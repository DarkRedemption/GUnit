# GUnit
GUnit is a Unit Testing framework for Garry's Mod based on [ScalaTest](http://www.scalatest.org/). It is compatible with all addons and gamemodes. It is named after other testing frameworks such as JUnit and NUnit, and [definitely not named after a rap group.](http://tvtropes.org/pmwiki/pmwiki.php/Main/SuspiciouslySpecificDenial)

## Warning
**DO NOT INSTALL GUNIT ON YOUR PRODUCTION SERVER UNLESS ABSOLUTELY NECESSARY. ONLY INSTALL IT ON YOUR TEST SERVER.** GUnit was designed assuming you wouldn't put it on your production server. A consequence of this is that you can paste your completed addon into your server without removing the tests for convenience. But if you have GUnit installed, that means those tests can be run. It is unlikely you want people running tests in the middle of a game, and unless you designed your tests to not interfere with the live code it can cause some seriously bad side effects.

The developer of GUnit is not responsible for what may happen if you put it on your production server.

## Getting Started

### Installation
Create a folder named "GUnit" in your GMod test server's addons directory, and place all the files from this project into it. Then, in your test server's `server.cfg` file, add the following line:

    sv_hibernate_think 1

This will make the server think/tick even when no one is in it. If the server isn't ticking, the hooks will not fire. If hooks do not fire, not only can hooks not be tested, but GUnit's hooks that are used to ensure the tests load properly won't work.

### Loading GUnit into your project
A test initialization file must be referenced by the core project in test. It should also be the last file loaded, and it is recommended for it to be placed into a folder called "test". This file should contain the following code:

    hook.Add("GUnitReady", "TestLoadHookNameHere", function()
        GUnit.load()
    end)

    if GUnit then
      GUnit.load()
    end

This code checks to see if GUnit is already loaded. If it is, it immediately starts loading the tests you have created. Otherwise, it waits for GUnit to send a message that it is ready, and then does so.

### Creating a test
To create a test, first, **create a new file in the same directory or in a subdirectory from the file where you called GUnit.load() and make sure its name ends with test.lua**. GUnit.load() will find this file for you and automatically load it, making it faster to create new test files and not have to deal with all of the `include` commands that come with it.

Now use the following function:

    local testname = "TestNameThatProbablyShouldntHaveSpacesAtThisTime"
    local test = GUnit.Test:new(testname)

The above creates what is known as a *test suite*. A test suite holds a list of tests, usually related to one another.

Spaces will (currently) interfere with test-only, discussed later. Avoid using spaces in the name.

Now, create functions that test specific parts of the class or function under test, which in GUnit are called `specs`. There are two ways to do this. The first is to define the function ahead of time, then dump it into `addSpec()`:

    local function myFirstTest()
      local multiplication = 2 * 2
      GUnit.assert(multiplication):shouldEqual(4)
    end

    test:addSpec("ensure two times two equals four", myFirstTest)

The use of GUnit.assert, above, is not necessary. The `assert` function that is baked into Lua may be used as well. The advantages of `GUnit.assert` are discussed under Advanced Features.

The second way to add a spec function is to simply define an anonymous function inside of `addSpec()` directly:

    test:addSpec("ensure two times two equals four", function()
        local multiplication = 2 * 2
        GUnit.assert(multiplication):shouldEqual(4)
      end
    )

When you've created your specs, type <code>test</code> in the server/web console. GUnit only lets you run tests from there--**you cannot run tests as a player at this time.**

### Loading your tests
The <code>GUnit.load()</code> function takes every file in the directory where it lives and every subdirectory and includes every file that ends with "test.lua". When GUnit has finished loading, it calls the <code>GUnitReady</code> hook so that your addon may load these files if it was not already loaded. If it is already loaded, such as when you have made changes to your addon, the if statement above will ensure those test files are reloaded. GUnit automatically clears and reloads the tests.

### Running your tests
Running your tests is simple. In the server console, simply type `test`. This will run all of the tests in every project where `GUnit.load()` has been called.

### Example Output
The output shown below is what happens if GUnit's tests are run:

![Output of tests from GUnit](http://i.imgur.com/VhVAs0Z.png)

The output also parallels ScalaTest WordSpecs in that after the name of every test, it is followed by the word "should" and then a description of the spec now running. This makes the output more readable as opposed to just listing test function names.

## Advanced Features

### The Assert Class (GUnit.assert)
GUnit comes with a custom `assert` class that not only allows you construct asserts expressively, but provides the dev with prepackaged assertion failed messages that help you troubleshoot your code.

The assert function that is baked into Lua forces you to define a custom message, lest you get a nigh-useless "Assertion Failed" message that doesn't tell you *why* it failed. GUnit.assert, on the other hand, has pre-made these custom assert messages, showing you the value and the type of the actual value and the expected value. For example:

    local test = GUnit.Test:new("WrongType")

    local function typeMismatchSpec()
      GUnit.assert(3):shouldEqual("3")
    end

    test:addSpec("find 3 equal to 3", typeMismatchSpec)

    --[[
    Output is:

    WrongType should:
    - find 3 equal to 3: *** FAILED ***
    Error was: addons/gunit/lua/gunit/main/testengine/sv_assertclass.lua:67:
    3 of type 'number' does not equal 3 of type 'string'
    ]]

GUnit's assert class caught that while they are the same value of `3`, they are not the same type: one is `3` represented as an integer, and the other is `3` represented as a string.

If we change the function to use a regular assert, the result is not informative:

    local function typeMismatchSpec()
        assert(3 == "3")
    end

    --[[
    Output is:
    - find 3 equal to 3: *** FAILED ***
    Error was: lua/../addons/gunit/lua/gunit/test/testengine/sv_assertdemotest.lua:4:
    assertion failed!
    ]]

#### Assert Chaining
Every matcher in the assert class returns `self`. This allows for chaining of commands without having to save it to a variable in order to avoid constructing it multiple times.

Consider a value that you want to check is within the range (0, 10). You could check for that with the assert class by typing:

    GUnit.assert(value):greaterThan(0):lessThan(10)

### BeforeAll/AfterAll and BeforeEach/AfterEach
Sometimes, you will need to perform some setup before you can execute a test. This setup may need to happen across all of your specs, such as when you are testing an SQL table and wish to clear it before the next spec in order to avoid interference from previous specs.

Just like ScalaTest, GUnit provides the BeforeAll, AfterAll, BeforeEach, and AfterEach functions.

BeforeAll is run before any spec is run in the test suite. Likewise, AfterAll is run after the test suite completes.

BeforeEach and AfterEach, on the other hand, run before and after *every* spec in the test suite.

Let's say you need to make a table before any spec runs in your Test Suite. You'd do something like this:

    local test = GUnit.Test:new("BeforeAllTest")

    local function beforeAll()
      sql.Query("CREATE TABLE testtable COLUMNS id INTEGER PRIMARY KEY value TEXT NOT NULL;")
    end

    test:beforeAll(beforeAll)
    --Actual specs below

The other before/after functions are applied in the exact same way `beforeAll()` was applied above.

### Test-only
If you have a significant number of tests, or a significant number of projects with their own tests, running the `test` command can start taking far more time than you would like. To get around this, GUnit comes with another testing command: `test-only`.

The `test-only` command allows you specify a project to test. Optionally, it lets you select a test inside that project to further lower the test runtime. This is extremely useful when you are actively working with one test and it's the only one giving you any problems.

The usage is:

    test-only <projectname> [testname]

where projectname is the name of the folder in your garrysmod/addons directory that the project lives in, and testname is the name you defined for your test with `GUnit.Test:new(testname)`

For instance, typing `test-only gunit` will run all the tests in GUnit. Typing `test-only gunit AssertClass` will run only the test named `AssertClass` in GUnit.

The project name is not case sensitive. The testname *is* case sensitive, but this will be changed.

### Pending
`GUnit.pending()` throws a special type of assert error that GUnit catches. This shows that your spec is not ready to be run yet, but you need to do it later. This is an excellent way to make to-do lists in your test code as you will see the pending spec every time GUnit attempts to run that spec.

There are two ways to invoke `pending`. The first is shown below:

    local function pendingSpec()
      GUnit.pending()
    end

    test:addSpec("complete this spec", pendingSpec)

If you don't want to make the function ahead of time, you can be more direct and use the second method:

    test:addSpec("complete this spec", GUnit.pending)

## License
GUnit is distributed under the MIT License, because dev tools should never be closed source.

# GUnit
GUnit is a Unit Testing framework for Garry's Mod addons, usable by all game types. It is somewhat based on the ScalaTest testing framework.

## Installation
Simply create a folder named "GUnit" in your GMod server's addons directory, and place all the files from this project into it.

## Loading GUnit into your project
A test initialization file must be referenced by the core project in test. It should also be the last file loaded, and it is recommended for it to be placed into a folder called "test".
This file should contain the following code:

    hook.Add("GUnitReady", "TestLoadHookNameHere", function()
        GUnit.load()
    end)
    
    if GUnit then
      GUnit.load()
    end

The <code>GUnit.load()</code> function takes every file in the directory where it lives and every subdirectory and includes every file that ends with "test.lua". When GUnit has finished loading, it calls the <code>GUnitReady</code> hook so that your addon may load these files if it was not already loaded. If it is already loaded, such as when you have made changes to your addon, the if statement above will ensure those test files are reloaded. GUnit automatically clears and reloads the tests.

## Creating a test
To create a test, use the following function:

    local testname = "Test name goes here. This should usually be the name of the class or function under test."
    local test = GUnit.Test:new(testname)

Now, create functions that test specific parts of the class or function under test, which in GUnit are called <code>specs</code>. There are two ways to do this. The first is the one I use personally.

    local function myFirstTest()
      local multiplication = 2 * 2
      assert(multiplication == 4)
    end
    
    test.addSpec("ensure two times two equals four", myFirstTest)
    
The second, in a way, is more like ScalaTest. However, due to Lua's nature, it's a bit uglier--but lets you put the spec in an anonymous function.

    test.addSpec("ensure two times two equals four", function()
        local multiplication = 2 * 2
        assert(multiplication == 4)
      end
    )

When you've created your test, type <code>test</code> in the server/web console. GUnit only lets you run tests from there--**you cannot run tests as a player at this time.**

## Example Output
Below is the output of a couple tests in my TTT Stats system, Dark's Dank Data.

![Output of tests from DDD](http://i.imgur.com/AcoRADz.png)

The output also parallels ScalaTest WordSpecs in that after the name of every test, it is followed by the word "should" and then a description of the spec now running. This makes the output more readable as opposed to just listing test function names.

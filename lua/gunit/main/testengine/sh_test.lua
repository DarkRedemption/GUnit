local Test = {}
local Colors = GUnit.Colors

local function defaultTest(testName)
  MsgC(Colors.yellow, testName .. ": No tests to run.\n")
end

--Returns the number of specs in the test.
function Test:size()
  local size = 0
  for specName, specFunction in pairs(self.specs) do
    size = size + 1
  end
  return size
end

--[[
Sets a function to be run immediately before the entire test suite is run.
If it fails, the entire test suite run is aborted.
PARAM func: => Nil - The function to run before every spec.
]]
function Test:beforeAll(func)
  self.beforeAllFunc = func
end

--[[
Sets a function to be run immediately before the entire test suite is run.
Always runs as long as beforeAll completed successfully (or doesn't exist.)
If it fails, nothing special happens except for it printing out the error.
PARAM func: => Nil - The function to run before every spec.
]]
function Test:afterAll(func)
  self.afterAllFunc = func
end

--[[
Sets a function to be run immediately before each spec is run.
If it fails, the run of the spec and afterEach is aborted, which will probably abort the entire test suite.
PARAM func: => Nil - The function to run before a spec.
]]
function Test:beforeEach(func)
  self.beforeEachFunc = func
end

--[[
Sets a function to be run immediately after each spec is run.
Runs even if a spec fails, but not if beforeEach fails, 
as afterEach is usually used to tear down the setup created by beforeEach.
PARAM func: => Nil - The function to run after a spec.
]]
function Test:afterEach(func)
  self.afterEachFunc = func
end

--[[
Adds a spec to the test.
A spec (short for specification) is a subtest that tests one specific element of your code
that is related to the overall test. Usually, it is used to test a single behavior of a class.
PARAM specName:String - The name of the spec.
PARAM specFunction: => Nil -  The spec function to run.
]]
function Test:addSpec(specName, specFunction)
  self.specs[specName] = specFunction
  table.insert(self.indexedSpecs, specName)
end

--Finds the name of the addon directory.
function Test.findProjectName()
  local workingDirectory = debug.getinfo(3, "S").source:sub(2)
  local path = workingDirectory:match("(.*/)")
  local directories = path:split("/")
  return directories[4]
end

local function runBeforeAll(test)
  local passed, errorMessage = xpcall(test.beforeAllFunc, debug.traceback)
  if (!passed) then
    MsgC(Colors.red, "- " .. test.name .. ": *** ABORTED - BEFOREALL FAILED ***\nError was: " .. errorMessage)
    print("") --Forces a newline because appending /n to the errorMessage doesn't work for whatever reason.
  end
  return passed
end

local function runAfterAll(test)
  local passed, errorMessage = xpcall(test.afterAllFunc, debug.traceback)
  if (!passed) then
    MsgC(Colors.red, "- " .. test.name .. " AfterAll: *** FAILED ***\nError was: " .. errorMessage)
    print("") --Forces a newline because appending /n to the errorMessage doesn't work for whatever reason.
  end
end

local function runTestFunc(specName, func)
  local passed, errorMessage = xpcall(func, debug.traceback)
  return GUnit.Result:new(specName, passed, errorMessage)
end

local function runSpec(testSuite, specName, specFunction)
  local beforeEachResult 
  local specResult
  local afterEachResult 
  
  beforeEachResult = runTestFunc(specName, testSuite.beforeEachFunc)
  
  --If nothing went wrong in the beforeEachResult, run the spec and its afterEach.
  if (beforeEachResult.passed) then
    specResult = runTestFunc(specName, specFunction)
    afterEachResult = runTestFunc(specName, testSuite.afterEachFunc)
  else
    --Something went wrong so don't run anything else.
    return beforeEachResult
  end

  if (!specResult.passed) then
    --It broke before getting to afterEach so we only care about the spec's result.
    return specResult
  else 
    --It got through the spec but that doesn't mean it got through the afterEach. Return afterEach's result.
    return afterEachResult
  end
end

function Test:runSpecs()
  local results = {}
  
  if self:size() == 0 then
    defaultTest(self.name)
  else
    MsgC(Colors.white, self.name .. " should:\n")
    if (runBeforeAll(self)) then
      for index, specName in pairs(self.indexedSpecs) do
        --Mark when the latest spec has been run
        GUnit.timestamp = os.time()
        results[specName] = runSpec(self, specName, self.specs[specName])
        results[specName]:print()
      end
      runAfterAll(self)
    end
  end
  
  return results
end

local function findAddonDirectories()
  local files, directories = file.Find("addons/*", "MOD")
  return directories
end

local function addProjectNameToTable(testType, test)
  --If the testType does not exist, or it does exist and it matches it being a SERVER or CLIENT
  if (testType == nil || testType) then
    if (GUnit.Tests[test.projectName] == nil) then
      GUnit.Tests[test.projectName] = {}
    end
  end
end

local function addTestToTable(testType, test)
  if (testType == nil || testType) then
    assert(GUnit.Tests[test.projectName][test.name] == nil,
      "Testname " .. test.name .. " already exist for project " .. test.projectName) 
    GUnit.Tests[test.projectName][test.name] = test
  end
end

--[[
Creates a test and instantly adds it to GUnit's list of tests to run.
PARAM name:String - The name of the test.
]]
function Test:new(name, testType)
  local newTest = {}
  setmetatable(newTest, self)
  self.__index = self
  newTest.name = name
  newTest.specs = {}
  newTest.indexedSpecs = {}
  newTest.beforeAllFunc = function() end
  newTest.afterAllFunc = function() end
  newTest.beforeEachFunc = function() end
  newTest.afterEachFunc = function() end
  newTest.projectName = self.findProjectName()
  newTest.testType = testType
  addProjectNameToTable(testType, newTest)
  addTestToTable(testType, newTest)
  return newTest
end

--findTests()
GUnit.Test = Test
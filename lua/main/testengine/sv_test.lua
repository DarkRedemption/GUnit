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
Adds a spec to the test.
A spec (short for specification) is a subtest that tests one specific element of your code
that is related to the overall test. Usually, it is used to test a single behavior of a class.
PARAM specName:String - The name of the spec.
PARAM specFunction:Nil => Nil -  The spec function to run.
]]
function Test:addSpec(specName, specFunction)
  self.specs[specName] = specFunction
end

-- Finds the name of the addon directory.
local function findProjectName()
  local workingDirectory = debug.getinfo(3, "S").source:sub(2)
  local path = workingDirectory:match("(.*/)")
  local directories = path:split("/")
  return directories[4]
end

function Test:runSpecs()
  local results = {}
  
  if self:size() == 0 then
    defaultTest(self.name)
  else
    MsgC(Colors.lightBlue, "\n" .. self.name .. " should:\n")
    
    for specName, specFunction in pairs(self.specs) do
      MsgC(Colors.lightBlue, specName .. "\n")
      --Mark when the latest spec has been run
      GUnit.timestamp = os.time()
      local passed, errorMessage = pcall(specFunction)
      results[specName] = GUnit.Result:new(specName, passed, errorMessage)
    end
  end
  
  return results
end

local function findAddonDirectories()
  local files, directories = file.Find("addons/*", "MOD")
  return directories
end

local function addProjectNameToTable(test)
  if (GUnit.Tests[test.projectName] == nil) then
    GUnit.Tests[test.projectName] = {}
  end
end

local function addTestToTable(test)
  assert(GUnit.Tests[test.projectName][test.name] == nil,
    "Testname " .. test.name .. " already exist for project " .. test.projectName) 
  GUnit.Tests[test.projectName][test.name] = test
end

--Creates a test and instantly adds it to GUnit's list of tests to run.
--PARAM name:String - The name of the test.
function Test:new(name)
  local newTest = {}
  setmetatable(newTest, self)
  self.__index = self
  newTest.name = name
  newTest.specs = {}
  newTest.projectName = findProjectName()
  addProjectNameToTable(newTest)
  addTestToTable(newTest)
  return newTest
end

--findTests()
GUnit.Test = Test
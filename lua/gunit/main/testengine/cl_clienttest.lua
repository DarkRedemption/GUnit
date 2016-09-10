local clientTest = table.Copy(GUnit.Test)

function clientTest:new(name)
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
  newTest.testType = CLIENT
  self:addProjectNameToTable(CLIENT, newTest)
  self:addTestToTable(CLIENT, newTest)
  return newTest
end
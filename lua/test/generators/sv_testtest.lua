local test = GUnit.Test:new("Test class")

local testValue = ""

test:beforeEach(function()
    assert(testValue == "")
    test.generatedBeforeValue = GUnit.Generators.StringGen.generateAlphaNum()
    testValue = test.generatedBeforeValue
  end)

test:afterEach(function()
    testValue = ""
  end)

local function beforeAfterEachTest()
  assert(testValue == test.generatedBeforeValue)
end

test:addSpec("modify a value before the test starts", beforeAfterEachTest)
test:addSpec("be sure that the value was reset, then run again", beforeAfterEachTest)
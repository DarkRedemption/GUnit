local test = GUnit.Test:new("Test class")

local eachTestValue = ""
local allTestValue = ""

test:beforeAll(function()
    --Make sure it got reset in case this is the second time running
    assert(allTestValue == "")
    assert(test.generatedBeforeAllValue == nil)
    test.generatedBeforeAllValue = GUnit.Generators.StringGen.generateAlphaNum()
    allTestValue = ""
  end)

test:afterAll(function()
    allTestValue = ""
    test.generatedBeforeAllValue = nil
  end)

test:beforeEach(function()
    --Make sure it got reset for the second time running
    assert(eachTestValue == "")
    assert(test.generatedBeforeEachValue == nil)
    test.generatedBeforeEachValue = GUnit.Generators.StringGen.generateAlphaNum()
    eachTestValue = test.generatedBeforeEachValue
  end)

test:afterEach(function()
    eachTestValue = ""
    test.generatedBeforeEachValue = nil
  end)

local function beforeAfterAllTest()
  assert(allTestValue == test.generatedBeforeEachValue)
end

local function beforeAfterEachTest()
  assert(eachTestValue == test.generatedBeforeEachValue)
end

test:addSpec("modify a value before any test starts (manually run this test twice to be sure it works)", beforeAfterAllTest)
test:addSpec("modify a value before a spec starts", beforeAfterEachTest)
test:addSpec("be sure that the value was reset, then run again", beforeAfterEachTest)

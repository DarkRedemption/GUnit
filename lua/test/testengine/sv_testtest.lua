local test = GUnit.Test:new("Test class")

local eachTestValue = ""
local allTestValue = ""

test:beforeAll(function()
    --Make sure it got reset in case this is the second time running
    assert(allTestValue == "")
    assert(test.generatedBeforeAllValue == nil)
    allTestValue = GUnit.Generators.StringGen.generateAlphaNum()
    test.generatedBeforeAllValue = allTestValue
  end)

test:afterAll(function()
    allTestValue = ""
    test.generatedBeforeAllValue = nil
  end)

test:beforeEach(function()
    --Make sure it got reset for the second time running
    assert(eachTestValue == "")
    assert(test.generatedBeforeEachValue == nil)
    eachTestValue = GUnit.Generators.StringGen.generateAlphaNum()
    test.generatedBeforeEachValue = eachTestValue
  end)

test:afterEach(function()
    eachTestValue = ""
    test.generatedBeforeEachValue = nil
  end)

local function beforeAfterAllTest()
  assert(allTestValue == test.generatedBeforeAllValue)
end

local function beforeAfterEachTest()
  assert(eachTestValue == test.generatedBeforeEachValue)
end

test:addSpec("modify a value before any test starts (manually run this test twice to be sure it works)", beforeAfterAllTest)
test:addSpec("modify a value before a spec starts", beforeAfterEachTest)
test:addSpec("be sure that the value was reset, then run again", beforeAfterEachTest)

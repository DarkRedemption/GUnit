local assertClassTest = GUnit.Test:new("AssertClass")

local function shouldEqualIntegerSpec()
  for i = 1, 100 do
    local randomNumber = math.random(1, 100000)
    GUnit.assert(randomNumber):shouldEqual(randomNumber)
  end
end

local function shouldEqualStringSpec()
  for i = 1, 100 do
    local randomString = GUnit.Generators.StringGen.generateAlphaNum()
    GUnit.assert(randomString):shouldEqual(randomString)
  end
end

local function lessThanIntSpec()
  for i = 1, 100 do
    local randomNumber = math.random(-100000, 100000)
    GUnit.assert(randomNumber - 1):lessThan(randomNumber)
  end
end

local function lessThanFloatSpec()
  for i = 1, 100 do
    local randomNumber = math.random(-100000.0, 100000.0)
    GUnit.assert(randomNumber - 1.0):lessThan(randomNumber)
  end
end

local function lessThanOrEqualToIntSpec()
  for i = 1, 100 do
    local randomNumber = math.random(-100000, 100000)
    local subtraction = math.random(0, 10)
    GUnit.assert(randomNumber - subtraction):lessThanOrEqualTo(randomNumber)
  end
end

local function lessThanOrEqualToFloatSpec()
  for i = 1, 100 do
    local randomNumber = math.random(-100000.0, 100000.0)
    local subtraction = math.random(0.0, 10.0)
    GUnit.assert(randomNumber - subtraction):lessThanOrEqualTo(randomNumber)
  end
end

local function greaterThanIntSpec()
   for i = 1, 100 do
    local randomNumber = math.random(-100000, 100000)
    local addition = math.random(1, 10)
    GUnit.assert(randomNumber + addition):greaterThan(randomNumber)
  end
end

local function greaterThanFloatSpec()
  for i = 1, 100 do
    local randomNumber = math.random(-100000.0, 100000.0)
    local addition = math.random(1.0, 10.0)
    GUnit.assert(randomNumber + addition):greaterThan(randomNumber)
  end
end

local function greaterThanOrEqualToIntSpec()
  for i = 1, 100 do
    local randomNumber = math.random(-100000, 100000)
    local addition = math.random(1, 10)
    GUnit.assert(randomNumber + addition):greaterThan(randomNumber)
  end
end

local function greaterThanOrEqualToFloatSpec()
  for i = 1, 100 do
    local randomNumber = math.random(-100000.0, 100000.0)
    local addition = math.random(1.0, 10.0)
    GUnit.assert(randomNumber + addition):greaterThan(randomNumber)
  end
end

local function isTrueSpec()
  GUnit.assert(true):isTrue()
end

local function isFalseSpec()
  GUnit.assert(false):isFalse()
end

local function chainedAssertSpec()
  for i = 1, 100 do
    local randomNumber = math.random(-100000.0, 100000.0)
    GUnit.assert(randomNumber):shouldEqual(randomNumber):
    greaterThanOrEqualTo(randomNumber):
    lessThanOrEqualTo(randomNumber)
  end
end

assertClassTest:addSpec("perform shouldEqual properly with integers", shouldEqualIntegerSpec)
assertClassTest:addSpec("perform shouldEqual properly with strings", shouldEqualStringSpec)
assertClassTest:addSpec("perform lessThan properly with integers", lessThanIntSpec)
assertClassTest:addSpec("perform lessThan properly with floats", lessThanFloatSpec)
assertClassTest:addSpec("perform lessThanOrEqualTo properly with integers", lessThanOrEqualToIntSpec)
assertClassTest:addSpec("perform lessThanOrEqualTo properly with floats", lessThanOrEqualToFloatSpec)
assertClassTest:addSpec("perform greaterThan properly with integers", greaterThanIntSpec)
assertClassTest:addSpec("perform greaterThan properly with floats", greaterThanFloatSpec)
assertClassTest:addSpec("perform greaterThanOrEqualTo properly with integers", greaterThanOrEqualToIntSpec)
assertClassTest:addSpec("perform greaterThanOrEqualTo properly with floats", greaterThanOrEqualToFloatSpec)
assertClassTest:addSpec("perform isTrue properly", isTrueSpec)
assertClassTest:addSpec("perform isFalse properly", isFalseSpec)
assertClassTest:addSpec("chain together some asserts", chainedAssertSpec)
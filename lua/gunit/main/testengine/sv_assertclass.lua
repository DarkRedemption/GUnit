local assertClass = {}
assertClass.__index = assertClass

function assertClass:isAssertClass()
  return true
end

function assertClass:new(funcOrValue, args)
  local newAssertClass = {}
  setmetatable(newAssertClass, self)
  newAssertClass.funcOrValue = funcOrValue
  if args then
    newAssertClass.args = args
  end
  return newAssertClass
end

local function checkForSelf(s)
  assert(s.isAssertClass != nil, "self variable not found. You need to call this function with a colon (:) and not a dot (.).")
end

function assertClass:isNil()
  checkForSelf(self)
  assert(self.funcOrValue == nil, "Expected nil, got " .. tostring(funcOrValue) .. " of type '" .. type(self.funcOrValue) .. "'")
  return self
end

function assertClass:isNotNil()
  checkForSelf(self)
  assert(self.funcOrValue != nil, "Value was nil, expected a non-nil value")
  return self
end

function assertClass:isType(typename)
  checkForSelf(self)
  assert(type(self.funcOrValue) == typename, 
    tostring(self.funcOrValue) .. " is not of type '" .. typename ..
    "'. It is of type '" .. type(self.funcOrValue) .. "'.")
  return self
end

function assertClass:isTrue()
  checkForSelf(self)
  self:isType("boolean")
  assert(self.funcOrValue, "Boolean was not true.")
  return self
end

function assertClass:isFalse()
  checkForSelf(self)
  self:isType("boolean")
  assert(!self.funcOrValue, "Boolean was not false.")
  return self
end

--[[
Checks a function or value for equality.
PARAM otherFuncOrValue:Any - The function or value to compare the item already in the assertClass with.
PARAM customErrorMsg:Nil or String - The error message to display if this assert fails. Uses a default one otherwise.
]]
function assertClass:shouldEqual(otherFuncOrValue, customErrorMsg)
  --If otherFuncOrValue is not defined, 'self' might be otherFuncOrValue due to how : works
  checkForSelf(self)
  local defaultErrorMsg = tostring(self.funcOrValue) .. " of type '" .. type(self.funcOrValue) .. 
    "' does not equal " .. tostring(otherFuncOrValue) .. " of type '" .. type(otherFuncOrValue) .. "'"
  local msg = customErrorMsg or defaultErrorMsg
  assert(self.funcOrValue == otherFuncOrValue, msg)
  return self
end

--[[
Checks a function or value for inequality.
PARAM otherFuncOrValue:Any - The function or value to compare the item already in the assertClass with.
PARAM customErrorMsg:Nil or String - The error message to display if this assert fails. Uses a default one otherwise.
]]
function assertClass:shouldNotEqual(otherFuncOrValue, customErrorMsg)
  --If otherFuncOrValue is not defined, 'self' might be otherFuncOrValue due to how : works
  checkForSelf(self)
  local defaultErrorMsg = tostring(self.funcOrValue) .. " of type '" .. type(self.funcOrValue) .. 
    "' is equal to " .. tostring(otherFuncOrValue) .. " of type '" .. type(otherFuncOrValue) .. "'"
  local msg = customErrorMsg or defaultErrorMsg
  assert(self.funcOrValue != otherFuncOrValue, msg)
  return self
end

function assertClass:lessThan(otherValue)
  checkForSelf(self)
  assert(self.funcOrValue < otherValue, 
    tostring(self.funcOrValue) .. " of type '" .. type(self.funcOrValue) ..
    "' was not less than " .. tostring(otherValue) .. " of type '" .. type(otherValue) .. "'")
  return self
end

function assertClass:lessThanOrEqualTo(otherValue)
  checkForSelf(self)
  assert(self.funcOrValue <= otherValue, 
    tostring(self.funcOrValue) .. " of type '" .. type(self.funcOrValue) ..
    "' was not less than or equal to" .. tostring(otherValue) .. " of type '" .. type(otherValue) .. "'")
  return self
end

function assertClass:greaterThan(otherValue)
  checkForSelf(self)
  assert(self.funcOrValue > otherValue, 
    tostring(self.funcOrValue) .. " of type '" .. type(self.funcOrValue) ..
    "' was not greater than " .. tostring(otherValue) .. " of type '" .. type(otherValue) .. "'")
  return self
end

function assertClass:greaterThanOrEqualTo(otherValue)
  checkForSelf(self)
  assert(self.funcOrValue >= otherValue, 
    tostring(self.funcOrValue) .. " of type '" .. type(self.funcOrValue) ..
    "' was not greater than or equal to " .. tostring(otherValue) .. " of type '" .. type(otherValue) .. "'")
  return self
end

function assertClass:shouldFail(printError)
  assert(type(self.funcOrValue) == "function", 
    "shouldFail is for functions. " .. tostring(self.funcOrValue) .. " is not a function.")
  
  local successful
  local err
  if (self.args == nil) then
    successful, err = pcall(func)
  else
    print("Got args.")
    successful, err = pcall(func, unpack(args))
  end
  assert(!successful, "Function did not fail.")
  if printError then
    print(err)
  end
  return self
end

function GUnit.assert(funcOrValue, ...)
  if (args != nil) then
    --PrintTable(args)
  end
  return assertClass:new(funcOrValue, args)
end

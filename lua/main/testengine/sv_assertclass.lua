local assertClass = {}
assertClass.__index = assertClass

function assertClass:new(funcOrValue, args)
  local newAssertClass = {}
  setmetatable(newAssertClass, self)
  newAssertClass.funcOrValue = funcOrValue
  if args then
    newAssertClass.args = args
  end
  return newAssertClass
end

--TODO: Make this work with other functions that have additional parameters.
local function checkForSelf(s)
  assert(s != nil, "self variable not found. You need to call this function with a colon (:) and not a dot (.).")
end

function assertClass:isNil()
  checkForSelf(self)
  assert(self.funcOrValue == nil, "Expected nil, got " .. tostring(funcOrValue) .. " of type " .. type(self.funcOrValue))
end

function assertClass:isNotNil()
  checkForSelf(self)
  assert(self.funcOrValue != nil, "Value was nil, expected a non-nil value")
end

function assertClass:isType(typename)
  checkForSelf(self)
  assert(type(self.funcOrValue) == typename, 
    tostring(self.funcOrValue) .. " is not of type '" .. typename ..
    "'. It is of type '" .. type(self.funcOrValue) .. "'.")
end

function assertClass:isTrue()
  checkForSelf(self)
  self:isType("boolean")
  assert(self.funcOrValue, "Boolean was not true.")
end

function assertClass:isFalse()
  checkForSelf(self)
  self:isType("boolean")
  assert(self.funcOrValue, "Boolean was not false.")
end


--[[
Checks a function or value for equality.
PARAM otherFuncOrValue:Any - The function or value to compare the item already in the assertClass with.
PARAM customErrorMsg:Nil or String - The error message to display if this assert fails. Uses a default one otherwise.
]]
function assertClass:shouldEqual(otherFuncOrValue, customErrorMsg)
  --If otherFuncOrValue is not defined, 'self' might be otherFuncOrValue due to how : works
  checkForSelf(otherFuncOrValue)
  local defaultErrorMsg = tostring(self.funcOrValue) .. " of type '" .. type(self.funcOrValue) .. 
    "' does not equal " .. tostring(otherFuncOrValue) .. " of type " .. type(otherFuncOrValue)
  local msg = customErrorMsg or defaultErrorMsg
  assert(self.funcOrValue == otherFuncOrValue, msg)
end

--[[
Checks a function or value for inequality.
PARAM otherFuncOrValue:Any - The function or value to compare the item already in the assertClass with.
PARAM customErrorMsg:Nil or String - The error message to display if this assert fails. Uses a default one otherwise.
]]
function assertClass:shouldNotEqual(otherFuncOrValue, customErrorMsg)
  --If otherFuncOrValue is not defined, 'self' might be otherFuncOrValue due to how : works
  checkForSelf(otherFuncOrValue)
  local defaultErrorMsg = tostring(self.funcOrValue) .. " of type '" .. type(self.funcOrValue) .. 
    "' is equal to " .. tostring(otherFuncOrValue) .. " of type " .. type(otherFuncOrValue)
  local msg = customErrorMsg or defaultErrorMsg
  assert(self.funcOrValue != otherFuncOrValue, msg)
end


function assertClass:lessThan(otherValue)
  checkForSelf(otherValue)
  assert(self.funcOrValue < otherValue, 
    tostring(self.funcOrValue) .. " of type " .. type(self.funcOrValue) ..
    " was not less than " .. tostring(otherValue) .. " of type " .. type(otherValue))
end

function assertClass:greaterThan(otherValue)
  checkForSelf(otherValue)
  assert(self.funcOrValue > otherValue, 
    tostring(self.funcOrValue) .. " of type " .. type(self.funcOrValue) ..
    " was not greater than " .. tostring(otherValue) .. " of type " .. type(otherValue))
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
end

function GUnit.assert(funcOrValue, ...)
  if (args != nil) then
    PrintTable(args)
  end
  return assertClass:new(funcOrValue, args)
end

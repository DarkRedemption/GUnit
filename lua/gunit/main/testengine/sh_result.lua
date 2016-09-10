local Colors = GUnit.Colors

local Result = {}

function Result:print()
  if (self.passed) then
    MsgC(Colors.green, "+ " .. self.specName .. "\n")
  elseif (self:isPending()) then
    MsgC(Colors.yellow, "* " .. self.specName .. ": * PENDING *\n")
  else
    MsgC(Colors.red, "- " .. self.specName .. ": *** FAILED ***\nError was: " .. self.errorMessage)
    --Force a newline because appending /n to the errorMessage doesn't work for whatever reason.
    --It's probably running out of characters it can hold.
    print("") 
  end
end

function Result:isPending()
  return string.match(self.errorMessage, GUnit.pendingCode) == GUnit.pendingCode
end

--[[
Holds the result for a spec.
Parameters:
specName: String - The name of the spec in the Test class that ran.
passed: Boolean - Whether or not the spec passed. If nil, autoconverts to false.
errorMessage: [String, Nil] - A string containing the error if failed. Nil otherwise.
]]
function Result:new(specName, passed, errorMessage)
  local newResult = {}
  setmetatable(newResult, self)
  self.__index = self
  
  newResult.specName = specName
  newResult.passed = passed or false
  newResult.errorMessage = errorMessage

  return newResult
end

GUnit.Result = Result
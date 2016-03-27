local stringGenerator = {}

--[[
Generates an alphanumeric string of a specified length. Default length range is [1, 128].
]]
function stringGenerator.generateAlphaNum(minSize, maxSize)
  minSize = minSize or 1
  maxSize = maxSize or 128
  assert(minSize <= maxSize, "The minimum size MUST be less than or equal to the maximum size.")
  
  local function getNewChar(charType)
    local num = 0
    if (charType == 0) then --Num
     num = math.random(48, 57)
    elseif (charType == 1) then --Uppercase character
     num = math.random(65, 90)
    elseif (charType == 2) then --Lowercase character
     num = math.random(97, 122)
    end
    return string.char(num)
  end

  local function gen(str, currentSize, maxSize)
    if (currentSize >= maxSize) then return str end
    local charType = math.random(0, 2)
    local newChar = getNewChar(charType)
    return gen(str .. newChar, currentSize + 1, maxSize)
  end
  
  local size = math.random(minSize, maxSize)
  
  return gen("", 0, size)
end

GUnit.Generators.StringGen = stringGenerator
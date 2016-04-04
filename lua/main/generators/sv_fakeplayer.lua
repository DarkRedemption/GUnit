--[[
Creates a fake player class. Generally for database testing purposes.
Currently only makes fake SteamIds since that's the way you tend to look them up in a database,
as well as generating player roles for TTT.
Features and configurations to be added as requested/personally needed.
]]

local fakePlayer = {}
fakePlayer.__index = fakePlayer

function fakePlayer:GetClass()
  return "player"
end

--[[
Returns the player's role as an integer ID.
Currently configured to be compatible with TTT only,
as the role ID that is automatically generated is between 0 and 2.
]]
function fakePlayer:GetRole()
  return self.role
end

--[[
Generates a table containing the SteamID along with all of its components as separate values.
SteamID compositions are described at https://developer.valvesoftware.com/wiki/SteamID
]]
local function generateSteamIdInfo()
  --TODO (maybe): Force universe/account values to always be values a user can actually have,
  --as opposed to the entire range of valid values. May not matter for testing.
  local steamIdInfo = {}
  steamIdInfo.universe = math.random(0, 4)
  steamIdInfo.accountType = math.random(0, 10)
  steamIdInfo.accountId = math.random(0, 2147483647) --0 to INT32_MAX
  return steamIdInfo
end

function fakePlayer:SteamID()
  local universe = self.steamIdInfo.universe
  local smallestBit = self.steamIdInfo.accountId % 2
  local highestBits = bit.rshift(self.steamIdInfo.accountId, 1)
  local steamId = "STEAM_" .. universe .. ":" .. smallestBit .. ":" .. highestBits
  return steamId
end

function fakePlayer:SteamID64()
  error("Not yet implemented.")
end

function fakePlayer:new()
  local newFakePlayer = {}
  setmetatable(newFakePlayer, self)
  newFakePlayer.role = math.random(0, 2)
  newFakePlayer.steamIdInfo = generateSteamIdInfo()
  return newFakePlayer
end

GUnit.Generators.FakePlayer = fakePlayer
--Creates a fake player class. Generally for database testing purposes.
--Currently only makes fake SteamIds since that's the way you tend to look them up in a database.
--Features to be added as requested/personally needed.

local fakePlayer = {}
fakePlayer.__index = fakePlayer

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
  newFakePlayer.steamIdInfo = generateSteamIdInfo()
  return newFakePlayer
end

GUnit.Generators.FakePlayer = fakePlayer
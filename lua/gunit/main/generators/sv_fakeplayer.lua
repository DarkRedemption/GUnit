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

function fakePlayer:GetName()
  return self.name
end

function fakePlayer:SetName(name)
  self.name = name
end

function fakePlayer:IsPlayer()
  return true
end

--[[
Returns the player's role as an integer ID.
GetRole() is only found in the Player class in TTT to my knowledge.
]]
function fakePlayer:GetRole()
  return self.role
end

function fakePlayer:IsTerror()
  return self.role == 1
end

function fakePlayer:SetRole(roleInt)
  self.role = roleInt
end

function fakePlayer:GetNWBool(boolName, default)
  return self.nwBools[boolName] or default
end

function fakePlayer:SetNWBool(boolName, value)
  GUnit.assert(value):isType("boolean")
  self.nwBools[boolName] = value
end

function fakePlayer:GetActiveWeapon()
  return self.activeWeapon
end


function fakePlayer:SetActiveWeapon(wep)
  self.activeWeapon = wep
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

function fakePlayer:getHighestIdBits()
  return bit.rshift(self.steamIdInfo.accountId, 1)
end

function fakePlayer:SteamID()
  local universe = self.steamIdInfo.universe
  local smallestBit = self.steamIdInfo.accountId % 2
  local highestBits = self:getHighestIdBits()
  local steamId = "STEAM_" .. universe .. ":" .. smallestBit .. ":" .. highestBits
  return steamId
end

function fakePlayer:SteamID64()
  error("Not yet implemented.")
end

--Unique IDs are a transform of the SteamID in an unknown way.
--Since it's unknown, I'm just going to add a large number to the highest bits.
--Should be just fine for testing purposes since it's still just a large int.
function fakePlayer:UniqueID()
  return self:getHighestIdBits() + 15000000
end

function fakePlayer:IsUserGroup(groupName)
  return self.userGroup == groupName
end

function fakePlayer:SetUserGroup(groupName)
  self.userGroup = groupName
end

function fakePlayer:IsBot()
  return self:SteamID() == "BOT"
end

function fakePlayer:new()
  local newFakePlayer = {}
  setmetatable(newFakePlayer, self)
  newFakePlayer.role = math.random(0, 2)
  newFakePlayer.steamIdInfo = generateSteamIdInfo()
  newFakePlayer.name = GUnit.Generators.StringGen.generateAlphaNum()
  newFakePlayer.nwBools = {}
  newFakePlayer.activeWeapon = GUnit.Generators.FakeEntity:new()
  newFakePlayer.userGroup = "user"
  return newFakePlayer
end

GUnit.Generators.FakePlayer = fakePlayer
--Generates fake damage information for testing.
--Currently only supports GetDamage(). More to be added as needed.
local fakeCTakeDamageInfo = {}
fakeCTakeDamageInfo.__index = fakeCTakeDamageInfo

function fakeCTakeDamageInfo:GetAttacker()
  return self.attacker
end

function fakeCTakeDamageInfo:GetDamage()
  return self.damage
end

function fakeCTakeDamageInfo:GetDamageType()
  return self.damageType
end

function fakeCTakeDamageInfo:GetInflictor()
  return self.inflictor
end

function fakeCTakeDamageInfo:SetAttacker(entity)
  self.attacker = entity
end

function fakeCTakeDamageInfo:SetDamage(damage)
  self.damage = damage
end

--[[
PARAM damageType:Integer - The type(s) of damage.
]]
function fakeCTakeDamageInfo:SetDamageType(damageType)
  self.damageType = damageType 
end

function fakeCTakeDamageInfo:SetInflictor(entity)
  self.inflictor = entity
end

function fakeCTakeDamageInfo:IsDamageType(damageType)
  return bit.band(damageType, self.damageType) == damageType
end

function fakeCTakeDamageInfo:IsFallDamage()
  return bit.band(DMG_FALL, self.damageType) == DMG_FALL
end

function fakeCTakeDamageInfo:new()
  local newDamage = {}
  setmetatable(newDamage, self)
  newDamage.damage = math.random(1, 100)
  newDamage.damageType = 0
  return newDamage
end

GUnit.Generators.CTakeDamageInfo = fakeCTakeDamageInfo
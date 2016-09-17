local fakeEntity = {}
fakeEntity.__index = fakeEntity

function fakeEntity:GetClass()
  return self.classname
end

function fakeEntity:GetNWBool(boolName, default)
  return self.nwBools[boolName] or default
end

function fakeEntity:SetNWBool(boolName, value)
  GUnit.assert(value):isType("boolean")
  self.nwBools[boolName] = value
end

function fakeEntity:GetNWString(stringName, default)
  return self.nwStrings[stringName] or default
end

function fakeEntity:SetNWString(stringName, value)
  GUnit.assert(value):isType("string")
  self.nwStrings[stringName] = value
end

function fakeEntity:IsValid()
  return true
end

function fakeEntity:IsWeapon()
  return self.isWeapon
end

function fakeEntity:SetIsWeapon(bool)
  assert(type(bool) == "boolean")
  self.isWeapon = bool
end

function fakeEntity:new()
  local newEntity = {}
  setmetatable(newEntity, self)
  newEntity.classname = GUnit.Generators.StringGen.generateAlphaNum()
  newEntity.nwBools = {}
  newEntity.nwStrings = {}
  newEntity.isWeapon = false
  return newEntity
end


GUnit.Generators.FakeEntity = fakeEntity

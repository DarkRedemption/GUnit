local fakeEntity = {}
fakeEntity.__index = fakeEntity

function fakeEntity:GetClass()
  return self.classname
end

function fakeEntity:new()
  local newEntity = {}
  setmetatable(newEntity, self)
  newEntity.classname = GUnit.Generators.StringGen.generateAlphaNum()
  return newEntity
end

GUnit.Generators.FakeEntity = fakeEntity

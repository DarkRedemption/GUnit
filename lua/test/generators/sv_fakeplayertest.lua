local playerMockTest = GUnit.Test:new("FakePlayer")
local playerGen = GUnit.Generators.FakePlayer

local function generateTest()
  for i = 1, 100 do
    playerGen:new()
  end
end

local function steamIdTest()
  for i = 1, 100 do
   local ply = playerGen:new()
   assert(ply:SteamID(), "SteamID was nil.")
  end
end

local function saneSteamIdTest()
  for i = 1, 100 do
   local ply = playerGen:new()
   assert(ply:SteamID() == ply:SteamID())
  end
end

local function roleTest()
  for i = 1, 100 do
    local player = playerGen:new()
    local role = player:GetRole()
    GUnit.assert(role):isNotNil()
  end
end

playerMockTest:addSpec("not break on creation", generateTest)
playerMockTest:addSpec("have non-nil SteamIDs", steamIdTest)
playerMockTest:addSpec("always generate the same SteamID", saneSteamIdTest)
playerMockTest:addSpec("return a role with GetRole()", roleTest) 
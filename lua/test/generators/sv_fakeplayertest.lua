local playerMockTest = GUnit.Test:new("Fake Player")

local function generateTest()
  for i = 1, 100 do
    GUnit.Generators.FakePlayer:new()
  end
end

local function steamIdTest()
  for i = 1, 100 do
   local ply = GUnit.Generators.FakePlayer:new()
   assert(ply:SteamID(), "SteamID was nil.")
  end
end

playerMockTest:addSpec("not break on creation", generateTest)
playerMockTest:addSpec("have non-nil SteamIDs", steamIdTest)
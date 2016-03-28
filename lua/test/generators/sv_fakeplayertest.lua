local playerMockTest = GUnit.Test:new("Fake Player")

local function generateTest()
  for i = 1, 100 do
    GUnit.Generators.FakePlayer:new()
  end
end

playerMockTest:addSpec("not break on creation", generateTest)
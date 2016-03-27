--Creates a mock player class. Generally for database testing purposes.
--Currently only makes fake SteamIds since that's the way you tend to look them up in a database.
--Features to be added as requested/personally needed.

local playerMock = {}

function playerMock:new()
  local newPlayerMock = {}
  setmetatable(newPlayerMock, self)
  return newPlayerMock
end
-- Initializes GUnit and loads the files in the proper order.

GUnit = {}
GUnit.Tests = {}
GUnit.Colors = {}

local enableTests = true

if (SERVER and enableTests) then
  include("main/global/sv_stringsplit.lua")
  include("main/testengine/sv_servertimer.lua")
  include("main/testengine/sv_colors.lua")
  include("main/testengine/sv_main.lua")
  include("main/testengine/sv_result.lua") 
  include("main/testengine/sv_test.lua")
  include("main/testengine/sv_load.lua")
  --include("main/testengine/sv_matchers.lua")
  hook.Run("GUnitReady")
end
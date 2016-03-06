-- The main file for controlling tests.
-- Does not actually test main.lua; that's in the test/autorun folder.

GUnit = {}
GUnit.Tests = {}
GUnit.Colors = {}

local enableTests = true

if (SERVER && enableTests) then
  include("main/global/sv_stringsplit.lua")
  include("main/testengine/sv_colors.lua")
  include("main/testengine/sv_main.lua")
  include("main/testengine/sv_test.lua")
  include("main/testengine/sv_load.lua")
  --include("main/testengine/sv_result.lua") 
  --include("main/testengine/sv_matchers.lua")

  hook.Add("Initialize", "GUnitInit", function()
    hook.Call("GUnitReady")
  end)
end
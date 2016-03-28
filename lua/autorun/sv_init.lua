-- Initializes GUnit and loads the files in the proper order.

GUnit = {}
GUnit.Asserts = {}
GUnit.Colors = {}
GUnit.Generators = {}
GUnit.Tests = {}

local enableTests = true

local function getGUnitWorkingDirectory()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

if (SERVER and enableTests) then
  local workingDirectory = "../" .. getGUnitWorkingDirectory()
  include("main/global/sv_stringsplit.lua")
  include("main/testengine/sv_servertimer.lua")
  include("main/testengine/sv_colors.lua")
  include("main/testengine/sv_main.lua")
  include("main/testengine/sv_result.lua")
  include("main/testengine/sv_test.lua")
  include("main/testengine/sv_load.lua")
  include("main/testengine/sv_asserts.lua")
  include("main/generators/sv_stringgen.lua")
  include("main/generators/sv_fakeplayer.lua")
  --include("main/testengine/sv_matchers.lua")
  
  include(workingDirectory .. "../test/sv_testinit.lua")
  hook.Run("GUnitReady")
end
-- Initializes GUnit and loads the files in the proper order.

GUnit = {}
GUnit.Asserts = {}
GUnit.Colors = {}
GUnit.Generators = {}
GUnit.Tests = {}
GUnit.version = "v0.1.0"

local enableTests = true

if (SERVER and enableTests) then
  include("gunit/main/global/sv_stringsplit.lua")
  include("gunit/main/testengine/sv_colors.lua")
  include("gunit/main/testengine/sv_runner.lua")
  include("gunit/main/testengine/sv_pending.lua")
  include("gunit/main/testengine/sv_result.lua")
  include("gunit/main/testengine/sv_test.lua")
  include("gunit/main/testengine/sv_load.lua")
  include("gunit/main/testengine/sv_assertclass.lua")
  include("gunit/main/generators/sv_stringgen.lua")
  include("gunit/main/generators/sv_fakeentity.lua")
  include("gunit/main/generators/sv_fakeplayer.lua")
  include("gunit/main/generators/sv_ctakedamageinfo.lua")
  include("gunit/test/sv_testinit.lua")
  hook.Run("GUnitReady")
end

hook.Add("Initialize", "__GUnitTestInitialize", function()
  hook.Run("GUnitReady")
end)
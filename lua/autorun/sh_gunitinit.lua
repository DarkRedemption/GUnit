-- Initializes GUnit and loads the files in the proper order.

GUnit = {}
GUnit.Asserts = {}
GUnit.Colors = {}
GUnit.Generators = {}
GUnit.Tests = {}
GUnit.version = "v0.2.0-SNAPSHOT"

if SERVER then
  AddCSLuaFile("gunit/main/global/sh_stringsplit.lua")
  AddCSLuaFile("gunit/main/testengine/sh_colors.lua")
  AddCSLuaFile("gunit/main/testengine/sh_runner.lua")
  AddCSLuaFile("gunit/main/testengine/sh_pending.lua")
  AddCSLuaFile("gunit/main/testengine/sh_result.lua")
  AddCSLuaFile("gunit/main/testengine/sh_test.lua")
  AddCSLuaFile("gunit/main/testengine/sh_load.lua")
  AddCSLuaFile("gunit/main/testengine/sh_assertclass.lua")
  AddCSLuaFile("gunit/main/generators/sh_stringgen.lua")
  AddCSLuaFile("gunit/main/generators/sh_fakeentity.lua")
  AddCSLuaFile("gunit/main/generators/sh_fakeplayer.lua")
  AddCSLuaFile("gunit/main/generators/sh_ctakedamageinfo.lua")
  AddCSLuaFile("gunit/main/testengine/cl_clienttest.lua")
  AddCSLuaFile("gunit/test/sh_testinit.lua")
  
  include("gunit/main/global/sh_stringsplit.lua")
  include("gunit/main/testengine/sh_colors.lua") 
  include("gunit/main/testengine/sh_runner.lua")
  include("gunit/main/testengine/sh_pending.lua")
  include("gunit/main/testengine/sh_result.lua")
  include("gunit/main/testengine/sh_test.lua")
  include("gunit/main/testengine/sh_load.lua")
  include("gunit/main/testengine/sh_assertclass.lua")
  include("gunit/main/generators/sh_stringgen.lua")
  include("gunit/main/generators/sh_fakeentity.lua")
  include("gunit/main/generators/sh_fakeplayer.lua")
  include("gunit/main/generators/sh_ctakedamageinfo.lua")
  
  include("gunit/test/sh_testinit.lua")
  hook.Run("GUnitReady")
end

if CLIENT then
  include("gunit/main/global/sh_stringsplit.lua")
  include("gunit/main/testengine/sh_colors.lua")
  include("gunit/main/testengine/sh_runner.lua")
  include("gunit/main/testengine/sh_pending.lua")
  include("gunit/main/testengine/sh_result.lua")
  include("gunit/main/testengine/sh_test.lua")
  include("gunit/main/testengine/sh_load.lua")
  include("gunit/main/testengine/sh_assertclass.lua")
  include("gunit/main/generators/sh_stringgen.lua")
  include("gunit/main/generators/sh_fakeentity.lua")
  include("gunit/main/generators/sh_fakeplayer.lua")
  include("gunit/main/generators/sh_ctakedamageinfo.lua")
  include("gunit/main/testengine/cl_clienttest.lua")
  
  include("gunit/test/sh_testinit.lua")
  hook.Run("GUnitReady")
end

hook.Add("Initialize", "__GUnitTestInitialize", function()
  hook.Run("GUnitReady")
end)
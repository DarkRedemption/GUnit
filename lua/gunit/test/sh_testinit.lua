print("loaded testinit")

hook.Add("GUnitReady", "GUnitLoadTests", function()
  GUnit.load()
end)

if GUnit then
  GUnit.load()
end
local strGenTest = GUnit.Test:new("String Generator")

local StringGen = GUnit.Generators.StringGen
local Asserts = GUnit.Asserts

strGenTest:addSpec("not break", function()
    for i=1, 100 do
      print(StringGen.generateAlphaNum())
    end
  end
)

strGenTest:addSpec("stop the user from having a min size exceed the max size", function()
    Asserts.shouldFail(StringGen.generateAlphaNum, 10, 1)
  end)
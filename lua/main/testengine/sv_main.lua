local Colors = GUnit.Colors

local function runTests()
  for projectName, testTable in pairs(GUnit.Tests) do
    MsgC(Colors.lightBlue, "Tests in project: " .. projectName .. ".\n")
    for testName, test in pairs(testTable) do
      test:runSpecs()
    end
  end
end

local function addConCommand()
  concommand.Add("test", function(ply, cmd, args, argStr)    
    if (ply == NULL) then
      MsgC(Colors.lightBlue, "Running tests in every project.\n")
      runTests()
    else
      MsgC(Colors.lightBlue, "This command may only be run through the server console.")
    end
  end)
end

addConCommand()
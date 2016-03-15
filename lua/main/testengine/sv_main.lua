local Colors = GUnit.Colors

local function updateResultStats(results, resultStats)
  for key, result in pairs(results) do
    resultStats.specs = resultStats.specs + 1
    if (result.passed) then
      resultStats.passed = resultStats.passed + 1
    else
      resultStats.failed = resultStats.failed + 1
    end
  end
end

local function printResultStats(resultStats)
  local color = nil
  if (resultStats.failed == 0) then
    color = Colors.green
  else
    color = Colors.red
  end
  local msg = resultStats.specs .. " specs run in " .. resultStats.projects .. " project(s). " ..
              resultStats.passed .. " passed, " .. resultStats.failed .. " failed.\n"
  MsgC(color,  msg) 
end

local function printResults(results)
  for key, result in pairs(results) do
    result:print()
  end
end

local function runTests()
  local resultStats = {}
  
  resultStats.projects = 0
  resultStats.specs = 0
  resultStats.passed = 0
  resultStats.failed = 0
  
  for projectName, testTable in pairs(GUnit.Tests) do
    resultStats.projects = resultStats.projects + 1
    
    MsgC(Colors.lightBlue, "Running tests for project: " .. projectName .. ".\n")
    for testName, test in pairs(testTable) do
      local results = test:runSpecs()
      printResults(results)
      updateResultStats(results, resultStats)
    end
  end
  
  printResultStats(resultStats)
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
local Colors = GUnit.Colors

local function updateResultStats(results, resultStats)
  for key, result in pairs(results) do
    resultStats.specs = resultStats.specs + 1
    if (result.passed) then
      resultStats.passed = resultStats.passed + 1
    elseif (result:isPending()) then
      resultStats.pending = resultStats.pending + 1
    else
      resultStats.failed = resultStats.failed + 1
    end
  end
end

local function printResultStats(resultStats)
  if (!resultStats) then return end
  
  local color = nil
  if (resultStats.failed == 0) then
    color = Colors.green
  else
    color = Colors.red
  end
  local elapsedTime = string.format("Run completed in %.3f seconds.\n", os.clock() - resultStats.startTime)
  local msg = elapsedTime ..
              resultStats.specs .. " specs run in " .. resultStats.projects .. " project(s). " ..
              resultStats.passed .. " passed, " .. resultStats.failed .. " failed, " .. resultStats.pending .. " pending.\n"
  MsgC(color,  msg) 
end

local function printResults(results)
  for key, result in pairs(results) do
    result:print()
  end
end

local function runTest(test, resultStats)
  local results = test:runSpecs()
  updateResultStats(results, resultStats)
end

local function runProjectTests(projectName, testTable, resultStats)
  MsgC(Colors.lightBlue, "\nRunning tests for project: " .. projectName .. ".\n")
  for testName, test in pairs(testTable) do
    runTest(test, resultStats)
  end
end

local function runAllTests(resultStats)
  if (GUnit.Tests == nil) then
    MsgC(Colors.red, "No tests found in any project!\n")
    return false
  else
    for project, testTable in pairs(GUnit.Tests) do
      resultStats.projects = resultStats.projects + 1
      runProjectTests(project, testTable, resultStats)
    end
    return true
  end
end

local function projectExists(projectName)
  if (GUnit.Tests[projectName]) then
    return true
  else
    MsgC(Colors.red, "Project " .. projectName .. " has no tests or does not exist.\n")
    return false
  end
end

local function runSingleProjectTests(projectName, resultStats)
  if (projectExists(projectName)) then
    resultStats.projects = 1
    runProjectTests(projectName, GUnit.Tests[projectName], resultStats)
    return true
  end
  return false
end

local function runSingleTest(projectName, testName, resultStats)
  if (projectExists(projectName)) then
    if (GUnit.Tests[projectName][testName]) then
      resultStats.projects = 1
      MsgC(Colors.lightBlue, "\nRunning test " .. testName .. " in project " .. projectName .. ".\n")
      runTest(GUnit.Tests[projectName][testName], resultStats)
      return true
    else
      MsgC(Colors.red, "Test " .. testName .. " in project " .. projectName .. " does not exist!\n")
    end
  end
  return false
end

local function runTests(projectName, testName)
  local allResults = {}
  local resultStats = {}
  local testsRan = false
  
  resultStats.startTime = os.clock()
  resultStats.projects = 0
  resultStats.specs = 0
  resultStats.passed = 0
  resultStats.failed = 0
  resultStats.pending = 0
  
  if (projectName == nil) then
    testsRan = runAllTests(resultStats)
  elseif (testName == nil) then
    testsRan = runSingleProjectTests(projectName, resultStats)
  else
    testsRan = runSingleTest(projectName, testName, resultStats)
  end
  
  if (testsRan) then
    printResultStats(resultStats)
  end
end

local function addTestCommand()
  concommand.Add("test", function(ply, cmd, args, argStr)
    if (#args > 0) then
      print("Command 'test' does not take arguments.\nIf you wish to specify a specific project or test to run, use the 'test-only' command.")
    else
      if (ply == NULL) then
        MsgC(Colors.lightBlue, "Running tests in every project.\n")
        runTests()
      else
        MsgC(Colors.lightBlue, "This command may only be run through the server console.")
      end
    end
  end)
end

local function addTestOnlyCommand()
  concommand.Add("test-only", function(ply, cmd, args, argStr)
    if (#args == 0 || #args > 2) then
      print("Usage: test-only <projectname> [testname]\nNote that testnames are case sensitive and project names are always lowercase.\n" ..
        "If your test has spaces in the name, surround it with quotes. ex: \"My Test\"")
    else
      runTests(args[1], args[2])
    end
  end)
end

addTestCommand()
addTestOnlyCommand()
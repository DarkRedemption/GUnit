--Code for discovering tests in an addon's test directory.

local function getWorkingDirectory()
  -- From https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
  local str = debug.getinfo(3, "S").source:sub(2)
  return str:match("(.*/)")
end

--Removes the working directory so you have a relative filepath
local function removeWorkingDirectoryFromPath(workingDirectory, filepath)
  return string.sub(filepath, workingDirectory:len())
end

-- Finds the name of the addon directory using getScriptPath.
local function findProjectName(workingDirectory)
  local directories = workingDirectory:split("/")
  return directories[2]
end

local function includeTests(workingDirectory, currentDirectory)
  currentDirectory = currentDirectory or workingDirectory
  local specPath = currentDirectory .. "*test.lua"
  local files, _ = file.Find(specPath, "MOD")
  local _, directories = file.Find(currentDirectory .. "*", "MOD")
  
  for index, file in ipairs(files) do
    local filePath = "../" .. currentDirectory .. "/" .. file
    include(filePath)
  end
  
  for index, directory in ipairs(directories) do
    includeTests(workingDirectory, currentDirectory .. directory .. "/")
  end
end

local function clearTests(projectName)
  if (GUnit.Tests[projectName]) then
    GUnit.Tests[projectName] = nil
    print("GUnit: Reloading tests in " .. projectName .. ".")
  end
end

--Discovers and loads tests in and below the current directory.
--This also clears out all currently loaded tests in a project
--to prevent double-loading if that project reloads.
--As such, ONLY RUN THIS FUNCTION ONCE IN A PROJECT!
function GUnit.load()
    local workingDirectory = getWorkingDirectory()
    local projectName = findProjectName(workingDirectory)
    clearTests(projectName)
    includeTests(getWorkingDirectory())
end
  
--Code for discovering tests in an addon's test directory.

--Removes lua/.. from the working directory path.
--A workaround necessary for some includes. 
--Notably happens when GUnit tries to load its own tests.
local function removeLuaStartFromPath(workingDirectory)
  if (string.sub(workingDirectory, 0, 6) == "lua/..") then
    return string.sub(workingDirectory, 7, workingDirectory:len())
  else
    return workingDirectory
  end
end

--Parses every instance ".." in the working directory that isn't the firstand removes it, 
--deleting the directory right before it.
local function applyDoubleDots(workingDirectory)
  local array = workingDirectory:split("/")
  local arraySize = 0
  for key, value in pairs(array) do
    arraySize = arraySize + 1
  end
  
  local function removeDir(newPath, index)
    if ((index + 1) == arraySize) then return newPath .. "/" end
    if (index == 1) then return removeDir(array[index], index + 1) end
    if (array[index + 1] == ".." || array[index] == "..") then
      return removeDir(newPath, index + 1)
    else
      return removeDir(newPath .. "/" .. array[index], index + 1)
    end
  end
  
  local newDir = removeDir("", 1)
  return newDir
end

--Gets the working directory of whatever called it from 3 functions ago, including this function.
--Used to get the working directory of the outside project.
--The logic being, the stacktrace is: outside project (#3) -> GUnit.load() (#2) -> getWorkingDirectory() itself (#1)
local function getWorkingDirectory()
  -- From https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
  local str = debug.getinfo(3, "S").source:sub(2)
  local path = str:match("(.*/)")
  local lualessPath = removeLuaStartFromPath(path)
  return applyDoubleDots(lualessPath)
end

--Removes the working directory so you have a relative filepath.
local function removeWorkingDirectoryFromPath(workingDirectory, filepath)
  return string.sub(filepath, workingDirectory:len())
end

-- Finds the name of the addon directory using getScriptPath.
local function findProjectName(workingDirectory)
  local directories = workingDirectory:split("/")
  return directories[2]
end

local function stringEndsWith(str, ending)
  return ending=='' or string.sub(str,-str.len(ending))==ending
end

local function includeTests(workingDirectory, currentDirectory)
  currentDirectory = currentDirectory or workingDirectory
  local specPath = currentDirectory .. "*"
  local files, _ = file.Find(specPath, "MOD")
  local _, directories = file.Find(currentDirectory .. "*", "MOD")
  
  if (files) then
    for index, file in ipairs(files) do
      local filePath = "../" .. currentDirectory .. file
      --We have to do it this way instead of doing *.lua in specPath
      --because Linux freaks out and can't find all the files for some reason otherwise.
      if (stringEndsWith(filePath, "test.lua")) then
      --AddCSLuaFile(filePath)
        include(filePath)
        --print("Including " .. filePath)
        --print("current directory is " .. currentDirectory)
      end
    end
  else
    print("No testfiles found in " .. currentDirectory)
  end
  
  if (directories) then
    for index, directory in ipairs(directories) do
      includeTests(workingDirectory, currentDirectory .. directory .. "/")
    end
  else
    --print("No subdirectories found in " .. currentDirectory)
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
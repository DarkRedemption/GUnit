local simpleTimers = {}

local ServerTimer = {}

local ticksSinceLastCheck = 0

function ServerTimer:Simple(seconds, func)
  print("making a timer")
  local newTimer = {}
  newTimer.timeToRun = os.time() + seconds
  newTimer.func = func
  table.insert(simpleTimers, newTimer)
  return newTimer
end

local function checkSimpleTimers()
  local function check(index, timers)
    if (timers[index] == nil) then return timers end
    if (timers[index].timeToRun < os.time()) then
      timers[index].func()
      table.remove(timers, index)
      return check(index, timers)
    else
      return check(index + 1, timers)
    end
  end
  
  if (simpleTimers != nil) then
    simpleTimers = check(1, simpleTimers)
  end
end

--Will add named timers later, so setting up this function ahead of time.
local function checkTimers()
  --Avoid spamming this function
  ticksSinceLastCheck = ticksSinceLastCheck + 1
  if (ticksSinceLastCheck > 25) then
    ticksSinceLastCheck = 0
    checkSimpleTimers() 
  end
end

GUnit.ServerTimer = ServerTimer

hook.Add("Tick", "GUnitServerTimerCheck", function() checkTimers() end)
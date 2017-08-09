local consoles = {}

local selector = dofile("src/selector.lua")
selector.init(consoles) -- console selector needs to have access to consoles

local function new_console(side)
  consoles[side] = selector.console(peripheral.wrap(side))
end

for _, side in ipairs(peripheral.getNames()) do
  if peripheral.getType(side) == "monitor" then
    new_console(side)
  end
end

while true do
  local event, side, x, y = os.pullEvent()

  if event == "monitor_touch" then
    if consoles[side] then
      if x == 1 and y == 1 then
        new_console(side) -- lazy hack, might lead to memory leak?
      end
      consoles[side]:touch(side, x, y)
    else
      new_console(side)
    end
  elseif event == "peripheral" then
    if peripheral.getType(side) == "monitor" then
      new_console(side)
    end
  else
    print(event, side, x, y)
  end
end

--[[
- make it possible to load a file specifying which monitors were using which screens and automatically restore previous "session"
]]

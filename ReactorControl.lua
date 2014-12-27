shell.run("Button")
shell.run("EventListener")

os.loadAPI("Button")
os.loadAPI("EventListener")

reactorString = "BigReactors-Reactor_0"
redstoneSide = "back"

reactor = peripheral.wrap(reactorString)

mon = peripheral.find("monitor", 
  function(name, object)
    return object.isColour()
  end
)

if not mon then
  print("No monitor connected")
  print("Requires Advanced Monitor")
  shell.exit()
end


function drawStaticText()
  mon.setCursorPos(1,1)
  mon.write("Status:")
  mon.setCursorPos(1,3)
  mon.write("Fuel:")
  mon.setCursorPos(1,4)
  mon.write("Fuel Temp:")

  rightAlign, _ = mon.getSize()
  rightAlign = rightAlign - 22

  mon.setCursorPos(rightAlign,1)
  mon.write("Time:")
  mon.setCursorPos(rightAlign,2)
  mon.write("Energy Stored:")
  mon.setCursorPos(rightAlign,3)
  mon.write("Waste:")
  mon.setCursorPos(rightAlign,4)
  mon.write("Case Temp:")
  mon.setCursorPos(14,5)
  mon.write("Energy:")
end

function drawText()
  mon.setCursorPos(12, 1)
  if reactor.getConnected() then
    mon.setTextColour(colours.green)
    mon.write("Connected")
    mon.setCursorPos(12, 2)
    
    if reactor.getActive() then
      mon.setTextColour(colours.green)
      mon.write("Online")
    else
      mon.setTextColour(colours.red)
      mon.write("Offline")
    end

    mon.setTextColour(colours.white)
    mon.setCursorPos(12, 3)
    mon.write(reactor.getFuelAmount() / 1000 .. "B")
    mon.setCursorPos(12, 4)
    mon.write(reactor.getFuelTemperature() .. " C")

    mon.setCursorPos(rightAlign + 12, 1)
    mon.write(os.time())
    mon.setCursorPos(rightAlign + 12, 2)
    mon.write(reactor.getEnergyStored() .. " RF")
    mon.setCursorPos(rightAlign + 12, 3)
    mon.write(reactor.getWasteAmount() / 1000 .. "B")
    mon.setCursorPos(rightAlign + 12, 4)
    mon.write(reactor.getCasingTemperature() .. " C")

    mon.setCursorPos(24, 5)
    local energy = reactor.getEnergyProducedLastTick()
    
    if energy > 100 then
      mon.setTextColour(colours.green)
    else
      mon.setTextColour(colours.red)
    end

    mon.write(energy .. " RF")
    mon.setTextColour(colours.white)
  else
    mon.setTextColour(colours.red)
    mon.write("Disconected")
  end
end

local xmid, ymid = mon.getSize()
xmid = xmid / 2
ymid = ymid / 2

-- Buttons
reactorControl = {
  width = 12,
  x = xmid - 6,
  y = ymid,
  height = 3,
  monitor = mon,
  text = "Reactor",
  state = reactor.getActive(),
  toggle = true,
  onClick = function(s)
    reactor.setActive(s)
  end
}

quit = {
  x = term.getSize() - 12,
  text = "Quit",
  colourOn = colors.red,
  colourOff = colors.green,
  onClick = function()
    reactor.setActive(false)
    mon.clear()
    term.clear()
    running = false
  end
}

function main()
  Button:new(reactorControl)
  Button:new(quit)

  EventListener.add("monitor_touch", "ButtonTouch", Button.eventHandler)
  EventListener.add("mouse_click", "ButtonClick", Button.eventHandler)
  EventListener.add("redstone", "ButtonTouch", function()
      reactor.setActive(redstone.getInput(redstoneSide))
      reactorControl.sate = reactor.getActive()
      Button.drawAll()
    end
  )

  drawStaticText()

  EventListener.updateLoop(1, running, function()
      drawText()
    end
  )
end

main()
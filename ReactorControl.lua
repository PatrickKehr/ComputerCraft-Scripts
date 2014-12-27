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
  mon.wite("Status:")
  mon.setCursorPos(1,2)
  mon.write("Energy Stored:")
  mon.setCursorPos(1,3)
  mon.write("Fuel Temperature:")
  mon.setCursorPos(1,4)
  mon.write("Case Temperature:")

  mon.setCursorPos(28,1)
  mon.write("Fuel:")
  mon.setCursorPos(28,2)
  mon.write("Waste:")
  mon.setCursorPos(14,5)
  mon.write("Energy:")
end

function drawText()
  mon.setCursorPos(18, 1)
  if reactor.getConnected() then
    mon.setTextColour(colours.green)
    mon.write("Connected")
    mon.setTextColour(colours.white)
    mon.setCursorPos(18, 2)
    mon.write(reactor.getEnergyStored() .. " RF")
    mon.setCursorPos(18, 3)
    mon.write(reactor.getFuelTemperature() .. " C")
    mon.setCursorPos(18, 4)
    mon.write(reactor.getCasingTemperature() .. " C")

    mon.setCursorPos(32, 1)
    mon.write(reactor.getFuelAmount() .. "mB")
    mon.setCursorPos(32, 2)
    mon.write(reactor.getWasteAmount() .. "mB")

    mon.setCursorPos(22, 5)
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

-- Buttons
reactorControl = {
  width = 12,
  x = math.floor(((x2 + x1) - width) / 2),
  y = math.floor((y2 + y1) / 2),
  height = 3,
  monitor = mon,
  text = "Reactor",
  state = getActive(),
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

EventListener.updateLoop(1, running, function()
    drawText()
  end
)
EventListener = {}
function EventListener.init()
  events = {
    char = {},
    key = {},
    timer = {},
    redstone = {},
    terminate = {},
    peripheral = {},
    mouse_click = {},
    monitor_touch = {}
  }
end

function EventListener.add(eventType, eventName, eventFunction)
  if events[eventType] then
    table.insert(events[eventType], {name = eventName, func = eventFunction})
  else
    print("Invalid event type: " .. eventType)
  end
end

function EventListener.remove(eventType, eventName)
  for i, event in ipairs(events[eventType]) do
    if event["name"] == eventName then
      table.remove(events[eventType], i)
    end
  end 
end

-- Recieves an os.pullEvent() and calls the associated functions
function EventListener.runEvent(event)
  for _, functionTable in ipairs(events[event[1]]) do
    functionTable["func"](event)
  end
end
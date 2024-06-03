-- Update script
-- Automatically downloads ComputerCraft programs to a computer
repo = "https://raw.githubusercontent.com/PatrickKehr/ComputerCraft-Scripts/master/"
urls = {
    {"Button",         repo .. "Button.lua"},
    {"MiningTurtle",   repo .. "MiningTurtle.lua"},
    {"EventListener",  repo .. "EventListener.lua"},
    {"ReactorControl", repo .. "ReactorControl.lua"},
    {"update",         repo .. "Update.lua"},
    {"warehouseDash",  repo .. "WarehouseDashboard.lua"}
}

function download(name, url)
  print("Updating " .. name)
 
  request = http.get(url)
  data = request.readAll()
 
  if fs.exists(name) then
    fs.delete(name)
    file = fs.open(name, "w")
    file.write(data)
    file.close()
  else
    file = fs.open(name, "w")
    file.write(data)
    file.close()
  end
 
  print("Successfully downloaded " .. name .. "\n")
end

for key, value in ipairs(urls) do
    download(unpack(value))
end

term.clear()
term.setCursorPos()

inventorySpace = {4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
Torch = true
EnderChest = false
 
--Calculations based on config
if turtle.getItemCount(4) == 0 then
  print("No torches detected in Inventory slot 4, Torch placing disabled.")
  Torch = false
end
 
if Torch == true then
  table.remove(inventorySpace, 1)
end

if turtle.getItemCount(1) > 1 then
  print("More than one chest detected, EnderChest mode == false.")
  EnderChest = false
end
 
function debug(Str, Val)
  local debug = false
  if debug == true then
    print(Str .. ": " .. tostring(Val))
  end
end

function breakBlock()
  while turtle.detect() do
    turtle.dig()
    sleep(0.5)
  end
end

function breakBlockUp()
  while turtle.detectUp() do
    turtle.digUp()
    sleep(0.5)
  end
end

function unload()
  for i, inventorySpace in pairs(inventorySpace) do
    turtle.select(inventorySpace)
    turtle.drop()
  end
  turtle.select(1)
end

function placeChest()
  breakBlock()
  if EnderChest then
    turtle.select(1)
    turtle.place()
    unload()
    turtle.dig()
  else
    turtle.select(1)
    turtle.place()
    unload()
  end
end
 
function checkInventory()
  if turtle.getFuelLevel() < 1280 then
    print("fuel Level: " .. turtle.getFuelLevel())
    for i, inventorySpace in pairs(inventorySpace) do
      turtle.select(inventorySpace)
      if turtle.refuel(10) then
        print("Refuelling " .. turtle.getFuelLevel())
      end
    end
  end

  if turtle.getItemCount(16) > 0 then
    placeChest()
  end
end

function placeTorch()
  if Torch == true and turtle.getItemCount(4) > 1 then
    turtle.select(4)
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.dig()
    turtle.place()
    turtle.turnRight()
    turtle.turnRight()
  end
end

function blacklist()
  for i = 2, 3 do
    bl = false
    debug("Blacklist Forward", i)
    turtle.select(i)
   if turtle.compare() then
      debug("blacklist Compare", turtle.compare())
      bl = true
      break
    end
  end
 
  return bl
end
 
function blacklistUp()
  for i = 2, 3 do
    bl = false
    debug("Blacklist up", i)
    turtle.select(i)
   if turtle.compareUp() then
      debug("blacklist Compare", turtle.compareUp())
      bl = true
      break
    end
  end
 
  return bl
end
 
function blacklistDown()
  for i = 2, 3 do
    bl = false
    debug("Blacklist Down", i)
    turtle.select(i)
   if turtle.compareDown() then
      debug("blacklist Compare", turtle.compareDown())
      bl = true
      break
    end
  end
 
  return bl
end
 
function compare()
  if blacklist() == false then
    turtle.dig()
  end
end
 
function compareUp()
  compare()
  if blacklistUp() == false then
    while turtle.detectUp() do
      turtle.digUp()
      sleep(0.5)
    end
  end
end
 
function compareDown()
  compare()
  if blacklistDown() == false then
    turtle.digDown()
  end
end
 
function compareSides()
  turtle.turnLeft()
  compare()
  turtle.turnRight()
  turtle.turnRight()
  compare()
  turtle.turnLeft()
end
 
function dig()
  breakBlock()
  while turtle.detectUp() do
    turtle.digUp()
    sleep(0.5)
  end
  if turtle.forward() then
    return true
  else
    turtle.attack()
    return false
  end
end
 
function mineShaft()
  for i=1, 16 do
    if not dig() then
      i=i-1
    end
    compareDown()
    compareSides()
  end
  breakBlockUp()
  checkInventory()
  turtle.up()
  compareUp()
  compareSides()
  turtle.turnLeft()
  turtle.turnLeft()
  placeTorch()

  for i=1, 16 do
    if not turtle.forward() then
      breakBlock()
      turtle.attack()
      i=i-1
    end
    compareUp()
    compareSides()
  end

  turtle.down()

  if EnderChest then
    checkInventory()
  end
end
 
function branch()
  for i = 0, 8 do
    turtle.turnRight()
    mineShaft()
    mineShaft()
    turtle.turnLeft()
    dig()
    placeTorch()
    for i = 1, 2 do
      if not dig() then
        i=i-1
      end
    end
  end
end

--main
branch()
local refuelAutomatically = true
local running = false
local paired_pc = -1

local function dig() --digs a single iteration
    --dig a up and down stuff
    if turtle.detect() then
        turtle.dig()
    end
    if turtle.detectDown() then
        turtle.digDown()
    end
    if turtle.detectUp() then
        turtle.digUp()
    end   
    if turtle.detectDown() then
        turtle.digDown()
    end    
    --dig a plus-like shape
    turtle.turnLeft()
    
    if turtle.detect() then
        turtle.dig()    
    end
    
    turtle.turnRight()
    turtle.turnRight()
    
    if turtle.detect() then
        turtle.dig()
    end
    
    turtle.turnLeft()
    
    turtle.forward()
end

local function drop(refuel) --drops useless stuff
    for iw=1,16 do
        turtle.select(iw)

        if refuel == true then
            turtle.refuel(10)
        end

        if turtle.getItemCount() > 0 then      
            if turtle.getItemDetail()["name"] == "minecraft:cobblestone" then
                turtle.drop()
            elseif turtle.getItemDetail()["name"] == "minecraft:andesite" then
                turtle.drop()
            elseif turtle.getItemDetail()["name"] == "minecraft:diorite" then
                turtle.drop()
            elseif turtle.getItemDetail()["name"] == "minecraft:gravel" then
                turtle.drop()
            elseif turtle.getItemDetail()["name"] == "minecraft:dirt" then
                turtle.drop()
            elseif turtle.getItemDetail()["name"] == "minecraft:netherrack" then
                turtle.drop()
            elseif turtle.getItemDetail()["name"] == "minecraft:basalt" then
                turtle.drop()
            elseif turtle.getItemDetail()["name"] == "minecraft:blackstone" then
                turtle.drop()
            end
        end
    end
end

local function move(dir)
    if dir == "fwd" then
        turtle.forward()
    elseif dir == "bck" then
        turtle.back()
    elseif dir == "uup" then
        turtle.up()
    elseif dir == "dwn" then
        turtle.down()
    elseif dir == "lft" then
        turtle.turnLeft()
    elseif dir == "rgh" then
        turtle.turnRight()
    end
end

local function stopDig()
    running = false
end

local function startDig()
    running = true
end

local function sendData()
    local data = {}
    data["fuel"] = turtle.getFuelLevel()
    data["working"] = running
    local mmm = textutils.serialize(data)
    rednet.send(paired_pc,mmm)
end

local function interpret(cmd)
    if cmd == "turtle_move_fwd" then move("fwd") end
    if cmd == "turtle_move_bck" then move("bck") end
    if cmd == "turtle_move_uup" then move("uup") end
    if cmd == "turtle_move_dwn" then move("dwn") end
    if cmd == "turtle_move_lft" then move("lft") end
    if cmd == "turtle_move_rgh" then move("rgh") end

    if cmd == "turtle_start_dig" then startDig() end
    if cmd == "turtle_stop_dig" then stopDig() end

    if cmd == "turtle_send_data" then sendData() end
    if cmd == "turtle_refuel" then drop(true) end
end



local function digloop()
    dig()
    drop(refuelAutomatically)
end

local function receive()
    id,msg,n = rednet.receive()

    if id == paired_pc then
        interpret(msg)
    end
end


print("Tuneller.NET")
print("v1.1:compat 1")
print("by Bajtix_One")

rednet.open("right")

while paired_pc == -1 do
    print("Pairing with a tablet. The ID is " .. os.getComputerID())

    local id,msg,n = rednet.receive()
    while not msg == "turtle_pair" do
        id,msg,n = rednet.receive()  
    end
    paired_pc = id
    print("Paired with " .. paired_pc .. " and sent confirmation packet.")
    rednet.send(paired_pc,"turtle_confirm")
end

while true do
    if running then 
        parallel.waitForAny(receive,digloop)
    else
        receive()
    end
    
end
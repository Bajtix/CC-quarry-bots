local refuelAutomatically = true
local running = true
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

local function digloop()
    dig()
    drop(refuelAutomatically)
end

local function receive()
    id,msg,n = rednet.receive()
end


print("Tuneller.NET")
print("v1.1:compat 1")
print("by Bajtix_One")

rednet.open("right")

while paired_pc == -1 do
    print("Pairing with a tablet. The ID is " .. os.getComputerID)

    local id,msg,n = rednet.receive()
    while not msg == "turtle_pair" do
        id,msg,n = rednet.receive()
        paired_pc = id
        print("Paired with " .. paired_pc .. " and sent confirmation packet.")
        rednet.send(paired_pc,"turtle_confirm")
    end
end

while running do
    parallel.waitForAny(receive,digloop)
end
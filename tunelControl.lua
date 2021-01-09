local function menu(caption,opts)
    while true do
        print("=======================")
        print(caption)
        for index, value in ipairs(opts) do
            print(index.." > "..value)
        end

        menuSel = read()

        if tonumber(menuSel) ~= nil then
            if tonumber(menuSel) <= table.getn(opts) then
                return tonumber(menuSel)
            end
        end

        print("Invalid option")
    end 
end

print("Tuneller.NET Controller")
print("v1.0:compat 1")
print("by Bajtix_One")

local c = menu("What do you want to do?",{"add turtle","manage turtles"})
rednet.open("back")

while true do
    
    if c == 1 then
        print("Add a turtle")
        print("Input the TurtleID (the one your tutle shows)")
        local botId = tonumber(read())
        print("Sending pair packet...")
        rednet.send(botId,"turtle_pair")
        print("Waiting for confirmation...")
        local id,msg,n = rednet.receive()
        while not (msg == "turtle_confirm" and id == botId) do
            id,msg,n = rednet.receive()
        end
        print("Paired with " .. botId .. " and sent confirmation packet.")

    elseif c == 2 then

    end

end
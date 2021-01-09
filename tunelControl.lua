local function table_invert(t)
    local s={}
    for k,v in pairs(t) do
      s[v]=k
    end
    return s
 end

local function menu(caption,opts,clear)
    if clear then
        term.clear()
    end
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

local c = -1
rednet.open("back")

local turtles = {}
local turtlesById = {}

while true do  
    if c == 1 then
        print("Add a turtle")
        print("Input the TurtleID (the one your tutle shows)")
        local botId = tonumber(read())
        print("Sending pair packet...")
        rednet.send(botId,"turtle_pair")
        print("Waiting for confirmation...")
        local at = 0
        local id,msg,n = rednet.receive(nil,1)
        while at < 10 and msg ~= "turtle_confirm" do
            id,msg,n = rednet.receive(nil,1)
            at = at + 1
        end
        if(at >= 8) then
            print("Failed")
            os.sleep(2)
        else
            print("Paired with " .. botId .. " and sent confirmation packet.")
            table.insert(turtles,table.getn(turtles),botId)
            turtlesById = table_invert(turtles)
            os.sleep(2)
        end
    elseif c == 2 then
        if table.getn(turtles) > 0 then

            local opts = {}
            for index, value in ipairs(turtles) do
                opts[index] = "Turtle #"..index.."(ID:"..value..")"
            end

            local cbot = menu("Here are the bots",opts,false)
            local botaction = 0
            while botaction ~= -1 do
                rednet.send(turtles[cbot],"turtle_send_data")
                print("Requesting...")
                local at = 0
                local id,msg,n = rednet.receive(nil,1)
                while at < 10 and id ~= turtles[cbot] do
                    id,msg,n = rednet.receive(nil,1)
                    at = at + 1
                end

                if(at >= 8) then
                    print("Failed")
                    botaction = -1
                    break
                else
                    local mmm = textutils.unserialize(msg)
                    print("Fuel amount: ".. tostring(mmm["fuel"]))
                    print("Is Digging: " .. tostring(mmm["working"]))
                      
                    
                    if botaction == 1 then
                        rednet.send(turtles[cbot],"turtle_start_dig")
                    elseif botaction == 2 then
                        rednet.send(turtles[cbot],"turtle_stop_dig")
                    elseif botaction == 3 then
                        rednet.send(turtles[cbot],"turtle_move_lft")
                    elseif botaction == 4 then
                        rednet.send(turtles[cbot],"turtle_move_rgh")
                    elseif botaction == 5 then
                        rednet.send(turtles[cbot],"turtle_move_uup")
                    elseif botaction == 6 then
                        rednet.send(turtles[cbot],"turtle_move_dwn")
                    elseif botaction == 7 then
                        rednet.send(turtles[cbot],"turtle_move_fwd")
                    elseif botaction == 8 then
                        rednet.send(turtles[cbot],"turtle_move_bck")
                    elseif botaction == 9 then
                        rednet.send(turtles[cbot],"turtle_refuel")
                    elseif botaction == 10 then
                        botaction = -1
                        break
                    end
                    botaction = menu("Bot Action",{"Start digging","Stop Digging","Turn left","Turn right","Up","Down","Forward","Back","Refuel","Quit"},false)
                end
            end
        else
            print("No turtles")
        end
    elseif c == 3 then
        if table.getn(turtles) > 0 then
            local botaction = 0
            while botaction ~= -1 do            
                for index, value in ipairs(turtles) do
                    local cbot = index
                    if botaction == 1 then
                        rednet.send(turtles[cbot],"turtle_start_dig")
                    elseif botaction == 2 then
                        rednet.send(turtles[cbot],"turtle_stop_dig")
                    elseif botaction == 3 then
                        rednet.send(turtles[cbot],"turtle_move_lft")
                    elseif botaction == 4 then
                        rednet.send(turtles[cbot],"turtle_move_rgh")
                    elseif botaction == 5 then
                        rednet.send(turtles[cbot],"turtle_move_uup")
                    elseif botaction == 6 then
                        rednet.send(turtles[cbot],"turtle_move_dwn")
                    elseif botaction == 7 then
                        rednet.send(turtles[cbot],"turtle_move_fwd")
                    elseif botaction == 8 then
                        rednet.send(turtles[cbot],"turtle_move_bck")
                    elseif botaction == 9 then
                        rednet.send(turtles[cbot],"turtle_refuel")
                    elseif botaction == 10 then
                        botaction = -1
                        break
                    end
                    
                end   
                if(botaction == -1) then
                    break 
                end
                botaction = menu("Bot Action",{"Start digging","Stop Digging","Turn left","Turn right","Up","Down","Forward","Back","Refuel","Quit"},false)
            end
        else
            print("No turtles")
        end
    end
    c = menu("What do you want to do?",{"add turtle","manage turtles","manage all"},true)

        
end
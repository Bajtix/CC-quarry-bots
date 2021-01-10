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
        term.setCursorPos(1,1)
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

term.clear()
term.setCursorPos(1,1)

print("Tuneller.NET Controller")
term.setTextColor(colors.gray)
print("v1.0:compat 1")
print("by Bajtix_One")
term.setTextColor(colors.white)
os.sleep(2)

local c = -1
rednet.open("back")

local turtles = {}
local turtlesById = {}

while true do  
    if c == 1 then
        term.clear()
        term.setCursorPos(1,1)
        print("Add a turtle")
        print("Input the TurtleID (the one your tutle shows)")
        local botId = tonumber(read())

        if botId then
            term.setTextColor(colors.gray)
            print("===================")
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
                term.setTextColor(colors.red)
                print("Failed")
                os.sleep(2)
            else
                term.setTextColor(colors.green)
                print("Paired with " .. botId .. " and sent confirmation packet.")
                table.insert(turtles,table.getn(turtles),botId)
                turtlesById = table_invert(turtles)
                os.sleep(2)
            end
        else
            term.setTextColor(colors.red)
            print("ID is incorrect!")
            os.sleep(2)
        end

        term.setTextColor(colors.white)
    elseif c == 2 then
        term.clear()
        term.setCursorPos(1,1)
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
                    term.setTextColor(colors.red)
                    print("Failed")
                    term.setTextColor(colors.white)
                    os.sleep(2)
                    botaction = -1
                    break
                else
                    term.clear()
                    term.setCursorPos(1,1)
                    local mmm = textutils.unserialize(msg)
                    term.write("Fuel amount: ")
                    if mmm["fuel"] < 200 then
                        term.setTextColor(colors.red)
                    end
                    term.write(mmm["fuel"])
                    term.setTextColor(colors.white)
                    print("") --new line
                    print("Is Digging: " .. tostring(mmm["working"]))
                    local items = mmm["inv"]

                    
                    
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
                        term.clear()
                        term.setCursorPos(1,1)
                        term.setTextColor(colors.white)
                        print("Inventory:")
                        print("===================")
                        for index, value in ipairs(items) do

                            if(string.find(value["name"], "iron")) then 
                                term.setTextColor(colors.lightGray)
                                print(index .. "> Iron Ore*" .. value["count"])                            
                            elseif(string.find(value["name"], "gold")) then 
                                term.setTextColor(colors.yellow)
                                print(index .. "> Gold Ore*" .. value["count"])                            
                            elseif(string.find(value["name"], "coal")) then 
                                term.setTextColor(colors.black)
                                term.setBackgroundColor(colors.white)
                                print(index .. "> Coal*" .. value["count"]) 
                                term.setBackgroundColor(colors.black)                           
                            elseif(string.find(value["name"], "diamond")) then 
                                term.setTextColor(colors.cyan)
                                print(index .. "> Diamond*" .. value["count"])
                            elseif(string.find(value["name"], "redstone")) then 
                                term.setTextColor(colors.red)
                                print(index .. "> Redstone*" .. value["count"])
                            elseif(string.find(value["name"], "lapis")) then 
                                term.setTextColor(colors.blue)
                                print(index .. "> Lapis Lazuli*" .. value["count"])
                            elseif(string.find(value["name"], "emerald")) then 
                                term.setTextColor(colors.green)
                                print(index .. "> Emerald*" .. value["count"])
                            elseif(string.find(value["name"], "ancient_debris")) then 
                                term.setTextColor(colors.brown)
                                print(index .. "> Ancient Debris*" .. value["count"])
                            elseif(string.find(value["name"], "copper")) then 
                                term.setTextColor(colors.orange)
                                print(index .. "> Copper*" .. value["count"])
                            elseif(string.find(value["name"], "silver")) then 
                                term.setTextColor(colors.lightGray)
                                print(index .. "> Silver*" .. value["count"])
                            else
                                term.setTextColor(colors.gray)
                                print(index .. ">" .. value["name"] .. "*" .. value["count"])
                            end
                        end
                        term.setTextColor(colors.white)
                        print("Enter to continue")
                        read()
                        term.clear()
                        term.setCursorPos(1,1)
                    elseif botaction == 11 then
                        rednet.send(turtles[cbot],"turtle_unpair")
                        table.remove(turtles,cbot)
                        botaction = -1
                        break
                    elseif botaction == 12 then
                        botaction = -1
                        break
                    end
                    botaction = menu("Bot Action",{"Start digging","Stop Digging","Turn left","Turn right","Up","Down","Forward","Back","Refuel","Detail","Remove","Quit"},false)
                end
            end
        else
            term.setTextColor(colors.red)
            print("No turtles")
            term.setTextColor(colors.white)
            os.sleep(2)
            
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
                botaction = menu("Bot Action",{"Start digging","Stop Digging","Turn left","Turn right","Up","Down","Forward","Back","Refuel","Quit"},true)
            end
        else
            print("No turtles")
            os.sleep(2)
        end
    elseif c == 4 then
        print("Shutting down...")

        term.setTextColor(colors.gray)
        for index, value in ipairs(turtles) do
            print("Unpair #"..index.."(ID:"..value..")")
            rednet.send(value,"turtle_unpair")
        end

        term.setTextColor(colors.white)
        print("Bye!")
        break
    end
    c = menu("What do you want to do?",{"add turtle","manage turtles","manage all","quit"},true)
end
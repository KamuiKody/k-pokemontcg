local QBCore = nil
local assert = assert
local MenuV = assert(MenuV)

function CreateBlips()
        for k, v in pairs(badge) do           
            local blip = AddBlipForCoord(v.location)
            SetBlipAsShortRange(blip, true)
            SetBlipSprite(blip, 546)
            SetBlipColour(blip, 46)
            SetBlipScale(blip, 0.6)
            SetBlipDisplay(blip, 6)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.label)
            EndTextCommandSetBlipName(blip)
        end

        for k, v in pairs(Config.CardshopLocation) do
            local blip = AddBlipForCoord(v.location)
            SetBlipAsShortRange(blip, true)
            SetBlipSprite(blip, 500)
            SetBlipColour(blip, 2)
            SetBlipScale(blip, 0.7)
            SetBlipDisplay(blip, 6)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.label)
            EndTextCommandSetBlipName(blip)
        end
    end

Citizen.CreateThread(function()
       CreateBlips()
end)

function DisplayTooltip(suffix)
    SetTextComponentFormat('STRING')
    AddTextComponentString('Press ~INPUT_PICKUP~ To ' .. suffix)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local sleep = true
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for k, v in pairs(Config.CardshopLocation) do
            local loc = v.location
            local distance = #(playerCoords - loc)
            if distance < 2.5 then
                sleep = false
                DisplayTooltip('Sell Items')
                if IsControlJustPressed(1, 38) then
                    TriggerEvent('Cards:client:openMenu')
                    end
                end
            end
        
        for k, v in pairs(badge) do
            local loc = v.location
            local distance = #(playerCoords - loc)
            if distance < 2.5 then
                sleep = false
                DisplayTooltip('Trade for a '..v.label)
                if IsControlJustPressed(1, 38) then
            TriggerServerEvent('Cards:server:badges', k)
                end
            end
        end
    end
end)

RegisterNetEvent("Cards:Client:OpenPack")
AddEventHandler("Cards:Client:OpenPack", function(itemName)
    QBCore.Functions.Progressbar("drink_something", "opening pack..", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
       TriggerServerEvent("Cards:Server:rewarditem")       
    end)
end)

RegisterNetEvent("Cards:client:UseBox")
AddEventHandler("Cards:client:UseBox", function()
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    print('Box is Opening')
    QBCore.Functions.Notify("Box is being opened...", "error")
    QBCore.Functions.Progressbar("use_bag", "Box is being opened", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local RLBagData = {
            outfitData = {
                ["bag"]   = { item = 41, texture = 0},  -- Nek / Das
            }
        }
        --TriggerEvent('qb-clothing:client:loadOutfit', RallyBagData)
        TriggerServerEvent("inventory:server:OpenInventory", "pokeBox", "poke_"..QBCore.Functions.GetPlayerData().citizenid)
        TriggerEvent("inventory:client:SetCurrentStash", "poke_"..QBCore.Functions.GetPlayerData().citizenid)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "invbag", 0.5)
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        QBCore.Functions.Notify("Box has been opened successfully", "success")
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        QBCore.Functions.TriggerCallback("Cards:server:Menu",function(item,amount)
            print(item,amount)
        end)
    end
end)


--------------------------------------------------------
----------------MENU---------------------------------

--Config

local menu = MenuV:CreateMenu(false, 'Player Items', 'topright', 155, 0, 0, 'size-125', 'none', 'menuv', 'test3')
local menu2 = menu:InheritMenu({title = false, subtitle = 'Card Shop', theme = 'default' })
local menu_button = menu:AddButton({ icon = '🔖', label = 'Sell Cards/Badges', value = menu2, description = 'View List Of Items' })


--------------------------------------------------------------------

RegisterCommand('openmenu', function() --test only--
    MenuV:OpenMenu(menu)
end)


RegisterCommand('closemenu', function()
    MenuV:CloseMenu(menu)
end)

RegisterNetEvent('Cards:client:openMenu')
AddEventHandler('Cards:client:openMenu', function()
    MenuV:OpenMenu(menu)
end)

menu_button:On('select', function(item)
    QBCore.Functions.TriggerCallback('Cards:server:get:drugs:items', function(CardsResult)
        for k, v in pairs(CardsResult) do
            local itemName = v['Item']
            local itemCount = v['Amount']
            local price = Config.CardshopItems[itemName]
            price = math.ceil(price * itemCount)

            local menu_button2 = menu2:AddButton({
                label = itemName .. " | Amount : " ..itemCount.." | $" .. price,
                name = itemName,
                value = {name = itemName, count = itemCount, price = price},

            select = function(btn)
                local select = btn.Value -- get all the values from v!
                TriggerServerEvent('Cards:sellItem', select.name, select.count, select.price)
                menu2:ClearItems(false)
                
            end})
        end
    end)
end)

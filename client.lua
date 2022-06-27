local assert = assert
local MenuV = assert(MenuV)
local isDead = false

local CardShops = {
	['Cardshop'] = {
		location = vector3(174.08, -1321.79, 29.36),
	},
}

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

function CreateBlips()
        for k, v in pairs(Config.Badge) do           
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

CreateThread(function()
    CreateBlips()
end)

function DisplayTooltip(suffix)
    SetTextComponentFormat('STRING')
    AddTextComponentString('Press ~INPUT_PICKUP~ To ' .. suffix)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

CreateThread(function()
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
        
        for k, v in pairs(Config.Badge) do
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

RegisterNetEvent("Cards:Client:OpenCards")
AddEventHandler("Cards:Client:OpenCards", function() 
    RequestAnimDict("mp_arresting")
    while (not HasAnimDictLoaded("mp_arresting")) do
        Wait(0)
    end
      local PedCoords = GetEntityCoords(PlayerPedId())
      propbox = CreateObject(GetHashKey('prop_boosterbox_01'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
      AttachEntityToEntity(propbox, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.1, 0.1, 0.0, 0.0, 10.0, 90.0, false, false, false, false, 2, true)
        Wait(5)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "boxopen", 0.8)
    ESX.Progressbar("opening box..", 9500,{
        FreezePlayer = true, 
        animation ={
            type = "anim",
            dict = "mp_arresting", 
            lib ="a_uncuff" 
        }, 
        onFinish = function()
        Wait(1)
        DeleteEntity(propbox)
        ClearPedTasks(PlayerPedId())
    end})
end)

RegisterNetEvent("Cards:Client:OpenPack")
AddEventHandler("Cards:Client:OpenPack", function() 
    RequestAnimDict("mp_arresting")
      while (not HasAnimDictLoaded("mp_arresting")) do
      Wait(0)
      end
          TaskPlayAnim(PlayerPedId(), "mp_arresting" ,"a_uncuff" ,8.0, -8.0, -1, 1, 0, false, false, false )
          local PedCoords = GetEntityCoords(PlayerPedId())
          propcards = CreateObject(GetHashKey('prop_boosterpack_01'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
          AttachEntityToEntity(propcards, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.1, 0.1, 0.0, 70.0, 10.0, 90.0, false, false, false, false, 2, true)
    QBCore.Functions.Progressbar("drink_something", "opening pack..", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        disableInventory = true,
    }, {}, {}, {}, function()-- Done
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "dealfour", 0.9) 
        Wait(500)
        SetNuiFocus(true, true)
        SendNUIMessage({
            open = true,
            class = 'open',
        })
        DeleteEntity(propcards)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('Cards:Server:RemoveItem')
    end)
end)

RegisterNetEvent("Cards:Client:OpenPack")
AddEventHandler("Cards:Client:OpenPack", function() 
    RequestAnimDict("mp_arresting")
    while (not HasAnimDictLoaded("mp_arresting")) do
    Wait(0)
    end
        local PedCoords = GetEntityCoords(PlayerPedId())
        propcards = CreateObject(GetHashKey('prop_boosterpack_01'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
        AttachEntityToEntity(propcards, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.1, 0.1, 0.0, 70.0, 10.0, 90.0, false, false, false, false, 2, true)
    ESX.Progressbar("opening pack..", 3000,{
        FreezePlayer = true , 
        animation ={
            type = "anim",
            dict = "mp_arresting", 
            lib ="a_uncuff" 
        }, 
        onFinish = function()
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "dealfour", 0.9) 
            Wait(500)
            SetNuiFocus(true, true)
            SendNUIMessage({
                open = true,
                class = 'open',
            })
            DeleteEntity(propcards)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('Cards:Server:RemoveItem')
    end})
end)

RegisterNUICallback('Rewardpokemon', function(data)
    local pokemon = data.Pokemon    
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "flip", 0.9)
    TriggerServerEvent('Cards:Server:GetPokemon', pokemon)
end)

RegisterNUICallback('randomCard', function()
    TriggerServerEvent('Cards:Server:rewarditem')
end)

RegisterNUICallback('CloseNui', function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("Cards:Client:CardChoosed")
AddEventHandler("Cards:Client:CardChoosed", function(card)
    SendNUIMessage({
        open = true,
        class = 'choose',
        data = card,
    }) 
end)

RegisterNetEvent("Cards:client:UseBox")
AddEventHandler("Cards:client:UseBox", function()
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    print('Box is Opening')
    local PedCoords = GetEntityCoords(PlayerPedId())
    deckbox = CreateObject(GetHashKey('prop_deckbox_01'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
    AttachEntityToEntity(deckbox, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.1, 0.1, 0.0, 0.0, 10.0, 90.0, false, false, false, false, 2, true)
    ESX.ShowNotifcation("Box is being opened...")
    ESX.Progressbar("Box is being opened", 5000,{
        FreezePlayer = true, 
        animation ={
            type = "anim",
            dict = "mp_arresting", 
            lib ="a_uncuff" 
        }, 
        onFinish = function()
        --Code here
        local RLBagData = {
            outfitData = {
                ["bag"]   = { item = 41, texture = 0},  -- Nek / Das
            }
        }
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "poke_"..QBCore.Functions.GetPlayerData().citizenid, {maxweight = 0.1, slots = 160}) -- Convert
        TriggerEvent("inventory:client:SetCurrentStash", "poke_"..QBCore.Functions.GetPlayerData().citizenid) -- Convert
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "snap", 1.2)
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        ESX.ShowNotifcation("Box has been opened successfully")
        Wait(10000)
        DeleteEntity(deckbox)
        ClearPedTasks(PlayerPedId())
    end})
end)

CreateThread(function()
    while true do 
        Wait(2500)
        local PlayerData = ESX.GetPlayerData
        local ShopCoords = Config.CardshopLocation['Cardshop'].location
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - ShopCoords)
        if dist < 2.5 and not isDead and not IsPauseMenuActive() then
            inshop = true
        else 
            inshop = false
        end
        if inshop == true then
            Wait(1000)
            ESX.TriggerServerCallback("Cards:server:Menu",function(item,amount)
                print(item,amount)
            end)
        end
    end 
end)

RegisterNetEvent("qb-pokemontcg:client:badgesound")
AddEventHandler("qb-pokemontcg:client:badgesound", function()
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "badge", 0.8)
end)

--------------------------------------------------------
----------------MENU---------------------------------

--Config

local menu = MenuV:CreateMenu(false, 'Player Items', 'topright', 155, 0, 0, 'size-125', 'none', 'menuv', 'test3')
local menu2 = menu:InheritMenu({title = false, subtitle = 'Card Shop', theme = 'default' })
local menu_button = menu:AddButton({ icon = '🔖', label = 'Sell Cards/Badges', value = menu2, description = 'View List Of Items' })


--------------------------------------------------------------------


RegisterNetEvent('Cards:client:openMenu')
AddEventHandler('Cards:client:openMenu', function()
    MenuV:OpenMenu(menu)
end)

menu_button:On('select', function(item)
    menu2:ClearItems(true)
    ESX.TriggerServerCallback('Cards:server:get:drugs:items', function(CardsResult)
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

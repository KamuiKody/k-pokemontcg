local QBCore = exports['qb-core']:GetCoreObject()
local Ped = {}
local Shops = {}
local Badges = {}
local gen = false
local pedSpawned = false

local function Open(type)
    QBCore.Functions.TriggerCallback('pokemon:cb:openitem', function(cb) 
        if cb ~= false then       
            QBCore.Functions.Progressbar("open_stuff"..type, Config.Opening[type].label, Config.Opening[type].time, false, false, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
                disableInventory = true,
            }, {
                animDict = Config.Opening[type].dict,
                anim = Config.Opening[type].animation,
                flags = 17,
            }, {
                model = Config.Opening[type].prop,
                bone = GetPedBoneIndex(PlayerPedId(), 0xDEAD),
                coords = { x = Config.Opening[type]['coords'].x, y = Config.Opening[type]['coords'].y, z = Config.Opening[type]['coords'].y },
                rotation = { x = Config.Opening[type]['rot'].x, y = Config.Opening[type]['rot'].y, z = Config.Opening[type]['rot'].z },
            }, {}, function()-- Done
                TriggerServerEvent("InteractSoundfSV:PlayOnSource", Config.Opening[type].audio, 0.6) 
                Wait(0)
                if cb == 'cards' then
                    gen = type
                    TriggerEvent('cards:focus', gen)
                elseif cb == 'packs' then
                    QBCore.Functions.Notify('You got 4 card(s).')
                else
                    TriggerEvent('cards:opendeckbox', cb)
                end
            end)
        end
    end, type)
end

local function TradeBadge(type)
    QBCore.Functions.TriggerCallback('pokemon:cb:badgetrade', function(cb)
        if cb then
            QBCore.Functions.Notify('You got a '..QBCore.Shared.Items[type].label, 'success', 5000)
            TriggerServerEvent("InteractSound_SV:PlayOnSource", Config.BadgeAudio, 0.6) 
        end
    end, type)
end

local function OpenShop(type)
    local menu = {
        {
            header = 'Open Shop',
            isMenuHeader = true
        },
        {
            header = 'Buy Shop',
            params = {
                event = 'pokemon:buyshop',
                args = {
                    location = type
                }
            }
        },
        {
            header = 'Sell Shop',
            params = {
                event = 'pokemon:sellshop'
            }
        }
    }
    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent('pokemon:buyshop', function()
    QBCore.Functions.TriggerCallback('pokemon:cb:getshopitems', function(ShopItems)
        ShopItems.slots = #Config.ShopItems
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "PokeShop", ShopItems)        
    end)
end)

RegisterNetEvent('pokemon:sellshop', function()
    QBCore.Functions.TriggerCallback('pokemon:cb:getshopitems', function(cb)
        local sellitems = {
            {
                header = '| Sell Shop |',
                isMenuHeader = true
            }
        }
        for k,v in pairs(cb) do            
            sellitems[#sellitems + 1] = {
                header = QBCore.Shared.Items[k].label,
                txt = '[x'..v.amount..']  $'..v.value,
                params = {
                    event = 'pokemon:sellamount',
                    args = {
                        item = k,
                        amount = v.amount,
                        value = v.value
                    }
                }
            }
        end
        for k,v in pairs(cb) do            
            sellitems[#sellitems + 1] = {
                header = QBCore.Shared.Items[k].label,
                txt = '[x'..v.amount..']  $'..v.value,
                params = {
                    event = 'pokemon:sellamount',
                    args = {
                        item = k,
                        amount = v.amount,
                        value = v.value
                    }
                }
            }
        end
        exports['qb-menu']:openMenu(sellitems)
    end)
end)

RegisterNetEvent('pokemon:sellamount', function(data)
    local sellamount = {
        {
            header = '| '..QBCore.Shared.Items[data.item].label..' |',
            isMenuHeader = true
        }
    }
    local amount = 0
    for i = 1,data.amount,1 do  
        amount = amount + 1
        local reward = (amount * data.value)
        sellamount[#sellamount + 1] = {
        header = 'Sell '..amount,
        txt = 'for  $'..reward,
        params = {
            event = 'pokemon:sellcards',
            args = {
                item = data.item,
                amount = amount,
                value = reward
            }
        }
    }
    end
    exports['qb-menu']:openMenu(sellamount)
end)

RegisterNetEvent('pokemon:sellcards', function(data)
    QBCore.Functions.TriggerCallback('pokemon:cb:sellitem', function(cb)
        if cb then
            QBCore.Functions.Notify('You Sold Your Items', 'success', 5000)
        end
    end)
end)

local function createPeds()
    if pedSpawned then return end
    for k, v in pairs(Config.Locations) do
        if v['ped'] then
            if k ~= 'badges' then
                if not Ped[k] then Ped[k] = {} end
                local current = v["ped"]
                current = type(current) == 'string' and GetHashKey(current) or current
                RequestModel(current)
                while not HasModelLoaded(current) do
                    Wait(0)
                end
                Ped[k] = CreatePed(0, current, v["location"].x, v["location"].y, v["location"].z-1, v["location"].w, false, false)
                FreezeEntityPosition(Ped[k], true)
                SetEntityInvincible(Ped[k], true)
                SetBlockingOfNonTemporaryEvents(Ped[k], true)
                if Config.UseTarget then
                    exports[Config.Target]:AddTargetEntity(Ped[k], {
                        options = {
                            {
                                label = v["label"],
                                icon = "fa-solid fa-cash-register",
                                action = function()
                                    OpenShop(k)
                                end,
                            }
                        },
                        distance = 2.0
                    })
                end
            else
                for i = 1,#Config.Badge,1 do
                    for f,u in pairs(Config.Badge[i]) do
                        if not Ped[f] then Ped[f] = {} end
                            local current = u["ped"]
                            current = type(current) == 'string' and GetHashKey(current) or current
                            RequestModel(current)
                            while not HasModelLoaded(current) do
                                Wait(0)
                            end
                            Ped[f] = CreatePed(0, current, u["location"].x, u["location"].y, u["location"].z-1, u["location"].w, false, false)
                            FreezeEntityPosition(Ped[f], true)
                            SetEntityInvincible(Ped[f], true)
                            SetBlockingOfNonTemporaryEvents(Ped[f], true)
                            if Config.UseTarget then
                                exports[Config.Target]:AddTargetEntity(Ped[f], {
                                    options = {
                                        {
                                            label = u["label"],
                                            icon = "fa-solid fa-cash-register",
                                            action = function()
                                                TradeBadge(f)
                                            end,
                                        }
                                    },
                                    distance = 2.0
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    pedSpawned = true
end


function CreateBlips()
    if Config.Locations['badges']['blip'] then
        for i = 1,#Config.Badge,1 do
            for k, v in pairs(Config.Badge[i]) do  
                local x,y,z,w = table.unpack(v.location)        
                local blip = AddBlipForCoord(x,y,z)
                SetBlipAsShortRange(blip, true)
                SetBlipSprite(blip, Config.Locations['badges']['sprite'])
                SetBlipColour(blip, Config.Locations['badges']['color'])
                SetBlipScale(blip, Config.Locations['badges']['size'])
                SetBlipDisplay(blip, 6)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(QBCore.Shared.Items[k].label)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
    if Config.Locations['shop']['blip'] then
        for k, v in pairs(Config.Locations['shop']['locations']) do
            local x,y,z,w = table.unpack(v)        
            local blip = AddBlipForCoord(x,y,z)
            SetBlipAsShortRange(blip, true)
            SetBlipSprite(blip, Config.Locations['shop']['sprite'])
            SetBlipColour(blip, Config.Locations['shop']['color'])
            SetBlipScale(blip, Config.Locations['shop']['size'])
            SetBlipDisplay(blip, 6)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Config.Locations['shop']['label'])
            EndTextCommandSetBlipName(blip)
        end
    end
end

local function Listen4Control(type,zone)
    CreateThread(function()
        listen = true
        while listen do
            if IsControlJustPressed(0, 38) then -- E
                exports["qb-core"]:KeyPressed()
                local Player = QBCore.Functions.GetPlayerData()
                local source = Player.source
                if type == 'shop' then
                    OpenShop(zone)
                else
                    TradeBadge(zone)
                end
                listen = false
                break
            end
            Wait(1)
        end
    end)
end

CreateThread(function()
    CreateBlips()
    createPeds()
end)

CreateThread(function()
    if not Config.UseTarget then
        for k,v in pairs(Config.Locations['shop']['locations']) do
            local x,y,z = table.unpack(v)
            Shops[#Shops+1] = CircleZone:Create(vector3(x, y, z), 3, {
                useZ = true,
                debugPoly = false,
                name = k,
            })
        end
        local ShopCombo = ComboZone:Create(Shops, {name = "RandomZOneName", debugPoly = false})
        ShopCombo:onPlayerInOut(function(isPointInside, f, zone)
            if isPointInside then
                currentShop = zone.name
                exports["qb-core"]:DrawText('[E] Open Shop')
                Listen4Control('shop',currentShop)
            else
                exports["qb-core"]:HideText()
                listen = false
            end
        end)
        for i = 1,#Config.Badge,1 do
            for k,v in pairs(Config.Badge[i]) do
                local x,y,z = table.unpack(v.location)
                Badges[#Badges+1] = CircleZone:Create(vector3(x, y, z), 3, {
                    useZ = true,
                    debugPoly = false,
                    name = k,
                })
            end
        end
        local BadgeCombo = ComboZone:Create(Badges, {name = "RandomZOneName", debugPoly = false})
        BadgeCombo:onPlayerInOut(function(isPointInside, f, zone)
            if isPointInside then
                currentShop = zone.name
                exports["qb-core"]:DrawText('[E] To trade for '..QBCore.Shared.Items[zone.name].label)
                Listen4Control('badge',currentShop)
            else
                exports["qb-core"]:HideText()
                listen = false
            end
        end)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    createPeds()
end)

RegisterNetEvent('pokemon:client:useitem', function(type)
    Open(type)
end)

RegisterNetEvent('pokemon:client:viewcard', function(item)
    SetNuiFocus(true, true)
    SendNUIMessage({
        open = true,
        class = 'card',
        data = item,
    })
end)

RegisterNetEvent('cards:focus', function(gen)
    gen = gen
    SetNuiFocus(true, true)
    SendNUIMessage({
        open = true,
        class = 'open',
    })
end)

RegisterNUICallback('Rewardpokemon', function(data)
    local pokemon = data.Pokemon    
    TriggerServerEvent("InteractSound_SV:PlayOnSource", Config.CardFlipAudio, 0.6)
    TriggerServerEvent('Cards:Server:GetPokemon', pokemon)
end)

RegisterNUICallback('randomCard', function()
    local type = gen
    TriggerServerEvent('Cards:Server:rewarditem', type)
end)

RegisterNUICallback('CloseNui', function()
    gen = false
    SetNuiFocus(false, false)
end)

RegisterNetEvent("Cards:Client:pickedcard", function(card)
    SendNUIMessage({
        open = true,
        class = 'choose',
        data = card,
    }) 
end)

RegisterNetEvent('cards:opendeckbox', function(BagId)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pokebox_"..BagId, {maxweight = Config.BoxWeight, slots = Config.BoxCapacity})
    TriggerEvent("inventory:client:SetCurrentStash", "pokebox_"..BagId)
end)
local QBCore = exports['qb-core']:GetCoreObject()
local shopitems = {}
local slots = 0
local itemTypes = {'Cards', 'Badge'}

local function GiveCardBox(id)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Config.BoxPrice) then
        local info = {
            bagid = math.random(11111,99999)
        }
        Player.Functions.AddItem("pokebox", 1, false, info)
        TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items["pokebox"], "add")
    end
end
exports('GiveCardBox', GiveCardBox)

RegisterServerEvent('cards:server:givebox', function()
    local src = source
    GiveCardBox(src)
end)

CreateThread(function()
    math.randomseed(os.time())
end)

RegisterServerEvent('Cards:Server:rewarditem', function(gen)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pack = Player.Functions.GetItemByName("boosterpack")
    local card = ''
    local randomChance = math.random(1, 1000)
    if randomChance <= 1 then 
        card = Config.Cards[gen]['rainbowCards'][math.random(1,#Config.Cards[gen]['rainbowCards'])]         
	elseif randomChance >= 2 and randomChance <= 5 then
        card = Config.Cards[gen]['vmaxCards'][math.random(1, #Config.Cards[gen]['vmaxCards'])]
	elseif randomChance >= 6 and randomChance <= 20 then
        card = Config.Cards[gen]['vCards'][math.random(1, #Config.Cards[gen]['vCards'])]
	elseif randomChance >= 21 and randomChance <= 50 then
        card = Config.Cards[gen]['ultraCards'][math.random(1, #Config.Cards[gen]['ultraCards'])]
    elseif randomChance >= 51 and randomChance <= 250 then
        card = Config.Cards[gen]['rareCards'][math.random(1, #Config.Cards[gen]['rareCards'])]
    else 
        card = Config.Cards[gen]['basicCards'][math.random(1, #Config.Cards[gen]['basicCards'])]
	end
    Wait(0)
    if card ~= '' then        
        TriggerClientEvent('Cards:Client:pickedcard', src, card)
    else
        TriggerClientEvent('QBCore:Notify', src, 'There is a problem in cards!')
    end 
end)

AddEventHandler('onResourceStart', function(GetCurrentResourceName())
        shopitems = Config.ShopItems
end)


QBCore.Functions.CreateCallback('pokemon:cb:getshopitems', function(source, cb)
    local ShopItems = {}
    for i = 1,#shopitems,1 do
        ShopItems.items[#ShopItems.items + 1] = shopitems[i]
    end
    Wait(0)
    cb(ShopItems)
end)

QBCore.Functions.CreateCallback('pokemon:cb:sellitem', function(source, cb, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(data.item,data.amount) then
        Player.Functions.AddMoney('cash', data.value)
        cb(true)
    else
        cb(false)
        TriggerClientEvent('QBCore:Notify', src, 'There is a problem in cards!')
    end
end)

QBCore.Functions.CreateCallback('pokemon:cb:getshopitems', function(source, cb, type)
    local src = source
    local items = {}
    local Player = QBCore.Functions.GetPlayer(src)
    for i = 1,#Config.Cards,1 do
        for u = 1,#Config.Cards[i],1 do
            for k,v in pairs(Config.Cards[i][u]) do
                local item = Player.Functions.GetItemsByName(k)
                if item ~= nil then
                    item[k] = {
                        amount = item.amount,
                        img = Config.Cards[i][u][k].img,
                        value = Config.Cards[i][u][k].value
                    }
                end
            end
        end
    end
    for i = 1,#Config.Badge,1 do
        for k,v in pairs(Config.Badge[i]) do
            local item = Player.Functions.GetItemsByName(k)
            if item ~= nil then
                item[k] = {
                    amount = item.amount,
                    img = Config.Badge[i][k].img,
                    value = Config.Badge[i][k].value
                }
            end
        end
    end
    cb(items)
end)

QBCore.Functions.CreateCallback('pokemon:cb:openitem', function(source, cb, type)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Config.Opening[type].storage then
        if Player.Functions.RemoveItem(type,1) then
            if Config.Opening[type].cards then
                cb('cards')
            else
                cb('packs')
                Player.Functions.AddItem(Config.Opening[type].packtype, Config.Opening[type].packamount)
                TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[type], "remove")
                TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.Opening[type].packtype], "add")
            end
        else
            cb(false)
            -- notify no packs... exploit or bug
        end
    else
        local item = Player.Functions.GetItemByName(Config.Opening[type])
        if item ~= nil then
            cb(item.info.bagid)
        else
            -- notify no box... exploit or bug
        end
    end
end)

QBCore.Functions.CreateCallback('pokemon:cb:badgetrade', function(source, cb, type)
    local Player = QBCore.Functions.GetPlayer(source)
    local Trade = true
    local items = {}
    for i = 1,#Config.Badge,1 do
        for k,v in pairs(Config.Badge[i]) do 
            if k == type then
                if Config.Badge[i][k].proveitem ~= false then
                    local item = Player.Functions.GetItemByName(Config.Badge[i][k].proveitem)
                    if item == nil then
                        Trade = false
                        TriggerClientEvent('QBCore:Notify', source, 'You need a '..QBCore.Shared.Items[Config.Badge[i][k].proveitem].label, 'error', 5000) 
                    end
                end
                if Trade then
                    for u,s in ipairs(Config.Badge[i][k].cards) do
                        local card = Player.Functions.GetItemByName(u)
                        if card.amount < s then 
                            Trade = false
                            TriggerClientEvent('QBCore:Notify', source, 'You need a '..QBCore.Shared.Items[u].label, 'error', 5000) 
                        else
                            items[u] = s  
                        end                      
                    end
                end
            end
        end
    end
    Wait(0)
    if Trade then
        for k,v in pairs(items) do
            if Player.Functions.RemoveItem(k,v) then
            else
                Trade = false
            end
        end
    end
    Wait(0)
    if Trade then
        Player.Functions.AddItem(type, 1)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[type], "add")
        cb(true)
    else
        cb(false)
    end 
end)

QBCore.Functions.CreateUseableItem("boosterbox", function(source, item)
    local src = source
    TriggerClientEvent('pokemon:client:useitem', src, item.name)
end)

QBCore.Functions.CreateUseableItem("boosterpack", function(source, item)
    local src = source
    TriggerClientEvent('pokemon:client:useitem', src, item.name)
end)

QBCore.Functions.CreateUseableItem("pokebox", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemSlot = item.slot
    if item.info.bagid == nil then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            local info = {
                bagid = math.random(11111,99999)
            }
            Player.Functions.AddItem("pokebox", 1, itemSlot, info)
        else
            print('qb:pokemon-bag error-dev notes...')
        end
    end
    local newitem = Player.Functions.GetItemBySlot(itemSlot)
    TriggerClientEvent('pokemon:client:useitem', src, newitem.name)
end)

for x = 1,2 do
    for i = 1,#Config[itemTypes[i]],1 do
        for k,v in pairs(Config.Badge[i]) do
	    QBCore.Functions.CreateUseableItem(k, function(source, item)
	        local src = source
	        TriggerClientEvent('pokemon:client:viewcard', src, item.name)
	    end)
        end
    end
end

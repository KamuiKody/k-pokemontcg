local cards = {}
local triggers = {}

local function cardDistribution(item, cid)
    local rand = math.random(1,1000)
    local tier = nil
    for k,v in pairs(Config.Tiers) do
        if v.min <= rand then
            if v.max >= rand then
                tier = k
            end
        end
    end
    for i = 1,#Config.Items do
        if Config.Items[i].card then
            if Config.Items[i].series == item then
                if Config.Items[i].tier == tier then
                    cards[cid][#cards[cid] + 1] = Config.Items[i].name
                end
            end
        end
    end
    local card = cards[cid][math.random(1,#cards[cid])]
    return card
end

RegisterNetEvent('k-pokemontcg:syncCard', function(card, player2)
    TriggerClientEvent('k-pokemontcg:showCard', player2, card)
end)

RegisterNetEvent('k-pokemontcg:success', function(cid)
    if not triggers[cid] then
        triggers[cid] = true
    else
        triggers[cid] = nil
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for k,v in pairs(Config.Items) do
        exports['qb-core']:AddItem(k,v)
        QBCore.Functions.CreateUseableItem(k, function(source, item)
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            local cid = Player.PlayerData.citizenid
            if not Player.Functions.GetItemByName(item.name) then return end
            if v.pack then
                if cards[cid] then return end
                if not Player.Functions.RemoveItem(item.name, 1) then return end
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item.name], "used")
                triggers[cid] = nil
                TriggerClientEvent('k-pokemontcg:progress', src, 'pack')
                local cardlist = {}
                for i = 1,v.reward.amount do
                   cardlist[#cardlist + 1] = cardDistribution(item.name, cid)
                end
                Wait(Config.Progress['pack'].time + 500)
                if triggers[cid] then
                    triggers[cid] = nil
                    TriggerClientEvent('k-pokemontcg:showUI', src, cardlist)
                    for _,v in pairs(cardlist) do
                        Player.Functions.AddItem(v, 1)
                    end
                    cards[cid] = nil
                else
                    cards[cid] = nil
                end
            elseif v.box then
                if not Player.Functions.RemoveItem(item.name, 1) then return end
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item.name], "used")
                triggers[cid] = nil
                TriggerClientEvent('k-pokemontcg:progress', src, 'box')
                Wait(Config.Progress['box'].time)
                if triggers[cid] then
                    triggers[cid] = nil
                    Player.Functions.AddItem(v.reward.item, v.reward.amount)
                    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item.name], "add")
                    cards[cid] = nil
                else
                    cards[cid] = nil
                end
            elseif v.card then
                TriggerClientEvent('k-pokemontcg:showCard', src, item.name, true)
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item.name], "used")
            elseif v.holder then
                TriggerEvent("InteractSound_SV:PlayOnSource", "snap", 1.2)
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item.name], "used")
                TriggerEvent("inventory:server:OpenInventory", "stash", "pokebox_"..item.info.bagid, {maxweight = 99000, slots = 150})
                TriggerClientEvent("inventory:client:SetCurrentStash", src, "pokebox_"..item.info.bagid)
            end
        end)
    end
end)
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('k-pokemontcg:progress', function(type)
    QBCore.Functions.Progressbar("use_bag", QBShared.FirstToUpper(type).." is being opened", Config.Progress[type].time, false, false, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mp_arresting",
        anim = "a_uncuff",
        flags = 17
    }, {
        model = Config.Progress[type].prop,
        bone = Config.Progress[type].bone,
        coords = Config.Progress[type].pos,
        rotation = Config.Progress[type].rot,
    }, {}, function()
        TriggerServerEvent('k-pokemontcg:success', QBCore.Functions.GetPlayerData().citizenid)
    end)
end)

RegisterNetEvent('k-pokemontcg:showUI', function(cardlist)
    SendNUIMessage({action = 'cardFlip', cards = cardlist})
    SetNuiFocus(true,true)
end)

RegisterNetEvent('k-pokemontcg:showCard', function(card, searchPlayer)
    if searchPlayer then
        local closestPlayer, distance = QBCore.Functions.GetClosestPlayer()
        if distance < 7 then
            TriggerServerEvent('k-pokemontcg:syncCard', card, GetPlayerServerId(closestPlayer))
        end
    end
    SendNUIMessage({action = 'cardShow', cards = card})
    SetNuiFocus(true,true)
end)
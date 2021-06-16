QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local basicCards = {"bulbasaur", "ivysaur", "charmander", "charmeleon", "squirtle", "wartortle", "caterpie", "metapod", "butterfree", "weedle", "kakuna", "beedrill", "pidgey","pidgeotto", "pidgeot", "rattata", "raticate", "spearow", "fearow", "ekans", "arbok", "pikachu", "sandshrew", "sandslash", "nidoran", "nidorina", "nidoqueen", "nidorino", "clefairy","clefable", "vulpix", "ninetales", "zubat", "golbat", "oddish", "gloom", "vileplume", "paras", "parasect", "venonat", "venomoth", "diglett", "dugtrio", "meowth", "persian", "psyduck","golduck", "mankey", "primeape", "growlithe", "arcanine", "poliwag", "poliwhirl", "poliwrath", "abra","machop", "machoke", "bellsprout", "weepinbell", "victreebel", "tentacool","tentacruel", "geodude", "graveler", "golem", "ponyta", "rapidash", "slowpoke", "slowbro", "magnemite", "magneton", "farfetchd", "doduo", "dodrio", "seel", "dewgong", "grimer", "muk", "shellder", "cloyster","gastly", "haunter", "gengar", "drowzee", "hypno", "krabby", "kingler", "voltorb", "electrode", "exeggcute", "exeggutor", "cubone", "marowak", "lickitung", "koffing", "weezing", "rhyhorn", "rhydon", "chansey", "tangela", "horsea", "seadra", "goldeen", "seaking", "staryu", "mr mime",  "electabuzz", "magmar", "pinsir", "tauros", "magikarp"}
local rareCards = {"lapras", "eevee", "togepi", "vaporeon", "jolteon", "flareon", "jigglypuff","wigglytuff", "kadabra","raichu", "nidoking",  "jynx", "kangaskhan", "gyarados","ditto","starmie", "onix", "machamp", "scyther", "hitmonlee", "hitmonchan", "venusaur" }
local ultraCards = {"charizard", "blastoise","porygon", "omanyte", "omastar", "dragonite", "mewtwo", "mew", "snorlax", "articuno", "zapdos", "kabuto", "kabutops", "aerodactyl", "moltres", "dratini", "dragonair"}
local vCards = {"blastoisev", "charizardv", "mewv", "pikachuv", "snorlaxv", "venusaurv"}
local vmaxCards = {"blastoisevmax", "mewtwogx", "snorlaxvmax", "venusaurvmax", "vmaxcharizard", "vmaxpikachu"}
local rainbowCards = {"rainbowmewtwogx", "rainbowvmaxcharizard", "rainbowvmaxpikachu", "snorlaxvmaxrainbow"}

QBCore.Functions.CreateUseableItem("boosterbox", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot, item.info) then
        TriggerClientEvent("Cards:Client:OpenCards", source, item.name)
			local xPlayer = QBCore.Functions.GetPlayer(source)
				xPlayer.Functions.AddItem('boosterpack',4)
           Citizen.Wait(4000)
        TriggerClientEvent('QBCore:Notify', source, 'You got 4 booster packs!')
            Citizen.Wait(1000)
    end
end)

QBCore.Functions.CreateCallback("Cards:server:Menu",function(source,cb)
    local player = QBCore.Functions.GetPlayer(source)
    local item = "...."
        if player ~= nil then
            if player.Functions.GetItemByName(item) then
            cb(item,item.amount)
        end
    end
end)

RegisterCommand('pokemon', function(source)
    TriggerClientEvent("Cards:client:openMenu")
end)

QBCore.Functions.CreateUseableItem("boosterpack", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)    
        TriggerClientEvent("Cards:Client:OpenPack", source, item.name)
            Citizen.Wait(4000)
        TriggerClientEvent('QBCore:Notify', source, 'You got 4 cards!')
end)

RegisterServerEvent('Cards:Server:rewarditem')
AddEventHandler('Cards:Server:rewarditem', function(listKey)
    local Player = QBCore.Functions.GetPlayer(source)
    local pack = Player.Functions.GetItemByName("boosterpack")
	    if pack.amount == nil then
		TriggerClientEvent('QBCore:Notify', source, 'You dont have a boosterpack!')
    else
        Player.Functions.RemoveItem('boosterpack',1)
        for i=1, 4 do
        local randomChance = math.random(1, 1000)
            if randomChance <= 5 then 
                local card = rainbowCards[math.random(1,#rainbowCards)]
                TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[card], "add")
                    Player.Functions.AddItem(card, 1)
                    Citizen.Wait(500)
		    elseif randomChance >= 6 and randomChance <= 19 then
                local card = vmaxCards[math.random(1, #vmaxCards)]
                TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[card], "add")
                    Player.Functions.AddItem(card, 1)
                    Citizen.Wait(500)
		    elseif randomChance >= 20 and randomChance <= 50 then
                local card = vCards[math.random(1, #vCards)]
                TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[card], "add")
                    Player.Functions.AddItem(card, 1)
                    Citizen.Wait(500)
		    elseif randomChance >= 51 and randomChance <= 100 then
                local card = ultraCards[math.random(1, #ultraCards)]
                TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[card], "add")
                    Player.Functions.AddItem(card, 1)
                    Citizen.Wait(500)
            elseif randomChance >= 101 and randomChance <= 399 then
                local card = rareCards[math.random(1, #rareCards)]
                TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[card], "add")
                    Player.Functions.AddItem(card, 1)
                    Citizen.Wait(500)
            else 
                local card = basicCards[math.random(1, #basicCards)]
                TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[card], "add")
                    Player.Functions.AddItem(card, 1)
                    Citizen.Wait(500)
			end
        end
    end   
end)

RegisterServerEvent("Cards:server:badges")
AddEventHandler("Cards:server:badges", function(type)
    if badge[type] ~= nil then
        local total = 0
        local Player = QBCore.Functions.GetPlayer(source)
        for i = 1, #badge[type].cards do
            local card = Player.Functions.GetItemByName(badge[type].cards[i])
            if card == nil then
                TriggerClientEvent('QBCore:Notify', source, 'You dont have '..badge[type].cards[i]..'!')
            else
                if card.amount < 1 then
                    TriggerClientEvent('QBCore:Notify', source, 'You dont have '..badge[type].cards[i]..'!')
                else
                    total = total + 1
                end
            end
        end
        Citizen.Wait(1000)
        if total == #badge[type].cards then
            for i = 1, #badge[type].cards do
                Player.Functions.RemoveItem(badge[type].cards[i], 1)
                TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[badge[type].cards[i]], "remove")
            end
            Player.Functions.AddItem(badge[type].reward, 1)
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[badge[type].reward], "add")
            TriggerClientEvent('QBCore:Notify', source, 'You got a '..badge[type].label..'!')	
        else
            TriggerClientEvent('QBCore:Notify', source, 'Come back when you have all the items!')
        end	
    end
end)

QBCore.Functions.CreateUseableItem("pokebox", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("Cards:client:UseBox", source)
    TriggerEvent("qb-log:server:CreateLog", "pokebox", "PokeBox", "white", "Player Opened The Box **"..GetPlayerName(source).."** Citizen ID : **"..Player.PlayerData.citizenid.. "**", false)
end)

function CanItemBeSaled(item)
    local retval = false
    if Config.AllowedItems[item] ~= nil then
        retval = true
    end
    return retval
end

RegisterServerEvent("Cards:sellItem")
AddEventHandler("Cards:sellItem", function(itemName, amount, price)
	local xPlayer = QBCore.Functions.GetPlayer(source)
    
    if xPlayer.Functions.RemoveItem(itemName, amount) then
        xPlayer.Functions.AddMoney('cash', price, 'Card-sell')
        TriggerClientEvent("QBCore:Notify", source, "You sold " .. amount .. " " .. itemName .. " for $" .. price, "success", 500)
    end
end)


QBCore.Functions.CreateCallback('Cards:server:get:drugs:items', function(source, cb)
    local src = source
    local AvailableDrugs = {}
    local Player = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.CardshopItems) do
        local DrugsData = Player.Functions.GetItemByName(k)
        if DrugsData ~= nil then
            table.insert(AvailableDrugs, {['Item'] = DrugsData.name, ['Amount'] = DrugsData.amount})
        end
    end
    cb(AvailableDrugs)
end)


function tprint (t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            tprint(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
end 
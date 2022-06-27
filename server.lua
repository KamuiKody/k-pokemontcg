local basicCards = {"bulbasaur", "ivysaur", "charmander", "charmeleon", "squirtle", "wartortle", "caterpie", "metapod", "butterfree", "weedle", "kakuna", "beedrill", "pidgey","pidgeotto", "pidgeot", "rattata", "raticate", "spearow", "fearow", "ekans", "arbok", "pikachu", "sandshrew", "sandslash", "nidoran", "nidorina", "nidoqueen", "nidorino", "clefairy","clefable", "vulpix", "ninetails", "zubat", "golbat", "oddish", "gloom", "vileplume", "paras", "parasect", "venonat", "venomoth", "diglett", "dugtrio", "meowth", "persian", "psyduck","golduck", "mankey", "primeape", "growlithe", "arcanine", "poliwag", "poliwhirl", "poliwrath", "abra","machop", "machoke", "bellsprout", "weepinbell", "victreebel", "tentacool","tentacruel", "geodude", "graveler", "golem", "ponyta", "rapidash", "slowpoke", "slowbro", "magnemite", "magneton", "farfetchd", "doduo", "dodrio", "seel", "dewgong", "grimer", "muk", "shellder", "cloyster","gastly", "haunter", "gengar", "drowzee", "hypno", "krabby", "kingler", "voltorb", "electrode", "exeggcute", "exeggutor", "cubone", "marowak", "lickitung", "koffing", "weezing", "rhyhorn", "rhydon", "chansey", "tangela", "horsea", "seadra", "goldeen", "seaking", "staryu", "mrmime",  "electabuzz", "magmar", "pinsir", "tauros", "magikarp"}
local rareCards = {"lapras", "eevee", "togepi", "vaporeon", "jolteon", "flareon", "jigglypuff","wigglytuff", "kadabra","raichu", "nidoking",  "jynx", "kangaskhan", "gyarados","ditto","starmie", "onix", "machamp", "scyther", "hitmonlee", "hitmonchan", "venusaur" }
local ultraCards = {"charizard", "blastoise","porygon", "omanyte", "omastar", "dragonite", "mewtwo", "mew", "snorlax", "articuno", "zapdos", "kabuto", "kabutops", "aerodactyl", "moltres", "dratini", "dragonair"}
local vCards = {"blastoisev", "charizardv", "mewv", "pikachuv", "snorlaxv", "venusaurv"}
local vmaxCards = {"blastoisevmax", "mewtwogx", "snorlaxvmax", "venusaurvmax", "vmaxcharizard", "vmaxpikachu"}
local rainbowCards = {"rainbowmewtwogx", "rainbowvmaxcharizard", "rainbowvmaxpikachu", "snorlaxvmaxrainbow"}

ESX.RegisterUsableItem("boosterbox", function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.removeInventoryItem(item.name, 1) then
        TriggerClientEvent("Cards:Client:OpenCards", source, item.name)
		xPlayer.addInventoryItem('boosterpack', 4)
        Wait(4000)
        xPlayer.showNotification('You got 4 booster packs!')
        Wait(1000)
    end
end)

ESX.RegisterServerCallback("Cards:server:Menu",function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = "...."
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem(item) then
            cb(item,item.amount)
        end
    end
end)

ESX.RegisterUsableItem("boosterpack", function(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)  
    TriggerClientEvent("Cards:Client:OpenPack", source)  
    Wait(4000)
    xPlayer.showNotification('You got 4 cards!')
end)

RegisterServerEvent('Cards:Server:RemoveItem')
AddEventHandler('Cards:Server:RemoveItem', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local pack = xPlayer.getInventoryItem("boosterpack")

    if pack.amount == nil then
        xPlayer.showNotification('You dont have a boosterpack!')
    else
        xPlayer.removeInventoryItem('boosterpack', 1)
    end
  
end)

CreateThread(function()
    math.randomseed(os.time())
end)

RegisterServerEvent('Cards:Server:rewarditem')
AddEventHandler('Cards:Server:rewarditem', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local pack = xPlayer.getInventoryItem("boosterpack")
    local card = ''

    local randomChance = math.random(1, 1000)
   -- print(randomChance) -- if you wanna see the random chance
    if randomChance <= 5 then 
        card = rainbowCards[math.random(1,#rainbowCards)]         
	elseif randomChance >= 6 and randomChance <= 19 then
        card = vmaxCards[math.random(1, #vmaxCards)]

	elseif randomChance >= 20 and randomChance <= 50 then
        card = vCards[math.random(1, #vCards)]

	elseif randomChance >= 51 and randomChance <= 100 then
        card = ultraCards[math.random(1, #ultraCards)]

    elseif randomChance >= 101 and randomChance <= 399 then
        card = rareCards[math.random(1, #rareCards)]
    else 
        card = basicCards[math.random(1, #basicCards)]
	end

    Wait(10)
    --print(card)

    if card ~= '' then        
        TriggerClientEvent('Cards:Client:CardChoosed', source, card)
    else
        xPlayer.showNotification('There is a problem in cards!')
    end 
end)

RegisterServerEvent('Cards:Server:GetPokemon')
AddEventHandler('Cards:Server:GetPokemon', function(pokemon)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local pokemonName = ESX.GetItemLabel(pokemon) -- May be wrong
    if pokemon ~= nil then 
        xPlayer.showNotification("You got "..pokemonName.. "")
        xPlayer.addInventoryItem(pokemon, 1)
    end  
end)

RegisterServerEvent("Cards:server:badges")
AddEventHandler("Cards:server:badges", function(type)
    local source = source
    local total = 0
    local canBadge = true
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(Config.Badge[type].cards) do 
        if xPlayer.getInventoryItem(k) ~= nil then 
            if xPlayer.getInventoryItem(k).amount < v then 
                canBadge = false
                xPlayer.showNotification('Come back when you have all the items for the '..Config.Badge[type].label.. '')
            end
        else 
            canBadge = false
            xPlayer.showNotification('Come back when you have all the items for the '..Config.Badge[type].label.. '')
            break                          
        end
    end
    if canBadge then 
        xPlayer.showNotification('You got a '..Config.Badge[type].label..'!')
        for k, v in pairs(Config.Badge[type].cards) do
            xPlayer.removeInventoryItem(k, v)
        end 
        Wait(2000)
        xPlayer.removeInventoryItem(type, 1)
    end 
end)

ESX.RegisterUsableItem("pokebox", function(source, item)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("Cards:client:UseBox", source)
    -- TriggerEvent("qb-log:server:CreateLog", "pokebox", "PokeBox", "white", "Player Opened The Box **"..GetPlayerName(source).."** Citizen ID : **"..Player.PlayerData.citizenid.. "**", false)
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
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.removeInventoryItem(itemName, amount) then
        xPlayer.addMoney(price)
        xPlayer.showNotification("You sold " .. amount .. " " .. itemName .. " for $" .. price)
    end
end)

ESX.RegisterServerCallback('Cards:server:get:drugs:items', function(source, cb)
    local source = source
    local AvailableDrugs = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(Config.CardshopItems) do
        local DrugsData = xPlayer.getInventoryItem(k)
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

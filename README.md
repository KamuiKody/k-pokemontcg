## Must have below added to qb-inventory for the box to have its own stash (This stash holds anything with 0 weight so make sure to have anything else that weighs 0 = 1 or something.)

## Client/Main.lua ##

# Under (around ln 35) # 
```lua

 if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end

--# Add this #


    elseif type == "pokeBox" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end

--################################################################

--# under this (around LN 736)#


    CurrentStash = stash
end)

--# Add this # 


RegisterNetEvent("inventory:client:SetCurrentPokeBox")
AddEventHandler("inventory:client:SetCurrentPokeBox", function(stash)
    CurrentStash = pokeBox
end)











```



##### Server/main.lua ###################
```lua
--# Under this (around line 67)


	if not IsOpen then
		if type == "stash" then
			Stashes[id].isOpen = false

--# add this # 


		elseif type == "pokeBox" then
			Stashes[id].isOpen = false

--# so it should look like this after -#


		elseif type == "pokeBox" then
			Stashes[id].isOpen = false
		elseif type == "trunk" then
			Trunks[id].isOpen = false
		elseif type == "glovebox" then

--###########################################################

-- Under this (line 134ish)

						Stashes[id].label = secondInv.label
					end
				end


-- add this # 


			elseif name == "pokeBox" then
				if Stashes[id] ~= nil then
					if Stashes[id].isOpen then
						local Target = QBCore.Functions.GetPlayer(Stashes[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('inventory:client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
						else
							Stashes[id].isOpen = false
						end
					end
				end
				local maxweight = 1
				local slots = 160
				if other ~= nil then 
					maxweight = other.maxweight ~= nil and other.maxweight or 1
					slots = other.slots ~= nil and other.slots or 160
				end
				secondInv.name = "stash-"..id
				secondInv.label = "Stash-"..id
				secondInv.maxweight = maxweight
				secondInv.inventory = {}
				secondInv.slots = slots
				if Stashes[id] ~= nil and Stashes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Stash-None"
					secondInv.maxweight = 1
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local stashItems = GetStashItems(id)
					if next(stashItems) ~= nil then
						secondInv.inventory = stashItems
						Stashes[id] = {}
						Stashes[id].items = stashItems
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					else
						Stashes[id] = {}
						Stashes[id].items = {}
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					end
				end

--#################################

-- Under this (line 344ish)
	end
	elseif type == "stash" then
		SaveStashItems(id, Stashes[id].items)

-- add this 
	elseif type == "pokeBox" then
		SaveStashItems(id, Stashes[id].items)


--#########################

-- under this (line 508ish)
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)


-- add this 


			elseif QBCore.Shared.SplitStr(toInventory, "-")[1] == "pokeBox" then  --- PokeBox
				local stashId = QBCore.Shared.SplitStr(toInventory, "-")[2]
				local toItemData = Stashes[stashId].items[toSlot]
				local IsItemValid = exports['pokeBox']:CanItemBeSaled(fromItemData.name:lower())
				if IsItemValid then
					Player.Functions.RemoveItem(fromItemData.name, fromAmount, fromSlot)
					TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
					--Player.PlayerData.items[toSlot] = fromItemData
					if toItemData ~= nil then
						--Player.PlayerData.items[fromSlot] = toItemData
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
						if toItemData.name ~= fromItemData.name then
							RemoveFromStash(stashId, fromSlot, itemInfo["name"], toAmount)
							Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, toItemData.info)
							TriggerEvent("qb-log:server:CreateLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
						end
					else
						local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
						TriggerEvent("qb-log:server:CreateLog", "stash", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
					end
					local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
					AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
				else 
					TriggerClientEvent('QBCore:Notify', src, "You can\'t Store this item in here..", 'error')

				end

--- #########################################

-- Under this (line 774ish)
		else
			TriggerClientEvent("QBCore:Notify", src, "Item doesn\'t exist??", "error")
		end

-- add this 
elseif QBCore.Shared.SplitStr(fromInventory, "-")[1] == "pokeBox" then
		local stashId = QBCore.Shared.SplitStr(fromInventory, "-")[2]
		local fromItemData = Stashes[stashId].items[fromSlot]
		local fromAmount = tonumber(fromAmount) ~= nil and tonumber(fromAmount) or fromItemData.amount
		if fromItemData ~= nil and fromItemData.amount >= fromAmount then
			local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.Functions.GetItemBySlot(toSlot)
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot)
						AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
						TriggerEvent("qb-log:server:CreateLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. stashId .. "*")
					else
						TriggerEvent("qb-log:server:CreateLog", "stash", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from stash: *" .. stashId .. "*")
					end
				else
					TriggerEvent("qb-log:server:CreateLog", "stash", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** stash: *" .. stashId .. "*")
				end
				SaveStashItems(stashId, Stashes[stashId].items)
				Player.Functions.AddItem(fromItemData.name, fromAmount, toSlot, fromItemData.info)
			else
				local toItemData = Stashes[stashId].items[toSlot]
				RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
				--Player.PlayerData.items[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
					--Player.PlayerData.items[fromSlot] = toItemData
					local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
					if toItemData.name ~= fromItemData.name then
						local itemInfo = QBCore.Shared.Items[toItemData.name:lower()]
						RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
						AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, toItemData.info)
					end
				else
					--Player.PlayerData.items[fromSlot] = nil
				end
				local itemInfo = QBCore.Shared.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, fromItemData.info)
			end
		else
			TriggerClientEvent("QBCore:Notify", src, "Item doesn\'t exist??", "error")
		end


---###########################################################
 

 -- Underthis (line 1642ish )
 			if Stashes[invId] ~= nil then 
				Stashes[invId].isOpen = false
			end
-- add this 
		elseif invType == "pokeBox" then
			if Stashes[invId] ~= nil then 
				Stashes[invId].isOpen = false
			end


























## for shared.lua ##

	["pokebox"]					 = {["name"] = "pokebox",					["label"] = "Pokemon TCG Box",				["weight"] = 500,		["type"] = "item",		["image"] = "pokeBox.png",			["unique"] = true,	["useable"] = true,	["shouldClose"] = true,		["combinable"] = nil,	["description"] = "Pokemon TCG Storage Box"},
	["boosterbox"] 					 = {["name"] = "boosterbox",		  	  		["label"] = "boosterbox", 				["weight"] = 200, 		["type"] = "item", 		["image"] = "boosterBox.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,		["combinable"] = nil,   ["description"] = "Box Of Card Packs"},
	["boosterpack"] 				 = {["name"] = "boosterpack", 			  	  	["label"] = "boosterpack", 				["weight"] = 45, 		["type"] = "item", 		["image"] = "boosterPack.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true, 	["combinable"] = nil,   ["description"] = "Pack of Cards"},
	["abra"] 					 = {["name"] = "abra", 			  			["label"] = "abra", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "abra.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "3/6 for Marsh Badge"},
	["aerodactyl"] 					 = {["name"] = "aerodactyl", 			  	  	["label"] = "aerodactyl", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "aerodactyl.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["alakazam"] 					 = {["name"] = "alakazam", 					["label"] = "alakazam", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "alakazam.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "1/6 for Marsh Badge"},
	["arbok"] 					 = {["name"] = "arbok", 			  	  	["label"] = "arbok", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "arbok.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["arcanine"] 					 = {["name"] = "arcanine", 				  	["label"] = "arcanine", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "arcanine.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = "1/6 for Volcano Badge"},
	["articuno"] 					 = {["name"] = "articuno", 			  		["label"] = "articuno", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "articuno.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["beedrill"] 					 = {["name"] = "beedrill", 			  	  	["label"] = "beedrill", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "beedrill.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["bellsprout"] 					 = {["name"] = "bellsprout", 			  	  	["label"] = "bellsprout", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "bellsprout.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "5/6 for Rainbow Badge"},
	["blastoise"] 					 = {["name"] = "blastoise", 			  	  	["label"] = "blastoise", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "blastoise.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "1/6 for Cascade Badge"},
	["boulderbadge"] 				 = {["name"] = "boulderbadge", 			 		["label"] = "boulderbadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "boulderBadge.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "1/8 for Trophy Badge"},
	["butterfree"] 					 = {["name"] = "butterfree", 			  		["label"] = "butterfree", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "butterfree.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["cascadeBadge"] 				 = {["name"] = "cascadeBadge", 			  		["label"] = "cascadeBadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "cascadeBadge.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "2/8 for Trophy Badge"},
	["caterpie"] 				     	 = {["name"] = "caterpie", 			  		["label"] = "caterpie", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "caterpie.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["chansey"] 				 	 = {["name"] = "chansey", 			  		["label"] = "chansey", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "chansey.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["charizard"] 				 	 = {["name"] = "charizard", 			  		["label"] = "charizard", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "charizard.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "5/6 for Volcano Badge"},
	["charmander"] 				 	 = {["name"] = "charmander", 			  		["label"] = "charmander", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "charmander.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["charmeleon"] 				 	 = {["name"] = "charmeleon", 			  		["label"] = "charmeleon", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "charmeleon.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["clefable"] 					 = {["name"] = "clefable", 			  		["label"] = "clefable", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "clefable.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["clefairy"] 				 	 = {["name"] = "clefairy", 			  	  	["label"] = "clefairy", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "clefairy.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["cloyster"] 				 	 = {["name"] = "cloyster", 			  	  	["label"] = "cloyster", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "cloyster.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["cubone"] 					 = {["name"] = "cubone", 			  	  	["label"] = "cubone", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "cubone.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["dewgong"] 				 	 = {["name"] = "dewgong", 			  	  	["label"] = "dewgong", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "dewgong.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["diglett"] 					 = {["name"] = "diglett", 			 	  	["label"] = "diglett", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "diglett.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["ditto"] 					 = {["name"] = "ditto", 			 		["label"] = "ditto", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "ditto.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["dodrio"] 					 = {["name"] = "dodrio", 			 		["label"] = "dodrio", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "dodrio.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["doduo"] 					 = {["name"] = "doduo", 					["label"] = "doduo", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "doduo.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["dragonair"] 					 = {["name"] = "dragonair", 			 	  	["label"] = "dragonair", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "dragonair.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["dragonite"] 					 = {["name"] = "dragonite", 				    	["label"] = "dragonite", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "dragonite.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["dratini"] 					 = {["name"] = "dratini", 			    		["label"] = "dratini", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "dratini.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["drowzee"] 					 = {["name"] = "drowzee", 			 		["label"] = "drowzee", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "drowzee.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["dugtrio"] 				  	 = {["name"] = "dugtrio", 			 		["label"] = "dugtrio", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "dugtrio.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "5/6 for Earth Badge"},
	["earthBadge"] 					 = {["name"] = "earthBadge", 					["label"] = "earthBadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "earthBadge.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "8/8 for Trophy Badge"},
	["eevee"] 					 = {["name"] = "eevee", 			 		["label"] = "eevee", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "eevee.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["ekans"] 					 = {["name"] = "ekans", 			 		["label"] = "ekans", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "ekans.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["electabuzz"] 				     	 = {["name"] = "electabuzz", 			 		["label"] = "electabuzz", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "electabuzz.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "4/6 for Thunder Badge"},
	["electrode"] 					 = {["name"] = "electrode", 					["label"] = "electrode", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "electrode.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = "5/6 for Thunder Badge"},
	["exeggcute"] 					 = {["name"] = "exeggcute", 				    	["label"] = "exeggcute", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "exeggcute.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["exeggutor"] 					 = {["name"] = "exeggutor", 					["label"] = "exeggutor", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "exeggutor.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["farfetchd"] 					 = {["name"] = "farfetchd", 					["label"] = "farfetchd", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "farfetchd.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["fearow"] 					 = {["name"] = "fearow", 					["label"] = "fearow", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "fearow.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["flareon"] 					 = {["name"] = "flareon", 					["label"] = "flareon", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "flareon.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["gastly"] 					 = {["name"] = "gastly", 					["label"] = "gastly", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "gastly.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["gengar"] 					 = {["name"] = "gengar", 					["label"] = "gengar", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "gengar.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["geodude"] 				 	 = {["name"] = "geodude", 				    	["label"] = "geodude", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "geodude.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "6/6 for Boulder Badge"},
	["gloom"] 					 = {["name"] = "gloom", 					["label"] = "gloom", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "gloom.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["golbat"] 					 = {["name"] = "golbat", 					["label"] = "golbat", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "golbat.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "6/6 for Soul Badge"},
	["goldeen"] 					 = {["name"] = "goldeen", 					["label"] = "goldeen", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "goldeen.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["golduck"] 		 			 = {["name"] = "golduck", 					["label"] = "golduck", 					["weight"] = 0, 	    	["type"] = "item", 		["image"] = "golduck.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "5/6 for Cascade Badge"},
	["golem"] 		 			 = {["name"] = "golem", 					["label"] = "golem", 					["weight"] = 0, 	    	["type"] = "item", 		["image"] = "golem.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["graveler"] 		 			 = {["name"] = "graveler", 					["label"] = "graveler", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "graveler.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "1/6 for Boulder Badge"},
	["grimer"] 		 			 = {["name"] = "grimer", 					["label"] = "grimer", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "grimer.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["growlithe"] 		 			 = {["name"] = "growlithe", 					["label"] = "growlithe", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "growlithe.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["gyarados"] 				 	 = {["name"] = "gyarados", 			  	  	["label"] = "gyarados", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "gyarados.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["haunter"] 					 = {["name"] = "haunter", 					["label"] = "haunter", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "haunter.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["hitmonchan"] 				 	 = {["name"] = "hitmonchan", 			  	  	["label"] = "hitmonchan", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "hitmonchan.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["hitmonlee"] 				 	 = {["name"] = "hitmonlee", 			   		["label"] = "hitmonlee", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "hitmonlee.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["horsea"] 					 = {["name"] = "horsea", 			  		["label"] = "horsea", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "horsea.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["hypno"] 				 	 = {["name"] = "hypno", 			  	  	["label"] = "hypno", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "hypno.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "5/6 for Marsh Badge"},
	["ivysaur"] 					 = {["name"] = "ivysaur", 			  		["label"] = "ivysaur", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "ivysaur.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["jigglypuff"] 					 = {["name"] = "jigglypuff", 			  	  	["label"] = "jigglypuff", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "jigglypuff.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["jolteon"] 					 = {["name"] = "jolteon", 					["label"] = "jolteon", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "jolteon.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "3/6 for Thunder Badge"},
	["jynx"] 					 = {["name"] = "jynx", 						["label"] = "jynx", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "jynx.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "6/6 for Marsh Badge"},
	["kabuto"] 					 = {["name"] = "kabuto", 					["label"] = "kabuto", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "kabuto.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["kabutops"] 			 		 = {["name"] = "kabutops", 				 	["label"] = "kabutops", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "kabutops.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "4/6 for Boulder Badge"},
	["kadabra"] 			 	 	 = {["name"] = "kadabra", 			  		["label"] = "kadabra", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "kadabra.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "4/6 for Marsh Badge"},
	["kakuna"] 			 	 	 = {["name"] = "kakuna", 			  		["label"] = "kakuna", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "kakuna.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["kangaskhan"] 			 	 	 = {["name"] = "kangaskhan", 			  		["label"] = "kangaskhan", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "kangaskhan.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["kingler"] 			 	 	 = {["name"] = "kingler", 			  		["label"] = "kingler", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "kingler.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   	["combinable"] = nil,   ["description"] = ""},
	["koffing"] 			 	 	 = {["name"] = "koffing", 			  		["label"] = "koffing", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "koffing.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = "1/6 for Soul Badge"},
	["krabby"] 				 	 = {["name"] = "krabby", 			  		["label"] = "krabby", 					["weight"] = 0, 	    	["type"] = "item", 		["image"] = "krabby.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["lapras"] 			 		 = {["name"] = "lapras", 			  		["label"] = "lapras", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "lapras.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = "4/6 for Cascade Badge"},
	["lickitung"] 			 		 = {["name"] = "lickitung", 			  		["label"] = "lickitung", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "lickitung.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["machamp"] 					 = {["name"] = "machamp", 					["label"] = "machamp", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "machamp.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["machoke"] 					 = {["name"] = "machoke", 					["label"] = "machoke", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "machoke.png",			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["machop"] 			 		 = {["name"] = "machop", 					["label"] = "machop", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "machop.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["magikarp"] 			 		 = {["name"] = "magikarp", 					["label"] = "magikarp", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "magikarp.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["magmar"] 					 = {["name"] = "magmar", 					["label"] = "magmar", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "magmar.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = "4/6 for Volcano Badge"},
	["magnemite"] 			   		 = {["name"] = "magnemite", 					["label"] = "magnemite", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "magnemite.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,    	["combinable"] = nil,   ["description"] = ""},
	["magneton"] 					 = {["name"] = "magneton", 			  	  	["label"] = "magneton", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "magneton.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "6/6 for Thunder Badge"},
	["mankey"] 					 = {["name"] = "mankey", 					["label"] = "mankey", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "mankey.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["marowak"] 					 = {["name"] = "marowak", 			  	  	["label"] = "marowak", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "marowak.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["marshBadge"] 					 = {["name"] = "marshBadge", 				  	["label"] = "marshBadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "marshBadge.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "6/8 for Trophy Badge"},
	["meowth"] 					 = {["name"] = "meowth", 			  		["label"] = "meowth", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "meowth.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["metapod"] 					 = {["name"] = "metapod", 			  	  	["label"] = "metapod", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "metapod.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["mew"] 					 = {["name"] = "mew", 			  			["label"] = "mew", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "mew.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["mewtwo"] 					 = {["name"] = "mewtwo", 			  		["label"] = "mewtwo", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "mewtwo.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "4/6 for Earth Badge"},
	["moltres"] 					 = {["name"] = "moltres", 			 		["label"] = "moltres", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "moltres.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "6/6 for Volcano Badge"},
	["mr_mime"] 					 = {["name"] = "mr_mime", 			  		["label"] = "mr_mime", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "mr_mime.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "2/6 for Marsh Badge"},
	["muk"] 					 = {["name"] = "muk", 			  			["label"] = "muk", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "muk.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["nidoking"] 				     	 = {["name"] = "nidoking", 			  		["label"] = "nidoking", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "nidoking.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "2/6 for Earth Badge"},
	["nidoqueen"] 				 	 = {["name"] = "nidoqueen", 			  		["label"] = "nidoqueen", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "nidoqueen.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "3/6 for Earth Badge"},
	["nidoran"] 				 	 = {["name"] = "nidoran", 			  		["label"] = "nidoran", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "nidoran.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["nidorina"] 				 	 = {["name"] = "nidorina", 			  		["label"] = "nidorina", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "nidorina.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["nidorino"] 				 	 = {["name"] = "nidorino", 			  		["label"] = "nidorino", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "nidorino.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["ninetails"] 					 = {["name"] = "ninetails", 			  		["label"] = "ninetails", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "ninetails.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "3/6 for Volcano badge"},
	["oddish"] 				 	 = {["name"] = "oddish", 			  	  	["label"] = "oddish", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "oddish.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["omanyte"] 				 	 = {["name"] = "omanyte", 			  	  	["label"] = "omanyte", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "omanyte.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["omastar"] 					 = {["name"] = "omastar", 			  	  	["label"] = "omastar", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "omastar.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "3/6 for Boulder Badge"},
	["onix"] 				 	 = {["name"] = "onix", 			  	  		["label"] = "onix", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "onix.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "5/6 for Boulder Badge"},
	["paras"] 					 = {["name"] = "paras", 			 	  	["label"] = "paras", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "paras.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["parasect"] 					 = {["name"] = "parasect", 			 		["label"] = "parasect", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "parasect.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["persian"] 					 = {["name"] = "persian", 			 		["label"] = "persian", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "persian.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "6/6 for Earth Badge"},
	["pidgeot"] 					 = {["name"] = "pidgeot", 			 			["label"] = "pidgeot", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "pidgeot.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	   ["combinable"] = nil,   ["description"] = "6/6 for Earth Badge"},
	["pidgeotto"] 					 = {["name"] = "pidgeotto", 					["label"] = "pidgeotto", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "pidgeotto.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["pidgey"] 					 = {["name"] = "pidgey", 			 		["label"] = "pidgey", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "pidgey.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["pikachu"] 					 = {["name"] = "pikachu", 					["label"] = "pikachu", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "pikachu.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "2/6 for Thunder Badge"},
	["pinsir"] 					 = {["name"] = "pinsir", 			    		["label"] = "pinsir", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "pinsir.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["poliwag"] 					 = {["name"] = "poliwag", 			 		["label"] = "poliwag", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "poliwag.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["polywhirl"] 				  	 = {["name"] = "polywhirl", 			 		["label"] = "polywhirl", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "polywhirl.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["poliwrath"] 					 = {["name"] = "poliwrath", 					["label"] = "poliwrath", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "poliwrath.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["ponyta"] 					 = {["name"] = "ponyta", 			 		["label"] = "ponyta", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "ponyta.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["porygon"] 					 = {["name"] = "porygon", 			 		["label"] = "porygon", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "porygon.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["primeape"] 				     	 = {["name"] = "primeape", 			 		["label"] = "primeape", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "primeape.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["psyduck"] 					 = {["name"] = "psyduck", 					["label"] = "psyduck", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "psyduck.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "3/6 for Cascade Badge"},
	["raichu"] 					 = {["name"] = "raichu", 					["label"] = "raichu", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "raichu.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["rainbowBadge"] 				 = {["name"] = "rainbowBadge", 					["label"] = "rainbowBadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "rainbowBadge.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "4/6 for Rainbow Badge"},
	["rapidash"] 					 = {["name"] = "rapidash", 					["label"] = "rapidash", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "rapidash.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "2/6 for Volcano Badge"},
	["raticate"] 					 = {["name"] = "raticate", 					["label"] = "raticate", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "raticate.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["rattata"] 					 = {["name"] = "rattata", 					["label"] = "rattata", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "rattata.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["rhydon"] 					 = {["name"] = "rhydon", 					["label"] = "rhydon", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "rhydon.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "1/6 for Earth Badge"},
	["rhyhorn"] 					 = {["name"] = "rhyhorn", 					["label"] = "rhyhorn", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "rhyhorn.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "2/6 for Boulder Badge"},
	["sandshrew"] 				 	 = {["name"] = "sandshrew", 				    	["label"] = "sandshrew", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "sandshrew.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["sandslash"] 					 = {["name"] = "sandslash", 					["label"] = "sandslash", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "sandslash.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["scyther"] 					 = {["name"] = "scyther", 					["label"] = "scyther", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "scyther.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "4/6 for Rainbow Badge"},
	["seadra"] 					 = {["name"] = "seadra", 					["label"] = "seadra", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "seadra.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["seaking"] 		 			 = {["name"] = "seaking", 					["label"] = "seaking", 					["weight"] = 0, 	    	["type"] = "item", 		["image"] = "seaking.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["seel"] 		 			 = {["name"] = "seel", 						["label"] = "seel", 					["weight"] = 0, 	    	["type"] = "item", 		["image"] = "seel.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["shellder"] 		 			 = {["name"] = "shellder", 					["label"] = "shellder", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "shellder.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["slowbro"] 		 			 = {["name"] = "slowbro", 					["label"] = "slowbro", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "slowbro.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["slowpoke"] 		 			 = {["name"] = "slowpoke", 					["label"] = "slowpoke", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "slowpoke.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["snorlax"] 				 	 = {["name"] = "snorlax", 			  	  	["label"] = "snorlax", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "snorlax.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "3/6 for Sould Badge"},
	["soulBadge"] 					 = {["name"] = "soulBadge", 					["label"] = "soulBadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "soulBadge.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "5/8 for Trophy Badge"},
	["spearow"] 				 	 = {["name"] = "spearow", 			  	  	["label"] = "spearow", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "spearow.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["squirtle"] 				 	 = {["name"] = "squirtle", 			   		["label"] = "squirtle", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "squirtle.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["starmie"] 					 = {["name"] = "starmie", 			  		["label"] = "starmie", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "starmie.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "2/6 for Cascade Badge"},
	["staryu"] 				 	 = {["name"] = "staryu", 			  	  	["label"] = "staryu", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "staryu.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["tangela"] 					 = {["name"] = "tangela", 			  		["label"] = "tangela", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "tangela.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "2/6 for Rainbow Badge"},
	["tauros"] 					 = {["name"] = "tauros", 			  	  	["label"] = "tauros", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "tauros.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["tentacool"] 					 = {["name"] = "tentacool", 					["label"] = "tentacool", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "tentacool.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["tentacruel"] 					 = {["name"] = "tentacruel", 					["label"] = "tentacruel", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "tentacruel.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["thunderBadge"] 				 = {["name"] = "thunderBadge", 					["label"] = "thunderBadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "thunderBadge.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "3/8 for Trophy Badge"},
	["togepi"] 			 		 = {["name"] = "togepi", 				 	["label"] = "togepi", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "togepi.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "6/6 for Cascade Badge"},
	["trophyBadge"] 			 	 = {["name"] = "trophyBadge", 			  		["label"] = "trophyBadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "trophyBadge.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "OwO You have a Trophy"},
	["vaporeon"] 			 	 	 = {["name"] = "vaporeon", 			  		["label"] = "vaporeon", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "vaporeon.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["venomoth"] 			 	 	 = {["name"] = "venomoth", 			  		["label"] = "venomoth", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "venomoth.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "4/6 for Soul Badge"},
	["venonat"] 			 	 	 = {["name"] = "venonat", 			  		["label"] = "venonat", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "venonat.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "5/6 for Soul Badge"},
	["venusaur"] 			 	 	 = {["name"] = "venusaur", 			  		["label"] = "venusaur", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "venusaur.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "6/6 for Rainbow Badge"},
	["victreebel"] 				 	 = {["name"] = "victreebel", 			  		["label"] = "victreebel", 				["weight"] = 0, 	    	["type"] = "item", 		["image"] = "victreebel.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "1/6 for Rainbow Badge"},
	["vileplume"] 		 			 = {["name"] = "vileplume", 			  		["label"] = "vileplume", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "vileplume.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "3/6 for Rainbow Badge"},
	["volcanoBadge"] 		 		 = {["name"] = "volcanoBadge", 			  		["label"] = "volcanoBadge", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "volcanoBadge.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "7/8 for Trophy Badge"},
	["voltorb"] 					 = {["name"] = "voltorb", 					["label"] = "voltorb", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "voltorb.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["vulpix"] 					 = {["name"] = "vulpix", 					["label"] = "vulpix", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "vulpix.png",			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["wartortle"] 		 			 = {["name"] = "wartortle", 					["label"] = "wartortle", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "wartortle.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["weedle"] 				 	 = {["name"] = "weedle", 					["label"] = "weedle", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "weedle.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["weepinbell"] 				     	 = {["name"] = "weepinbell", 					["label"] = "weepinbell", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "weepinbell.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["weezing"] 			   		 = {["name"] = "weezing", 					["label"] = "weezing", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "weezing.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "2/6 for Soul Badge"},
	["wigglytuff"] 			 		 = {["name"] = "wigglytuff", 					["label"] = "wigglytuff", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "wigglytuff.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["zapdos"] 					 = {["name"] = "zapdos", 					["label"] = "zapdos", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "zapdos.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = "1/6 for Thunder Badge"},
	["zubat"] 				   	 = {["name"] = "zubat", 					["label"] = "zubat", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "zubat.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["bulbasaur"] 			   		 = {["name"] = "bulbasaur", 					["label"] = "bulbasaur", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "bulbasaur.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["blastoisev"] 			 	 	 = {["name"] = "blastoisev", 			  		["label"] = "blastoisev", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "blastoisev.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = ""},
	["charizardv"] 				 	 = {["name"] = "charizardv", 			  		["label"] = "charizardv", 				["weight"] = 0, 	    	["type"] = "item", 		["image"] = "charizardv.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["mewv"] 		 			 = {["name"] = "mewv", 			  			["label"] = "mewv", 					["weight"] = 0, 		["type"] = "item", 		["image"] = "mewv.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["pikachuv"] 		 			 = {["name"] = "pikachuv", 			  		["label"] = "pikachuv", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "pikachuv.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["snorlaxv"] 					 = {["name"] = "snorlaxv", 					["label"] = "snorlaxv", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "snorlaxv.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["venusaurv"] 					 = {["name"] = "venusaurv", 					["label"] = "venusaurv", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "venusaurv.png",			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["blastoisevmax"] 		 		 = {["name"] = "blastoisevmax", 				["label"] = "blastoisevmax", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "blastoisevmax.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["mewtwogx"] 				 	 = {["name"] = "mewtwogx", 					["label"] = "mewtwogx", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "mewtwogx.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["snorlaxvmax"] 				 = {["name"] = "snorlaxvmax", 					["label"] = "snorlaxvmax", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "snorlaxvmax.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["venusaurvmax"] 			   	 = {["name"] = "venusaurvmax", 					["label"] = "venusaurvmax", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "venusaurvmax.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["vmaxcharizard"] 			 	 = {["name"] = "vmaxcharizard", 				["label"] = "vmaxcharizard", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "vmaxcharizard.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["vmaxpikachu"] 				 = {["name"] = "vmaxpikachu", 					["label"] = "vmaxpikachu", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "vmaxpikachu.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["rainbowmewtwogx"] 				 = {["name"] = "rainbowmewtwogx", 				["label"] = "rainbowmewtwogx", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "rainbowmewtwogx.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["rainbowvmaxcharizard"] 			 = {["name"] = "rainbowvmaxcharizard", 				["label"] = "rainbowvmaxcharizard", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "rainbowvmaxcharizard.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},
	["rainbowvmaxpikachu"] 				 = {["name"] = "rainbowvmaxpikachu", 				["label"] = "rainbowvmaxpikachu", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "rainbowvmaxpikachu.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,        ["combinable"] = nil,   ["description"] = ""},



## you may change shop location coords or the maps that i use for the shops are linked below

https://modit.store/collections/gtav-maps-mlo-shell/products/pawn-and-jewelry-mlo-interior?variant=38162504024247#

https://www.fivem-store.com/product/legion-square-with-underground-garage-mlo/

I'd Like to also point out that I am not to be recognized as sole creator of this project.
I am still learning and got tons of help from a great team of guys!
Big thanks to anyone that helped me if you want any sort of individual recognition say the word!

kamui_kody for support on script join https://discord.gg/3j9b439TeY


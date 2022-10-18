Config = {}

Config.BoxPrice = 4000
Config.BoxWeight = 120000
Config.BoxCapacity = 50
Config.UseTarget = true
Config.BadgeAudio = "badge"
Config.CardFlipAudio = "flip"

Config.Opening = {
    ['boosterpack'] = {
        cards = true,
        storage = false,
        animation = "a_uncuff",
        dict = "mp_arresting",
        prop = 'prop_boosterpack_01',
        label = 'opening pack..',
        time = 3000,
        audio = "dealfour",
        packtype = false,
        packamount = 0,
        ['coords'] = {
            x = 0.1,
            y = 0.1,
            z = 0.0
        },
        ['rot'] = {
            x = 70.0,
            y = 10.0,
            z = 90.0
        }
    },
    ['boosterbox'] = {
        cards = false,
        storage = false,
        animation = "a_uncuff",
        dict = "mp_arresting",
        prop = 'prop_boosterbox_01',
        label = 'opening boosterbox..',
        time = 9500,
        audio = "boxopen",
        packtype = 'boosterpack',
        packamount = 4,
        ['coords'] = {
            x = 0.1,
            y = 0.1,
            z = 0.0
        },
        ['rot'] = {
            x = 70.0,
            y = 10.0,
            z = 90.0
        }
    },
    ['pokebox'] = {
        cards = false,
        storage = true,
        animation = "a_uncuff",
        dict = "mp_arresting",
        prop = 'prop_deckbox_01',
        label = 'Box is being opened',
        time = 5000,
        audio = "snap",
        packtype = false,
        packamount = 0,
        ['coords'] = {
            x = 0.1,
            y = 0.1,
            z = 0.0
        },
        ['rot'] = {
            x = 70.0,
            y = 10.0,
            z = 90.0
        }
    }
}

Config.Locations = {
    ['shop'] = {
        ['locations'] = {
            vector4(77.64, -1571.3, 29.59,0),
        },
        ['ped'] = false, -- set to ped model to spawn ped
        ['label'] = 'Card Shop',
        ['blip'] = true,
        ['sprite'] = 272,
        ['color'] = 5,
        ['size'] = 0.6
    },
    ['badges'] = {
        ['ped'] = false, -- simply true false set model below per badge after setting this true
        ['blip'] = true, 
        ['sprite'] = 272,
        ['color'] = 5,
        ['size'] = 0.6

    }
}

Config.ShopItems = {
    [1] = {
        name = 'boosterpack',
        price = 400,
        amount = 50,
        info = {},
        type = 'item',
        slot = 1
    },
    [2] = {
        name = 'boosterbox',
        price = 1400,
        amount = 20,
        info = {},
        type = 'item',
        slot = 2
    },
    [3] = {
        name = 'pokebox',
        price = 4000,
        amount = 10,
        info = {},
        type = 'item',
        slot = 3
    }

}

Config.Badge = {
    ['boosterpack'] = {-- these sections should be labeled with the name of the pack that holds these cards
        ["boulderbadge"] = {
            location = vector4(282.24, 6789.04, 15.7),
            proveitem = false,
            value = 10000,
            ped = false,
            img = false,
            cards = {
            ["graveler"] = 1, 
            ["rhyhorn"] = 1,  
            ["omastar"] = 1,
            ["kabutops"] = 1,
            ["onix"] = 1, 
            ["geodude"] = 1
            }
        },
        ["cascadebadge"] = {
            location = vector4(-1844.97, -1195.94, 19.20),
            proveitem = "boulderbadge",
            value = 10000,
            ped = false,
            img = false,
            cards = {
            ["blastoise"] = 1, 
            ["lapras"] = 1, 
            ["starmie"] = 1, 
            ["psyduck"] = 1, 
            ["togepi"] = 1
            }
        },
        ["thunderbadge"] = {
            location = vector4(2729.21, 1577.74, 66.54),
            proveitem = "cascadebadge",
            value = 10000,
            ped = false,
            img = false,
            cards = {
                ["zapdos"] = 1, 
                ["pikachu"] = 1, 
                ["jolteon"] = 1, 
                ["electabuzz"] = 1, 
                ["electrode"] = 1, 
                ["magneton"] = 1
            }
        },
        ["rainbowbadge"] = {
            location = vector4(-86.19, 834.38, 235.92),
            proveitem = "thunderbadge",
            value = 10000,
            ped = false,
            img = false,
            cards = { 
                ["victreebel"] = 1, 
                ["tangela"] = 1, 
                ["vileplume"] = 1, 
                ["scyther"] = 1, 
                ["bellsprout"] = 1, 
                ["venusaur"] = 1
            }
        },
        ["soulbadge"] = {
            location = vector4(-758.68, -1046.87, 13.6),
            proveitem = "rainbowbadge",
            value = 10000,
            ped = false,
            img = false,
            cards = { 
                ["koffing"] = 1, 
                ["weezing"] = 1, 
                ["snorlax"] = 1, 
                ["venonat"] = 1, 
                ["venomoth"] = 1, 
                ["golbat"] = 1
            }
        },
        ["marshbadge"] = {
            location = vector4(387.26, 3585.02, 33.29),
            proveitem = "soulbadge",
            value = 10000,
            ped = false,
            img = false,
            cards = { 
                ["alakazam"] = 1, 
                ["mr_mime"] = 1, 
                ["abra"] = 1, 
                ["kadabra"] = 1, 
                ["hypno"] = 1, 
                ["jynx"] = 1
            }
        },
        ["volcanobadge"] = {
            location = vector4(2944.06, 2747.0, 43.5),
            proveitem = "marshbadge",
            value = 10000,
            ped = false,
            img = false,
            cards = { 
                ["arcanine"] = 1, 
                ["rapidash"] = 1, 
                ["ninetails"] = 1, 
                ["magmar"] = 1, 
                ["charizard"] =1, 
                ["moltres"] = 1
            }
        },
        ["earthbadge"] = {
            proveitem = "volcanobadge",
            location = vector4(-2588.14, 1911.6, 167.6),
            value = 10000,
            ped = false,
            img = false,
            cards = { 
                ["rhydon"] = 1, 
                ["nidoking"] = 1, 
                ["nidoqueen"] = 1, 
                ["mewtwo"] = 1, 
                ["dugtrio"] = 1, 
                ["persian"] = 1
            }
        },
        ["trophybadge"] = {
            proveitem = false,
            location = vector4(200.5, -873.09, 30.91),
            value = 150000,
            ped = false,
            img = false,
            cards = { 
                ["boulderbadge"] = 1, 
                ["cascadebadge"] = 1, 
                ["thunderbadge"] = 1, 
                ["rainbowbadge"] = 1, 
                ["soulbadge"] = 1, 
                ["marshbadge"] = 1, 
                ["volcanohbadge"] = 1, 
                ["earthbadge"] = 1
            }
        }
    }
}


Config.Cards = {
    ['boosterpack'] = {-- these sections should be labeled with the name of the pack that holds these cards
        ['basicCards'] = {
            ["bulbasaur"] = {
                value = 50,
                img = false -- this will be for menu images if you use nh-context i havent added context or uploaded the images yet
            },   
            ["ivysaur"] = {
                value = 50,
                img = false 
            },   
            ["charmander"] = {
                value = 50,
                img = false 
            },   
            ["charmeleon"] = {
                value = 50,
                img = false 
            },   
            ["squirtle"] = {
                value = 50,
                img = false 
            },   
            ["wartortle"] = {
                value = 50,
                img = false 
            },   
            ["caterpie"] = {
                value = 50,
                img = false 
            },   
            ["metapod"] = {
                value = 50,
                img = false 
            },   
            ["butterfree"] = {
                value = 50,
                img = false 
            },   
            ["weedle"] = {
                value = 50,
                img = false 
            },   
            ["kakuna"] = {
                value = 50,
                img = false 
            },   
            ["beedrill"] = {
                value = 50,
                img = false 
            },   
            ["pidgey"] = {
                value = 50,
                img = false 
            },  
            ["pidgeotto"] = {
                value = 50,
                img = false 
            },   
            ["pidgeot"] = {
                value = 50,
                img = false 
            },   
            ["rattata"] = {
                value = 50,
                img = false 
            },   
            ["raticate"] = {
                value = 50,
                img = false 
            },   
            ["spearow"] = {
                value = 50,
                img = false 
            },   
            ["fearow"] = {
                value = 50,
                img = false 
            },   
            ["ekans"] = {
                value = 50,
                img = false 
            },   
            ["arbok"] = {
                value = 50,
                img = false 
            },   
            ["pikachu"] = {
                value = 50,
                img = false 
            },   
            ["sandshrew"] = {
                value = 50,
                img = false 
            },   
            ["sandslash"] = {
                value = 50,
                img = false 
            },   
            ["nidoran"] = {
                value = 50,
                img = false 
            },   
            ["nidorina"] = {
                value = 50,
                img = false 
            },   
            ["nidoqueen"] = {
                value = 100,
                img = false 
            },   
            ["nidorino"] = {
                value = 50,
                img = false 
            },   
            ["clefairy"] = {
                value = 50,
                img = false 
            },  
            ["clefable"] = {
                value = 50,
                img = false 
            },   
            ["vulpix"] = {
                value = 50,
                img = false 
            },  
            ["ninetails"] = {
                value = 50,
                img = false 
            },   
            ["zubat"] = {
                value = 50,
                img = false 
            },   
            ["golbat"] = {
                value = 50,
                img = false 
            },   
            ["oddish"] = {
                value = 50,
                img = false 
            },   
            ["gloom"] = {
                value = 50,
                img = false 
            },   
            ["vileplume"] = {
                value = 50,
                img = false 
            },   
            ["paras"] = {
                value = 50,
                img = false 
            },   
            ["parasect"] = {
                value = 50,
                img = false 
            },   
            ["venonat"] = {
                value = 50,
                img = false 
            },   
            ["venomoth"] = {
                value = 50,
                img = false 
            },   
            ["diglett"] = {
                value = 50,
                img = false 
            },   
            ["dugtrio"] = {
                value = 50,
                img = false 
            },   
            ["meowth"] = {
                value = 50,
                img = false 
            },   
            ["persian"] = {
                value = 50,
                img = false 
            },   
            ["psyduck"] = {
                value = 50,
                img = false 
            },  
            ["golduck"] = {
                value = 50,
                img = false 
            },   
            ["mankey"] = {
                value = 50,
                img = false 
            },   
            ["primeape"] = {
                value = 50,
                img = false 
            },   
            ["growlithe"] = {
                value = 50,
                img = false 
            },   
            ["arcanine"] = {
                value = 50,
                img = false 
            },   
            ["poliwag"] = {
                value = 50,
                img = false 
            },   
            ["poliwhirl"] = {
                value = 50,
                img = false 
            },   
            ["poliwrath"] = {
                value = 50,
                img = false 
            },   
            ["abra"] = {
                value = 5050,
                img = false 
            },  
            ["machop"] = {
                value = 50,
                img = false 
            },   
            ["machoke"] = {
                value = 50,
                img = false 
            },   
            ["bellsprout"] = {
                value = 50,
                img = false 
            },   
            ["weepinbell"] = {
                value = 50,
                img = false 
            },   
            ["victreebel"] = {
                value = 50,
                img = false 
            },   
            ["tentacool"] = {
                value = 50,
                img = false 
            },  
            ["tentacruel"] = {
                value = 50,
                img = false 
            },   
            ["geodude"] = {
                value = 50,
                img = false 
            },   
            ["graveler"] = {
                value = 50,
                img = false 
            },   
            ["golem"] = {
                value = 50,
                img = false 
            },   
            ["ponyta"] = {
                value = 50,
                img = false 
            },   
            ["rapidash"] = {
                value = 50,
                img = false 
            },   
            ["slowpoke"] = {
                value = 50,
                img = false 
            },   
            ["slowbro"] = {
                value = 50,
                img = false 
            },   
            ["magnemite"] = {
                value = 50,
                img = false 
            },   
            ["magneton"] = {
                value = 50,
                img = false 
            },   
            ["farfetchd"] = {
                value = 50,
                img = false 
            },    
            ["doduo"] = {
                value = 50,
                img = false 
            },    
            ["dodrio"] = {
                value = 50,
                img = false 
            },    
            ["seel"] = {
                value = 50,
                img = false 
            },    
            ["dewgong"] = {
                value = 50,
                img = false 
            },    
            ["grimer"] = {
                value = 50,
                img = false 
            },    
            ["muk"] = {
                value = 50,
                img = false 
            },    
            ["shellder"] = {
                value = 50,
                img = false 
            },    
            ["cloyster"] = {
                value = 50,
                img = false 
            },    
            ["gastly"] = {
                value = 50,
                img = false 
            },    
            ["haunter"] = {
                value = 50,
                img = false 
            },    
            ["gengar"] = {
                value = 50,
                img = false 
            },    
            ["drowzee"] = {
                value = 50,
                img = false 
            },    
            ["hypno"] = {
                value = 50,
                img = false 
            },    
            ["krabby"] = {
                value = 50,
                img = false 
            },    
            ["kingler"] = {
                value = 50,
                img = false 
            },    
            ["voltorb"] = {
                value = 50,
                img = false 
            },    
            ["electrode"] = {
                value = 50,
                img = false 
            },    
            ["exeggcute"] = {
                value = 50,
                img = false 
            },    
            ["exeggutor"] = {
                value = 50,
                img = false 
            },    
            ["cubone"] = {
                value = 50,
                img = false 
            },    
            ["marowak"] = {
                value = 50,
                img = false 
            },    
            ["lickitung"] = {
                value = 50,
                img = false 
            },    
            ["koffing"] = {
                value = 50,
                img = false 
            },    
            ["weezing"] = {
                value = 50,
                img = false 
            },    
            ["rhyhorn"] = {
                value = 50,
                img = false 
            },    
            ["rhydon"] = {
                value = 50,
                img = false 
            },    
            ["chansey"] = {
                value = 50,
                img = false 
            },    
            ["tangela"] = {
                value = 50,
                img = false 
            },    
            ["horsea"] = {
                value = 50,
                img = false 
            },    
            ["seadra"] = {
                value = 50,
                img = false 
            },    
            ["goldeen"] = {
                value = 50,
                img = false 
            },    
            ["seaking"] = {
                value = 50,
                img = false 
            },    
            ["staryu"] = {
                value = 50,
                img = false 
            },    
            ["mrmime"] = {
                value = 50,
                img = false 
            },     
            ["electabuzz"] = {
                value = 50,
                img = false 
            },    
            ["magmar"] = {
                value = 50,
                img = false 
            },    
            ["pinsir"] = {
                value = 50,
                img = false 
            },    
            ["tauros"] = {
                value = 50,
                img = false 
            },    
            ["magikarp"] = {
                value = 50,
                img = false 
            }  
        }
        ['rareCards'] = {
            ["lapras"] = {
                value = 50,
                img = false 
            },   
            ["eevee"] = {
                value = 50,
                img = false 
            },   
            ["togepi"] = {
                value = 50,
                img = false 
            },   
            ["vaporeon"] = {
                value = 50,
                img = false 
            },   
            ["jolteon"] = {
                value = 50,
                img = false 
            },   
            ["flareon"] = {
                value = 50,
                img = false 
            },   
            ["jigglypuff"] = {
                value = 50,
                img = false 
            },  
            ["wigglytuff"] = {
                value = 50,
                img = false 
            },   
            ["kadabra"] = {
                value = 50,
                img = false 
            },  
            ["raichu"] = {
                value = 100,
                img = false 
            },   
            ["nidoking"] = {
                value = 100,
                img = false 
            },   
            ["jynx"] = {
                value = 100,
                img = false 
            },  
            ["kangaskhan"] = {
                value = 50,
                img = false 
            },   
            ["gyarados"] = {
                value = 100,
                img = false 
            },  
            ["ditto"] = {
                value = 100,
                img = false 
            },  
            ["starmie"] = {
                value = 100,
                img = false 
            },  
            ["onix"] = {
                value = 100,
                img = false 
            },  
            ["machamp"] = {
                value = 100,
                img = false 
            },   
            ["scyther"] = {
                value = 100,
                img = false 
            },   
            ["hitmonlee"] = {
                value = 100,
                img = false 
            },   
            ["hitmonchan"] = {
                value = 100,
                img = false 
            },  
            ["venusaur"] = {
                value = 100,
                img = false 
            }
        }
        ['ultraCards'] = {
            ["alakazam"] = {
                value = 250,
                img = false 
            },   
            ["charizard"] = {
                value = 100,
                img = false 
            },   
            ["blastoise"] = {
                value = 100,
                img = false 
            },  
            ["porygon"] = {
                value = 250,
                img = false 
            },  
            ["omanyte"] = {
                value = 250,
                img = false 
            },  
            ["omastar"] = {
                value = 250,
                img = false 
            },   
            ["dragonite"] = {
                value = 250,
                img = false 
            },   
            ["mewtwo"] = {
                value = 250,
                img = false 
            },   
            ["mew"] = {
                value = 250,
                img = false 
            },   
            ["snorlax"] = {
                value = 250,
                img = false 
            },   
            ["articuno"] = {
                value = 250,
                img = false 
            },  
            ["zapdos"] = {
                value = 250,
                img = false 
            },   
            ["kabuto"] = {
                value = 250,
                img = false 
            },   
            ["kabutops"] = {
                value = 250,
                img = false 
            },   
            ["aerodactyl"] = {
                value = 250,
                img = false 
            },   
            ["moltres"] = {
                value = 250,
                img = false 
            },  
            ["dratini"] = {
                value = 250,
                img = false 
            },   
            ["dragonair"] = {
                value = 250,
                img = false 
            }  
        }
        ['vCards'] = {
            ["blastoisev"] = {
                value = 500,
                img = false 
            },   
            ["charizardv"] = {
                value = 700,
                img = false 
            },   
            ["mewv"] = {
                value = 600,
                img = false 
            },  
            ["pikachuv"] = {
                value = 400,
                img = false 
            },   
            ["snorlaxv"] = {
                value = 500,
                img = false 
            },   
            ["venusaurv"] = {
                value = 500,
                img = false 
            }
        }
        ['vmaxCards'] = {
            ["blastoisevmax"] = {
                value = 1200,
                img = false 
            },  
            ["mewtwogx"] = {
                value = 1500,
                img = false 
            },  
            ["snorlaxvmax"] = {
                value = 1000,
                img = false 
            }, 
            ["venusaurvmax"] = {
                value = 1200,
                img = false 
            }, 
            ["vmaxcharizard"] = {
                value = 1300,
                img = false 
            },  
            ["vmaxpikachu"] = {
                value = 900,
                img = false 
            }
        }
        ['rainbowCards'] = {
            ["rainbowmewtwogx"] = {
                value = 2400,
                img = false 
            }, 
            ["rainbowvmaxcharizard"] = {
                value = 2700,
                img = false 
            }, 
            ["rainbowvmaxpikachu"] = {
                value = 2000,
                img = false 
            }, 
            ["snorlaxvmaxrainbow"] = {
                value = 2000,
                img = false 
            }
        }
    }
}
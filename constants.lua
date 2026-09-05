-- RE4-SOURCE-UNIT: constants
--[[
RE4 HUB · IMMUTABLE GAME/RUNTIME CONSTANTS
Fixed game identifiers live here. Runtime-tunable values belong in config.lua;
immutable feature/catalog/topology/UI metadata belongs here; executable behavior stays in main.lua.
]]
do
    local function RE4ResolveEnvLocal()
        local fn=getgenv
        if type(fn)=="function" then
            local ok,value=pcall(fn)
            if ok and type(value)=="table" then return value end
        end
        return _G
    end
    local env=RE4ResolveEnvLocal()
    RE4Config=env.RE4_CONFIG
    local Metadata=env.RE4_APP_METADATA
    if type(Metadata)~="table" or type(RE4Config)~="table" or tostring(RE4Config.Version or "")~=tostring(Metadata.Version or "") then
        error("[RE4 HUB/Constants] metadata/config version mismatch")
    end

    RE4Constants = {
        Version = RE4Config.Version,

        Teams = {
            Pirates = "Pirates",
            Marines = "Marines",
        },

        Folders = {
            Enemies = "Enemies",
            Characters = "Characters",
            NPCs = "NPCs",
        },

        Places = {
            Sea1 = {2753915549, 85211729168715},
            Sea2 = {4442272183, 79091703265657},
            Sea3 = {7449423635, 100117331123089},
        },

        CriticalItems = {
            ["God's Chalice"] = true,
            ["Sweet Chalice"] = true,
            ["Holy Torch"] = true,
            ["Fist of Darkness"] = true,
            ["Hallow Essence"] = true,
            ["Leviathan Heart"] = true,
        },

        TransientKeyItems = {
            -- Physical quest/progression tools that can be invalidated by a
            -- spawn-reset style Bypass. Movement code consumes this one table
            -- instead of scattering item-name checks across features.
            ["Library Key"] = true,
            ["Water Key"] = true,
            ["Fire Essence"] = true,
            ["Key"] = true,
            ["Torch"] = true,
            ["Cup"] = true,
            ["Relic"] = true,
            ["Red Key"] = true,
            ["Fruit Bowl"] = true,
            ["Flower 1"] = true,
            ["Flower 2"] = true,
            ["Flower 3"] = true,
            ["Special Microchip"] = true,
            ["Microchip"] = true,
        },

        MoonAssets = {
            Phase0 = "http://www.roblox.com/asset/?id=9709135895",
            Phase1 = "http://www.roblox.com/asset/?id=9709139597",
            Phase2 = "http://www.roblox.com/asset/?id=9709143733",
            Phase3 = "http://www.roblox.com/asset/?id=9709149052",
            Phase4 = "http://www.roblox.com/asset/?id=9709149431",
            Phase5 = "http://www.roblox.com/asset/?id=9709149680",
            Phase6 = "http://www.roblox.com/asset/?id=9709150086",
            Phase7 = "http://www.roblox.com/asset/?id=9709150401",
        },
    }



    -- Application/game metadata and immutable lookup tables live here so the
    -- single runtime file only owns executable state/behavior. Consumers must
    -- treat these tables as read-only.
    RE4Constants.FeatureMetadata = {
    	Version = Metadata.Version,
    
    	GameData = {
    		BossOptionsBySea = {
    			[1] = {"The Gorilla King","Bobby","The Saw","Yeti","Mob Leader","Vice Admiral","Saber Expert","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Greybeard"},
    			[2] = {"Diamond","Jeremy","Orbitus","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Darkbeard","Cursed Captain","Order"},
    			[3] = {"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Cake Queen","Dough King","Longma","Soul Reaper","Tyrant of the Skies"},
    		},
    		FishingBaits = {
    			{Name="Basic Bait",Seas={1,2,3},Bundle=10,RequiredTrust=0,Beli=1000,Source="Fisherman/Angler"},
    			{Name="Kelp Bait",Seas={1},Bundle=10,RequiredTrust=3,Beli=12000,Source="Angler"},
    			{Name="Good Bait",Seas={1},Bundle=10,RequiredTrust=10,Beli=8000,Source="Angler"},
    			{Name="Abyssal Bait",Seas={2},Bundle=10,RequiredTrust=5,Beli=25000,Material="Demonic Wisp",MaterialCount=1,Source="Angler"},
    			{Name="Frozen Bait",Seas={2},Bundle=10,RequiredTrust=20,Beli=36000,Material="Yeti Fur",MaterialCount=1,Source="Angler"},
    			{Name="Epic Bait",Seas={3},Bundle=10,RequiredTrust=10,Beli=50000,Material="Terror Eyes",MaterialCount=1,Source="Angler"},
    			{Name="Carnivore Bait",Seas={3},Bundle=10,RequiredTrust=15,Beli=60000,Material="Dragon Scale",MaterialCount=1,Source="Angler"},
    		},
    		MaterialCatalog = {
    			[1] = {
    				{Name="Leather + Scrap Metal",Mobs={"Brute","Pirate"},Position=CFrame.new(-1145,15,4350)},
    				{Name="Angel Wings",Mobs={"Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"},Position=CFrame.new(-4698,845,-1912)},
    				{Name="Magma Ore",Mobs={"Military Soldier","Military Spy","Magma Admiral"},Position=CFrame.new(-5815,84,8820)},
    				{Name="Fish Tail",Mobs={"Fishman Warrior","Fishman Commando","Fishman Lord"},Position=CFrame.new(61123,19,1569)},
    			},
    			[2] = {
    				{Name="Leather + Scrap Metal",Mobs={"Marine Captain"},Position=CFrame.new(-2010.5059814453125,73.00115966796875,-3326.620849609375)},
    				{Name="Radioactive Material",Mobs={"Factory Staff"},Position=CFrame.new(295,73,-56)},
    				{Name="Ectoplasm",Mobs={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"},Position=CFrame.new(911.35827636719,125.95812988281,33159.5390625)},
    				{Name="Mystic Droplet",Mobs={"Water Fighter"},Position=CFrame.new(-3385,239,-10542)},
    				{Name="Magma Ore",Mobs={"Magma Ninja","Lava Pirate"},Position=CFrame.new(-5428,78,-5959)},
    				{Name="Vampire Fang",Mobs={"Vampire"},Position=CFrame.new(-6033,7,-1317)},
    			},
    			[3] = {
    				{Name="Scrap Metal",Mobs={"Jungle Pirate","Forest Pirate"},Position=CFrame.new(-11975.78515625,331.7734069824219,-10620.0302734375)},
    				{Name="Demonic Wisp",Mobs={"Demonic Soul"},Position=CFrame.new(-9495.6806640625,453.58624267578125,5977.3486328125)},
    				{Name="Conjured Cocoa",Mobs={"Chocolate Bar Battler","Cocoa Warrior"},Position=CFrame.new(620.6344604492188,78.93644714355469,-12581.369140625)},
    				{Name="Dragon Scale",Mobs={"Dragon Crew Archer","Dragon Crew Warrior"},Position=CFrame.new(6594,383,139)},
    				{Name="Gunpowder",Mobs={"Pistol Billionaire"},Position=CFrame.new(-84.8556900024414,85.62061309814453,6132.0087890625)},
    				{Name="Fish Tail",Mobs={"Fishman Raider","Fishman Captain"},Position=CFrame.new(-10993,332,-8940)},
    				{Name="Mini Tusk",Mobs={"Mythological Pirate"},Position=CFrame.new(-13545,470,-6917)},
    			},
    		},
    		QuestCatalog={
    		  [1]={
    			{Max=9,Team={Marines={Mon="Trainee",Qdata=1,Qname="MarineQuest",NameMon="Trainee",PosQ=CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),PosM=CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929)},Pirates={Mon="Bandit",Qdata=1,Qname="BanditQuest1",NameMon="Bandit",PosQ=CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125),PosM=CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)}}},
    			{Min=10,Max=14,Mon="Monkey",Qdata=1,Qname="JungleQuest",NameMon="Monkey",PosQ=CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0),PosM=CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)},
    			{Min=15,Max=29,Mon="Gorilla",Qdata=2,Qname="JungleQuest",NameMon="Gorilla",PosQ=CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0),PosM=CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)},
    			{Min=30,Max=39,Mon="Pirate",Qdata=1,Qname="BuggyQuest1",NameMon="Pirate",PosQ=CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627),PosM=CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)},
    			{Min=40,Max=59,Mon="Brute",Qdata=2,Qname="BuggyQuest1",NameMon="Brute",PosQ=CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627),PosM=CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)},
    			{Min=60,Max=74,Mon="Desert Bandit",Qdata=1,Qname="DesertQuest",NameMon="Desert Bandit",PosQ=CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693),PosM=CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)},
    			{Min=75,Max=89,Mon="Desert Officer",Qdata=2,Qname="DesertQuest",NameMon="Desert Officer",PosQ=CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693),PosM=CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)},
    			{Min=90,Max=99,Mon="Snow Bandit",Qdata=1,Qname="SnowQuest",NameMon="Snow Bandit",PosQ=CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685),PosM=CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)},
    			{Min=100,Max=119,Mon="Snowman",Qdata=2,Qname="SnowQuest",NameMon="Snowman",PosQ=CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685),PosM=CFrame.new(6241.9951171875, 51.522083282471, -1243.9771728516)},
    			{Min=120,Max=149,Mon="Chief Petty Officer",Qdata=1,Qname="MarineQuest2",NameMon="Chief Petty Officer",PosQ=CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)},
    			{Min=150,Max=174,Mon="Sky Bandit",Qdata=1,Qname="SkyQuest",NameMon="Sky Bandit",PosQ=CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268),PosM=CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625)},
    			{Min=175,Max=189,Mon="Dark Master",Qdata=2,Qname="SkyQuest",NameMon="Dark Master",PosQ=CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268),PosM=CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625)},
    			{Min=190,Max=209,Mon="Prisoner",Qdata=1,Qname="PrisonerQuest",NameMon="Prisoner",PosQ=CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712),PosM=CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781)},
    			{Min=210,Max=249,Mon="Dangerous Prisoner",Qdata=2,Qname="PrisonerQuest",NameMon="Dangerous Prisoner",PosQ=CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712),PosM=CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)},
    			{Min=250,Max=274,Mon="Toga Warrior",Qdata=1,Qname="ColosseumQuest",NameMon="Toga Warrior",PosQ=CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298),PosM=CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625)},
    			{Min=275,Max=299,Mon="Gladiator",Qdata=2,Qname="ColosseumQuest",NameMon="Gladiator",PosQ=CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298),PosM=CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625)},
    			{Min=300,Max=324,Mon="Military Soldier",Qdata=1,Qname="MagmaQuest",NameMon="Military Soldier",PosQ=CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469),PosM=CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875),Boubty=false},
    			{Min=325,Max=374,Mon="Military Spy",Qdata=2,Qname="MagmaQuest",NameMon="Military Spy",PosQ=CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469),PosM=CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375)},
    			{Min=375,Max=399,Mon="Fishman Warrior",Qdata=1,Qname="FishmanQuest",NameMon="Fishman Warrior",PosQ=CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734),PosM=CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)},
    			{Min=400,Max=449,Mon="Fishman Commando",Qdata=2,Qname="FishmanQuest",NameMon="Fishman Commando",PosQ=CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734),PosM=CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)},
    			{Min=450,Max=474,Mon="God's Guard",Qdata=1,Qname="SkyExp1Quest",NameMon="God's Guard",PosQ=CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, 0, 1, -0, 0.0871884301, 0, 0.996191859),PosM=CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)},
    			{Min=475,Max=524,Mon="Shanda",Qdata=2,Qname="SkyExp1Quest",NameMon="Shanda",PosQ=CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998),PosM=CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531)},
    			{Min=525,Max=549,Mon="Royal Squad",Qdata=1,Qname="SkyExp2Quest",NameMon="Royal Squad",PosQ=CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)},
    			{Min=550,Max=624,Mon="Royal Soldier",Qdata=2,Qname="SkyExp2Quest",NameMon="Royal Soldier",PosQ=CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)},
    			{Min=625,Max=649,Mon="Galley Pirate",Qdata=1,Qname="FountainQuest",NameMon="Galley Pirate",PosQ=CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381),PosM=CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)},
    			{Min=650,Mon="Galley Captain",Qdata=2,Qname="FountainQuest",NameMon="Galley Captain",PosQ=CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381),PosM=CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)},
    		  },
    		  [2]={
    			{Max=724,Mon="Raider",Qdata=1,Qname="Area1Quest",NameMon="Raider",PosQ=CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985),PosM=CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)},
    			{Min=725,Max=774,Mon="Mercenary",Qdata=2,Qname="Area1Quest",NameMon="Mercenary",PosQ=CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985),PosM=CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)},
    			{Min=775,Max=799,Mon="Swan Pirate",Qdata=1,Qname="Area2Quest",NameMon="Swan Pirate",PosQ=CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906),PosM=CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)},
    			{Min=800,Max=874,Mon="Factory Staff",Qdata=2,Qname="Area2Quest",NameMon="Factory Staff",PosQ=CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369),PosM=CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)},
    			{Min=875,Max=899,Mon="Marine Lieutenant",Qdata=1,Qname="MarineQuest3",NameMon="Marine Lieutenant",PosQ=CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268),PosM=CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)},
    			{Min=900,Max=949,Mon="Marine Captain",Qdata=2,Qname="MarineQuest3",NameMon="Marine Captain",PosQ=CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268),PosM=CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)},
    			{Min=950,Max=974,Mon="Zombie",Qdata=1,Qname="ZombieQuest",NameMon="Zombie",PosQ=CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146),PosM=CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)},
    			{Min=975,Max=999,Mon="Vampire",Qdata=2,Qname="ZombieQuest",NameMon="Vampire",PosQ=CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146),PosM=CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)},
    			{Min=1000,Max=1049,Mon="Snow Trooper",Qdata=1,Qname="SnowMountainQuest",NameMon="Snow Trooper",PosQ=CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106),PosM=CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)},
    			{Min=1050,Max=1099,Mon="Winter Warrior",Qdata=2,Qname="SnowMountainQuest",NameMon="Winter Warrior",PosQ=CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106),PosM=CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)},
    			{Min=1100,Max=1124,Mon="Lab Subordinate",Qdata=1,Qname="IceSideQuest",NameMon="Lab Subordinate",PosQ=CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578),PosM=CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)},
    			{Min=1125,Max=1174,Mon="Horned Warrior",Qdata=2,Qname="IceSideQuest",NameMon="Horned Warrior",PosQ=CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578),PosM=CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)},
    			{Min=1175,Max=1199,Mon="Magma Ninja",Qdata=1,Qname="FireSideQuest",NameMon="Magma Ninja",PosQ=CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213),PosM=CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)},
    			{Min=1200,Max=1249,Mon="Lava Pirate",Qdata=2,Qname="FireSideQuest",NameMon="Lava Pirate",PosQ=CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213),PosM=CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)},
    			{Min=1250,Max=1274,Mon="Ship Deckhand",Qdata=1,Qname="ShipQuest1",NameMon="Ship Deckhand",PosQ=CFrame.new(1037.80127, 125.092171, 32911.6016),PosM=CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)},
    			{Min=1275,Max=1299,Mon="Ship Engineer",Qdata=2,Qname="ShipQuest1",NameMon="Ship Engineer",PosQ=CFrame.new(1037.80127, 125.092171, 32911.6016),PosM=CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)},
    			{Min=1300,Max=1324,Mon="Ship Steward",Qdata=1,Qname="ShipQuest2",NameMon="Ship Steward",PosQ=CFrame.new(968.80957, 125.092171, 33244.125),PosM=CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)},
    			{Min=1325,Max=1349,Mon="Ship Officer",Qdata=2,Qname="ShipQuest2",NameMon="Ship Officer",PosQ=CFrame.new(968.80957, 125.092171, 33244.125),PosM=CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)},
    			{Min=1350,Max=1374,Mon="Arctic Warrior",Qdata=1,Qname="FrostQuest",NameMon="Arctic Warrior",PosQ=CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909),PosM=CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)},
    			{Min=1375,Max=1424,Mon="Snow Lurker",Qdata=2,Qname="FrostQuest",NameMon="Snow Lurker",PosQ=CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909),PosM=CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)},
    			{Min=1425,Max=1449,Mon="Sea Soldier",Qdata=1,Qname="ForgottenQuest",NameMon="Sea Soldier",PosQ=CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376),PosM=CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)},
    			{Min=1450,Mon="Water Fighter",Qdata=2,Qname="ForgottenQuest",NameMon="Water Fighter",PosQ=CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376),PosM=CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875)},
    		  },
    		  [3]={
    			{Max=1524,Mon="Pirate Millionaire",Qdata=1,Qname="PiratePortQuest",NameMon="Pirate Millionaire",PosQ=CFrame.new(-712.8272705078125, 98.5770492553711, 5711.9541015625),PosM=CFrame.new(-712.8272705078125, 98.5770492553711, 5711.9541015625)},
    			{Min=1525,Max=1574,Mon="Pistol Billionaire",Qdata=2,Qname="PiratePortQuest",NameMon="Pistol Billionaire",PosQ=CFrame.new(-723.4331665039062, 147.42906188964844, 5931.9931640625),PosM=CFrame.new(-723.4331665039062, 147.42906188964844, 5931.9931640625)},
    			{Min=1575,Max=1599,Mon="Dragon Crew Warrior",Qdata=1,Qname="AmazonQuest",NameMon="Dragon Crew Warrior",PosQ=CFrame.new(6779.03271484375, 111.16865539550781, -801.2130737304688),PosM=CFrame.new(6779.03271484375, 111.16865539550781, -801.2130737304688)},
    			{Min=1600,Max=1624,Mon="Dragon Crew Archer",Qdata=2,Qname="AmazonQuest",NameMon="Dragon Crew Archer",PosQ=CFrame.new(6955.8974609375, 546.6658935546875, 309.0401306152344),PosM=CFrame.new(6955.8974609375, 546.6658935546875, 309.0401306152344)},
    			{Min=1625,Max=1649,Mon="Hydra Enforcer",Qdata=1,Qname="VenomCrewQuest",NameMon="Hydra Enforcer",PosQ=CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219),PosM=CFrame.new(4620.61572265625, 1002.2954711914062, 399.0868835449219)},
    			{Min=1650,Max=1699,Mon="Venomous Assailant",Qdata=2,Qname="VenomCrewQuest",NameMon="Venomous Assailant",PosQ=CFrame.new(4697.5918, 1100.65137, 946.401978, 0.579397917, -4.19689783e-10, 0.81504482, -1.49287818e-10, 1, 6.21053986e-10, -0.81504482, -4.81513662e-10, 0.579397917),PosM=CFrame.new(4697.5918, 1100.65137, 946.401978, 0.579397917, -4.19689783e-10, 0.81504482, -1.49287818e-10, 1, 6.21053986e-10, -0.81504482, -4.81513662e-10, 0.579397917)},
    			{Min=1700,Max=1724,Mon="Marine Commodore",Qdata=1,Qname="MarineTreeIsland",NameMon="Marine Commodore",PosQ=CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747),PosM=CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)},
    			{Min=1725,Max=1774,Mon="Marine Rear Admiral",Qdata=2,Qname="MarineTreeIsland",NameMon="Marine Rear Admiral",PosQ=CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813),PosM=CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125)},
    			{Min=1775,Max=1799,Mon="Fishman Raider",Qdata=1,Qname="DeepForestIsland3",NameMon="Fishman Raider",PosQ=CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213),PosM=CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)},
    			{Min=1800,Max=1824,Mon="Fishman Captain",Qdata=2,Qname="DeepForestIsland3",NameMon="Fishman Captain",PosQ=CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213),PosM=CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625)},
    			{Min=1825,Max=1849,Mon="Forest Pirate",Qdata=1,Qname="DeepForestIsland",NameMon="Forest Pirate",PosQ=CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247),PosM=CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)},
    			{Min=1850,Max=1899,Mon="Mythological Pirate",Qdata=2,Qname="DeepForestIsland",NameMon="Mythological Pirate",PosQ=CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247),PosM=CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)},
    			{Min=1900,Max=1924,Mon="Jungle Pirate",Qdata=1,Qname="DeepForestIsland2",NameMon="Jungle Pirate",PosQ=CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002),PosM=CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)},
    			{Min=1925,Max=1974,Mon="Musketeer Pirate",Qdata=2,Qname="DeepForestIsland2",NameMon="Musketeer Pirate",PosQ=CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002),PosM=CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)},
    			{Min=1975,Max=1999,Mon="Reborn Skeleton",Qdata=1,Qname="HauntedQuest1",NameMon="Reborn Skeleton",PosQ=CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0),PosM=CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)},
    			{Min=2000,Max=2024,Mon="Living Zombie",Qdata=2,Qname="HauntedQuest1",NameMon="Living Zombie",PosQ=CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0),PosM=CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)},
    			{Min=2025,Max=2049,Mon="Demonic Soul",Qdata=1,Qname="HauntedQuest2",NameMon="Demonic Soul",PosQ=CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)},
    			{Min=2050,Max=2074,Mon="Posessed Mummy",Qdata=2,Qname="HauntedQuest2",NameMon="Posessed Mummy",PosQ=CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)},
    			{Min=2075,Max=2099,Mon="Peanut Scout",Qdata=1,Qname="NutsIslandQuest",NameMon="Peanut Scout",PosQ=CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)},
    			{Min=2100,Max=2124,Mon="Peanut President",Qdata=2,Qname="NutsIslandQuest",NameMon="Peanut President",PosQ=CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)},
    			{Min=2125,Max=2149,Mon="Ice Cream Chef",Qdata=1,Qname="IceCreamIslandQuest",NameMon="Ice Cream Chef",PosQ=CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)},
    			{Min=2150,Max=2199,Mon="Ice Cream Commander",Qdata=2,Qname="IceCreamIslandQuest",NameMon="Ice Cream Commander",PosQ=CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0),PosM=CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)},
    			{Min=2200,Max=2224,Mon="Cookie Crafter",Qdata=1,Qname="CakeQuest1",NameMon="Cookie Crafter",PosQ=CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931),PosM=CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)},
    			{Min=2225,Max=2249,Mon="Cake Guard",Qdata=2,Qname="CakeQuest1",NameMon="Cake Guard",PosQ=CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931),PosM=CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)},
    			{Min=2250,Max=2274,Mon="Baking Staff",Qdata=1,Qname="CakeQuest2",NameMon="Baking Staff",PosQ=CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446),PosM=CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)},
    			{Min=2275,Max=2299,Mon="Head Baker",Qdata=2,Qname="CakeQuest2",NameMon="Head Baker",PosQ=CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446),PosM=CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)},
    			{Min=2300,Max=2324,Mon="Cocoa Warrior",Qdata=1,Qname="ChocQuest1",NameMon="Cocoa Warrior",PosQ=CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375),PosM=CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)},
    			{Min=2325,Max=2349,Mon="Chocolate Bar Battler",Qdata=2,Qname="ChocQuest1",NameMon="Chocolate Bar Battler",PosQ=CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375),PosM=CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)},
    			{Min=2350,Max=2374,Mon="Sweet Thief",Qdata=1,Qname="ChocQuest2",NameMon="Sweet Thief",PosQ=CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875),PosM=CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)},
    			{Min=2375,Max=2399,Mon="Candy Rebel",Qdata=2,Qname="ChocQuest2",NameMon="Candy Rebel",PosQ=CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875),PosM=CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)},
    			{Min=2400,Max=2449,Mon="Candy Pirate",Qdata=1,Qname="CandyQuest1",NameMon="Candy Pirate",PosQ=CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375),PosM=CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)},
    			{Min=2450,Max=2474,Mon="Isle Outlaw",Qdata=1,Qname="TikiQuest1",NameMon="Isle Outlaw",PosQ=CFrame.new(-16548.8164, 55.6059914, -172.8125, 0.213092566, -0, -0.977032006, 0, 1, -0, 0.977032006, 0, 0.213092566),PosM=CFrame.new(-16479.900390625, 226.6117401123047, -300.3114318847656)},
    			{Min=2475,Max=2499,Mon="Island Boy",Qdata=2,Qname="TikiQuest1",NameMon="Island Boy",PosQ=CFrame.new(-16548.8164, 55.6059914, -172.8125, 0.213092566, -0, -0.977032006, 0, 1, -0, 0.977032006, 0, 0.213092566),PosM=CFrame.new(-16849.396484375, 192.86505126953125, -150.7853240966797)},
    			{Min=2500,Max=2524,Mon="Sun-kissed Warrior",Qdata=1,Qname="TikiQuest2",NameMon="kissed Warrior",PosQ=CFrame.new(-16538, 55, 1049),PosM=CFrame.new(-16347, 64, 984)},
    			{Min=2525,Max=2550,Mon="Isle Champion",Qdata=2,Qname="TikiQuest2",NameMon="Isle Champion",PosQ=CFrame.new(-16541.0215, 57.3082275, 1051.46118, 0.0410757065, -0, -0.999156058, 0, 1, -0, 0.999156058, 0, 0.0410757065),PosM=CFrame.new(-16602.1015625, 130.38734436035156, 1087.24560546875)},
    			{Min=2551,Max=2574,Mon="Serpent Hunter",Qdata=1,Qname="TikiQuest3",NameMon="Serpent Hunter",PosQ=CFrame.new(-16679.4785, 176.7473, 1474.3995),PosM=CFrame.new(-16679.4785, 176.7473, 1474.3995)},
    			{Min=2575,Max=2599,Mon="Skull Slayer",Qdata=2,Qname="TikiQuest3",NameMon="Skull Slayer",PosQ=CFrame.new(-16759.5898, 71.2837, 1595.3399),PosM=CFrame.new(-16759.5898, 71.2837, 1595.3399)},
    			{Min=2600,Max=2624,Mon="Reef Bandit",Qdata=1,Qname="SubmergedQuest1",NameMon="Reef Bandit",PosQ=CFrame.new(10778.875, -2087.72437, 9265.18359),PosM=CFrame.new(11019.1318, -2146.06812, 9342.3916)},
    			{Min=2625,Max=2649,Mon="Coral Pirate",Qdata=2,Qname="SubmergedQuest1",NameMon="Coral Pirate",PosQ=CFrame.new(10778.875, -2087.72437, 9265.18359),PosM=CFrame.new(10808.6006, -2030.36145, 9364.2334)},
    			{Min=2650,Max=2674,Mon="Sea Chanter",Qdata=1,Qname="SubmergedQuest2",NameMon="Sea Chanter",PosQ=CFrame.new(10880.6855, -2086.20044, 10032.624),PosM=CFrame.new(10671.2715, -2057.59155, 10047.2588)},
    			{Min=2675,Max=2699,Mon="Ocean Prophet",Qdata=2,Qname="SubmergedQuest2",NameMon="Ocean Prophet",PosQ=CFrame.new(10880.6855, -2086.20044, 10032.624),PosM=CFrame.new(11008.5195, -2007.72839, 10223.0791)},
    			{Min=2700,Max=2724,Mon="High Disciple",Qdata=1,Qname="SubmergedQuest3",NameMon="High Disciple",PosQ=CFrame.new(9640.08789, -1992.44507, 9613.65234),PosM=CFrame.new(9750.41602, -1966.93884, 9753.36035)},
    			{Min=2725,Max=2800,Mon="Grand Devotee",Qdata=2,Qname="SubmergedQuest3",NameMon="Grand Devotee",PosQ=CFrame.new(9640.08789, -1992.44507, 9613.65234),PosM=CFrame.new(9611.70508, -1993.47119, 9882.68848)},
    		  },
    		},
    	},
    
    	LegacySeaRules = {
    		Mirage = {3},
    		Race = {2, 3},
    		Drago = {3},
    		Prehistoric = {3},
    		Raids = {2, 3},
    		SeaEvent = {2, 3},
    	},
    
    	SectionLayoutProfiles = {
    		Home = {
    			["dashboard"]={Title="Player Overview",Column="Left",Order=10},
    			["server status"]={Column="Right",Order=10},
    			["community & release"]={Column="Right",Order=20},
    			["latest updates"]={FullWidth=true,Order=90},
    		},
    		Farm = {
    			["farming"]={Title="Auto Farm",Column="Left",Order=10},
    			["collect chest"]={Title="Collection",Column="Left",Order=20,MergeKey="farm.collection"},
    			["collect berry"]={Title="Collection",Column="Left",Order=20,MergeKey="farm.collection"},
    			["farming cake"]={Title="Special Farm",Column="Left",Order=30,MergeKey="farm.special"},
    			["farming bone"]={Title="Special Farm",Column="Left",Order=30,MergeKey="farm.special"},
    			["farm material"]={Title="Special Farm",Column="Left",Order=30,MergeKey="farm.special"},
    			["farm elite hunter"]={Title="Boss & Elite",Column="Right",Order=10,MergeKey="farm.boss"},
    			["farm boss"]={Title="Boss & Elite",Column="Right",Order=10,MergeKey="farm.boss"},
    			["tyrant of the skies"]={Title="Boss & Elite",Column="Right",Order=10,MergeKey="farm.boss"},
    			["farm status"]={Column="Right",Order=20},
    			["farming mastery"]={Title="Mastery",Column="Right",Order=30},
    		},
    		Progress = {
    			["tushita and yama"]={Column="Left",Order=10},
    			["cursed dual katana"]={Column="Right",Order=10},
    			["true triple katana sword"]={Column="Left",Order=20},
    			["pole / god enal's"]={Column="Right",Order=20},
    			["pole / god enal"]={Column="Right",Order=20},
    			["items law / order sword"]={Column="Left",Order=30},
    			["east blue misc"]={Column="Right",Order=30},
    			["rengoku sword"]={Column="Left",Order=40},
    			["cavender + twin hooks + bigmom"]={Column="Right",Order=40},
    			["buso / aura colours"]={Column="Left",Order=50},
    			["instinct / observation"]={Column="Right",Order=50},
    			["dark dragger + valkyrie"]={Column="Left",Order=60},
    			["upgrade races v3"]={Column="Right",Order=60},
    			["trials quest v4"]={Column="Right",Order=70},
    			["dojo quest & drago race"]={Column="Left",Order=70},
    			["drago trial"]={Column="Right",Order=80},
    			["stats upgrade"]={Column="Left",Order=90},
    		},
    		Items = {
    			["shop options"]={Title="Abilities & Skills",Column="Right",Order=10,MergeKey="items.abilities"},
    			["fighting style · equip"]={Column="Left",Order=20},
    			["basic abilities"]={Title="Abilities & Skills",Column="Right",Order=10,MergeKey="items.abilities"},
    			["accessory sea 1"]={Title="Accessories",Column="Left",Order=20,MergeKey="items.accessories"},
    			["ectoplasm shop"]={Title="Accessories",Column="Left",Order=20,MergeKey="items.accessories"},
    			["accessory seaevent"]={Title="Accessories",Column="Left",Order=40,MergeKey="items.accessories"},
    			["fragments shop"]={Title="Fragments & Race",Column="Right",Order=40},
    			["ownership status"]={Title="Ownership Status",Column="Right",Order=80},
    		},
    		World = {
    			["fishing"]={Column="Left",Order=10},
    			["mystic island / full moon"]={Column="Right",Order=10},
    			["skull guitars / misc"]={Column="Right",Order=20},
    			["volcanic magnet"]={Column="Left",Order=20},
    			["prehistoric island"]={Column="Left",Order=30},
    			["sea event / setting sail"]={Column="Right",Order=30},
    			["entity sea event"]={Column="Left",Order=40},
    			["kitsune island / event"]={Column="Right",Order=40},
    		},
    		Raid = {
    			["dungeon event / raiding"]={Column="Left",Order=10},
    			["raiding menu"]={Column="Right",Order=10},
    			["law raid"]={Column="Right",Order=20},
    		},
    		Teleport = {
    
    			["travel - worlds"]={Column="Left",Order=10,FullWidth=false},
    			["travel - island"]={Column="Left",Order=20,FullWidth=false},
    			["teleport - npc"]={Column="Left",Order=30,FullWidth=false},
    			["teleport - player"]={Column="Right",Order=10,FullWidth=false},
    			["server navigation"]={Column="Right",Order=20,FullWidth=false},
    			["travel automation"]={Column="Right",Order=30,FullWidth=false},
    		},
    		Combat = {
    			["attack & targeting"]={Column="Left",Order=10,FullWidth=false},
    			["combat assist"]={Column="Right",Order=10,FullWidth=false},
    		},
    		Settings = {
    			["interface"]={Column="Left",Order=10},
    			["startup & team"]={Column="Right",Order=10},
    			["runtime safety"]={Column="Right",Order=20},
    			["settings / configure"]={Column="Left",Order=20},
    			["esp"]={Column="Left",Order=30},
    			["interface & utilities"]={Column="Right",Order=30},
    			["graphics & haki"]={Column="Left",Order=40},
    			["display & movement"]={Column="Right",Order=40},
    		},
    	},
    
    	SectionSeaRules = {
    		Main = {
    			["farm elite hunter"] = {3},
    			["farming cake"] = {3},
    			["unlocked dungeon"] = {3},
    			["farming bone"] = {3},
    			["tyrant of the skies"] = {3},
    		},
    		Quests = {
    			["tushita and yama"] = {3},
    			["cursed dual katana"] = {3},
    			["true triple katana sword"] = {2},
    			["pole / god enal"] = {1, 2, 3},
    			["pole / god enal's"] = {1, 2, 3},
    			["items law / order sword"] = {2},
    			["first sea obtainables"] = {1},
    			["rengoku sword"] = {2},
    			["cavender + twin hooks + bigmom"] = {3},
    			["dark dragger + valkyrie"] = {3},
    		},
    		Race = {
    			["upgrade races v3"] = {2},
    			["trials quest v4"] = {3},
    		},
    		SeaEvent = {
    			["kitsune island / event"] = {3},
    		},
    		Shop = {
    			["shop options"] = {1},
    			["accessory sea 1"] = {1},
    			["ectoplasm shop"] = {2},
    			["accessory seaevent"] = {3},
    			["fragments shop"] = {2},
    			["weapon world 1"] = {1},
    		},
    	},
    
    	FeatureSeaRules = {
    
    		["Auto Get Pole V1"] = {1},
    		["Auto Pole V2"] = {2, 3},
    		["Auto Bisento V2"] = {1},
    		["Auto Get Shark Saw"] = {1},
    		["Auto Get Saber"] = {1},
    		["Auto Get Cool Shades"] = {1},
    		["Auto Get Usoap's Hat"] = {1, 2, 3},
    		["Auto Get Marine Cap"] = {1, 2, 3},
    		["Auto Get Wardens Sword"] = {1},
    		["Auto Get Coat"] = {1},
    		["Auto Get Pink Coat"] = {1},
    		["Auto Get Magma Blaster"] = {1},
    		["Auto Get Trident"] = {1},
    		["Auto Get Bazooka"] = {1},
    		["Auto Quest Sea 2"] = {1},
    		["Auto Pirate Raid"] = {3},
    		["Auto Private Raid"] = {3},
    		["Auto Teleport Barista Cousin"] = {2},
    		["Auto Haki Rainbow"] = {3},
    		["Get Quest Haki Rainbow"] = {3},
    		["Auto Haki Observation V2"] = {3},
    		["Auto Complete Quest Bartilo"] = {2},
    		["Auto Complete Quest Citizen"] = {3},
    		["Auto Farm Training Dummy"] = {3},
    		["Auto Kill Shark"] = {2, 3},
    		["Auto Kill Piranha"] = {2, 3},
    		["Auto Kill Terror Shark"] = {3},
    		["Auto Attack Fish Crew Member"] = {3},
    		["Auto Attack Haunted Crew Member"] = {3},
    		["Auto Attack Leviathan"] = {3},
    		["Auto Teleport Frozen Dimension"] = {3},
    		["Buy Spy"] = {3},        ["Spy Status"] = {3},        ["Frozen Dimension status"] = {3},
    
    		["Auto Factory Raid"] = {2},
    		["Auto Farm Ectoplasm"] = {2},
    		["Auto Get Law Sword"] = {2},
    		["Buy Microchip Law"] = {2},
    		["Start Law Raid"] = {2},
    		["Auto Buy Chip Law"] = {2},
    		["Auto Start Law"] = {2},
    		["Auto Raid Law"] = {2},
    		["Auto Drive To Hydra Island"] = {3},
    		["Auto Farm Tyrant of the Skies"] = {3},
    
    		["Auto Get Dark Step"] = {1, 2, 3},
    		["Auto Get Electric"] = {1, 2, 3},
    		["Auto Get Water Kung Fu"] = {1, 2, 3},
    		["Auto Get Dragon Breath"] = {2, 3},
    		["Auto Get Superhuman"] = {2, 3},
    		["Auto Get DeathStep"] = {2, 3},
    		["Auto Get Sharkman Karate"] = {2, 3},
    		["Auto Get ElectricClaw"] = {3},
    		["Auto Get DragonTalon"] = {3},
    		["Auto Get GodHuman"] = {3},
    		["Auto Get SanguineArt"] = {3},
    
    		["Use Dark Step"] = {1, 2, 3},
    		["Use Electric"] = {1, 2, 3},
    		["Use Water Kung Fu"] = {1, 2, 3},
    		["Use Dragon Breath"] = {2, 3},
    		["Use Superhuman"] = {2, 3},
    		["Use Death Step"] = {2, 3},
    		["Use Sharkman Karate"] = {2, 3},
    		["Use Electric Claw"] = {3},
    		["Use Dragon Talon"] = {3},
    		["Use Godhuman"] = {3},
    		["Use Sanguine Art"] = {3},
    		["Buy Buso"] = {1}, ["Buy Geppo"] = {1}, ["Buy Soru"] = {1}, ["Buy Ken"] = {1},
    		["Buy Tomoe Ring"] = {1}, ["Buy Black Cape"] = {1}, ["Buy Swordsman Hat"] = {1},
    		["Buy Refined Slingshot"] = {1},
    		["Buy Bizarre Revolver"] = {2}, ["Buy Ghoul Mask"] = {2}, ["Buy Kabucha"] = {2},
    		["Refund Stats"] = {2}, ["Reroll Race"] = {2}, ["Buy Ghoul Race"] = {2}, ["Buy Cyborg Race"] = {2},
    		["Craft DragonHeart"] = {3},
    		["Craft DragonStorm"] = {3},
    		["Craft Dino Hood"] = {3},
    		["Craft Shark Tooth Necklace"] = {3},
    		["Craft Terror Jaw"] = {3},
    		["Craft Leviathan Crown"] = {3},
    		["Craft Leviathan Shield"] = {3},
    		["Craft Beast Hunter Boat"] = {3},
    		["Craft LegendaryScroll"] = {3},
    		["Craft MythicalScroll"] = {3},
    	},
    
    	NPCSeaRules = {
    		["Barista Cousin"] = {2},
    		["Legendary Sword Dealer"] = {2},
    		["Manager"] = {2},
    		["Alchemist"] = {2},
    		["Arowe"] = {2},
    		["Previous Hero"] = {3},
    		["Uzoth"] = {3},
    		["Dragon Hunter"] = {3},
    		["Dojo Trainer"] = {3},
    		["Dragon Wizard"] = {3},
    		["Shark Hunter"] = {3},
    		["Beast Hunter"] = {3},
    		["Spy"] = {3},
    	},
    
    	FightingStyleCatalog = {
    		DarkStep={Id="dark_step",Name="Dark Step",Internal="Black Leg",FirstObtainableSea=1,Seas={1,2,3},Price=150000,Currency="Beli",NPC="Dark Step Teacher",Locations={"Pirate Village","Hot and Cold","Castle on the Sea"},Remote="BuyBlackLeg"},
    		Electric={Id="electric",Name="Electric",Internal="Electro",FirstObtainableSea=1,Seas={1,2,3},Price=500000,Currency="Beli",NPC="Mad Scientist",Locations={"Skylands · Lower","Hot and Cold","Castle on the Sea"},Remote="BuyElectro"},
    		WaterKungFu={Id="water_kung_fu",Name="Water Kung Fu",Internal="Fishman Karate",FirstObtainableSea=1,Seas={1,2,3},Price=750000,Currency="Beli",NPC="Water Kung Fu Teacher",Locations={"Underwater City","Hot and Cold","Castle on the Sea"},Remote="BuyFishmanKarate"},
    	},
    
    	BossCatalog = {
    		["The Saw"]={Id="the_saw",Seas={1},Level=100,Location="Middle Town",SpawnSeconds=4500,DespawnSeconds=900,Aliases={"The Saw","Saw"},Drops={{Name="Shark Saw",Chance="Unknown"}},MinimumDamageShare=0.10},
    		["Mob Leader"]={Id="mob_leader",Seas={1},Level=120,Location="Jean-Luc Island",Aliases={"Mob Leader"},QuestChain="Saber Puzzle"},
    		["Vice Admiral"]={Id="vice_admiral",Seas={1},Level=130,QuestLevel=130,Location="Marine Fortress",Aliases={"Vice Admiral"},Drops={{Name="Coat",Chance=0.05}}},
    		["Saber Expert"]={Id="saber_expert",Seas={1},Level=200,Location="Jungle",Aliases={"Saber Expert"},Drops={{Name="Saber",Chance=1}},QuestChain="Saber Puzzle"},
    		["Chief Warden"]={Id="chief_warden",Seas={1},Level=230,QuestLevel=230,Location="Prison",Aliases={"Chief Warden"},Drops={{Name="Wardens Sword",Chance="5-10%"}}},
    		["Swan"]={Id="swan",Seas={1},Level=240,QuestLevel=240,Location="Prison",SpawnSeconds=1800,Aliases={"Swan"},Drops={{Name="Pink Coat",Chance="Unknown"}}},
    		["Magma Admiral"]={Id="magma_admiral",Seas={1},Level=350,QuestLevel=350,Location="Magma Village",SpawnSeconds=600,Aliases={"Magma Admiral"},Drops={{Name="Magma Blaster",Chance="Low/unknown"}}},
    		["Fishman Lord"]={Id="fishman_lord",Seas={1},Level=425,QuestLevel=425,Location="Underwater City",SpawnSeconds=480,Aliases={"Fishman Lord"},Phases=2,Drops={{Name="Trident",Chance=0.10}}},
    		["Wysper"]={Id="wysper",Seas={1},Level=500,QuestLevel=500,Location="Upper Skylands",SpawnSeconds=600,Aliases={"Wysper"},Drops={{Name="Bazooka",Chance=0.05}}},
    		["Thunder God"]={Id="thunder_god",Seas={1},Level=575,QuestLevel=575,Location="Upper Skylands",SpawnSeconds=600,Aliases={"Thunder God"},Drops={{Name="Pole (1st Form)",Chance=0.06}}},
    		["Cyborg"]={Id="cyborg",Seas={1},Level=675,QuestLevel=675,Location="Fountain City",SpawnSeconds=720,Aliases={"Cyborg"},Drops={{Name="Cool Shades",Chance="1-2%"}}},
    		["Ice Admiral"]={Id="ice_admiral",Seas={1},Level=700,Location="Frozen Village",Aliases={"Ice Admiral"},QuestChain="Second Sea Access"},
    		["Greybeard"]={Id="greybeard",Seas={1},Level=750,HP=303750,Location="Marine Fortress",Aliases={"Greybeard"},RaidBoss=true,Upgrade="Bisento V1 -> V2",MinimumDamageShare=0.10},
    	},
    
    	ProgressionCatalog = {
    		PoleV1 = {Id="pole_v1",Name="Pole (1st Form)",Seas={1},Category="Sword",Boss="Thunder God",Ownership="Pole V1",FarmFeature="Auto Get Pole V1",Requirements={"Defeat Thunder God"}},
    		PoleV2 = {Id="pole_v2",Name="Pole (2nd Form)",Seas={2,3},Category="Sword",Ownership="Pole V2",FarmFeature="Auto Pole V2",Requirements={"Own Pole (1st Form)","Hold Pole (1st Form) in Rough Sea","Be struck by natural Rough Sea lightning"},Note="Current method; no Rumble awakening, mastery 180 or Fragment payment."},
    		BisentoV2 = {Id="bisento_v2",Name="Bisento V2",Seas={1},Category="Sword",Boss="Greybeard",Ownership="Bisento V2",FarmFeature="Auto Bisento V2",MinimumDamageShare=0.10,Requirements={"Own Bisento V1","Deal at least 10% of Greybeard's max HP","Defeat Greybeard"},Note="Bisento only needs to be owned; it does not need to be equipped during the Greybeard fight."},
    		SharkSaw = {Id="shark_saw",Name="Shark Saw",Seas={1},Category="Sword",Boss="The Saw",Ownership="Shark Saw",FarmFeature="Auto Get Shark Saw",Requirements={"Defeat The Saw","Meet boss reward damage requirement"}},
    		Saber = {Id="saber",Name="Saber",Seas={1},Category="Sword",Boss="Saber Expert",Ownership="Saber",FarmFeature="Auto Get Saber",Requirements={"Level 200+","Complete Saber Puzzle","Defeat Saber Expert"}},
    		WardensSword = {Id="wardens_sword",Name="Wardens Sword",Seas={1},Category="Sword",Boss="Chief Warden",Ownership="Wardens Sword",FarmFeature="Auto Get Wardens Sword",Requirements={"Defeat Chief Warden"}},
    		Coat = {Id="coat",Name="Coat",Seas={1},Category="Accessory",Boss="Vice Admiral",Ownership="Coat",FarmFeature="Auto Get Coat",Requirements={"Defeat Vice Admiral"}},
    		PinkCoat = {Id="pink_coat",Name="Pink Coat",Seas={1},Category="Accessory",Boss="Swan",Ownership="Pink Coat",FarmFeature="Auto Get Pink Coat",Requirements={"Defeat Swan"}},
    		MagmaBlaster = {Id="magma_blaster",Name="Magma Blaster",Aliases={"Refined Musket"},Seas={1},Category="Gun",Boss="Magma Admiral",Ownership="Magma Blaster",FarmFeature="Auto Get Magma Blaster",Requirements={"Defeat Magma Admiral"}},
    		Trident = {Id="trident",Name="Trident",Seas={1},Category="Sword",Boss="Fishman Lord",Ownership="Trident",FarmFeature="Auto Get Trident",Requirements={"Defeat both Fishman Lord phases"}},
    		Bazooka = {Id="bazooka",Name="Bazooka",Seas={1},Category="Gun",Boss="Wysper",Ownership="Bazooka",FarmFeature="Auto Get Bazooka",Requirements={"Defeat Wysper"}},
    		CoolShades = {Id="cool_shades",Name="Cool Shades",Seas={1},Category="Accessory",Boss="Cyborg",Ownership="Cool Shades",FarmFeature="Auto Get Cool Shades",Requirements={"Defeat Cyborg"}},
    		UsoapHat = {Id="usoap_hat",Name="Usoap's Hat",Seas={1,2,3},Category="Accessory",Ownership="Usoap's Hat",FarmFeature="Auto Get Usoap's Hat",RequiredFaction="Pirates",Requirements={"Pirates team","250,000+ Bounty","Defeat 3 players near your level"}},
    		MarineCap = {Id="marine_cap",Name="Marine Cap",Seas={1,2,3},Category="Accessory",Ownership="Marine Cap",FarmFeature="Auto Get Marine Cap",RequiredFaction="Marines",Requirements={"Marines team","250,000+ Honor","Defeat an eligible Pirate"}},
    		Aura = {Id="aura",Name="Aura",Seas={1},Category="Ability",NPC="Ability Teacher",Ownership="Buso"},
    		AirJump = {Id="air_jump",Name="Air Jump",Seas={1},Category="Ability",NPC="Ability Teacher",Ownership="Geppo"},
    		FlashStep = {Id="flash_step",Name="Flash Step",Seas={1},Category="Ability",NPC="Ability Teacher",Ownership="Soru"},
    		Instinct = {Id="instinct",Name="Instinct",Seas={1},Category="Ability",NPC="Instinct Teacher",Ownership="Ken",Requirements={"Level 300+","Saber Puzzle completed"}},
    		SecondSeaAccess = {
			Id="second_sea_access",Name="Second Sea Access",Seas={1},Category="Quest",FarmFeature="Auto Quest Sea 2",
			NPCs={Detective="Military Detective",Captain="Experienced Captain"},
			Locations={Detective="Prison",Door="Frozen Village",Captain="Middle Town"},
			Remotes={Progress="DressrosaQuestProgress",Detective="Detective",Completion="Dressrosa",Travel="TravelDressrosa"},
			Requirements={"Level 700+","Talk to Military Detective and obtain Key","Use Key at Frozen Village","Defeat Ice Admiral","Return to Military Detective","Travel with Experienced Captain"},
		},
    	},
    
    	ItemCatalog = {
    		["Buy Buso"]={Name="Aura",Type="Ability",Seas={1},Price="25,000",Currency="Beli",Requirement="None",NPC="Ability Teacher",Source="Ability Teacher · Frozen Village / Magma Village",Note="Permanent Aura unlock."},
    		["Buy Geppo"]={Name="Air Jump",Type="Ability",Seas={1},Price="10,000",Currency="Beli",Requirement="None",NPC="Ability Teacher",Source="Ability Teacher · Frozen Village / Magma Village",Note="Permanent Air Jump unlock."},
    		["Buy Soru"]={Name="Flash Step",Type="Ability",Seas={1},Price="100,000",Currency="Beli",Requirement="None",NPC="Ability Teacher",Source="Ability Teacher · Frozen Village / Magma Village",Note="Permanent Flash Step unlock."},
    		["Buy Ken"]={Name="Instinct",Type="Ability",Seas={1},Price="750,000",Currency="Beli",MinLevel=300,RequiredOwnership={"Saber"},Requirement="Level 300 + Saber Puzzle",NPC="Instinct Teacher",Source="Instinct Teacher · Upper Skylands",Note="Requires Saber Puzzle completion."},
    		["Buy Tomoe Ring"]={Name="Tomoe Ring",Type="Accessory",Seas={1},Price="500,000",Currency="Beli",MinStats={Melee=200},Requirement="200+ Melee stat points",NPC="Yoshi",Source="Skylands",Note="Buy from Yoshi on the Skylands castle roof."},
    		["Buy Black Cape"]={Name="Black Cape",Type="Accessory",Seas={1},Price="50,000",Currency="Beli",MinLevel=50,Requirement="Level 50+",NPC="Parlus",Source="Marine Fortress",Note="Buy from Parlus inside the Marine Fortress tower."},
    		["Buy Swordsman Hat"]={Name="Swordsman Hat",Type="Accessory",Seas={1},Price="150,000",Currency="Beli",MinStats={Sword=300},RequiredAbilities={"Buso","Geppo","Soru"},Requirement="300 Sword stats + Flash Step + Air Jump + Aura",NPC="Hasan",Source="Desert",Note="All ability/stat requirements must be met before Hasan sells it."},
    		["Buy Bizarre Revolver"]={Name="Bizarre Revolver",Type="Gun",Seas={2},Price="25",Currency="Ectoplasm",Requirement="Cursed Ship access",NPC="El Rodolfo",Source="Cursed Ship",Note="Current item name; callback keeps the Ectoplasm shop slot."},
    		["Buy Ghoul Mask"]={Name="Ghoul Mask",Type="Accessory",Seas={2},Price="50",Currency="Ectoplasm",Requirement="Cursed Ship access",NPC="El Perro",Source="Cursed Ship",Note="Ectoplasm shop."},
    		["Buy Cutlass"]={Name="Cutlass",Type="Sword",Seas={1},Price="1,000",Currency="Beli",Requirement="None",NPC="Sword Dealer",Source="First Sea sword dealer",Note="Starter sword."},
    		["Buy Katana"]={Name="Katana",Type="Sword",Seas={1},Price="1,000",Currency="Beli",Requirement="None",NPC="Sword Dealer",Source="First Sea sword dealer",Note="Starter sword."},
    		["Buy Iron Mace"]={Name="Iron Mace",Type="Sword",Seas={1},Price="25,000",Currency="Beli",Requirement="None",NPC="Sword Dealer of the West",Source="Pirate Village",Note="First Sea sword."},
    		["Buy Duel Katana"]={Name="Dual Katana",Type="Sword",Seas={1},Price="12,000",Currency="Beli",Requirement="None",NPC="Sword Dealer of the West",Source="Pirate Village",Note="Remote keeps legacy 'Duel Katana' spelling."},
    		["Buy Triple Katana"]={Name="Triple Katana",Type="Sword",Seas={1},Price="60,000",Currency="Beli",Requirement="None",NPC="Sword Dealer of the East",Source="Frozen Village",Note="First Sea sword."},
    		["Buy Pipe"]={Name="Pipe",Type="Sword",Seas={1},Price="100,000",Currency="Beli",Requirement="None",NPC="Sword Dealer of the East",Source="First Sea",Note="First Sea sword."},
    		["Buy Dual-Headed Blade"]={Name="Dual-Headed Blade",Type="Sword",Seas={1},Price="400,000",Currency="Beli",Requirement="None",NPC="Master Sword Dealer",Source="Skylands",Note="First Sea sword."},
    		["Buy Bisento"]={Name="Bisento",Type="Sword",Seas={1},Price="1,000,000",Currency="Beli",MinLevel=250,Requirement="Level 250+",NPC="Master Sword Dealer",Source="Skylands",Note="Requires Level 250 or higher."},
    		["Buy Soul Cane"]={Name="Soul Cane",Type="Sword",Seas={1},Price="750,000",Currency="Beli",Requirement="None",NPC="Living Skeleton",Source="Magma Village",Note="First Sea sword."},
    		["Buy SlingShot"]={Name="Slingshot",Type="Gun",Seas={1},Price="5,000",Currency="Beli",Requirement="None",NPC="Weapon Dealer",Source="First Sea weapon dealer",Note="First Sea gun."},
    		["Buy Musket"]={Name="Musket",Type="Gun",Seas={1},Price="8,000",Currency="Beli",Requirement="None",NPC="Weapon Dealer",Source="Middle Town",Note="First Sea gun."},
    		["Buy Refined Slingshot"]={Name="Refined Slingshot",Type="Gun",Seas={1},Price="30,000",Currency="Beli",Requirement="None",NPC="Advanced Weapon Dealer",Source="Marine Fortress",Note="First Sea gun."},
    		["Buy Dual Flintlock"]={Name="Dual Flintlock",Type="Gun",Seas={1},Price="65,000",Currency="Beli",Requirement="None",NPC="Advanced Weapon Dealer",Source="Marine Fortress",Note="First Sea gun."},
    		["Buy Flintlock"]={Name="Flintlock",Type="Gun",Seas={1},Price="10,500",Currency="Beli",Requirement="None",NPC="Weapon Dealer",Source="First Sea weapon dealer",Note="First Sea gun."},
    		["Buy Cannon"]={Name="Cannon",Type="Gun",Seas={1},Price="100,000",Currency="Beli",Requirement="None",NPC="Advanced Weapon Dealer",Source="Marine Fortress",Note="First Sea gun."},
    		["Auto Get Shark Saw"]={Name="Shark Saw",Type="Sword",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat The Saw",NPC="The Saw",Source="Middle Town",Note="Drop chance is not hard-coded because current sources do not establish a reliable percentage."},
    		["Auto Get Saber"]={Name="Saber",Type="Sword",Seas={1},Price="Quest",Currency="Progression",Requirement="Level 200+ + Saber Puzzle",NPC="Saber Expert",Source="Jungle / Desert / Frozen Village / Pirate Village",Note="Five-button puzzle, Torch/Cup, Sick Man, Rich Man, Mob Leader, Ancient Relic, then Saber Expert."},
    		["Auto Get Wardens Sword"]={Name="Wardens Sword",Type="Sword",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Chief Warden",NPC="Chief Warden",Source="Prison",Note="Canonical current item name; legacy Warden's Sword remains an ownership alias."},
    		["Auto Get Coat"]={Name="Coat",Type="Accessory",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Vice Admiral",NPC="Vice Admiral",Source="Marine Fortress",Note="5% boss drop."},
    		["Auto Get Pink Coat"]={Name="Pink Coat",Type="Accessory",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Swan",NPC="Swan",Source="Prison",Note="Legacy Swan Coat remains an ownership alias only."},
    		["Auto Get Magma Blaster"]={Name="Magma Blaster",Type="Gun",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Magma Admiral",NPC="Magma Admiral",Source="Magma Village",Note="Current name; Refined Musket is retained only as a legacy alias."},
    		["Auto Get Trident"]={Name="Trident",Type="Sword",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Fishman Lord (2 phases)",NPC="Fishman Lord",Source="Underwater City",Note="Boss phase transition is handled by the shared boss tracker."},
    		["Auto Get Bazooka"]={Name="Bazooka",Type="Gun",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Wysper",NPC="Wysper",Source="Upper Skylands",Note="Boss drop."},
    		["Auto Get Cool Shades"]={Name="Cool Shades",Type="Accessory",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Cyborg",NPC="Cyborg",Source="Fountain City",Note="Boss drop."},
    		["Auto Get Usoap's Hat"]={Name="Usoap's Hat",Type="Accessory",Seas={1,2,3},Price="Condition",Currency="PvP",RequiredFaction="Pirates",Requirement="Pirates + 250,000 Bounty + 3 eligible near-level PvP defeats",NPC="None",Source="PvP achievement",Note="Bounty alone is not ownership evidence."},
    		["Auto Get Marine Cap"]={Name="Marine Cap",Type="Accessory",Seas={1,2,3},Price="Condition",Currency="PvP",RequiredFaction="Marines",Requirement="Marines + 250,000 Honor + eligible Pirate defeat",NPC="None",Source="PvP achievement",Note="Honor alone is not ownership evidence."},
    		["Buy Kabucha"]={Name="Kabucha",Type="Gun",Seas={2},Price="1,500",Currency="Fragments",Requirement="None",NPC="The Strongest God",Source="Usoapp's Island",Note="Moved out of the Sea 1 weapon section."},
    		["Buy Ghoul Race"]={Name="Ghoul",Type="Race",Seas={2},Price="100 Ectoplasm + 1 Hellfire Torch",Currency="Materials",Requirement="Level 1000+",NPC="Experimic",Source="Cursed Ship kitchen",Note="Hellfire Torch drops from Cursed Captain; Ectoplasm is consumed."},
    		["Buy Cyborg Race"]={Name="Cyborg",Type="Race",Seas={2},Price="2,500",Currency="Fragments",Requirement="Complete Cyborg Puzzle: Fist of Darkness + Core Brain",NPC="Secret Cyborg NPC",Source="Hot and Cold · Secret Laboratory",Note="Puzzle progress persists after required items are inserted."},
    		["Refund Stats"]={Name="Stat Refund",Type="Service",Seas={2},Price="2,500",Currency="Fragments",Requirement="None",NPC="Plokster",Source="Second Sea",Note="Refunds stat points."},
    		["Reroll Race"]={Name="Race Reroll",Type="Service",Seas={2},Price="3,000",Currency="Fragments",Requirement="None",NPC="Tort",Source="Second Sea",Note="Randomly rerolls standard race."},
    		["Craft DragonHeart"]={Name="Dragonheart",Type="Sword",Seas={3},Price="1 Dragon Egg + 6 Dinosaur Bones + 15 Blaze Embers",Currency="Materials",Requirement="Dojo Belt (Red) unlocks recipe; Dragon Egg route also needs Black Belt + Dragon Tether",NPC="Dragon Hunter",Source="Hydra Island · Dragon Dojo",Note="Craft from Dragon Hunter."},
    		["Craft DragonStorm"]={Name="Dragonstorm",Type="Gun",Seas={3},Price="2 Dragon Eggs + 10 Dinosaur Bones + 5 Dragon Scales + 30 Blaze Embers",Currency="Materials",Requirement="Dojo Belt (Red) + Dragon Hunter recipe",NPC="Dragon Hunter",Source="Hydra Island · Dragon Dojo",Note="Craft from Dragon Hunter."},
    		["Craft Dino Hood"]={Name="Dino Hood",Type="Accessory",Seas={3},Price="25 Dinosaur Bones + 10 Mini Tusk",Currency="Materials",Requirement="Complete Volcano Event materials",NPC="Fossil Expert",Source="Prehistoric Island",Note="Crafted accessory."},
    		["Craft Shark Tooth Necklace"]={Name="Shark Tooth Necklace",Type="Accessory",Seas={3},Price="1 Mutant Tooth + 5 Shark Teeth",Currency="Materials",Requirement="None beyond materials",NPC="Shark Hunter",Source="Tiki Outpost",Note="Crafting this and Terror Jaw unlocks Monster Magnet."},
    		["Craft Terror Jaw"]={Name="Terror Jaw",Type="Accessory",Seas={3},Price="1 Terror Eye + 2 Mutant Teeth + 10 Fool's Gold + 5 Shark Teeth",Currency="Materials",Requirement="None beyond materials",NPC="Shark Hunter",Source="Tiki Outpost",Note="Crafting this and Shark Tooth Necklace unlocks Monster Magnet."},
    		["Craft Leviathan Crown"]={Name="Leviathan Crown",Type="Accessory",Seas={3},Price="1 Dark Fragment + 10 Leviathan Scales + 5 Electric Wings",Currency="Materials",Requirement="None beyond materials",NPC="Beast Hunter",Source="Tiki Outpost",Note="Leviathan material accessory."},
    		["Craft Leviathan Shield"]={Name="Leviathan Shield",Type="Accessory",Seas={3},Price="1 Mirror Fractal + 30 Leviathan Scales + 10 Electric Wings + 20 Fool's Gold",Currency="Materials",Requirement="Mirror Fractal from Dough King",NPC="Beast Hunter",Source="Tiki Outpost",Note="Mythical defensive accessory."},
    		["Craft Beast Hunter Boat"]={Name="Beast Hunter",Type="Boat",Seas={3},Price="20 Leviathan Scales + 6 Electric Wings + 2 Mutant Teeth + 30 Fool's Gold + 6 Shark Teeth",Currency="Materials",Requirement="None beyond materials",NPC="Beast Hunter",Source="Tiki Outpost",Note="Required to collect Leviathan Heart."},
    		["Craft LegendaryScroll"]={Name="Legendary Scroll",Type="Scroll",Seas={3},Price="5 Leviathan Scales + 3 Electric Wings + 1 Mutant Tooth + 7 Fool's Gold",Currency="Materials",Requirement="Craft 10 Rare Scrolls to unlock recipe",NPC="Dragon Talon Sage",Source="Tiki Outpost / rotating Sage locations",Note="High-tier enchanting scroll."},
    		["Craft MythicalScroll"]={Name="Mythical Scroll",Type="Scroll",Seas={3},Price="1 Leviathan Heart + 15 Leviathan Scales + 1 Terror Eye + 20 Fool's Gold",Currency="Materials",Requirement="Craft 10 Legendary Scrolls to unlock recipe",NPC="Dragon Talon Sage",Source="Tiki Outpost / rotating Sage locations",Note="Highest standard enchanting scroll tier."},
    	},
    
    	Features = {
    		["Auto Farm Tyrant of the Skies"] = {
    			Id = "farm.tyrant", Category = "Farm", Seas = {3}, Icon = "boss", Order = 44,
    		},
    		["Auto Factory Raid"] = {
    			Id = "farm.factory_raid", Category = "Farm", Seas = {2}, Icon = "factory", Order = 45,
    		},
    		["Auto Farm Ectoplasm"] = {
    			Id = "farm.ectoplasm", Category = "Farm", Seas = {2}, Icon = "material", Order = 46,
    		},
    		["Auto Get Law Sword"] = {
    			Id = "progress.law_sword", Category = "Quest", Seas = {2}, Icon = "sword", Order = 45,
    		},
    		["Buy Microchip Law"] = {
    			Id = "raid.law.microchip", Category = "Raid", Seas = {2}, Icon = "raid", Order = 39,
    		},
    		["Start Law Raid"] = {
    			Id = "raid.law.start", Category = "Raid", Seas = {2}, Icon = "raid", Order = 40,
    		},
    		["Auto Buy Chip Law"] = {
    			Id = "raid.law.auto_buy", Category = "Raid", Seas = {2}, Icon = "raid", Order = 41,
    		},
    		["Auto Start Law"] = {
    			Id = "raid.law.auto_start", Category = "Raid", Seas = {2}, Icon = "raid", Order = 42,
    		},
    		["Auto Raid Law"] = {
    			Id = "raid.law.auto_raid", Category = "Raid", Seas = {2}, Icon = "raid", Order = 43,
    		},
    		["Auto Drive To Hydra Island"] = {
    			Id = "sea.sail.hydra", Category = "Sea", Seas = {3}, Icon = "sea", Order = 65,
    		},
    		["Auto Start Raid"] = {
    			Id = "raid.auto_start",
    			Category = "Raid",
    			Seas = {2, 3},
    			Icon = "raid",
    			Order = 10,
    		},
    		["Auto Raid [Safe]"] = {
    			Id = "raid.auto_clear",
    			Category = "Raid",
    			Seas = {2, 3},
    			Icon = "raid",
    			Order = 20,
    		},
    		["Auto Awakening"] = {
    			Id = "raid.auto_awaken",
    			Category = "Raid",
    			Seas = {2, 3},
    			Icon = "spark",
    			Order = 30,
    		},
    		["Auto Haki Rainbow"] = {
    			Id = "progress.rainbow_haki",
    			Category = "Quest",
    			Seas = {3},
    			Icon = "progress",
    		},
    		["Auto Complete Quest Bartilo"] = {
    			Id = "progress.bartilo",
    			Category = "Quest",
    			Seas = {2},
    			Icon = "progress",
    		},
    		["Auto Complete Quest Citizen"] = {
    			Id = "progress.citizen",
    			Category = "Quest",
    			Seas = {3},
    			Icon = "progress",
    		},
    		["Auto Kill Shark"] = {
    			Id = "sea.shark",
    			Category = "Sea",
    			Seas = {2, 3},
    			Icon = "sea",
    		},
    		["Auto Kill Piranha"] = {
    			Id = "sea.piranha",
    			Category = "Sea",
    			Seas = {2, 3},
    			Icon = "sea",
    		},
    		["Auto Kill Terror Shark"] = {
    			Id = "sea.terror_shark",
    			Category = "Sea",
    			Seas = {3},
    			Icon = "sea",
    		},
    		["Auto Attack Leviathan"] = {
    			Id = "sea.leviathan",
    			Category = "Sea",
    			Seas = {3},
    			Icon = "sea",
    		},
    		["Auto Teleport Frozen Dimension"] = {
    			Id = "sea.frozen_dimension",
    			Category = "Sea",
    			Seas = {3},
    			Icon = "teleport",
    		},
    	},
    
    	Sections = {
    		Race = {
    			["upgrade races v3"] = {Id = "race.v3", Seas = {2}, Order = 20},
    			["trials quest v4"] = {Id = "race.v4", Seas = {3}, Order = 30},
    		},
    		Main = {
    			["farm elite hunter"] = {Id = "farm.elite", Seas = {3}},
    			["farming cake"] = {Id = "farm.cake", Seas = {3}},
    			["farming bone"] = {Id = "farm.bone", Seas = {3}},
    
    			["farming mastery"] = {Id = "combat.mastery", Tab = "Combat", Order = 30},
    		},
    		Shop = {
    			["fighting style · equip"] = {Id = "items.fighting_style"},
    			["accessory sea 1"] = {Id = "items.accessory_sea1"},
    			["ectoplasm shop"] = {Id = "items.ectoplasm_shop"},
    			["accessory seaevent"] = {Id = "items.accessory_sea_event"},
    			["fragments shop"] = {Id = "items.fragments_shop"},
    			["ownership status"] = {Id = "items.ownership"},
    		},
    	},
    }
    env.RE4_FEATURE_METADATA = RE4Constants.FeatureMetadata

    RE4Constants.ItemAliases = {
    	["Godhuman"] = {"Godhuman", "GodHuman"},
    	["Sanguine Art"] = {"Sanguine Art", "SanguineArt"},
    	["Black Leg"] = {"Black Leg", "Dark Step", "BlackLeg"},
    	["Electro"] = {"Electro", "Electric"},
    	["Fishman Karate"] = {"Fishman Karate", "FishmanKarate", "Water Kung Fu", "WaterKungFu"},
    	["Dragon Breath"] = {"Dragon Breath", "DragonBreath", "Dragon Claw", "DragonClaw"},
    	["Death Step"] = {"Death Step", "DeathStep"},
    	["Sharkman Karate"] = {"Sharkman Karate", "SharkmanKarate"},
    	["Electric Claw"] = {"Electric Claw", "ElectricClaw"},
    	["Dragon Talon"] = {"Dragon Talon", "DragonTalon"},
    	["Superhuman"] = {"Superhuman"},
    	["Cursed Dual Katana"] = {"Cursed Dual Katana", "CursedDualKatana"},
    	["True Triple Katana"] = {"True Triple Katana", "TrueTripleKatana"},
    	["Pole V1"] = {"Pole (1st Form)", "Pole V1", "Pole"},
    	["Pole V2"] = {"Pole (2nd Form)", "Pole V2"},
    	["Bisento"] = {"Bisento", "Bisento V1", "Bisento (1st Form)"},
    	["Bisento V2"] = {"Bisento V2", "Bisento (2nd Form)"},
    	["Law Sword"] = {"Koko", "Law Sword"},
    	["Shark Saw"] = {"Shark Saw", "Saw", "Saw Sword"},
    	["Saw Sword"] = {"Shark Saw", "Saw", "Saw Sword"},
    	["Wardens Sword"] = {"Wardens Sword", "Warden's Sword", "Warden Sword"},
    	["Warden's Sword"] = {"Wardens Sword", "Warden's Sword", "Warden Sword"},
    	["Coat"] = {"Coat", "Marine Coat", "Vice Admiral's Coat"},
    	["Marine Coat"] = {"Coat", "Marine Coat", "Vice Admiral's Coat"},
    	["Pink Coat"] = {"Pink Coat", "Swan Coat"},
    	["Swan Coat"] = {"Pink Coat", "Swan Coat"},
    	["Magma Blaster"] = {"Magma Blaster", "Refined Musket"},
    	["Trident"] = {"Trident"},
    	["Bazooka"] = {"Bazooka"},
    	["Cool Shades"] = {"Cool Shades"},
    	["Usoap's Hat"] = {"Usoap's Hat", "Usopp's Hat", "Usoap"},
    	["Usoap"] = {"Usoap's Hat", "Usopp's Hat", "Usoap"},
    	["Marine Cap"] = {"Marine Cap"},
    	["Refined Slingshot"] = {"Refined Slingshot"},
    	["Black Spikey"] = {"Spikey Trident", "Black Spikey"},
    	["Long Sword"] = {"Longsword", "Long Sword"},
    	["Soul Guitar"] = {"Soul Guitar", "Skull Guitar"},
    	["Skull Guitar"] = {"Skull Guitar", "Soul Guitar"},
    	["Pole (1st Form)"] = {"Pole (1st Form)", "Pole V1", "Pole"},
    	["Pole (2nd Form)"] = {"Pole (2nd Form)", "Pole V2"},
    	["Acidum Rifle"] = {"Acidum Rifle", "Acidum Rifle Gun"},
    	["Valkyrie Helm"] = {"Valkyrie Helm", "Valkyrie Helmet"},
    	["DragonHeart"] = {"DragonHeart", "Dragonheart", "Dragon Heart"},
    	["DragonStorm"] = {"DragonStorm", "Dragonstorm", "Dragon Storm"},
    	["Dino Hood"] = {"Dino Hood", "DinoHood"},
    	["Shark Tooth"] = {"Shark Tooth", "SharkTooth"},
    	["Terror Jaw"] = {"Terror Jaw", "TerrorJaw"},
    	["Shark Anchor"] = {"Shark Anchor", "SharkAnchor"},
    	["Leviathan Crown"] = {"Leviathan Crown", "LeviathanCrown"},
    	["Leviathan Shield"] = {"Leviathan Shield", "LeviathanShield"},
    	["Leviathan Boat"] = {"Leviathan Boat", "LeviathanBoat"},
    	["Legendary Scroll"] = {"Legendary Scroll", "LegendaryScroll"},
    	["Mythical Scroll"] = {"Mythical Scroll", "MythicalScroll"},
    	["Volcanic Magnet"] = {"Volcanic Magnet", "VolcanicMagnet"},
    	["Buso"] = {"Buso", "Aura"},
    	["Geppo"] = {"Geppo", "Air Jump", "AirJump", "Skyjump", "Sky Jump"},
    	["Soru"] = {"Soru", "Flash Step", "FlashStep"},
    	["Ken"] = {"Ken", "Instinct", "Observation", "Observation Haki"},
    	["Bizarre Revolver"] = {"Bizarre Revolver", "Bizarre Rifle"},
    	["Shark Tooth Necklace"] = {"Shark Tooth Necklace", "SharkToothNecklace"},
    	["Beast Hunter"] = {"Beast Hunter", "Leviathan Boat", "LeviathanBoat"},
    }

    RE4Constants.OneTimeRules = {
    	["Auto Get Tushita"] = "Tushita",
    	["Auto Get Yama"] = "Yama",
    	["Auto Get CDK"] = "Cursed Dual Katana",
    	["Auto Craft True Triple Katana"] = "True Triple Katana",
    	["Auto Get Pole V1"] = "Pole V1",
    	["Auto Pole V2"] = "Pole V2",
    	["Auto Bisento V2"] = "Bisento V2",
    	["Auto Get Law Sword"] = "Law Sword",
    	["Auto Get Shark Saw"] = "Shark Saw",
    	["Auto Get Saber"] = "Saber",
    	["Auto Get Usoap's Hat"] = "Usoap's Hat",
    	["Auto Get Marine Cap"] = "Marine Cap",
    	["Auto Get Wardens Sword"] = "Wardens Sword",
    	["Auto Get Coat"] = "Coat",
    	["Auto Get Pink Coat"] = "Pink Coat",
    	["Auto Get Magma Blaster"] = "Magma Blaster",
    	["Auto Get Trident"] = "Trident",
    	["Auto Get Bazooka"] = "Bazooka",
    	["Auto Get Cool Shades"] = "Cool Shades",
    	["Auto Get Rengoku Sword"] = "Rengoku",
    	["Auto Get Dragon Trident"] = "Dragon Trident",
    	["Auto Get Long Sword"] = "Long Sword",
    	["Auto Get Black Spikey"] = "Black Spikey",
    	["Auto Get Midnight Blade"] = "Midnight Blade",
    	["Auto Get Swan Glasses"] = "Swan Glasses",
    	["Auto Get Buddy Sword"] = "Buddy Sword",
    	["Auto Get Florentino Sword"] = "Canvander",
    	["Auto Get Twin Hooks"] = "Twin Hooks",
    	["Auto Get Serpent Bow"] = "Serpent Bow",
    	["Auto Get Lei Accessory"] = "Lei",
    	["Auto Get Skull Guitar"] = "Skull Guitar",
    	["Auto Get Dark Step"] = "Black Leg",
    	["Auto Get Electric"] = "Electro",
    	["Auto Get Water Kung Fu"] = "Fishman Karate",
    	["Auto Get Dragon Breath"] = "Dragon Breath",
    	["Auto Get Superhuman"] = "Superhuman",
    	["Auto Get DeathStep"] = "Death Step",
    	["Auto Get Sharkman Karate"] = "Sharkman Karate",
    	["Auto Get ElectricClaw"] = "Electric Claw",
    	["Auto Get DragonTalon"] = "Dragon Talon",
    	["Auto Get GodHuman"] = "Godhuman",
    	["Auto Get SanguineArt"] = "Sanguine Art",
    
    	["Use Dark Step"] = "Black Leg",
    	["Use Electric"] = "Electro",
    	["Use Water Kung Fu"] = "Fishman Karate",
    	["Use Dragon Breath"] = "Dragon Breath",
    	["Use Superhuman"] = "Superhuman",
    	["Use Death Step"] = "Death Step",
    	["Use Sharkman Karate"] = "Sharkman Karate",
    	["Use Electric Claw"] = "Electric Claw",
    	["Use Dragon Talon"] = "Dragon Talon",
    	["Use Godhuman"] = "Godhuman",
    	["Use Sanguine Art"] = "Sanguine Art",
    
    	["Buy Black Leg"] = "Black Leg",
    	["Buy Electro"] = "Electro",
    	["Buy Fishman Karate"] = "Fishman Karate",
    	["Buy DragonBreath"] = "Dragon Breath",
    	["Buy Superhuman"] = "Superhuman",
    	["Buy Death Step"] = "Death Step",
    	["Buy Sharkman Karate"] = "Sharkman Karate",
    	["Buy ElectricClaw"] = "Electric Claw",
    	["Buy DragonTalon"] = "Dragon Talon",
    	["Buy GodHuman"] = "Godhuman",
    	["Buy SanguineArt"] = "Sanguine Art",
    	["Buy Buso"] = "Buso",
    	["Buy Geppo"] = "Geppo",
    	["Buy Soru"] = "Soru",
    	["Buy Ken"] = "Ken",
    	["Buy Tomoe Ring"] = "Tomoe Ring",
    	["Buy Black Cape"] = "Black Cape",
    	["Buy Swordsman Hat"] = "Swordsman Hat",
    	["Buy Bizarre Revolver"] = "Bizarre Revolver",
    	["Buy Ghoul Mask"] = "Ghoul Mask",
    	["Buy Cutlass"] = "Cutlass",
    	["Buy Katana"] = "Katana",
    	["Buy Iron Mace"] = "Iron Mace",
    	["Buy Duel Katana"] = "Dual Katana",
    	["Buy Triple Katana"] = "Triple Katana",
    	["Buy Pipe"] = "Pipe",
    	["Buy Dual-Headed Blade"] = "Dual-Headed Blade",
    	["Buy Bisento"] = "Bisento",
    	["Buy Soul Cane"] = "Soul Cane",
    	["Buy SlingShot"] = "Slingshot",
    	["Buy Musket"] = "Musket",
    	["Buy Refined Slingshot"] = "Refined Slingshot",
    	["Buy Dual Flintlock"] = "Dual Flintlock",
    	["Buy Flintlock"] = "Flintlock",
    	["Buy Cannon"] = "Cannon",
    	["Buy Kabucha"] = "Kabucha",
    	["Craft DragonHeart"] = "DragonHeart",
    	["Craft DragonStorm"] = "DragonStorm",
    	["Craft Dino Hood"] = "Dino Hood",
    	["Craft Shark Tooth Necklace"] = "Shark Tooth Necklace",
    	["Craft Terror Jaw"] = "Terror Jaw",
    	["Craft Leviathan Crown"] = "Leviathan Crown",
    	["Craft Leviathan Shield"] = "Leviathan Shield",
    	["Craft Beast Hunter Boat"] = "Beast Hunter",
    	["Craft LegendaryScroll"] = "Legendary Scroll",
    	["Craft MythicalScroll"] = "Mythical Scroll",
    	["Craft Volcanic Magnet"] = "Volcanic Magnet",
    }

    RE4Constants.EquipmentOwnershipKeys = {
    	["Bizarre Revolver"]=true,
    	["Black Cape"]=true,
    	["Black Spikey"]=true,
    	["Buddy Sword"]=true,
    	["Cannon"]=true,
    	["Canvander"]=true,
    	["Cursed Dual Katana"]=true,
    	["Cutlass"]=true,
    	["Dino Hood"]=true,
    	["Dragon Trident"]=true,
    	["DragonHeart"]=true,
    	["DragonStorm"]=true,
    	["Dual Flintlock"]=true,
    	["Dual Katana"]=true,
    	["Dual-Headed Blade"]=true,
    	["Flintlock"]=true,
    	["Ghoul Mask"]=true,
    	["Iron Mace"]=true,
    	["Kabucha"]=true,
    	["Katana"]=true,
    	["Law Sword"]=true,
    	["Lei"]=true,
    	["Leviathan Crown"]=true,
    	["Leviathan Shield"]=true,
    	["Long Sword"]=true,
    	["Coat"]=true,
    	["Marine Coat"]=true,
    	["Midnight Blade"]=true,
    	["Musket"]=true,
    	["Pipe"]=true,
    	["Pole V1"]=true,
    	["Pole V2"]=true,
    	["Rengoku"]=true,
    	["Saber"]=true,
    	["Shark Saw"]=true,
    	["Saw Sword"]=true,
    	["Magma Blaster"]=true,
    	["Trident"]=true,
    	["Bazooka"]=true,
    	["Cool Shades"]=true,
    	["Marine Cap"]=true,
    	["Refined Slingshot"]=true,
    	["Serpent Bow"]=true,
    	["Shark Tooth Necklace"]=true,
    	["Skull Guitar"]=true,
    	["Slingshot"]=true,
    	["Soul Cane"]=true,
    	["Pink Coat"]=true,
    	["Swan Coat"]=true,
    	["Swan Glasses"]=true,
    	["Swordsman Hat"]=true,
    	["Terror Jaw"]=true,
    	["Tomoe Ring"]=true,
    	["Triple Katana"]=true,
    	["True Triple Katana"]=true,
    	["Tushita"]=true,
    	["Twin Hooks"]=true,
    	["Usoap's Hat"]=true,
    	["Usoap"]=true,
    	["Wardens Sword"]=true,
    	["Warden's Sword"]=true,
    	["Yama"]=true,
    	["Bisento"]=true,
    	["Bisento V2"]=true,
    }

    -- Fighting Style registry is the single source of truth for Progress and Items.
    -- Sea availability, optional explicitly-safe ownership probes, dealer identity/location
    -- and Buy/Equip action arguments all live in this registry; UI consumers do not own copies.
    local RE4FeatureMetadata = RE4Constants.FeatureMetadata or {}
    -- FightingStyleCatalog is a top-level FeatureMetadata table (not GameData).
    -- Keep one canonical source: both Progress and Items consume registry entries
    -- derived from this catalog, and ownership/dealer state is resolved later.
    local RE4BasicStyleCatalog = RE4FeatureMetadata.FightingStyleCatalog or {}
    local function RE4DealerLocations(list)
      local out={}
      for sea,location in ipairs(list or {}) do out[sea]=location end
      return out
    end
    local function RE4BuildBasicStyleMeta(key)
      local source=RE4BasicStyleCatalog[key]
      if type(source)~="table" then
        error("[RE4 HUB/Constants] FightingStyleCatalog missing entry: "..tostring(key),0)
      end
      local style=tostring(source.Internal or "")
      local display=tostring(source.Name or "")
      local remote=tostring(source.Remote or "")
      local seas=source.Seas
      if style=="" or display=="" or remote=="" or type(seas)~="table" or #seas==0 then
        error("[RE4 HUB/Constants] invalid FightingStyleCatalog entry: "..tostring(key),0)
      end
      return {
        CatalogKey=key,Style=style,Display=display,Seas=seas,
        CostBeli=source.Currency=="Beli" and source.Price or nil,CostFragments=source.Currency=="Fragments" and source.Price or nil,
        Remote=remote,ActionArgs={},OwnershipProbe={Remote=remote,Args={true},PositiveOnly=true},EquipDirect=true,DealerFallback=true,AcquireMode="dealer",
        NPC=source.NPC and {source.NPC} or {},DealerLocations=RE4DealerLocations(source.Locations),Requirements={},
        DisplayRequirements={{Key="fighting_style.req.none",Fallback="None"}},
      }
    end

    RE4Constants.FightingStyleRegistry = {
      DarkStep=RE4BuildBasicStyleMeta("DarkStep"),
      Electric=RE4BuildBasicStyleMeta("Electric"),
      WaterKungFu=RE4BuildBasicStyleMeta("WaterKungFu"),
      DragonBreath={
        CatalogKey="DragonBreath",Style="Dragon Breath",Display="Dragon Breath",Seas={2,3},CostFragments=1500,
        Remote="BlackbeardReward",OwnershipProbe={Args={"DragonClaw","1"},PositiveOnly=true},ActionArgs={"DragonClaw","2"},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
        NPC={"Sabi"},DealerLocations={[2]="Kingdom of Rose · Café",[3]="Castle on the Sea"},
        Requirements={{Kind="Access",Label="Access Second Sea"}},
        DisplayRequirements={{Key="fighting_style.req.access_second_sea",Fallback="Access Second Sea"}},
      },
      Superhuman={
        CatalogKey="Superhuman",Style="Superhuman",Display="Superhuman",Seas={2,3},CostBeli=3000000,
        Remote="BuySuperhuman",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
        NPC={"Martial Arts Master"},DealerLocations={[2]="Snow Mountain",[3]="Castle on the Sea"},
        Requirements={{Kind="Mastery",Style="DarkStep",Target=300},{Kind="Mastery",Style="Electric",Target=300},{Kind="Mastery",Style="WaterKungFu",Target=300},{Kind="Mastery",Style="DragonBreath",Target=300}},
        DisplayRequirements={
          {Key="fighting_style.req.dark_step_300",Fallback="Dark Step Mastery >= 300"},
          {Key="fighting_style.req.electric_300",Fallback="Electric Mastery >= 300"},
          {Key="fighting_style.req.water_kung_fu_300",Fallback="Water Kung Fu Mastery >= 300"},
          {Key="fighting_style.req.dragon_breath_300",Fallback="Dragon Breath Mastery >= 300"},
        },
      },
      DeathStep={
        CatalogKey="DeathStep",Style="Death Step",Display="Death Step",Seas={2,3},CostBeli=2500000,CostFragments=5000,
        Remote="BuyDeathStep",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
        NPC={"Phoeyu, the Reformed","Phoeyu"},DealerLocations={[2]="Ice Castle",[3]="Castle on the Sea"},
        Requirements={{Kind="Mastery",Style="DarkStep",Target=400},{Kind="Item",Name="Library Key",Label="Library Key · Awakened Ice Admiral"},{Kind="Library",Label="Ice Castle Library Door"}},
        DisplayRequirements={
          {Key="fighting_style.req.dark_step_400",Fallback="Dark Step Mastery >= 400"},
          {Key="fighting_style.req.library_key",Fallback="Library Key"},
          {LabelKey="fighting_style.library_key",Label="Library Key",Key="fighting_style.req.library_key_drop",Fallback="Drop from Awakened Ice Admiral"},
          {Key="fighting_style.req.library_open",Fallback="Open the Library door at Ice Castle"},
        },
      },
      ElectricClaw={
        CatalogKey="ElectricClaw",Style="Electric Claw",Display="Electric Claw",Seas={3},CostBeli=3000000,CostFragments=5000,
        Remote="BuyElectricClaw",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
        NPC={"Previous Hero"},DealerLocations={[3]="Floating Turtle"},
        Requirements={{Kind="Mastery",Style="Electric",Target=400},{Kind="Quest",Label="Previous Hero → Mansion in ≤ 30s"}},
        DisplayRequirements={
          {Key="fighting_style.req.electric_400",Fallback="Electric Mastery >= 400"},
          {Key="fighting_style.req.previous_hero",Fallback="Complete Previous Hero quest"},
          {LabelKey="fighting_style.quest",Label="Quest",Key="fighting_style.req.previous_hero_route",Fallback="Travel from Previous Hero to Mansion in <= 30 seconds"},
        },
      },
      Sharkman={
        CatalogKey="Sharkman",Style="Sharkman Karate",Display="Sharkman Karate",Seas={2,3},CostBeli=2500000,CostFragments=5000,
        Remote="BuySharkmanKarate",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
        NPC={"Sharkman Teacher","Daigrock, the Sharkman","Daigrock"},DealerLocations={[2]="Forgotten Island",[3]="Castle on the Sea"},
        Requirements={{Kind="Mastery",Style="WaterKungFu",Target=400},{Kind="Item",Name="Water Key",Label="Water Key · Tide Keeper"},{Kind="Dealer",Label="Give Water Key to Sharkman Teacher"}},
        DisplayRequirements={
          {Key="fighting_style.req.water_kung_fu_400",Fallback="Water Kung Fu Mastery >= 400"},
          {Key="fighting_style.req.water_key",Fallback="Water Key"},
          {LabelKey="fighting_style.water_key",Label="Water Key",Key="fighting_style.req.water_key_drop",Fallback="Drop from Tide Keeper"},
          {Key="fighting_style.req.water_key_give",Fallback="Give Water Key to Sharkman Teacher"},
        },
      },
      DragonTalon={
        CatalogKey="DragonTalon",Style="Dragon Talon",Display="Dragon Talon",Seas={3},CostBeli=3000000,CostFragments=5000,
        Remote="BuyDragonTalon",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
        NPC={"Uzoth"},DealerLocations={[3]="Hydra Island"},
        Requirements={{Kind="Mastery",Style="DragonBreath",Target=400},{Kind="Item",Name="Fire Essence",Label="Fire Essence · Death King/Bones"},{Kind="Dealer",Label="Give Fire Essence to Uzoth"}},
        DisplayRequirements={
          {Key="fighting_style.req.dragon_breath_400",Fallback="Dragon Breath Mastery >= 400"},
          {Key="fighting_style.req.fire_essence",Fallback="Fire Essence"},
          {LabelKey="fighting_style.fire_essence",Label="Fire Essence",Key="fighting_style.req.fire_essence_source",Fallback="Random reward from Death King using Bones"},
          {Key="fighting_style.req.fire_essence_give",Fallback="Give Fire Essence to Uzoth"},
        },
      },
      Godhuman={
        CatalogKey="Godhuman",Style="Godhuman",Display="Godhuman",Seas={3},CostBeli=5000000,CostFragments=5000,
        Remote="BuyGodhuman",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
        NPC={"Ancient Monk"},DealerLocations={[3]="Floating Turtle"},
        Requirements={{Kind="Mastery",Style="Superhuman",Target=400},{Kind="Mastery",Style="DeathStep",Target=400},{Kind="Mastery",Style="ElectricClaw",Target=400},{Kind="Mastery",Style="Sharkman",Target=400},{Kind="Mastery",Style="DragonTalon",Target=400},{Kind="Material",Name="Dragon Scale",Target=10},{Kind="Material",Name="Fish Tail",Target=20},{Kind="Material",Name="Mystic Droplet",Target=10},{Kind="Material",Name="Magma Ore",Target=20}},
        DisplayRequirements={
          {Key="fighting_style.req.superhuman_400",Fallback="Superhuman Mastery >= 400"},
          {Key="fighting_style.req.death_step_400",Fallback="Death Step Mastery >= 400"},
          {Key="fighting_style.req.electric_claw_400",Fallback="Electric Claw Mastery >= 400"},
          {Key="fighting_style.req.sharkman_400",Fallback="Sharkman Karate Mastery >= 400"},
          {Key="fighting_style.req.dragon_talon_400",Fallback="Dragon Talon Mastery >= 400"},
          {Key="fighting_style.req.dragon_scales_10",Fallback="10 Dragon Scales"},
          {Key="fighting_style.req.fish_tails_20",Fallback="20 Fish Tails"},
          {Key="fighting_style.req.mystic_droplets_10",Fallback="10 Mystic Droplets"},
          {Key="fighting_style.req.magma_ore_20",Fallback="20 Magma Ore"},
        },
      },
      Sanguine={
        CatalogKey="Sanguine",Style="Sanguine Art",Display="Sanguine Art",Seas={3},CostBeli=5000000,CostFragments=5000,
        Remote="BuySanguineArt",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
        NPC={"Shafi"},DealerLocations={[3]="Tiki Outpost"},
        Requirements={{Kind="Item",Name="Leviathan Heart",Label="Leviathan Heart"},{Kind="Material",Name="Dark Fragment",Target=2},{Kind="Material",Name="Demonic Wisp",Target=20},{Kind="Material",Name="Vampire Fang",Target=20}},
        DisplayRequirements={
          {Key="fighting_style.req.leviathan_heart",Fallback="Leviathan Heart"},
          {Key="fighting_style.req.dark_fragments_2",Fallback="2 Dark Fragments"},
          {Key="fighting_style.req.demonic_wisps_20",Fallback="20 Demonic Wisps"},
          {Key="fighting_style.req.vampire_fangs_20",Fallback="20 Vampire Fangs"},
        },
      },
    }
    -- Compatibility alias for existing consumers; both names point to the same table.
    RE4Constants.StyleMeta = RE4Constants.FightingStyleRegistry

    RE4Constants.BossAliases = {
    	["The Saw"]={"The Saw","Saw"},
    	["Saber Expert"]={"Saber Expert"},
    	["Mob Leader"]={"Mob Leader"},
    	["Vice Admiral"]={"Vice Admiral"},
    	["Chief Warden"]={"Chief Warden","ChiefWarden"},
    	["Swan"]={"Swan"}, ["Magma Admiral"]={"Magma Admiral"},
    	["Fishman Lord"]={"Fishman Lord"}, ["Wysper"]={"Wysper"},
    	["Thunder God"]={"Thunder God","God Enel","God Enal"}, ["Cyborg"]={"Cyborg"},
    	["Ice Admiral"]={"Ice Admiral"}, ["Greybeard"]={"Greybeard"},
    	["Cake Prince"]={"Cake Prince"}, ["Dough King"]={"Dough King"},
    	["Tyrant of the Skies"]={"Tyrant of the Skies"},
    	["Diablo"]={"Diablo"}, ["Deandre"]={"Deandre"}, ["Urban"]={"Urban"},
    	["rip_indra"]={"rip_indra","rip indra","rip_indra True Form"},
    	["Don Swan"]={"Don Swan"}, ["Awakened Ice Admiral"]={"Awakened Ice Admiral"},
    	["Darkbeard"]={"Darkbeard"}, ["Cursed Captain"]={"Cursed Captain"}, ["Order"]={"Order"},
    	["Soul Reaper"]={"Soul Reaper"}, ["Longma"]={"Longma"}, ["Cake Queen"]={"Cake Queen"},
      }

    -- Curated from Cr4's Farm All Island data, but consumed by Re4's shared
    -- FeatureRuntime/Target/Movement/Combat pipeline (no per-island worker loops).
    RE4Constants.FarmIslands = {
      [1] = {
        {Name="Pirates",Position=CFrame.new(-2709.67944,24.5206585,2104.24585),Mobs={"Bandit"}},
        {Name="Marine",Position=CFrame.new(-2709.67944,24.5206585,2104.24585),Mobs={"Trainee"}},
        {Name="Jungle",Position=CFrame.new(-1600,36,150),Mobs={"Monkey","Gorilla"}},
        {Name="Pirate Village",Position=CFrame.new(-1100,4,3850),Mobs={"Pirate","Brute"}},
        {Name="Desert",Position=CFrame.new(1090,7,4370),Mobs={"Desert Bandit","Desert Officer"}},
        {Name="Frozen Village",Position=CFrame.new(1200,28,-1500),Mobs={"Snow Bandit","Snowman"}},
        {Name="Marine Fortress",Position=CFrame.new(-4500,20,4250),Mobs={"Chief Petty Officer"}},
        {Name="Skylands Lower",Position=CFrame.new(-5000,700,-2500),Mobs={"Sky Bandit","Dark Master"}},
        {Name="Prison",Position=CFrame.new(4875,6,735),Mobs={"Prisoner","Dangerous Prisoner"}},
        {Name="Colosseum",Position=CFrame.new(-1500,60,-290),Mobs={"Toga Warrior","Gladiator"}},
        {Name="Magma Village",Position=CFrame.new(-5200,8,8400),Mobs={"Military Soldier","Military Spy"}},
        {Name="Underwater City",Position=CFrame.new(61160,5,1819),Mobs={"Fishman Warrior","Fishman Commando"}},
        {Name="Skylands Upper",Position=CFrame.new(-7880,5545,-380),Mobs={"Shanda","Royal Squad","Royal Soldier"}},
      },
      [2] = {
        {Name="Kingdom of Rose",Position=CFrame.new(-321,73,297),Mobs={"Raider","Mercenary","Swan Pirate","Factory Staff"}},
        {Name="Green Zone",Position=CFrame.new(-2447,73,-3211),Mobs={"Marine Lieutenant","Marine Captain"}},
        {Name="Graveyard Island",Position=CFrame.new(-9515,142,5536),Mobs={"Zombie","Vampire"}},
        {Name="Snow Mountain",Position=CFrame.new(561,401,-5306),Mobs={"Snow Trooper","Winter Warrior"}},
        {Name="Hot and Cold (Cold)",Position=CFrame.new(-6026,15,-5062),Mobs={"Lab Subordinate","Horned Warrior"}},
        {Name="Hot and Cold (Hot)",Position=CFrame.new(-5478,15,-5240),Mobs={"Magma Ninja","Lava Pirate"}},
        {Name="Cursed Ship",Position=CFrame.new(902,126,33071),Mobs={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}},
        {Name="Ice Castle",Position=CFrame.new(6137,294,-6747),Mobs={"Arctic Warrior","Snow Lurker"}},
        {Name="Forgotten Island",Position=CFrame.new(-3043,238,-10191),Mobs={"Sea Soldier","Water Fighter"}},
      },
      [3] = {
        {Name="Port Town",Position=CFrame.new(-290,44,5450),Mobs={"Pirate Millionaire","Pistol Billionaire"}},
        {Name="Hydra Island",Position=CFrame.new(5228,604,345),Mobs={"Dragon Crew Warrior","Dragon Crew Archer","Female Islander","Giant Islander","Training Dummy"}},
        {Name="Great Tree",Position=CFrame.new(2682,1682,-7190),Mobs={"Marine Commodore","Marine Rear Admiral"}},
        {Name="Floating Turtle",Position=CFrame.new(-12000,331,-8500),Mobs={"Forest Pirate","Mythological Pirate","Jungle Pirate","Musketeer Pirate","Fishman Raider","Fishman Captain"}},
        {Name="Haunted Castle",Position=CFrame.new(-9515,142,5536),Mobs={"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}},
        {Name="Sea of Treats",Position=CFrame.new(-1145,13,-14450),Mobs={"Peanut Scout","Peanut President","Ice Cream Commander","Cookie Crafter","Cake Guard","Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel"}},
        {Name="Tiki Outpost",Position=CFrame.new(-16200,90,-17300),Mobs={"Isle Outlaw","Island Boy","Sun-kissed Warrior","Isle Champion"}},
        {Name="Submerged Island",Position=CFrame.new(-3200,-10,-10000),Mobs={"Reef Bandit","Coral Pirate","Sea Chanter","Ocean Prophet","High Disciple","Grand Devotee"}},
      },
    }

    RE4Constants.MasterySpots = {
    	Cake={
    	  Position=CFrame.new(-2130.80712890625,69.95634460449219,-12327.83984375),
    	  Mobs={"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"},
    	},
    	Bone={
    	  Position=CFrame.new(-9508.5673828125,142.1398468017578,5737.3603515625),
    	  Mobs={"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"},
    	},
      }

    RE4Constants.RaidChipReasonText = {
      raid_active="Chờ Raid hiện tại kết thúc",raid_lifecycle_active="Chờ Raid hoàn tất cleanup",raid_start_pending="Chip đã được dùng · chờ Raid bắt đầu",
      finalizing_native="Chờ server hoàn tất reward/return",level_required="Cần Level 1100+",insufficient_beli="Không đủ 100,000 Beli",
      beli_state_unavailable="Chưa đọc được số Beli",insufficient_fragments="Không đủ 1,000 Fragments",fragment_state_unavailable="Chưa đọc được số Fragments",
      beli_transport_ambiguous="Giao dịch Beli chưa xác nhận",fragment_transport_ambiguous="Giao dịch Fragment chưa xác nhận",purchase_pending_confirmation="Đã gửi giao dịch · chờ trạng thái chip",purchase_effect_observed_waiting_chip="Đã thấy thay đổi số dư · chờ trạng thái chip",
      raid_not_selected="Chưa chọn Raid",raid_kind_unknown="Không xác minh được loại Raid",mode_mismatch="Raid mode và raid selection không khớp",mode_changed="Raid mode đã thay đổi",
      policy_changed="Phương thức mua chip đã thay đổi trong giao dịch",cancelled="Đã hủy",
    }

    RE4Constants.RedeemCodes = {
    			"LIGHTNINGABUSE",
    			"KITT_RESET",
    			"SUB2GAMERROBOT_RESET1",
    			"Sub2UncleKizaru",
    			"Sub2CaptainMaui",
    			"kittgaming",
    			"Sub2Fer999",
    			"Enyu_is_Pro",
    			"Magicbus",
    			"JCWK",
    			"Starcodeheo",
    			"Bluxxy",
    			"Axiore",
    			"SUB2OFFICIALNOOBIE",
    			"AXIORE",
    			"BIGNEWS",
    			"fudd10_v2",
    			"Fudd10",
    			"Chandler",
    			"SUB2NOOBMASTER123",
    			"Sub2Daigrock",
    			"TantaiGaming",
    			"StrawHatMaine",
    			"THEGREATACE"
    		}

    local T = {}
      T.RegionOrder = {"UnderwaterCity","CursedShip","TempleOfTime","Submerged"}
      T.Regions = {
    	World = {Key="World"},
    	UnderwaterCity = {
    	  Key="UnderwaterCity", BypassAllowed=false, Sea=1,
    	  TargetDetector={Center=Vector3.new(61163.8515625,11.6796875,1819.7841796875),Radius3D=6500},
    	  CurrentDetector={Center=Vector3.new(61163.8515625,11.6796875,1819.7841796875),Radius3D=7500},
    	  Entrance={Mode="Portal",Destination=Vector3.new(61163.8515625,11.6796875,1819.7841796875)},
    
    	  Exit={Mode="Portal",Destination=Vector3.new(3864.8515625,6.6796875,-1926.7841796875)},
    	},
    	CursedShip = {
    	  Key="CursedShip", BypassAllowed=false, Sea=2,
    	  TargetDetector={Center=Vector3.new(923.21252441406,126.9760055542,32852.83203125),Radius3D=6500},
    	  CurrentDetector={Center=Vector3.new(923.21252441406,126.9760055542,32852.83203125),Radius3D=7500},
    	  Entrance={Mode="Portal",Destination=Vector3.new(923.21252441406,126.9760055542,32852.83203125)},
    
    	  Exit={Mode="FastTravel"},
    	},
    	TempleOfTime = {
    	  Key="TempleOfTime", BypassAllowed=false, Sea=3,
    	  TargetDetector={Center=Vector3.new(28611.2988,14896.1572,105.400009),Radius3D=6500},
    	  CurrentDetector={Center=Vector3.new(28611.2988,14896.1572,105.400009),Radius3D=7500},
    
    	  Entrance={
    		Mode="NPCCommand",
    		Name="Mysterious Force",
    		Approach=CFrame.new(3032.78003,2280.85107,-7325.47803,0.927176774,0,-0.374624074,0,1,0,0.374624074,0,0.927176774),
    		Args={"RaceV4Progress","Teleport"},
    		ArrivalRadius=8,
    		FastTravelApproach=true,
    	  },
    	  Exit={
    		Mode="NPCCommand",
    		Name="Mysterious Force3",
    		Approach=CFrame.new(28611.2988,14896.1572,105.400009,0,0,1,0,1,0,-1,0,0),
    		Args={"RaceV4Progress","TeleportBack"},
    		ArrivalRadius=8,
    	  },
    
    	  Anchor={
    		Kind="NPC",
    		Name="Mysterious Force3",
    		Fallback=CFrame.new(28611.2988,14896.1572,105.400009,0,0,1,0,1,0,-1,0,0),
    		ArrivalRadius=8,
    	  },
    	  Landmarks={
    		AncientOne={
    		  Kind="NPC",
    		  Name="Ancient One",
    		  Fallback=CFrame.new(28974.2227,14888.9844,-119.069,0,0,-1,0,1,0,1,0,0),
    		  ArrivalRadius=8,
    		},
    		AncientClock={
    		  Kind="Map",
    		  Root="Temple of Time",
    		  Aliases={"Ancient Clock","Clock"},
    
    		  Fallback=CFrame.new(29553.7812,15066.6133,-88.2750015),
    		  ArrivalRadius=12,
    		},
    	  },
    	},
    	Submerged = {
    	  Key="Submerged", BypassAllowed=false, Sea=3,
    	  TargetDetector={Center=Vector3.new(10780.639648,-2088.414062,9260.453125),RadiusXZ=3400,MaxY=-900},
    
    	  CurrentDetector={Center=Vector3.new(10780.639648,-2088.414062,9260.453125),RadiusXZ=3400,MaxY=800},
    	  Entrance={
    		Mode="NPCRemote",
    		Name="Submarine Worker",
    		Approach=CFrame.new(-16269.1016,29.5177539,1372.3204),
    		Remote="RF/SubmarineWorkerSpeak",
    		Command="TravelToSubmergedIsland",
    		Requires="Defeat Tyrant of the Skies",
    	  },
    	  Exit={Mode="Resurface",TargetY=650},
    	},
      }
      T.Islands = {
    	[1] = {
    	  {Name="Pirate Starter Island",Target=CFrame.new(979.79895019531,16.516613006592,1429.0466308594)},
    	  {Name="Marine Starter Island",Target=CFrame.new(-2566.4296875,6.8556680679321,2045.2561035156)},
    	  {Name="Middle Town",Target=CFrame.new(-690.33081054688,15.09425163269,1582.2380371094)},
    	  {Name="Jungle",Target=CFrame.new(-1612.7957763672,36.852081298828,149.12843322754)},
    	  {Name="Pirate Village",Target=CFrame.new(-1181.3093261719,4.7514905929565,3803.5456542969)},
    	  {Name="Desert",Target=CFrame.new(944.15789794922,20.919729232788,4373.3002929688)},
    	  {Name="Frozen Village",Target=CFrame.new(1347.8067626953,104.66806030273,-1319.7370605469)},
    	  {Name="Marine Fortress",Target=CFrame.new(-4914.8212890625,50.963626861572,4281.0278320313)},
    	  {Name="Colosseum",Target=CFrame.new(-1427.6203613281,7.2881078720093,-2792.7722167969)},
    	  {Name="Skylands · Lower",Target=CFrame.new(-4869.1025390625,733.46051025391,-2667.0180664063),BypassAllowed=false},
    	  {Name="Skylands · Middle",Target=CFrame.new(-4607.82275,872.54248,-1667.55688),TravelMode="Portal",PortalDestination=Vector3.new(-4607.82275,872.54248,-1667.55688),BypassAllowed=false},
    	  {Name="Skylands · Upper",Target=CFrame.new(-7894.6176757813,5547.1416015625,-380.29119873047),TravelMode="Portal",PortalDestination=Vector3.new(-7894.6176757813,5547.1416015625,-380.29119873047),BypassAllowed=false},
    	  {Name="Prison",Target=CFrame.new(4875.330078125,5.6519818305969,734.85021972656)},
    	  {Name="Magma Village",Target=CFrame.new(-5247.7163085938,12.883934020996,8504.96875)},
    	  {Name="Underwater City",Target=CFrame.new(61163.8515625,11.6796875,1819.7841796875),Region="UnderwaterCity",BypassAllowed=false},
    	  {Name="Fountain City",Target=CFrame.new(5127.1284179688,59.501365661621,4105.4458007813)},
    	},
    	[2] = {
    	  {Name="Kingdom of Rose · Café",Target=CFrame.new(-380.47927856445,77.220390319824,255.82550048828)},
    	  {Name="Kingdom of Rose · Docks",Target=CFrame.new(-11.311455726624,29.276733398438,2771.5224609375)},
    	  {Name="Dark Arena",Target=CFrame.new(3780.0302734375,22.652164459229,-3498.5859375)},
    	  {Name="Don Swan Mansion",Target=CFrame.new(-483.73370361328,332.0383605957,595.32708740234)},
    	  {Name="Don Swan Room",Target=CFrame.new(2284.4140625,15.152037620544,875.72534179688)},
    	  {Name="Green Zone",Target=CFrame.new(-2448.5300292969,73.016105651855,-3210.6306152344)},
    	  {Name="Factory",Target=CFrame.new(424.12698364258,211.16171264648,-427.54049682617)},
    	  {Name="Colosseum",Target=CFrame.new(-1503.6224365234,219.7956237793,1369.3101806641)},
    	  {Name="Graveyard",Target=CFrame.new(-5622.033203125,492.19604492188,-781.78552246094)},
    	  {Name="Snow Mountain",Target=CFrame.new(753.14288330078,408.23559570313,-5274.6147460938)},
    	  {Name="Hot and Cold",Target=CFrame.new(-6127.654296875,15.951762199402,-5040.2861328125)},
    	  {Name="Cursed Ship",Target=CFrame.new(923.40197753906,125.05712890625,32885.875),Region="CursedShip",BypassAllowed=false},
    	  {Name="Ice Castle",Target=CFrame.new(6148.4116210938,294.38687133789,-6741.1166992188)},
    	  {Name="Forgotten Island",Target=CFrame.new(-3032.7641601563,317.89672851563,-10075.373046875)},
    	  {Name="Usoap's Island",Target=CFrame.new(4816.8618164063,8.4599885940552,2863.8195800781)},
    	  {Name="Mini Sky Island",Target=CFrame.new(-288.74060058594,49326.31640625,-35248.59375)},
    	},
    	[3] = {
    	  {Name="Mansion",Target=CFrame.new(-12471.169921875,374.94024658203,-7551.677734375),TravelMode="Portal",PortalDestination=Vector3.new(-12471.169921875,374.94024658203,-7551.677734375),BypassAllowed=false},
    	  {Name="Port Town",Target=CFrame.new(-290.7376708984375,6.729952812194824,5343.5537109375)},
    	  {Name="Great Tree",Target=T.Regions.TempleOfTime.Entrance.Approach,RuntimeNPC="Mysterious Force",ExactTarget=true},
    	  {Name="Castle on the Sea",Target=CFrame.new(-5074.45556640625,314.5155334472656,-2991.054443359375)},
    	  {Name="Hydra Island",Target=CFrame.new(5255.1049,1004.1949,344.7700)},
    	  {Name="Floating Turtle",Target=CFrame.new(-13274.528320313,531.82073974609,-7579.22265625)},
    	  {Name="Haunted Castle",Target=CFrame.new(-9515.3720703125,164.00624084473,5786.0610351562)},
    	  {Name="Ice Cream Island",Target=CFrame.new(-902.56817626953,79.93204498291,-10988.84765625)},
    	  {Name="Peanut Island",Target=CFrame.new(-2062.7475585938,50.473892211914,-10232.568359375)},
    	  {Name="Cake Island",Target=CFrame.new(-1884.7747802734375,19.327526092529297,-11666.8974609375)},
    	  {Name="Cocoa Island",Target=CFrame.new(87.94276428222656,73.55451202392578,-12319.46484375)},
    	  {Name="Candy Island",Target=CFrame.new(-1014.4241943359375,149.11068725585938,-14555.962890625)},
    	  {Name="Tiki Outpost",Target=CFrame.new(-16218.6826,9.08636189,445.618408)},
    	  {Name="Submerged Island",Target=CFrame.new(10780.639648,-2088.414062,9260.453125),Region="Submerged",BypassAllowed=false},
    	},
      }
      -- Normalize Bypass capability for every island across all Seas. The routing
      -- engine consumes this data uniformly; consumers never special-case island names.
      for _,islands in pairs(T.Islands) do
        for _,island in ipairs(islands) do
          local regionSpec=island.Region and T.Regions[tostring(island.Region)] or nil
          if tostring(island.TravelMode or "")=="Portal" or (type(regionSpec)=="table" and regionSpec.BypassAllowed==false) then
            island.BypassAllowed=false
          elseif island.BypassAllowed==nil then
            island.BypassAllowed=true
          end
        end
      end

      T.MovementZoneOrder = {"SkyUpper","SkyLower"}
      T.MovementZones = {
        SkyUpper = {
          Key="SkyUpper", Sea=1, TransitionSensitive=true, BypassAllowed=false,
          Detector={Center=Vector3.new(-7894.6176757813,5547.1416015625,-380.29119873047),RadiusXZ=2600,MinY=3000,MaxY=8000},
        },
        SkyLower = {
          Key="SkyLower", Sea=1, TransitionSensitive=true, BypassAllowed=false,
          Detector={Center=Vector3.new(-4738.4626464844,800,-2167.2875976563),RadiusXZ=2800,MinY=150,MaxY=1800},
        },
      }

      T.Portals = {
        [1] = {
          {Key="Sky3Exit",Aliases={"Skylands · Middle","Sky Island 2","Sky2","Lower Sky","SkyMiddle"},RemotePos=Vector3.new(-4607.82275,872.54248,-1667.55688),DestinationZone="SkyLower",ServiceZones={"SkyLower"},ServiceRadius=4500,TransitionRole="Middle"},
          {Key="Sky3",Aliases={"Skylands · Upper","Sky Island 3","SkyUpper","Upper Sky"},RemotePos=Vector3.new(-7894.6176757813,5547.1416015625,-380.29119873047),DestinationZone="SkyUpper",ServiceZones={"SkyUpper"},ServiceRadius=4500,TransitionRole="Upper"},
          {Key="UnderWater",Aliases={"Underwater City","Under Water Island","UnderWater","Fishman Island"},RemotePos=Vector3.new(61163.8515625,11.6796875,1819.7841796875),DestinationRegion="UnderwaterCity",ServiceRegions={"UnderwaterCity"},ServiceRadius=7000},
          {Key="UnderwaterExit",Aliases={"Underwater Exit"},RemotePos=Vector3.new(3864.8515625,6.6796875,-1926.7841796875),SourceRegions={"UnderwaterCity"},DestinationRegion="World",ServiceRegions={"World"},ServiceRadius=10000},
        },
        [2] = {
          {Key="CursedShip",Aliases={"Cursed Ship"},RemotePos=Vector3.new(923.21252441406,126.9760055542,32852.83203125),DestinationRegion="CursedShip",ServiceRegions={"CursedShip"},ServiceRadius=7500},
          {Key="SecondSeaMainland",Aliases={"Zombie Island","Graveyard","Second Sea Mainland"},RemotePos=Vector3.new(-6508.5581054688,89.034996032715,-132.83953857422),DestinationRegion="World",ServiceRegions={"World"},ServiceRadius=10000},
          {Key="SwanRoom",Aliases={"Don Swan Room","Flamingo Room","Swan Room"},RemotePos=Vector3.new(2285,15,905),DestinationRegion="World",ServiceRegions={"World"},ServiceRadius=5500},
        },
        [3] = {
          {Key="Mansion",Aliases={"Mansion","Floating Turtle"},RemotePos=Vector3.new(-12471.169921875,374.94024658203,-7551.677734375),DestinationRegion="World",ServiceRegions={"World"},ServiceRadius=6500},
          {Key="Castle",Aliases={"Castle on the Sea","Castle On The Sea"},RemotePos=Vector3.new(-5097.93164,316.447021,-3142.66602),DestinationRegion="World",ServiceRegions={"World"},ServiceRadius=6500},
          {Key="Hydra",Aliases={"Hydra Island","Hydra"},RemotePos=Vector3.new(5643.4526367188,1013.0858154297,-340.51025390625),DestinationRegion="World",ServiceRegions={"World"},ServiceRadius=6500},
          {Key="BeautifulPirate",Aliases={"Beautiful Pirate","Beautiful Pirate Domain"},RemotePos=Vector3.new(5314.5463867188,22.562219619751,-127.06755065918),DestinationRegion="World",ServiceRegions={"World"},ServiceRadius=5000},
        },
      }
    RE4Constants.WorldTopology = T

    RE4Constants.SimpleToggles = {
        ["global.AcientOne"]={Name="Auto Train V4",Description="Tự Động Train V4",Default=false,Binding="global",Flag="AcientOne"},
        ["global.Addealer"]={Name="Auto Tween To Advanced Fruit Dealer",Description="Tự Động Bay Đến Đại Lý Bán Trái",Default=false,Binding="global",Flag="Addealer"},
        ["global.AutoBigmom"]={Name="Auto Get Buddy Sword",Description="Tự Động Lấy Kiếm Buddy",Default=false,Binding="global",Flag="AutoBigmom"},
        ["global.AutoEcBoss"]={Name="Auto Get Midnight Blade",Description="Tự Động Lấy Midnight Blade",Default=false,Binding="global",Flag="AutoEcBoss"},
        ["global.AutoFireFlowers"]={Name="Auto Draco V2",Description="Tự Động Lấy Tộc Draco V2",Default=false,Binding="global",Flag="AutoFireFlowers"},
        ["global.AutoHopServer"]={Name="Auto Hop [Every 30 Minutes]",Description="Tự Động Chuyển Máy Chủ [Mỗi 30 Phút]",Default=false,Binding="global",Flag="AutoHopServer"},
        ["global.AutoKenVTWO"]={Name="Auto Haki Observation V2",Description="Tự Động Lấy Haki Quan Sát V2",Default=false,Binding="global",Flag="AutoKenVTWO"},
        ["global.AutoKilo"]={Name="Auto Get Lei Accessory",Description="Tự Động Lấy Lai Accessory",Default=false,Binding="global",Flag="AutoKilo"},
        ["global.AutoMatSoul"]={Name="Auto Farm Materials Skull Guitar",Description="Tự Động Cày Nguyên Liệu Lấy Skull Guitar",Default=false,Binding="global",Flag="AutoMatSoul"},
        ["global.AutoRipIngay"]={Name="Auto Farm Rip Indra",Description="Tự Động Đánh Rip Indra",Default=false,Binding="global",Flag="AutoRipIngay"},
        ["global.AutoSerpentBow"]={Name="Auto Get Serpent Bow",Description="Tự Động Lấy Serpent Bow",Default=false,Binding="global",Flag="AutoSerpentBow"},
        ["global.AutoTridentW2"]={Name="Auto Get Dragon Trident",Description="Tự Động Lấy Dragon Trident",Default=false,Binding="global",Flag="AutoTridentW2"},
        ["global.AutoUnHaki"]={Name="Auto Three Color Haki",Description="Tự Động Giải Mã 3 Màu Haki",Default=false,Binding="global",Flag="AutoUnHaki"},
        ["global.AutoZou"]={Name="Auto Quest Sea 3",Description="Tự Động Làm Nhiệm Vụ Sea 3",Default=false,Binding="global",Flag="AutoZou"},
        ["global.Auto_Cavender"]={Name="Auto Get Florentino Sword",Description="Tự Động Lấy Kiếm Florentino",Default=false,Binding="global",Flag="Auto_Cavender"},
        ["global.Auto_Def_DarkCoat"]={Name="Auto Farm Darkbeard",Description="Tự Động Đánh Râu Đen",Default=false,Binding="global",Flag="Auto_Def_DarkCoat"},
        ["global.Auto_DonAcces"]={Name="Auto Unlock DonSwan",Description="Tự Động Mở Khoá DonSwan",Default=false,Binding="global",Flag="Auto_DonAcces"},
        ["global.Auto_Fish"]={Name="Auto Upgrade Fish V3",Description="Tự Động Nâng Tộc Cá V3",Default=false,Binding="global",Flag="Auto_Fish"},
        ["global.Auto_Human"]={Name="Auto Upgrade Human V3",Description="Tự Động Nâng Tộc Người V3",Default=false,Binding="global",Flag="Auto_Human"},
        ["global.Auto_Mink"]={Name="Auto Upgrade Mink V3",Description="Tự Động Nâng Tộc Thỏ V3",Default=false,Binding="global",Flag="Auto_Mink"},
        ["global.Auto_Rainbow_Haki"]={Name="Auto Haki Rainbow",Description="Tự Động Lấy Haki 7 Màu",Default=false,Binding="global",Flag="Auto_Rainbow_Haki"},
        ["global.Auto_Skypiea"]={Name="Auto Upgrade Angel V3",Description="Tự Động Nâng Tộc Thiên Thần V3",Default=false,Binding="global",Flag="Auto_Skypiea"},
        ["global.Auto_Soul_Guitar"]={Name="Auto Get Skull Guitar",Description="Tự Động Lấy Skull Guitar",Default=false,Binding="global",Flag="Auto_Soul_Guitar"},
        ["global.Auto_SwanGG"]={Name="Auto Get Swan Glasses",Description="Tự Động Lấy Kính Swan",Default=false,Binding="global",Flag="Auto_SwanGG"},
        ["global.Auto_Tushita"]={Name="Auto Get Tushita",Description="Tự Động Lấy Tushita",Default=false,Binding="global",Flag="Auto_Tushita"},
        ["global.Auto_Yama"]={Name="Auto Get Yama",Description="Tự Động Lấy Yama",Default=false,Binding="global",Flag="Auto_Yama"},
        ["global.AutofindKitIs"]={Name="Auto Find Kitsune Island",Description="Tự Động Tìm Đảo Cáo",Default=false,Binding="global",Flag="AutofindKitIs"},
        ["global.Bartilo_Quest"]={Name="Auto Complete Quest Bartilo",Description="Tự Động Hoàn Thành Nhiệm Vụ Bartilo",Default=false,Binding="global",Flag="Bartilo_Quest"},
        ["global.BlackSpikey"]={Name="Auto Get Black Spikey",Description="Tự Động Lấy Black Spikey",Default=false,Binding="global",Flag="BlackSpikey"},
        ["global.BuyDrago"]={Name="Swap Draco Race",Description="Chuyển Đổi Tộc Draco",Default=false,Binding="global",Flag="BuyDrago"},
        ["global.Bypass"]={Name="Turn On Bypass Teleport",Description="Bật Dịch Chuyển Bypass",Default=true,Binding="global",Flag="Bypass"},
        ["global.CDK"]={Name="Auto Get CDK",Description="Tự Động Lấy Song Kiếm Nguyền Rủa",Default=false,Binding="global",Flag="CDK"},
        ["global.CDK_TS"]={Name="Auto Quest Tushita [CDK]",Description="Tự Động Nhiệm Vụ Tushita [CDK]",Default=false,Binding="global",Flag="CDK_TS"},
        ["global.CDK_YM"]={Name="Auto Quest Yama [CDK]",Description="Tự Động Nhiệm Vụ Yama [CDK]",Default=false,Binding="global",Flag="CDK_YM"},
        ["global.CitizenQuest"]={Name="Auto Complete Quest Citizen",Description="Tự Động Hoàn Thành Nhiệm Vụ Citizen",Default=false,Binding="global",Flag="CitizenQuest"},
        ["global.Collect_Ember"]={Name="Auto Collect Azure Ember",Description="Tự Động Nhặt Azure Ember",Default=false,Binding="global",Flag="Collect_Ember"},
        ["global.Complete_Trials"]={Name="Auto Complete Trial Race",Description="Tự Động Hoàn Thành Trial",Default=false,Binding="global",Flag="Complete_Trials"},
        ["global.CraftVM"]={Name="Auto Craft Volcanic Magnet",Description="Tự Động Chế Tạo Volcanic Magnet",Default=false,Binding="global",Flag="CraftVM"},
        ["global.DT_Uzoth"]={Name="Upgrade Dragon Talon V3",Description="Nâng Cấp Dragon Talon V3",Default=false,Binding="global",Flag="DT_Uzoth"},
        ["global.DarkBladev3"]={Name="Auto Dark Blade V3",Description="Tự Động Lấy Dark Blade V3",Default=false,Binding="global",Flag="DarkBladev3"},
        ["global.Defeating"]={Name="Auto Kill Player After Trial",Description="Tự Động Giết Các Người Chơi Khác Sau Trial",Default=false,Binding="global",Flag="Defeating"},
        ["global.Dojoo"]={Name="Auto Dojo Trainer",Description="Tự Động Lấy Đai",Default=false,Binding="global",Flag="Dojoo"},
        ["global.DragoV1"]={Name="Auto Draco V1",Description="Tự Động Lấy Tộc Draco V1",Default=false,Binding="global",Flag="DragoV1"},
        ["global.DragoV3"]={Name="Auto Draco V3",Description="Tự Động Lấy Tộc Draco V3",Default=false,Binding="global",Flag="DragoV3"},
        ["global.DummyMan"]={Name="Auto Farm Training Dummy",Description="Tự Động Đánh Training Dummy",Default=false,Binding="global",Flag="DummyMan"},
        ["global.FarmBlazeEM"]={Name="Auto Dragon Hunter",Description="Tự Động Dragon Hunter",Default=false,Binding="global",Flag="FarmBlazeEM"},
        ["global.FarmChestM"]={Name="Auto Collect Mirage Chest",Description="Tự Động Nhặt Rương Bí Ẩn",Default=false,Binding="global",Flag="FarmChestM"},
        ["global.FindMirage"]={Name="Auto Find Mirage Island",Description="Tự Động Tìm Đảo Bí Ẩn",Default=false,Binding="global",Flag="FindMirage"},
        ["global.FrozenTP"]={Name="Auto Teleport Frozen Dimension",Description="Tự Động Dịch Chuyển Đến Frozen Dimension",Default=false,Binding="global",Flag="FrozenTP"},
        ["global.GetQFast"]={Name="Get Quest Haki Rainbow",Description="Nhận Nhiệm Vụ Haki 7 Màu",Default=false,Binding="global",Flag="GetQFast"},
        ["global.HighestMirage"]={Name="Tween To Mirage Island",Description="Bay Đến Đảo Bí Ẩn",Default=false,Binding="global",Flag="HighestMirage"},
        ["global.IceBossRen"]={Name="Auto Get Rengoku Sword",Description="Tự Động Lấy Kiếm Rengoku",Default=false,Binding="global",Flag="IceBossRen"},
        ["global.KeysRen"]={Name="Auto Get Key Rengoku",Description="Tự Động Lấy Chìa Khoá Rengoku",Default=false,Binding="global",Flag="KeysRen"},
        ["global.Leviathan1"]={Name="Auto Attack Leviathan",Description="Tự Động Đánh Leviathan",Default=false,Binding="global",Flag="Leviathan1"},
        ["global.LongsWord"]={Name="Auto Get Long Sword",Description="Tự Động Lấy Kiếm Dài",Default=false,Binding="global",Flag="LongsWord"},
        ["global.Lver"]={Name="Auto Pull Lever",Description="Tự Động Gạt Cần",Default=false,Binding="global",Flag="Lver"},
        ["global.PortalUnLock"]={Name="Unlock All Portals",Description="Nhảy Vô Hạn Bằng Trái Portal",Default=false,Binding="global",Flag="PortalUnLock"},
        ["global.Prehis_DB"]={Name="Auto Collect Bones",Description="Tự Động Nhặt Xương",Default=false,Binding="global",Flag="Prehis_DB"},
        ["global.RaceClickAutov3"]={Name="Auto Turn On V3",Description="Tự Động Bật V3",Default=false,Binding="global",Flag="RaceClickAutov3"},
        ["global.RaceClickAutov4"]={Name="Auto Turn On V4",Description="Tự Động Bật V4",Default=false,Binding="global",Flag="RaceClickAutov4"},
        ["global.Relic123"]={Name="Auto Relic Draco Trial V4",Description="Tự Động Thắp Đèn Trial Draco V4",Default=false,Binding="global",Flag="Relic123"},
        ["global.ResetPH"]={Name="Auto Reset When Complete",Description="Tự Động Đặt Lại Khi Hoàn Thành",Default=false,Binding="global",Flag="ResetPH"},
        ["global.Safemode"]={Name="Panic Mode",Description="Chế Độ Hoảng Loạn",Default=false,Binding="global",Flag="Safemode"},
        ["global.SailBoat_Hydra"]={Name="Auto Drive To Hydra Island",Description="Tự Động Lái Đến Đảo Phụ Nữ",Default=false,Binding="global",Flag="SailBoat_Hydra"},
        ["global.TPDoor"]={Name="Auto Teleport To Race Doors",Description="Dịch Chuyển Đến Race Doors",Default=false,Binding="global",Flag="TPDoor"},
        ["global.TPGEAR"]={Name="Auto Collect Gear",Description="Tự Động Nhặt Bánh Răng",Default=false,Binding="global",Flag="TPGEAR"},
        ["global.TpDrago_Prehis"]={Name="Tween To Draco Trial V4",Description="Bay Đến Nơi Trial Draco V4",Default=false,Binding="global",Flag="TpDrago_Prehis"},
        ["global.Tp_LgS"]={Name="Tween To Legendary Sword Seller NPC",Description="Bay Đến NPC Bán Kiếm Legendary",Default=false,Binding="global",Flag="Tp_LgS"},
        ["global.Trade_Ember"]={Name="Auto Trade Azure Ember",Description="Tự Động Đổi Azure Ember",Default=false,Binding="global",Flag="Trade_Ember"},
        ["global.TrainDrago"]={Name="Auto Train Draco V4",Description="Tự Động Train Draco V4",Default=false,Binding="global",Flag="TrainDrago"},
        ["global.TwinHook"]={Name="Auto Get Twin Hooks",Description="Tự Động Lấy Móc Đôi",Default=false,Binding="global",Flag="TwinHook"},
        ["global.UPGDrago"]={Name="Tween To Upgrade Draco Trial",Description="Bay Đến Trial Nâng Cấp Draco",Default=false,Binding="global",Flag="UPGDrago"},
        ["global.WalkWater"]={Name="Turn On Ice Walk",Description="Bật Đi Trên Băng",Default=false,Binding="global",Flag="WalkWater"},
        ["global.can"]={Name="Change Transparency Can See",Description="Thay Đổi Tính Minh Bạch Có Thể Thấy",Default=false,Binding="global",Flag="can"},
        ["global.daylightN"]={Name="Turn On Time",Description="Bật Thời Gian",Default=false,Binding="global",Flag="daylightN"},
        ["global.obsFarm"]={Name="Auto Farm Haki Observation",Description="Tự Động Cày Điểm Né Haki Quan Sát",Default=false,Binding="global",Flag="obsFarm"},
        ["global.tweenShrine"]={Name="Auto Shrine Actived",Description="Tự Động Kích Hoạt",Default=false,Binding="global",Flag="tweenShrine"},
        ["lease.Auto_Awakener"]={Name="Auto Awakening",Description="Tự Động Thức Tỉnh",Default=false,Binding="lease",Flag="Auto_Awakener"},
        ["lease.FishBoat"]={Name="Auto Attack Fish Boat",Description="Tự Động Đánh Tàu Bắt Cá",Default=false,Binding="lease",Flag="FishBoat"},
        ["lease.HCM"]={Name="Auto Attack Haunted Crew Member",Description="Tự Động Đánh Thành Viên Ohi Hành Đoàn Bị Ám",Default=false,Binding="lease",Flag="HCM"},
        ["lease.KillAuraFull"]={Name="Kill Aura",Description="Giết Hào Quang",Default=false,Binding="lease",Flag="KillAuraFull"},
        ["lease.MobCrew"]={Name="Auto Attack Fish Crew Member",Description="Tự Động Đánh Thành Viên Đội Đánh Cá",Default=false,Binding="lease",Flag="MobCrew"},
        ["lease.PGB"]={Name="Auto Attack Pirate Ship",Description="Tự Động Đánh Tàu Hải Tặc",Default=false,Binding="lease",Flag="PGB"},
        ["lease.Piranha"]={Name="Auto Kill Piranha",Description="Tự Động Giết Cá Piranha",Default=false,Binding="lease",Flag="Piranha"},
        ["lease.Prehis_DE"]={Name="Auto Collect Dragon Egg",Description="Tự Động Nhặt Trứng Rồng",Default=false,Binding="lease",Flag="Prehis_DE"},
        ["lease.Prehis_Find"]={Name="Auto Find Prehistoric Island",Description="Tự Động Tìm Đảo Núi Lửa",Default=false,Binding="lease",Flag="Prehis_Find"},
        ["lease.Prehis_Skills"]={Name="Auto Start Event",Description="Tự Động Bắt Đầu Sự Kiện",Default=false,Binding="lease",Flag="Prehis_Skills"},
        ["lease.Raiding"]={Name="Auto Raid [Safe]",Description="Tự Động Raid [An Toàn]",Default=false,Binding="lease",Flag="Raiding"},
        ["lease.SailBoats"]={Name="Auto Sail [Sit Down And Turn On]",Description="Tự Động Lái [Ngồi Vào Chỗ Rồi Bật]",Default=false,Binding="lease",Flag="SailBoats"},
        ["lease.SeaBeast1"]={Name="Auto Attack Sea Beast",Description="Tự Động Đánh Sea Beast",Default=false,Binding="lease",Flag="SeaBeast1"},
        ["lease.Shark"]={Name="Auto Kill Shark",Description="Tự Động Giết Cá Mập",Default=false,Binding="lease",Flag="Shark"},
        ["lease.TerrorShark"]={Name="Auto Kill Terror Shark",Description="Tự Động Giết Cá Mập Tận Thế",Default=false,Binding="lease",Flag="TerrorShark"},
    }


    RE4Constants.UIControls = RE4Constants.UIControls or {}
    RE4Constants.UIControls["button.auto.buy.legendary.sword"]={Name="Auto Buy Legendary Sword",Description="Tự Động Mua Kiếm Lagendary"}
    RE4Constants.UIControls["button.auto.craft.true.triple.katana"]={Name="Auto Craft True Triple Katana",Description="Tự Động Chế Tạo True Triple Katana"}
    RE4Constants.UIControls["button.buy.boat"]={Name="Buy Boat",Description="Mua Thuyền"}
    RE4Constants.UIControls["button.buy.color.haki"]={Name="Buy Color Haki",Description="Mua Màu Haki"}
    RE4Constants.UIControls["button.buy.cyborg.race"]={Name="Buy Cyborg Race",Description="Mua Tộc Người Máy"}
    RE4Constants.UIControls["button.buy.dungeon.chips.devil.fruit"]={Name="Buy Dungeon Chips [Devil Fruit]",Description="Mua Chip Dungeon [Bằng Trái Ác Quỷ]"}
    RE4Constants.UIControls["button.buy.ghoul.race"]={Name="Buy Ghoul Race",Description="Mua Tộc Quỷ"}
    RE4Constants.UIControls["button.buy.kabucha"]={Name="Buy Kabucha",Description="Mua Ná Kabucha"}
    RE4Constants.UIControls["button.buy.spy"]={Name="Buy Spy",Description="Mua Spy"}
    RE4Constants.UIControls["button.changebusostage"]={Name="ChangeBusoStage",Description=""}
    RE4Constants.UIControls["button.copy.job.id"]={Name="Copy Job ID",Description="Sao Chép Job ID Máy Chủ"}
    RE4Constants.UIControls["button.craft.volcanic.magnet"]={Name="Craft Volcanic Magnet",Description="Chế Tạo Volcanic Magnet"}
    RE4Constants.UIControls["button.devil.fruit.rain.update.2450"]={Name="Devil Fruit Rain Update 2450",Description="Mưa Trái Ác Quảy Cập Nhật Cấp 2450"}
    RE4Constants.UIControls["button.open.awakening.expert"]={Name="Open Awakening Expert",Description="Mở Chuyên Gia Thức Tỉnh"}
    RE4Constants.UIControls["button.open.title.select"]={Name="Open Title Select",Description="Mở Lựa Chọn Danh Hiệu"}
    RE4Constants.UIControls["button.refund.stats"]={Name="Refund Stats",Description="Hoàn Lại Chỉ Số"}
    RE4Constants.UIControls["button.rejoin.server"]={Name="Rejoin Server",Description="Vào Lại Máy Chủ"}
    RE4Constants.UIControls["button.remove.sky.fog"]={Name="Remove Sky Fog",Description="Xoá Sương Mù"}
    RE4Constants.UIControls["button.reroll.race"]={Name="Reroll Race",Description="Đổi Tộc"}
    RE4Constants.UIControls["button.set.marine.team"]={Name="Set Marine Team",Description="Vào Đội Hải Quân"}
    RE4Constants.UIControls["button.set.pirate.team"]={Name="Set Pirate Team",Description="Vào Đội Hải Tặc"}
    RE4Constants.UIControls["button.talk.with.kitsune.statue"]={Name="Talk With Kitsune Statue",Description="Nói Chuyện Với Tượng Cáo"}
    RE4Constants.UIControls["button.talk.with.stone"]={Name="Talk With Stone",Description="Race V4 Progress"}
    RE4Constants.UIControls["button.teleport.job.id"]={Name="Teleport [Job ID]",Description="Dịch Chuyển [Job ID]"}
    RE4Constants.UIControls["button.teleport.to.ancient.clock"]={Name="Teleport To Ancient Clock",Description="Travel to Ancient Clock"}
    RE4Constants.UIControls["button.teleport.to.ancient.one"]={Name="Teleport To Ancient One",Description="Travel to Ancient One"}
    RE4Constants.UIControls["button.teleport.to.sea.1"]={Name="Teleport To Sea 1",Description="Dịch Chuyển Đến Sea 1"}
    RE4Constants.UIControls["button.teleport.to.sea.2"]={Name="Teleport To Sea 2",Description="Dịch Chuyển Đến Sea 2"}
    RE4Constants.UIControls["button.teleport.to.sea.3"]={Name="Teleport To Sea 3",Description="Dịch Chuyển Đến Sea 3"}
    RE4Constants.UIControls["button.teleport.to.temple.of.time"]={Name="Teleport To Temple of Time",Description="Enter through Mysterious Force at Great Tree"}
    RE4Constants.UIControls["button.trade.item.azure"]={Name="Trade Item Azure",Description="Đổi Vật Phẩm Azure"}
    RE4Constants.UIControls["button.turn.on.fast.mode"]={Name="Turn On Fast Mode",Description="Bật Chế Độ Nhanh"}
    RE4Constants.UIControls["button.turn.on.increase.boat"]={Name="Turn On Increase Boat",Description="Bật Tăng Tốc Thuyền"}
    RE4Constants.UIControls["button.turn.on.low.cpu"]={Name="Turn On Low CPU",Description="Bật CPU Thấp"}
    RE4Constants.UIControls["toggle.anti.kick"]={Name="Anti Kick",Description="Chống Kick",Default=true}
    RE4Constants.UIControls["toggle.auto.get.law.sword"]={Name="Auto Get Law Sword",Description="Tự Động Lấy Kiếm Law",Default=false}
    RE4Constants.UIControls["toggle.auto.get.pole.v1"]={Name="Auto Get Pole V1",Description="Tự Động Lấy Pole V1",Default=false}
    RE4Constants.UIControls["toggle.auto.look.at.moon"]={Name="Auto Look At Moon",Description="Tự Động Nhìn Trăng",Default=false}
    RE4Constants.UIControls["toggle.auto.pole.v2"]={Name="Auto Pole V2",Description="Equip Pole V1 and wait for the current Rough Sea lightning upgrade condition.",Default=false}
    RE4Constants.UIControls["toggle.auto.quest.sea.2"]={Name="Auto Quest Sea 2",Description="Tự Động Làm Nhiệm Vụ Sea 2",Default=false}
    RE4Constants.UIControls["toggle.auto.start.raid"]={Name="Auto Start Raid",Description="Tự Động Bắt Đầu Raid",Default=false}
    RE4Constants.UIControls["toggle.auto.teleport.barista.cousin"]={Name="Auto Teleport Barista Cousin",Description="Tự Động Dịch Chuyển Đến Barista Cousin",Default=false}
    RE4Constants.UIControls["toggle.auto.turn.on.haki"]={Name="Auto Turn On Haki",Description="Tự Động Bật Haki",Default=true}
    RE4Constants.UIControls["toggle.auto.turn.on.spin.position"]={Name="Auto Turn On Spin Position",Description="Tự Động Bật Spin Position",Default=false}
    RE4Constants.UIControls["toggle.auto.use.skill.z.buddha"]={Name="Auto Use Skill Z Buddha",Description="Tự Động Dùng Chiêu Z Buddha Để Farm",Default=false}
    RE4Constants.UIControls["toggle.disable.chat"]={Name="Disable Chat",Description="Tắt Chat",Default=false}
    RE4Constants.UIControls["toggle.disable.leader.board"]={Name="Disable Leader Board",Description="Tắt Khung Chat",Default=false}
    RE4Constants.UIControls["toggle.disable.notify"]={Name="Disable Notify",Description="Tắt Thông Báo",Default=false}
    RE4Constants.UIControls["toggle.fast.attack"]={Name="Fast Attack",Description="Đánh Nhanh",Default=true}
    RE4Constants.UIControls["toggle.fullbright"]={Name="FullBright",Description="Sáng Màn Hình",Default=false}
    RE4Constants.UIControls["toggle.noclip"]={Name="Noclip",Description="Đi Xuyên Tường",Default=false}
    RE4Constants.UIControls["toggle.remove.death.and.respamed"]={Name="Remove Death And Respamed",Description="Xoá Hiệu Ứng Chết Và Hồi Sinh",Default=false}
    RE4Constants.UIControls["toggle.remove.hit"]={Name="Remove Hit",Description="Xoá Hiệu Ứng Chém Và Kiếm Để Có Khả Năng Hiển Thị Tốt Hơn",Default=false}
    RE4Constants.UIControls["toggle.remove.lava"]={Name="Remove Lava",Description="Xoá Dung Nham",Default=false}
    RE4Constants.UIControls["toggle.silent.aim"]={Name="Silent Aim",Description="Aim chiêu vào người chơi",Default=false}
    RE4Constants.UIControls["toggle.stop.item"]={Name="Stop Item",Description="Dừng Khi Có Vật Phẩm",Default=true}
    RE4Constants.UIControls["toggle.turn.on.walk.on.water"]={Name="Turn On Walk On Water",Description="Bật Đi Trên Nước",Default=true}

    RE4Constants.TrialCombatMobs={"Ancient Vampire","Ancient Zombie"}

    env.RE4_CONSTANTS=RE4Constants
end

-- RE4-SOURCE-UNIT: data
--[[
RE4 HUB · GAME DATA REGISTRY
Passive, authoritative game/catalog data only. Runtime behavior belongs in main.lua;
configurable timing/threshold values belong in config.lua; user-facing text belongs in language/.
This module has no dependency on Core, UI, Config or executor state.
]]

local RE4Data = {
    Schema = 1,
    Revision = "game-data-2.3.15-final-20260912.1",

    Teams = {
        Pirates = "Pirates",
        Marines = "Marines",
    },

    Folders = {
        Enemies = "Enemies",
        Characters = "Characters",
        NPCs = "NPCs",
    },

    GachaRules = { MinimumLevel = 50 },
    RaidRules = {
        MinimumLevel = 1100,
        NormalIslandNames = {"Island 1", "Island 2", "Island 3", "Island 4", "Island 5"},
        NormalIslandCount = 5,
    },

    -- Update 30 separates ordinary quest progression from Secret Levels.
    -- Regular quests stop contributing progression at 2800; Island Secrets
    -- provide the remaining 200 levels up to the actual 3000 cap. Keeping
    -- these as separate concepts prevents Auto Farm Level from repeatedly
    -- grinding a valid quest that can no longer advance the account.
    LevelSystem = {
        RegularQuestCap = 2800,
        SecretLevelCap = 3000,
        SecretCount = 40,
        SecretLevelsPerSecret = 5,
    },

    EliteBosses = {"Diablo","Deandre","Urban"},

    RaceProgression = {
        Aliases = {
            Human="Human", Rabbit="Mink", Mink="Mink", Angel="Skypiea", Skypiea="Skypiea",
            Shark="Fishman", Fishman="Fishman", Ghoul="Ghoul", Cyborg="Cyborg", Draco="Draco",
        },
        DisplayAliases = {
            Mink="Rabbit", Skypiea="Angel", Fishman="Shark",
        },
        HumanV3Bosses = {"Orbitus","Jeremy","Diamond"},
        V2Flowers = {"Flower 1","Flower 2","Flower 3"},
        V2 = {MinimumLevel=850, BeliRequired=500000, BartiloProgress=3, QuestNPC="Alchemist", Remote="Alchemist"},
        V3 = {MinimumLevel=1000, BeliRequired=2000000, QuestNPC="Arowe", Remote="Wenlocktoad", DonSwan="Don Swan"},
        Ghoul = {
            MinimumLevel=1000, EctoplasmRequired=100, Torch="Hellfire Torch", Boss="Cursed Captain", NPC="Experimic",
            Shop={Remote="Ectoplasm",BuyCheck="BuyCheck",Change="Change",Index=4},
        },
        Cyborg = {
            FragmentsRequired=2500, Fist="Fist of Darkness", Core="Core Brain", Boss="Order", Trainer="CyborgTrainer", PreferredFistSource="Sea Beast",
            TrainerCheckAction="Check", TrainerBuyAction="Buy",
            LabPath={"Map","CircleIsland","RaidSummon","Button","Main"}, LabGatePart="BlockPart",
            -- Observable client text emitted by the laboratory after the Fist
            -- prerequisite has been accepted. These are evidence tokens only;
            -- progression never succeeds from UI text alone.
            FistAcceptedNotificationTokens={"core brain","lõi"},
        },
        Draco = {
            NPC="Dragon Wizard", Remote="InteractDragonQuest",
            Speak={NPC="Dragon Wizard",Command="Speak"},
            Begin={NPC="Dragon Wizard",Command="Ascension",Action="Begin"},
            Complete={NPC="Dragon Wizard",Command="Ascension",Action="Complete"},
            Buy={NPC="Dragon Wizard",Command="DragonRace"},
            V2Available="V2", V2InProgress="V2InProgress",
            V3Available="V3", V3InProgress="V3InProgress",
            FireFlower="Fire Flower", FireFlowerRequired=5, FireFlowerContainer="FireFlowers", FireFlowerMob="Forest Pirate",
            V3Boss="Terrorshark",
        },
    },

    MasterySkillControls = {
        fruit = {"Z","X","C","V","F"},
        gun = {"Z","X","C","V"},
    },

    -- Passive presentation/runtime identity metadata. Core owns behavior; these
    -- registries keep ordering and game/entity mappings out of feature code.
    FightingStyleOrder = {
        "DarkStep","Electric","WaterKungFu","DragonBreath","Superhuman",
        "DeathStep","ElectricClaw","Sharkman","DragonTalon","Godhuman","Sanguine",
    },

    BossObtainables = {
        {ControlId="toggle.auto.get.shark.saw", Item="Shark Saw", Boss="The Saw", LegacyFlag="AutoSaw", RuntimeId="progress.shark_saw"},
        {ControlId="toggle.auto.get.wardens.sword", Item="Wardens Sword", Boss="Warden", LegacyFlag="WardenBoss", RuntimeId="progress.wardens_sword"},
        {ControlId="toggle.auto.get.coat", Item="Coat", Boss="Vice Admiral", LegacyFlag="MarinesCoat", RuntimeId="progress.coat"},
        {ControlId="toggle.auto.get.magma.blaster", Item="Magma Blaster", Boss="Magma General", LegacyFlag="AutoMagmaBlaster", RuntimeId="progress.magma_blaster"},
        {ControlId="toggle.auto.get.trident", Item="Trident", Boss="Fishman Lord", LegacyFlag="AutoTrident", RuntimeId="progress.trident"},
        {ControlId="toggle.auto.get.bazooka", Item="Bazooka", Boss="Sky Warlord", LegacyFlag="AutoBazooka", RuntimeId="progress.bazooka"},
        {ControlId="toggle.auto.get.cool.shades", Item="Cool Shades", Boss="Cyborg", LegacyFlag="AutoCoolShades", RuntimeId="progress.cool_shades"},
    },

    RemotePaths = {
        CommF = {"Remotes", "CommF_"},
        CommE = {"Remotes", "CommE"},
        Validator2 = {"Remotes", "Validator2"},
        RegisterAttack = {"Modules", "Net", "RE/RegisterAttack"},
        RegisterHit = {"Modules", "Net", "RE/RegisterHit"},
        ShootGunEvent = {"Modules", "Net", "RE/ShootGunEvent"},
        TouchKitsuneStatue = {"Modules", "Net", "RE/TouchKitsuneStatue"},
        SubmarineWorkerSpeak = {"Modules", "Net", "RF/SubmarineWorkerSpeak"},
        JobsRemoteFunction = {"Modules", "Net", "RF/JobsRemoteFunction"},
        Craft = {"Modules", "Net", "RF/Craft"},
        DracoTrial = {"Remotes", "DracoTrial"},
        Redeem = {"Remotes", "Redeem"},
        JobToolAbilities = {"Modules", "Net", "RF/JobToolAbilities"},
        FruitCustomizer = {"Modules", "Net", "RF/FruitCustomizerRF"},
        InteractDragonQuest = {"Modules", "Net", "RF/InteractDragonQuest"},
        DragonHunter = {"Modules", "Net", "RF/DragonHunter"},
        KitsuneStatuePray = {"Modules", "Net", "RF/KitsuneStatuePray"},
        FishingRequest = {"FishReplicated", "FishingRequest"},
    },

    Places = {
        Sea1 = {2753915549, 85211729168715, 113741252407134, 114279672983750},
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
        ["Hidden Key"] = true,
        ["Hellfire Torch"] = true,
        ["Core Brain"] = true,
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
RE4Data.FeatureMetadata = {
	Schema = 1,
	Revision = RE4Data.Revision,

	GameData = {
		BossOptionsBySea = {
			[1] = {"The Gorilla King","Chef","The Saw","Yeti","Mob Leader","Vice Admiral","Saber Expert","Warden","Magma General","Fishman Lord","Sky Warlord","Lightning God","Cyborg","Ice Admiral","Greybeard"},
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
            {Name="Leather + Scrap Metal",Island="Pirate Village",Mobs={"Brute","Pirate"}},
            {Name="Angel Wings",Island="Skylands · Upper",Mobs={"Shanda","Royal Squad","Royal Soldier","Sky Warlord","Lightning God"}},
            {Name="Magma Ore",Island="Magma Village",Mobs={"Military Soldier","Military Spy","Magma General"}},
            {Name="Fish Tail",Island="Underwater City",Mobs={"Fishman Warrior","Fishman Commando","Fishman Lord"}},
        },
        [2] = {
            {Name="Leather + Scrap Metal",Island="Green Zone",Mobs={"Marine Captain"}},
            {Name="Radioactive Material",Island="Kingdom of Rose · Café",Mobs={"Factory Staff"}},
            {Name="Ectoplasm",Island="Cursed Ship",Mobs={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}},
            {Name="Mystic Droplet",Island="Forgotten Island",Mobs={"Water Fighter"}},
            {Name="Magma Ore",Island="Hot and Cold",Mobs={"Magma Ninja","Lava Pirate"}},
            {Name="Vampire Fang",Island="Graveyard",Mobs={"Vampire"}},
        },
        [3] = {
            {Name="Scrap Metal",Island="Floating Turtle",Mobs={"Jungle Pirate","Forest Pirate"}},
            {Name="Demonic Wisp",Island="Haunted Castle",Mobs={"Demonic Soul"}},
            {Name="Conjured Cocoa",Island="Cocoa Island",Mobs={"Chocolate Bar Battler","Cocoa Warrior"}},
            {Name="Dragon Scale",Island="Hydra Island",Mobs={"Dragon Crew Archer","Dragon Crew Warrior"}},
            {Name="Gunpowder",Island="Port Town",Mobs={"Pistol Billionaire"}},
            {Name="Fish Tail",Island="Floating Turtle",Mobs={"Fishman Raider","Fishman Captain"}},
            {Name="Mini Tusk",Island="Floating Turtle",Mobs={"Mythological Pirate"}},
        },
    },
    QuestCatalog={
      [1]={
        {Max=9,Team={Marines={Mon="Trainee",Qdata=1,Qname="MarineQuest",NameMon="Trainee",NPC="Marine Leader",Island="Marine Starter Island"},Pirates={Mon="Bandit",Qdata=1,Qname="BanditQuest1",NameMon="Bandit",NPC="Bandit Quest Giver",Island="Pirate Starter Island"}}},
        {Min=10,Max=14,Mon="Monkey",Qdata=1,Qname="JungleQuest",NameMon="Monkey",NPC="Adventurer",Island="Jungle"},
        {Min=15,Max=29,Mon="Gorilla",Qdata=2,Qname="JungleQuest",NameMon="Gorilla",NPC="Adventurer",Island="Jungle"},
        {Min=30,Max=39,Mon="Pirate",Qdata=1,Qname="BuggyQuest1",NameMon="Pirate",NPC="Pirate Adventurer",Island="Pirate Village"},
        {Min=40,Max=59,Mon="Brute",Qdata=2,Qname="BuggyQuest1",NameMon="Brute",NPC="Pirate Adventurer",Island="Pirate Village"},
        {Min=60,Max=74,Mon="Desert Bandit",Qdata=1,Qname="DesertQuest",NameMon="Desert Bandit",NPC="Desert Adventurer",Island="Desert"},
        {Min=75,Max=89,Mon="Desert Officer",Qdata=2,Qname="DesertQuest",NameMon="Desert Officer",NPC="Desert Adventurer",Island="Desert"},
        {Min=90,Max=99,Mon="Snow Bandit",Qdata=1,Qname="SnowQuest",NameMon="Snow Bandit",NPC="Villager",Island="Frozen Village"},
        {Min=100,Max=119,Mon="Snowman",Qdata=2,Qname="SnowQuest",NameMon="Snowman",NPC="Villager",Island="Frozen Village"},
        {Min=120,Max=149,Mon="Chief Petty Officer",Qdata=1,Qname="MarineQuest2",NameMon="Chief Petty Officer",NPC="Marine",Island="Marine Fortress"},
        {Min=150,Max=174,Mon="Sky Bandit",Qdata=1,Qname="SkyQuest",NameMon="Sky Bandit",NPC="Sky Adventurer",Island="Skylands · Lower"},
        {Min=175,Max=189,Mon="Dark Master",Qdata=2,Qname="SkyQuest",NameMon="Dark Master",NPC="Sky Adventurer",Island="Skylands · Lower"},
        {Min=190,Max=209,Mon="Prisoner",Qdata=1,Qname="PrisonerQuest",NameMon="Prisoner",NPC="Jail Keeper",Island="Prison"},
        {Min=210,Max=224,Mon="Dangerous Prisoner",Qdata=2,Qname="PrisonerQuest",NameMon="Dangerous Prisoner",NPC="Jail Keeper",Island="Prison"},
        {Min=225,Max=249,Mon="Ruthless Prisoner",Qdata=1,Qname="ImpelQuest",NameMon="Ruthless Prisoner",NPC="Head Jailer",Island="Prison"},
        {Min=250,Max=274,Mon="Toga Warrior",Qdata=1,Qname="ColosseumQuest",NameMon="Toga Warrior",NPC="Colosseum Quest Giver",Island="Colosseum"},
        {Min=275,Max=299,Mon="Gladiator",Qdata=2,Qname="ColosseumQuest",NameMon="Gladiator",NPC="Colosseum Quest Giver",Island="Colosseum"},
        {Min=300,Max=324,Mon="Military Soldier",Qdata=1,Qname="MagmaQuest",NameMon="Military Soldier",NPC="The Mayor",Island="Magma Village",Boubty=false},
        {Min=325,Max=374,Mon="Military Spy",Qdata=2,Qname="MagmaQuest",NameMon="Military Spy",NPC="The Mayor",Island="Magma Village"},
        {Min=375,Max=399,Mon="Fishman Warrior",Qdata=1,Qname="FishmanQuest",NameMon="Fishman Warrior",NPC="King Neptune",Island="Underwater City"},
        {Min=400,Max=449,Mon="Fishman Commando",Qdata=2,Qname="FishmanQuest",NameMon="Fishman Commando",NPC="King Neptune",Island="Underwater City"},
        {Min=450,Max=474,Mon="God's Guard",Qdata=1,Qname="SkyExp1Quest",NameMon="God's Guard",NPC="Mole",Island="Skylands · Middle"},
        {Min=475,Max=524,Mon="Shanda",Qdata=2,Qname="SkyExp1Quest",NameMon="Shanda",NPC="Mole",Island="Skylands · Upper"},
        {Min=525,Max=549,Mon="Royal Squad",Qdata=1,Qname="SkyExp2Quest",NameMon="Royal Squad",NPC="Sky Quest Giver 2",Island="Skylands · Upper"},
        {Min=550,Max=624,Mon="Royal Soldier",Qdata=2,Qname="SkyExp2Quest",NameMon="Royal Soldier",NPC="Sky Quest Giver 2",Island="Skylands · Upper"},
        {Min=625,Max=649,Mon="Galley Pirate",Qdata=1,Qname="FountainQuest",NameMon="Galley Pirate",NPC="Freezeburg Quest Giver",Island="Fountain City"},
        {Min=650,Mon="Galley Captain",Qdata=2,Qname="FountainQuest",NameMon="Galley Captain",NPC="Freezeburg Quest Giver",Island="Fountain City"},
      },
      [2]={
        {Max=724,Mon="Raider",Qdata=1,Qname="Area1Quest",NameMon="Raider",NPC="Area 1 Quest Giver",Island="Kingdom of Rose · Docks"},
        {Min=725,Max=774,Mon="Mercenary",Qdata=2,Qname="Area1Quest",NameMon="Mercenary",NPC="Area 1 Quest Giver",Island="Kingdom of Rose · Docks"},
        {Min=775,Max=799,Mon="Swan Pirate",Qdata=1,Qname="Area2Quest",NameMon="Swan Pirate",NPC="Area 2 Quest Giver",Island="Kingdom of Rose · Café"},
        {Min=800,Max=874,Mon="Factory Staff",Qdata=2,Qname="Area2Quest",NameMon="Factory Staff",NPC="Area 2 Quest Giver",Island="Kingdom of Rose · Café"},
        {Min=875,Max=899,Mon="Marine Lieutenant",Qdata=1,Qname="MarineQuest3",NameMon="Marine Lieutenant",NPC="Marine Quest Giver",Island="Green Zone"},
        {Min=900,Max=949,Mon="Marine Captain",Qdata=2,Qname="MarineQuest3",NameMon="Marine Captain",NPC="Marine Quest Giver",Island="Green Zone"},
        {Min=950,Max=974,Mon="Zombie",Qdata=1,Qname="ZombieQuest",NameMon="Zombie",NPC="Graveyard Quest Giver",Island="Graveyard"},
        {Min=975,Max=999,Mon="Vampire",Qdata=2,Qname="ZombieQuest",NameMon="Vampire",NPC="Graveyard Quest Giver",Island="Graveyard"},
        {Min=1000,Max=1049,Mon="Snow Trooper",Qdata=1,Qname="SnowMountainQuest",NameMon="Snow Trooper",NPC="Snow Quest Giver",Island="Snow Mountain"},
        {Min=1050,Max=1099,Mon="Winter Warrior",Qdata=2,Qname="SnowMountainQuest",NameMon="Winter Warrior",NPC="Snow Quest Giver",Island="Snow Mountain"},
        {Min=1100,Max=1124,Mon="Lab Subordinate",Qdata=1,Qname="IceSideQuest",NameMon="Lab Subordinate",NPC="Ice Quest Giver",Island="Hot and Cold"},
        {Min=1125,Max=1174,Mon="Horned Warrior",Qdata=2,Qname="IceSideQuest",NameMon="Horned Warrior",NPC="Ice Quest Giver",Island="Hot and Cold"},
        {Min=1175,Max=1199,Mon="Magma Ninja",Qdata=1,Qname="FireSideQuest",NameMon="Magma Ninja",NPC="Fire Quest Giver",Island="Hot and Cold"},
        {Min=1200,Max=1249,Mon="Lava Pirate",Qdata=2,Qname="FireSideQuest",NameMon="Lava Pirate",NPC="Fire Quest Giver",Island="Hot and Cold"},
        {Min=1250,Max=1274,Mon="Ship Deckhand",Qdata=1,Qname="ShipQuest1",NameMon="Ship Deckhand",NPC="Rear Crew Quest Giver",Island="Cursed Ship"},
        {Min=1275,Max=1299,Mon="Ship Engineer",Qdata=2,Qname="ShipQuest1",NameMon="Ship Engineer",NPC="Rear Crew Quest Giver",Island="Cursed Ship"},
        {Min=1300,Max=1324,Mon="Ship Steward",Qdata=1,Qname="ShipQuest2",NameMon="Ship Steward",NPC="Front Crew Quest Giver",Island="Cursed Ship"},
        {Min=1325,Max=1349,Mon="Ship Officer",Qdata=2,Qname="ShipQuest2",NameMon="Ship Officer",NPC="Front Crew Quest Giver",Island="Cursed Ship"},
        {Min=1350,Max=1374,Mon="Arctic Warrior",Qdata=1,Qname="FrostQuest",NameMon="Arctic Warrior",NPC="Frost Quest Giver",Island="Ice Castle"},
        {Min=1375,Max=1424,Mon="Snow Lurker",Qdata=2,Qname="FrostQuest",NameMon="Snow Lurker",NPC="Frost Quest Giver",Island="Ice Castle"},
        {Min=1425,Max=1449,Mon="Sea Soldier",Qdata=1,Qname="ForgottenQuest",NameMon="Sea Soldier",NPC="Forgotten Quest Giver",Island="Forgotten Island"},
        {Min=1450,Mon="Water Fighter",Qdata=2,Qname="ForgottenQuest",NameMon="Water Fighter",NPC="Forgotten Quest Giver",Island="Forgotten Island"},
      },
      [3]={
        {Max=1524,Mon="Pirate Millionaire",Qdata=1,Qname="PiratePortQuest",NameMon="Pirate Millionaire",NPC="Pirate Port Quest Giver",Island="Port Town"},
        {Min=1525,Max=1574,Mon="Pistol Billionaire",Qdata=2,Qname="PiratePortQuest",NameMon="Pistol Billionaire",NPC="Pirate Port Quest Giver",Island="Port Town"},
        {Min=1575,Max=1599,Mon="Dragon Crew Warrior",Qdata=1,Qname="DragonCrewQuest",NameMon="Dragon Crew Warrior",NPC="Dragon Crew Quest Giver",Island="Hydra Island"},
        {Min=1600,Max=1624,Mon="Dragon Crew Archer",Qdata=2,Qname="DragonCrewQuest",NameMon="Dragon Crew Archer",NPC="Dragon Crew Quest Giver",Island="Hydra Island"},
        {Min=1625,Max=1649,Mon="Hydra Enforcer",Qdata=1,Qname="VenomCrewQuest",NameMon="Hydra Enforcer",NPC="Hydra Town Quest Giver",Island="Hydra Island"},
        {Min=1650,Max=1699,Mon="Venomous Assailant",Qdata=2,Qname="VenomCrewQuest",NameMon="Venomous Assailant",NPC="Hydra Town Quest Giver",Island="Hydra Island"},
        {Min=1700,Max=1724,Mon="Marine Commodore",Qdata=1,Qname="MarineTreeIsland",NameMon="Marine Commodore",NPC="Marine Tree Quest Giver",Island="Great Tree"},
        {Min=1725,Max=1774,Mon="Marine Rear Admiral",Qdata=2,Qname="MarineTreeIsland",NameMon="Marine Rear Admiral",NPC="Marine Tree Quest Giver",Island="Great Tree"},
        {Min=1775,Max=1799,Mon="Fishman Raider",Qdata=1,Qname="DeepForestIsland3",NameMon="Fishman Raider",NPC="Turtle Adventure Quest Giver",Island="Floating Turtle"},
        {Min=1800,Max=1824,Mon="Fishman Captain",Qdata=2,Qname="DeepForestIsland3",NameMon="Fishman Captain",NPC="Turtle Adventure Quest Giver",Island="Floating Turtle"},
        {Min=1825,Max=1849,Mon="Forest Pirate",Qdata=1,Qname="DeepForestIsland",NameMon="Forest Pirate",NPC="Deep Forest Quest Giver",Island="Floating Turtle"},
        {Min=1850,Max=1899,Mon="Mythological Pirate",Qdata=2,Qname="DeepForestIsland",NameMon="Mythological Pirate",NPC="Deep Forest Quest Giver",Island="Floating Turtle"},
        {Min=1900,Max=1924,Mon="Jungle Pirate",Qdata=1,Qname="DeepForestIsland2",NameMon="Jungle Pirate",NPC="Deep Forest Area 2 Quest Giver",Island="Floating Turtle"},
        {Min=1925,Max=1974,Mon="Musketeer Pirate",Qdata=2,Qname="DeepForestIsland2",NameMon="Musketeer Pirate",NPC="Deep Forest Area 2 Quest Giver",Island="Floating Turtle"},
        {Min=1975,Max=1999,Mon="Reborn Skeleton",Qdata=1,Qname="HauntedQuest1",NameMon="Reborn Skeleton",NPC="Haunted Castle Quest Giver 1",Island="Haunted Castle"},
        {Min=2000,Max=2024,Mon="Living Zombie",Qdata=2,Qname="HauntedQuest1",NameMon="Living Zombie",NPC="Haunted Castle Quest Giver 1",Island="Haunted Castle"},
        {Min=2025,Max=2049,Mon="Demonic Soul",Qdata=1,Qname="HauntedQuest2",NameMon="Demonic Soul",NPC="Haunted Castle Quest Giver 2",Island="Haunted Castle"},
        {Min=2050,Max=2074,Mon="Posessed Mummy",Qdata=2,Qname="HauntedQuest2",NameMon="Posessed Mummy",NPC="Haunted Castle Quest Giver 2",Island="Haunted Castle"},
        {Min=2075,Max=2099,Mon="Peanut Scout",Qdata=1,Qname="NutsIslandQuest",NameMon="Peanut Scout",NPC="Peanut Quest Giver",Island="Peanut Island"},
        {Min=2100,Max=2124,Mon="Peanut President",Qdata=2,Qname="NutsIslandQuest",NameMon="Peanut President",NPC="Peanut Quest Giver",Island="Peanut Island"},
        {Min=2125,Max=2149,Mon="Ice Cream Chef",Qdata=1,Qname="IceCreamIslandQuest",NameMon="Ice Cream Chef",NPC="Ice Cream Quest Giver",Island="Ice Cream Island"},
        {Min=2150,Max=2199,Mon="Ice Cream Commander",Qdata=2,Qname="IceCreamIslandQuest",NameMon="Ice Cream Commander",NPC="Ice Cream Quest Giver",Island="Ice Cream Island"},
        {Min=2200,Max=2224,Mon="Cookie Crafter",Qdata=1,Qname="CakeQuest1",NameMon="Cookie Crafter",NPC="Cake Quest Giver 1",Island="Cake Island"},
        {Min=2225,Max=2249,Mon="Cake Guard",Qdata=2,Qname="CakeQuest1",NameMon="Cake Guard",NPC="Cake Quest Giver 1",Island="Cake Island"},
        {Min=2250,Max=2274,Mon="Baking Staff",Qdata=1,Qname="CakeQuest2",NameMon="Baking Staff",NPC="Cake Quest Giver 2",Island="Cake Island"},
        {Min=2275,Max=2299,Mon="Head Baker",Qdata=2,Qname="CakeQuest2",NameMon="Head Baker",NPC="Cake Quest Giver 2",Island="Cake Island"},
        {Min=2300,Max=2324,Mon="Cocoa Warrior",Qdata=1,Qname="ChocQuest1",NameMon="Cocoa Warrior",NPC="Chocolate Quest Giver 1",Island="Cocoa Island"},
        {Min=2325,Max=2349,Mon="Chocolate Bar Battler",Qdata=2,Qname="ChocQuest1",NameMon="Chocolate Bar Battler",NPC="Chocolate Quest Giver 1",Island="Cocoa Island"},
        {Min=2350,Max=2374,Mon="Sweet Thief",Qdata=1,Qname="ChocQuest2",NameMon="Sweet Thief",NPC="Chocolate Quest Giver 2",Island="Cocoa Island"},
        {Min=2375,Max=2399,Mon="Candy Rebel",Qdata=2,Qname="ChocQuest2",NameMon="Candy Rebel",NPC="Chocolate Quest Giver 2",Island="Cocoa Island"},
        {Min=2400,Max=2424,Mon="Candy Pirate",Qdata=1,Qname="CandyQuest1",NameMon="Candy Pirate",NPC="Candy Cane Quest Giver",Island="Candy Island"},
        {Min=2425,Max=2449,Mon="Snow Demon",Qdata=2,Qname="CandyQuest1",NameMon="Snow Demon",NPC="Candy Cane Quest Giver",Island="Candy Island"},
        {Min=2450,Max=2474,Mon="Isle Outlaw",Qdata=1,Qname="TikiQuest1",NameMon="Isle Outlaw",NPC="Tiki Quest Giver 1",Island="Tiki Outpost"},
        {Min=2475,Max=2499,Mon="Island Boy",Qdata=2,Qname="TikiQuest1",NameMon="Island Boy",NPC="Tiki Quest Giver 1",Island="Tiki Outpost"},
        {Min=2500,Max=2524,Mon="Sun-kissed Warrior",Qdata=1,Qname="TikiQuest2",NameMon="Sun-kissed Warrior",NPC="Tiki Quest Giver 2",Island="Tiki Outpost"},
        {Min=2525,Max=2549,Mon="Isle Champion",Qdata=2,Qname="TikiQuest2",NameMon="Isle Champion",NPC="Tiki Quest Giver 2",Island="Tiki Outpost"},
        {Min=2550,Max=2574,Mon="Serpent Hunter",Qdata=1,Qname="TikiQuest3",NameMon="Serpent Hunter",NPC="Tiki Quest Giver 3",Island="Tiki Outpost"},
        {Min=2575,Max=2599,Mon="Skull Slayer",Qdata=2,Qname="TikiQuest3",NameMon="Skull Slayer",NPC="Tiki Quest Giver 3",Island="Tiki Outpost"},
        {Min=2600,Max=2624,Mon="Reef Bandit",Qdata=1,Qname="SubmergedQuest1",NameMon="Reef Bandit",NPC="Submerged Quest Giver 1",Island="Submerged Island"},
        {Min=2625,Max=2649,Mon="Coral Pirate",Qdata=2,Qname="SubmergedQuest1",NameMon="Coral Pirate",NPC="Submerged Quest Giver 1",Island="Submerged Island"},
        {Min=2650,Max=2674,Mon="Sea Chanter",Qdata=1,Qname="SubmergedQuest2",NameMon="Sea Chanter",NPC="Submerged Quest Giver 2",Island="Submerged Island"},
        {Min=2675,Max=2699,Mon="Ocean Prophet",Qdata=2,Qname="SubmergedQuest2",NameMon="Ocean Prophet",NPC="Submerged Quest Giver 2",Island="Submerged Island",AutoLevel=false},
        {Min=2675,Max=2699,Mon="High Disciple",Qdata=1,Qname="SubmergedQuest3",NameMon="High Disciple",NPC="Submerged Quest Giver 3",Island="Submerged Island",EnemyLevel=2700},
        {Min=2700,Max=2800,Mon="Grand Devotee",Qdata=2,Qname="SubmergedQuest3",NameMon="Grand Devotee",NPC="Submerged Quest Giver 3",Island="Submerged Island",EnemyLevel=2725},
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

    -- Current semantic sea catalog (Update 30 baseline, 2026-09-09).
    -- Presentation consumes descriptor availability; coordinates remain in the
    -- existing topology registries so one source does not duplicate another.
    SeaCatalog = {
        [1]={LevelMin=1,LevelMax=700,Islands={"Pirate Starter Island","Marine Starter Island","Middle Town","Jungle","Pirate Village","Desert","Frozen Village","Marine Fortress","Skylands","Prison","Colosseum","Magma Village","Underwater City","Upper Skylands","Fountain City"}},
        [2]={LevelMin=700,LevelMax=1500,Islands={"Kingdom of Rose","Green Zone","Graveyard","Snow Mountain","Hot and Cold","Cursed Ship","Ice Castle","Forgotten Island","Remote Island","Cave Island","Dark Arena","Indra Island"}},
        [3]={LevelMin=1500,LevelMax=3000,RegularQuestMax=2800,Islands={"Port Town","Hydra Island","Great Tree","Floating Turtle","Haunted Castle","Sea of Treats","Tiki Outpost","Submerged Island","Castle on the Sea","Treasure Island","Kitsune Island","Mirage Island","Frozen Dimension","Prehistoric Island"}},
    },

    -- Stable domain/group availability used by Core descriptor resolution.
    -- This is intentionally data-owned; ui.lua never hardcodes Sea visibility.
    GroupSeaRules = {
        ["Farm/farming.cake"]={3}, ["Farm/farming.bone"]={3}, ["Farm/farm.elite.hunter"]={3}, ["Farm/tyrant.of.the.skies"]={3},
        ["Farm/unlocked.dungeon"]={3},
        ["Sea/mystic.island.full.moon"]={3}, ["Sea/skull.guitars.misc"]={3},
        ["Quest/tushita.and.yama"]={3}, ["Quest/cursed.dual.katana"]={3}, ["Quest/true.triple.katana.sword"]={2}, ["Quest/items.law.order.sword"]={2},
        ["Quest/progress.first_sea_obtainables"]={1}, ["Quest/rengoku.sword"]={2}, ["Quest/cavender.twin.hooks.bigmom"]={3}, ["Quest/dark.dragger.valkyrie"]={3},
        ["Race/upgrade.races.v3"]={2}, ["Race/trials.quest.v4"]={3}, ["Race/dojo.quest.drago.race"]={3}, ["Race/drago.trial"]={3},
        ["Raid/dungeon.event.raiding"]={2,3}, ["Raid/unlocked.dungeon"]={2,3}, ["Raid/raiding.menu"]={2,3}, ["Raid/law.raid"]={2},
        ["Events/volcanic.magnet"]={3}, ["Events/prehistoric.island"]={3}, ["Events/kitsune.island.event"]={3}, ["Events/sea.event.setting.sail"]={2,3}, ["Events/entity.sea.event"]={2,3},
        ["Items/items.ectoplasm_shop"]={2}, ["Items/items.accessory_sea_event"]={3}, ["Items/items.fragments_shop"]={2}, ["Items/weapon.world.1"]={1}, ["Items/weapon.world.2"]={2}, ["Items/weapon.world.3"]={3},
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
		Electric={Id="electric",Name="Electric",Internal="Electro",FirstObtainableSea=1,Seas={1,2,3},Price=500000,Currency="Beli",NPC="Mad Scientist",Locations={"Skylands · Lower","Hot and Cold","Castle on the Sea"},Remote="BuyElectro",AutoAcquireVerified=false,Update30Quest={Sea=1,Material="Lightning Bolt",Location="Skylands · Lower"}},
		WaterKungFu={Id="water_kung_fu",Name="Water Kung Fu",Internal="Fishman Karate",FirstObtainableSea=1,Seas={1,2,3},Price=750000,Currency="Beli",NPC="Water Kung-fu Teacher",Locations={"Underwater City","Hot and Cold","Castle on the Sea"},Remote="BuyFishmanKarate",AutoAcquireVerified=false,Update30Quest={Sea=1,Secret="Scattered Light",Location="Underwater City"}},
	},

	-- Runtime/internal enemy names observed after the game update. This is the
	-- shared non-boss alias source consumed by target selection and spawn resolution.
    RuntimeEnemyAliases = {
        ["Dangerous Prisoner"]={"Dangerous Prisoner"},
        ["Ruthless Prisoner"]={"Ruthless Prisoner"},
        ["Hydra Enforcer"]={"Hydra Enforcer","Female Islander"},
        ["Venomous Assailant"]={"Venomous Assailant","Giant Islander"},
        ["Orbitus"]={"Orbitus","Fajita"},
    },

	BossCatalog = {
        ["The Gorilla King"]={Id="gorilla_king",Seas={1},Level=25,Location="Jungle",Aliases={"The Gorilla King"}},
        ["Chef"]={Id="chef",Seas={1},Level=55,Location="Pirate Village",Aliases={"Chef"}},
        ["The Saw"]={Id="the_saw",Seas={1},Level=100,Location="Middle Town",SpawnSeconds=4500,DespawnSeconds=900,Aliases={"The Saw","Saw"},Drops={{Name="Shark Saw",Chance="Unknown"}},MinimumDamageShare=0.10},
        ["Yeti"]={Id="yeti",Seas={1},Level=110,Location="Frozen Village",Aliases={"Yeti"}},
        ["Mob Leader"]={Id="mob_leader",Seas={1},Level=120,Location="Jean-Luc Island",Aliases={"Mob Leader","Mob Boss"},QuestChain="Saber Puzzle"},
        ["Vice Admiral"]={Id="vice_admiral",Seas={1},Level=130,QuestLevel=130,Location="Marine Fortress",Aliases={"Vice Admiral"},Drops={{Name="Coat",Chance=0.05}}},
        ["Saber Expert"]={Id="saber_expert",Seas={1},Level=200,Location="Jungle",Aliases={"Saber Expert"},Drops={{Name="Saber",Chance=1}},QuestChain="Saber Puzzle"},
        ["Warden"]={Id="warden",Seas={1},Level=230,QuestLevel=230,Location="Prison",SpawnSeconds=420,Aliases={"Warden"},Drops={{Name="Wardens Sword"}}},
        ["Magma General"]={Id="magma_general",Seas={1},Level=350,QuestLevel=350,Location="Magma Village",Aliases={"Magma General","Magma Admiral"},Drops={{Name="Magma Blaster",Chance="Low/unknown"}}},
        ["Fishman Lord"]={Id="fishman_lord",Seas={1},Level=425,QuestLevel=425,Location="Underwater City",SpawnSeconds=480,Aliases={"Fishman Lord"},Phases=2,Drops={{Name="Trident",Chance=0.10}}},
        ["Sky Warlord"]={Id="sky_warlord",Seas={1},Level=500,QuestLevel=500,Location="Skylands · Upper",SpawnSeconds=600,Aliases={"Sky Warlord","Wysper"},Drops={{Name="Bazooka",Chance=0.05}}},
        ["Lightning God"]={Id="lightning_god",Seas={1},Level=575,QuestLevel=575,Location="Skylands · Upper",SpawnSeconds=600,Aliases={"Lightning God","Thunder God"},Drops={{Name="Pole (1st Form)",Chance=0.06}}},
        ["Cyborg"]={Id="cyborg",Seas={1},Level=675,QuestLevel=675,Location="Fountain City",SpawnSeconds=720,Aliases={"Cyborg"},Drops={{Name="Cool Shades",Chance="1-2%"}}},
        ["Ice Admiral"]={Id="ice_admiral",Seas={1},Level=700,Location="Frozen Village",Aliases={"Ice Admiral"},QuestChain="Second Sea Access"},
        ["Greybeard"]={Id="greybeard",Seas={1},Level=750,HP=303750,Location="Marine Fortress",Aliases={"Greybeard"},RaidBoss=true,Upgrade="Bisento V1 -> V2",MinimumDamageShare=0.10},
    },

	ProgressionCatalog = {
		PoleV1 = {Id="pole_v1",Name="Pole (1st Form)",Seas={1},Category="Sword",Boss="Lightning God",Ownership="Pole V1",FarmFeature="Auto Get Pole V1",Requirements={"Defeat Lightning God"}},
		PoleV2 = {Id="pole_v2",Name="Pole (2nd Form)",Seas={2,3},Category="Sword",Ownership="Pole V2",FarmFeature="Auto Pole V2",Requirements={"Own Pole (1st Form)","Hold Pole (1st Form) in Rough Sea","Be struck by natural Rough Sea lightning"},Note="Current method; no Rumble awakening, mastery 180 or Fragment payment."},
		BisentoV2 = {Id="bisento_v2",Name="Bisento V2",Seas={1},Category="Sword",Boss="Greybeard",Ownership="Bisento V2",FarmFeature="Auto Bisento V2",MinimumDamageShare=0.10,Requirements={"Own Bisento V1","Deal at least 10% of Greybeard's max HP","Defeat Greybeard"},Note="Bisento only needs to be owned; it does not need to be equipped during the Greybeard fight."},
		SharkSaw = {Id="shark_saw",Name="Shark Saw",Seas={1},Category="Sword",Boss="The Saw",Ownership="Shark Saw",FarmFeature="Auto Get Shark Saw",Requirements={"Defeat The Saw","Meet boss reward damage requirement"}},
		Saber = {Id="saber",Name="Saber",Seas={1},Category="Sword",Boss="Saber Expert",Ownership="Saber",FarmFeature="Auto Get Saber",Requirements={"Level 200+","Complete Saber Puzzle","Defeat Saber Expert"}},
		WardensSword = {Id="wardens_sword",Name="Wardens Sword",Seas={1},Category="Sword",Boss="Warden",Ownership="Wardens Sword",FarmFeature="Auto Get Wardens Sword",Requirements={"Defeat Warden"}},
		Coat = {Id="coat",Name="Coat",Seas={1},Category="Accessory",Boss="Vice Admiral",Ownership="Coat",FarmFeature="Auto Get Coat",Requirements={"Defeat Vice Admiral"}},
		PinkCoat = {Id="pink_coat",Name="Pink Coat",Seas={1},Category="Accessory",Ownership="Pink Coat",Acquisition="Island Secret",Requirements={"Complete the Prison Mysterious Key island secret"},Note="Update 30 removed Swan; no automatic secret interaction is exposed until its live contract is verified."},
		MagmaBlaster = {Id="magma_blaster",Name="Magma Blaster",Aliases={"Refined Musket"},Seas={1},Category="Gun",Boss="Magma General",Ownership="Magma Blaster",FarmFeature="Auto Get Magma Blaster",Requirements={"Defeat Magma General"}},
		Trident = {Id="trident",Name="Trident",Seas={1},Category="Sword",Boss="Fishman Lord",Ownership="Trident",FarmFeature="Auto Get Trident",Requirements={"Defeat both Fishman Lord phases"}},
		Bazooka = {Id="bazooka",Name="Bazooka",Seas={1},Category="Gun",Boss="Sky Warlord",Ownership="Bazooka",FarmFeature="Auto Get Bazooka",Requirements={"Defeat Sky Warlord"}},
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
		ThirdSeaAccess = {
			Id="third_sea_access",Name="Third Sea Access",Seas={2},Category="Quest",FarmFeature="Auto Quest Sea 3",TrevorFruitValueRequired=1000000,
			Remotes={Bartilo="BartiloQuestProgress",Trevor="TalkTrevor",Progress="ZQuestProgress",Check="Check",General="General",Begin="Begin",Travel="TravelZou"},
			Requirements={"Level 1500+","Complete Bartilo/Colosseum quest","Unlock Don Swan through Trevor","Defeat Don Swan","Complete King Red Head/rip_indra progression","Travel to Third Sea"},
		},
	},

	ItemCatalog = {
		["Buy Buso"]={Name="Aura",Type="Ability",Seas={1},Price="25,000",Currency="Beli",Requirement="None",NPC="Ability Teacher",Source="Ability Teacher · Frozen Village / Magma Village",Note="Permanent Aura unlock."},
		["Buy Geppo"]={Name="Air Jump",Type="Ability",Seas={1},Price="10,000",Currency="Beli",Requirement="None",NPC="Ability Teacher",Source="Ability Teacher · Frozen Village / Magma Village",Note="Permanent Air Jump unlock."},
		["Buy Soru"]={Name="Flash Step",Type="Ability",Seas={1},Price="100,000",Currency="Beli",Requirement="None",NPC="Ability Teacher",Source="Ability Teacher · Frozen Village / Magma Village",Note="Permanent Flash Step unlock."},
		["Buy Ken"]={Name="Instinct",Type="Ability",Seas={1},Price="750,000",Currency="Beli",MinLevel=300,RequiredOwnership={"Saber"},Requirement="Level 300 + Saber Puzzle",NPC="Instinct Teacher",Source="Instinct Teacher · Skylands · Upper",Note="Requires Saber Puzzle completion."},
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
		["Auto Get Wardens Sword"]={Name="Wardens Sword",Type="Sword",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Warden",NPC="Warden",Source="Prison",Note="Update 30 removed Chief Warden; current Warden is the verified drop source."},
		["Auto Get Coat"]={Name="Coat",Type="Accessory",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Vice Admiral",NPC="Vice Admiral",Source="Marine Fortress",Note="5% boss drop."},
		["Auto Get Magma Blaster"]={Name="Magma Blaster",Type="Gun",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Magma General",NPC="Magma General",Source="Magma Village",Note="Magma Admiral is retained only as a resolver alias for compatibility."},
		["Auto Get Trident"]={Name="Trident",Type="Sword",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Fishman Lord (2 phases)",NPC="Fishman Lord",Source="Underwater City",Note="Boss phase transition is handled by the shared boss tracker."},
		["Auto Get Bazooka"]={Name="Bazooka",Type="Gun",Seas={1},Price="Drop",Currency="Boss",Requirement="Defeat Sky Warlord",NPC="Sky Warlord",Source="Skylands · Upper",Note="Boss drop."},
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

RE4Data.ItemAliases = {
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

RE4Data.OneTimeRules = {
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

RE4Data.EquipmentOwnershipKeys = {
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

-- Shared Fighting Style source for Progress, Items, ownership and dealer actions.
local RE4FeatureMetadata = RE4Data.FeatureMetadata or {}
local RE4BasicStyleCatalog = RE4FeatureMetadata.FightingStyleCatalog or {}
local function RE4DealerLocations(list)
  local out={}
  for sea,location in ipairs(list or {}) do out[sea]=location end
  return out
end
local function RE4BuildBasicStyleMeta(key)
  local source=RE4BasicStyleCatalog[key]
  if type(source)~="table" then
    error("[RE4 HUB/Data] FightingStyleCatalog missing entry: "..tostring(key),0)
  end
  local style=tostring(source.Internal or "")
  local display=tostring(source.Name or "")
  local remote=tostring(source.Remote or "")
  local seas=source.Seas
  if style=="" or display=="" or remote=="" or type(seas)~="table" or #seas==0 then
    error("[RE4 HUB/Data] invalid FightingStyleCatalog entry: "..tostring(key),0)
  end
  return {
    CatalogKey=key,Style=style,Display=display,Seas=seas,
    CostBeli=source.Currency=="Beli" and source.Price or nil,CostFragments=source.Currency=="Fragments" and source.Price or nil,
    Remote=remote,ActionArgs={},OwnershipProbe={Remote=remote,Args={true},PositiveOnly=true},EquipDirect=true,DealerFallback=true,AcquireMode="dealer",
    NPC=source.NPC and {source.NPC} or {},DealerLocations=RE4DealerLocations(source.Locations),Requirements=source.Requirements or {},
    Update30Quest=source.Update30Quest,AutoAcquireVerified=source.AutoAcquireVerified,
    DisplayRequirements={},
  }
end

RE4Data.FightingStyleRegistry = {
  DarkStep=RE4BuildBasicStyleMeta("DarkStep"),
  Electric=RE4BuildBasicStyleMeta("Electric"),
  WaterKungFu=RE4BuildBasicStyleMeta("WaterKungFu"),
  DragonBreath={
    CatalogKey="DragonBreath",Style="Dragon Breath",Display="Dragon Breath",Seas={2,3},CostFragments=1500,
    Remote="BlackbeardReward",OwnershipProbe={Args={"DragonClaw","1"},PositiveOnly=true},ActionArgs={"DragonClaw","2"},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
    NPC={"Sabi"},DealerLocations={[2]="Kingdom of Rose · Café",[3]="Castle on the Sea"},
    Requirements={{Kind="Access"}},
    DisplayRequirements={{Key="fighting_style.req.access_second_sea"}},
  },
  Superhuman={
    CatalogKey="Superhuman",Style="Superhuman",Display="Superhuman",Seas={2,3},CostBeli=3000000,
    Remote="BuySuperhuman",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
    NPC={"Martial Arts Master"},DealerLocations={[2]="Snow Mountain",[3]="Castle on the Sea"},
    Requirements={{Kind="Mastery",Style="DarkStep",Target=300},{Kind="Mastery",Style="Electric",Target=300},{Kind="Mastery",Style="WaterKungFu",Target=300},{Kind="Mastery",Style="DragonBreath",Target=300}},
    DisplayRequirements={
      {Key="fighting_style.req.dark_step_300"},
      {Key="fighting_style.req.electric_300"},
      {Key="fighting_style.req.water_kung_fu_300"},
      {Key="fighting_style.req.dragon_breath_300"},
    },
  },
  DeathStep={
    CatalogKey="DeathStep",Style="Death Step",Display="Death Step",Seas={2,3},CostBeli=2500000,CostFragments=5000,
    Remote="BuyDeathStep",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
    NPC={"Phoeyu, the Reformed","Phoeyu"},DealerLocations={[2]="Ice Castle",[3]="Castle on the Sea"},
    Requirements={{Kind="Mastery",Style="DarkStep",Target=400},{Kind="Item",Name="Library Key"},{Kind="Library"}},
    DisplayRequirements={
      {Key="fighting_style.req.dark_step_400"},
      {Key="fighting_style.req.library_key"},
      {Key="fighting_style.req.library_key_drop",RequirementIndex=2},
      {Key="fighting_style.req.library_open",RequirementIndex=3},
    },
  },
  ElectricClaw={
    CatalogKey="ElectricClaw",Style="Electric Claw",Display="Electric Claw",Seas={3},CostBeli=3000000,CostFragments=5000,
    Remote="BuyElectricClaw",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
    NPC={"Previous Hero"},DealerLocations={[3]="Floating Turtle"},
    Requirements={{Kind="Mastery",Style="Electric",Target=400},{Kind="Quest"}},
    DisplayRequirements={
      {Key="fighting_style.req.electric_400"},
      {Key="fighting_style.req.previous_hero"},
      {Key="fighting_style.req.previous_hero_route",RequirementIndex=2},
    },
  },
  Sharkman={
    CatalogKey="Sharkman",Style="Sharkman Karate",Display="Sharkman Karate",Seas={2,3},CostBeli=2500000,CostFragments=5000,
    Remote="BuySharkmanKarate",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
    NPC={"Sharkman Teacher","Daigrock, the Sharkman","Daigrock"},DealerLocations={[2]="Forgotten Island",[3]="Castle on the Sea"},
    Requirements={{Kind="Mastery",Style="WaterKungFu",Target=400},{Kind="Item",Name="Water Key"},{Kind="Dealer"}},
    DisplayRequirements={
      {Key="fighting_style.req.water_kung_fu_400"},
      {Key="fighting_style.req.water_key"},
      {Key="fighting_style.req.water_key_drop",RequirementIndex=2},
      {Key="fighting_style.req.water_key_give",RequirementIndex=3},
    },
  },
  DragonTalon={
    CatalogKey="DragonTalon",Style="Dragon Talon",Display="Dragon Talon",Seas={3},CostBeli=3000000,CostFragments=5000,
    Remote="BuyDragonTalon",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
    NPC={"Uzoth"},DealerLocations={[3]="Hydra Island"},
    Requirements={{Kind="Mastery",Style="DragonBreath",Target=400},{Kind="Item",Name="Fire Essence"},{Kind="Dealer"}},
    DisplayRequirements={
      {Key="fighting_style.req.dragon_breath_400"},
      {Key="fighting_style.req.fire_essence"},
      {Key="fighting_style.req.fire_essence_source",RequirementIndex=2},
      {Key="fighting_style.req.fire_essence_give",RequirementIndex=3},
    },
  },
  Godhuman={
    CatalogKey="Godhuman",Style="Godhuman",Display="Godhuman",Seas={3},CostBeli=5000000,CostFragments=5000,
    Remote="BuyGodhuman",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
    NPC={"Ancient Monk"},DealerLocations={[3]="Floating Turtle"},
    Requirements={{Kind="Mastery",Style="Superhuman",Target=400},{Kind="Mastery",Style="DeathStep",Target=400},{Kind="Mastery",Style="ElectricClaw",Target=400},{Kind="Mastery",Style="Sharkman",Target=400},{Kind="Mastery",Style="DragonTalon",Target=400},{Kind="Material",Name="Dragon Scale",Target=10},{Kind="Material",Name="Fish Tail",Target=20},{Kind="Material",Name="Mystic Droplet",Target=10},{Kind="Material",Name="Magma Ore",Target=20}},
    DisplayRequirements={
      {Key="fighting_style.req.superhuman_400"},
      {Key="fighting_style.req.death_step_400"},
      {Key="fighting_style.req.electric_claw_400"},
      {Key="fighting_style.req.sharkman_400"},
      {Key="fighting_style.req.dragon_talon_400"},
      {Key="fighting_style.req.dragon_scales_10"},
      {Key="fighting_style.req.fish_tails_20"},
      {Key="fighting_style.req.mystic_droplets_10"},
      {Key="fighting_style.req.magma_ore_20"},
    },
  },
  Sanguine={
    CatalogKey="Sanguine",Style="Sanguine Art",Display="Sanguine Art",Seas={3},CostBeli=5000000,CostFragments=5000,
    Remote="BuySanguineArt",OwnershipProbe={Args={true},PositiveOnly=true},ActionArgs={},EquipDirect=true,DealerFallback=true,AcquireMode="direct",
    NPC={"Shafi"},DealerLocations={[3]="Tiki Outpost"},
    Requirements={{Kind="Item",Name="Leviathan Heart"},{Kind="Material",Name="Dark Fragment",Target=2},{Kind="Material",Name="Demonic Wisp",Target=20},{Kind="Material",Name="Vampire Fang",Target=20}},
    DisplayRequirements={
      {Key="fighting_style.req.leviathan_heart"},
      {Key="fighting_style.req.dark_fragments_2"},
      {Key="fighting_style.req.demonic_wisps_20"},
      {Key="fighting_style.req.vampire_fangs_20"},
    },
  },
}
RE4Data.BossAliases = {
    ["Cake Prince"]={"Cake Prince"}, ["Dough King"]={"Dough King"},
    ["Tyrant of the Skies"]={"Tyrant of the Skies"},
    ["Diablo"]={"Diablo"}, ["Deandre"]={"Deandre"}, ["Urban"]={"Urban"},
    ["rip_indra"]={"rip_indra","rip indra","rip_indra True Form"},
    ["Don Swan"]={"Don Swan"}, ["Awakened Ice Admiral"]={"Awakened Ice Admiral"},
    ["Darkbeard"]={"Darkbeard"}, ["Cursed Captain"]={"Cursed Captain"}, ["Order"]={"Order"},
    ["Soul Reaper"]={"Soul Reaper"}, ["Longma"]={"Longma"}, ["Cake Queen"]={"Cake Queen"},
  }
for canonical,meta in pairs(RE4Data.FeatureMetadata.BossCatalog or {}) do
  local aliases={canonical}; local seen={[canonical]=true}
  for _,alias in ipairs(type(meta)=="table" and meta.Aliases or {}) do if not seen[alias] then seen[alias]=true; aliases[#aliases+1]=alias end end
  RE4Data.BossAliases[canonical]=aliases
end

-- One canonical enemy-name resolver for every combat/farm consumer. Boss aliases
-- and non-boss runtime aliases are merged here so features never keep local maps.
RE4Data.EnemyAliases = {}
RE4Data.EnemyAliasToCanonical = {}
local function RE4RegisterEnemyAliases(canonical,aliases)
  local list,seen={canonical},{[canonical]=true}
  for _,alias in ipairs(type(aliases)=="table" and aliases or {}) do
    alias=tostring(alias or "")
    if alias~="" and not seen[alias] then seen[alias]=true; list[#list+1]=alias end
  end
  RE4Data.EnemyAliases[canonical]=list
  for _,alias in ipairs(list) do RE4Data.EnemyAliasToCanonical[alias]=canonical end
end
for canonical,aliases in pairs(RE4Data.BossAliases or {}) do RE4RegisterEnemyAliases(canonical,aliases) end
for canonical,aliases in pairs(RE4Data.FeatureMetadata.RuntimeEnemyAliases or {}) do RE4RegisterEnemyAliases(canonical,aliases) end

-- Verified cumulative scanner anchors. Runtime objects remain authoritative; these are shared bootstrap/fallback data only.
-- Raid islands are intentionally excluded from this registry.
RE4Data.WorldSpatial = {
  Revision="2.0.45-world-v2",
  MobTargets={
    [1]={
      ["Bandit"]=CFrame.new(1114.26123,11.451765,1590.185425),
      ["Brute"]=CFrame.new(-1312.805054,28.104431,4402.859375),
      ["Chef"]=CFrame.new(-1120.452148,54.707001,4121.157227),
      ["Chief Petty Officer"]=CFrame.new(-4763.676758,13.391308,4288.842773),
      ["Cyborg"]=CFrame.new(6252.391602,9.318767,4941.388672),
      ["Dangerous Prisoner"]=CFrame.new(5271.362305,16.372007,799.60791),
      ["Dark Master"]=CFrame.new(-5206.771973,504.744202,-348.463867),
      ["Desert Bandit"]=CFrame.new(931.705017,7.565002,4564.533203),
      ["Desert Officer"]=CFrame.new(1615.490601,14.248001,4187.38623),
      ["Fishman Commando"]=CFrame.new(62013.03125,24.553377,1329.945068),
      ["Fishman Lord"]=CFrame.new(61352.902344,67.167007,1029.110962),
      ["Fishman Warrior"]=CFrame.new(60736.8125,23.795456,1396.337646),
      ["Galley Captain"]=CFrame.new(5594.933594,78.711441,4751.866699),
      ["Galley Pirate"]=CFrame.new(5670.652832,79.511688,4074.463379),
      ["Gladiator"]=CFrame.new(-1238.913696,11.62256,-3241.158936),
      ["God's Guard"]=CFrame.new(-4364.76416,1090.171753,-383.479156),
      ["Gorilla"]=CFrame.new(-1387.328247,14.466744,-577.800049),
      ["Ice Admiral"]=CFrame.new(1212.383057,20.398001,-1429.639038),
      ["Magma General"]=CFrame.new(-5625.709961,55.443821,8623.011719),
      ["Military Soldier"]=CFrame.new(-5418.478027,18.009012,8421.083984),
      ["Military Spy"]=CFrame.new(-5808.983398,77.313324,8791.204102),
      ["Mob Leader"]=CFrame.new(-2880.716064,6.690224,5430.853027),
      ["Monkey"]=CFrame.new(-1525.555542,27.246964,163.957825),
      ["Pirate"]=CFrame.new(-1122.782715,19.93531,3965.881836),
      ["Prisoner"]=CFrame.new(5278.591309,7.133566,391.556885),
      ["Royal Soldier"]=CFrame.new(-7137.427734,5541.050293,892.987122),
      ["Royal Squad"]=CFrame.new(-6706.870605,5551.413574,1155.430176),
      ["Shanda"]=CFrame.new(-6026.836426,5469.552734,1851.049438),
      ["Sky Bandit"]=CFrame.new(-5014.03418,280.721466,-972.079346),
      ["Snow Bandit"]=CFrame.new(1431.750732,77.960236,-1444.892334),
      ["Snowman"]=CFrame.new(1246.768799,98.329163,-1555.694092),
      ["The Gorilla King"]=CFrame.new(-1193.906616,10.721458,-549.84729),
      ["Lightning God"]=CFrame.new(-7125.414551,5596.062988,111.5187),
      ["Toga Warrior"]=CFrame.new(-1819.480347,9.218998,-2736.564941),
      ["Trainee"]=CFrame.new(-2748.037354,30.316719,2152.703125),
      ["Vice Admiral"]=CFrame.new(-5010.819824,15.061595,4383.727539),
      ["Warden"]=CFrame.new(5623.165527,1.356678,733.808899),
      ["Yeti"]=CFrame.new(1181.661621,104.033043,-1616.931885),
    },
    [2]={
      ["Arctic Warrior"]=CFrame.new(5994.588867,27.559998,-6324.278809),
      ["Awakened Ice Admiral"]=CFrame.new(6551.793945,325.295013,-6989.898926),
      ["Factory Staff"]=CFrame.new(386.109985,72.807999,91.751999),
      ["Horned Warrior"]=CFrame.new(-6331.765137,29.228615,-5778.941895),
      ["Jeremy"]=CFrame.new(2338.001953,451.425995,700.106995),
      ["Lab Subordinate"]=CFrame.new(-5897.821777,81.699837,-4554.624023),
      ["Lava Pirate"]=CFrame.new(-5005.521484,28.023432,-4916.077148),
      ["Magma Ninja"]=CFrame.new(-5811.147949,30.047733,-5576.536621),
      ["Marine Captain"]=CFrame.new(-1805.364014,73.014008,-3313.324951),
      ["Marine Lieutenant"]=CFrame.new(-3012.852051,71.014008,-2921.832031),
      ["Mercenary"]=CFrame.new(-1135.94397,72.876007,1248.327026),
      ["Orbitus"]=CFrame.new(-2138.483887,75.94101,-4326.455078),
      ["Raider"]=CFrame.new(-607.437012,40.007996,2202.435059),
      ["Sea Soldier"]=CFrame.new(-3240.331055,27.453003,-9813.96582),
      ["Ship Deckhand"]=CFrame.new(1176.29895,125.577011,33119.109375),
      ["Ship Engineer"]=CFrame.new(1088.251953,43.693008,32890.09375),
      ["Ship Officer"]=CFrame.new(694.528992,179.906006,33112.632812),
      ["Ship Steward"]=CFrame.new(918.666992,125.834,33506.503906),
      ["Smoke Admiral"]=CFrame.new(-4857.358398,233.677841,-5583.243164),
      ["Snow Lurker"]=CFrame.new(5484.417969,27.559998,-6733.75),
      ["Snow Trooper"]=CFrame.new(484.345001,400.808014,-5472.416016),
      ["Swan Pirate"]=CFrame.new(967.174011,72.968002,1180.755981),
      ["Tide Keeper"]=CFrame.new(-3760.416016,78.337997,-11585.704102),
      ["Vampire"]=CFrame.new(-6132.39502,9.007996,-1466.168945),
      ["Water Fighter"]=CFrame.new(-3331.705078,239.138,-10553.356445),
      ["Winter Warrior"]=CFrame.new(1226.30896,428.808014,-5215.976074),
      ["Zombie"]=CFrame.new(-5766.648926,47.501007,-824.661987),
      ["rip_indra"]=CFrame.new(-26952.289062,21.529007,329.35199),
    },
    [3]={
      ["Baking Staff"]=CFrame.new(-1759.286011,34.665009,-12994.839844),
      ["Beautiful Pirate"]=CFrame.new(5367.313965,26.395004,-64.701004),
      ["Cake Guard"]=CFrame.new(-1418.510986,35.219009,-12255.71875),
      ["Candy Pirate"]=CFrame.new(-1428.152954,36.406998,-14637.896484),
      ["Candy Rebel"]=CFrame.new(47.923004,25.582001,-13029.240234),
      ["Chocolate Bar Battler"]=CFrame.new(717.515015,25.582001,-12557.670898),
      ["Cocoa Warrior"]=CFrame.new(6.332001,26.225006,-12305.208984),
      ["Cookie Crafter"]=CFrame.new(-2342.873047,37.005005,-12009.238281),
      ["Coral Pirate"]=CFrame.new(10733.178711,-2087.297119,9411.109375),
      ["Demonic Soul"]=CFrame.new(-9426.956055,171.953003,6048.408203),
      ["Dragon Crew Archer"]=CFrame.new(6668.762207,481.377014,329.122009),
      ["Dragon Crew Warrior"]=CFrame.new(6919.080078,57.731003,-940.838989),
      ["Fishman Captain"]=CFrame.new(-11107.853516,331.825989,-8842.916016),
      ["Fishman Raider"]=CFrame.new(-10603.644531,332.602997,-8309.125977),
      ["Forest Pirate"]=CFrame.new(-13279.542969,332.226013,-7897.757812),
      ["Ghost"]=CFrame.new(5253.057129,10.304001,393.96701),
      ["Grand Devotee"]=CFrame.new(9608.927734,-1994.397583,9956.375),
      ["Head Baker"]=CFrame.new(-2369.090088,51.009995,-12807.921875),
      ["High Disciple"]=CFrame.new(9778.435547,-1995.088013,9720.9375),
      ["Hydra Enforcer"]=CFrame.new(4547.115234,1003.10199,334.195007),
      ["Ice Cream Chef"]=CFrame.new(-715.434021,64.559006,-10920.435547),
      ["Ice Cream Commander"]=CFrame.new(-657.549988,129.740997,-11215.791992),
      ["Island Boy"]=CFrame.new(-16883.048828,23.347,-250.873993),
      ["Isle Champion"]=CFrame.new(-16787.320312,25.205002,992.132019),
      ["Isle Outlaw"]=CFrame.new(-16289.488281,22.874008,-179.444),
      ["Jungle Pirate"]=CFrame.new(-11902.273438,331.291992,-10432.067383),
      ["Kilo Admiral"]=CFrame.new(2998.294922,508.794006,-7344.321777),
      ["Living Zombie"]=CFrame.new(-10205.101562,151.953003,5861.930176),
      ["Marine Commodore"]=CFrame.new(2577.253906,75.610001,-7739.87207),
      ["Marine Rear Admiral"]=CFrame.new(3920.061035,146.225998,-7175.206055),
      ["Musketeer Pirate"]=CFrame.new(-13270.881836,472.062012,-9860.661133),
      ["Mythological Pirate"]=CFrame.new(-13456.049805,469.433014,-7039.963867),
      ["Ocean Prophet"]=CFrame.new(11003.326172,-2007.025757,10225.0625),
      ["Peanut President"]=CFrame.new(-1996.069946,37.222,-10496.926758),
      ["Peanut Scout"]=CFrame.new(-2065.3479,34.951996,-10066.810547),
      ["Pirate Millionaire"]=CFrame.new(-543.814026,56.692001,5653.969238),
      ["Pistol Billionaire"]=CFrame.new(-666.770996,84.944,6008.337891),
      ["Posessed Mummy"]=CFrame.new(-9609.351562,5.953003,6361.974121),
      ["Reborn Skeleton"]=CFrame.new(-8682.101562,140.953003,5968.930176),
      ["Reef Bandit"]=CFrame.new(10980.532227,-2160.414551,9051.949219),
      ["Sea Chanter"]=CFrame.new(10581.507812,-2071.748779,10020.650391),
      ["Serpent Hunter"]=CFrame.new(-16521.0625,106.093002,1488.785034),
      ["Skull Slayer"]=CFrame.new(-16948.578125,193.132004,1643.613037),
      ["Snow Demon"]=CFrame.new(-936.151978,13.996002,-14552.498047),
      ["Sun-kissed Warrior"]=CFrame.new(-16186.420898,25.104004,1098.083008),
      ["Sweet Thief"]=CFrame.new(88.472,25.582001,-12662.207031),
      ["Training Dummy"]=CFrame.new(3657.079102,11.889008,178.031998),
      ["Venomous Assailant"]=CFrame.new(4637.883789,1078.786011,882.419983),
    },
  },
  RegionTargets={
    [1]={
      ["Colosseum"]=CFrame.new(-1533.140625,12.489322,-2781.293457),
      ["Desert"]=CFrame.new(999.850464,7.565002,4490.331055),
      ["Fountain City"]=CFrame.new(5594.933594,78.711441,4751.866699),
      ["Frozen Village"]=CFrame.new(1246.768799,98.329163,-1555.694092),
      ["Jungle"]=CFrame.new(-1637.554565,29.97735,19.640137),
      ["Magma Village"]=CFrame.new(-5714.918457,76.592033,8834.858398),
      ["Marine Fortress"]=CFrame.new(-4763.676758,13.391308,4288.842773),
      ["Marine Starter Island"]=CFrame.new(-2748.037354,30.316719,2152.703125),
      ["Pirate Starter Island"]=CFrame.new(1114.26123,11.451765,1590.185425),
      ["Pirate Village"]=CFrame.new(-1176.765137,19.742043,4027.27002),
      ["Prison"]=CFrame.new(5271.362305,16.372007,799.60791),
      ["Skylands · Lower"]=CFrame.new(-5157.066406,280.721466,-916.718018),
      ["Skylands · Middle"]=CFrame.new(-4364.76416,1090.171753,-383.479156),
      ["Skylands · Upper"]=CFrame.new(-6690.039551,5551.413574,1318.30542),
      ["Underwater City"]=CFrame.new(60930.921875,23.794806,1393.093506),
    },
    [2]={
      ["Cursed Ship"]=CFrame.new(815.629028,43.693008,33111.339844),
      ["Forgotten Island"]=CFrame.new(-3316.753906,239.138,-10323.168945),
      ["Graveyard"]=CFrame.new(-6039.688965,9.007996,-1099.159058),
      ["Green Zone"]=CFrame.new(-2583.945068,71.014008,-3039.61792),
      ["Hot and Cold"]=CFrame.new(-5790.075684,28.915442,-5393.24707),
      ["Ice Castle"]=CFrame.new(5763.846191,27.559998,-6671.045898),
      ["Kingdom of Rose · Café"]=CFrame.new(-382,73,290),
      ["Kingdom of Rose · Docks"]=CFrame.new(-607.437012,40.007996,2202.435059),
      ["Snow Mountain"]=CFrame.new(642.666016,400.808014,-5454.48877),
    },
    [3]={
      ["Cake Island"]=CFrame.new(-2100.705078,51.009995,-12720.96582),
      ["Candy Island"]=CFrame.new(-1255.79895,33.466995,-14507.09668),
      ["Cocoa Island"]=CFrame.new(143.970001,25.582001,-12531.720703),
      ["Floating Turtle"]=CFrame.new(-11210.268555,331.825989,-9072.711914),
      ["Great Tree"]=CFrame.new(3222.416992,75.610001,-7820.557129),
      ["Haunted Castle"]=CFrame.new(-9426.956055,171.953003,6048.408203),
      ["Hydra Island"]=CFrame.new(4671.688965,1004.333984,-14.567001),
      ["Ice Cream Island"]=CFrame.new(-770.414978,125.611008,-11159.84082),
      ["Peanut Island"]=CFrame.new(-2247.476074,87.322998,-10440.868164),
      ["Port Town"]=CFrame.new(-232.919998,57.042999,5757.833008),
      ["Submerged Island"]=CFrame.new(10680.076172,-2056.674805,9933.889648),
      ["Tiki Outpost"]=CFrame.new(-16787.320312,25.205002,992.132019),
    },
  },
  QuestNPCs={
    [1]={
      ["Adventurer"]={CFrame.new(-1679.763184,48.740005,175.640015)},
      ["Bandit Quest Giver"]={CFrame.new(1051.797852,11.016113,1557.742554)},
      ["Colosseum Quest Giver"]={CFrame.new(-1342.255493,11.151421,-2928.580811)},
      ["Desert Adventurer"]={CFrame.new(931.377991,4.684,4198.212891)},
      ["Freezeburg Quest Giver"]={CFrame.new(5263.487793,74.90799,4087.615723)},
      ["Jail Keeper"]={CFrame.new(5208.339355,15.872004,736.586304)},
      ["King Neptune"]={CFrame.new(61406.195312,24.518736,1626.816406)},
      ["Marine"]={CFrame.new(-4699.331055,4.741011,4227.63916)},
      ["Marine Leader"]={CFrame.new(-2655.28418,30.566717,2113.724365)},
      ["Mole"]={CFrame.new(-5949.067383,5467.939941,2086.515137),CFrame.new(-4882.894043,926.17749,-1031.05481)},
      ["Pirate Adventurer"]={CFrame.new(-1151.58606,13.615271,3863.125)},
      ["Sky Adventurer"]={CFrame.new(-4750.180176,966.066711,-748.241455)},
      ["Sky Quest Giver 2"]={CFrame.new(-7033.100586,5590.574219,1353.106934)},
      ["The Mayor"]={CFrame.new(-5308.867188,17.034981,8482.698242)},
      ["Villager"]={CFrame.new(1400.563843,77.390999,-1311.285034)},
    },
    [2]={
      ["Area 1 Quest Giver"]={CFrame.new(-429.544006,71.770004,1836.182007)},
      ["Area 2 Quest Giver"]={CFrame.new(638.445007,71.770004,918.236023)},
      ["Fire Quest Giver"]={CFrame.new(-5403.368164,28.277618,-5371.700195)},
      ["Forgotten Quest Giver"]={CFrame.new(-3054.445068,238.343994,-10142.819336)},
      ["Front Crew Quest Giver"]={CFrame.new(974.075928,124.938667,33253.621094)},
      ["Frost Quest Giver"]={CFrame.new(5667.658203,26.800003,-6486.089844)},
      ["Graveyard Quest Giver"]={CFrame.new(-5497.062012,47.591995,-795.237)},
      ["Ice Quest Giver"]={CFrame.new(-6231.271973,80.933769,-4851.320801)},
      ["Marine Quest Giver"]={CFrame.new(-2440.795898,71.714005,-3216.068115)},
      ["Rear Crew Quest Giver"]={CFrame.new(1040.55542,121.409012,32909.105469)},
      ["Snow Quest Giver"]={CFrame.new(609.859009,400.119995,-5372.258789)},
    },
    [3]={
      ["Cake Quest Giver 1"]={CFrame.new(-2022.29895,36.928009,-12030.976562)},
      ["Cake Quest Giver 2"]={CFrame.new(-1928.317993,37.729996,-12840.625977)},
      ["Candy Cane Quest Giver"]={CFrame.new(-1164.498047,59.268997,-14492.618164)},
      ["Chocolate Quest Giver 2"]={CFrame.new(151.197998,23.891006,-12774.617188)},
      ["Deep Forest Area 2 Quest Giver"]={CFrame.new(-12680.381836,389.971008,-9902.019531)},
      ["Deep Forest Quest Giver"]={CFrame.new(-13234.040039,331.488007,-7625.400879)},
      ["Dragon Crew Quest Giver"]={CFrame.new(6735.11084,126.990005,-711.098022)},
      ["Haunted Castle Quest Giver 1"]={CFrame.new(-9479.216797,141.214996,5566.092773)},
      ["Haunted Castle Quest Giver 2"]={CFrame.new(-9516.993164,172.016998,6078.464844)},
      ["Ice Cream Quest Giver"]={CFrame.new(-819.377014,64.92601,-10967.283203)},
      ["Peanut Quest Giver"]={CFrame.new(-2105.531982,37.25,-10195.508789)},
      ["Pirate Port Quest Giver"]={CFrame.new(-450.105011,107.681,5950.726074)},
      ["Submerged Quest Giver 1"]={CFrame.new(10780.639648,-2088.414062,9260.453125)},
      ["Submerged Quest Giver 2"]={CFrame.new(10883.598633,-2086.888916,10034.019531)},
      ["Tiki Quest Giver 1"]={CFrame.new(-16548.816406,55.606003,-172.811996)},
      ["Tiki Quest Giver 2"]={CFrame.new(-16541.021484,54.770996,1051.46106)},
      ["Tiki Quest Giver 3"]={CFrame.new(-16665.191406,104.596008,1579.69397)},
      ["Turtle Adventure Quest Giver"]={CFrame.new(-10581.65625,330.872986,-8761.186523)},
    },
  },
}
-- Curated from Cr4's Farm All Island data, but consumed by Re4's shared
-- FeatureRuntime/Target/Movement/Combat pipeline (no per-island worker loops).
RE4Data.FarmIslands = {
  [1] = {
    {Name="Pirates",Island="Pirate Starter Island",Mobs={"Bandit"}},
    {Name="Marine",Island="Marine Starter Island",Mobs={"Trainee"}},
    {Name="Jungle",Island="Jungle",Mobs={"Monkey","Gorilla"}},
    {Name="Pirate Village",Island="Pirate Village",Mobs={"Pirate","Brute"}},
    {Name="Desert",Island="Desert",Mobs={"Desert Bandit","Desert Officer"}},
    {Name="Frozen Village",Island="Frozen Village",Mobs={"Snow Bandit","Snowman"}},
    {Name="Marine Fortress",Island="Marine Fortress",Mobs={"Chief Petty Officer"}},
    {Name="Skylands Lower",Island="Skylands · Lower",Mobs={"Sky Bandit","Dark Master"}},
    {Name="Skylands Middle",Island="Skylands · Middle",Mobs={"God's Guard"}},
    {Name="Prison",Island="Prison",Mobs={"Prisoner","Dangerous Prisoner"}},
    {Name="Colosseum",Island="Colosseum",Mobs={"Toga Warrior","Gladiator"}},
    {Name="Magma Village",Island="Magma Village",Mobs={"Military Soldier","Military Spy"}},
    {Name="Underwater City",Island="Underwater City",Mobs={"Fishman Warrior","Fishman Commando"}},
    {Name="Skylands Upper",Island="Skylands · Upper",Mobs={"Shanda","Royal Squad","Royal Soldier"}},
    {Name="Fountain City",Island="Fountain City",Mobs={"Galley Pirate","Galley Captain"}},
  },
  [2] = {
    {Name="Kingdom of Rose · Docks",Island="Kingdom of Rose · Docks",Mobs={"Raider","Mercenary"}},
    {Name="Kingdom of Rose · Café",Island="Kingdom of Rose · Café",Mobs={"Swan Pirate","Factory Staff"}},
    {Name="Green Zone",Island="Green Zone",Mobs={"Marine Lieutenant","Marine Captain"}},
    {Name="Graveyard Island",Island="Graveyard",Mobs={"Zombie","Vampire"}},
    {Name="Snow Mountain",Island="Snow Mountain",Mobs={"Snow Trooper","Winter Warrior"}},
    {Name="Hot and Cold · Cold",Island="Hot and Cold",Mobs={"Lab Subordinate","Horned Warrior"}},
    {Name="Hot and Cold · Hot",Island="Hot and Cold",Mobs={"Magma Ninja","Lava Pirate"}},
    {Name="Cursed Ship",Island="Cursed Ship",Mobs={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}},
    {Name="Ice Castle",Island="Ice Castle",Mobs={"Arctic Warrior","Snow Lurker"}},
    {Name="Forgotten Island",Island="Forgotten Island",Mobs={"Sea Soldier","Water Fighter"}},
  },
  [3] = {
    {Name="Port Town",Island="Port Town",Mobs={"Pirate Millionaire","Pistol Billionaire"}},
    {Name="Hydra Island",Island="Hydra Island",Mobs={"Dragon Crew Warrior","Dragon Crew Archer","Hydra Enforcer","Venomous Assailant"}},
    {Name="Great Tree",Island="Great Tree",Mobs={"Marine Commodore","Marine Rear Admiral"}},
    {Name="Floating Turtle",Island="Floating Turtle",Mobs={"Forest Pirate","Mythological Pirate","Jungle Pirate","Musketeer Pirate","Fishman Raider","Fishman Captain"}},
    {Name="Haunted Castle",Island="Haunted Castle",Mobs={"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}},
    {Name="Peanut Island",Island="Peanut Island",Mobs={"Peanut Scout","Peanut President"}},
    {Name="Ice Cream Island",Island="Ice Cream Island",Mobs={"Ice Cream Chef","Ice Cream Commander"}},
    {Name="Cake Island",Island="Cake Island",Mobs={"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"}},
    {Name="Cocoa Island",Island="Cocoa Island",Mobs={"Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel"}},
    {Name="Candy Island",Island="Candy Island",Mobs={"Candy Pirate","Snow Demon"}},
    {Name="Tiki Outpost",Island="Tiki Outpost",Mobs={"Isle Outlaw","Island Boy","Sun-kissed Warrior","Isle Champion","Serpent Hunter","Skull Slayer"}},
    {Name="Submerged Island",Island="Submerged Island",Mobs={"Reef Bandit","Coral Pirate","Sea Chanter","Ocean Prophet","High Disciple","Grand Devotee"}},
  },
}

RE4Data.MasterySpots = {
  Cake={Island="Cake Island",Mobs={"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"}},
  Bone={Island="Haunted Castle",Mobs={"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}},
}

RE4Data.Assets = { DevilFruitRain = "rbxassetid://14759368201" }

RE4Data.RedeemCodes = {
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
	UnderwaterCity = {Key="UnderwaterCity",BypassAllowed=false,Sea=1},
	CursedShip = {
	  Key="CursedShip", BypassAllowed=false, Sea=2,
	  TargetDetector={Center=Vector3.new(923.21252441406,126.9760055542,32852.83203125),Radius3D=6500},
	  CurrentDetector={Center=Vector3.new(923.21252441406,126.9760055542,32852.83203125),Radius3D=7500},
	  Entrance={Mode="Portal",PortalKey="CursedShip"},
	  Exit={Mode="Portal",PortalKey="SecondSeaMainland"},
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
        ApproachIsland="Great Tree",
        ApproachRegion="World",
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
	  SpawnIds={"SubmergedIsland"},
	  Entrance={
		Mode="NPCRemote",
		Name="Submarine Worker",
		Approach=CFrame.new(-16269.1016,29.5177539,1372.3204),
		Remote="RF/SubmarineWorkerSpeak",
		Command="TravelToSubmergedIsland",
        ApproachIsland="Tiki Outpost",
        ApproachRegion="World",
		Requires="Defeat Tyrant of the Skies",
	  },
	  Exit={Mode="Resurface",TargetY=650},
	},
  }
  local function RE4CanonicalWorldTarget(sea,name)
    local bySea=RE4Data.WorldSpatial and RE4Data.WorldSpatial.RegionTargets and RE4Data.WorldSpatial.RegionTargets[sea]
    local target=type(bySea)=="table" and bySea[name] or nil
    if typeof(target)~="CFrame" then error("[RE4 HUB/Data] missing canonical world target: "..tostring(sea)..":"..tostring(name)) end
    return target
  end
  T.Islands = {
	[1] = {
      {Name="Pirate Starter Island",Target=RE4CanonicalWorldTarget(1,"Pirate Starter Island")},
      {Name="Marine Starter Island",Target=RE4CanonicalWorldTarget(1,"Marine Starter Island")},
      {Name="Middle Town",Target=CFrame.new(-838.894653320312,28.3712882995605,1603.0986328125,-0.965929746627808,0,-0.258804798126221,0,1,0,0.258804798126221,0,-0.965929746627808)},
      {Name="Jungle",Target=RE4CanonicalWorldTarget(1,"Jungle")},
      {Name="Pirate Village",Target=RE4CanonicalWorldTarget(1,"Pirate Village")},
      {Name="Desert",Target=RE4CanonicalWorldTarget(1,"Desert")},
      {Name="Frozen Village",Target=RE4CanonicalWorldTarget(1,"Frozen Village")},
      {Name="Marine Fortress",Target=RE4CanonicalWorldTarget(1,"Marine Fortress")},
      {Name="Colosseum",Target=RE4CanonicalWorldTarget(1,"Colosseum")},
      {Name="Skylands · Lower",Target=RE4CanonicalWorldTarget(1,"Skylands · Lower"),MovementZone="SkyLower",BypassAllowed=true,TransportPolicy="NativePortalPreferred",AllowBypassAcrossPortalBoundary=true,DisableFastTravel=false},
      {Name="Skylands · Middle",Target=RE4CanonicalWorldTarget(1,"Skylands · Middle"),MovementZone="SkyLower",BypassAllowed=true,TransportPolicy="NativePortalPreferred",AllowBypassAcrossPortalBoundary=true,DisableFastTravel=false},
      {Name="Skylands · Upper",Target=RE4CanonicalWorldTarget(1,"Skylands · Upper"),MovementZone="SkyUpper",BypassAllowed=true,TransportPolicy="NativePortalPreferred",AllowBypassAcrossPortalBoundary=true,DisableFastTravel=false},
      {Name="Prison",Target=RE4CanonicalWorldTarget(1,"Prison")},
      {Name="Jean-Luc Island",Target=CFrame.new(-2880.716064453125,6.6902241706848145,5430.85302734375)},
      {Name="Magma Village",Target=RE4CanonicalWorldTarget(1,"Magma Village")},
      {Name="Underwater City",Target=CFrame.new(61406.1953125,24.5187358856201,1626.81640625,-0.874882340431213,2.15906948142219e-05,0.484336316585541,-2.15906948142219e-05,1,-8.35783139336854e-05,-0.484336316585541,-8.35783139336854e-05,-0.874882340431213),Region="UnderwaterCity",BypassAllowed=false},
      {Name="Fountain City",Target=RE4CanonicalWorldTarget(1,"Fountain City")},
    },
    [2] = {
	  {Name="Kingdom of Rose · Café",Target=RE4CanonicalWorldTarget(2,"Kingdom of Rose · Café"),RuntimeNPC="Barista"},
	  {Name="Kingdom of Rose · Docks",Target=RE4CanonicalWorldTarget(2,"Kingdom of Rose · Docks")},
	  {Name="Dark Arena",Target=CFrame.new(3780.0302734375,22.652164459229,-3498.5859375)},
	  {Name="Don Swan Mansion",Target=CFrame.new(-483.73370361328,332.0383605957,595.32708740234)},
	  {Name="Don Swan Room",Target=CFrame.new(2284.4140625,15.152037620544,875.72534179688)},
	  {Name="Green Zone",Target=RE4CanonicalWorldTarget(2,"Green Zone")},
	  {Name="Factory",Target=CFrame.new(424.12698364258,211.16171264648,-427.54049682617)},
	  {Name="Colosseum",Target=CFrame.new(-1503.6224365234,219.7956237793,1369.3101806641)},
	  {Name="Graveyard",Target=RE4CanonicalWorldTarget(2,"Graveyard")},
	  {Name="Snow Mountain",Target=RE4CanonicalWorldTarget(2,"Snow Mountain")},
	  {Name="Hot and Cold",Target=RE4CanonicalWorldTarget(2,"Hot and Cold")},
	  {Name="Cursed Ship",Target=CFrame.new(923.40197753906,125.05712890625,32885.875),Region="CursedShip",BypassAllowed=false},
	  {Name="Ice Castle",Target=RE4CanonicalWorldTarget(2,"Ice Castle")},
	  {Name="Forgotten Island",Target=RE4CanonicalWorldTarget(2,"Forgotten Island")},
	  {Name="Usoap's Island",Target=CFrame.new(4816.8618164063,8.4599885940552,2863.8195800781)},
	  {Name="Mini Sky Island",Target=CFrame.new(-288.74060058594,49326.31640625,-35248.59375)},
	},
	[3] = {
	  {Name="Mansion",Target=CFrame.new(-12471.169921875,374.94024658203,-7551.677734375)},
	  {Name="Port Town",Target=RE4CanonicalWorldTarget(3,"Port Town")},
	  {Name="Great Tree",Target=T.Regions.TempleOfTime.Entrance.Approach,RuntimeNPC="Mysterious Force",ExactTarget=true},
	  {Name="Castle on the Sea",Target=CFrame.new(-5074.45556640625,314.5155334472656,-2991.054443359375)},
	  {Name="Hydra Island",Target=RE4CanonicalWorldTarget(3,"Hydra Island")},
	  {Name="Floating Turtle",Target=RE4CanonicalWorldTarget(3,"Floating Turtle")},
	  {Name="Haunted Castle",Target=RE4CanonicalWorldTarget(3,"Haunted Castle")},
	  {Name="Ice Cream Island",Target=RE4CanonicalWorldTarget(3,"Ice Cream Island")},
	  {Name="Peanut Island",Target=RE4CanonicalWorldTarget(3,"Peanut Island")},
	  {Name="Cake Island",Target=RE4CanonicalWorldTarget(3,"Cake Island")},
	  {Name="Cocoa Island",Target=RE4CanonicalWorldTarget(3,"Cocoa Island")},
	  {Name="Candy Island",Target=RE4CanonicalWorldTarget(3,"Candy Island")},
	  {Name="Tiki Outpost",Target=RE4CanonicalWorldTarget(3,"Tiki Outpost")},
	  {Name="Submerged Island",Target=CFrame.new(10780.639648,-2088.414062,9260.453125),Region="Submerged",BypassAllowed=false},
	},
  }
  T.CanonicalDestinationRevision = "2.0.45-worldspatial-v1"

  -- Bypass capability is topology data. Consumers never infer it from a
  -- transport implementation name or from a Sea/island-specific branch.
  for _,islands in pairs(T.Islands) do
    for _,island in ipairs(islands) do
      local regionSpec=island.Region and T.Regions[tostring(island.Region)] or nil
      if type(regionSpec)=="table" and regionSpec.BypassAllowed==false then island.BypassAllowed=false
      elseif island.BypassAllowed==nil then island.BypassAllowed=true end
    end
  end

  T.MovementZoneOrder = {"SkyUpper","SkyLower"}
  local function RE4TopologyIslandVector(sea,name)
    for _,entry in ipairs(T.Islands[sea] or {}) do
      if entry.Name==name and typeof(entry.Target)=="CFrame" then return entry.Target.Position end
    end
    return nil
  end
  local function RE4TopologyIslandFrame(sea,name)
    for _,entry in ipairs(T.Islands[sea] or {}) do
      if entry.Name==name and typeof(entry.Target)=="CFrame" then return entry.Target end
    end
    return nil
  end

  -- Portal schema v5 keeps requestEntrance protocol tokens separate from world
  -- arrival geometry. First Sea Sky protocols are callable World-region transport
  -- capabilities; semantic arrival zones decide World<->Sky and layer traversal.
  -- This removes the stale physical-trigger duplicate path without changing the
  -- verified protocol vectors or canonical map targets.
  local RE4_SKY_MIDDLE_PROTOCOL=Vector3.new(-4607.82275,872.54248,-1667.55688)
  local RE4_SKY_UPPER_PROTOCOL=Vector3.new(-7894.6176757813,5547.1416015625,-380.29119873047)
  local RE4_UW_PROTOCOL=Vector3.new(61163.8515625,11.6796875,1819.7841796875)
  local RE4_UW_TARGET=RE4TopologyIslandFrame(1,"Underwater City")
  local RE4_UW_EXIT_PROTOCOL=Vector3.new(3864.8515625,6.6796875,-1926.7841796875)
  local RE4_UW_EXIT_ARRIVAL=CFrame.new(4078.927490234375,-13.781997680664063,-1814.863037109375)

  T.Regions.UnderwaterCity.TargetDetector={Center=RE4_UW_TARGET.Position,Radius3D=6500}
  T.Regions.UnderwaterCity.CurrentDetector={Center=RE4_UW_TARGET.Position,Radius3D=7500}
  T.Regions.UnderwaterCity.Entrance={Mode="Portal",PortalKey="UnderwaterCity"}
  T.Regions.UnderwaterCity.Exit={Mode="Portal",PortalKey="UnderwaterExit"}

  T.MovementZones = {
    SkyUpper = {Key="SkyUpper",Sea=1,TransitionSensitive=true,PortalBoundary=true,BypassAllowed=false,Detector={Center=RE4TopologyIslandVector(1,"Skylands · Upper"),RadiusXZ=3400,MinY=3000,MaxY=8000}},
    SkyLower = {Key="SkyLower",Sea=1,TransitionSensitive=true,BypassAllowed=false,Detector={Center=RE4TopologyIslandVector(1,"Skylands · Lower"),RadiusXZ=2800,MinY=150,MaxY=2500}},
  }

  T.PortalSchemaVersion=5
  T.Portals = {
    [1] = {
      -- requestEntrance is a World-region capability, not a World-zone-only
      -- entry. The same two protocols serve World<->Sky and Sky layer changes;
      -- arrival zone + shared boundary logic decide whether a route is compatible.
      {
        Key="SkyMiddle",Sea=1,Direction="AnyWorldToMiddle",Activation="Remote",
        EntryRegion="World",EntryTrigger=false,
        PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=RE4_SKY_MIDDLE_PROTOCOL,
        ArrivalRegion="World",ArrivalZone="SkyLower",ArrivalPosition=RE4TopologyIslandFrame(1,"Skylands · Middle"),ArrivalRadius=900,
        NativeDestination=true,NativeIslands={"Skylands · Lower","Skylands · Middle"},
        ServiceRegions={"World"},ServiceZones={"SkyLower"},
      },
      {
        Key="SkyUpper",Sea=1,Direction="AnyWorldToUpper",Activation="Remote",
        EntryRegion="World",EntryTrigger=false,
        PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=RE4_SKY_UPPER_PROTOCOL,
        ArrivalRegion="World",ArrivalZone="SkyUpper",ArrivalPosition=RE4TopologyIslandFrame(1,"Skylands · Upper"),ArrivalRadius=1200,
        NativeDestination=true,NativeIslands={"Skylands · Upper"},
        ServiceRegions={"World"},ServiceZones={"SkyUpper"},
      },
      {
        Key="UnderwaterCity",Sea=1,Direction="WorldToUnderwater",Activation="Remote",EntryRegion="World",EntryTrigger=false,
        PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=RE4_UW_PROTOCOL,
        ArrivalRegion="UnderwaterCity",ArrivalPosition=RE4_UW_TARGET,ArrivalRadius=900,NativeDestination=true,NativeRegions={"UnderwaterCity"},NativeIslands={"Underwater City"},ServiceRegions={"UnderwaterCity"},
      },
      {
        Key="UnderwaterExit",Sea=1,Direction="UnderwaterToWorld",Activation="Remote",EntryRegion="UnderwaterCity",EntryTrigger=false,
        PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=RE4_UW_EXIT_PROTOCOL,
        ArrivalRegion="World",ArrivalPosition=RE4_UW_EXIT_ARRIVAL,ArrivalRadius=900,SourceRegions={"UnderwaterCity"},ServiceRegions={"World"},
      },
    },
    [2] = {
      {Key="CursedShip",Sea=2,Direction="WorldToCursedShip",Activation="Remote",EntryRegion="World",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(923.21252441406,126.9760055542,32852.83203125),ArrivalRegion="CursedShip",ArrivalPosition=RE4TopologyIslandFrame(2,"Cursed Ship"),ArrivalRadius=900,NativeDestination=true,NativeRegions={"CursedShip"},NativeIslands={"Cursed Ship"},ServiceRegions={"CursedShip"}},
      -- Current public runtime implementations (Jun/Aug 2026) independently
      -- expose this Kingdom-of-Rose entrance. It was missing from the 2.3.4
      -- portal registry, leaving a safe Bypass rejection with no portal fallback.
      {Key="Cafe",Sea=2,Direction="AnyToCafe",Activation="Remote",EntryRegion="Any",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(-288.46246337890625,306.130615234375,597.9988403320312),ArrivalRegion="World",ArrivalPosition=RE4TopologyIslandFrame(2,"Kingdom of Rose · Café"),ArrivalRadius=900,NativeDestination=true,NativeIslands={"Kingdom of Rose · Café"},ServiceRegions={"World"}},
      {Key="SecondSeaMainland",Sea=2,Direction="AnyToMainland",Activation="Remote",EntryRegion="Any",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(-6508.5581054688,89.034996032715,-132.83953857422),ArrivalRegion="World",ArrivalPosition=CFrame.new(-6508.5581054688,89.034996032715,-132.83953857422),ArrivalRadius=900,ServiceRegions={"World"}},
      {Key="SwanRoom",Sea=2,Direction="AnyToSwanRoom",Activation="Remote",EntryRegion="Any",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(2285,15,905),ArrivalRegion="World",ArrivalPosition=RE4TopologyIslandFrame(2,"Don Swan Room"),ArrivalRadius=900,NativeDestination=true,NativeIslands={"Don Swan Room"},ServiceRegions={"World"}},
    },
    [3] = {
      -- Update 30+ runtime implementations observed on 2026-09-09 route distant
      -- Submerged farming through this Tiki requestEntrance before invoking the
      -- Submarine Worker. Keep protocol position separate from the final island
      -- target so every movement consumer can use the same portal capability.
      {Key="Tiki",Sea=3,Direction="AnyToTiki",Activation="Remote",EntryRegion="Any",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(-16269.7041,25.2288494,1373.65955),ArrivalRegion="World",ArrivalPosition=CFrame.new(-16269.7041,25.2288494,1373.65955),ArrivalRadius=900,NativeDestination=true,NativeIslands={"Tiki Outpost"},ServiceRegions={"World"}},
      {Key="Mansion",Sea=3,Direction="AnyToMansion",Activation="Remote",EntryRegion="Any",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(-12471.169921875,374.94024658203,-7551.677734375),ArrivalRegion="World",ArrivalPosition=RE4TopologyIslandFrame(3,"Mansion"),ArrivalRadius=900,NativeDestination=true,NativeIslands={"Mansion"},ServiceRegions={"World"}},
      {Key="Castle",Sea=3,Direction="AnyToCastle",Activation="Remote",EntryRegion="Any",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(-5097.93164,316.447021,-3142.66602),ArrivalRegion="World",ArrivalPosition=CFrame.new(-5097.93164,316.447021,-3142.66602),ArrivalRadius=900,NativeDestination=true,NativeIslands={"Castle on the Sea"},ServiceRegions={"World"}},
      {Key="Hydra",Sea=3,Direction="AnyToHydra",Activation="Remote",EntryRegion="Any",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(5643.4526367188,1013.0858154297,-340.51025390625),ArrivalRegion="World",ArrivalPosition=CFrame.new(5643.4526367188,1013.0858154297,-340.51025390625),ArrivalRadius=900,NativeDestination=true,NativeIslands={"Hydra Island"},ServiceRegions={"World"}},
      {Key="BeautifulPirate",Sea=3,Direction="AnyToBeautifulPirate",Activation="Remote",EntryRegion="Any",EntryTrigger=false,PortalObject={Kind="Remote",Name="requestEntrance"},ProtocolPosition=Vector3.new(5314.5463867188,22.562219619751,-127.06755065918),ArrivalRegion="World",ArrivalPosition=CFrame.new(5314.5463867188,22.562219619751,-127.06755065918),ArrivalRadius=900,NativeDestination=true,NativeNames={"Beautiful Pirate"},NativeSpatialMatch=true,NativeDestinationRadius=700,ServiceRegions={"World"}},
    },
  }
  T.PortalByKey={}
  for sea,routes in pairs(T.Portals) do
    for _,route in ipairs(routes) do
      route.Sea=tonumber(route.Sea) or tonumber(sea)
      route.NodeType=route.NodeType or "FastTravel"
      T.PortalByKey[route.Key]=route
    end
  end
RE4Data.WorldTopology = T



-- Feature-specific world geometry. Runtime consumers must read these canonical
-- positions instead of embedding map coordinates inside Core/UI code.
RE4Data.FeatureLocations = {
  PirateRaid = {
    Castle = CFrame.new(-5496.17432,313.768921,-2841.53027,0.924894512,7.37058015e-09,0.380223751,3.5881019e-08,1,-1.06665446e-07,-0.380223751,1.12297109e-07,0.924894512),
    DetectionCenter = CFrame.new(-5539.3115234375,313.800537109375,-2972.372314453125),
  },
  Cake = {
    Island = CFrame.new(-2077,252,-12373),
    Spawn = CFrame.new(-2151.82,149.32,-12404.91),
    Cocoa = CFrame.new(402.7,81.06,-12259.54),
    UnlockCocoa = CFrame.new(402.7189,81.0605,-12259.543),
    RedDoor = CFrame.new(-2681.97998,64.3921585,-12853.7363,0.149007782,-1.87902192e-08,0.98883605,3.60619588e-08,1,1.35681812e-08,-0.98883605,3.36376011e-08,0.149007782),
    Scientist = CFrame.new(-2812.76708984375,254.803466796875,-12595.560546875),
  },
  Haunted = {
    BoneFarm = CFrame.new(-9495.6807,453.5862,5977.3486),
    SoulReaperSummon = CFrame.new(-8932.3223,146.8315,6062.5508),
    CDKSoulReaperSummon = CFrame.new(-8932.322265625,146.83154296875,6062.55078125),
    Gravestone = CFrame.new(-8761.3154,164.8583,6161.1567),
    SoulGuitarBringAnchor = CFrame.new(-10138.3974609375,138.6524658203125,5902.89208984375),
    SoulGuitarStart = CFrame.new(-8655.0166015625,141.3166961669922,6160.0224609375),
    SoulGuitarPuzzle = CFrame.new(-9532.8232421875,6.471667766571045,6078.068359375),
    RacePoint = CFrame.new(-8987.041015625,215.862060546875,5886.71044921875),
  },
  Tyrant = {
    SummonPoints = {
      CFrame.new(-16332.5264,158.0720,1440.3250), CFrame.new(-16288.6094,158.1670,1470.3680),
      CFrame.new(-16245.4121,158.4370,1463.3660), CFrame.new(-16212.4688,158.1670,1466.3440),
      CFrame.new(-16211.9463,158.0720,1322.3979), CFrame.new(-16260.9219,154.9210,1323.6160),
      CFrame.new(-16297.0596,159.3230,1317.2240), CFrame.new(-16335.0967,159.3340,1324.8860),
    },
  },
  Bartilo = {
    DonSwanRoom = CFrame.new(2288.802,15.1870775,863.034607),
    QuestApproach = CFrame.new(-456.28952,73.0200958,299.895966),
    MazeEntrySimple = CFrame.new(-1836,11,1714),
    MazeRoute = {
      CFrame.new(-1850.49329,13.1789551,1750.89685), CFrame.new(-1858.87305,19.3777466,1712.01807),
      CFrame.new(-1803.94324,16.5789185,1750.89685), CFrame.new(-1858.55835,16.8604317,1724.79541),
      CFrame.new(-1869.54224,15.987854,1681.00659), CFrame.new(-1800.0979,16.4978027,1684.52368),
      CFrame.new(-1819.26343,14.795166,1717.90625), CFrame.new(-1813.51843,14.8604736,1724.79541),
    },
    QuestGiver = CFrame.new(970.369446,142.653198,1217.3667,0.162079468,-4.85452638e-08,-0.986777723,1.03357589e-08,1,-4.74980872e-08,0.986777723,-2.50063148e-09,0.162079468),
    QuestStart = CFrame.new(-461.533203,72.3478546,300.311096,0.050853312,0,-0.998706102,0,1,0,0.998706102,0,0.050853312),
    Jeremy = CFrame.new(2158.97412,449.056244,705.411682,-0.754199564,-4.17389057e-09,-0.656645238,-4.47752875e-08,1,4.50709301e-08,0.656645238,6.3393955e-08,-0.754199564),
    MazeEntry = CFrame.new(-1830.83972,10.5578213,1680.60229,0.979988456,-2.02152783e-08,-0.199054286,2.20792113e-08,1,7.1442483e-09,0.199054286,-1.13962431e-08,0.979988456),
  },
  Tushita = {
    HolyTorch = CFrame.new(5148.03613,162.352493,910.548218),
    TorchRoute = {
      CFrame.new(-10752,417,-9366), CFrame.new(-11672,334,-9474), CFrame.new(-12132,521,-10655),
      CFrame.new(-13336,486,-6985), CFrame.new(-13489,332,-7925),
    },
    LongmaFallback = CFrame.new(-12318.193359375,601.9518432617188,-6538.662109375),
  },
  CDK = {
    BoatQuest = {
      CFrame.new(-4602.5107421875,16.446542739868164,-2880.998046875),
      CFrame.new(4001.185302734375,10.089399337768555,-2654.86328125),
      CFrame.new(-9530.763671875,7.245208740234375,-8375.5087890625),
    },
    HeavenlyPrompts = {
      CFrame.new(-22529.6171875,5275.77392578125,3873.5712890625),
      CFrame.new(-22637.291015625,5281.365234375,3749.28857421875),
      CFrame.new(-22791.14453125,5277.16552734375,3764.570068359375),
    },
    HeavenlyCenter = CFrame.new(-22695.7012,5270.93652,3814.42847,0.11794927,3.32185834e-08,0.99301964,-8.73070718e-08,1,-2.30819008e-08,-0.99301964,-8.3975138e-08,0.11794927),
  },
  Items = {
    RengokuKey = CFrame.new(6571.1201171875,299.23028564453,-6967.841796875),
    DarkBladeArena = CFrame.new(-5719.36376953125,48.50590515136719,-782.9759521484375),
    DarkBladeQuest = CFrame.new(3677.08203125,62.751937866211,-3144.8332519531),
    TrainingDummy = CFrame.new(3688.005126953125,12.746943473815918,170.20953369140625),
    RipIndraFallback = CFrame.new(-5344.822265625,423.98541259766,-2725.0930175781),
    MaterialSoulFallback = CFrame.new(3798.4575195313,13.826690673828,-3399.806640625),
  },
  RainbowHaki = {
    QuestGiver = CFrame.new(-11892.0703125,930.57672119141,-8760.1591796875),
    Stone = CFrame.new(-1086.11621,38.8425903,6768.71436,0.0231462717,-0.592676699,0.805107772,2.03251839e-05,0.805323839,0.592835128,-0.999732077,-0.0137055516,0.0186523199),
    Hydra = CFrame.new(5821.89794921875,1019.0950927734375,-73.71923065185547),
    Kilo = CFrame.new(2877.61743,423.558685,-7207.31006,-0.989591599,0,-0.143904909,0,1.00000012,0,0.143904924,0,-0.989591479),
    CaptainElephant = CFrame.new(-13376.7578125,433.28689575195,-8071.392578125),
    BeautifulPirate = CFrame.new(5314.54638671875,22.562219619750977,-127.06755065917969),
  },
  Observation = {
    FarmTargets = {
      [1]="Galley Captain",
      [2]="Lava Pirate",
      [3]="Venomous Assailant",
    },
    FarmFallback = {
      [1]=CFrame.new(5533.29785,88.1079102,4852.3916),
      [2]=CFrame.new(-5478.39209,15.9775667,-5246.9126),
      [3]=CFrame.new(4530.3540039063,656.75695800781,-131.60952758789),
    },
  },
  KenV2 = {
    Quest = CFrame.new(-12444.78515625,332.40396118164,-7673.1806640625),
    Point3 = CFrame.new(-10920.125,624.20275878906,-10266.995117188),
    Point4 = CFrame.new(-13277.568359375,370.34185791016,-7821.1572265625),
    Point5 = CFrame.new(-13493.12890625,318.89553833008,-8373.7919921875),
    Completion = CFrame.new(-12513.51953125,340.1137390136719,-9873.048828125),
    Apple = CFrame.new(-12471.169921875,374.94024658203,-7551.677734375),
    Banana = CFrame.new(2286.0078125,73.13391876220703,-7159.80908203125),
    Pineapple = CFrame.new(-712.8272705078125,98.5770492553711,5711.9541015625),
  },
  Citizen = {
    QuestGiver = CFrame.new(-12443.8671875,332.40396118164,-7675.4892578125),
    CaptainElephant = CFrame.new(-13374.889648438,421.27752685547,-8225.208984375),
    Completion = CFrame.new(-12512.138671875,340.39279174805,-9872.8203125),
  },
  Sea = {
    BoatDealer = CFrame.new(-16927.451,9.086,433.864),
    Infinite = CFrame.new(-10000000,31,37016.25),
    InfiniteHigh = CFrame.new(-10000000,150,37016.25),
    SeaBeastApproachHigh = CFrame.new(5433,150,290),
    SeaBeastApproachLow = CFrame.new(5433,35,290),
    DangerZones = {
      ["Lv 1"]=CFrame.new(-21998.375,30.0006084,-682.309143),
      ["Lv 2"]=CFrame.new(-26779.5215,30.0005474,-822.858032),
      ["Lv 3"]=CFrame.new(-31171.957,30.0001011,-2256.93774),
      ["Lv 4"]=CFrame.new(-34054.6875,30.2187767,-2560.12012),
      ["Lv 5"]=CFrame.new(-38887.5547,30.0004578,-2162.99023),
      ["Lv 6"]=CFrame.new(-44541.7617,30.0003204,-1244.8584),
      ["Lv Infinite"]=CFrame.new(-10000000,31,37016.25),
    },
  },
  Race = {
    AncientClockRoute = {
      CFrame.new(29020.66015625,14889.4267578125,-379.2682800292969),
      CFrame.new(28224.056640625,14889.4267578125,-210.5872039794922),
      CFrame.new(28492.4140625,14894.4267578125,-422.1100158691406),
      CFrame.new(28967.408203125,14918.0751953125,234.31198120117188),
      CFrame.new(28672.720703125,14889.1279296875,454.5961608886719),
      CFrame.new(29237.294921875,14889.4267578125,-206.94955444335938),
    },
    DragonBelt = CFrame.new(5865.0234375,1208.3154296875,871.15185546875),
    DragonTrainer = CFrame.new(5813,1208,884),
    DragonWizard = CFrame.new(5814.42724609375,1208.3267822265625,884.5785522460938),
    Uzoth = CFrame.new(5661.89014,1211.31909,864.836731,0.811413169,-1.36805838e-08,-0.584473014,4.75227395e-08,1,4.25682458e-08,0.584473014,-6.23161966e-08,0.811413169),
    DracoRelicRoute = {
      CFrame.new(-39934.9765625,10685.359375,22999.34375), CFrame.new(-40511.25390625,9376.4013671875,23458.37890625),
      CFrame.new(-39914.65625,10685.384765625,23000.177734375), CFrame.new(-40045.83203125,9376.3984375,22791.287109375),
      CFrame.new(-39908.5,10685.4052734375,22990.04296875), CFrame.new(-39609.5,9376.400390625,23472.94335975),
    },
  },
  Raid = {
    Start = {
      [2]=CFrame.new(-6438.73535,250.645355,-4501.50684),
      [3]=CFrame.new(-5097.93164,316.447021,-3142.66602),
    },
  },
}

RE4Data.StatusEntities = {
  PrehistoricIsland = "Prehistoric Island",
  FrozenDimension = "Frozen Dimension",
  KitsuneIsland = "Kitsune Island",
  MirageIsland = "Mirage Island",
}
RE4Data.StatusRuntimeNames = {
  KitsuneIsland = "KitsuneIsland",
  MoonSkyBySea = { [1] = "FantasySky", [2] = "FantasySky", [3] = "Sky" },
}
RE4Data.StatusBossGroups = {
  Sea1Greybeard = {"Greybeard"}, Sea1Saw = {"The Saw"},
  Sea2CursedCaptain = {"Cursed Captain"}, Sea2Darkbeard = {"Darkbeard"},
  Sea3Elite = {"Diablo","Deandre","Urban"}, Sea3RipIndra = {"rip_indra True Form","rip_indra"}, Sea3DoughKing = {"Dough King"},
}
RE4Data.StatusCodes = { LeviathanSpyComplete = 5 }

-- Stable game/runtime option values. Display labels are localized separately.
RE4Data.OptionValues = {
  Weapons = {"Melee","Sword","Blox Fruit","Gun"},
  FishingRods = {"Fishing Rod","Gold Rod","Shark Rod","Shell Rod","Treasure Rod"},
  RaidModes = {"Basic","Advanced"},
  DayPhases = {"Morning","Evening"},
  SeaBoats = {"Guardian","PirateGrandBrigade","MarineGrandBrigade","PirateBrigade","MarineBrigade","PirateSloop","MarineSloop","Beast Hunter"},
  SeaDangerZones = {"Lv 1","Lv 2","Lv 3","Lv 4","Lv 5","Lv 6","Lv Infinite"},
  HakiStates = {"State 0","State 1","State 2","State 3","State 4","State 5"},
}

-- Passive shop/action registry. UI labels are language-owned; Core consumes only
-- stable IDs, semantic catalog keys, remote arguments and Sea scope from here.
RE4Data.ShopActions = {
  Sea1Abilities = {
    {Id="button.shop.buy.buso",Action="Buy Buso",Trace="Shop.Buso",Args={"BuyHaki","Buso"}},
    {Id="button.shop.buy.geppo",Action="Buy Geppo",Trace="Shop.Geppo",Args={"BuyHaki","Geppo"}},
    {Id="button.shop.buy.soru",Action="Buy Soru",Trace="Shop.Soru",Args={"BuyHaki","Soru"}},
    {Id="button.shop.buy.ken",Action="Buy Ken",Trace="Shop.Ken",Args={"KenTalk","Buy"}},
  },
  Sea1Accessories = {
    {Id="button.shop.buy.tomoe.ring",Action="Buy Tomoe Ring",Trace="Shop.TomoeRing",Args={"BuyItem","Tomoe Ring"}},
    {Id="button.shop.buy.black.cape",Action="Buy Black Cape",Trace="Shop.BlackCape",Args={"BuyItem","Black Cape"}},
    {Id="button.shop.buy.swordsman.hat",Action="Buy Swordsman Hat",Trace="Shop.SwordsmanHat",Args={"BuyItem","Swordsman Hat"}},
  },
  Ectoplasm = {
    {Id="button.shop.buy.bizarre.revolver",Action="Buy Bizarre Revolver",Args={"Ectoplasm","Buy",1}},
    {Id="button.shop.buy.ghoul.mask",Action="Buy Ghoul Mask",Args={"Ectoplasm","Buy",2}},
  },
  SeaEventCraft = {
    {Id="button.shop.craft.dragonheart",Action="Craft DragonHeart",Args={"CraftItem","Craft","Dragonheart"}},
    {Id="button.shop.craft.dragonstorm",Action="Craft DragonStorm",Args={"CraftItem","Craft","Dragonstorm"}},
    {Id="button.shop.craft.dino.hood",Action="Craft Dino Hood",Args={"CraftItem","Craft","DinoHood"}},
    {Id="button.shop.craft.shark.tooth.necklace",Action="Craft Shark Tooth Necklace",Args={"CraftItem","Craft","SharkTooth"}},
    {Id="button.shop.craft.terror.jaw",Action="Craft Terror Jaw",Args={"CraftItem","Craft","TerrorJaw"}},
    {Id="button.shop.craft.leviathan.crown",Action="Craft Leviathan Crown",Args={"CraftItem","Craft","LeviathanCrown"}},
    {Id="button.shop.craft.leviathan.shield",Action="Craft Leviathan Shield",Args={"CraftItem","Craft","LeviathanShield"}},
    {Id="button.shop.craft.beast.hunter.boat",Action="Craft Beast Hunter Boat",Args={"CraftItem","Craft","LeviathanBoat"}},
    {Id="button.shop.craft.legendary.scroll",Action="Craft LegendaryScroll",Args={"CraftItem","Craft","LegendaryScroll"}},
    {Id="button.shop.craft.mythical.scroll",Action="Craft MythicalScroll",Args={"CraftItem","Craft","MythicalScroll"}},
  },
  Sea1Weapons = {
    {Id="button.shop.buy.cutlass",Action="Buy Cutlass",Trace="Shop.Cutlass",Args={"BuyItem","Cutlass"}},
    {Id="button.shop.buy.katana",Action="Buy Katana",Trace="Shop.Katana",Args={"BuyItem","Katana"}},
    {Id="button.shop.buy.iron.mace",Action="Buy Iron Mace",Trace="Shop.IronMace",Args={"BuyItem","Iron Mace"}},
    {Id="button.shop.buy.duel.katana",Action="Buy Duel Katana",Trace="Shop.DualKatana",Args={"BuyItem","Duel Katana"}},
    {Id="button.shop.buy.triple.katana",Action="Buy Triple Katana",Trace="Shop.TripleKatana",Args={"BuyItem","Triple Katana"}},
    {Id="button.shop.buy.pipe",Action="Buy Pipe",Trace="Shop.Pipe",Args={"BuyItem","Pipe"}},
    {Id="button.shop.buy.dual.headed.blade",Action="Buy Dual-Headed Blade",Trace="Shop.DualHeadedBlade",Args={"BuyItem","Dual-Headed Blade"}},
    {Id="button.shop.buy.bisento",Action="Buy Bisento",Trace="Shop.Bisento",Args={"BuyItem","Bisento"}},
    {Id="button.shop.buy.soul.cane",Action="Buy Soul Cane",Trace="Shop.SoulCane",Args={"BuyItem","Soul Cane"}},
    {Id="button.shop.buy.slingshot",Action="Buy SlingShot",Trace="Shop.Slingshot",Args={"BuyItem","Slingshot"}},
    {Id="button.shop.buy.musket",Action="Buy Musket",Trace="Shop.Musket",Args={"BuyItem","Musket"}},
    {Id="button.shop.buy.refined.slingshot",Action="Buy Refined Slingshot",Trace="Shop.RefinedSlingshot",Args={"BuyItem","Refined Slingshot"}},
    {Id="button.shop.buy.dual.flintlock",Action="Buy Dual Flintlock",Trace="Shop.DualFlintlock",Args={"BuyItem","Dual Flintlock"}},
    {Id="button.shop.buy.flintlock",Action="Buy Flintlock",Trace="Shop.Flintlock",Args={"BuyItem","Flintlock"}},
    {Id="button.shop.buy.cannon",Action="Buy Cannon",Trace="Shop.Cannon",Args={"BuyItem","Cannon"}},
  },
}
for _,group in pairs(RE4Data.ShopActions) do
  for _,entry in ipairs(group) do
    entry.Seas = (RE4Data.FeatureMetadata and RE4Data.FeatureMetadata.FeatureSeaRules and RE4Data.FeatureMetadata.FeatureSeaRules[entry.Action]) or entry.Seas
  end
end

-- Ownership is keyed by stable public control IDs, never by localized UI text.
-- Legacy semantic names remain only as passive game metadata for shop/action resolvers.
RE4Data.ControlOwnership={}
do
  local function slug(value)
    local text=tostring(value or ""):lower():gsub("[^%w]+","."):gsub("^%.*",""):gsub("%.*$",""):gsub("%.+",".")
    return text~="" and text or "control"
  end
  for featureName,itemKey in pairs(RE4Data.OneTimeRules or {}) do
    local mode="one_time"
    if tostring(featureName):match("^Use ") then mode="use"
    elseif tostring(featureName):match("^Auto Get ") then mode="automation"
    elseif tostring(featureName):match("^Auto Craft ") then mode="automation" end
    local suffix=slug(featureName)
    local rule={Item=itemKey,Mode=mode,Seas=RE4Data.FeatureMetadata and RE4Data.FeatureMetadata.FeatureSeaRules and RE4Data.FeatureMetadata.FeatureSeaRules[featureName] or nil}
    RE4Data.ControlOwnership["toggle."..suffix]=rule
    RE4Data.ControlOwnership["button."..suffix]=rule
  end
  for key,meta in pairs(RE4Data.FightingStyleRegistry or {}) do
    if type(meta)=="table" and tostring(meta.Style or "")~="" then
      local suffix=tostring(key):lower()
      RE4Data.ControlOwnership["toggle.fighting.style.auto."..suffix]={Item=meta.Style,Mode="automation",Seas=meta.Seas}
      RE4Data.ControlOwnership["toggle.fighting.style.use."..suffix]={Item=meta.Style,Mode="use",Seas=meta.Seas}
    end
  end
end

RE4Data.TrialCombatMobs={"Ancient Vampire","Ancient Zombie"}

return RE4Data

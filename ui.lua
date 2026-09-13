--[[
RE4 HUB UI · NEXT COMPACT TWO-COLUMN APPLICATION SHELL
Release identity is provided by config.lua; gameplay state is accessed only through the public Core API
Compact rail-navigation, two-column responsive application shell for Roblox / executor environments.

Design goals:
- Keep legacy AddToggle/AddButton/... API compatible with RE4 HUB gameplay code.
- Section-first layout: one panel contains many compact controls instead of one card per toggle.
- Desktop/tablet compact rail navigation + balanced content workspace; narrow screens retain one-column pages.
- Centralized popup, input, motion, responsive and feature-search managers.
- Safe callbacks with readable tracebacks and no broad error swallowing.
- Sea-aware legacy routing and ownership-aware controls.
]]

local function RE4ResolveEnvLocal()
    local fn=getgenv
    if type(fn)=="function" then
        local ok,value=pcall(fn)
        if ok and type(value)=="table" then return value end
    end
    return _G
end
local env=RE4ResolveEnvLocal()
local Config=env.RE4_CONFIG
if type(Config)~="table" or tonumber(Config.Schema)~=2 or type(Config.App)~="table" then
    error("[RE4 HUB/UI] config.lua schema 2 is required")
end
local RE4UI = {}
RE4UI.__index = RE4UI
RE4UI.Schema = 2
RE4UI.ApiVersion = 1
RE4UI.Version = tostring(Config.App.Version or "")
RE4UI.ReleaseStamp = tostring(Config.Source and Config.Source.Artifacts and Config.Source.Artifacts.UI or "ui")
RE4UI.LanguageRevision = tostring(Config.Source and Config.Source.Artifacts and Config.Source.Artifacts.Language or RE4UI.ReleaseStamp)
RE4UI.DisplayVersion = tostring(Config.App.DisplayVersion or RE4UI.Version)
RE4UI.HubName = tostring(Config.App.HubName or Config.App.Product or "RE4 HUB")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

RE4UI.Config = {
    Assets = {
        Logo = "rbxassetid://129347191626169",
        Header = "rbxassetid://77866589839728",
        LegacyIconSheet = "rbxassetid://126253815695177",
    },
    IconLibrary = {
        -- Primary icons are individual Lucide image assets. They do not depend on
        -- atlas rect metadata, so source-resolution/fetch failure is isolated per icon.
        Primary = {
            Farm="rbxassetid://10734965572", Raid="rbxassetid://10734962068", Items="rbxassetid://10709769841", Progress="rbxassetid://10734977012", World="rbxassetid://10723398002", More="rbxassetid://10734897250",
            Search="rbxassetid://10734943674", Settings="rbxassetid://10734950309", QuickSetup="rbxassetid://10734950020", CurrentTarget="rbxassetid://10734977012", Special="rbxassetid://10734966248", ChevronDown="rbxassetid://10709790948",
            Minimize="rbxassetid://10734896206", Close="rbxassetid://10747384394", Check="rbxassetid://10709790644", Warning="rbxassetid://10709753149", Info="rbxassetid://10723415903", Teleport="rbxassetid://10734886004",
            Weapon="rbxassetid://10734975692", Player="rbxassetid://10747373176", Backpack="rbxassetid://10709769841", Shield="rbxassetid://10734951847", Home="rbxassetid://10723407389", Lock="rbxassetid://10723434711",
        },
        -- Independent fallback source. The fallback is only selected when Roblox
        -- reports a terminal fetch failure for a primary icon.
        Fallback = {
            Farm="rbxassetid://7743872071", Raid="rbxassetid://7734058599", Items="rbxassetid://7734021469", Progress="rbxassetid://7733799969", World="rbxassetid://7733954760", More="rbxassetid://7734006080",
            Search="rbxassetid://7734052925", Settings="rbxassetid://7734053495", QuickSetup="rbxassetid://8997386997", CurrentTarget="rbxassetid://7733765307", Special="rbxassetid://7734068321", ChevronDown="rbxassetid://7733717447",
            Minimize="rbxassetid://7734000129", Close="rbxassetid://7743878737", Check="rbxassetid://7733715400", Warning="rbxassetid://7733658504", Info="rbxassetid://7733964719", Teleport="rbxassetid://7733992789",
            Weapon="rbxassetid://7733674079", Player="rbxassetid://7743875962", Backpack="rbxassetid://7734021469", Shield="rbxassetid://7734056608", Home="rbxassetid://7733960981", Lock="rbxassetid://7733992528",
        },
        Aliases = {
            farm="Farm", combat="Weapon", raid="Raid", raids="Raid", items="Items", inventory="Backpack", progress="Progress", race="Player",
            shop="Backpack", events="Special", event="Special", travel="Teleport", teleport="Teleport", system="Settings", settings="Settings",
            boss="Special", factory="Special", material="Backpack", sword="Weapon", sea="World", world="World", weapon="Weapon", player="Player",
            info="Info", warning="Warning", lock="Lock", home="Home", search="Search", target="CurrentTarget", shield="Shield",
        },
        Legacy = {Id=126253815695177, Uri="rbxassetid://126253815695177"},
    },
    PresentationSchema = {
        Tabs = {
            {Key="Main",TitleKey="nav.main",SubtitleKey="page.main",Icon="Home",Order=5,ColumnRatio=0.50},
            {Key="Farm",TitleKey="nav.farm",SubtitleKey="page.farm",Icon="Farm",Order=10,ColumnRatio=0.52},
            {Key="Combat",TitleKey="nav.combat",SubtitleKey="page.combat",Icon="Weapon",Order=20,ColumnRatio=0.50},
            {Key="Raids",TitleKey="nav.raids",SubtitleKey="page.raids",Icon="Raid",Order=30,ColumnRatio=0.50},
            {Key="Progress",TitleKey="nav.progress",SubtitleKey="page.progress_new",Icon="Progress",Order=40,ColumnRatio=0.53},
            {Key="Race",TitleKey="nav.race",SubtitleKey="page.race",Icon="Player",Order=50,ColumnRatio=0.50},
            {Key="Items",TitleKey="nav.items",SubtitleKey="page.items_new",Icon="Items",Order=60,ColumnRatio=0.54},
            {Key="Shop",TitleKey="nav.shop",SubtitleKey="page.shop",Icon="Backpack",Order=70,ColumnRatio=0.51},
            {Key="Events",TitleKey="nav.events",SubtitleKey="page.events",Icon="Special",Order=80,ColumnRatio=0.49},
            {Key="Travel",TitleKey="nav.travel",SubtitleKey="page.travel",Icon="Teleport",Order=90,ColumnRatio=0.52},
            {Key="System",TitleKey="nav.system",SubtitleKey="page.system",Icon="Settings",Order=100,ColumnRatio=0.50},
        },
        DomainDefaults={Home="Main",Farm="Farm",Settings="System",Sea="Events",Quest="Progress",Events="Events",Race="Race",Fruit="Items",Raid="Raids",Teleport="Travel",Items="Shop",Utilities="System",runtime="System"},
        GroupRoutes={
            ["Home/home.dashboard"]={Tab="Main",Section="main.overview"}, ["Home/home.active_features"]={Tab="Main",Section="main.active"}, ["Home/home.activity"]={Tab="Main",Section="main.active"}, ["Home/home.server_status"]={Tab="Main",Section="main.server"}, ["Home/home.community"]={Tab="Main",Section="main.updates"},
            ["Farm/farming"]={Tab="Farm",Section="farm.level"}, ["Farm/farm.island"]={Tab="Farm",Section="farm.island"}, ["Farm/collect.chest"]={Tab="Farm",Section="farm.collection"}, ["Farm/collect.berry"]={Tab="Farm",Section="farm.collection"},
            ["Farm/farming.cake"]={Tab="Farm",Section="farm.special"}, ["Farm/farming.bone"]={Tab="Farm",Section="farm.special"}, ["Farm/farm.material"]={Tab="Farm",Section="farm.materials"}, ["Farm/farm.elite.hunter"]={Tab="Farm",Section="farm.boss"}, ["Farm/farm.boss"]={Tab="Farm",Section="farm.boss"}, ["Farm/tyrant.of.the.skies"]={Tab="Farm",Section="farm.boss"}, ["Farm/farm.status"]={Tab="Farm",Section="farm.target"}, ["Farm/farming.mastery"]={Tab="Farm",Section="farm.mastery"}, ["Farm/unlocked.dungeon"]={Tab="Raids",Section="raids.unlocks"},
            ["Settings/settings.configure"]={Tab="System",Section="system.runtime"}, ["Settings/settings.team"]={Tab="System",Section="system.team"}, ["Settings/settings.runtime_safety"]={Tab="System",Section="system.safety"}, ["Settings/stats.upgrade"]={Tab="Progress",Section="progress.stats"},
            ["Sea/fishing"]={Tab="Events",Section="events.fishing"}, ["Sea/mystic.island.full.moon"]={Tab="Events",Section="events.mirage"}, ["Sea/skull.guitars.misc"]={Tab="Events",Section="events.mirage"},
            ["Quest/tushita.and.yama"]={Tab="Progress",Section="progress.swords"}, ["Quest/cursed.dual.katana"]={Tab="Progress",Section="progress.swords"}, ["Quest/true.triple.katana.sword"]={Tab="Progress",Section="progress.swords"}, ["Quest/pole.thunder.god"]={Tab="Progress",Section="progress.swords"}, ["Quest/items.law.order.sword"]={Tab="Progress",Section="progress.swords"}, ["Quest/rengoku.sword"]={Tab="Progress",Section="progress.swords"}, ["Quest/cavender.twin.hooks.bigmom"]={Tab="Progress",Section="progress.swords"}, ["Quest/dark.dragger.valkyrie"]={Tab="Progress",Section="progress.swords"}, ["Quest/progress.first_sea_obtainables"]={Tab="Progress",Section="progress.first_sea"}, ["Quest/buso.aura.colours"]={Tab="Progress",Section="progress.haki"}, ["Quest/instinct.observation"]={Tab="Progress",Section="progress.haki"}, ["Quest/fighting_style"]={Tab="Progress",Section="progress.fighting_styles"},
            ["Race/upgrade.races.v3"]={Tab="Race",Section="race.v3"}, ["Race/race.progression"]={Tab="Race",Section="race.v3"}, ["Race/trials.quest.v4"]={Tab="Race",Section="race.v4"}, ["Race/dojo.quest.drago.race"]={Tab="Race",Section="race.draco"}, ["Race/drago.trial"]={Tab="Race",Section="race.draco"},
            ["Fruit/fruits.options"]={Tab="Items",Section="items.fruits"}, ["Fruit/fruits.shop"]={Tab="Items",Section="items.fruit_shop"}, ["Items/items.fighting_style"]={Tab="Items",Section="items.fighting_styles"}, ["Items/fighting_style"]={Tab="Items",Section="items.fighting_styles"}, ["Items/items.ownership"]={Tab="Items",Section="items.ownership"},
            ["Items/shop.options"]={Tab="Shop",Section="shop.abilities"}, ["Items/basic abilities"]={Tab="Shop",Section="shop.abilities"}, ["Items/items.accessory_sea1"]={Tab="Shop",Section="shop.accessories"}, ["Items/items.ectoplasm_shop"]={Tab="Shop",Section="shop.accessories"}, ["Items/items.accessory_sea_event"]={Tab="Shop",Section="shop.accessories"}, ["Items/items.fragments_shop"]={Tab="Shop",Section="shop.fragments"}, ["Items/weapon.world.1"]={Tab="Shop",Section="shop.weapons"}, ["Items/weapon.world.2"]={Tab="Shop",Section="shop.weapons"}, ["Items/weapon.world.3"]={Tab="Shop",Section="shop.weapons"},
            ["Raid/dungeon.event.raiding"]={Tab="Raids",Section="raids.normal"}, ["Raid/unlocked.dungeon"]={Tab="Raids",Section="raids.unlocks"}, ["Raid/raiding.menu"]={Tab="Raids",Section="raids.setup"}, ["Raid/law.raid"]={Tab="Raids",Section="raids.law"},
            ["Events/volcanic.magnet"]={Tab="Events",Section="events.prehistoric"}, ["Events/prehistoric.island"]={Tab="Events",Section="events.prehistoric"}, ["Events/sea.event.setting.sail"]={Tab="Events",Section="events.sailing"}, ["Events/entity.sea.event"]={Tab="Events",Section="events.entities"}, ["Events/kitsune.island.event"]={Tab="Events",Section="events.kitsune"},
            ["Teleport/travel.worlds"]={Tab="Travel",Section="travel.worlds"}, ["Teleport/travel.island"]={Tab="Travel",Section="travel.islands"}, ["Teleport/teleport.npc"]={Tab="Travel",Section="travel.npc"}, ["Teleport/teleport.player"]={Tab="Travel",Section="travel.player"}, ["Teleport/travel.automation"]={Tab="Travel",Section="travel.movement"},
            ["Utilities/server.function"]={Tab="Travel",Section="travel.servers"}, ["Utilities/player.gui.others"]={Tab="System",Section="system.game_ui"}, ["Utilities/graphics.haki.stats"]={Tab="System",Section="system.visuals"}, ["Utilities/configure.god"]={Tab="System",Section="system.utilities"}, ["Utilities/esp"]={Tab="System",Section="system.esp"},
        },
        ControlRoutes={
            {Pattern="toggle.esp.",Tab="System",Section="system.esp"},
            {Pattern="option.farm.nearest.max.distance",Tab="Farm",Section="farm.level"}, {Pattern="option.choose.weapon",Tab="Combat",Section="combat.weapon"}, {Pattern="toggle.fast.attack",Tab="Combat",Section="combat.attack"}, {Pattern="toggle.silent.aim",Tab="Combat",Section="combat.targeting"}, {Pattern="option.attack.range",Tab="Combat",Section="combat.targeting"}, {Pattern="toggle.bring.mob",Tab="Combat",Section="combat.targeting"},
            {Pattern="toggle.auto.turn.on.haki",Tab="Combat",Section="combat.abilities"}, {Pattern="toggle.auto.turn.on.spin.position",Tab="Combat",Section="combat.abilities"}, {Pattern="toggle.auto.use.skill.z.buddha",Tab="Combat",Section="combat.abilities"}, {Pattern="toggle.auto.turn.on.v3",Tab="Combat",Section="combat.abilities"}, {Pattern="toggle.auto.turn.on.v4",Tab="Combat",Section="combat.abilities"},
            {Pattern="option.auto.speed",Tab="Travel",Section="travel.movement"}, {Pattern="option.auto.jump",Tab="Travel",Section="travel.movement"}, {Pattern="toggle.turn.on.bypass.teleport",Tab="Travel",Section="travel.movement"}, {Pattern="toggle.noclip",Tab="Travel",Section="travel.movement"},
            {Pattern="fighting.style.use",Tab="Items",Section="items.fighting_styles"}, {Pattern="fighting.style.auto",Tab="Progress",Section="progress.fighting_styles"}, {Pattern="unlock.dough.dungeon",Tab="Raids",Section="raids.unlocks"}, {Pattern="unlock.phoenix.dungeon",Tab="Raids",Section="raids.unlocks"},
            {Pattern="option.stats.",Tab="Progress",Section="progress.stats"}, {Pattern="toggle.stats.",Tab="Progress",Section="progress.stats"}, {Pattern="mastery",Tab="Farm",Section="farm.mastery"},
            {Pattern="button.rejoin.server",Tab="Travel",Section="travel.servers"}, {Pattern="button.hop.server",Tab="Travel",Section="travel.servers"}, {Pattern="option.input.job.id",Tab="Travel",Section="travel.servers"}, {Pattern="button.teleport.job.id",Tab="Travel",Section="travel.servers"}, {Pattern="button.copy.job.id",Tab="Travel",Section="travel.servers"},
            {Pattern="toggle.auto.factory.raid",Tab="Events",Section="events.world"}, {Pattern="toggle.auto.pirate.raid",Tab="Events",Section="events.world"},
        },
        Sections={
            Main={ ["main.overview"]={TitleKey="presentation.sections.main_overview",Column="Left",Order=10,Icon="Home"}, ["main.active"]={TitleKey="presentation.sections.main_active",Column="Left",Order=20,Icon="Check"}, ["main.server"]={TitleKey="presentation.sections.main_server",Column="Right",Order=10,Icon="World"}, ["main.updates"]={TitleKey="presentation.sections.main_updates",Column="Right",Order=20,Icon="Info"}},
            Farm={
                ["farm.level"]={TitleKey="presentation.sections.farm_level",Column="Left",Order=10,Icon="Farm"}, ["farm.island"]={TitleKey="presentation.sections.farm_island",Column="Left",Order=20,Icon="World"}, ["farm.collection"]={TitleKey="presentation.sections.farm_collection",Column="Left",Order=30,Icon="Backpack"}, ["farm.materials"]={TitleKey="presentation.sections.farm_materials",Column="Left",Order=40,Icon="Backpack"},
                ["farm.boss"]={TitleKey="presentation.sections.farm_boss",Column="Right",Order=10,Icon="Special"}, ["farm.special"]={TitleKey="presentation.sections.farm_special",Column="Right",Order=20,Icon="Special"}, ["farm.mastery"]={TitleKey="presentation.sections.farm_mastery",Column="Right",Order=30,Icon="Weapon"}, ["farm.target"]={TitleKey="presentation.sections.farm_target",Column="Right",Order=40,Icon="CurrentTarget"},
            },
            Combat={ ["combat.weapon"]={TitleKey="presentation.sections.combat_weapon",Column="Left",Order=10,Icon="Weapon"}, ["combat.attack"]={TitleKey="presentation.sections.combat_attack",Column="Left",Order=20,Icon="Weapon"}, ["combat.targeting"]={TitleKey="presentation.sections.combat_targeting",Column="Right",Order=10,Icon="CurrentTarget"}, ["combat.abilities"]={TitleKey="presentation.sections.combat_abilities",Column="Right",Order=20,Icon="Shield"}},
            Raids={ ["raids.setup"]={TitleKey="presentation.sections.raids_setup",Column="Left",Order=10,Icon="Settings"}, ["raids.normal"]={TitleKey="presentation.sections.raids_normal",Column="Left",Order=20,Icon="Raid"}, ["raids.unlocks"]={TitleKey="presentation.sections.raids_unlocks",Column="Right",Order=10,Icon="Lock"}, ["raids.law"]={TitleKey="presentation.sections.raids_law",Column="Right",Order=20,Icon="Special"}},
            Progress={ ["progress.first_sea"]={TitleKey="presentation.sections.progress_first_sea",Column="Left",Order=10,Icon="Progress"}, ["progress.swords"]={TitleKey="presentation.sections.progress_swords",Column="Left",Order=20,Icon="Weapon"}, ["progress.fighting_styles"]={TitleKey="presentation.sections.progress_styles",Column="Right",Order=10,Icon="Weapon"}, ["progress.haki"]={TitleKey="presentation.sections.progress_haki",Column="Right",Order=20,Icon="Shield"}, ["progress.stats"]={TitleKey="presentation.sections.progress_stats",Column="Right",Order=30,Icon="Progress"}},
            Race={ ["race.v3"]={TitleKey="presentation.sections.race_v3",Column="Left",Order=10,Icon="Player"}, ["race.v4"]={TitleKey="presentation.sections.race_v4",Column="Right",Order=10,Icon="Special"}, ["race.draco"]={TitleKey="presentation.sections.race_draco",Column="Left",Order=20,Icon="Special"}},
            Items={ ["items.fruits"]={TitleKey="presentation.sections.items_fruits",Column="Left",Order=10,Icon="Items"}, ["items.fighting_styles"]={TitleKey="presentation.sections.items_styles",Column="Left",Order=20,Icon="Weapon"}, ["items.fruit_shop"]={TitleKey="presentation.sections.items_fruit_shop",Column="Right",Order=5,Icon="Backpack"}, ["items.ownership"]={TitleKey="presentation.sections.items_ownership",Column="Right",Order=10,Icon="Backpack"}},
            Shop={ ["shop.abilities"]={TitleKey="presentation.sections.shop_abilities",Column="Left",Order=10,Icon="Shield"}, ["shop.weapons"]={TitleKey="presentation.sections.shop_weapons",Column="Left",Order=20,Icon="Weapon"}, ["shop.accessories"]={TitleKey="presentation.sections.shop_accessories",Column="Right",Order=10,Icon="Backpack"}, ["shop.fragments"]={TitleKey="presentation.sections.shop_fragments",Column="Right",Order=20,Icon="Progress"}},
            Events={ ["events.fishing"]={TitleKey="presentation.sections.events_fishing",Column="Left",Order=10,Icon="World"}, ["events.world"]={TitleKey="presentation.sections.events_world",Column="Left",Order=20,Icon="Special"}, ["events.entities"]={TitleKey="presentation.sections.events_entities",Column="Left",Order=30,Icon="Special"}, ["events.mirage"]={TitleKey="presentation.sections.events_mirage",Column="Right",Order=10,Icon="World"}, ["events.sailing"]={TitleKey="presentation.sections.events_sailing",Column="Right",Order=20,Icon="Teleport"}, ["events.kitsune"]={TitleKey="presentation.sections.events_kitsune",Column="Right",Order=30,Icon="Special"}, ["events.prehistoric"]={TitleKey="presentation.sections.events_prehistoric",Column="Right",Order=40,Icon="Special"}},
            Travel={ ["travel.worlds"]={TitleKey="presentation.sections.travel_worlds",Column="Left",Order=10,Icon="World"}, ["travel.islands"]={TitleKey="presentation.sections.travel_islands",Column="Left",Order=20,Icon="Teleport"}, ["travel.npc"]={TitleKey="presentation.sections.travel_npc",Column="Left",Order=30,Icon="Player"}, ["travel.movement"]={TitleKey="presentation.sections.travel_movement",Column="Right",Order=10,Icon="Teleport"}, ["travel.player"]={TitleKey="presentation.sections.travel_player",Column="Right",Order=20,Icon="Player"}, ["travel.servers"]={TitleKey="presentation.sections.travel_servers",Column="Right",Order=30,Icon="World"}},
            System={ ["system.overview"]={TitleKey="presentation.sections.system_overview",Column="Left",Order=10,Icon="Home"}, ["system.interface"]={TitleKey="presentation.sections.system_interface",Column="Left",Order=20,Icon="Settings"}, ["system.visuals"]={TitleKey="presentation.sections.system_visuals",Column="Left",Order=30,Icon="World"}, ["system.esp"]={TitleKey="presentation.sections.system_esp",Column="Left",Order=40,Icon="Info"}, ["system.session"]={TitleKey="presentation.sections.system_session",Column="Right",Order=10,Icon="Info"}, ["system.team"]={TitleKey="presentation.sections.system_team",Column="Right",Order=20,Icon="Player"}, ["system.runtime"]={TitleKey="presentation.sections.system_runtime",Column="Right",Order=30,Icon="Settings"}, ["system.safety"]={TitleKey="presentation.sections.system_safety",Column="Right",Order=40,Icon="Shield"}, ["system.game_ui"]={TitleKey="presentation.sections.system_game_ui",Column="Right",Order=50,Icon="Settings"}, ["system.utilities"]={TitleKey="presentation.sections.system_utilities",Column="Right",Order=60,Icon="More"}, ["system.release"]={TitleKey="presentation.sections.system_release",Column="Right",Order=70,Icon="Info"}},
        },
    },
    Theme={
        Window=Color3.fromRGB(15,17,22),Header=Color3.fromRGB(20,20,27),Rail=Color3.fromRGB(16,17,22),Content=Color3.fromRGB(18,19,24),
        Surface=Color3.fromRGB(30,31,38),SurfaceRaised=Color3.fromRGB(37,39,47),SurfaceHover=Color3.fromRGB(52,38,43),
        Control=Color3.fromRGB(25,27,33),ControlHover=Color3.fromRGB(46,33,38),Divider=Color3.fromRGB(83,88,97),Stroke=Color3.fromRGB(108,114,123),
        Text=Color3.fromRGB(247,248,250),TextSoft=Color3.fromRGB(224,227,231),Muted=Color3.fromRGB(162,168,176),
        Accent=Color3.fromRGB(214,70,74),AccentStrong=Color3.fromRGB(184,54,58),AccentSoft=Color3.fromRGB(82,31,34),AccentFaint=Color3.fromRGB(54,22,25),
        Good=Color3.fromRGB(92,194,126),Warn=Color3.fromRGB(227,182,82),Bad=Color3.fromRGB(219,95,100),Info=Color3.fromRGB(141,158,255),
    },
    Breakpoints={CompactRail=820,StackWideActions=780,SingleColumn=675,IconRail=560,TinyWidth=430,TinyHeight=470},
    Window={WidthRatio=0.54,AspectRatio=1.7777778,MinWidth=640,MinHeight=360,MaxWidth=980,MaxHeight=570,Margin=12,Radius=18,HeaderHeight=52,RailWidth=176,CompactRailWidth=152,IconRailWidth=48,RailRatio=0.30,RailMin=176,RailMax=224,CompactRailMin=144,CompactRailMax=180,PageHeaderHeight=48,FloatingSize=42,MobileHeightRatio=0.78},
    Metrics={PagePad=13,ColumnGap=14,SectionGap=11,SectionRadius=12,SectionHeader=40,SectionBodyPad=8,RowDesktop=60,RowCompact=56,RowMobile=68,RowMobileStacked=104,SwitchW=42,SwitchH=24,ControlHeight=36,PopupRadius=12,ColumnBalanceTolerance=82},
    Typography={Header=14,PageTitle=19,PageSubtitle=11,Nav=12,Section=13,RowTitle=13,RowDesc=11,Meta=10,Status=10,Control=12,MobileRowTitle=13,MobileRowDesc=11},
    Motion={Fast=0.09,Normal=0.14,Slow=0.18},
    Overlay={ESP={Size=UDim2.new(1,200,1,30),Offset=Vector3.new(0,1,0),TextStrokeTransparency=0.5,Presets={Island={Font=Enum.Font.BuilderSansMedium},Fruit={Font=Enum.Font.BuilderSansMedium},Berry={Font=Enum.Font.BuilderSansMedium},Chest={Font=Enum.Font.Code},PlayerAlly={Font=Enum.Font.BuilderSansMedium},PlayerEnemy={Font=Enum.Font.BuilderSansMedium}}}},
}

local C = RE4UI.Config
local T = C.Theme
local M = C.Metrics
local TX = C.Typography

-- Centralized icon service ----------------------------------------------------
-- The legacy 126253815695177 atlas is diagnostic-only and is never part of
-- the active rendering path. Active UI icons use centralized individual sources;
-- legacy fetch state is reported separately so it cannot become a false UI-health signal.
local IconService={State="idle",Reason=nil,Source="primary",RenderingPath="individual",FetchStatus=nil,LegacyStatus=nil,LegacyInfo=nil,LegacyUsable=nil,LegacyDiagnosticStarted=false,LegacyDiagnosticCompleted=false,PrimaryFailures={},FallbackFailures={},PrimaryDiagnostics={},FallbackDiagnostics={},Tracked=setmetatable({}, {__mode="k"}),Listeners={}}
function IconService:_emit()
    for i=#self.Listeners,1,-1 do
        local listener=self.Listeners[i]
        local ok,keep=pcall(listener,self)
        if not ok or keep==false then table.remove(self.Listeners,i) end
    end
end
function IconService:_setState(state,fetchStatus,reason)
    self.State=state or self.State; self.FetchStatus=fetchStatus; self.Reason=reason
    self:_emit()
end
function IconService:OnChanged(callback)
    if type(callback)~="function" then return function() end end
    self.Listeners[#self.Listeners+1]=callback
    local active=true
    return function()
        if not active then return end; active=false
        for i=#self.Listeners,1,-1 do if self.Listeners[i]==callback then table.remove(self.Listeners,i); break end end
    end
end
local function iconName(name)
    local raw=tostring(name or ""); if raw=="" then return nil end
    if C.IconLibrary.Primary[raw] then return raw end
    local alias=C.IconLibrary.Aliases and C.IconLibrary.Aliases[raw:lower()]
    return alias and C.IconLibrary.Primary[alias] and alias or nil
end
local function iconUri(name,useFallback)
    local resolved=iconName(name) or "Info"
    local source=useFallback and C.IconLibrary.Fallback or C.IconLibrary.Primary
    local uri=source and source[resolved]
    if not uri and useFallback then uri=C.IconLibrary.Primary[resolved] end
    return resolved,uri or ""
end
local function isFetchFailure(status)
    return type(status)=="string" and status:lower():find("failure",1,true)~=nil
end
local function readFetchStatus(uri)
    local ok,value=pcall(function() return ContentProvider:GetAssetFetchStatus(uri) end)
    return ok and tostring(value) or nil
end
function IconService:_apply(image,name,useFallback)
    if typeof(image)~="Instance" then return image end
    local resolved,uri=iconUri(name,useFallback==true)
    image.Image=uri
    image.ImageRectOffset=Vector2.new()
    image.ImageRectSize=Vector2.new()
    pcall(function()
        image:SetAttribute("RE4IconName",resolved)
        image:SetAttribute("RE4IconSource",useFallback and "fallback" or "primary")
    end)
    local tracked=self.Tracked[image]
    if tracked then tracked.Name=resolved; tracked.Fallback=useFallback==true end
    return image
end
function IconService:Track(image,name)
    if typeof(image)=="Instance" then
        local resolved=iconName(name) or "Info"
        self.Tracked[image]={Name=resolved,Fallback=self.Source=="fallback"}
        self:_apply(image,resolved,self.Source=="fallback")
    end
    return image
end
function IconService:_switchAll(useFallback)
    self.Source=useFallback and "fallback" or "primary"
    for image,meta in pairs(self.Tracked) do
        if image and image.Parent then self:_apply(image,meta.Name,useFallback) end
    end
end
local function contentIdentity(value)
    local raw=tostring(value or "")
    local numeric=raw:match("(%d+)")
    return numeric or raw
end
local function probeRenderEvidence(probe)
    if typeof(probe)~="Instance" then return false,"0x0" end
    local loaded=false
    local sizeText="0x0"
    pcall(function() loaded=probe.IsLoaded==true end)
    pcall(function()
        local size=probe.ContentImageSize
        if typeof(size)=="Vector2" then
            sizeText=tostring(math.floor(size.X+0.5)).."x"..tostring(math.floor(size.Y+0.5))
            if size.X>0 and size.Y>0 then loaded=true end
        end
    end)
    return loaded,sizeText
end
local function preloadSource(source)
    local probes={}; local probeMeta={}; local uris={}
    for name,uri in pairs(source or {}) do
        if type(uri)=="string" and uri~="" and not uris[uri] then
            uris[uri]=name
            local probe=Instance.new("ImageLabel"); probe.BackgroundTransparency=1; probe.Image=uri
            probes[#probes+1]=probe; probeMeta[probe]={Name=name,Uri=uri}
        end
    end
    local callbackStatus={}
    local ok,err=pcall(function()
        ContentProvider:PreloadAsync(probes,function(assetId,status)
            callbackStatus[contentIdentity(assetId)]=tostring(status)
        end)
    end)
    -- PreloadAsync is bounded/synchronous for the submitted content. A short
    -- settle window is used only when ContentProvider says Failure but the
    -- ImageLabel may already have render evidence in Roblox's image cache.
    local mismatch=false
    for _,probe in ipairs(probes) do
        local meta=probeMeta[probe]
        local status=readFetchStatus(meta.Uri) or callbackStatus[contentIdentity(meta.Uri)]
        local loaded=probeRenderEvidence(probe)
        if isFetchFailure(status) and not loaded then mismatch=true; break end
    end
    if mismatch then
        local deadline=os.clock()+0.35
        repeat
            task.wait(0.05)
            mismatch=false
            for _,probe in ipairs(probes) do
                local meta=probeMeta[probe]
                local status=readFetchStatus(meta.Uri) or callbackStatus[contentIdentity(meta.Uri)]
                local loaded=probeRenderEvidence(probe)
                if isFetchFailure(status) and not loaded then mismatch=true; break end
            end
        until not mismatch or os.clock()>=deadline
    end
    local failures={}; local diagnostics={}
    for _,probe in ipairs(probes) do
        local meta=probeMeta[probe]
        local providerStatus=readFetchStatus(meta.Uri)
        local callback=callbackStatus[contentIdentity(meta.Uri)]
        local loaded,sizeText=probeRenderEvidence(probe)
        local failed=isFetchFailure(providerStatus) or isFetchFailure(callback)
        local usable=loaded or (ok and not failed)
        diagnostics[meta.Name]={Provider=providerStatus,Callback=callback,Loaded=loaded,ContentSize=sizeText,Usable=usable}
        if not usable then failures[meta.Name]=providerStatus or callback or tostring(err or "asset_fetch_failure") end
    end
    if not ok then failures.__preload=tostring(err) end
    for _,probe in ipairs(probes) do pcall(function() probe:Destroy() end) end
    return ok and not next(failures),failures,diagnostics,err
end
function IconService:DiagnoseLegacy()
    if self.LegacyDiagnosticStarted then return false end
    local legacy=C.IconLibrary.Legacy
    if type(legacy)~="table" or not legacy.Uri then return false end
    self.LegacyDiagnosticStarted=true
    task.spawn(function()
        local infoOk,info=pcall(function() return MarketplaceService:GetProductInfo(tonumber(legacy.Id),Enum.InfoType.Asset) end)
        if infoOk and type(info)=="table" then
            local creator=type(info.Creator)=="table" and (info.Creator.Name or info.Creator.Id) or nil
            self.LegacyInfo={Name=info.Name,AssetTypeId=info.AssetTypeId,Creator=creator,IsForSale=info.IsForSale}
        else
            self.LegacyInfo={Error=tostring(info)}
        end
        local probe=Instance.new("ImageLabel"); probe.BackgroundTransparency=1; probe.Image=legacy.Uri
        local callbackStatus=nil
        local preloadOk,preloadErr=pcall(function() ContentProvider:PreloadAsync({probe},function(_,status) callbackStatus=tostring(status) end) end)
        local providerFetch=readFetchStatus(legacy.Uri)
        local fetch=providerFetch or callbackStatus or (preloadOk and "unavailable" or tostring(preloadErr))
        local isLoaded,sizeText=probeRenderEvidence(probe)
        if not isLoaded and (isFetchFailure(providerFetch) or isFetchFailure(callbackStatus)) then
            local deadline=os.clock()+0.45
            repeat
                task.wait(0.05)
                isLoaded,sizeText=probeRenderEvidence(probe)
            until isLoaded or os.clock()>=deadline
        end
        local usable=isLoaded or (preloadOk and not isFetchFailure(providerFetch) and not isFetchFailure(callbackStatus))
        self.LegacyStatus=fetch
        self.LegacyUsable=usable
        self.LegacyDiagnosticCompleted=true
        self:_emit()
        pcall(function() probe:Destroy() end)
        local details=self.LegacyInfo or {}
        local assetTypeName="unknown"
        if tonumber(details.AssetTypeId) then
            local okTypes,items=pcall(function() return Enum.AssetType:GetEnumItems() end)
            if okTypes then for _,item in ipairs(items) do if item.Value==tonumber(details.AssetTypeId) then assetTypeName=item.Name; break end end end
        end
        local renderPath=tostring(self.RenderingPath or "individual")
        local activeSource=tostring(self.Source or "primary")
        local activeState=tostring(self.State or "idle")
        local prefix="[RE4 HUB/UI/IconLegacy] id="..tostring(legacy.Id).." uri="..tostring(legacy.Uri).." fetch="..tostring(fetch).." assetTypeId="..tostring(details.AssetTypeId or "unknown").." assetType="..tostring(assetTypeName).." name="..tostring(details.Name or "unknown").." creator="..tostring(details.Creator or "unknown").." isForSale="..tostring(details.IsForSale).." productInfoError="..tostring(details.Error or "none")
        local suffix=" usable="..tostring(usable).." providerFetch="..tostring(providerFetch or "unknown").." preloadCallback="..tostring(callbackStatus or "unknown").." preloadOk="..tostring(preloadOk).." renderPath="..renderPath.." activeSource="..activeSource.." activeState="..activeState.." contentSize="..sizeText.." phase=post_mount"
        if usable then
            print(prefix..suffix)
        elseif renderPath=="legacy" then
            warn(prefix..suffix.." severity=error")
        else
            print(prefix..suffix.." severity=diagnostic")
        end
    end)
    return true
end
function IconService:GetStatusText()
    if self.State=="ready" then return "ready · primary individual icons" end
    if self.State=="fallback" then return "ready · fallback individual icons" end
    if self.State=="failed" then return "load_failed: "..tostring(self.Reason or self.FetchStatus or "unknown") end
    if self.State=="loading" then return "loading icons" end
    return "pending"
end
function IconService:GetStatusTone()
    if self.State=="ready" or self.State=="fallback" then return "good" end
    if self.State=="failed" then return "error" end
    return "waiting"
end
function IconService:GetLegacyStatusText()
    if self.LegacyStatus==nil then return "legacy diagnostic pending" end
    local fetch=tostring(self.LegacyStatus)
    if self.LegacyUsable==true then
        return "legacy atlas reachable · not in render path"
    end
    if isFetchFailure(fetch) then
        return "legacy atlas fetch failed · active icons unaffected"
    end
    return "legacy atlas unresolved · active icons unaffected"
end
function IconService:GetLegacyTone()
    if self.LegacyStatus==nil then return "waiting" end
    if self.LegacyUsable==true then return "info" end
    if tostring(self.RenderingPath or "individual")~="legacy" then return "info" end
    return "error"
end
function IconService:Preload()
    if self.State~="idle" then return self.State end
    self:_setState("loading","Loading",nil)
    task.spawn(function()
        local primaryOk,primaryFailures,primaryDiagnostics,primaryErr=preloadSource(C.IconLibrary.Primary)
        self.PrimaryFailures=primaryFailures or {}; self.PrimaryDiagnostics=primaryDiagnostics or {}
        if primaryOk then
            self.Source="primary"; self:_setState("ready","Success",nil)
            print("[RE4 HUB/UI/Icons] primary individual icon set ready")
            return
        end
        warn("[RE4 HUB/UI/Icons] primary source incomplete; switching to bounded fallback; reason="..tostring(primaryErr or next(primaryFailures or {}) or "asset_fetch_failure"))
        self:_switchAll(true)
        local fallbackOk,fallbackFailures,fallbackDiagnostics,fallbackErr=preloadSource(C.IconLibrary.Fallback)
        self.FallbackFailures=fallbackFailures or {}; self.FallbackDiagnostics=fallbackDiagnostics or {}
        if fallbackOk then
            self:_setState("fallback","FallbackSuccess",nil)
            print("[RE4 HUB/UI/Icons] fallback individual icon set ready")
        else
            local reason=tostring(fallbackErr or next(fallbackFailures or {}) or "icon_sources_unavailable")
            self:_setState("failed","Failure",reason)
            warn("[RE4 HUB/UI/Icons] primary and fallback sources failed; reason="..tostring(self.Reason))
        end
    end)
    return self.State
end
RE4UI.IconService=IconService
local function iconImageProps(name,props)
    props=props or {}; local _,uri=iconUri(name,false)
    props.BackgroundTransparency=props.BackgroundTransparency==nil and 1 or props.BackgroundTransparency
    props.Image=uri; props.ImageRectOffset=Vector2.new(); props.ImageRectSize=Vector2.new()
    return props
end
local NavigationKeySet={}; for _,definition in ipairs(C.PresentationSchema.Tabs or {}) do if definition.Key then NavigationKeySet[tostring(definition.Key)]=true end end
local function canonicalTabKey(key) local raw=tostring(key or ""); if NavigationKeySet[raw] then return raw end; return (C.PresentationSchema.DomainDefaults and C.PresentationSchema.DomainDefaults[raw]) or raw end
local function presentationSectionSpec(tabKey,sectionId) local sections=C.PresentationSchema.Sections and C.PresentationSchema.Sections[canonicalTabKey(tabKey)]; return sections and sections[tostring(sectionId or "")] or nil end
local function sectionIconName(tabKey,sectionId,semanticIcon)
    local semantic=iconName(semanticIcon); if semantic then return semantic end
    local spec=presentationSectionSpec(tabKey,sectionId); if spec and iconName(spec.Icon) then return iconName(spec.Icon) end
    for _,definition in ipairs(C.PresentationSchema.Tabs or {}) do if definition.Key==tabKey then return iconName(definition.Icon) or "Info" end end
    return "Info"
end

-- Semantic overlay colors consume the same centralized palette as the shell.
C.Overlay.ESP.Presets.Island.Color=T.Text
C.Overlay.ESP.Presets.Fruit.Color=T.Text
C.Overlay.ESP.Presets.Berry.Color=T.Text
C.Overlay.ESP.Presets.Chest.Color=T.Warn
C.Overlay.ESP.Presets.PlayerAlly.Color=T.Good
C.Overlay.ESP.Presets.PlayerEnemy.Color=T.Bad


-- ============================================================================
-- Fixed visual theme
-- ============================================================================
-- Runtime theme switching stays disabled; every component consumes one role-based reference palette.
-- This makes future palette swaps possible without per-component color edits.

-- Stable protected helpers. These function objects are created once; hot UI paths
-- pass them directly to pcall instead of allocating an anonymous closure per call.
local function TouchInstanceParent(object) object.Parent = object.Parent end
local function SetInstanceParent(object, parent) object.Parent = parent end
local function SetInstanceProperty(object, property, value) object[property] = value end
local function DisconnectConnection(connection) connection:Disconnect() end
local function IsInstanceAlive(object)
    if typeof(object) ~= "Instance" then return false end
    -- Preserve the prior locked-Parent liveness semantics without closure churn.
    local ok=pcall(TouchInstanceParent, object)
    return ok
end

local function SafeParent(object, parent)
    if not IsInstanceAlive(object) then return false end
    -- Do not write-probe the host itself. CoreGui/gethui containers can reject
    -- writes to their own Parent property while still accepting GUI children.
    if parent ~= nil and typeof(parent) ~= "Instance" then return false end
    local ok=pcall(SetInstanceParent, object, parent)
    return ok and object.Parent==parent
end

local function New(className, props, parent)
    local object = Instance.new(className)
    for key, value in pairs(props or {}) do
        local ok, err = pcall(SetInstanceProperty, object, key, value)
        if not ok then
            warn("[RE4 HUB/UI][Property] " .. tostring(className) .. "." .. tostring(key) .. ": " .. tostring(err))
        end
    end
    if parent and not SafeParent(object, parent) then
        -- A previous RE4 shell can be destroyed while its old script is still
        -- finishing UI registration. Keep this object detached rather than
        -- throwing and aborting the rest of main.lua.
        object:SetAttribute("RE4Detached", true)
    end
    return object
end

local function Corner(parent, radius)
    return New("UICorner", {CornerRadius=UDim.new(0, radius or 8)}, parent)
end

local function Stroke(parent, transparency, color, thickness)
    return New("UIStroke", {
        Color=color or T.Stroke,
        Transparency=transparency == nil and 0.45 or transparency,
        Thickness=thickness or 1,
    }, parent)
end

local function Padding(parent, l, r, t, b)
    return New("UIPadding", {
        PaddingLeft=UDim.new(0,l or 0), PaddingRight=UDim.new(0,r or 0),
        PaddingTop=UDim.new(0,t or 0), PaddingBottom=UDim.new(0,b or 0),
    }, parent)
end

local function CreateTween(object, duration, goal)
    return TweenService:Create(
        object,
        TweenInfo.new(duration or C.Motion.Fast, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        goal
    )
end
local function Tween(object, duration, goal)
    if not object or not object.Parent then return nil end
    local ok, tween = pcall(CreateTween, object, duration, goal)
    if ok and tween then tween:Play(); return tween end
    return nil
end

local function Traceback(err)
    if debug and type(debug.traceback) == "function" then
        return debug.traceback(tostring(err), 2)
    end
    return tostring(err)
end

local function SafeCall(name, callback, ...)
    if type(callback) ~= "function" then return true end
    -- Luau xpcall forwards varargs directly. Avoid allocating an args table and
    -- anonymous dispatcher closure for every UI callback/visibility check.
    local ok, result = xpcall(callback, Traceback, ...)
    if not ok then
        warn("[RE4 HUB/UI][" .. tostring(name or "Callback") .. "] " .. tostring(result))
    end
    return ok, result
end

local function stripRichText(text)
    return tostring(text or ""):gsub("<.->", "")
end

local function toneColor(tone)
    if tone == "good" or tone == "completed" or tone == "running" or tone == "ready" or tone == "active" then return T.Good end
    if tone == "warn" or tone == "waiting" or tone == "pending" then return T.Warn end
    if tone == "bad" or tone == "error" or tone == "blocked" or tone == "failed" then return T.Bad end
    if tone == "info" then return T.Info end
    return T.Muted
end

local function normalizeText(text)
    return stripRichText(text):lower():gsub("[%p%c]", " "):gsub("%s+", " ")
end

local function MeasureText(text, size, font)
    return TextService:GetTextSize(tostring(text or ""), size or 11, font or Enum.Font.BuilderSans, Vector2.new(1000, 100))
end
local function estimateTextWidth(text, size, font)
    local ok, bounds = pcall(MeasureText, text, size, font)
    return ok and bounds.X or (#tostring(text or "") * (size or 11) * 0.55)
end

-- ============================================================================
-- Preferences + localization manager
-- ============================================================================
RE4UI._Windows = {}
RE4UI._PreferenceFile = "RE4Hub_UI_Preferences.json"
RE4UI._Preferences = nil

local function shallowCopy(source)
    local out = {}
    if type(source) == "table" then for k,v in pairs(source) do out[k]=v end end
    return out
end

local function loadPreferences()
    if type(RE4UI._Preferences) == "table" then return RE4UI._Preferences end
    local env = RE4ResolveEnvLocal()
    local prefs = type(env.__RE4UIPreferences)=="table" and shallowCopy(env.__RE4UIPreferences) or {}
    pcall(function()
        if type(isfile)=="function" and type(readfile)=="function" and isfile(RE4UI._PreferenceFile) then
            local decoded = HttpService:JSONDecode(readfile(RE4UI._PreferenceFile))
            if type(decoded)=="table" then for k,v in pairs(decoded) do prefs[k]=v end end
        end
    end)
    RE4UI._Preferences=prefs
    env.__RE4UIPreferences=prefs
    return prefs
end

local function savePreferences()
    local prefs=loadPreferences()
    local env=RE4ResolveEnvLocal()
    env.__RE4UIPreferences=prefs
    pcall(function()
        if type(writefile)=="function" then writefile(RE4UI._PreferenceFile,HttpService:JSONEncode(prefs)) end
    end)
end

function RE4UI:GetPreference(key, defaultValue)
    local value=loadPreferences()[key]
    if value==nil then return defaultValue end
    return value
end

function RE4UI:SetPreference(key, value)
    local prefs=loadPreferences()
    local current=prefs[key]
    -- Table preferences (currently Favorites) may be mutated in place by callers.
    -- Persist explicit table writes even when identity is unchanged; primitive
    -- values retain the no-op fast path to avoid unnecessary file I/O.
    if current==value and type(value)~="table" then return value end
    prefs[key]=value
    savePreferences()
    return value
end

function RE4UI:ResetPreferences()
    local currentEnv=RE4ResolveEnvLocal()
    self._Preferences={}
    currentEnv.__RE4UIPreferences=self._Preferences
    pcall(function() if type(delfile)=="function" and type(isfile)=="function" and isfile(self._PreferenceFile) then delfile(self._PreferenceFile) end end)
    if type(delfile)~="function" then pcall(function() if type(writefile)=="function" then writefile(self._PreferenceFile,"{}") end end) end
    return true
end

local EmergencyEnglish = {} -- language/en.json is the authoritative fallback catalog.

local LocalizationConfig = type(Config.Localization)=="table" and Config.Localization or {}
RE4UI._FetchText=nil
local LanguageManager = {
    Config={
        Default=tostring(LocalizationConfig.Default or "vi"),Fallback=tostring(LocalizationConfig.Fallback or "en"),Current=tostring(LocalizationConfig.Default or "vi"),
        BaseUrl="",Manifest="manifest.json",Languages=type(LocalizationConfig.Languages)=="table" and LocalizationConfig.Languages or {},
    },
    Cache={}, CurrentData=nil, FallbackData=nil, Bindings={}, Listeners={}, Loading={}, Generation=0, Active=true,
}

local function languageCacheFile(name)
    local stamp=tostring(RE4UI.LanguageRevision or RE4UI.ReleaseStamp or RE4UI.Version or "release"):gsub("[^%w_%-]","_")
    local clean=tostring(name or "data"):gsub("[^%w_%-%.]","_")
    local prefix=tostring(Config.Source and Config.Source.Cache and Config.Source.Cache.Prefix or "RE4Hub_AssetCache_")
    return prefix.."Lang_"..stamp.."_"..clean
end

local function readLanguageCache(name)
    if type(isfile)~="function" or type(readfile)~="function" then return nil end
    local file=languageCacheFile(name)
    local ok,data=pcall(function()
        if isfile(file) then return readfile(file) end
    end)
    return ok and type(data)=="string" and data~="" and data or nil
end

local function writeLanguageCache(name, raw)
    if type(writefile)~="function" or type(raw)~="string" or raw=="" then return end
    pcall(function() writefile(languageCacheFile(name),raw) end)
end

local function deleteLanguageCache(name)
    if type(delfile)~="function" then return end
    local file=languageCacheFile(name)
    pcall(function() if type(isfile)~="function" or isfile(file) then delfile(file) end end)
end

-- Decode cached JSON before trusting it. A truncated executor cache should never
-- make the hub permanently fail until the user manually deletes files.
local function loadLanguageJson(name,url)
    local raw=readLanguageCache(name)
    if raw then
        local ok,decoded=pcall(HttpService.JSONDecode,HttpService,raw)
        if ok and type(decoded)=="table" then return decoded,"disk" end
        deleteLanguageCache(name)
    end
    if type(RE4UI._FetchText)~="function" then error("Core text fetch service is unavailable") end
    raw=select(1,RE4UI._FetchText(url,"language:"..tostring(name)))
    local decoded=HttpService:JSONDecode(raw)
    if type(decoded)~="table" then error("language JSON must decode to a table") end
    writeLanguageCache(name,raw)
    return decoded,"network"
end

local function nestedGet(root,key)
    if type(root)~="table" or type(key)~="string" then return nil end
    if root[key]~=nil then return root[key] end
    local parts={}; for part in key:gmatch("[^%.]+") do parts[#parts+1]=part end
    local node=root; local index=1
    while index<=#parts do
        if type(node)~="table" then return nil end
        local found,nextNode,nextIndex=false,nil,nil
        for finish=#parts,index,-1 do
            local candidate=table.concat(parts,".",index,finish)
            if node[candidate]~=nil then found=true; nextNode=node[candidate]; nextIndex=finish+1; break end
        end
        if not found then return nil end
        node=nextNode; index=nextIndex
    end
    return node
end

local function interpolate(text, params)
    text=tostring(text or "")
    if type(params)~="table" then return text end
    return (text:gsub("{([%w_]+)}",function(key)
        local value=params[key]
        return value==nil and ("{"..key.."}") or tostring(value)
    end))
end

function LanguageManager:Configure(options)
    self.Generation=(tonumber(self.Generation) or 0)+1; self.Active=true
    options=type(options)=="table" and options or {}
    for k,v in pairs(options) do self.Config[k]=v end
    if type(self.Config.Languages)~="table" then self.Config.Languages={vi="Tiếng Việt",en="English"} end
    self.Config.Current=tostring(self.Config.Current or self.Config.Default or "vi")
end

function LanguageManager:_baseUrl(fileName)
    local base=tostring(self.Config.BaseUrl or "")
    if base=="" then return nil end
    if base:sub(-1)~="/" then base=base.."/" end
    return base..tostring(fileName or "").."?v="..tostring(RE4UI.LanguageRevision or RE4UI.ReleaseStamp)
end

function LanguageManager:LoadManifest()
    if self.Active~=true then return false,"language_manager_shutdown" end
    local generation=tonumber(self.Generation) or 0
    local fileName=self.Config.Manifest or "manifest.json"
    local url=self:_baseUrl(fileName)
    if not url then return false,"language BaseUrl is not configured" end
    local ok,result=xpcall(function()
        local decoded=loadLanguageJson(fileName,url)
        if type(decoded)~="table" then error("language manifest must decode to a table") end
        if type(decoded.languages)~="table" then error("language manifest is missing languages[]") end
        if decoded.version and tostring(decoded.version)~=tostring(RE4UI.Version) then
            warn("[RE4 HUB/Lang/Manifest] version mismatch: "..tostring(decoded.version).." != "..tostring(RE4UI.Version))
        end
        local languages={}
        for _,entry in ipairs(decoded.languages) do
            if type(entry)=="table" and type(entry.code)=="string" and entry.code~="" and type(entry.name)=="string" and entry.name~="" then
                languages[entry.code]=entry.name
            end
        end
        if next(languages)==nil then error("language manifest contains no valid languages") end
        self.Config.Languages=languages
        if type(decoded.default)=="string" and languages[decoded.default] then self.Config.Default=decoded.default end
        if type(decoded.fallback)=="string" and languages[decoded.fallback] then self.Config.Fallback=decoded.fallback end
        return decoded
    end,Traceback)
    if not ok then
        if self.Active==true and (tonumber(self.Generation) or 0)==generation then warn("[RE4 HUB/Lang/Manifest] "..tostring(result)) end
        return false,result
    end
    if self.Active~=true or (tonumber(self.Generation) or 0)~=generation then return false,"language_generation_stale" end
    self.ManifestData=result
    return true,result
end

function LanguageManager:_url(code)
    return self:_baseUrl(tostring(code)..".json")
end

function LanguageManager:Load(code)
    if self.Active~=true then return nil,"language_manager_shutdown" end
    local generation=tonumber(self.Generation) or 0
    code=tostring(code or "")
    if code=="" then return nil,"invalid language code" end
    if type(self.Cache[code])=="table" then return self.Cache[code] end
    if self.Loading[code] then return nil,"language already loading" end
    self.Loading[code]=true
    local url=self:_url(code)
    local ok,result=xpcall(function()
        if not url then error("language BaseUrl is not configured") end
        local cacheName=tostring(code)..".json"
        local decoded=loadLanguageJson(cacheName,url)
        if type(decoded)~="table" then error("language JSON must decode to a table") end
        if decoded._meta~=nil and type(decoded._meta)~="table" then error("language _meta must be a table") end
        if decoded.legacy~=nil and type(decoded.legacy)~="table" then error("language legacy must be a table") end
        if decoded.nav~=nil and type(decoded.nav)~="table" then error("language nav must be a table") end
        if decoded.ui~=nil and type(decoded.ui)~="table" then error("language ui must be a table") end
        if decoded._meta and decoded._meta.code and tostring(decoded._meta.code)~=code then
            warn("[RE4 HUB/Lang] language metadata code mismatch: "..tostring(decoded._meta.code).." != "..code)
        end
        if decoded._meta and decoded._meta.version and tostring(decoded._meta.version)~=tostring(RE4UI.Version) then
            warn("[RE4 HUB/Lang]["..code.."] version mismatch: "..tostring(decoded._meta.version).." != "..tostring(RE4UI.Version))
        end
        return decoded
    end,Traceback)
    if (tonumber(self.Generation) or 0)==generation then self.Loading[code]=nil end
    if not ok then
        if self.Active==true and (tonumber(self.Generation) or 0)==generation then warn("[RE4 HUB/Lang]["..code.."] "..tostring(result)) end
        return nil,result
    end
    if self.Active~=true or (tonumber(self.Generation) or 0)~=generation then return nil,"language_generation_stale" end
    self.Cache[code]=result
    return result
end

function LanguageManager:Get(key, params, fallback)
    local value=nestedGet(self.CurrentData,key)
    if value==nil then value=nestedGet(self.FallbackData,key) end
    if value==nil then value=nestedGet(EmergencyEnglish,key) end
    if value==nil then value=fallback or key end
    if type(value)~="string" and type(value)~="number" then value=fallback or key end
    return interpolate(value,params)
end

function LanguageManager:Legacy(source, params)
    source=tostring(source or "")
    local value=nil
    if type(self.CurrentData)=="table" and type(self.CurrentData.legacy)=="table" then value=self.CurrentData.legacy[source] end
    if value==nil and type(self.FallbackData)=="table" and type(self.FallbackData.legacy)=="table" then value=self.FallbackData.legacy[source] end
    return interpolate(value==nil and source or value,params)
end

function LanguageManager:Resolve(key, source, params)
    if type(key)=="string" and key~="" then return self:Get(key,params,source) end
    return self:Legacy(source,params)
end

function LanguageManager:Bind(instance, property, key, fallback, paramsProvider, legacy)
    if not instance then return nil end
    local binding={Instance=instance,Property=property or "Text",Key=key,Fallback=fallback,ParamsProvider=paramsProvider,Legacy=legacy==true}
    self.Bindings[#self.Bindings+1]=binding
    self:_applyBinding(binding)
    return binding
end

function LanguageManager:_applyBinding(binding)
    local instance=binding.Instance
    if not instance or not instance.Parent then return false end
    local params=type(binding.ParamsProvider)=="function" and binding.ParamsProvider() or nil
    local value=binding.Legacy and self:Legacy(binding.Fallback,params) or self:Get(binding.Key,params,binding.Fallback)
    pcall(SetInstanceProperty,instance,binding.Property,value)
    return true
end

function LanguageManager:RefreshBindings()
    local alive={}
    for _,binding in ipairs(self.Bindings) do
        if self:_applyBinding(binding) then alive[#alive+1]=binding end
    end
    self.Bindings=alive
end

function LanguageManager:SetLanguage(code)
    if self.Active~=true then return false,"language_manager_shutdown" end
    local generation=tonumber(self.Generation) or 0
    local requested=tostring(code or self.Config.Default or "vi")
    local fallbackCode=tostring(self.Config.Fallback or "en")

    -- Fast path: load the requested language first. Previous releases always
    -- downloaded English before Vietnamese/Thai/Indonesian, adding an avoidable
    -- synchronous network round-trip to every cold start.
    local data=self:Load(requested)
    local exact=data~=nil
    local applied=requested
    if not data then
        if not self.FallbackData then self.FallbackData=self:Load(fallbackCode) end
        if requested~=fallbackCode then data=self.FallbackData; applied=fallbackCode end
        if not data then data=EmergencyEnglish; applied="en" end
    elseif requested==fallbackCode then
        self.FallbackData=data
    end

    if self.Active~=true or (tonumber(self.Generation) or 0)~=generation then return false,"language_generation_stale" end
    self.CurrentData=data
    self.Config.Current=applied
    RE4UI:SetPreference("language",applied)
    self:RefreshBindings()
    for _,callback in ipairs(self.Listeners) do SafeCall("LanguageChanged",callback,applied,requested,exact) end

    -- Warm the fallback after the requested language is already active. This keeps
    -- missing-key behavior intact without blocking first paint.
    if exact and requested~=fallbackCode and not self.FallbackData then
        local generation=self.Generation
        task.delay(tonumber(self.Config.ManifestDelay) or 0,function()
            if not self.Active or self.Generation~=generation then return end
            if not self.FallbackData then self.FallbackData=self:Load(fallbackCode) end
        end)
    end
    return exact,applied
end

function LanguageManager:OnChanged(callback)
    if type(callback)=="function" then self.Listeners[#self.Listeners+1]=callback end
    return callback
end

function LanguageManager:OffChanged(callback)
    if type(callback)~="function" then return false end
    for index=#self.Listeners,1,-1 do
        if self.Listeners[index]==callback then table.remove(self.Listeners,index) end
    end
    return true
end

function LanguageManager:PruneBindings()
    local alive={}
    for _,binding in ipairs(self.Bindings or {}) do
        local instance=binding and binding.Instance
        if instance and instance.Parent then alive[#alive+1]=binding end
    end
    self.Bindings=alive
    return #alive
end


function LanguageManager:Shutdown()
    self.Generation=(tonumber(self.Generation) or 0)+1; self.Active=false
    self.Bindings={}; self.Listeners={}; self.Loading={}
end

function LanguageManager:GetLanguageOptions()
    local out={}
    for code,name in pairs(self.Config.Languages or {}) do out[#out+1]={Code=code,Name=name} end
    table.sort(out,function(a,b) return a.Code<b.Code end)
    return out
end

RE4UI.Language=LanguageManager
function RE4UI:ConfigureLocalization(options) LanguageManager:Configure(options) return LanguageManager end
function RE4UI:LoadLanguageManifest() return LanguageManager:LoadManifest() end
function RE4UI:SetLanguage(code) return LanguageManager:SetLanguage(code) end
function RE4UI:GetLanguage() return LanguageManager.Config.Current end
function RE4UI:T(key, params, fallback) return LanguageManager:Get(key,params,fallback) end
function RE4UI:OnLanguageChanged(callback) return LanguageManager:OnChanged(callback) end
function RE4UI:GetLanguageOptions() return LanguageManager:GetLanguageOptions() end

local function tr(key, fallback, params) return LanguageManager:Get(key,params,fallback) end
local function localizeLegacy(source, params) return LanguageManager:Legacy(source,params) end
local function bindKey(instance,key,fallback,property,paramsProvider) return LanguageManager:Bind(instance,property or "Text",key,fallback,paramsProvider,false) end
local function bindLegacy(instance,source,property,paramsProvider) return LanguageManager:Bind(instance,property or "Text",nil,source,paramsProvider,true) end

-- ============================================================================
-- Ownership adapter
-- ============================================================================
local NullOwnership = {Has=function() return false end, IsEquipped=function() return false end, ResolveState=function() return {Code="unknown",Owned=false,Exact=false} end, Register=function() end}
function RE4UI:SetOwnershipProvider(provider)
    self.OwnershipProvider = type(provider) == "table" and provider or nil
end
local function Ownership()
    return RE4UI.OwnershipProvider or NullOwnership
end
local function ownershipState(provider,itemKey)
    if provider and type(provider.ResolveState)=="function" then
        local ok,state=pcall(provider.ResolveState,provider,itemKey,false)
        if ok and type(state)=="table" then return state end
    end
    local owned=provider and type(provider.Has)=="function" and provider:Has(itemKey) or false
    return {Code=owned and "owned" or "not_owned",Owned=owned,Exact=true}
end
local function renderOwnershipStatus(control,state,running)
    if running then control:SetStatus(tr("status.running"),"running"); return end
    local code=tostring(state and state.Code or "unknown")
    if code=="owned" then control:SetStatus(tr("status.owned"),"completed")
    elseif code=="can_buy" then control:SetStatus(tr("status.can_buy"),"info")
    elseif code=="blocked" then control:SetStatus(tr("status.requirements_missing"),"blocked")
    elseif code=="not_owned" then control:SetStatus(tr("status.not_owned"),"warn")
    elseif code=="variant_unconfirmed" then control:SetStatus(tr("status.v2_unconfirmed"),"waiting")
    else control:SetStatus(tr("status.unknown"),"waiting") end
end

-- ============================================================================
-- Centralized input router: one global InputChanged/InputEnded pair per window.
-- ============================================================================
local function createInputManager(window)
    local manager = {Drag=nil, Slider=nil, Connections={}}

    function manager:BeginDrag(input, startPos, apply, ended)
        self.Drag = {
            Type=input.UserInputType,
            Start=input.Position,
            StartPos=startPos,
            Apply=apply,
            Ended=ended,
            Moved=false,
        }
    end

    function manager:BeginSlider(input, setter)
        self.Slider = {Type=input.UserInputType, Setter=setter}
        setter(input.Position.X)
    end

    manager.Connections[#manager.Connections+1] = UserInputService.InputChanged:Connect(function(input)
        local d = manager.Drag
        if d and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - d.Start
            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then d.Moved = true end
            SafeCall("Input/Drag", d.Apply, delta)
        end
        local s = manager.Slider
        if s and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            SafeCall("Input/Slider", s.Setter, input.Position.X)
        end
    end)

    manager.Connections[#manager.Connections+1] = UserInputService.InputEnded:Connect(function(input)
        local d = manager.Drag
        if d and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            manager.Drag = nil
            SafeCall("Input/DragEnd", d.Ended, d.Moved)
        end
        if manager.Slider and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            manager.Slider = nil
        end
    end)

    function manager:Destroy()
        for _, c in ipairs(self.Connections) do pcall(DisconnectConnection,c) end
        self.Connections = {}
        self.Drag = nil
        self.Slider = nil
    end

    return manager
end

-- ============================================================================
-- Overlay / popup manager
-- ============================================================================
local function createOverlayManager(window, gui)
    local manager = {Active=nil}

    function manager:Close()
        if self.Active then
            local active = self.Active
            self.Active = nil
            if active.Close then SafeCall("PopupClose", active.Close) end
            if active.Frame and active.Frame.Parent then active.Frame:Destroy() end
            if active.Blocker and active.Blocker.Parent then active.Blocker:Destroy() end
        end
    end

    function manager:CreateBlocker(z)
        local blocker = New("TextButton", {
            Size=UDim2.fromScale(1,1), Position=UDim2.fromScale(0,0),
            BackgroundTransparency=1, Text="", AutoButtonColor=false,
            ZIndex=z or 800,
        }, gui)
        blocker.MouseButton1Click:Connect(function() manager:Close() end)
        return blocker
    end

    function manager:Set(frame, blocker, closeFn)
        self:Close()
        self.Active = {Frame=frame, Blocker=blocker, Close=closeFn}
    end

    return manager
end

-- ============================================================================
-- Shared control helpers
-- ============================================================================
local function createText(parent, props)
    local base = {
        BackgroundTransparency=1,
        BorderSizePixel=0,
        Font=Enum.Font.BuilderSans,
        TextColor3=T.Text,
        TextSize=TX.RowDesc,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center,
    }
    for k,v in pairs(props or {}) do base[k]=v end
    return New("TextLabel", base, parent)
end

local function createDivider(parent)
    return New("Frame", {
        Size=UDim2.new(1, -24, 0, 1),
        Position=UDim2.new(0, 12, 1, -1),
        BackgroundColor3=T.Divider,
        BackgroundTransparency=0.78,
        BorderSizePixel=0,
        ZIndex=4,
    }, parent)
end

local function createStatusPill(parent)
    local pill = New("TextLabel", {
        BackgroundColor3=T.Control,
        BackgroundTransparency=0.82,
        BorderSizePixel=0,
        Font=Enum.Font.BuilderSansMedium,
        Text="",
        TextColor3=T.Muted,
        TextSize=TX.Status,
        TextXAlignment=Enum.TextXAlignment.Center,
        Visible=false,
        ZIndex=6,
    }, parent)
    Corner(pill, 999)
    return pill
end

local function createSwitch(parent, initial)
    local track = New("TextButton", {
        Size=UDim2.fromOffset(M.SwitchW, M.SwitchH),
        BackgroundColor3=initial and T.Accent or T.Control,
        BorderSizePixel=0,
        Text="",
        AutoButtonColor=false,
        ZIndex=7,
    }, parent)
    Corner(track, M.SwitchH)
    Stroke(track, 0.70, initial and T.AccentStrong or T.Stroke)
    local knobSize=math.max(10,M.SwitchH-6)
    local inset=math.floor(M.SwitchH/2)
    local knob = New("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5),
        Size=UDim2.fromOffset(knobSize,knobSize),
        Position=initial and UDim2.new(1,-inset,0.5,0) or UDim2.new(0,inset,0.5,0),
        BackgroundColor3=T.Text,
        BorderSizePixel=0,
        ZIndex=8,
    }, track)
    Corner(knob, knobSize)
    return track, knob
end

-- ============================================================================
-- Window
-- ============================================================================
function RE4UI:MakeWindow(options)
    options=options or {}
    local playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui"); local hosts,seen={},{ }
    local function addHost(label,host) if typeof(host)=="Instance" and not seen[host] then seen[host]=true; hosts[#hosts+1]={Label=label,Instance=host} end end
    if type(gethui)=="function" then local ok,hui=pcall(gethui); if ok then addHost("gethui",hui) end end
    addHost("PlayerGui",playerGui); local okCore,coreGui=pcall(function() return game:GetService("CoreGui") end); if okCore then addHost("CoreGui",coreGui) end
    if #hosts==0 then playerGui=LocalPlayer:WaitForChild("PlayerGui",Config.UI.Timing.HostResolveTimeout); addHost("PlayerGui",playerGui) end
    if #hosts==0 then error("[RE4 HUB/UI] no compatible GUI host is available") end
    for _,entry in ipairs(hosts) do for _,name in ipairs({"RE4HubV4","RE4HubV5","RE4Hub","Re4Hub","RE4HubNext"}) do local old=entry.Instance:FindFirstChild(name); if old then pcall(function() old:Destroy() end) end end end
    local gui=New("ScreenGui",{Name="RE4HubNext",ResetOnSpawn=false,IgnoreGuiInset=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=999999}); local mounted=nil
    for _,entry in ipairs(hosts) do if SafeParent(gui,entry.Instance) then mounted=entry.Label break end end
    if not mounted then pcall(function() gui:Destroy() end); error("[RE4 HUB/UI] ScreenGui mount failed") end
    print("[RE4 HUB/BOOT] UI mounted via "..tostring(mounted).."; presentation=next-shell"); IconService:Preload()

    local window={Gui=gui,Tabs={},TabsByKey={},Features={},FeatureById={},ActiveTab=nil,Context={},Alive=true,Generation=1,UserScale=1,CompactDensity=false,ReducedMotion=false,SingleColumn=false,IconRail=false,RailWidth=C.Window.RailWidth,UserDragged=false,_connections={},_delayedTasks={},_languageListeners={},_cleanupCallbacks={},_toastOrder=0}
    function window:_isAlive(generation) return self.Alive==true and (generation==nil or generation==self.Generation) and self.Gui and self.Gui.Parent~=nil end
    function window:_connect(signal,callback) if not signal or type(callback)~="function" then return nil end; local c=signal:Connect(callback); self._connections[#self._connections+1]=c; return c end
    function window:_defer(callback) if type(callback)~="function" then return false end; local g=self.Generation; task.defer(function() if self:_isAlive(g) then callback() end end); return true end
    function window:_delay(seconds,callback) if type(callback)~="function" then return false end; local g=self.Generation; local h; h=task.delay(tonumber(seconds) or 0,function() if h then self._delayedTasks[h]=nil end; if self:_isAlive(g) then callback() end end); if h then self._delayedTasks[h]=true end; return h or true end
    function window:_registerCleanup(callback) if type(callback)~="function" then return false end; self._cleanupCallbacks[#self._cleanupCallbacks+1]=callback; return true end
    function window:_listenLanguage(callback) if type(callback)~="function" then return nil end; local listener; listener=function() if not self:_isAlive() then return end; local ok,keep=SafeCall("LanguageChanged",callback); if ok and keep==false then LanguageManager:OffChanged(listener) end end; self._languageListeners[#self._languageListeners+1]=listener; LanguageManager:OnChanged(listener); return listener end
    window.Input=createInputManager(window); window.Overlay=createOverlayManager(window,gui)

    local main=New("Frame",{Name="Shell",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=T.Window,BackgroundTransparency=0.20,BorderSizePixel=0,ClipsDescendants=true,Active=true,ZIndex=10},gui); Corner(main,C.Window.Radius); Stroke(main,0.42,T.Stroke); local mainScale=New("UIScale",{Scale=1},main); window.Main=main; window.MainScale=mainScale
    local floating=New("ImageButton",{Name="RE4FloatingLogo",AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,12,1,-12),Size=UDim2.fromOffset(C.Window.FloatingSize,C.Window.FloatingSize),BackgroundColor3=T.Header,BackgroundTransparency=0.16,BorderSizePixel=0,Image=C.Assets.Logo,ScaleType=Enum.ScaleType.Fit,AutoButtonColor=false,ZIndex=1500},gui); Corner(floating,11); Stroke(floating,0.36,T.AccentStrong); window.FloatingLogo=floating

    -- Compact application bar: branding and session context are left-weighted;
    -- search/window actions are right-weighted so the center can breathe.
    local header=New("Frame",{Name="Header",Size=UDim2.new(1,0,0,C.Window.HeaderHeight),BackgroundColor3=T.Header,BackgroundTransparency=0.22,BorderSizePixel=0,Active=true,ZIndex=20},main)
    New("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,1),BackgroundColor3=T.Divider,BackgroundTransparency=0.52,BorderSizePixel=0,ZIndex=21},header)
    local brand=New("ImageLabel",{Position=UDim2.fromOffset(12,10),Size=UDim2.fromOffset(136,30),BackgroundTransparency=1,Image=C.Assets.Header,ScaleType=Enum.ScaleType.Fit,ZIndex=22},header)
    New("Frame",{Position=UDim2.fromOffset(158,13),Size=UDim2.fromOffset(1,24),BackgroundColor3=T.Divider,BackgroundTransparency=0.42,BorderSizePixel=0,ZIndex=22},header)
    local contextPill=New("Frame",{Position=UDim2.fromOffset(170,11),Size=UDim2.fromOffset(96,30),BackgroundColor3=T.Control,BackgroundTransparency=0.42,BorderSizePixel=0,ZIndex=22},header); Corner(contextPill,8); Stroke(contextPill,0.76,T.Stroke)
    IconService:Track(New("ImageLabel",iconImageProps("World",{Position=UDim2.fromOffset(8,6),Size=UDim2.fromOffset(14,14),ImageColor3=T.Accent,ScaleType=Enum.ScaleType.Fit,ZIndex=23}),contextPill),"World")
    local contextText=createText(contextPill,{Position=UDim2.fromOffset(27,0),Size=UDim2.new(1,-32,1,0),Text=tostring(options.SeaName or tr("sea.unknown")),Font=Enum.Font.BuilderSansMedium,TextSize=TX.Control,TextColor3=T.TextSoft,ZIndex=23,TextTruncate=Enum.TextTruncate.AtEnd})
    local runtimePill=New("Frame",{Position=UDim2.fromOffset(272,11),Size=UDim2.fromOffset(110,30),BackgroundColor3=T.Control,BackgroundTransparency=0.44,BorderSizePixel=0,ZIndex=22},header); Corner(runtimePill,8); Stroke(runtimePill,0.80,T.Stroke)
    local runtimeDot=New("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,9,0.5,0),Size=UDim2.fromOffset(7,7),BackgroundColor3=T.Good,BorderSizePixel=0,ZIndex=23},runtimePill); Corner(runtimeDot,99)
    local runtimeText=createText(runtimePill,{Position=UDim2.fromOffset(24,0),Size=UDim2.new(1,-30,1,0),Text=tr("ui.ready"),Font=Enum.Font.BuilderSansMedium,TextSize=TX.Control,TextColor3=T.TextSoft,ZIndex=23,TextTruncate=Enum.TextTruncate.AtEnd})

    local function smallHeaderButton(offset,iconName)
        local b=New("TextButton",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,offset,0,10),Size=UDim2.fromOffset(32,32),BackgroundColor3=T.Control,BackgroundTransparency=0.42,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=24},header); Corner(b,8); Stroke(b,0.74,T.Stroke)
        IconService:Track(New("ImageLabel",iconImageProps(iconName,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(14,14),ImageColor3=T.TextSoft,ScaleType=Enum.ScaleType.Fit,ZIndex=25}),b),iconName)
        return b
    end
    local searchButton=New("TextButton",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-86,0,10),Size=UDim2.fromOffset(206,32),BackgroundColor3=T.Control,BackgroundTransparency=0.42,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=24},header); Corner(searchButton,8); Stroke(searchButton,0.74,T.Stroke)
    local searchIcon=IconService:Track(New("ImageLabel",iconImageProps("Search",{Position=UDim2.fromOffset(9,7),Size=UDim2.fromOffset(14,14),ImageColor3=T.Muted,ScaleType=Enum.ScaleType.Fit,ZIndex=25}),searchButton),"Search")
    local searchText=createText(searchButton,{Position=UDim2.fromOffset(30,0),Size=UDim2.new(1,-38,1,0),Text=tr("ui.search_hint"),Font=Enum.Font.BuilderSans,TextSize=TX.Control,TextColor3=T.Muted,ZIndex=25,TextTruncate=Enum.TextTruncate.AtEnd})
    local minimizeButton=smallHeaderButton(-42,"Minimize"); local closeButton=smallHeaderButton(-10,"Close")

    -- Navigation is intentionally narrow. Labels remain visible on normal
    -- desktop/tablet widths and collapse only when the viewport actually needs it.
    local rail=New("Frame",{Position=UDim2.fromOffset(0,C.Window.HeaderHeight),Size=UDim2.new(0,C.Window.RailWidth,1,-C.Window.HeaderHeight),BackgroundColor3=T.Rail,BackgroundTransparency=0.34,BorderSizePixel=0,ZIndex=16},main)
    New("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=T.Divider,BackgroundTransparency=0.58,BorderSizePixel=0,ZIndex=17},rail)
    local navScroll=New("ScrollingFrame",{Position=UDim2.fromOffset(7,8),Size=UDim2.new(1,-14,1,-32),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.Stroke,ZIndex=18},rail)
    New("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},navScroll)
    local versionLabel=createText(rail,{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,8,1,-5),Size=UDim2.new(1,-16,0,16),Text="v"..tostring(RE4UI.Version),Font=Enum.Font.BuilderSans,TextSize=TX.Meta,TextColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=18})

    local content=New("Frame",{Position=UDim2.fromOffset(C.Window.RailWidth,C.Window.HeaderHeight),Size=UDim2.new(1,-C.Window.RailWidth,1,-C.Window.HeaderHeight),BackgroundColor3=T.Content,BackgroundTransparency=0.28,BorderSizePixel=0,ZIndex=14},main)
    local pageHeader=New("Frame",{Size=UDim2.new(1,0,0,C.Window.PageHeaderHeight),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=15},content)
    local pageIconShell=New("Frame",{Position=UDim2.fromOffset(M.PagePad,9),Size=UDim2.fromOffset(30,30),BackgroundColor3=T.AccentFaint,BackgroundTransparency=0.18,BorderSizePixel=0,ZIndex=16},pageHeader); Corner(pageIconShell,8); Stroke(pageIconShell,0.78,T.AccentStrong)
    local pageIcon=IconService:Track(New("ImageLabel",iconImageProps("Farm",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(15,15),ImageColor3=T.Accent,ScaleType=Enum.ScaleType.Fit,ZIndex=17}),pageIconShell),"Farm")
    local pageTitle=createText(pageHeader,{Position=UDim2.fromOffset(M.PagePad+44,4),Size=UDim2.new(1,-(M.PagePad*2+132),0,24),Text=tr("nav.farm"),Font=Enum.Font.BuilderSansBold,TextSize=TX.PageTitle,TextColor3=T.Text,ZIndex=16,TextTruncate=Enum.TextTruncate.AtEnd})
    local pageSubtitle=createText(pageHeader,{Position=UDim2.fromOffset(M.PagePad+44,26),Size=UDim2.new(1,-(M.PagePad*2+132),0,17),Text=tr("page.farm"),Font=Enum.Font.BuilderSans,TextSize=TX.PageSubtitle,TextColor3=T.Muted,ZIndex=16,TextTruncate=Enum.TextTruncate.AtEnd})
    local pageCount=createText(pageHeader,{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-M.PagePad,0.5,0),Size=UDim2.fromOffset(94,22),Text="",Font=Enum.Font.BuilderSansMedium,TextSize=TX.Meta,TextColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=16})
    local pages=New("Frame",{Position=UDim2.fromOffset(0,C.Window.PageHeaderHeight),Size=UDim2.new(1,0,1,-C.Window.PageHeaderHeight),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,ZIndex=14},content)
    local toastRoot=New("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,12),Size=UDim2.fromOffset(286,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1600},gui); New("UIListLayout",{Padding=UDim.new(0,6),HorizontalAlignment=Enum.HorizontalAlignment.Right,SortOrder=Enum.SortOrder.LayoutOrder},toastRoot)
    window.Rail=rail; window.NavScroll=navScroll; window.Content=content; window.Pages=pages; window.PageTitle=pageTitle; window.PageSubtitle=pageSubtitle; window.PageCount=pageCount; window.PageIcon=pageIcon

    local function setHover(button,normal,hover)
        button.MouseEnter:Connect(function() if button.Parent and button:GetAttribute("RE4Locked")~=true then Tween(button,C.Motion.Fast,{BackgroundColor3=hover}) end end)
        button.MouseLeave:Connect(function() if button.Parent then local base=button:GetAttribute("RE4Selected")==true and T.AccentFaint or normal; Tween(button,C.Motion.Fast,{BackgroundColor3=base}) end end)
    end
    for _,b in ipairs({searchButton,minimizeButton,closeButton}) do setHover(b,T.Control,T.SurfaceHover) end
    function window:_viewport() local camera=Workspace.CurrentCamera; return camera and camera.ViewportSize or Vector2.new(1280,720) end
    function window:_clampFrame(frame) if not frame or not frame.Parent then return end; local v=self:_viewport(); local size=frame.AbsoluteSize; local x=math.clamp(frame.AbsolutePosition.X,0,math.max(0,v.X-size.X)); local y=math.clamp(frame.AbsolutePosition.Y,0,math.max(0,v.Y-size.Y)); frame.AnchorPoint=Vector2.new(0,0); frame.Position=UDim2.fromOffset(x,y) end
    function window:_applyResponsive(recenter)
        if not self:_isAlive() then return end
        local v=self:_viewport(); local scale=math.clamp(tonumber(self.UserScale) or 1,0.82,1.12); mainScale.Scale=scale
        local aw=math.max(300,(v.X-C.Window.Margin*2)/scale); local ah=math.max(320,(v.Y-C.Window.Margin*2)/scale)
        local landscape=(v.X>=760 and (v.X/math.max(1,v.Y))>=1.15)
        local w,h
        if landscape then
            w=math.min(math.clamp(v.X*C.Window.WidthRatio/scale,C.Window.MinWidth,C.Window.MaxWidth),aw)
            h=w/C.Window.AspectRatio
            if h>ah then h=ah; w=math.min(w,h*C.Window.AspectRatio) end
            if h<C.Window.MinHeight and ah>=C.Window.MinHeight then h=C.Window.MinHeight; w=math.min(aw,h*C.Window.AspectRatio) end
            h=math.min(h,C.Window.MaxHeight,ah)
        else
            -- Portrait/small screens deliberately relax 16:9. A rigid landscape
            -- aspect would make a one-column interface unusably short.
            w=math.min(aw,math.max(320,v.X*0.92/scale))
            h=math.min(ah,math.max(400,v.Y*C.Window.MobileHeightRatio/scale))
        end
        w=math.floor(w+0.5); h=math.floor(h+0.5); main.Size=UDim2.fromOffset(w,h)
        self.SingleColumn=(w<C.Breakpoints.SingleColumn) or not landscape
        self.IconRail=w<C.Breakpoints.IconRail
        local railW
        if self.IconRail then
            railW=C.Window.IconRailWidth
        elseif w<C.Breakpoints.CompactRail then
            railW=math.floor(math.clamp(w*(tonumber(C.Window.RailRatio) or 0.30),tonumber(C.Window.CompactRailMin) or C.Window.CompactRailWidth,tonumber(C.Window.CompactRailMax) or C.Window.CompactRailWidth)+0.5)
        else
            railW=math.floor(math.clamp(w*(tonumber(C.Window.RailRatio) or 0.30),tonumber(C.Window.RailMin) or C.Window.RailWidth,tonumber(C.Window.RailMax) or C.Window.RailWidth)+0.5)
        end
        self.RailWidth=railW
        rail.Size=UDim2.new(0,railW,1,-C.Window.HeaderHeight); content.Position=UDim2.fromOffset(railW,C.Window.HeaderHeight); content.Size=UDim2.new(1,-railW,1,-C.Window.HeaderHeight)
        contextPill.Visible=w>=610; runtimePill.Visible=w>=800
        local fullSearch=w>=850
        searchText.Visible=fullSearch
        searchButton.Size=fullSearch and UDim2.fromOffset(206,32) or UDim2.fromOffset(32,32)
        searchIcon.Position=fullSearch and UDim2.fromOffset(9,8) or UDim2.fromOffset(8,8)
        for _,tab in ipairs(self.Tabs) do tab:_applyResponsive() end
        if recenter==true or not self.UserDragged then main.AnchorPoint=Vector2.new(0.5,0.5); main.Position=UDim2.fromScale(0.5,0.5) else self:_clampFrame(main) end
        self:RefreshVisibility(true)
    end
    function window:SetScale(value) self.UserScale=math.clamp(tonumber(value) or 1,0.82,1.12); RE4UI:SetPreference("uiScale",self.UserScale); self:_applyResponsive(false); return self.UserScale end
    function window:SetCompactDensity(enabled) self.CompactDensity=enabled==true; RE4UI:SetPreference("compactDensity",self.CompactDensity); for _,tab in ipairs(self.Tabs) do tab:_applyResponsive() end; return self.CompactDensity end
    function window:SetReducedMotion(enabled) self.ReducedMotion=enabled==true; RE4UI:SetPreference("reducedMotion",self.ReducedMotion); return self.ReducedMotion end
    function window:SetContext(ctx) self.Context=type(ctx)=="table" and ctx or {}; if self.Context.SeaName then contextText.Text=tostring(self.Context.SeaName) end; return self.Context end
    function window:SetRuntimeStatus(text,percent,tone) runtimeText.Text=tostring(text or tr("ui.ready")); runtimeDot.BackgroundColor3=toneColor(tone or "good"); return runtimeText.Text end
    function window:SetRuntimeStatusKey(key,params,percent,tone) return self:SetRuntimeStatus(tr(key,key,params),percent,tone) end
    function window:Notify(opts)
        opts=type(opts)=="table" and opts or {Content=tostring(opts or "")}; self._toastOrder=self._toastOrder+1; local color=toneColor(opts.Tone or "info"); local toast=New("Frame",{Size=UDim2.fromOffset(302,68),BackgroundColor3=T.SurfaceRaised,BackgroundTransparency=0.32,BorderSizePixel=0,LayoutOrder=self._toastOrder,ZIndex=1601},toastRoot); Corner(toast,11); Stroke(toast,0.34,T.Stroke); New("Frame",{Size=UDim2.fromOffset(3,40),Position=UDim2.fromOffset(0,11),BackgroundColor3=color,BorderSizePixel=0,ZIndex=1602},toast)
        local title=opts.TitleKey and tr(opts.TitleKey,opts.Title or RE4UI.HubName,opts.Params) or tostring(opts.Title or RE4UI.HubName); local body=opts.ContentKey and tr(opts.ContentKey,opts.Content or opts.ContentKey,opts.Params) or tostring(opts.Content or "")
        createText(toast,{Position=UDim2.fromOffset(12,7),Size=UDim2.new(1,-20,0,19),Text=title,Font=Enum.Font.BuilderSansBold,TextSize=11,ZIndex=1602}); createText(toast,{Position=UDim2.fromOffset(12,27),Size=UDim2.new(1,-20,0,32),Text=body,Font=Enum.Font.BuilderSans,TextSize=10,TextColor3=T.TextSoft,TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,ZIndex=1602}); self:_delay(tonumber(opts.Duration) or 2.8,function() if toast.Parent then toast:Destroy() end end); return toast
    end
    local function normalizeSeas(value) if value==nil then return nil end; local out={}; if type(value)=="number" or type(value)=="string" then out[tonumber(value) or tostring(value)]=true elseif type(value)=="table" then for k,v in pairs(value) do if type(k)=="number" and type(v)~="boolean" then out[tonumber(v) or tostring(v)]=true elseif v==true then out[tonumber(k) or tostring(k)]=true end end end; return next(out) and out or nil end
    function window:_currentSeaNumber() return tonumber(RE4UI.CurrentSea) or tonumber(self.Context and self.Context.SeaNumber) or 0 end
    function window:RegisterFeature(control,tab,opts) opts=opts or {}; local id=tostring(opts.Id or (tab.Key..":"..tostring(#self.Features+1))); control.Id=id; local f={Id=id,Control=control,Tab=tab,Seas=normalizeSeas(opts.Seas or opts.Sea or opts.__RE4Seas),VisibilityCondition=opts.VisibilityCondition or opts.VisibleWhen,ManualVisible=true}; control._Feature=f; self.Features[#self.Features+1]=f; self.FeatureById[id]=f; return f end
    function window:_isFeatureVisible(f) if not f or f.ManualVisible==false then return false end; if f.Seas then local sea=self:_currentSeaNumber(); if f.Seas[sea]~=true and f.Seas[tostring(sea)]~=true then return false end end; if type(f.VisibilityCondition)=="function" then local ok,v=SafeCall("Visibility:"..f.Id,f.VisibilityCondition,self.Context); if not ok or v==false then return false end end; return true end
    function window:RefreshVisibility(force)
        if not self:_isAlive() then return false end
        local sections={}
        for _,f in ipairs(self.Features) do
            local visible=self:_isFeatureVisible(f)
            local row=f.Control and f.Control.Row
            if row and row.Parent then row.Visible=visible end
            if f.Control and f.Control.Section then sections[f.Control.Section]=true end
        end
        for section in pairs(sections) do section:_refreshVisibility() end
        if self.ActiveTab then
            local page=self.ActiveTab.Page; local oldCanvas=page and page.CanvasPosition or nil
            self.ActiveTab:_relayoutSections(false)
            if page and oldCanvas then page.CanvasPosition=oldCanvas end
            pageCount.Text=tostring(self.ActiveTab:VisibleControlCount()).." "..tr("ui.features","features")
        end
        return true
    end
    function window:SetFeatureVisibility(id,condition) local f=self.FeatureById[tostring(id or "")]; if not f then return false end; f.VisibilityCondition=condition; self:RefreshVisibility(true); return true end
    function window:FocusFeature(feature) if type(feature)=="string" then feature=self.FeatureById[feature] end; if not feature then return false end; self:ShowTab(feature.Tab); self:_defer(function() local row=feature.Control and feature.Control.Row; local page=feature.Tab and feature.Tab.Page; if row and row.Parent and page then page.CanvasPosition=Vector2.new(0,math.max(0,row.AbsolutePosition.Y-page.AbsolutePosition.Y+page.CanvasPosition.Y-18)); local old=row.BackgroundColor3; local oldTransparency=row.BackgroundTransparency; row.BackgroundColor3=T.AccentFaint; row.BackgroundTransparency=0.28; self:_delay(0.5,function() if row.Parent then row.BackgroundColor3=old; row.BackgroundTransparency=oldTransparency end end) end end); return true end
    function window:OpenSearch()
        self.Overlay:Close(); local blocker=self.Overlay:CreateBlocker(1700); local panel=New("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,70),Size=UDim2.fromOffset(math.min(480,math.max(308,main.AbsoluteSize.X-52)),math.min(348,math.max(258,main.AbsoluteSize.Y-68))),BackgroundColor3=T.Surface,BackgroundTransparency=0.26,BorderSizePixel=0,ZIndex=1701},gui); Corner(panel,13); Stroke(panel,0.28,T.Stroke)
        local input=New("TextBox",{Position=UDim2.fromOffset(12,12),Size=UDim2.new(1,-24,0,40),BackgroundColor3=T.Control,BackgroundTransparency=0.34,BorderSizePixel=0,Text="",PlaceholderText=tr("ui.search_hint"),PlaceholderColor3=T.Muted,TextColor3=T.Text,Font=Enum.Font.BuilderSansMedium,TextSize=13,ClearTextOnFocus=false,ZIndex=1702},panel); Corner(input,9); Stroke(input,0.58,T.Stroke); Padding(input,12,12,0,0)
        local list=New("ScrollingFrame",{Position=UDim2.fromOffset(12,60),Size=UDim2.new(1,-24,1,-72),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.Stroke,ZIndex=1702},panel); New("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},list); local buttons={}
        local function render() for _,b in ipairs(buttons) do if b.Parent then b:Destroy() end end; table.clear(buttons); local q=normalizeText(input.Text); local n=0; for _,f in ipairs(self.Features) do if n>=30 then break end; local c=f.Control; if c and c.Row and c.Row.Visible then local hay=normalizeText((c.TitleLabel and c.TitleLabel.Text or "").." "..(c.DescLabel and c.DescLabel.Text or "").." "..f.Id); if q=="" or hay:find(q,1,true) then n=n+1; local b=New("TextButton",{Size=UDim2.new(1,-2,0,48),BackgroundColor3=T.Control,BackgroundTransparency=0.34,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=1703},list); Corner(b,8); createText(b,{Position=UDim2.fromOffset(10,4),Size=UDim2.new(1,-20,0,19),Text=c.TitleLabel and c.TitleLabel.Text or f.Id,Font=Enum.Font.BuilderSansMedium,TextSize=11,ZIndex=1704,TextTruncate=Enum.TextTruncate.AtEnd}); createText(b,{Position=UDim2.fromOffset(10,25),Size=UDim2.new(1,-20,0,16),Text=(f.Tab and f.Tab.Title or "").." · "..f.Id,Font=Enum.Font.BuilderSans,TextSize=9,TextColor3=T.Muted,ZIndex=1704,TextTruncate=Enum.TextTruncate.AtEnd}); b.MouseButton1Click:Connect(function() self.Overlay:Close(); self:FocusFeature(f) end); buttons[#buttons+1]=b end end end end
        input:GetPropertyChangedSignal("Text"):Connect(render); self.Overlay:Set(panel,blocker); render(); input:CaptureFocus()
    end
    function window:_setVisible(visible) visible=visible~=false; main.Visible=visible; if not visible then self.Overlay:Close() end; if type(self.OnVisibilityChanged)=="function" then SafeCall("VisibilityChanged",self.OnVisibilityChanged,visible) end; return visible end
    function window:Toggle() return self:_setVisible(not main.Visible) end; function window:IsVisible() return main.Visible end
    function window:ShowTab(tab)
        if type(tab)=="string" then tab=self.TabsByKey[tab] or self.TabsByKey[canonicalTabKey(tab)] end
        if not tab then return false end
        local previous=self.ActiveTab
        for _,other in ipairs(self.Tabs) do
            local active=other==tab
            other.Page.Visible=active
            other.NavButton:SetAttribute("RE4Selected",active)
            other.NavButton.BackgroundColor3=active and T.AccentFaint or T.Rail
            other.NavMarker.Visible=active
            other.NavIcon.ImageColor3=active and T.Accent or T.Muted
            other.NavTitle.TextColor3=active and T.Text or T.TextSoft
        end
        self.ActiveTab=tab
        pageTitle.Text=tab.Title
        pageSubtitle.Text=tab.Subtitle
        IconService:_apply(pageIcon,tab.Definition and tab.Definition.Icon or "Info",IconService.Source=="fallback")
        pageCount.Text=tostring(tab:VisibleControlCount()).." "..tr("ui.features","features")
        if previous and previous~=tab then for _,cb in ipairs(previous.HiddenCallbacks) do SafeCall("TabHidden",cb,previous) end end
        if previous~=tab then for _,cb in ipairs(tab.ShownCallbacks) do SafeCall("TabShown",cb,tab) end end
        if type(self.OnTabChanged)=="function" then SafeCall("TabChanged",self.OnTabChanged,tab) end
        self:RefreshVisibility(true)
        return true
    end
    function window:MakeTab(tabOptions)
        tabOptions=tabOptions or {}; local key=tostring(tabOptions.Key or tabOptions.Title or "Tab"); local def=nil; for _,d in ipairs(C.PresentationSchema.Tabs) do if d.Key==key then def=d break end end; def=def or {Key=key,TitleKey=tabOptions.TitleKey,Icon="Info",Order=#self.Tabs+1}; local fallback=tostring(tabOptions.Title or key); local title=def.TitleKey and tr(def.TitleKey,fallback) or fallback; local subtitle=def.SubtitleKey and tr(def.SubtitleKey,"") or ""
        local tab={Window=self,Key=key,Title=title,Subtitle=subtitle,Definition=def,Sections={},SectionsById={},CurrentSection=nil,Controls={},ShownCallbacks={},HiddenCallbacks={}}
        local page=New("ScrollingFrame",{Name="Page_"..key,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),ScrollBarThickness=2,ScrollBarImageColor3=T.Stroke,ScrollingDirection=Enum.ScrollingDirection.Y,Visible=false,ZIndex=14},pages)
        local left=New("Frame",{Position=UDim2.fromOffset(M.PagePad,0),Size=UDim2.new(0.5,-(M.PagePad+M.ColumnGap/2),0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=15},page); local right=New("Frame",{Position=UDim2.new(0.5,M.ColumnGap/2,0,0),Size=UDim2.new(0.5,-(M.PagePad+M.ColumnGap/2),0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=15},page)
        local ll=New("UIListLayout",{Padding=UDim.new(0,M.SectionGap),SortOrder=Enum.SortOrder.LayoutOrder},left); local rl=New("UIListLayout",{Padding=UDim.new(0,M.SectionGap),SortOrder=Enum.SortOrder.LayoutOrder},right); Padding(left,0,0,M.SectionGap,M.SectionGap); Padding(right,0,0,M.SectionGap,M.SectionGap)
        tab.Page=page; tab.Left=left; tab.Right=right; tab.LeftLayout=ll; tab.RightLayout=rl
        local nav=New("TextButton",{Size=UDim2.new(1,0,0,38),BackgroundColor3=T.Rail,BackgroundTransparency=0.26,BorderSizePixel=0,Text="",AutoButtonColor=false,LayoutOrder=tonumber(def.Order) or #self.Tabs+1,ZIndex=19},navScroll); Corner(nav,8); Stroke(nav,0.44,T.Stroke); nav:SetAttribute("RE4Selected",false)
        local marker=New("Frame",{Position=UDim2.fromOffset(0,9),Size=UDim2.fromOffset(3,20),BackgroundColor3=T.Accent,BorderSizePixel=0,Visible=false,ZIndex=20},nav); Corner(marker,2)
        local navIcon=IconService:Track(New("ImageLabel",iconImageProps(def.Icon or "Info",{Position=UDim2.fromOffset(11,10),Size=UDim2.fromOffset(16,16),ImageColor3=T.Muted,ScaleType=Enum.ScaleType.Fit,ZIndex=20}),nav),def.Icon or "Info")
        local navTitle=createText(nav,{Position=UDim2.fromOffset(34,0),Size=UDim2.new(1,-40,1,0),Text=title,Font=Enum.Font.BuilderSansMedium,TextSize=TX.Nav,TextColor3=T.TextSoft,ZIndex=20,TextTruncate=Enum.TextTruncate.AtEnd})
        setHover(nav,T.Rail,T.SurfaceHover); nav.MouseButton1Click:Connect(function() self:ShowTab(tab) end); tab.NavButton=nav; tab.NavMarker=marker; tab.NavIcon=navIcon; tab.NavTitle=navTitle
        function tab:OnShown(cb) if type(cb)=="function" then self.ShownCallbacks[#self.ShownCallbacks+1]=cb end; return cb end; function tab:OnHidden(cb) if type(cb)=="function" then self.HiddenCallbacks[#self.HiddenCallbacks+1]=cb end; return cb end
        function tab:VisibleControlCount() local n=0; for _,c in ipairs(self.Controls) do if c.Row and c.Row.Visible then n=n+1 end end; return n end
        function tab:_refreshCanvas()
            local h=window.SingleColumn and self.LeftLayout.AbsoluteContentSize.Y or math.max(self.LeftLayout.AbsoluteContentSize.Y,self.RightLayout.AbsoluteContentSize.Y)
            self.Page.CanvasSize=UDim2.fromOffset(0,h+M.SectionGap*2)
        end
        function tab:_sectionHeight(section)
            if not section or not section.Frame.Visible then return 0 end
            local measured=section.Frame.AbsoluteSize.Y
            if measured and measured>M.SectionHeader then return measured end
            local total=M.SectionHeader+M.SectionBodyPad*2
            local visible=0
            for _,control in ipairs(section.Controls or {}) do
                local row=control.Row
                if row and row.Visible then
                    visible=visible+1
                    local rh=(row.AbsoluteSize and row.AbsoluteSize.Y) or 0
                    if rh<=0 then rh=(row.Size and row.Size.Y.Offset) or M.RowDesktop end
                    total=total+math.max(M.RowCompact,rh)
                end
            end
            return total+math.max(0,visible-1)
        end
        function tab:_relayoutSections(rebalance)
            self.Right.Visible=not window.SingleColumn
            if window.SingleColumn then
                self.Left.Position=UDim2.fromOffset(M.PagePad,0); self.Left.Size=UDim2.new(1,-M.PagePad*2,0,0)
                for _,section in ipairs(self.Sections) do if section.Frame.Parent~=self.Left then section.Frame.Parent=self.Left end end
            else
                local ratio=math.clamp(tonumber(self.Definition and self.Definition.ColumnRatio) or 0.5,0.46,0.54)
                local halfGap=M.ColumnGap/2
                self.Left.Position=UDim2.fromOffset(M.PagePad,0)
                self.Left.Size=UDim2.new(ratio,-(M.PagePad+halfGap),0,0)
                self.Right.Position=UDim2.new(ratio,halfGap,0,0)
                self.Right.Size=UDim2.new(1-ratio,-(M.PagePad+halfGap),0,0)
                if rebalance~=false then
                    local ordered={}
                    for _,section in ipairs(self.Sections) do if section.Frame.Visible then ordered[#ordered+1]=section end end
                    table.sort(ordered,function(a,b) if a.Order==b.Order then return (a.StableIndex or 0)<(b.StableIndex or 0) end; return a.Order<b.Order end)
                    local heights={Left=0,Right=0}
                    for _,section in ipairs(ordered) do
                        local pref=section.PreferredColumn=="Right" and "Right" or "Left"
                        local other=pref=="Left" and "Right" or "Left"
                        local choice=pref
                        if heights[pref]>heights[other]+M.ColumnBalanceTolerance then choice=other end
                        section.AssignedColumn=choice
                        heights[choice]=heights[choice]+self:_sectionHeight(section)+M.SectionGap
                    end
                end
                for _,section in ipairs(self.Sections) do
                    local side=section.AssignedColumn or (section.PreferredColumn=="Right" and "Right" or "Left")
                    local parent=side=="Right" and self.Right or self.Left
                    if section.Frame.Parent~=parent then section.Frame.Parent=parent end
                end
            end
            self:_refreshCanvas()
        end
        function tab:StabilizeLayout() self:_relayoutSections(true); self._LayoutStabilized=true end
        function tab:_applyResponsive()
            self.NavTitle.Visible=not window.IconRail
            self.NavIcon.Position=window.IconRail and UDim2.new(0.5,-8,0,10) or UDim2.fromOffset(11,10)
            for _,section in ipairs(self.Sections) do section:_applyResponsive() end
            self:_relayoutSections(self._LayoutStabilized~=true)
        end
        local function ensureSection() return tab.CurrentSection or tab:AddSection({Id="general",Title=tr("ui.general","General")}) end
        function tab:AddSection(opts)
            opts=opts or {}
            local id=tostring(opts.Id or opts.Title or "general")
            if self.SectionsById[id] then self.CurrentSection=self.SectionsById[id]; return self.CurrentSection end
            local spec=presentationSectionSpec(self.Key,id) or {}
            local titleKey=opts.TitleKey or spec.TitleKey
            local fb=tostring(opts.Title or id:gsub("[._]"," "))
            local titleText=titleKey and tr(titleKey,fb) or localizeLegacy(fb)
            local column=opts.Column or spec.Column or "Left"
            local order=tonumber(opts.Order or spec.Order) or #self.Sections+1
            local stableIndex=#self.Sections+1
            local parent=(window.SingleColumn or column~="Right") and self.Left or self.Right
            local frame=New("Frame",{Size=UDim2.new(1,0,0,M.SectionHeader),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.Surface,BackgroundTransparency=0.34,BorderSizePixel=0,LayoutOrder=order*100+stableIndex,ZIndex=16},parent)
            Corner(frame,M.SectionRadius); Stroke(frame,0.58,T.Stroke)
            local sh=New("Frame",{Size=UDim2.new(1,0,0,M.SectionHeader),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=17},frame)
            local iconName=sectionIconName(self.Key,id,opts.Icon or spec.Icon)
            local iconShell=New("Frame",{Position=UDim2.fromOffset(8,8),Size=UDim2.fromOffset(22,22),BackgroundColor3=T.AccentFaint,BackgroundTransparency=0.20,BorderSizePixel=0,ZIndex=18},sh); Corner(iconShell,7); Stroke(iconShell,0.56,T.AccentStrong)
            IconService:Track(New("ImageLabel",iconImageProps(iconName,{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(12,12),ImageColor3=T.Accent,ScaleType=Enum.ScaleType.Fit,ZIndex=19}),iconShell),iconName)
            local titleObj=createText(sh,{Position=UDim2.fromOffset(38,0),Size=UDim2.new(1,-78,1,0),Text=titleText,Font=Enum.Font.BuilderSansMedium,TextSize=TX.Section,TextColor3=T.Text,ZIndex=18,TextTruncate=Enum.TextTruncate.AtEnd})
            if titleKey then bindKey(titleObj,titleKey,fb) else bindLegacy(titleObj,fb) end
            local countObj=createText(sh,{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-9,0.5,0),Size=UDim2.fromOffset(34,18),Text="",Font=Enum.Font.BuilderSansMedium,TextSize=TX.Meta,TextColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=18})
            New("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,8,1,0),Size=UDim2.new(1,-16,0,1),BackgroundColor3=T.Divider,BackgroundTransparency=0.62,BorderSizePixel=0,ZIndex=18},sh)
            local body=New("Frame",{Position=UDim2.fromOffset(0,M.SectionHeader),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=17},frame)
            local bl=New("UIListLayout",{Padding=UDim.new(0,0),SortOrder=Enum.SortOrder.LayoutOrder},body); Padding(body,M.SectionBodyPad,M.SectionBodyPad,M.SectionBodyPad,M.SectionBodyPad)
            local section={Id=id,Tab=self,Frame=frame,Body=body,Layout=bl,Controls={},PreferredColumn=column,AssignedColumn=column,Order=order,StableIndex=stableIndex,CountLabel=countObj}
            function section:_refreshVisibility()
                local visible=0
                for _,c in ipairs(self.Controls) do if c.Row and c.Row.Visible then visible=visible+1 end end
                self.Frame.Visible=visible>0
                self.CountLabel.Text=visible>0 and tostring(visible) or ""
                self.Tab:_refreshCanvas()
                return visible>0
            end
            function section:_applyResponsive() for _,c in ipairs(self.Controls) do if c._applyResponsive then c:_applyResponsive() end end end
            self.Sections[#self.Sections+1]=section; self.SectionsById[id]=section; self.CurrentSection=section
            window:_connect(bl:GetPropertyChangedSignal("AbsoluteContentSize"),function() self:_refreshCanvas() end)
            self:_relayoutSections(true)
            return section
        end
        local function rowBase(opts,kind,heightOverride)
            opts=opts or {}
            local section=ensureSection()
            local sourceName=stripRichText(opts.Name or opts.Title or kind or tr("ui.feature"))
            local sourceDesc=stripRichText(opts.Description or opts.Desc or opts.Content or "")
            local titleText=opts.TitleKey and tr(opts.TitleKey,sourceName) or localizeLegacy(sourceName)
            local descText=opts.DescriptionKey and tr(opts.DescriptionKey,sourceDesc) or localizeLegacy(sourceDesc)
            if descText==titleText then descText="" end
            local row=New("Frame",{Size=UDim2.new(1,0,0,heightOverride or M.RowDesktop),BackgroundColor3=T.Control,BackgroundTransparency=0.68,BorderSizePixel=0,LayoutOrder=tonumber(opts.Order) or #section.Controls+1,ZIndex=18},section.Body)
            local divider=New("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,5,1,0),Size=UDim2.new(1,-10,0,1),BackgroundColor3=T.Divider,BackgroundTransparency=0.78,BorderSizePixel=0,ZIndex=18},row)
            local titleObj=createText(row,{Position=UDim2.fromOffset(8,9),Size=UDim2.new(1,-16,0,21),Text=titleText,Font=Enum.Font.BuilderSansMedium,TextSize=TX.RowTitle,TextColor3=T.Text,ZIndex=19,TextTruncate=Enum.TextTruncate.AtEnd})
            local descObj=createText(row,{Position=UDim2.fromOffset(8,32),Size=UDim2.new(1,-16,0,18),Text=descText,Font=Enum.Font.BuilderSans,TextSize=TX.RowDesc,TextColor3=T.Muted,ZIndex=19,TextTruncate=Enum.TextTruncate.AtEnd})
            if opts.TitleKey then bindKey(titleObj,opts.TitleKey,sourceName) else bindLegacy(titleObj,sourceName) end
            if opts.DescriptionKey then bindKey(descObj,opts.DescriptionKey,sourceDesc) else bindLegacy(descObj,sourceDesc) end
            local status=createStatusPill(row)
            local c={Row=row,Card=row,Frame=row,Divider=divider,Section=section,Tab=tab,Type=kind,Name=sourceName,TitleLabel=titleObj,DescLabel=descObj,StatusLabel=status,Disabled=false,ActionWidth=0}
            function c:SetDesc(v) descObj.Text=localizeLegacy(tostring(v or "")); self:_applyResponsive(); return self end
            function c:SetDescKey(key,params,fallback) descObj.Text=tr(key,fallback or "",params); self:_applyResponsive(); return self end
            function c:_renderStatus()
                local spec=self._StatusSpec
                if not spec or spec.Hidden then status.Visible=false; self:_applyResponsive(); return end
                local value=spec.Key and tr(spec.Key,spec.Fallback or spec.Key,spec.Params) or localizeLegacy(spec.Source or "",spec.Params)
                if value=="" then status.Visible=false; self:_applyResponsive(); return end
                local col=toneColor(spec.Tone); status.Text=value; status.TextColor3=col; status.BackgroundColor3=col; status.BackgroundTransparency=0.76; status.Visible=true
                status.Size=UDim2.fromOffset(math.clamp(estimateTextWidth(value,TX.Status,Enum.Font.BuilderSansMedium)+16,50,136),21)
                self:_applyResponsive()
            end
            function c:SetStatus(v,tone) local source=tostring(v or ""); if source=="" then self._StatusSpec={Hidden=true}; status.Visible=false; self:_applyResponsive(); return self end; self._StatusSpec={Source=source,Fallback=source,Tone=tone}; self:_renderStatus(); return self end
            function c:SetStatusKey(key,params,tone,fallback) self._StatusSpec={Key=key,Params=params,Tone=tone,Fallback=fallback or key}; self:_renderStatus(); return self end
            function c:SetAvailable(available,reason) available=available==true; self.Disabled=not available; titleObj.TextTransparency=available and 0 or 0.35; descObj.TextTransparency=available and 0 or 0.42; if self.Button then self.Button.Active=available; self.Button:SetAttribute("RE4Locked",not available) end; if self.Hit then self.Hit.Active=available end; if self.Box then self.Box.TextEditable=available end; if not available and reason then self:SetStatus(reason,"blocked") end; return available end
            function c:SetVisible(visible) visible=visible~=false; if self.Visible==visible and row.Visible==visible then return self end; self.Visible=visible; if self._Feature then self._Feature.ManualVisible=visible; window:RefreshVisibility(true) else row.Visible=visible end; return self end
            function c:_applyResponsive()
                local compact=window.CompactDensity and not window.SingleColumn
                local actionW=(self.Action and self.Action.Visible~=false) and (self.ActionWidth or 0) or 0
                local stackAction=actionW>100 and ((window.SingleColumn and main.AbsoluteSize.X<C.Breakpoints.IconRail) or ((not window.SingleColumn) and main.AbsoluteSize.X<C.Breakpoints.StackWideActions))
                local h=heightOverride or (stackAction and M.RowMobileStacked or (window.SingleColumn and M.RowMobile or (compact and M.RowCompact or M.RowDesktop)))
                row.Size=UDim2.new(1,0,0,h)
                local reserve=(not stackAction and actionW>0) and actionW+13 or 8
                titleObj.Size=UDim2.new(1,-(reserve+10),0,21)
                descObj.Size=UDim2.new(1,-(reserve+10),0,18)
                descObj.Visible=(not compact) and descObj.Text~="" and descObj.Text~=titleObj.Text
                if status.Visible then
                    status.AnchorPoint=Vector2.new(1,0.5)
                    status.Position=stackAction and UDim2.new(1,-7,0,18) or UDim2.new(1,-(actionW>0 and actionW+11 or 7),0.5,0)
                end
                if self._positionAction then self:_positionAction(h,stackAction) end
            end
            section.Controls[#section.Controls+1]=c; tab.Controls[#tab.Controls+1]=c; window:RegisterFeature(c,tab,opts); c:_applyResponsive(); section:_refreshVisibility(); return c
        end
        function tab:AddParagraph(opts) opts=opts or {}; local c=rowBase(opts,"Paragraph"); if opts.Status then c:SetStatus(opts.Status,opts.Tone) end; return c end; function tab:AddStatus(opts) opts=opts or {}; local c=rowBase(opts,"Status"); c:SetStatus(opts.Status or tr("status.waiting"),opts.Tone or "waiting"); return c end
        function tab:AddToggle(opts)
            opts=opts or {}; local initial=opts.Default==true; if type(opts.StateGetter)=="function" then local ok,v=pcall(opts.StateGetter); if ok and type(v)=="boolean" then initial=v end end; local c=rowBase(opts,"Toggle"); local track,knob=createSwitch(c.Row,initial); c.Action=track; c.Button=track; c.ActionWidth=50; c.Value=initial; c.Callback=opts.Callback
            function c:_positionAction(h) track.AnchorPoint=Vector2.new(1,0.5); track.Position=UDim2.new(1,-10,0.5,0) end; function c:_render() Tween(track,C.Motion.Fast,{BackgroundColor3=self.Value and T.Accent or T.SurfaceRaised}); Tween(knob,C.Motion.Fast,{Position=self.Value and UDim2.new(1,-math.floor(M.SwitchH/2),0.5,0) or UDim2.new(0,math.floor(M.SwitchH/2),0.5,0)}) end
            function c:SetValue(v,call) local nextValue=v==true; if self.Disabled and nextValue then return false end; local prev=self.Value; if call~=false and type(self.Callback)=="function" then local ok,result=SafeCall(self.Id or self.Name,self.Callback,nextValue); if not ok or result==false then self.Value=prev; self:_render(); return false end end; self.Value=nextValue; self:_render(); return true end
            function c:RefreshOwnership() if not self._OwnershipItem then return end; local provider=Ownership(); local state=ownershipState(provider,self._OwnershipItem); local owned=state.Owned==true; local selectable=self._OwnershipSelectable==true; local automation=self._OwnershipAutomation==true; local oneTime=self._OwnershipOneTime==true; local active=type(provider.IsEquipped)=="function" and provider:IsEquipped(self._OwnershipItem) or false; if automation or oneTime then if owned then if self.Value and type(self.Callback)=="function" then self.Value=false; SafeCall(self.Id or self.Name,self.Callback,false) end; self.Disabled=true; track.Active=false; self:SetStatus(tr("status.owned"),"completed"); self:SetVisible(false) else self:SetVisible(true); self.Disabled=false; track.Active=true; renderOwnershipStatus(self,state,self.Value==true); self:_render() end; return end; if selectable then if self._OwnershipUseOnly==true and not owned then self.Disabled=true; track.Active=false; self.Value=false; self:SetStatus(""); self:SetVisible(false); return end; self:SetVisible(true); if active then self.Disabled=true; track.Active=false; self.Value=true; self:SetStatus(tr("status.active"),"good"); track.BackgroundColor3=T.Good; knob.Position=UDim2.new(1,-math.floor(M.SwitchH/2),0.5,0) else self.Disabled=false; track.Active=true; self.Value=false; self:_render(); renderOwnershipStatus(self,state,false) end end end
            track.MouseButton1Click:Connect(function() c:RefreshOwnership(); if not c.Disabled then c:SetValue(not c.Value,true) end end); Ownership():Register(c,c.Name); c:RefreshOwnership(); c:_render(); c:_applyResponsive(); if not c.Disabled and opts.InvokeInitialCallback~=false then window:_defer(function() c:SetValue(c.Value,true) end) end; return c
        end
        function tab:AddButton(opts)
            opts=opts or {}; local c=rowBase(opts,"Button"); local key=opts.ActionTextKey; if not key then local id=tostring(opts.Id or c.Name):lower(); if id:find("teleport",1,true) or id:find("tween",1,true) then key="action.go" elseif id:find("buy",1,true) then key="action.buy" elseif id:find("craft",1,true) then key="action.craft" elseif id:find("start",1,true) then key="action.start" elseif id:find("copy",1,true) then key="action.copy" else key="action.run" end end; local button=New("TextButton",{Size=UDim2.fromOffset(86,M.ControlHeight),BackgroundColor3=T.AccentSoft,BackgroundTransparency=0.22,BorderSizePixel=0,Text=tr(key,opts.ActionText or "Run"),Font=Enum.Font.BuilderSansBold,TextColor3=T.Text,TextSize=TX.Control,AutoButtonColor=false,ZIndex=20},c.Row); Corner(button,8); Stroke(button,0.60,T.AccentStrong); setHover(button,T.AccentSoft,T.AccentStrong); c.Action=button; c.Button=button; c.ActionWidth=96; c.Callback=opts.Callback; function c:_positionAction(h) button.AnchorPoint=Vector2.new(1,0.5); button.Position=UDim2.new(1,-10,0.5,0) end
            function c:RefreshOwnership() if not self._OwnershipItem then self.Disabled=false; button.Active=true; button.Visible=true; self:SetVisible(true); return end; local provider=Ownership(); local state=ownershipState(provider,self._OwnershipItem); local owned=state.Owned==true; local selectable=self._OwnershipSelectable==true; local useOnly=self._OwnershipUseOnly==true; local active=selectable and type(provider.IsEquipped)=="function" and provider:IsEquipped(self._OwnershipItem) or false; if selectable then if useOnly and not owned then self.Disabled=true; button.Active=false; button.Visible=false; self:SetVisible(false); return end; self:SetVisible(true); button.Visible=true; if active then self.Disabled=true; button.Active=false; button.Text=tr("status.active"); button.BackgroundColor3=T.Good; self:SetStatus(tr("status.active"),"good") else self.Disabled=false; button.Active=true; button.Text=tr("action.use"); button.BackgroundColor3=T.AccentSoft; self:SetStatus(tr("status.owned"),"completed") end; return end; self:SetVisible(true); local blocked=state.Code=="blocked"; self.Disabled=owned or blocked; button.Active=not self.Disabled; button.Visible=not owned; renderOwnershipStatus(self,state,false) end
            button.MouseButton1Click:Connect(function() c:RefreshOwnership(); if c.Disabled then return end; c:SetStatus(tr("status.working"),"running"); local ok,result=SafeCall(c.Id or c.Name,c.Callback); local success=ok and result~=false; c:SetStatus(tr(success and "status.done" or "status.error"),success and "good" or "bad"); if success and c._OwnershipItem then local provider=Ownership(); if type(provider.UpdateControls)=="function" then window:_delay(Config.UI.Timing.OwnershipRefreshDelay,function() pcall(function() provider:UpdateControls(true) end) end) end end; window:_delay(Config.UI.Timing.OwnershipStatusClearDelay,function() if c.Row.Parent then c:RefreshOwnership(); if not c._OwnershipItem then c:SetStatus("") end end end) end); Ownership():Register(c,c.Name); c:RefreshOwnership(); c:_applyResponsive(); return c
        end
        function tab:AddDropdown(opts)
            opts=opts or {}; local optionsList=type(opts.Options)=="table" and opts.Options or {}; local selected=opts.Default; if selected==nil then selected=optionsList[1] end; local c=rowBase(opts,"Dropdown"); c.Options=optionsList; c.Value=selected; c.Callback=opts.Callback; c.LocalizeOptions=opts.LocalizeOptions~=false; c.OptionLabelKeys=type(opts.OptionLabelKeys)=="table" and opts.OptionLabelKeys or nil
            local button=New("TextButton",{Size=UDim2.fromOffset(164,M.ControlHeight),BackgroundColor3=T.SurfaceRaised,BackgroundTransparency=0.34,BorderSizePixel=0,Text="",Font=Enum.Font.BuilderSansMedium,TextColor3=T.Text,TextSize=TX.Control,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,AutoButtonColor=false,ZIndex=20},c.Row); Corner(button,8); Stroke(button,0.60,T.Stroke); Padding(button,11,28,0,0); setHover(button,T.SurfaceRaised,T.ControlHover); IconService:Track(New("ImageLabel",iconImageProps("ChevronDown",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-8,0.5,0),Size=UDim2.fromOffset(12,12),ImageColor3=T.Muted,ScaleType=Enum.ScaleType.Fit,ZIndex=21}),button),"ChevronDown"); c.Action=button; c.Button=button; c.ActionWidth=176
            local function display(v) local raw=tostring(v or ""); if c.OptionLabelKeys and c.OptionLabelKeys[v] then return tr(c.OptionLabelKeys[v],raw) end; return c.LocalizeOptions and localizeLegacy(raw) or raw end; local function refresh() button.Text=display(c.Value or "") end; function c:_positionAction(h,stacked)
                if stacked then button.AnchorPoint=Vector2.new(0,1); button.Position=UDim2.new(0,7,1,-7); button.Size=UDim2.new(1,-14,0,M.ControlHeight)
                else button.AnchorPoint=Vector2.new(1,0.5); button.Position=UDim2.new(1,-10,0.5,0); button.Size=UDim2.fromOffset(154,M.ControlHeight) end
            end; function c:SetValue(v,call) local prev=self.Value; if call~=false and type(self.Callback)=="function" then local ok,result=SafeCall(self.Id or self.Name,self.Callback,v); if not ok or result==false then return false end end; self.Value=v; refresh(); return true end; function c:SetOptions(v,keep) self.Options=type(v)=="table" and v or {}; if not keep and self.Value==nil then self.Value=self.Options[1] end; refresh(); return self end
            local function openPopup() if c.Disabled then return end; window.Overlay:Close(); local blocker=window.Overlay:CreateBlocker(1750); local maxVisible=math.min(#c.Options,8); local ph=math.max(42,maxVisible*34+12); local abs=button.AbsolutePosition; local size=button.AbsoluteSize; local vp=window:_viewport(); local x=math.clamp(abs.X,8,math.max(8,vp.X-math.max(size.X,190)-8)); local below=abs.Y+size.Y+5; local y=(below+ph<=vp.Y-8) and below or math.max(8,abs.Y-ph-5); local popup=New("Frame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(math.max(size.X,190),ph),BackgroundColor3=T.Surface,BorderSizePixel=0,ZIndex=1751},gui); Corner(popup,10); Stroke(popup,0.25,T.Stroke); local list=New("ScrollingFrame",{Position=UDim2.fromOffset(6,6),Size=UDim2.new(1,-12,1,-12),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.Stroke,ZIndex=1752},popup); New("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},list); for i,opt in ipairs(c.Options) do local active=c.Value==opt; local e=New("TextButton",{Size=UDim2.new(1,-2,0,33),BackgroundColor3=active and T.AccentFaint or T.Control,BorderSizePixel=0,Text=display(opt),Font=Enum.Font.BuilderSansMedium,TextColor3=active and T.Text or T.TextSoft,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,LayoutOrder=i,ZIndex=1753},list); Corner(e,7); Padding(e,9,8,0,0); e.MouseButton1Click:Connect(function() if c:SetValue(opt,true) then window.Overlay:Close() end end) end; window.Overlay:Set(popup,blocker) end
            button.MouseButton1Click:Connect(openPopup); refresh(); c:_applyResponsive(); return c
        end
        function tab:AddSlider(opts)
            opts=opts or {}; local min=tonumber(opts.Min) or 0; local max=tonumber(opts.Max) or 100; local rounding=tonumber(opts.Rounding or opts.Step) or 1; local c=rowBase(opts,"Slider"); c.Min=min; c.Max=max; c.Rounding=rounding; c.Value=math.clamp(tonumber(opts.Default) or min,min,max); c.Callback=opts.Callback; local holder=New("Frame",{Size=UDim2.fromOffset(166,M.ControlHeight),BackgroundColor3=T.SurfaceRaised,BackgroundTransparency=0.34,BorderSizePixel=0,ZIndex=20},c.Row); Corner(holder,8); Stroke(holder,0.60,T.Stroke); local bar=New("Frame",{Position=UDim2.fromOffset(10,17),Size=UDim2.new(1,-68,0,4),BackgroundColor3=T.Divider,BorderSizePixel=0,ZIndex=21},holder); Corner(bar,3); local fill=New("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=22},bar); Corner(fill,3); local label=createText(holder,{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-8,0,0),Size=UDim2.fromOffset(46,M.ControlHeight),Text="",Font=Enum.Font.BuilderSansBold,TextSize=TX.Control,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=22}); c.Action=holder; c.Hit=holder; c.ActionWidth=178; local function norm(v) v=math.clamp(tonumber(v) or min,min,max); if rounding>0 then v=math.floor(v/rounding+0.5)*rounding end; return math.clamp(v,min,max) end; local function render() local r=max==min and 0 or (c.Value-min)/(max-min); fill.Size=UDim2.fromScale(math.clamp(r,0,1),1); label.Text=tostring(c.Value) end; function c:_positionAction(h,stacked)
                if stacked then holder.AnchorPoint=Vector2.new(0,1); holder.Position=UDim2.new(0,7,1,-7); holder.Size=UDim2.new(1,-14,0,M.ControlHeight)
                else holder.AnchorPoint=Vector2.new(1,0.5); holder.Position=UDim2.new(1,-10,0.5,0); holder.Size=UDim2.fromOffset(156,M.ControlHeight) end
            end; function c:SetValue(v,call) local nv=norm(v); if call~=false and type(self.Callback)=="function" then local ok,result=SafeCall(self.Id or self.Name,self.Callback,nv); if not ok or result==false then return false end end; self.Value=nv; render(); return true end; holder.InputBegan:Connect(function(input) if c.Disabled then return end; if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then window.Input:BeginSlider(input,function(x) local r=math.clamp((x-bar.AbsolutePosition.X)/math.max(1,bar.AbsoluteSize.X),0,1); c:SetValue(min+(max-min)*r,true) end) end end); render(); c:_applyResponsive(); return c
        end
        function tab:AddTextBox(opts) opts=opts or {}; local c=rowBase(opts,"TextBox"); local box=New("TextBox",{Size=UDim2.fromOffset(164,M.ControlHeight),BackgroundColor3=T.SurfaceRaised,BackgroundTransparency=0.34,BorderSizePixel=0,Text=tostring(opts.Default or ""),PlaceholderText=opts.PlaceholderKey and tr(opts.PlaceholderKey,opts.Placeholder or "") or tostring(opts.Placeholder or ""),PlaceholderColor3=T.Muted,TextColor3=T.Text,Font=Enum.Font.BuilderSansMedium,TextSize=TX.Control,ClearTextOnFocus=opts.ClearOnFocus==true,ZIndex=20},c.Row); Corner(box,8); Stroke(box,0.60,T.Stroke); Padding(box,11,11,0,0); c.Action=box; c.Box=box; c.ActionWidth=176; c.Value=box.Text; c.Callback=opts.Callback; function c:_positionAction(h,stacked)
                if stacked then box.AnchorPoint=Vector2.new(0,1); box.Position=UDim2.new(0,7,1,-7); box.Size=UDim2.new(1,-14,0,M.ControlHeight)
                else box.AnchorPoint=Vector2.new(1,0.5); box.Position=UDim2.new(1,-10,0.5,0); box.Size=UDim2.fromOffset(154,M.ControlHeight) end
            end; function c:SetValue(v,call) local nv=tostring(v or ""); if call~=false and type(self.Callback)=="function" then local ok,result=SafeCall(self.Id or self.Name,self.Callback,nv); if not ok or result==false then return false end end; self.Value=nv; box.Text=nv; return true end; box.FocusLost:Connect(function() if not c.Disabled then c:SetValue(box.Text,true) end end); c:_applyResponsive(); return c end; tab.AddInput=tab.AddTextBox
        function tab:AddProgress(opts) opts=opts or {}; local c=rowBase(opts,"Progress",68); local bar=New("Frame",{Position=UDim2.fromOffset(10,47),Size=UDim2.new(1,-20,0,6),BackgroundColor3=T.SurfaceRaised,BorderSizePixel=0,ZIndex=20},c.Row); Corner(bar,6); local fill=New("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=21},bar); Corner(fill,6); function c:SetProgress(v,m,label) local maxv=tonumber(m) or 1; fill.Size=UDim2.fromScale(maxv==0 and 0 or math.clamp((tonumber(v) or 0)/maxv,0,1),1); if label and tostring(label)~="" then self:SetStatus(tostring(label),"info") end; return self end; c:SetProgress(opts.Value or 0,opts.Max or 1,opts.Status); return c end
        function tab:AddInfoList(opts)
            opts=opts or {}; local section=ensureSection(); local source=tostring(opts.Title or opts.Name or tr("ui.information","Information")); local panel=New("Frame",{Size=UDim2.new(1,0,0,45),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=T.Control,BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=tonumber(opts.Order) or #section.Controls+1,ZIndex=18},section.Body); local head=createText(panel,{Position=UDim2.fromOffset(7,4),Size=UDim2.new(1,-14,0,20),Text=opts.TitleKey and tr(opts.TitleKey,source) or localizeLegacy(source),Font=Enum.Font.BuilderSansBold,TextSize=TX.RowTitle,ZIndex=19}); local list=New("Frame",{Position=UDim2.fromOffset(5,28),Size=UDim2.new(1,-10,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=19},panel); New("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},list); Padding(list,0,0,0,8); local c={Row=panel,Frame=panel,Section=section,Tab=tab,Type="InfoList",Name=source,TitleLabel=head,DescLabel=createText(panel,{Visible=false}),Items={},Cells={},OnItemAction=opts.OnItemAction}
            function c:SetItems(items)
                self.Items=type(items)=="table" and items or {}; local seen={}
                for i,item in ipairs(self.Items) do
                    local key=tostring(type(item)=="table" and (item.Id or item.Key or item.LabelKey or item.Label) or i); seen[key]=true; local cell=self.Cells[key]
                    if not cell then
                        local frame=New("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=T.SurfaceRaised,BackgroundTransparency=0.58,BorderSizePixel=0,LayoutOrder=i,ZIndex=20},list); Corner(frame,6)
                        cell={Frame=frame,Label=createText(frame,{Position=UDim2.fromOffset(8,0),Size=UDim2.new(0.48,-8,1,0),Font=Enum.Font.BuilderSans,TextSize=10,TextColor3=T.Muted,ZIndex=21,TextTruncate=Enum.TextTruncate.AtEnd}),Value=createText(frame,{Position=UDim2.new(0.48,0,0,0),Size=UDim2.new(0.52,-8,1,0),Font=Enum.Font.BuilderSansMedium,TextSize=10,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=21,TextTruncate=Enum.TextTruncate.AtEnd})}
                        local action=New("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-5,0.5,0),Size=UDim2.fromOffset(72,22),BackgroundColor3=T.Control,BackgroundTransparency=0.20,BorderSizePixel=0,Text="",TextColor3=T.Text,Font=Enum.Font.BuilderSansMedium,TextSize=9,AutoButtonColor=false,Visible=false,ZIndex=22},frame); Corner(action,6); Stroke(action,0.60,T.Stroke); setHover(action,T.Control,T.SurfaceHover); cell.Action=action
                        action.MouseButton1Click:Connect(function() local current=cell.ActionItem; if current and type(c.OnItemAction)=="function" then SafeCall("InfoListAction:"..key,c.OnItemAction,current,c) end end)
                        self.Cells[key]=cell
                    end
                    cell.Frame.LayoutOrder=i; local label,value; local actionable=false
                    if type(item)=="table" then label=item.LabelKey and tr(item.LabelKey,item.Label or item.Id or key,item.LabelParams) or tostring(item.Label or item.Name or item.Id or key); value=item.ValueKey and tr(item.ValueKey,item.Value or item.ValueKey,item.ValueParams or item.Params) or tostring(item.Value~=nil and item.Value or item.Text or ""); actionable=item.ActionId~=nil and type(self.OnItemAction)=="function"; cell.ActionItem=item else label=tostring(i); value=tostring(item); cell.ActionItem=nil end
                    cell.Label.Text=label; cell.Value.Text=value; cell.Frame.Visible=true; cell.Action.Visible=actionable
                    if actionable then cell.Action.Text=tr((type(item)=="table" and item.ActionTextKey) or opts.ActionTextKey or "action.turn_off","Turn Off"); cell.Value.Size=UDim2.new(0.52,-84,1,0); cell.Value.Position=UDim2.new(0.48,0,0,0) else cell.Value.Size=UDim2.new(0.52,-8,1,0); cell.Value.Position=UDim2.new(0.48,0,0,0) end
                end
                for key,cell in pairs(self.Cells) do if not seen[key] then cell.Frame.Visible=false; if cell.Action then cell.Action.Visible=false end end end; section:_refreshVisibility(); return self
            end
            function c:SetVisible(v) panel.Visible=v~=false; section:_refreshVisibility(); return self end; function c:IsVisible() return panel.Visible end; function c:SetDesc() return self end; function c:SetStatus() return self end; function c:SetStatusKey() return self end; function c:SetAvailable() return true end; function c:_applyResponsive() end; section.Controls[#section.Controls+1]=c; tab.Controls[#tab.Controls+1]=c; window:RegisterFeature(c,tab,opts); c:SetItems(opts.Items or {}); return c
        end
        function tab:AddDiscordInvite(opts) return self:AddButton(opts or {}) end
        self.Tabs[#self.Tabs+1]=tab; self.TabsByKey[key]=tab; self:_listenLanguage(function() if not nav.Parent then return false end; tab.Title=def.TitleKey and tr(def.TitleKey,fallback) or fallback; tab.Subtitle=def.SubtitleKey and tr(def.SubtitleKey,"") or ""; navTitle.Text=tab.Title; if window.ActiveTab==tab then pageTitle.Text=tab.Title; pageSubtitle.Text=tab.Subtitle end; return true end); tab:_applyResponsive(); return tab
    end
    header.InputBegan:Connect(function(input) if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end; local start=main.Position; window.Input:BeginDrag(input,start,function(delta) main.AnchorPoint=Vector2.new(0.5,0.5); main.Position=UDim2.new(start.X.Scale,start.X.Offset+delta.X,start.Y.Scale,start.Y.Offset+delta.Y); window.UserDragged=true end,function() window:_clampFrame(main) end) end)
    floating.InputBegan:Connect(function(input) if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end; local start=floating.Position; window.Input:BeginDrag(input,start,function(delta) floating.Position=UDim2.new(start.X.Scale,start.X.Offset+delta.X,start.Y.Scale,start.Y.Offset+delta.Y) end,function(moved) if moved then window:_clampFrame(floating) else window:Toggle() end end) end)
    searchButton.MouseButton1Click:Connect(function() window:OpenSearch() end); minimizeButton.MouseButton1Click:Connect(function() window:_setVisible(false) end); closeButton.MouseButton1Click:Connect(function() window:_setVisible(false) end)
    window:_connect(UserInputService.InputBegan,function(input,processed) if not processed and input.KeyCode==Enum.KeyCode.K and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) and main.Visible then window:OpenSearch() end end)
    local cameraConnection=nil; local function bindCamera() if cameraConnection then pcall(DisconnectConnection,cameraConnection) end; local camera=Workspace.CurrentCamera; if camera then cameraConnection=camera:GetPropertyChangedSignal("ViewportSize"):Connect(function() window:_applyResponsive(false) end); window._connections[#window._connections+1]=cameraConnection end end; window:_connect(Workspace:GetPropertyChangedSignal("CurrentCamera"),function() bindCamera(); window:_applyResponsive(false) end); bindCamera()
    window.UserScale=tonumber(RE4UI:GetPreference("uiScale",1)) or 1; window.CompactDensity=RE4UI:GetPreference("compactDensity",false)==true; window.ReducedMotion=RE4UI:GetPreference("reducedMotion",false)==true
    gui.Destroying:Connect(function() if window.Alive~=true then return end; window.Alive=false; window.Generation=window.Generation+1; if window.Overlay then window.Overlay:Close() end; if window.Input then window.Input:Destroy() end; for h in pairs(window._delayedTasks) do pcall(function() task.cancel(h) end) end; table.clear(window._delayedTasks); for _,c in ipairs(window._connections) do pcall(DisconnectConnection,c) end; table.clear(window._connections); for _,l in ipairs(window._languageListeners) do LanguageManager:OffChanged(l) end; table.clear(window._languageListeners); for _,cb in ipairs(window._cleanupCallbacks) do pcall(cb) end; table.clear(window._cleanupCallbacks); for i=#(RE4UI._Windows or {}),1,-1 do if RE4UI._Windows[i]==window then table.remove(RE4UI._Windows,i) end end; if RE4UI.LastWindow==window then RE4UI.LastWindow=nil end; if #(RE4UI._Windows or {})==0 and LanguageManager.Active==true then LanguageManager:Shutdown() end end)
    window.LayoutManager={Refresh=function(_,recenter) return window:_applyResponsive(recenter==true) end,Mode=function() return window.SingleColumn and "SingleColumn" or (window.IconRail and "IconRail" or "TwoColumn") end}; window.SearchManager={Open=function() return window:OpenSearch() end}; window.VisibilityManager={Refresh=function() return window:RefreshVisibility(true) end}; window.PreferenceManager={Get=function(_,k,d) return RE4UI:GetPreference(k,d) end,Set=function(_,k,v) return RE4UI:SetPreference(k,v) end}
    RE4UI._Windows[#RE4UI._Windows+1]=window; RE4UI.LastWindow=window; window:_applyResponsive(true); return window
end

function RE4UI:Notify(options) if self.LastWindow then return self.LastWindow:Notify(options) end end

-- ============================================================================
-- ESP / floating gameplay overlays keep centralized styling.
-- ============================================================================
function RE4UI.CreateESPBillboard(adornee,guiName,presetName)
    if not adornee then return nil,nil end
    local cfg=C.Overlay.ESP; local preset=cfg.Presets[presetName] or cfg.Presets.Island
    local gui=New("BillboardGui",{Name=guiName or "RE4Esp",Size=cfg.Size,ExtentsOffset=cfg.Offset,Adornee=adornee,AlwaysOnTop=true},adornee)
    local text=New("TextLabel",{Name="TextLabel",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,TextStrokeTransparency=cfg.TextStrokeTransparency,Font=preset.Font,TextWrapped=true,TextColor3=preset.Color,TextSize=TX.RowDesc},gui)
    return gui,text
end
-- ============================================================================
-- Presentation sea context. Core remains authoritative for runtime/game state;
-- this value only drives responsive visibility rules on already-rendered controls.
-- ============================================================================
function RE4UI:SetSea(sea)
    self.CurrentSea=tonumber(sea) or 0
    local alive={}
    for _,window in ipairs(self._Windows or {}) do
        if window and window.Gui and window.Gui.Parent then
            alive[#alive+1]=window
            if window.Context then window.Context.SeaNumber=self.CurrentSea end
            SafeCall("RefreshSeaVisibility",function() window:RefreshVisibility(true) end)
        end
    end
    self._Windows=alive
    return self.CurrentSea
end

-- Core binding ---------------------------------------------------------------
-- Everything below this boundary is presentation-only. No game remote, NPC,
-- mob, quest, movement, combat or automation resolver is implemented here.
local function RE4PrettyId(id)
    local text=tostring(id or ""):gsub("^[^%.]+%.",""):gsub("[._]+"," ")
    text=text:gsub("(%a)([%w']*)",function(a,b) return string.upper(a)..b end)
    return text~="" and text or tr("ui.feature")
end
local function RE4ControlKey(id,suffix) return "controls."..tostring(id or "unknown").."."..tostring(suffix or "title") end
local function RE4SectionKey(id) return "sections."..tostring(id or "general")..".title" end

RE4UI.RouteAudit={Fallbacks={},Counts={}}
function RE4UI:_routeControl(descriptor)
    descriptor=type(descriptor)=="table" and descriptor or {}; local id=tostring(descriptor.Id or ""):lower(); local schema=C.PresentationSchema
    for _,rule in ipairs(schema.ControlRoutes or {}) do if id:find(tostring(rule.Pattern or ""):lower(),1,true) then self.RouteAudit.Counts[rule.Tab]=(self.RouteAudit.Counts[rule.Tab] or 0)+1; return rule.Tab,rule.Section,"control" end end
    local domain=tostring(descriptor.Domain or "runtime"); local group=tostring(descriptor.Group or descriptor.Domain or "general"); local mapped=schema.GroupRoutes and schema.GroupRoutes[domain.."/"..group]
    if mapped then self.RouteAudit.Counts[mapped.Tab]=(self.RouteAudit.Counts[mapped.Tab] or 0)+1; return mapped.Tab,mapped.Section,"group" end
    local tab=(schema.DomainDefaults and schema.DomainDefaults[domain]) or "System"; if NavigationKeySet[tab]~=true then tab="System" end; local slug=group:lower():gsub("[^%w_%.]+","_"); if slug=="" then slug="general" end; local section=tab:lower().."."..slug; self.RouteAudit.Fallbacks[tostring(descriptor.Id or "unknown")]={Domain=domain,Group=group,Tab=tab,Section=section}; self.RouteAudit.Counts[tab]=(self.RouteAudit.Counts[tab] or 0)+1; return tab,section,"fallback"
end

local function RE4ApplyDisabled(control,state)
    if not control then return end
    control.Disabled=state.Disabled==true
    local enabled=state.Disabled~=true
    if control.Button then pcall(function() control.Button.Active=enabled end) end
    if control.Hit then pcall(function() control.Hit.Active=enabled end) end
    if control.Box then pcall(function() control.Box.TextEditable=enabled end) end
end
function RE4UI:_applyCoreState(control,state)
    if not control or type(state)~="table" then return end
    local desiredVisible=state.Visible~=false
    local currentVisible=control.Visible
    -- Presentation state may be delivered after Core work that originated from a
    -- restricted game thread. Never read Instance properties directly at this
    -- boundary; the presentation dispatcher applies Instance mutations on the
    -- UI-owned thread below. IsVisible is optional and protected for future controls.
    if currentVisible==nil and type(control.IsVisible)=="function" then
        local ok,value=pcall(control.IsVisible,control)
        if ok then currentVisible=value end
    end
    if control.SetVisible and currentVisible~=desiredVisible then pcall(control.SetVisible,control,desiredVisible) end
    RE4ApplyDisabled(control,state)
    if state.Options and control.SetOptions then pcall(control.SetOptions,control,state.Options) end
    if state.Items and control.SetItems then pcall(control.SetItems,control,state.Items) end
    if state.Value~=nil and control.SetValue and state.Kind~="Button" then pcall(control.SetValue,control,state.Value,false) end
    if state.Kind=="Progress" and control.SetProgress then
        local label=state.ProgressLabel
        if type(label)=="table" and label.Key then label=self:T(label.Key,label.Params,label.Fallback) elseif label~=nil then label=tostring(label) else label="" end
        pcall(control.SetProgress,control,state.Progress or 0,state.Max or 1,label)
    end
    local status=state.Status
    local tone=state.Tone
    if (status==nil or status=="") and state.Kind=="Toggle" and type(state.RuntimeOwners)=="table" and next(state.RuntimeOwners)~=nil then
        local runtime=tostring(state.RuntimeState or "configured")
        local runtimeKeys={running="status.running",starting="status.starting",stopping="status.stopping",error="status.runtime_error_stopped",stopped="status.stopped",completed="status.stopped",configured="status.configured"}
        local runtimeTones={running="running",starting="working",stopping="waiting",error="error",stopped="muted",completed="muted",configured="waiting"}
        local key=runtimeKeys[runtime]
        if key then status={Key=key}; tone=runtimeTones[runtime] end
    end
    if type(status)=="table" and status.Key and control.SetStatusKey then
        pcall(control.SetStatusKey,control,status.Key,status.Params,tone,status.Fallback)
    elseif status~=nil and control.SetStatus then
        pcall(control.SetStatus,control,tostring(status),tone)
    end
end
function RE4UI:Shutdown(reason)
    -- Presentation owns every Window and localization callback it creates. This is
    -- safe both after a completed attach and while Attach is only partially built.
    local core=(self._Attachment and self._Attachment.Core) or self._AttachCore
    local windows={}
    for _,window in ipairs(self._Windows or {}) do windows[#windows+1]=window end
    for _,window in ipairs(windows) do
        local gui=window and window.Gui
        if gui and gui.Parent then pcall(function() gui:Destroy() end) end
    end
    self._Windows={}
    self.LastWindow=nil
    if LanguageManager.Active==true then LanguageManager:Shutdown() end
    self._FetchText=nil
    self._Attachment=nil
    self._AttachCore=nil
    if type(core)=="table" and type(core.SetPresentationState)=="function" then pcall(core.SetPresentationState,core,{Visible=false,Attached=false}) end
    return true
end

function RE4UI:Attach(Core)
    if type(Core)~="table" or tonumber(Core.Schema)~=1 or tonumber(Core.ApiVersion)~=1 then
        return nil,"unsupported_core_api"
    end
    self._AttachCore=Core
    if self._Attachment and self._Attachment.Window and self._Attachment.Window.Gui and self._Attachment.Window.Gui.Parent then
        return self._Attachment.Window
    end
    local config=Core:GetConfig()
    self._FetchText=function(url,label) return Core:FetchText(url,label) end
    if type(config)~="table" then return nil,"missing_config" end
    self:ConfigureLocalization({
        BaseUrl=Core:GetSourceUrl("LanguageBase"),
        Default=config.Localization and config.Localization.Default or "vi",
        Fallback=config.Localization and config.Localization.Fallback or "en",
        Current=tostring(self:GetPreference("language",config.Localization and config.Localization.Default or "vi")),
        Languages=config.Localization and config.Localization.Languages or {en="English",vi="Tiếng Việt"},
    })
    -- Do not block first paint on the manifest. Config already carries the known
    -- language list; the remote manifest is refreshed after the shell is mounted.
    local requested=self:GetPreference("language",config.Localization and config.Localization.Default or "vi")
    self:SetLanguage(requested)

    local seaNumber=select(1,Core:Query("runtime.sea"))
    self:SetSea(tonumber(seaNumber) or 0)
    local seaKey=(tonumber(seaNumber)==3 and "sea.third") or (tonumber(seaNumber)==2 and "sea.second") or (tonumber(seaNumber)==1 and "sea.first") or "sea.unknown"
    local Window=self:MakeWindow({Title=config.HubName or self.HubName,SubTitle=self:T("ui.subtitle"),SeaName=self:T(seaKey)})
    if not Window or not Window.Gui or not Window.Gui.Parent then return nil,"window_mount_failed" end
    Window.OnVisibilityChanged=function(visible) if type(Core.SetPresentationState)=="function" then Core:SetPresentationState({Visible=visible}) end end
    Window.OnTabChanged=function(tab) if type(Core.SetPresentationState)=="function" then Core:SetPresentationState({ActiveTab=tab and tab.Key or nil}) end end
    if type(Core.SetPresentationState)=="function" then
        local attached,attachReason=Core:SetPresentationState({Root=Window.Gui,Visible=true,Attached=true})
        if attached~=true then
            if Window.Gui and Window.Gui.Parent then pcall(function() Window.Gui:Destroy() end) end
            return nil,attachReason or "presentation_attach_rejected"
        end
    end
    local tabs={}
    for _,tabDef in ipairs(self.Config.PresentationSchema.Tabs) do
        tabs[tabDef.Key]=Window:MakeTab({Key=tabDef.Key,Title=tabDef.Title,TitleKey=tabDef.TitleKey,MobileTitleKey=tabDef.MobileTitleKey})
    end
    local sectionCache,rendered={},{}
    local function sectionFor(tabKey,sectionId)
        local canonicalKey=canonicalTabKey(tabKey)
        local tab=tabs[canonicalKey] or tabs.System
        local cacheKey=tostring(canonicalKey)..":"..tostring(sectionId)
        local section=sectionCache[cacheKey]
        if not section then
            local fallback=RE4PrettyId(sectionId)
            section=tab:AddSection({Id=tostring(sectionId),Title=fallback})
            sectionCache[cacheKey]=section
        else
            -- Descriptor registration order is not guaranteed to be section-contiguous.
            -- Re-select the cached section so a later control cannot leak into whichever
            -- section happened to be current most recently on the same tab.
            tab.CurrentSection=section
        end
        return tab
    end
    local function renderDescriptor(d)
        if type(d)~="table" or rendered[d.Id] then return rendered[d.Id] end
        local tabKey,sectionId=self:_routeControl(d)
        local tab=sectionFor(tabKey,sectionId)
        local titleKey=d.TitleKey or RE4ControlKey(d.Id,"title")
        local descKey=d.DescriptionKey or RE4ControlKey(d.Id,"description")
        local common={Id=d.Id,Name=RE4PrettyId(d.Id),TitleKey=titleKey,Description="",DescriptionKey=descKey,ActionTextKey=d.ActionTextKey,Order=d.Order,Seas=d.Seas,InvokeInitialCallback=false}
        local control
        if d.Kind=="Toggle" then
            common.Default=d.Value==true; common.Callback=function(value) return Core:SetFeatureEnabled(d.Id,value) end
            control=tab:AddToggle(common)
        elseif d.Kind=="Button" then
            common.Callback=function() local ok,reason=Core:InvokeAction(d.Id); if ok==false and reason then Window:Notify({Title=config.HubName,ContentKey="notify.action_failed",Params={reason=tostring(reason)},Tone="warn"}) end; return ok,reason end
            control=tab:AddButton(common)
        elseif d.Kind=="Dropdown" then
            common.Options=d.Options or {}; common.Default=d.Value; common.LocalizeOptions=d.LocalizeOptions; common.OptionLabelKeys=d.OptionLabelKeys
            common.Callback=function(value) return Core:SetOption(d.Id,value) end
            control=tab:AddDropdown(common)
        elseif d.Kind=="Slider" then
            common.Min=d.Min or 0; common.Max=d.Max or 100; common.Rounding=d.Rounding or 1; common.Default=d.Value or common.Min
            common.Callback=function(value) return Core:SetOption(d.Id,value) end
            control=tab:AddSlider(common)
        elseif d.Kind=="TextBox" then
            common.Default=d.Value or ""; common.Placeholder=d.Placeholder or ""; common.PlaceholderKey=d.PlaceholderKey; common.Callback=function(value) return Core:SetOption(d.Id,value) end
            control=tab:AddTextBox(common)
        elseif d.Kind=="InfoList" then
            common.Title=RE4PrettyId(d.Id); common.Items=d.Items or {}; common.OnItemAction=function(item) if type(item)=="table" and item.ActionId then return Core:SetFeatureEnabled(item.ActionId,false) end return false,"action_unavailable" end; control=tab:AddInfoList(common)
        elseif d.Kind=="Progress" then
            common.Title=RE4PrettyId(d.Id); common.Value=d.Progress or 0; common.Max=d.Max or 1; control=tab:AddProgress(common)
        elseif d.Kind=="Paragraph" then
            common.Title=RE4PrettyId(d.Id); control=tab:AddParagraph(common)
        else
            common.Title=RE4PrettyId(d.Id); control=tab:AddStatus(common)
        end
        rendered[d.Id]=control
        self:_applyCoreState(control,Core:GetState(d.Id))
        return control
    end
    -- Registry is finalized before presentation attach, so one immutable descriptor
    -- snapshot is sufficient and avoids repeated table cloning/scans during mount.
    local initialDescriptors=Core:GetControls()
    if type(initialDescriptors)~="table" then initialDescriptors={} end
    for _,d in ipairs(initialDescriptors) do renderDescriptor(d) end

    -- UI-only settings are deliberately defined here; changing them never touches Core.
    local settings=tabs.System
    if settings then
        settings:AddSection({Id="system.interface",TitleKey="presentation.sections.system_interface"})
        local displayToCode,codeToDisplay,languageOptions={},{},{}
        local function rebuildLanguages()
            table.clear(displayToCode); table.clear(codeToDisplay); table.clear(languageOptions)
            for _,language in ipairs(self:GetLanguageOptions()) do displayToCode[language.Name]=language.Code; codeToDisplay[language.Code]=language.Name; languageOptions[#languageOptions+1]=language.Name end
        end
        rebuildLanguages()
        local lang=settings:AddDropdown({Id="ui.language",TitleKey="settings.language_title",Description="",DescriptionKey="settings.language_desc",Options=languageOptions,LocalizeOptions=false,Default=codeToDisplay[self:GetLanguage()] or languageOptions[1],Callback=function(value)
            local code=displayToCode[tostring(value)]; if code then self:SetLanguage(code) end
        end})
        local scaleControl=settings:AddSlider({Id="ui.scale",TitleKey="settings.scale_title",Description="",DescriptionKey="settings.scale_desc",Min=82,Max=112,Rounding=5,Default=math.floor((tonumber(self:GetPreference("uiScale",1)) or 1)*100+0.5),Callback=function(v) Window:SetScale((tonumber(v) or 100)/100) end})
        local compactControl=settings:AddToggle({Id="ui.compact",TitleKey="settings.density_title",Description="",DescriptionKey="settings.density_desc",Default=self:GetPreference("compactDensity",false)==true,Callback=function(v) Window:SetCompactDensity(v) end})
        local motionControl=settings:AddToggle({Id="ui.motion",TitleKey="settings.motion_title",Description="",DescriptionKey="settings.motion_desc",Default=self:GetPreference("reducedMotion",false)==true,Callback=function(v) Window:SetReducedMotion(v) end})
        settings:AddButton({Id="ui.search",TitleKey="settings.search_title",Description="",DescriptionKey="settings.search_desc",Callback=function() Window:OpenSearch() end})
        settings:AddButton({Id="ui.reset_settings",TitleKey="settings.reset_title",Description="",DescriptionKey="settings.reset_desc",ActionTextKey="action.reset",Callback=function()
            local ok,reason=Core:ResetUserSettings()
            if ok~=true then Window:Notify({Title=RE4UI.HubName,ContentKey="settings.reset_failed",Params={reason=tostring(reason or "unknown")},Tone="error"}); return false end
            self:ResetPreferences()
            Window.UserScale=1; Window.CompactDensity=false; Window.ReducedMotion=false
            if scaleControl and scaleControl.SetValue then scaleControl:SetValue(100,false) end
            if compactControl and compactControl.SetValue then compactControl:SetValue(false,false) end
            if motionControl and motionControl.SetValue then motionControl:SetValue(false,false) end
            local defaultLanguage=tostring(config.Localization and config.Localization.Default or "vi")
            self:SetLanguage(defaultLanguage)
            local defaultLabel=codeToDisplay[defaultLanguage]; if defaultLabel and lang and lang.SetValue then lang:SetValue(defaultLabel,false) end
            Window:_applyResponsive(false)
            Window:Notify({Title=RE4UI.HubName,ContentKey="settings.reset_done",Tone="good"})
            return true
        end})
        self:OnLanguageChanged(function()
            rebuildLanguages(); if lang and lang.SetOptions then lang:SetOptions(languageOptions) end
            local label=codeToDisplay[self:GetLanguage()]; if label and lang and lang.SetValue then lang:SetValue(label,false) end
        end)
        Window:_delay(tonumber(config.Localization and config.Localization.ManifestDelay) or 0,function()
            local ok=self:LoadLanguageManifest()
            if ok~=true then return end
            rebuildLanguages()
            if lang and lang.SetOptions then lang:SetOptions(languageOptions) end
            local label=codeToDisplay[self:GetLanguage()]
            if label and lang and lang.SetValue then lang:SetValue(label,false) end
        end)
    end

    for _,tab in ipairs(Window.Tabs or {}) do if tab.StabilizeLayout then tab:StabilizeLayout() end end
    local requestedTab=tostring(Core.PresentationTab or "")
    Window:ShowTab(tabs[requestedTab] or tabs.Main or tabs.Farm or tabs.System)

    local overlays={}
    local function removeOverlay(id)
        local gui=overlays[id]; overlays[id]=nil
        if gui then pcall(function() gui:Destroy() end) end
    end
    local function renderOverlay(state)
        if type(state)~="table" or not state.Id then return end
        local id=tostring(state.Id); local adornee=state.Adornee
        if typeof(adornee)~="Instance" or not adornee.Parent then removeOverlay(id); return end
        local gui=overlays[id]
        if not gui or not gui.Parent or gui.Adornee~=adornee then
            removeOverlay(id); gui=self.CreateESPBillboard(adornee,"RE4Overlay",state.Preset or "Island"); overlays[id]=gui
        end
        local label=gui and gui:FindFirstChild("TextLabel")
        if label then
            if state.TextKey then label.Text=self:T(state.TextKey,state.Params,state.TextKey) else label.Text=tostring(state.Text or "") end
        end
    end
    for _,overlay in ipairs(Core:GetOverlays()) do renderOverlay(overlay) end
    local subscriptions={}
    -- Core events can originate from scheduler/game callbacks whose thread identity
    -- is intentionally lower than the executor-owned presentation thread. The Core
    -- subscriber boundary therefore stays pure-Lua: callbacks only enqueue ids/data.
    -- A single dispatcher created by Attach owns every later Instance read/write.
    -- Control ids are coalesced so bursts such as Items+Status+Ownership render once
    -- using the newest Core state instead of replaying stale intermediate snapshots.
    local presentationQueue={Active=true,DirtyControls={},OverlayEvents={},Notifications={}}
    local function enqueueControl(event)
        local id=event and event.Id
        if id~=nil then presentationQueue.DirtyControls[tostring(id)]=true end
    end
    local function enqueueOverlay(event)
        if type(event)~="table" or event.Id==nil then return end
        local id=tostring(event.Id)
        presentationQueue.OverlayEvents[id]={Id=id,Removed=event.Removed==true,State=event.State or event}
    end
    local function enqueueNotification(payload)
        payload=type(payload)=="table" and payload or {Content=tostring(payload or "")}
        presentationQueue.Notifications[#presentationQueue.Notifications+1]=payload
    end
    local function renderNotification(payload)
        local copy={}; for k,v in pairs(payload or {}) do copy[k]=v end
        if copy.ContentKey then copy.Content=self:T(copy.ContentKey,copy.Params,copy.Content or copy.ContentKey) end
        if type(copy.Title)=="table" and copy.Title.Key then copy.Title=self:T(copy.Title.Key,copy.Title.Params,copy.Title.Fallback) end
        Window:Notify(copy)
    end

    -- Core rejects control registration after FinalizeRegistry(), which is a
    -- prerequisite of Attach. A post-attach "registered" subscription therefore
    -- had no reachable producer and only retained an unused callback.
    subscriptions[#subscriptions+1]=Core:Subscribe("control",enqueueControl)
    subscriptions[#subscriptions+1]=Core:Subscribe("overlay",enqueueOverlay)
    subscriptions[#subscriptions+1]=Core:Subscribe("notify",enqueueNotification)

    -- Notifications emitted before Attach are consumed once here on the UI-owned
    -- thread. New notifications arrive through the pure-Lua queue above.
    for _,payload in ipairs(Core:DrainNotifications()) do enqueueNotification(payload) end

    local dispatcherGeneration=Window.Generation
    local dispatcherThread
    dispatcherThread=task.spawn(function()
        while presentationQueue.Active==true and Window.Alive==true and Window.Generation==dispatcherGeneration do
            task.wait(0.05)
            if presentationQueue.Active~=true or Window.Alive~=true or Window.Generation~=dispatcherGeneration then break end

            local dirtyControls=presentationQueue.DirtyControls
            presentationQueue.DirtyControls={}
            for id in pairs(dirtyControls) do
                local control=rendered[id]
                if control then
                    local state=Core:GetState(id)
                    if state then self:_applyCoreState(control,state) end
                end
            end

            local overlayEvents=presentationQueue.OverlayEvents
            presentationQueue.OverlayEvents={}
            for id,event in pairs(overlayEvents) do
                if event.Removed then removeOverlay(id) else renderOverlay(event.State or event) end
            end

            local notifications=presentationQueue.Notifications
            presentationQueue.Notifications={}
            for _,payload in ipairs(notifications) do renderNotification(payload) end
        end
    end)

    local attachment={Core=Core,Window=Window,Tabs=tabs,Controls=rendered,Subscriptions=subscriptions,PresentationQueue=presentationQueue,DispatcherThread=dispatcherThread}
    self._Attachment=attachment
    Window.Gui.Destroying:Connect(function()
        presentationQueue.Active=false
        local oldDispatcher=dispatcherThread; dispatcherThread=nil
        if oldDispatcher and oldDispatcher~=coroutine.running() and type(task.cancel)=="function" then pcall(task.cancel,oldDispatcher) end
        for _,subscription in ipairs(subscriptions) do pcall(function() subscription:Disconnect() end) end
        for id in pairs(overlays) do removeOverlay(id) end
        table.clear(subscriptions)
        table.clear(overlays)
        table.clear(presentationQueue.DirtyControls)
        table.clear(presentationQueue.OverlayEvents)
        table.clear(presentationQueue.Notifications)
        table.clear(rendered)
        table.clear(sectionCache)
        if type(Core.SetPresentationState)=="function" then Core:SetPresentationState({Visible=false,Attached=false}) else Core.Attached=false end
        if self._Attachment==attachment then self._Attachment=nil; self._FetchText=nil end
    end)
    return Window
end

return RE4UI

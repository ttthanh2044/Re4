--[[
RE4 HUB UI · HORIZONTAL APPLICATION SHELL
Version/release stamp are derived from metadata.lua
Compact horizontal responsive application shell for Roblox / executor environments.

Design goals:
- Keep legacy AddToggle/AddButton/... API compatible with RE4 HUB gameplay code.
- Section-first layout: one panel contains many compact controls instead of one card per toggle.
- Desktop/tablet horizontal tab navigation + content workspace; mobile bottom navigation + one-column pages.
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
local Metadata=env.RE4_APP_METADATA
if type(Metadata)~="table" or tostring(Metadata.Version or "")=="" then
    error("[RE4 HUB/UI] metadata.lua is required")
end
local RE4UI = {}
RE4UI.__index = RE4UI
RE4UI.Version = Metadata.Version
RE4UI.ReleaseStamp = Metadata.UIStamp
RE4UI.DisplayVersion = Metadata.DisplayVersion
RE4UI.HubName = tostring(Metadata.HubName or Metadata.Product)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

RE4UI.Config = {
    Assets = {
        Logo = "rbxassetid://129347191626169",
        Header = "rbxassetid://77866589839728",
        Search = "rbxassetid://115639474901135",
    },

    -- Nine visual destinations. Legacy names are resolved through TabAliases so
    -- gameplay/bootstrap code can keep using the existing tab references.
    Navigation = {
        {Key="Home", Title="Home", TitleKey="nav.home", Subtitle="Overview, server & release information", SubtitleKey="page.home", Icon="rbxassetid://98842907608427", Group="OVERVIEW", GroupKey="group.overview", Mobile=true},
        {Key="Farm", Title="Farm", TitleKey="nav.farm", Subtitle="Automatic farming & targets", SubtitleKey="page.farm", Icon="rbxassetid://102626487778468", Group="AUTOMATION", GroupKey="group.automation", Mobile=true},
        {Key="Progress", Title="Progress", TitleKey="nav.progress", Subtitle="Progression, quests & race", SubtitleKey="page.progress", Icon="rbxassetid://85102095728618", Group="PROGRESSION", GroupKey="group.progression", Mobile=true},
        {Key="Items", Title="Items", TitleKey="nav.items", Subtitle="Equipment, fighting styles & ownership", SubtitleKey="page.items", Icon="rbxassetid://83845432645469", Group="INVENTORY", GroupKey="group.progression", Mobile=true},
        {Key="World", Title="World", TitleKey="nav.world", Subtitle="Sea content, events & exploration", SubtitleKey="page.world", Icon="rbxassetid://135066964737869", Group="WORLD", GroupKey="group.world"},
        {Key="Raid", Title="Raid", TitleKey="nav.raid", Subtitle="Raid setup & automation", SubtitleKey="page.raid", Icon="rbxassetid://116013617782351", Group="AUTOMATION", GroupKey="group.automation"},
        {Key="Teleport", Title="Teleport", TitleKey="nav.teleport", Subtitle="World, NPC, player & server travel", SubtitleKey="page.teleport", Icon="rbxassetid://79776725897471", Group="WORLD", GroupKey="group.world", Mobile=true},
        {Key="Combat", Title="Combat", TitleKey="nav.combat", Subtitle="Attack, targeting & combat support", SubtitleKey="page.combat", Icon="rbxassetid://119501760627949", Group="TOOLS", GroupKey="group.tools"},
        {Key="Settings", Title="Settings", TitleKey="nav.settings", Subtitle="Interface, utilities & runtime", SubtitleKey="page.settings", Icon="rbxassetid://108260028570537", Group="SYSTEM", GroupKey="group.system"},

        -- Compatibility-only definitions. MakeTab canonicalizes these before any
        -- visual object is created, so they never add extra navigation entries.
        {Key="Fruit", Title="Fruit", AliasOnly=true},
        {Key="Quest", Title="Progression", TitleKey="nav.progression", AliasOnly=true},
        {Key="Quests", Title="Quests", AliasOnly=true},
        {Key="Race", Title="Race", TitleKey="nav.race", AliasOnly=true},
        {Key="Sea", Title="Sea", TitleKey="nav.sea", AliasOnly=true},
        {Key="Events", Title="Events", AliasOnly=true},
        {Key="Utilities", Title="Utilities", AliasOnly=true},
    },

    TabAliases = {
        Fruit="Items", Fruits="Items",
        Quest="Progress", Quests="Progress", Progression="Progress", Race="Progress",
        Sea="World", Events="World", Mirage="World", SeaEvent="World", Prehistoric="World",
        Utilities="Settings", Misc="Settings",
    },

    MobilePrimary = {"Home", "Farm", "Items", "Teleport"},

    Theme = {
        Background = Color3.fromRGB(12, 13, 14),
        Window = Color3.fromRGB(16, 17, 18),
        Topbar = Color3.fromRGB(18, 19, 21),
        Surface = Color3.fromRGB(23, 25, 27),
        SurfaceRaised = Color3.fromRGB(29, 32, 35),
        SurfaceHover = Color3.fromRGB(35, 38, 42),
        Control = Color3.fromRGB(27, 29, 32),
        ControlHover = Color3.fromRGB(38, 41, 45),
        Divider = Color3.fromRGB(41, 44, 48),
        Stroke = Color3.fromRGB(48, 52, 57),
        Text = Color3.fromRGB(244, 244, 244),
        TextSoft = Color3.fromRGB(202, 205, 209),
        Muted = Color3.fromRGB(146, 151, 157),
        Accent = Color3.fromRGB(226, 61, 69),
        AccentHover = Color3.fromRGB(238, 78, 86),
        AccentSecondary = Color3.fromRGB(188, 51, 58),
        AccentSoft = Color3.fromRGB(82, 36, 40),
        AccentFaint = Color3.fromRGB(45, 28, 30),
        Good = Color3.fromRGB(84, 196, 128),
        Warn = Color3.fromRGB(219, 169, 83),
        Bad = Color3.fromRGB(226, 72, 80),
        Info = Color3.fromRGB(181, 187, 194),
        Shadow = Color3.fromRGB(0, 0, 0),
        GradientDark = Color3.fromRGB(16, 17, 18),
        GradientLight = Color3.fromRGB(22, 24, 26),
    },

    Breakpoints = {
        Mobile = 640,
        Tablet = 980,
        CompactHeight = 520,
        NarrowMobile = 430,
        TinyWidth = 360,
        TinyHeight = 420,
    },

    Window = {
        DesktopWidth = 840,
        DesktopHeight = 540,
        TabletWidth = 730,
        TabletHeight = 500,
        MobileMaxWidth = 430,
        MobileMaxHeight = 620,
        MarginDesktop = 20,
        MarginTablet = 12,
        MarginMobile = 7,
        Radius = 14,
        SidebarDesktop = 0,
        SidebarCompact = 0,
        TopbarDesktop = 46,
        TopbarMobile = 44,
        NavDesktop = 50,
        PageHeaderDesktop = 46,
        PageHeaderMobile = 42,
        Runtime = 30,
        Footer = 30,
        MobileNav = 56,
        FloatingWidth = 42,
        FloatingHeight = 42,
    },

    Metrics = {
        PagePadDesktop = 9,
        PagePadMobile = 8,
        ColumnGap = 8,
        SectionGap = 8,
        SectionRadius = 10,
        SectionHeader = 31,
        SectionPad = 9,
        RowDesktop = 46,
        RowMobile = 56,
        RowCompact = 42,
        RowStackedMobile = 86,
        ControlHeightDesktop = 30,
        ControlHeightMobile = 36,
        SwitchW = 42,
        SwitchH = 22,
        PopupRadius = 12,
    },

    -- Explicit visual composition rules. These only decide where existing sections
    -- are rendered; callback/state/gameplay behavior remains untouched.
    SectionLayoutProfiles = {},

    Typography = {
        Brand = 18,
        PageTitle = 18,
        Section = 12,
        RowTitle = 12,
        RowDesc = 10,
        Meta = 9,
        Status = 9,
        Control = 11,
        MobileRowTitle = 13,
        MobileRowDesc = 10,
    },

    Motion = {
        Instant = 0.05,
        Fast = 0.08,
        Normal = 0.12,
        Slow = 0.16,
    },

    Overlay = {
        ESP = {
            Size = UDim2.new(1, 200, 1, 30),
            Offset = Vector3.new(0, 1, 0),
            TextStrokeTransparency = 0.5,
            Presets = {
                Island = {Font=Enum.Font.GothamMedium},
                Fruit = {Font=Enum.Font.GothamMedium},
                Chest = {Font=Enum.Font.Code},
                PlayerAlly = {Font=Enum.Font.GothamMedium},
                PlayerEnemy = {Font=Enum.Font.GothamMedium},
            },
        },
        FloatingToggle = {
            Width=88, Height=36, Radius=11, Margin=8,
            Positions={Player=UDim2.fromOffset(10,90), NPC=UDim2.fromOffset(10,48)},
        },
    },
}

local C = RE4UI.Config
local T = C.Theme
local M = C.Metrics
local TX = C.Typography

local function canonicalTabKey(key)
    local raw=tostring(key or "")
    return (C.TabAliases and C.TabAliases[raw]) or raw
end

local function resolveTabFromMap(tabMap,key)
    if type(tabMap)~="table" then return nil end
    local raw=tostring(key or "")
    local canonical=canonicalTabKey(raw)
    if tabMap[canonical] then return tabMap[canonical] end
    if tabMap[raw] then return tabMap[raw] end
    for alias,target in pairs(C.TabAliases or {}) do
        if target==canonical and tabMap[alias] then return tabMap[alias] end
    end
    return nil
end

local function sectionLayoutRule(tabKey,title)
    local metadata=RE4UI.FeatureMetadata
    local profiles=type(metadata)=="table" and metadata.SectionLayoutProfiles or nil
    if type(profiles)~="table" then profiles=C.SectionLayoutProfiles end
    local profile=profiles and profiles[canonicalTabKey(tabKey)]
    return profile and profile[tostring(title or ""):lower()] or nil
end

-- Semantic overlay colors consume the same centralized palette as the shell.
C.Overlay.ESP.Presets.Island.Color=T.Text
C.Overlay.ESP.Presets.Fruit.Color=T.Text
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

local function Gradient(parent, rotation)
    if not parent then return nil end
    return New("UIGradient", {
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0.00,T.GradientDark),
            ColorSequenceKeypoint.new(1.00,T.GradientLight),
        }),
        Rotation=rotation or 90,
    }, parent)
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
    if tone == "good" or tone == "completed" then return T.Good end
    if tone == "warn" or tone == "waiting" or tone == "blocked" then return T.Warn end
    if tone == "bad" or tone == "error" then return T.Bad end
    if tone == "info" or tone == "running" then return T.Info end
    return T.Muted
end

local function normalizeText(text)
    return stripRichText(text):lower():gsub("[%p%c]", " "):gsub("%s+", " ")
end

local function MeasureText(text, size, font)
    return TextService:GetTextSize(tostring(text or ""), size or 11, font or Enum.Font.Gotham, Vector2.new(1000, 100))
end
local function estimateTextWidth(text, size, font)
    local ok, bounds = pcall(MeasureText, text, size, font)
    return ok and bounds.X or (#tostring(text or "") * (size or 11) * 0.55)
end

-- ============================================================================
-- Preferences + localization manager
-- ============================================================================
RE4UI._Windows = RE4UI._Windows or {}
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
    if prefs[key]==value then return value end
    prefs[key]=value
    savePreferences()
    return value
end

local EmergencyEnglish = {
    nav={home="Home",farm="Farm",progression="Progression",progress="Progress",world="World",raid="Raid",sea="Sea",race="Race",items="Items",teleport="Teleport",combat="Combat",settings="Settings"},
    group={overview="OVERVIEW",automation="AUTOMATION",progression="PROGRESSION",world="WORLD",tools="TOOLS",system="SYSTEM"},
    ui={search="Search",search_hint="Search features...",more="More",connected="Connected",ready="Ready",select="Select",general="General",information="Information",external_link="External link",external_disabled="External links are disabled in this build.",no_results="No matching features",language="Language",loading="Loading",unavailable="Unavailable"},
    action={run="Run",go="Go",buy="Buy",start="Start",copy="Copy",search="Search",use="Use",apply="Apply"},
    status={running="Running",owned="Owned",not_owned="Not owned",active="Active",working="Working",done="Done",error="Error",waiting="Waiting",available="Available",blocked="Blocked"},
    settings={interface="Interface",language_title="Language",language_desc="Change the interface language without reloading the Hub.",scale_title="UI Scale",scale_desc="Scale the interface while preserving responsive layout.",density_title="Compact Density",density_desc="Reduce desktop spacing without shrinking touch targets.",motion_title="Reduced Motion",motion_desc="Shorten transitions and animation duration.",search_title="Search Hub",search_desc="Find any visible feature quickly.",team_section="Startup & Team",auto_team_title="Auto Select Team",auto_team_desc="Automatically select the preferred team when joining before gameplay automation starts.",preferred_team_title="Preferred Team",preferred_team_desc="Choose which side Auto Select Team should use on the next join.",apply_team_title="Apply Team Now",apply_team_desc="Try to select the preferred team immediately using remote first, then the executor fallback.",team_status_title="Team Status",team_status_desc="Shows the team currently assigned by the game.",team_status_value="Current team: {team}"},
    runtime={ready="Ready",running_raid="Running · Raid",running_target="Running · {target}",nearest="Running · Nearest Enemy",dough_king="Running · Dough King",cake_prince="Running · Cake Prince",fast_attack="Combat · Fast Attack ready"},
    sea={first="First Sea",second="Second Sea",third="Third Sea",unknown="Unknown Sea"},
    team={pirates="Pirates",marines="Marines",not_selected="Not selected"},
    notify={team_selected="Selected {team} successfully via {method}.",team_select_failed="Unable to select team: {reason}"},
}

local LanguageManager = {
    Config={Default="vi",Fallback="en",Current="vi",BaseUrl="",Manifest="manifest.json",Languages={vi="Tiếng Việt",en="English"}},
    Cache={}, CurrentData=nil, FallbackData=nil, Bindings={}, Listeners={}, Loading={},
}

local function languageCacheFile(name)
    local stamp=tostring(RE4UI.ReleaseStamp or RE4UI.Version or "release"):gsub("[^%w_%-]","_")
    local clean=tostring(name or "data"):gsub("[^%w_%-%.]","_")
    return "RE4Hub_LangCache_"..stamp.."_"..clean
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
    raw=game:HttpGet(url)
    local decoded=HttpService:JSONDecode(raw)
    if type(decoded)~="table" then error("language JSON must decode to a table") end
    writeLanguageCache(name,raw)
    return decoded,"network"
end

local function nestedGet(root,key)
    if type(root)~="table" or type(key)~="string" then return nil end
    local node=root
    for part in key:gmatch("[^%.]+") do
        if type(node)~="table" then return nil end
        node=node[part]
        if node==nil then return nil end
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
    options=type(options)=="table" and options or {}
    for k,v in pairs(options) do self.Config[k]=v end
    if type(self.Config.Languages)~="table" then self.Config.Languages={vi="Tiếng Việt",en="English"} end
    self.Config.Current=tostring(self.Config.Current or self.Config.Default or "vi")
end

function LanguageManager:_baseUrl(fileName)
    local base=tostring(self.Config.BaseUrl or "")
    if base=="" then return nil end
    if base:sub(-1)~="/" then base=base.."/" end
    return base..tostring(fileName or "").."?v="..tostring(RE4UI.ReleaseStamp)
end

function LanguageManager:LoadManifest()
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
        warn("[RE4 HUB/Lang/Manifest] "..tostring(result))
        return false,result
    end
    self.ManifestData=result
    return true,result
end

function LanguageManager:_url(code)
    return self:_baseUrl(tostring(code)..".json")
end

function LanguageManager:Load(code)
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
    self.Loading[code]=nil
    if not ok then
        warn("[RE4 HUB/Lang]["..code.."] "..tostring(result))
        return nil,result
    end
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

    self.CurrentData=data
    self.Config.Current=applied
    RE4UI:SetPreference("language",applied)
    self:RefreshBindings()
    for _,callback in ipairs(self.Listeners) do SafeCall("LanguageChanged",callback,applied,requested,exact) end

    -- Warm the fallback after the requested language is already active. This keeps
    -- missing-key behavior intact without blocking first paint.
    if exact and requested~=fallbackCode and not self.FallbackData then
        task.delay(2,function()
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
function RE4UI:TL(source, params) return LanguageManager:Legacy(source,params) end
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
    if running then control:SetStatus("Running","running"); return end
    local code=tostring(state and state.Code or "unknown")
    if code=="owned" then control:SetStatus("Owned","completed")
    elseif code=="can_buy" then control:SetStatus("Can buy","info")
    elseif code=="blocked" then control:SetStatus("Requirements missing","blocked")
    elseif code=="not_owned" then control:SetStatus("Not owned","warn")
    elseif code=="variant_unconfirmed" then control:SetStatus("V2 unconfirmed","waiting")
    else control:SetStatus("Unknown","waiting") end
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
        Font=Enum.Font.Gotham,
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
        Font=Enum.Font.GothamMedium,
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
    Stroke(track, 0.66)
    local knob = New("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5),
        Size=UDim2.fromOffset(16,16),
        Position=initial and UDim2.new(1,-11,0.5,0) or UDim2.new(0,11,0.5,0),
        BackgroundColor3=T.Text,
        BorderSizePixel=0,
        ZIndex=8,
    }, track)
    Corner(knob, 16)
    return track, knob
end

-- ============================================================================
-- Window
-- ============================================================================
function RE4UI:MakeWindow(options)
    options = options or {}

    -- Do not make PlayerGui a hard prerequisite. Keep gethui priority where the
    -- executor supports it, then fall back to PlayerGui and finally CoreGui.
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local hosts = {}
    local seen = {}
    local function addHost(label, host)
        if typeof(host) == "Instance" and not seen[host] then
            seen[host]=true
            hosts[#hosts+1]={Label=label,Instance=host}
        end
    end
    if type(gethui) == "function" then
        local ok,hui=pcall(gethui)
        if ok then addHost("gethui",hui) end
    end
    addHost("PlayerGui",playerGui)
    local coreGuiOk,coreGui=pcall(function() return game:GetService("CoreGui") end)
    if coreGuiOk then addHost("CoreGui",coreGui) end
    if #hosts==0 then
        playerGui=LocalPlayer:WaitForChild("PlayerGui",5)
        addHost("PlayerGui",playerGui)
    end
    if #hosts==0 then error("[RE4 HUB/UI] no compatible GUI host is available") end

    -- Destroy previous shells before binding the new one. Include the current
    -- canonical casing so same-session replacement cannot leave a stale shell.
    for _,entry in ipairs(hosts) do
        local host=entry.Instance
        for _,name in ipairs({"RE4HubV4","RE4HubV5","RE4Hub","Re4Hub"}) do
            local old=host:FindFirstChild(name)
            if old then pcall(function() old:Destroy() end) end
        end
    end

    -- Create detached first and mount through the first host that accepts the real
    -- child-parent assignment. Failure is explicit instead of silently detaching UI.
    local gui = New("ScreenGui", {
        Name="Re4Hub", ResetOnSpawn=false, IgnoreGuiInset=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=999999,
    })
    local mountedLabel=nil
    for _,entry in ipairs(hosts) do
        if SafeParent(gui,entry.Instance) then
            mountedLabel=entry.Label
            break
        end
    end
    if not mountedLabel then
        pcall(function() gui:Destroy() end)
        error("[RE4 HUB/UI] ScreenGui could not be mounted to gethui, PlayerGui, or CoreGui")
    end
    print("[RE4 HUB/BOOT] UI mounted via "..tostring(mountedLabel))

    local window = {
        Gui=gui,
        Tabs={},
        TabsByKey={},
        Features={},
        FeatureById={},
        ResponsiveCallbacks={},
        Mode="Desktop",
        ActiveTab=nil,
        Hidden=false,
        UserDragged=false,
        Context={},
        _connections={},
        _toastOrder=0,
        VisibleTabs={},
        NarrowContent=false,
        TinyViewport=false,
        UserScale=1,
    }

    window.Input = createInputManager(window)
    window.Overlay = createOverlayManager(window, gui)

    -- ========================================================================
    -- COMPACT HORIZONTAL APPLICATION SHELL
    -- Visual-only shell. Gameplay-facing callbacks, registries and state objects
    -- remain below this layer and retain their existing contracts.
    -- ========================================================================
    local main = New("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
        BackgroundColor3=T.Window, BackgroundTransparency=0.03, BorderSizePixel=0,
        ClipsDescendants=true, Active=true, ZIndex=2,
    }, gui)
    Corner(main, C.Window.Radius)
    Stroke(main, 0.46, T.Stroke)

    window.Main=main; window.Shadow=nil
    local mainScale=New("UIScale",{Scale=1},main)
    window.MainScale=mainScale
    window.CompactDensity=false
    window.ReducedMotion=false
    window.NavCompact=false

    -- Horizontal navigation is fixed directly below the header. On narrow desktop
    -- widths it scrolls horizontally instead of sacrificing content width.
    local navBar=New("Frame",{
        BackgroundColor3=T.Window,BackgroundTransparency=0.02,BorderSizePixel=0,
        ClipsDescendants=true,ZIndex=4,
    },main)
    window.NavBar=navBar
    local navEdge=New("Frame",{
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,1),
        BackgroundColor3=T.Divider,BackgroundTransparency=0.62,BorderSizePixel=0,ZIndex=5,
    },navBar)

    local brand=New("Frame",{BackgroundTransparency=1,BorderSizePixel=0,Visible=false,ZIndex=6},navBar)
    local brandImage=New("ImageLabel",{
        AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),
        BackgroundTransparency=1,Image=C.Assets.Logo,ScaleType=Enum.ScaleType.Fit,ZIndex=7,
    },brand)
    local brandTitle=createText(brand,{Size=UDim2.fromScale(1,1),Text=options.Title or RE4UI.HubName,Visible=false,ZIndex=6})
    window.Brand=brand; window.BrandTitle=brandTitle; window.BrandImage=brandImage

    local navScroll=New("ScrollingFrame",{
        BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.X,ScrollBarThickness=0,
        ScrollingDirection=Enum.ScrollingDirection.X,ElasticBehavior=Enum.ElasticBehavior.WhenScrollable,ZIndex=6,
    },navBar)
    local navLayout=New("UIListLayout",{
        FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Left,
        VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder,
    },navScroll)
    window.NavScroll=navScroll

    -- Header is deliberately sparse: game/sea context, connection state, search,
    -- and minimize. The page identity sits in the page header below it.
    local topbar=New("Frame",{
        BackgroundColor3=T.Topbar,BackgroundTransparency=0.16,BorderSizePixel=0,
        Active=true,Selectable=false,ZIndex=4,
    },main)
    window.Topbar=topbar
    local topDivider=New("Frame",{
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,1),
        BackgroundColor3=T.Divider,BackgroundTransparency=0.70,BorderSizePixel=0,ZIndex=5,
    },topbar)
    local headerImage=New("ImageLabel",{
        AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Image=C.Assets.Header,
        ScaleType=Enum.ScaleType.Fit,ZIndex=6,
    },topbar)
    window.HeaderImage=headerImage

    local pageMeta=createText(topbar,{
        Font=Enum.Font.GothamMedium,Text="Blox Fruits / "..tostring(options.SeaName or "Sea"),
        TextSize=10,TextColor3=T.TextSoft,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,
    })
    window.PageMeta=pageMeta

    local onlineDot=New("Frame",{
        AnchorPoint=Vector2.new(0,0.5),Size=UDim2.fromOffset(6,6),
        BackgroundColor3=T.Good,BorderSizePixel=0,ZIndex=6,
    },topbar)
    Corner(onlineDot,999)
    local onlineText=createText(topbar,{
        Text="Online",Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=T.TextSoft,ZIndex=6,
    })
    window.OnlineDot=onlineDot; window.OnlineText=onlineText

    local searchButton=New("ImageButton",{
        BackgroundColor3=T.Control,BackgroundTransparency=0.55,BorderSizePixel=0,
        Image=C.Assets.Search,ImageColor3=T.TextSoft,ScaleType=Enum.ScaleType.Fit,
        AutoButtonColor=false,ZIndex=7,
    },topbar)
    Corner(searchButton,8); Padding(searchButton,7,7,7,7)
    local minimize=New("TextButton",{
        BackgroundColor3=T.Control,BackgroundTransparency=0.55,BorderSizePixel=0,Text="",
        AutoButtonColor=false,ZIndex=7,
    },topbar)
    Corner(minimize,8)
    local minimizeGlyph=New("Frame",{
        AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),
        Size=UDim2.fromOffset(11,2),BackgroundColor3=T.TextSoft,BorderSizePixel=0,ZIndex=8,
    },minimize)
    Corner(minimizeGlyph,2)
    window.SearchButton=searchButton; window.MinimizeButton=minimize

    local contentPanel=New("Frame",{
        BackgroundColor3=T.Window,BackgroundTransparency=0,BorderSizePixel=0,
        ClipsDescendants=true,ZIndex=3,
    },main)
    window.ContentPanel=contentPanel

    local pageHeader=New("Frame",{BackgroundTransparency=1,BorderSizePixel=0,ZIndex=4},contentPanel)
    window.PageHeader=pageHeader
    local pageTitle=createText(pageHeader,{
        Font=Enum.Font.GothamBold,Text=tr("nav.home","Home"),TextSize=TX.PageTitle,TextColor3=T.Text,ZIndex=5,
    })
    local pageSubtitle=createText(pageHeader,{
        Font=Enum.Font.GothamMedium,Text="Overview",TextSize=9,TextColor3=T.Muted,ZIndex=5,
    })
    local contextText=createText(pageHeader,{
        Font=Enum.Font.GothamMedium,Text="",TextSize=TX.Meta,TextColor3=T.TextSoft,
        TextXAlignment=Enum.TextXAlignment.Right,ZIndex=5,
    })
    window.PageTitle=pageTitle; window.PageSubtitle=pageSubtitle; window.ContextText=contextText

    local headerRule=New("Frame",{
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,12,1,0),Size=UDim2.new(1,-24,0,1),
        BackgroundColor3=T.Divider,BackgroundTransparency=0.80,BorderSizePixel=0,ZIndex=5,
    },pageHeader)

    local body=New("Frame",{BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,ZIndex=3},contentPanel)
    window.Body=body

    -- One compact status bar replaces the previous runtime strip + meta footer.
    local footer=New("Frame",{
        BackgroundColor3=T.Topbar,BackgroundTransparency=0.14,BorderSizePixel=0,ZIndex=4,
    },contentPanel)
    window.Footer=footer; window.MetaFooter=footer
    local footerRule=New("Frame",{
        Size=UDim2.new(1,0,0,1),BackgroundColor3=T.Divider,BackgroundTransparency=0.72,BorderSizePixel=0,ZIndex=5,
    },footer)
    local runtimeDot=New("Frame",{
        AnchorPoint=Vector2.new(0,0.5),Size=UDim2.fromOffset(6,6),
        BackgroundColor3=T.Good,BorderSizePixel=0,ZIndex=6,
    },footer)
    Corner(runtimeDot,999)
    local runtimeText=createText(footer,{
        Text=tr("ui.ready","Ready"),Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=T.TextSoft,ZIndex=6,
    })
    local runtimePercent=createText(footer,{
        Text="",Font=Enum.Font.GothamBold,TextSize=9,TextColor3=T.Text,ZIndex=6,TextXAlignment=Enum.TextXAlignment.Right,
    })
    local runtimeTrack=New("Frame",{
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,2),
        BackgroundColor3=T.Control,BackgroundTransparency=1,BorderSizePixel=0,Visible=false,ZIndex=7,
    },footer)
    local runtimeFill=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=8},runtimeTrack)
    window.RuntimeDot=runtimeDot; window.RuntimeText=runtimeText; window.RuntimePercent=runtimePercent
    window.RuntimeTrack=runtimeTrack; window.RuntimeFill=runtimeFill

    local metaFooter=footer
    local metaSea=createText(footer,{Text=options.SeaName or "Sea",Font=Enum.Font.GothamMedium,TextSize=8,TextColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=6})
    local metaPing=createText(footer,{Text="Ping --",Font=Enum.Font.GothamMedium,TextSize=8,TextColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=6})
    local metaFps=createText(footer,{Text="FPS --",Font=Enum.Font.GothamMedium,TextSize=8,TextColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=6})
    local metaVersion=createText(footer,{Text="v"..tostring(RE4UI.Version),Font=Enum.Font.GothamMedium,TextSize=8,TextColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=6})
    local metaSep1=New("Frame",{BackgroundTransparency=1,Visible=false},footer)
    local metaSep2=New("Frame",{BackgroundTransparency=1,Visible=false},footer)
    local metaSep3=New("Frame",{BackgroundTransparency=1,Visible=false},footer)
    window.MetaSea=metaSea; window.MetaPing=metaPing; window.MetaFps=metaFps; window.MetaVersion=metaVersion

    local mobileNav=New("Frame",{
        AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),BackgroundColor3=T.Topbar,
        BackgroundTransparency=0.04,BorderSizePixel=0,Visible=false,ZIndex=20,
    },main)
    local mobileDivider=New("Frame",{
        Size=UDim2.new(1,0,0,1),BackgroundColor3=T.Divider,BackgroundTransparency=0.64,BorderSizePixel=0,ZIndex=21,
    },mobileNav)
    local mobileLayout=New("UIListLayout",{
        FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,
        VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),
    },mobileNav)
    window.MobileNav=mobileNav

    local floatingLogo=New("ImageButton",{
        Size=UDim2.fromOffset(C.Window.FloatingWidth,C.Window.FloatingHeight),Position=UDim2.fromOffset(12,92),
        BackgroundColor3=T.Window,BackgroundTransparency=0.04,BorderSizePixel=0,
        Image=C.Assets.Logo,ScaleType=Enum.ScaleType.Fit,AutoButtonColor=false,Visible=true,ZIndex=1000,
    },gui)
    Corner(floatingLogo,12); Stroke(floatingLogo,0.52,T.Stroke); Padding(floatingLogo,4,4,4,4)
    local logoScale=New("UIScale",{Scale=1},floatingLogo)
    window.FloatingLogo=floatingLogo

    local toastHost=New("Frame",{
        AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-10,0,10),Size=UDim2.fromOffset(286,420),
        BackgroundTransparency=1,ZIndex=1200,
    },gui)
    local toastLayout=New("UIListLayout",{
        VerticalAlignment=Enum.VerticalAlignment.Top,HorizontalAlignment=Enum.HorizontalAlignment.Right,
        SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),
    },toastHost)
    window.ToastHost=toastHost
    RE4UI._Windows[#RE4UI._Windows+1]=window

    window._languageListeners={}
    function window:_listenLanguage(callback)
        if type(callback)~="function" then return nil end
        self._languageListeners[#self._languageListeners+1]=callback
        return LanguageManager:OnChanged(callback)
    end

    local function setHover(button, normal, hover)
        if not UserInputService.MouseEnabled then return end
        local normalToken,hoverToken=nil,nil
        for token,color in pairs(T) do
            if color==normal then normalToken=token end
            if color==hover then hoverToken=token end
        end
        button.MouseEnter:Connect(function()
            if button:GetAttribute("RE4Locked") then return end
            Tween(button,C.Motion.Fast,{BackgroundColor3=(hoverToken and T[hoverToken]) or hover})
        end)
        button.MouseLeave:Connect(function()
            if button:GetAttribute("RE4Locked") then return end
            Tween(button,C.Motion.Fast,{BackgroundColor3=(normalToken and T[normalToken]) or normal})
        end)
    end

    function window:_hideTooltip()
        local tip=self._tooltip
        self._tooltip=nil
        if tip and tip.Parent then tip:Destroy() end
    end

    function window:_showTooltip(text,anchor)
        self:_hideTooltip()
        if not self.NavCompact or not UserInputService.MouseEnabled or not main.Visible then return end
        if not anchor or not anchor.Parent then return end
        local value=tostring(text or "")
        if value=="" then return end
        local v=self:_viewport()
        local width=math.clamp(estimateTextWidth(value,9,Enum.Font.GothamMedium)+20,54,140)
        local x=math.min(v.X-width-6,anchor.AbsolutePosition.X+anchor.AbsoluteSize.X+7)
        local y=math.clamp(anchor.AbsolutePosition.Y+anchor.AbsoluteSize.Y*0.5-15,6,v.Y-36)
        local tip=New("Frame",{
            Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(width,30),
            BackgroundColor3=T.SurfaceRaised,BackgroundTransparency=0.04,BorderSizePixel=0,ZIndex=1100,
        },gui)
        Corner(tip,8); Stroke(tip,0.58,T.Stroke)
        createText(tip,{Position=UDim2.fromOffset(9,0),Size=UDim2.new(1,-18,1,0),Text=value,Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=T.TextSoft,ZIndex=1101})
        self._tooltip=tip
    end
    window._setHover=setHover
    setHover(searchButton,T.Control,T.ControlHover)
    setHover(minimize,T.Control,T.ControlHover)

    function window:_viewport()
        local camera = Workspace.CurrentCamera
        return camera and camera.ViewportSize or Vector2.new(900,650)
    end

    function window:_detectMode(v)
        -- Width is primary, but short landscape viewports also collapse early so
        -- the page never loses its minimum usable content height.
        if v.X < C.Breakpoints.Mobile or (v.Y < C.Breakpoints.TinyHeight and v.X < C.Breakpoints.Tablet) then return "Mobile" end
        if v.X <= C.Breakpoints.Tablet or v.Y < 600 then return "Tablet" end
        return "Desktop"
    end

    function window:_syncShadow()
        -- Retained as a compatibility no-op. The compact shell intentionally has
        -- no detached shadow/glow frame.
    end

    function window:_clampMain()
        local v=self:_viewport()
        local s=main.AbsoluteSize
        if s.X<=0 or s.Y<=0 then return end
        local center=main.AbsolutePosition+s*0.5
        local x=math.clamp(center.X,s.X*0.5+4,math.max(s.X*0.5+4,v.X-s.X*0.5-4))
        local y=math.clamp(center.Y,s.Y*0.5+4,math.max(s.Y*0.5+4,v.Y-s.Y*0.5-4))
        main.Position=UDim2.fromOffset(x,y)
    end

    function window:_clampLogo()
        local v=self:_viewport(); local s=floatingLogo.AbsoluteSize
        local p=floatingLogo.AbsolutePosition
        local x=math.clamp(p.X,4,math.max(4,v.X-s.X-4))
        local y=math.clamp(p.Y,4,math.max(4,v.Y-s.Y-4))
        floatingLogo.Position=UDim2.fromOffset(x,y)
    end

    function window:RegisterResponsive(callback)
        if type(callback) ~= "function" then return end
        self.ResponsiveCallbacks[#self.ResponsiveCallbacks+1]=callback
        task.defer(function() SafeCall("Responsive",callback,self.Mode) end)
    end

    function window:_applyResponsive(recenter)
        local v=self:_viewport()
        local mode=self:_detectMode(v)
        self.Mode=mode
        local mobile=mode=="Mobile"
        local tablet=mode=="Tablet"
        local margin=mobile and C.Window.MarginMobile or (tablet and C.Window.MarginTablet or C.Window.MarginDesktop)
        local scale=math.clamp(tonumber(mainScale.Scale) or tonumber(self.UserScale) or 1,0.82,1.12)
        local aw=math.max(1,(v.X-margin*2)/scale)
        local ah=math.max(1,(v.Y-margin*2)/scale)
        local tiny=v.X<=C.Breakpoints.TinyWidth or v.Y<=C.Breakpoints.TinyHeight
        local w,h
        if mobile then
            w=math.min(C.Window.MobileMaxWidth,math.floor(aw*0.98))
            h=math.min(C.Window.MobileMaxHeight,math.floor(ah*0.97))
        elseif tablet then
            w=math.min(C.Window.TabletWidth,math.floor(aw*0.92))
            h=math.min(C.Window.TabletHeight,math.floor(ah*0.90))
        else
            w=math.min(C.Window.DesktopWidth,math.floor(aw*0.86))
            h=math.min(C.Window.DesktopHeight,math.floor(ah*0.88))
        end
        w=math.max(1,math.min(w,aw)); h=math.max(1,math.min(h,ah))
        main.Size=UDim2.fromOffset(w,h)
        if recenter or not self.UserDragged then main.Position=UDim2.fromOffset(v.X*0.5,v.Y*0.5) end

        local topH=mobile and (tiny and 42 or C.Window.TopbarMobile) or C.Window.TopbarDesktop
        local navH=mobile and 0 or C.Window.NavDesktop
        local footerH=mobile and (tiny and 26 or 28) or C.Window.Footer
        local mobileNavH=mobile and (tiny and 46 or C.Window.MobileNav) or 0
        self.NavCompact=false
        self:_hideTooltip()

        topbar.Position=UDim2.fromOffset(0,0)
        topbar.Size=UDim2.new(1,0,0,topH)

        navBar.Visible=not mobile
        navBar.Position=UDim2.fromOffset(0,topH)
        navBar.Size=UDim2.new(1,0,0,navH)
        brand.Visible=false
        navScroll.Position=UDim2.fromOffset(6,0)
        navScroll.Size=UDim2.new(1,-12,1,0)

        local panelGap=mobile and 5 or 0
        local contentLeft=mobile and panelGap or 0
        local contentTop=topH+navH
        local contentRight=mobile and panelGap or 0
        local contentBottom=mobileNavH+(mobile and panelGap or 0)
        contentPanel.Position=UDim2.fromOffset(contentLeft,contentTop)
        contentPanel.Size=UDim2.new(1,-(contentLeft+contentRight),1,-(contentTop+contentBottom))

        local pageH=mobile and C.Window.PageHeaderMobile or C.Window.PageHeaderDesktop
        pageHeader.Position=UDim2.fromOffset(0,0)
        pageHeader.Size=UDim2.new(1,0,0,pageH)
        footer.Position=UDim2.new(0,0,1,-footerH)
        footer.Size=UDim2.new(1,0,0,footerH)
        body.Position=UDim2.fromOffset(0,pageH)
        body.Size=UDim2.new(1,0,1,-(pageH+footerH))

        mobileNav.Visible=mobile
        mobileNav.Size=UDim2.new(1,0,0,mobileNavH)

        self.ContentWidth=math.max(1,w-contentLeft-contentRight-18)
        self.ContentHeight=math.max(1,h-contentTop-contentBottom-pageH-footerH)
        self.NarrowContent=self.ContentWidth < (mobile and 390 or 610)
        self.TinyViewport=tiny

        local rightPad=mobile and 8 or 10
        local actionSize=mobile and 30 or 28
        minimize.Size=UDim2.fromOffset(actionSize,actionSize)
        minimize.Position=UDim2.new(1,-rightPad-actionSize,0.5,-actionSize/2)
        searchButton.Size=UDim2.fromOffset(actionSize,actionSize)
        searchButton.Position=UDim2.new(1,-rightPad-actionSize*2-5,0.5,-actionSize/2)

        local actionBlock=rightPad+actionSize*2+9
        onlineText.Visible=not tiny and w>=390
        onlineText.Size=UDim2.fromOffset(42,topH)
        onlineText.Position=UDim2.new(1,-(actionBlock+48),0,0)
        onlineText.TextXAlignment=Enum.TextXAlignment.Left
        onlineDot.Position=UDim2.new(1,-(actionBlock+57),0.5,0)
        onlineDot.Visible=onlineText.Visible

        headerImage.Position=UDim2.new(0,mobile and 10 or 12,0.5,0)
        headerImage.Size=UDim2.fromOffset(mobile and 78 or 90,mobile and 26 or 30)
        pageMeta.Visible=true
        local metaLeft=(mobile and 98 or 116)
        pageMeta.Position=UDim2.fromOffset(metaLeft,0)
        local metaRightReserve=actionBlock+(onlineText.Visible and 62 or 0)
        pageMeta.Size=UDim2.new(1,-(metaLeft+metaRightReserve),1,0)
        pageMeta.TextSize=mobile and 8 or 9

        local titleLeft=mobile and 12 or 14
        pageTitle.Position=UDim2.fromOffset(titleLeft,mobile and 5 or 7)
        pageTitle.Size=UDim2.new(0.62,-titleLeft,0,mobile and 22 or 24)
        pageTitle.TextSize=mobile and (tiny and 15 or 16) or TX.PageTitle
        pageSubtitle.Position=UDim2.fromOffset(titleLeft,mobile and 26 or 29)
        pageSubtitle.Size=UDim2.new(0.62,-titleLeft,0,14)
        pageSubtitle.TextSize=mobile and 8 or 9
        contextText.Visible=not tiny and self.ContentWidth>=470
        contextText.Position=UDim2.new(0.58,0,0,0)
        contextText.Size=UDim2.new(0.42,-14,1,0)
        contextText.TextSize=mobile and 8 or TX.Meta

        runtimeDot.Position=UDim2.new(0,10,0.5,0)
        runtimeText.Position=UDim2.fromOffset(22,0)
        runtimeText.Size=UDim2.new(mobile and 0.42 or 0.38,-24,1,0)
        runtimeText.TextSize=mobile and 8 or 9
        runtimePercent.Position=UDim2.new(mobile and 0.43 or 0.39,-38,0,0)
        runtimePercent.Size=UDim2.fromOffset(34,footerH)
        runtimePercent.TextSize=8
        runtimeTrack.Position=UDim2.new(0,0,0,0)
        runtimeTrack.Size=UDim2.new(1,0,0,2)

        if mobile then
            metaSea.Visible=false
            metaPing.Position=UDim2.new(0.44,0,0,0); metaPing.Size=UDim2.new(0.19,0,1,0)
            metaFps.Position=UDim2.new(0.63,0,0,0); metaFps.Size=UDim2.new(0.17,0,1,0)
            metaVersion.Position=UDim2.new(0.80,0,0,0); metaVersion.Size=UDim2.new(0.20,0,1,0)
        else
            metaSea.Visible=true
            metaSea.Position=UDim2.new(0.43,0,0,0); metaSea.Size=UDim2.new(0.14,0,1,0)
            metaPing.Position=UDim2.new(0.57,0,0,0); metaPing.Size=UDim2.new(0.15,0,1,0)
            metaFps.Position=UDim2.new(0.72,0,0,0); metaFps.Size=UDim2.new(0.12,0,1,0)
            metaVersion.Position=UDim2.new(0.84,0,0,0); metaVersion.Size=UDim2.new(0.16,0,1,0)
        end
        local metaTextSize=mobile and (tiny and 7 or 8) or 8
        metaSea.TextSize=metaTextSize; metaPing.TextSize=metaTextSize; metaFps.TextSize=metaTextSize; metaVersion.TextSize=metaTextSize

        local toastW=mobile and math.max(220,math.min(w-16,286)) or 286
        toastHost.Size=UDim2.fromOffset(toastW,math.min(420,v.Y-20)); toastHost.Position=UDim2.new(1,-8,0,8)

        for _,tab in ipairs(self.Tabs) do tab:_applyMode(mode) end
        for _,cb in ipairs(self.ResponsiveCallbacks) do SafeCall("Responsive",cb,mode,self.NarrowContent,self.TinyViewport) end
        self:_refreshNavigation()
        task.defer(function() self:_clampMain(); self:_clampLogo() end)
    end

    function window:SetScale(value)
        local scale = math.clamp(tonumber(value) or 1, 0.82, 1.12)
        self.UserScale=scale
        mainScale.Scale=scale
        RE4UI:SetPreference("uiScale",scale)
        task.defer(function() self:_applyResponsive(false); self:_clampMain() end)
        return scale
    end

    function window:SetCompactDensity(enabled)
        self.CompactDensity = enabled == true
        RE4UI:SetPreference("compactDensity",self.CompactDensity)
        for _, tab in ipairs(self.Tabs) do tab:_applyMode(self.Mode) end
    end

    function window:SetReducedMotion(enabled)
        self.ReducedMotion = enabled == true
        RE4UI:SetPreference("reducedMotion",self.ReducedMotion)
        -- Keep interaction feedback, but shorten all configured transitions.
        if self.ReducedMotion then
            C.Motion.Fast = 0.04; C.Motion.Normal = 0.06; C.Motion.Slow = 0.08
        else
            C.Motion.Fast = 0.08; C.Motion.Normal = 0.12; C.Motion.Slow = 0.16
        end
    end

    -- Fixed visual theme: no runtime theme/accent mutation APIs.

    local function updateHeaderContext()
        local sea=tostring(window.Context.Sea or options.SeaName or "Sea")
        local level=window.Context.Level and ("Lv."..tostring(window.Context.Level)) or nil
        local meta=sea..(level and (" · "..level) or "")
        if pageMeta.Text~=meta then pageMeta.Text=meta end
        if metaSea.Text~=sea then metaSea.Text=sea end
    end

    function window:SetContext(context)
        context=type(context)=="table" and context or nil
        self.Context=type(self.Context)=="table" and self.Context or {}
        local previousSea=tonumber(self.Context.SeaNumber or self.Context.SeaId)
        local changed=false

        -- Keep one context table for the lifetime of the window. Home updates once
        -- per second; replacing this table used to create permanent GC pressure.
        if context then
            for key in pairs(self.Context) do
                if context[key]==nil then self.Context[key]=nil; changed=true end
            end
            for key,value in pairs(context) do
                if self.Context[key]~=value then self.Context[key]=value; changed=true end
            end
        elseif next(self.Context)~=nil then
            table.clear(self.Context); changed=true
        end

        local contextValue=""
        if self.Context.Race and tostring(self.Context.Race)~="-" then contextValue=tostring(self.Context.Race) end
        if self.Context.Fruit and tostring(self.Context.Fruit)~="-" then
            contextValue=contextValue..(contextValue~="" and " · " or "")..tostring(self.Context.Fruit)
        end
        if contextText.Text~=contextValue then contextText.Text=contextValue end
        updateHeaderContext()

        -- Sea filtering only needs a global pass when the Sea changes. Context-based
        -- custom predicates opt into refreshes explicitly through RegisterFeature.
        local currentSea=tonumber(self.Context.SeaNumber or self.Context.SeaId)
        if previousSea~=currentSea or (changed and self._hasContextVisibilityConditions==true) then
            self:RefreshVisibility()
        end
    end

    function window:SetRuntimeStatus(text, percent, tone)
        runtimeText.Text=tostring(text or tr("ui.ready","Ready"))
        local col=toneColor(tone or ((text and tostring(text):lower():find("running")) and "running" or "good"))
        runtimeDot.BackgroundColor3=col
        if type(percent)=="number" then
            local p=math.clamp(percent,0,100)
            runtimeTrack.Visible=true
            runtimeTrack.BackgroundTransparency=0.55
            runtimePercent.Text=string.format("%d%%",math.floor(p+0.5))
            Tween(runtimeFill,C.Motion.Normal,{Size=UDim2.new(p/100,0,1,0)})
        else
            runtimeTrack.Visible=false
            runtimePercent.Text=tostring(percent or "")
        end
    end

    function window:SetRuntimeStatusKey(key, params, percent, tone)
        return self:SetRuntimeStatus(tr(key,key,params),percent,tone)
    end

    function window:Notify(opts)
        opts=opts or {}
        self._notificationLast=self._notificationLast or {}
        local dedupeId=tostring(opts.Id or opts.Key or opts.ContentKey or opts.Content or opts.Text or "")
        local cooldown=math.max(0,tonumber(opts.Cooldown) or 0)
        local now=os.clock()
        if dedupeId~="" and cooldown>0 then
            local last=self._notificationLast[dedupeId]
            if last and now-last<cooldown then return nil end
            self._notificationLast[dedupeId]=now
        end
        self._toastOrder=self._toastOrder+1
        local tone=opts.Tone or opts.Type or "info"
        local col=toneColor(tone)
        local toastTitle=opts.TitleKey and tr(opts.TitleKey,opts.Title or RE4UI.HubName,opts.Params) or localizeLegacy(opts.Title or RE4UI.HubName)
        local toastContent=opts.ContentKey and tr(opts.ContentKey,opts.Content or opts.Text or "",opts.Params) or localizeLegacy(opts.Content or opts.Text or "")
        local toast=New("Frame", {
            Size=UDim2.new(1,0,0,60), BackgroundColor3=T.SurfaceRaised, BackgroundTransparency=0.08,
            BorderSizePixel=0, LayoutOrder=self._toastOrder, ZIndex=1201,
        }, toastHost)
        Corner(toast,10); Stroke(toast,0.58,T.Stroke)
        local stripe=New("Frame", {Size=UDim2.new(0,3,1,-14),Position=UDim2.fromOffset(6,7),BackgroundColor3=col,BorderSizePixel=0,ZIndex=1202},toast)
        Corner(stripe,3)
        local title=createText(toast,{Position=UDim2.fromOffset(16,7),Size=UDim2.new(1,-26,0,17),Text=toastTitle,Font=Enum.Font.GothamBold,TextSize=10,ZIndex=1202})
        local content=createText(toast,{Position=UDim2.fromOffset(16,25),Size=UDim2.new(1,-26,0,27),Text=toastContent,TextColor3=T.TextSoft,TextSize=9,TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,ZIndex=1202})
        toast.BackgroundTransparency=1; title.TextTransparency=1; content.TextTransparency=1
        Tween(toast,C.Motion.Normal,{BackgroundTransparency=0.08}); Tween(title,C.Motion.Normal,{TextTransparency=0}); Tween(content,C.Motion.Normal,{TextTransparency=0})
        task.delay(tonumber(opts.Duration) or 3.0,function()
            if not toast.Parent then return end
            Tween(toast,C.Motion.Normal,{BackgroundTransparency=1}); Tween(title,C.Motion.Normal,{TextTransparency=1}); Tween(content,C.Motion.Normal,{TextTransparency=1})
            task.delay(C.Motion.Normal,function() if toast.Parent then toast:Destroy() end end)
        end)
        return toast
    end

    local function normalizeSeas(value)
        if value==nil then return nil end
        if type(value)=="number" then return {value} end
        if type(value)~="table" then return nil end
        local out={}
        for _,sea in ipairs(value) do
            sea=tonumber(sea)
            if sea then out[#out+1]=sea end
        end
        return #out>0 and out or nil
    end

    local function featureId(tab, name, index)
        local raw=(tostring(tab and tab.Key or "feature").."."..tostring(name or "feature")):lower()
        raw=raw:gsub("[^%w]+","_"):gsub("^_+",""):gsub("_+$","")
        if raw=="" then raw="feature_"..tostring(index or 0) end
        return raw
    end

    function window:_currentSeaNumber()
        local n=tonumber(self.Context and (self.Context.SeaNumber or self.Context.SeaId))
        if n then return n end
        n=tonumber(RE4UI.CurrentSea)
        if n then return n end
        return 0
    end

    function window:_isFeatureVisible(feature)
        if not feature then return false end
        if feature.ManualVisible == false then return false end
        local seas=feature.Seas
        if type(seas)=="table" and #seas>0 then
            local current=self:_currentSeaNumber()
            local found=false
            for _,sea in ipairs(seas) do if tonumber(sea)==current then found=true break end end
            if not found then return false end
        end
        local condition=feature.VisibilityCondition
        if type(condition)=="function" then
            local ok,result=SafeCall("FeatureVisibility/"..tostring(feature.Id),condition,self.Context,self:_currentSeaNumber(),feature.Control)
            if not ok or result==false then return false end
        elseif condition==false then
            return false
        end
        return true
    end

    function window:_queueVisibilityRefresh()
        if self._visibilityRefreshQueued then return end
        self._visibilityRefreshQueued=true
        task.defer(function()
            self._visibilityRefreshQueued=false
            if self.Gui and self.Gui.Parent then self:RefreshVisibility() end
        end)
    end

    function window:RegisterFeature(control, tab, opts)
        if not control or not tab then return end
        opts=opts or {}
        local sourceName=tostring(opts.Name or opts.Title or control.Name or "Feature")
        local sourceDesc=tostring(opts.Description or opts.Desc or opts.Content or "")
        local section=control.Section
        local seas=normalizeSeas(opts.Seas or opts.Sea or opts.__RE4Seas or (section and section.Seas))
        local id=tostring(opts.Id or opts.FeatureId or featureId(tab,sourceName,#self.Features+1))
        if self.FeatureById[id] then id=id.."_"..tostring(#self.Features+1) end
        local favorites=RE4UI:GetPreference("favorites",{})
        local feature={
            Id=id, Control=control, Tab=tab, Section=section,
            Category=opts.Category or tab.Key, CategoryKey=opts.CategoryKey or tab.TitleKey,
            SectionId=opts.SectionId or (section and section.Id),
            SourceName=sourceName, SourceDescription=sourceDesc,
            TitleKey=opts.TitleKey, DescriptionKey=opts.DescriptionKey,
            Icon=opts.Icon, Order=tonumber(opts.Order) or (#self.Features+1),
            Seas=seas,
            VisibilityCondition=opts.VisibilityCondition or opts.VisibleWhen or opts.Visible,
            Favorite=type(favorites)=="table" and favorites[id]==true or false,
            ManualVisible=true,
            Visible=false,
        }
        control._Feature=feature
        if feature.VisibilityCondition~=nil then self._hasContextVisibilityConditions=true end
        self.Features[#self.Features+1]=feature
        self.FeatureById[id]=feature
        -- Registration happens hundreds of times during startup. Batch the global
        -- visibility/layout pass instead of rescanning every feature for every row.
        self:_queueVisibilityRefresh()
        return feature
    end

    function window:SetFeatureVisibility(id, condition)
        local feature=self.FeatureById[tostring(id or "")]
        if not feature then return false end
        feature.VisibilityCondition=condition
        self:RefreshVisibility()
        return true
    end

    function window:RefreshVisibility(force)
        local visibleTabCount=0
        local layoutChanged=force==true
        local navigationChanged=force==true
        for _,feature in ipairs(self.Features) do
            local newVisible=self:_isFeatureVisible(feature)
            if feature.Visible~=newVisible then
                feature.Visible=newVisible
                layoutChanged=true
            end
            local frame=feature.Control and (feature.Control.Row or feature.Control.Frame or feature.Control.Card)
            if frame and frame.Parent and frame.Visible~=newVisible then frame.Visible=newVisible end
        end
        for _,tab in ipairs(self.Tabs) do
            local tabVisible=false
            local tabLayoutChanged=false
            for _,section in ipairs(tab.Sections) do
                local sectionVisible=false
                local sectionSeaOK=true
                if type(section.Seas)=="table" and #section.Seas>0 then
                    sectionSeaOK=false
                    local sea=self:_currentSeaNumber()
                    for _,allowed in ipairs(section.Seas) do if tonumber(allowed)==sea then sectionSeaOK=true break end end
                end
                if sectionSeaOK and type(section.VisibilityCondition)=="function" then
                    local ok,result=SafeCall("SectionVisibility/"..tostring(section.SourceTitle),section.VisibilityCondition,self.Context,self:_currentSeaNumber())
                    sectionSeaOK=ok and result~=false
                elseif section.VisibilityCondition==false then sectionSeaOK=false end
                if sectionSeaOK then
                    for _,control in ipairs(section.Controls) do
                        if control._Feature and control._Feature.Visible then sectionVisible=true break end
                    end
                end
                if section.Visible~=sectionVisible then
                    section.Visible=sectionVisible
                    tabLayoutChanged=true
                    layoutChanged=true
                end
                if section.Frame and section.Frame.Parent and section.Frame.Visible~=sectionVisible then section.Frame.Visible=sectionVisible end
                if sectionVisible then tabVisible=true end
            end
            if tab.Visible~=tabVisible then
                tab.Visible=tabVisible
                navigationChanged=true
                layoutChanged=true
            end
            if tab.NavButton then
                local navVisible=tabVisible and self.Mode~="Mobile"
                if tab.NavButton.Visible~=navVisible then tab.NavButton.Visible=navVisible end
            end
            if not tabVisible then tab.Page.Visible=false end
            if tabVisible then visibleTabCount=visibleTabCount+1 end
            if tabLayoutChanged or force==true then tab:_relayoutSections() end
        end
        if navigationChanged then self:_refreshNavigation() end
        if self.ActiveTab and not self.ActiveTab.Visible then self.ActiveTab=nil end
        if not self.ActiveTab then
            for _,tab in ipairs(self.Tabs) do if tab.Visible then self:ShowTab(tab); break end end
        end
        return visibleTabCount,layoutChanged,navigationChanged
    end

    function window:FocusFeature(feature)
        if not feature or not feature.Tab or not feature.Visible then return end
        self:ShowTab(feature.Tab)
        task.defer(function()
            local control=feature.Control
            local frame=control and (control.Row or control.Card or control.Frame)
            if frame and frame.Parent and frame.Visible then
                local page=feature.Tab.Page
                local y=frame.AbsolutePosition.Y-page.AbsolutePosition.Y+page.CanvasPosition.Y-18
                Tween(page,C.Motion.Normal,{CanvasPosition=Vector2.new(0,math.max(0,y))})
                local original=frame.BackgroundColor3
                if frame:IsA("Frame") then
                    Tween(frame,C.Motion.Fast,{BackgroundColor3=T.AccentFaint})
                    task.delay(0.55,function() if frame.Parent then Tween(frame,C.Motion.Normal,{BackgroundColor3=original}) end end)
                end
            end
        end)
    end

    function window:OpenSearch()
        self:_hideTooltip()
        self.Overlay:Close()
        local v=self:_viewport()
        local width=math.min(470,v.X-16)
        local height=math.min(370,v.Y-20)
        local blocker=self.Overlay:CreateBlocker(850)
        blocker.BackgroundTransparency=1
        local panel=New("Frame", {
            AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.48),
            Size=UDim2.fromOffset(width,height), BackgroundColor3=T.SurfaceRaised,
            BorderSizePixel=0, ZIndex=851,
        }, gui)
        Corner(panel,14); Stroke(panel,0.48,T.Stroke)
        local searchShell=New("Frame",{
            Position=UDim2.fromOffset(10,10),Size=UDim2.new(1,-20,0,38),
            BackgroundColor3=T.Control,BorderSizePixel=0,ZIndex=852,
        },panel)
        Corner(searchShell,9); Stroke(searchShell,0.66,T.Stroke)
        local searchIcon=New("ImageLabel",{
            AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,10,0.5,0),Size=UDim2.fromOffset(16,16),
            BackgroundTransparency=1,Image=C.Assets.Search,ImageColor3=T.Muted,ScaleType=Enum.ScaleType.Fit,ZIndex=853,
        },searchShell)
        local search=New("TextBox", {
            Position=UDim2.fromOffset(34,0), Size=UDim2.new(1,-44,1,0),
            BackgroundTransparency=1, BorderSizePixel=0,
            Font=Enum.Font.GothamMedium, Text="", PlaceholderText=tr("ui.search_hint","Search features..."),
            PlaceholderColor3=T.Muted, TextColor3=T.Text, TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,
            ClearTextOnFocus=false, ZIndex=853,
        },searchShell)
        local results=New("ScrollingFrame", {
            Position=UDim2.fromOffset(10,56), Size=UDim2.new(1,-20,1,-66),
            BackgroundTransparency=1, BorderSizePixel=0, CanvasSize=UDim2.new(),
            AutomaticCanvasSize=Enum.AutomaticSize.Y, ScrollBarThickness=2,
            ScrollBarImageColor3=T.Accent, ZIndex=852,
        },panel)
        New("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},results)
        local function render()
            for _,child in ipairs(results:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
            local q=normalizeText(search.Text)
            local matches={}
            for _,f in ipairs(window.Features) do
                if f.Visible then
                    local title=f.Control and f.Control.TitleLabel and f.Control.TitleLabel.Text or localizeLegacy(f.SourceName)
                    local desc=f.Control and f.Control.DescLabel and f.Control.DescLabel.Text or localizeLegacy(f.SourceDescription)
                    local tabTitle=f.Tab and f.Tab.Title or ""
                    local searchable=normalizeText(title.." "..desc.." "..tabTitle)
                    if q=="" or searchable:find(q,1,true) then matches[#matches+1]=f end
                end
            end
            table.sort(matches,function(a,b)
                if a.Favorite~=b.Favorite then return a.Favorite end
                if a.Tab.Title~=b.Tab.Title then return a.Tab.Title<b.Tab.Title end
                return a.Order<b.Order
            end)
            local shown=0
            for _,f in ipairs(matches) do
                if shown>=36 then break end
                shown=shown+1
                local b=New("TextButton", {Size=UDim2.new(1,-2,0,46),BackgroundColor3=T.Control,BackgroundTransparency=0.22,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=853},results)
                Corner(b,9)
                local title=f.Control and f.Control.TitleLabel and f.Control.TitleLabel.Text or localizeLegacy(f.SourceName)
                local desc=f.Control and f.Control.DescLabel and f.Control.DescLabel.Text or localizeLegacy(f.SourceDescription)
                createText(b,{Position=UDim2.fromOffset(10,3),Size=UDim2.new(1,-68,0,19),Text=title,Font=Enum.Font.GothamBold,TextSize=10,ZIndex=854})
                createText(b,{Position=UDim2.fromOffset(10,22),Size=UDim2.new(1,-68,0,16),Text=f.Tab.Title..(desc~="" and " / "..desc or ""),TextColor3=T.Muted,TextSize=8,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=854})
                local pin=New("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-7,0.5,0),Size=UDim2.fromOffset(48,26),BackgroundColor3=f.Favorite and T.AccentFaint or T.SurfaceRaised,BackgroundTransparency=0.18,BorderSizePixel=0,Text=f.Favorite and "PINNED" or "PIN",Font=Enum.Font.GothamBold,TextColor3=f.Favorite and T.Text or T.Muted,TextSize=7,AutoButtonColor=false,ZIndex=855},b)
                Corner(pin,7)
                pin.MouseButton1Click:Connect(function()
                    f.Favorite=not f.Favorite
                    pin.Text=f.Favorite and "PINNED" or "PIN"; pin.TextColor3=f.Favorite and T.Text or T.Muted; pin.BackgroundColor3=f.Favorite and T.AccentFaint or T.SurfaceRaised
                    local favorites=RE4UI:GetPreference("favorites",{})
                    if type(favorites)~="table" then favorites={} end
                    favorites[f.Id]=f.Favorite or nil; RE4UI:SetPreference("favorites",favorites)
                end)
                setHover(b,T.Control,T.ControlHover)
                b.MouseButton1Click:Connect(function() window.Overlay:Close(); window:FocusFeature(f) end)
            end
            if shown==0 then createText(results,{Size=UDim2.new(1,0,0,48),Text=tr("ui.no_results","No matching features"),TextColor3=T.Muted,TextXAlignment=Enum.TextXAlignment.Center,TextSize=10,ZIndex=853}) end
        end
        search:GetPropertyChangedSignal("Text"):Connect(render)
        render(); task.defer(function() search:CaptureFocus() end)
        self.Overlay:Set(panel,blocker,function() pcall(function() search:ReleaseFocus() end) end)
    end

    function window:_mobilePrimaryTabs()
        local visible={}
        local used={}
        for _,key in ipairs(C.MobilePrimary) do
            local tab=self.TabsByKey[key]
            if tab and tab.Visible and #visible<4 then visible[#visible+1]=tab; used[tab]=true end
        end
        for _,tab in ipairs(self.Tabs) do
            if tab.Visible and not used[tab] and #visible<4 then visible[#visible+1]=tab; used[tab]=true end
        end
        return visible,used
    end

    function window:_openMoreMenu()
        self.Overlay:Close()
        local primary,used=self:_mobilePrimaryTabs()
        local remaining={}
        for _,tab in ipairs(self.Tabs) do if tab.Visible and not used[tab] then remaining[#remaining+1]=tab end end
        if #remaining==0 then return end
        local blocker=self.Overlay:CreateBlocker(850)
        blocker.BackgroundTransparency=1
        local v=self:_viewport(); local h=math.min(360,v.Y*0.66)
        local sheet=New("Frame", {AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,h),BackgroundColor3=T.SurfaceRaised,BorderSizePixel=0,ZIndex=851},gui)
        Corner(sheet,16); Stroke(sheet,0.48,T.Stroke)
        local grab=New("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,7),Size=UDim2.fromOffset(34,3),BackgroundColor3=T.Muted,BackgroundTransparency=0.45,BorderSizePixel=0,ZIndex=852},sheet); Corner(grab,4)
        createText(sheet,{Position=UDim2.fromOffset(14,16),Size=UDim2.new(1,-28,0,26),Text=tr("ui.more","More"),Font=Enum.Font.GothamBold,TextSize=14,ZIndex=852})
        local list=New("ScrollingFrame",{Position=UDim2.fromOffset(10,48),Size=UDim2.new(1,-20,1,-58),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ZIndex=852},sheet)
        New("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},list)
        for _,tab in ipairs(remaining) do
            local b=New("TextButton",{Size=UDim2.new(1,-2,0,42),BackgroundColor3=T.Control,BackgroundTransparency=0.18,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=853},list)
            Corner(b,9); setHover(b,T.Control,T.ControlHover)
            local def=navDefinition[tab.Key] or {}
            New("ImageLabel",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,10,0.5,0),Size=UDim2.fromOffset(18,18),BackgroundTransparency=1,Image=def.Icon or "",ImageColor3=Color3.new(1,1,1),ImageTransparency=0.12,ScaleType=Enum.ScaleType.Fit,ZIndex=854},b)
            createText(b,{Position=UDim2.fromOffset(38,0),Size=UDim2.new(1,-48,1,0),Text=tab.Title,Font=Enum.Font.GothamMedium,TextColor3=T.Text,TextSize=11,ZIndex=854})
            b.MouseButton1Click:Connect(function() window.Overlay:Close(); window:ShowTab(tab) end)
        end
        self.Overlay:Set(sheet,blocker,nil)
    end

    function window:_setVisible(visible)
        self.Hidden=not visible
        self:_hideTooltip()
        if visible then
            self.Overlay:Close()
            floatingLogo.Visible=true
            main.Visible=true
            local target=self.UserScale or mainScale.Scale
            mainScale.Scale=math.max(0.01,target*0.985)
            Tween(mainScale,C.Motion.Fast,{Scale=target})
        else
            self.Overlay:Close()
            main.Visible=false
            floatingLogo.Visible=true
            logoScale.Scale=0.94
            Tween(logoScale,C.Motion.Fast,{Scale=1})
        end
    end

    function window:AddMinimizeButton() return minimize end
    function window:Toggle() self:_setVisible(not main.Visible) end
    function window:IsVisible() return main.Visible end

    function window:ShowTab(tab)
        if not tab or tab.Visible==false then return false end
        local previous=self.ActiveTab
        if previous and previous~=tab then
            for _,callback in ipairs(previous.HiddenCallbacks or {}) do SafeCall("TabHidden/"..tostring(previous.Key),callback,previous) end
        end
        self.Overlay:Close()
        for _,other in ipairs(self.Tabs) do
            local active=other==tab and other.Visible~=false
            other.Page.Visible=active
            if other.NavButton then
                other.NavButton:SetAttribute("RE4Locked",active)
                Tween(other.NavButton,C.Motion.Fast,{BackgroundColor3=active and T.AccentFaint or T.SurfaceHover,BackgroundTransparency=active and 0.16 or 1})
                if other.NavTitle then
                    other.NavTitle.TextColor3=active and T.Text or T.TextSoft
                    other.NavTitle.Font=active and Enum.Font.GothamBold or Enum.Font.GothamMedium
                end
                if other.NavIcon then Tween(other.NavIcon,C.Motion.Fast,{ImageColor3=Color3.new(1,1,1),ImageTransparency=active and 0 or 0.18}) end
                if other.NavMarker then
                    other.NavMarker.Size=active and UDim2.fromOffset(34,3) or UDim2.fromOffset(30,2)
                    other.NavMarker.Visible=active
                end
            end
            if other.MobileButton then
                if other.MobileLabel then
                    other.MobileLabel.TextColor3=active and T.Text or T.Muted
                    other.MobileLabel.Font=active and Enum.Font.GothamBold or Enum.Font.GothamMedium
                end
                if other.MobileIcon then Tween(other.MobileIcon,C.Motion.Fast,{ImageColor3=Color3.new(1,1,1),ImageTransparency=active and 0 or 0.30}) end
                if other.MobileMarker then other.MobileMarker.Visible=active end
            end
        end
        self.ActiveTab=tab
        for _,callback in ipairs(tab.ShownCallbacks or {}) do SafeCall("TabShown/"..tostring(tab.Key),callback,tab) end
        -- Heavy InfoList cells are materialized on first view rather than at boot.
        for _,section in ipairs(tab.Sections or {}) do
            for _,control in ipairs(section.Controls or {}) do
                if control._renderDeferred then control:_renderDeferred() end
            end
        end
        tab:_queueRelayout(); tab:_queueRefresh()
        pageTitle.Text=tab.Title
        pageSubtitle.Text=tostring(tab.Subtitle or tab.GroupTitle or tab.Group or RE4UI.HubName)
        updateHeaderContext()
        return true
    end

    function window:_refreshNavigation()
        for _,tab in ipairs(self.Tabs) do
            if tab.NavButton then tab.NavButton.Visible=tab.Visible and self.Mode~="Mobile" end
        end
        for _,entry in ipairs(self._navGroupLabels or {}) do
            local label=entry.Label or entry
            label.Visible=false
        end
        self:_rebuildMobileNav()
    end

    -- Navigation buttons are created lazily from MakeTab.
    window._navGroups={}
    window._navGroupLabels={}
    function window:_ensureNavGroup(group, order, groupKey)
        -- Group metadata is retained for routing/search, but the compact horizontal shell intentionally avoids category labels in navigation.
        self._navGroups[group]=true
    end

    local navDefinition={}
    for i,d in ipairs(C.Navigation) do navDefinition[d.Key]=d; d._Index=i end

    function window:MakeTab(tabOptions)
        tabOptions=tabOptions or {}
        local requestedKey=tabOptions.Key
        local sourceTitle=stripRichText(tabOptions.Title or tabOptions.Name or "Tab")
        if not requestedKey then
            requestedKey=sourceTitle:gsub("%W","")
            for _,d in ipairs(C.Navigation) do if d.Title==sourceTitle or d.Key==sourceTitle then requestedKey=d.Key break end end
        end
        local key=canonicalTabKey(requestedKey)
        local requestedWasAlias=tostring(requestedKey or "")~=key
        local existing=self.TabsByKey[key]
        if existing then
            self.TabsByKey[tostring(requestedKey or key)]=existing
            return existing
        end
        local def=navDefinition[key] or {Key=key,Title=sourceTitle,Icon=nil,Group="OTHER",GroupKey=nil,_Index=#self.Tabs+1}
        local titleKey=(not requestedWasAlias and tabOptions.TitleKey) or def.TitleKey
        local mobileTitleKey=(not requestedWasAlias and tabOptions.MobileTitleKey) or def.MobileTitleKey or titleKey
        local subtitleKey=(not requestedWasAlias and tabOptions.SubtitleKey) or def.SubtitleKey
        local title=titleKey and tr(titleKey,def.Title or sourceTitle) or localizeLegacy(def.Title or sourceTitle)
        local subtitle=subtitleKey and tr(subtitleKey,tabOptions.Subtitle or def.Subtitle or def.Group or RE4UI.HubName) or (tabOptions.Subtitle or def.Subtitle or def.Group)
        sourceTitle=def.Title or sourceTitle
        self:_ensureNavGroup(def.Group,def._Index,def.GroupKey)

        local navWidth=math.clamp(math.floor(estimateTextWidth(title,13,Enum.Font.GothamBold)+58),92,138)
        local navButton=New("TextButton",{
            Size=UDim2.fromOffset(navWidth,46),BackgroundColor3=T.SurfaceHover,BackgroundTransparency=1,
            BorderSizePixel=0,Text="",AutoButtonColor=false,LayoutOrder=def._Index,ZIndex=7,Visible=false,
        },navScroll)
        Corner(navButton,9)
        local navMarker=New("Frame",{
            AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,0),Size=UDim2.fromOffset(34,3),
            BackgroundColor3=T.Accent,BorderSizePixel=0,Visible=false,ZIndex=9,
        },navButton)
        Corner(navMarker,2)
        local navIcon=New("ImageLabel",{
            AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,11,0.5,0),Size=UDim2.fromOffset(24,24),
            BackgroundTransparency=1,Image=def.Icon or "",ImageColor3=Color3.new(1,1,1),ImageTransparency=0.18,
            ScaleType=Enum.ScaleType.Fit,ZIndex=8,
        },navButton)
        local navTitle=createText(navButton,{
            Position=UDim2.fromOffset(43,0),Size=UDim2.new(1,-51,1,0),Text=title,
            Font=Enum.Font.GothamBold,TextSize=13,TextColor3=T.TextSoft,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8,
        })
        navButton.MouseEnter:Connect(function()
            if navButton:GetAttribute("RE4Locked") then return end
            Tween(navButton,C.Motion.Fast,{BackgroundColor3=T.SurfaceHover,BackgroundTransparency=0.72})
            navTitle.TextColor3=T.Text
            Tween(navIcon,C.Motion.Fast,{ImageColor3=Color3.new(1,1,1),ImageTransparency=0.03})
        end)
        navButton.MouseLeave:Connect(function()
            if navButton:GetAttribute("RE4Locked") then return end
            Tween(navButton,C.Motion.Fast,{BackgroundColor3=T.SurfaceHover,BackgroundTransparency=1})
            navTitle.TextColor3=T.TextSoft
            Tween(navIcon,C.Motion.Fast,{ImageColor3=Color3.new(1,1,1),ImageTransparency=0.18})
            window:_hideTooltip()
        end)
        if titleKey then bindKey(navTitle,titleKey,sourceTitle) else bindLegacy(navTitle,sourceTitle) end

        local page=New("ScrollingFrame",{
            Size=UDim2.fromScale(1,1), BackgroundTransparency=1, BorderSizePixel=0,
            CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.None,
            ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
            ScrollingDirection=Enum.ScrollingDirection.Y, Visible=false, ZIndex=4,
        },body)
        local root=New("Frame",{BackgroundTransparency=1,BorderSizePixel=0,ZIndex=4},page)
        local left=New("Frame",{BackgroundTransparency=1,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=4},root)
        local right=New("Frame",{BackgroundTransparency=1,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=4},root)
        local full=New("Frame",{BackgroundTransparency=1,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.Y,ZIndex=4},root)
        local leftLayout=New("UIListLayout",{Padding=UDim.new(0,M.SectionGap),SortOrder=Enum.SortOrder.LayoutOrder},left)
        local rightLayout=New("UIListLayout",{Padding=UDim.new(0,M.SectionGap),SortOrder=Enum.SortOrder.LayoutOrder},right)
        local fullLayout=New("UIListLayout",{Padding=UDim.new(0,M.SectionGap),SortOrder=Enum.SortOrder.LayoutOrder},full)

        local tab={
            Window=window, Key=key, Title=title, SourceTitle=sourceTitle, TitleKey=titleKey,
            Subtitle=subtitle, SubtitleKey=subtitleKey,
            MobileTitle=mobileTitleKey and tr(mobileTitleKey,def.MobileTitle or sourceTitle) or localizeLegacy(def.MobileTitle or sourceTitle), MobileTitleKey=mobileTitleKey,
            Group=def.Group, GroupKey=def.GroupKey, GroupTitle=def.GroupKey and tr(def.GroupKey,def.Group) or def.Group,
            Page=page, Root=root, Left=left, Right=right, Full=full, Visible=false,
            LeftLayout=leftLayout, RightLayout=rightLayout, FullLayout=fullLayout,
            NavButton=navButton, NavMarker=navMarker, NavIcon=navIcon, NavTitle=navTitle,
            Sections={}, CurrentSection=nil, _sectionOrder=0, ShownCallbacks={}, HiddenCallbacks={},
        }

        function tab:OnShown(callback)
            if type(callback)=="function" then self.ShownCallbacks[#self.ShownCallbacks+1]=callback end
            return callback
        end
        function tab:OnHidden(callback)
            if type(callback)=="function" then self.HiddenCallbacks[#self.HiddenCallbacks+1]=callback end
            return callback
        end

        function tab:_refreshCanvas()
            local columnsY=self.LeftLayout.AbsoluteContentSize.Y
            if self.Right.Visible then columnsY=math.max(columnsY,self.RightLayout.AbsoluteContentSize.Y) end
            local fullY=(self.Full and self.Full.Visible) and self.FullLayout.AbsoluteContentSize.Y or 0
            local gap=fullY>0 and columnsY>0 and M.SectionGap or 0
            if self.Full then
                self.Full.Position=UDim2.fromOffset(0,columnsY+gap)
                self.Full.Size=UDim2.new(1,0,0,fullY)
            end
            local totalY=columnsY+gap+fullY
            local pad=self.Window.Mode=="Mobile" and M.PagePadMobile or M.PagePadDesktop
            self.Root.Size=UDim2.new(1,-pad*2,0,totalY)
            self.Root.Position=UDim2.fromOffset(pad,pad)
            self.Page.CanvasSize=UDim2.fromOffset(0,totalY+pad*2)
        end

        function tab:_queueRefresh()
            if self._refreshQueued then return end
            self._refreshQueued=true
            task.defer(function()
                self._refreshQueued=false
                if self.Page and self.Page.Parent then self:_refreshCanvas() end
            end)
        end

        function tab:_queueRelayout()
            if self._relayoutQueued then return end
            self._relayoutQueued=true
            task.defer(function()
                self._relayoutQueued=false
                if self.Page and self.Page.Parent then self:_relayoutSections() end
            end)
        end

        function tab:_relayoutSections()
            if not IsInstanceAlive(self.Left) or not IsInstanceAlive(self.Right) or not IsInstanceAlive(self.Full) then return end
            local singleColumn=self.Window.Mode=="Mobile" or (tonumber(self.Window.ContentWidth) or 0)<570
            local leftWeight,rightWeight=0,0
            local fullVisible=0
            local aliveSections={}

            local function sectionWeight(section)
                local frame=section and section.Frame
                if frame and frame.AbsoluteSize and frame.AbsoluteSize.Y>M.SectionHeader+4 then return frame.AbsoluteSize.Y end
                local weight=M.SectionHeader
                for _,control in ipairs(section.Controls or {}) do
                    if not control._Feature or control._Feature.Visible then
                        local row=control.Row or control.Frame or control.Card
                        local h=row and row.Size and row.Size.Y.Offset or M.RowDesktop
                        if control.Type=="InfoList" then h=math.max(h,M.RowDesktop*3) end
                        weight=weight+math.max(M.RowCompact,h)
                    end
                end
                return math.max(M.RowDesktop,weight)
            end

            for _,section in ipairs(self.Sections) do
                local frame=section and section.Frame
                if IsInstanceAlive(frame) then
                    aliveSections[#aliveSections+1]=section
                    if section.Visible~=false then
                        local weight=sectionWeight(section)
                        local target
                        local preferred=tostring(section.PreferredColumn or ""):lower()
                        if section.FullWidth==true then
                            target=self.Full; fullVisible=fullVisible+1
                        elseif singleColumn then
                            target=self.Left; leftWeight=leftWeight+weight
                        elseif preferred=="right" then
                            target=self.Right; rightWeight=rightWeight+weight
                        elseif preferred=="left" then
                            target=self.Left; leftWeight=leftWeight+weight
                        elseif leftWeight<=rightWeight then
                            target=self.Left; leftWeight=leftWeight+weight
                        else
                            target=self.Right; rightWeight=rightWeight+weight
                        end
                        SafeParent(frame,target)
                    end
                end
            end
            self.Sections=aliveSections
            self.Right.Visible=not singleColumn
            self.Full.Visible=fullVisible>0
            self:_queueRefresh()
        end

        function tab:_applyMode(mode)
            local mobile=mode=="Mobile"
            local singleColumn=mobile or (tonumber(self.Window.ContentWidth) or 0)<570
            local pad=mobile and M.PagePadMobile or M.PagePadDesktop
            local gap=singleColumn and 0 or M.ColumnGap
            self.Page.ScrollBarThickness=mobile and 2 or 3
            self.Root.Position=UDim2.fromOffset(pad,pad)
            self.Root.Size=UDim2.new(1,-pad*2,self.Root.Size.Y.Scale,self.Root.Size.Y.Offset)
            self.Full.Size=UDim2.new(1,0,0,self.Full.Size.Y.Offset)
            if singleColumn then
                self.Left.Position=UDim2.fromOffset(0,0); self.Left.Size=UDim2.new(1,0,0,0); self.Right.Visible=false
            else
                self.Left.Position=UDim2.fromOffset(0,0); self.Left.Size=UDim2.new(0.5,-gap/2,0,0)
                self.Right.Position=UDim2.new(0.5,gap/2,0,0); self.Right.Size=UDim2.new(0.5,-gap/2,0,0); self.Right.Visible=true
            end
            local navW=math.clamp(math.floor(estimateTextWidth(self.Title,13,Enum.Font.GothamBold)+58),92,138)
            navButton.Size=UDim2.fromOffset(navW,46)
            navIcon.AnchorPoint=Vector2.new(0,0.5); navIcon.Position=UDim2.new(0,11,0.5,0); navIcon.Size=UDim2.fromOffset(24,24)
            navTitle.Position=UDim2.fromOffset(43,0)
            navTitle.Size=UDim2.new(1,-51,1,0)
            navTitle.Font=Enum.Font.GothamBold
            navTitle.TextSize=13
            navTitle.TextXAlignment=Enum.TextXAlignment.Left
            navTitle.Visible=true
            navMarker.AnchorPoint=Vector2.new(0.5,1); navMarker.Position=UDim2.new(0.5,0,1,0); navMarker.Size=UDim2.fromOffset(34,3)
            self:_relayoutSections()
            for _,section in ipairs(self.Sections) do section:_applyMode(mode) end
        end

        leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tab:_queueRefresh() end)
        rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tab:_queueRefresh() end)
        fullLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tab:_queueRefresh() end)

        local function ensureSection()
            if tab.CurrentSection then return tab.CurrentSection end
            return tab:AddSection({Title="General",TitleKey="ui.general",Subtle=true})
        end

        function tab:AddSection(sectionOptions)
            local opts=type(sectionOptions)=="table" and sectionOptions or {Title=sectionOptions}
            local sourceTitle=stripRichText(opts.Title or opts.Name or opts[1] or "Section")
            local layoutRule=sectionLayoutRule(self.Key,sourceTitle)
            if layoutRule then
                if layoutRule.Title then opts.Title=layoutRule.Title; opts.TitleKey=nil end
                if layoutRule.Column then opts.PreferredColumn=layoutRule.Column end
                if layoutRule.Order then opts.Order=layoutRule.Order end
                if layoutRule.FullWidth~=nil then opts.FullWidth=layoutRule.FullWidth==true end
            end
            local mergeKey=layoutRule and layoutRule.MergeKey or opts.MergeKey
            self._visualSectionsByKey=self._visualSectionsByKey or {}
            if mergeKey and self._visualSectionsByKey[mergeKey] and IsInstanceAlive(self._visualSectionsByKey[mergeKey].Frame) then
                self.CurrentSection=self._visualSectionsByKey[mergeKey]
                return self.CurrentSection
            end
            local displaySource=stripRichText(opts.Title or opts.Name or opts[1] or sourceTitle)
            local titleKey=opts.TitleKey
            local titleText=titleKey and tr(titleKey,displaySource) or localizeLegacy(displaySource)
            self._sectionOrder=self._sectionOrder+1
            local sectionId=tostring(opts.Id or ("section."..tostring(tab.Key or "tab").."."..displaySource):lower():gsub("[^%w%.]+","_"))
            -- Canonical layout invariant: the Items ownership summary always belongs
            -- to the right container. This is an ID-level layout rule, not a second
            -- ownership system, so localization/title routing cannot move it left.
            if canonicalTabKey(tab.Key)=="Items" and (sectionId=="items.ownership" or sectionId=="items.summary.owned" or sectionId=="items.summary.not_owned") then
                opts.PreferredColumn="Right"; opts.FullWidth=false
            end
            local sectionOrder=tonumber(opts.Order) or self._sectionOrder
            local frame=New("Frame",{
                Size=UDim2.new(1,0,0,52), AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=T.Surface, BackgroundTransparency=0.08, BorderSizePixel=0,
                LayoutOrder=sectionOrder, ZIndex=5,
            },self.Left)
            Corner(frame,M.SectionRadius); Stroke(frame,0.82,T.Stroke)
            local header=New("Frame",{Size=UDim2.new(1,0,0,M.SectionHeader),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=6},frame)
            local titleLabel=createText(header,{Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-24,1,0),Text=titleText,Font=Enum.Font.GothamMedium,TextSize=TX.Section,TextColor3=T.Text,ZIndex=7})
            if titleKey then bindKey(titleLabel,titleKey,displaySource) else bindLegacy(titleLabel,displaySource) end
            local headerLine=New("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,10,1,0),Size=UDim2.new(1,-20,0,1),BackgroundColor3=T.Divider,BackgroundTransparency=0.78,BorderSizePixel=0,ZIndex=7},header)
            local bodyFrame=New("Frame",{Position=UDim2.fromOffset(0,M.SectionHeader),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=6},frame)
            local bodyLayout=New("UIListLayout",{Padding=UDim.new(0,0),SortOrder=Enum.SortOrder.LayoutOrder},bodyFrame)
            local profileForcesColumn=layoutRule and layoutRule.FullWidth==false
            local section={Id=sectionId,Tab=tab,Frame=frame,Header=header,Title=titleLabel,Body=bodyFrame,Layout=bodyLayout,Controls={},Subtle=opts.Subtle==true,
                SourceTitle=sourceTitle,TitleKey=titleKey,Icon=opts.Icon,Order=sectionOrder,PreferredColumn=opts.PreferredColumn or opts.Column,FullWidth=(not profileForcesColumn) and (opts.FullWidth==true or tonumber(opts.Span)==2) or false,MergeKey=mergeKey,Seas=normalizeSeas(opts.Seas or opts.Sea or opts.__RE4Seas),VisibilityCondition=opts.VisibilityCondition or opts.VisibleWhen,Visible=false}
            function section:_applyMode(mode)
                local mobile=mode=="Mobile"
                self.Title.TextSize=mobile and (window.TinyViewport and 12 or 13) or TX.Section
                for _,control in ipairs(self.Controls) do if control._applyMode then control:_applyMode(mode) end end
            end
            bodyLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tab:_queueRefresh() end)
            self.Sections[#self.Sections+1]=section
            if mergeKey then self._visualSectionsByKey[mergeKey]=section end
            self.CurrentSection=section
            self:_queueRelayout()
            return section
        end

        local function rowBase(opts, kind, heightOverride)
            local section=ensureSection()
            local sourceName=stripRichText(opts.Name or opts.Title or kind or "Feature")
            local sourceDesc=stripRichText(opts.Description or opts.Desc or opts.Content or "")
            local name=opts.TitleKey and tr(opts.TitleKey,sourceName) or localizeLegacy(sourceName)
            local desc=opts.DescriptionKey and tr(opts.DescriptionKey,sourceDesc) or localizeLegacy(sourceDesc)
            if desc==name then desc="" end
            local order=tonumber(opts.Order) or (#section.Controls+1)
            local row=New("Frame",{
                Size=UDim2.new(1,0,0,heightOverride or M.RowDesktop),
                BackgroundColor3=T.Surface, BackgroundTransparency=1, BorderSizePixel=0,
                LayoutOrder=order, ZIndex=6,
            },section.Body)
            local titleLabel=createText(row,{Font=Enum.Font.GothamMedium,Text=name,TextSize=TX.RowTitle,TextColor3=T.Text,ZIndex=7,TextTruncate=Enum.TextTruncate.AtEnd})
            local descLabel=createText(row,{Font=Enum.Font.Gotham,Text=desc,TextSize=TX.RowDesc,TextColor3=T.Muted,ZIndex=7,TextTruncate=Enum.TextTruncate.AtEnd})
            local status=createStatusPill(row)
            local divider=createDivider(row)
            local control={
                Row=row,Card=row,Frame=row,Section=section,Tab=tab,
                Type=kind,Name=sourceName,SourceName=sourceName,SourceDescription=sourceDesc,Description=desc,TitleLabel=titleLabel,DescLabel=descLabel,
                TitleKey=opts.TitleKey,DescriptionKey=opts.DescriptionKey,StatusLabel=status,Divider=divider,Disabled=false,
            }
            if opts.TitleKey then bindKey(titleLabel,opts.TitleKey,sourceName) else bindLegacy(titleLabel,sourceName) end
            if opts.DescriptionKey then bindKey(descLabel,opts.DescriptionKey,sourceDesc) else bindLegacy(descLabel,sourceDesc) end
            function control:SetDesc(text)
                self.SourceDescription=tostring(text or "")
                self.Description=localizeLegacy(self.SourceDescription)
                descLabel.Text=(self.Description==titleLabel.Text) and "" or self.Description
            end
            function control:SetDescKey(key,params,fallback)
                self.DescriptionKey=key
                self.Description=tr(key,fallback or self.SourceDescription or "",params)
                descLabel.Text=(self.Description==titleLabel.Text) and "" or self.Description
            end
            local statusKeys={Running="status.running",Owned="status.owned",["Not owned"]="status.not_owned",["Can buy"]="status.can_buy",["Requirements missing"]="status.requirements_missing",Unknown="status.unknown",Active="status.active",Working="status.working",Done="status.done",Error="status.error",Waiting="status.waiting",Available="status.available",Blocked="status.blocked"}
            local function renderStatusSpec()
                local spec=control._StatusSpec
                if not spec or spec.Hidden then status.Visible=false; return end
                local value
                if spec.Key then value=tr(spec.Key,spec.Fallback or spec.Key,spec.Params)
                else value=localizeLegacy(spec.Source or "",spec.Params) end
                if value=="" then status.Visible=false; return end
                status.Text=value; status.Visible=true
                local col=toneColor(spec.Tone)
                status.TextColor3=col; status.BackgroundColor3=col; status.BackgroundTransparency=0.88
                status.Size=UDim2.fromOffset(math.clamp(estimateTextWidth(value,TX.Status,Enum.Font.GothamMedium)+14,46,116),19)
                if control._applyMode then control:_applyMode(window.Mode) end
            end
            function control:SetStatus(text,tone)
                local source=tostring(text or "")
                if source=="" then self._StatusSpec={Hidden=true}; status.Visible=false; return end
                local key=statusKeys[source]
                self._StatusSpec={Key=key,Source=source,Fallback=source,Tone=tone}
                renderStatusSpec()
            end
            function control:SetStatusKey(key,params,tone,fallback)
                self._StatusSpec={Key=key,Params=params,Fallback=fallback or key,Tone=tone}
                renderStatusSpec()
            end
            window:_listenLanguage(function() if not row.Parent then return false end; renderStatusSpec(); return true end)
            function control:SetAvailable(available,reason)
                available=available==true
                self.Disabled=not available
                row.BackgroundTransparency=1
                titleLabel.TextTransparency=available and 0 or 0.35
                descLabel.TextTransparency=available and 0 or 0.4
                if available then self:SetStatus("Available","good") else self:SetStatus(reason or "Unavailable","blocked") end
                if self.Button then self.Button.Active=available; self.Button.TextTransparency=available and 0 or 0.35 end
                if self.Box then self.Box.TextEditable=available; self.Box.TextTransparency=available and 0 or 0.35 end
                if self.Hit then self.Hit.Active=available end
                return available
            end
            function control:SetVisible(visible)
                visible=visible~=false
                self.Visible=visible
                if self._Feature then
                    self._Feature.ManualVisible=visible
                    if window and window._queueVisibilityRefresh then window:_queueVisibilityRefresh() end
                else
                    row.Visible=visible
                end
                return self
            end
            function control:_applyMode(mode)
                local mobile=mode=="Mobile"
                local titleSize=mobile and (window.TinyViewport and 12 or TX.MobileRowTitle) or TX.RowTitle
                local hasAction=self.Action and self.Action.Visible~=false
                local predictedReserve=hasAction and (self.ActionWidth or 104) or 12
                local predictedAvailable=math.max(80,(tonumber(window.ContentWidth) or 360)-predictedReserve-48)
                local longTitle=mobile and hasAction and estimateTextWidth(titleLabel.Text,titleSize,Enum.Font.GothamMedium)>predictedAvailable
                local complexAction=self.Type=="Dropdown" or self.Type=="Slider" or self.Type=="TextBox"
                local compactAction=self.Type=="Toggle" or self.Type=="Button"
                local contentWidth=tonumber(window.ContentWidth) or 360
                local stack=mobile and hasAction and ((complexAction and (window.NarrowContent or longTitle)) or (compactAction and longTitle and contentWidth<390))
                self.Stacked=stack==true
                local h=heightOverride or (stack and M.RowStackedMobile or (mobile and M.RowMobile or (window.CompactDensity and M.RowCompact or M.RowDesktop)))
                row.Size=UDim2.new(1,0,0,h)
                local left=mobile and 10 or 12
                local reserve=stack and 10 or (hasAction and (self.ActionWidth or 104) or 12)
                local statusReserve=(status.Visible and not stack) and (status.Size.X.Offset+7) or 0
                titleLabel.Position=UDim2.fromOffset(left,mobile and 6 or 6)
                titleLabel.Size=UDim2.new(1,-(left+reserve+statusReserve+7),0,stack and 31 or (mobile and 21 or 18))
                titleLabel.TextSize=titleSize
                titleLabel.TextWrapped=stack
                titleLabel.TextTruncate=stack and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd
                descLabel.Position=UDim2.fromOffset(left,stack and 37 or (mobile and 27 or 23))
                descLabel.Size=UDim2.new(1,-(left+reserve+7),0,stack and 18 or (mobile and 22 or 18))
                descLabel.TextSize=mobile and (window.TinyViewport and 10 or TX.MobileRowDesc) or TX.RowDesc
                descLabel.Visible=descLabel.Text~="" and descLabel.Text~=titleLabel.Text and not (window.CompactDensity and not mobile)
                if window.CompactDensity and not mobile then
                    titleLabel.Position=UDim2.fromOffset(left,4)
                    titleLabel.Size=UDim2.new(1,-(left+reserve+statusReserve+7),1,-8)
                end
                if status.Visible then
                    if stack then status.Position=UDim2.new(1,-(status.Size.X.Offset+10),0,6)
                    else status.Position=UDim2.new(1,-(reserve+status.Size.X.Offset+6),0,mobile and 7 or 5) end
                    status.TextSize=mobile and 9 or TX.Status
                end
                if hasAction and self._positionAction then self:_positionAction(mode,h,stack) end
            end
            section.Controls[#section.Controls+1]=control
            tab:_queueRelayout()
            window:RegisterFeature(control,tab,opts)
            control:_applyMode(window.Mode)
            return control,section
        end

        function tab:AddParagraph(opts)
            opts=opts or {}
            local control=rowBase(opts,"Paragraph",nil)
            control:SetStatus(opts.Status or "",opts.Tone)
            return control
        end

        function tab:AddStatus(opts)
            opts=opts or {}
            local control=self:AddParagraph(opts)
            control:SetStatus(opts.Status or "Waiting",opts.Tone or "waiting")
            return control
        end

        function tab:AddToggle(opts)
            opts=opts or {}
            local control=rowBase(opts,"Toggle")
            local track,knob=createSwitch(control.Row,opts.Default==true)
            control.Action=track; control.Button=track; control.ActionWidth=62
            control.Value=opts.Default==true; control.Callback=opts.Callback
            function control:_positionAction(mode,h)
                track.Position=UDim2.new(1,-50,0.5,-M.SwitchH/2)
            end
            function control:_render()
                Tween(track,C.Motion.Fast,{BackgroundColor3=self.Value and T.Accent or T.Control})
                Tween(knob,C.Motion.Fast,{Position=self.Value and UDim2.new(1,-11,0.5,0) or UDim2.new(0,11,0.5,0)})
                if not self._OwnershipItem then
                    self:SetStatus(self.Value and "Running" or "",self.Value and "running" or nil)
                end
            end
            function control:SetValue(value,callCallback)
                if self.Disabled and value then return false end
                self.Value=value==true; self:_render()
                if callCallback~=false then
                    -- Movement lifecycle is owner-scoped in runtime. UI must never
                    -- cancel/resume the global TravelResolver for a generic toggle:
                    -- disabling feature A may coexist with feature B still moving.
                    local ok=SafeCall(self.Name,self.Callback,self.Value)
                    pcall(function()
                        local env=RE4ResolveEnvLocal()
                        local changed=env and env.__RE4ControlStateChanged
                        if type(changed)=="function" then changed(self.Name,self.Value) end
                    end)
                    return ok
                end
                return true
            end
            function control:RefreshOwnership()
                if not self._OwnershipItem then return end
                local provider=Ownership()
                local state=ownershipState(provider,self._OwnershipItem)
                local owned=state.Owned==true
                local selectable=self._OwnershipSelectable==true
                local automation=self._OwnershipAutomation==true
                local oneTime=self._OwnershipOneTime==true
                local active=type(provider.IsEquipped)=="function" and provider:IsEquipped(self._OwnershipItem) or false
                if automation or oneTime then
                    -- One-time progression automation disappears once ownership is confirmed.
                    -- The adjacent progression/info card remains and shows Owned.
                    if owned then
                        if self.Value then
                            self.Value=false
                            SafeCall(self.Name,self.Callback,false)
                        end
                        self.Disabled=true
                        track.Active=false
                        self:SetStatus("Owned","completed")
                        self:SetVisible(false)
                    else
                        self:SetVisible(true)
                        self.Disabled=false
                        track.Active=true
                        renderOwnershipStatus(self,state,self.Value==true)
                        self:_render()
                    end
                    return
                end
                if selectable then
                    if self._OwnershipUseOnly==true and not owned then
                        -- Items → Fighting only exposes styles with confirmed ownership.
                        -- The control remains mounted so a later Progress purchase can
                        -- reveal it immediately during the shared ownership refresh.
                        self.Disabled=true; track.Active=false; self.Value=false; self._UseJobRunning=false
                        self:SetStatus(""); self:SetVisible(false)
                        return
                    end
                    self:SetVisible(true)
                    if active then
                        self.Disabled=true; track.Active=false; self.Value=true; self._UseJobRunning=false
                        self:SetStatus("Active","good"); track.BackgroundColor3=T.Good; knob.Position=UDim2.new(1,-11,0.5,0)
                    elseif self._UseJobRunning==true then
                        self.Disabled=false; track.Active=true; self.Value=true
                        self:SetStatus("Working","running"); track.BackgroundColor3=T.Accent; knob.Position=UDim2.new(1,-11,0.5,0)
                    else
                        self.Disabled=false; track.Active=true; self.Value=false
                        self:SetStatus("Owned","completed"); track.BackgroundColor3=T.Control; knob.Position=UDim2.new(0,11,0.5,0)
                    end
                    return
                end
                self.Disabled=owned
                track.Active=not owned
                if owned then
                    if self.Value then self.Value=false; SafeCall(self.Name,self.Callback,false) end
                    self:SetStatus("Owned","completed"); track.BackgroundColor3=T.Good; knob.Position=UDim2.new(1,-11,0.5,0)
                else
                    self:_render()
                    if not self.Value then renderOwnershipStatus(self,state,false) end
                end
            end
            track.MouseButton1Click:Connect(function()
                control:RefreshOwnership(); if control.Disabled then return end
                local nextValue=not control.Value
                local ok=control:SetValue(nextValue,true)
                if ok then
                    window:Notify({Id="toggle:"..tostring(control.Name),Cooldown=0.35,Tone=nextValue and "good" or "info",Title=RE4UI.HubName,ContentKey=nextValue and "notify.feature_enabled" or "notify.feature_disabled",Params={feature=control.TitleLabel and control.TitleLabel.Text or localizeLegacy(control.Name)},Duration=2.2})
                end
            end)
            Ownership():Register(control,control.Name); control:RefreshOwnership(); control:_render(); control:_applyMode(window.Mode)
            if not control.Disabled then task.defer(function() SafeCall(control.Name,control.Callback,control.Value) end) end
            return control
        end

        function tab:AddButton(opts)
            opts=opts or {}
            local control=rowBase(opts,"Button")
            local actionText=opts.ActionText
            local actionKey=opts.ActionTextKey
            if not actionText then
                local n=control.Name:lower()
                if n:find("teleport") or n:find("tween") then actionKey="action.go"; actionText="Go"
                elseif n:find("buy") then actionKey="action.buy"; actionText="Buy"
                elseif n:find("craft") then actionKey="action.craft"; actionText="Craft"
                elseif n:find("start") then actionKey="action.start"; actionText="Start"
                elseif n:find("copy") then actionKey="action.copy"; actionText="Copy"
                else actionKey="action.run"; actionText="Run" end
            end
            if actionKey then actionText=tr(actionKey,actionText) else actionText=localizeLegacy(actionText) end
            local button=New("TextButton",{Size=UDim2.fromOffset(78,30),BackgroundColor3=T.AccentSoft,BorderSizePixel=0,Text=actionText,Font=Enum.Font.GothamBold,TextColor3=T.Text,TextSize=TX.Control,AutoButtonColor=false,ZIndex=8},control.Row)
            Corner(button,8); Stroke(button,0.72,T.Stroke); setHover(button,T.AccentSoft,T.Accent)
            control.Action=button; control.Button=button; control.ActionWidth=90; control.Callback=opts.Callback
            window:_listenLanguage(function()
                if not button.Parent then return false end
                if actionKey then actionText=tr(actionKey,opts.ActionText or actionText) else actionText=localizeLegacy(opts.ActionText or actionText) end
                if button.Parent then control:RefreshOwnership() end
                return button.Parent~=nil
            end)
            function control:_positionAction(mode,h,stack)
                local bh=mode=="Mobile" and 36 or 30
                local bw=mode=="Mobile" and 84 or 78
                button.Size=UDim2.fromOffset(bw,bh)
                if stack then button.Position=UDim2.new(1,-(bw+10),1,-(bh+7)) else button.Position=UDim2.new(1,-(bw+10),0.5,-bh/2) end
                button.TextSize=TX.Control
            end
            function control:RefreshOwnership()
                if not self._OwnershipItem then
                    self:SetVisible(true)
                    self.Disabled=false; button.Active=true; button.Visible=true; button.Text=actionText; button.BackgroundColor3=T.AccentSoft
                    return
                end
                local provider=Ownership()
                local state=ownershipState(provider,self._OwnershipItem)
                local owned=state.Owned==true
                local selectable=self._OwnershipSelectable==true
                local useOnly=self._OwnershipUseOnly==true
                local active=selectable and type(provider.IsEquipped)=="function" and provider:IsEquipped(self._OwnershipItem) or false
                if selectable then
                    if useOnly and not owned then
                        -- Use/equip rows are relevant only for styles the player owns.
                        self.Disabled=true; button.Active=false; button.Visible=false; self:SetVisible(false)
                        return
                    end
                    self:SetVisible(true); button.Visible=true
                    if active then
                        self.Disabled=true; button.Active=false; button:SetAttribute("RE4Locked",true)
                        button.Text=tr("status.active","Active"); button.BackgroundColor3=T.Good; self:SetStatus("Active","good")
                    else
                        self.Disabled=false; button.Active=true; button:SetAttribute("RE4Locked",false)
                        button.Text=tr("action.use","Use"); button.BackgroundColor3=T.AccentSoft; self:SetStatus("Owned","completed")
                    end
                    return
                end

                -- Purchasable/craftable item: keep the row and Owned status, but hide
                -- the Buy/Craft action itself once inventory ownership is confirmed.
                self:SetVisible(true)
                local blocked=state.Code=="blocked"
                self.Disabled=owned or blocked
                button.Active=not self.Disabled
                button.Visible=not owned
                button:SetAttribute("RE4Locked",self.Disabled)
                button.Text=actionText
                button.BackgroundColor3=blocked and T.Control or T.AccentSoft
                renderOwnershipStatus(self,state,false)
            end
            button.MouseButton1Click:Connect(function()
                control:RefreshOwnership(); if control.Disabled then return end
                control:SetStatus("Working","running")
                local ok=SafeCall(control.Name,control.Callback)
                control:SetStatus(ok and "Done" or "Error",ok and "good" or "bad")
                if ok and control._OwnershipItem then
                    local provider=Ownership()
                    if type(provider.UpdateControls)=="function" then
                        task.delay(0.45,function() pcall(function() provider:UpdateControls(true) end) end)
                    end
                end
                task.delay(1.1,function() if control.Row.Parent then control:RefreshOwnership(); if not control._OwnershipItem then control:SetStatus("") end end end)
            end)
            Ownership():Register(control,control.Name); control:RefreshOwnership(); control:_applyMode(window.Mode)
            return control
        end

        function tab:AddDropdown(opts)
            opts=opts or {}
            local optionsList=type(opts.Options)=="table" and opts.Options or {}
            local multi=opts.Multi==true
            local selected=opts.Default
            if multi and type(selected)~="table" then selected={} end
            if not multi and (selected==nil or selected==false) then selected=optionsList[1] end
            local control=rowBase(opts,"Dropdown")
            local button=New("TextButton",{BackgroundColor3=T.Control,BorderSizePixel=0,Text="",Font=Enum.Font.GothamMedium,TextColor3=T.Text,TextSize=TX.Control,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=8},control.Row)
            Corner(button,8); Stroke(button,0.64,T.Stroke); Padding(button,9,24,0,0); setHover(button,T.Control,T.ControlHover)
            local caret=createText(button,{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-8,0.5,0),Size=UDim2.fromOffset(12,14),Text="v",Font=Enum.Font.GothamBold,TextColor3=T.Muted,TextSize=9,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=9})
            control.Action=button; control.Button=button; control.ActionWidth=178; control.Value=selected; control.Options=optionsList; control.Callback=opts.Callback
            local localizeOptions=opts.LocalizeOptions~=false
            local optionLabelKeys=type(opts.OptionLabelKeys)=="table" and opts.OptionLabelKeys or nil
            local optionLabels=type(opts.OptionLabels)=="table" and opts.OptionLabels or nil
            local function optionDisplay(option)
                local raw=tostring(option or "")
                if optionLabelKeys and optionLabelKeys[option] then return tr(optionLabelKeys[option],raw) end
                if optionLabels and optionLabels[option] then return tostring(optionLabels[option]) end
                return localizeOptions and localizeLegacy(raw) or raw
            end
            local function selectedText()
                if multi then
                    if #control.Value==0 then return tr("ui.select","Select") end
                    local labels={}; for _,value in ipairs(control.Value) do labels[#labels+1]=optionDisplay(value) end
                    return table.concat(labels,", ")
                end
                return control.Value~=nil and optionDisplay(control.Value) or tr("ui.select","Select")
            end
            local function refresh() button.Text=selectedText() end
            window:_listenLanguage(function() if not button.Parent then return false end; refresh(); return true end)
            function control:_positionAction(mode,h,stack)
                local hh=mode=="Mobile" and 34 or 28
                if stack then button.Size=UDim2.new(1,-20,0,hh); button.Position=UDim2.fromOffset(10,h-hh-8); self.ActionWidth=10
                else local w=mode=="Mobile" and 138 or 150; button.Size=UDim2.fromOffset(w,hh); button.Position=UDim2.new(1,-(w+10),0.5,-hh/2); self.ActionWidth=w+20 end
                button.TextSize=TX.Control
            end
            function control:SetValue(value,callCallback)
                if self.Disabled then return false end
                self.Value=value; refresh()
                if callCallback~=false then SafeCall(self.Name,self.Callback,self.Value) end
            end
            function control:SetOptions(newOptions,keepValue)
                self.Options=type(newOptions)=="table" and newOptions or {}
                if not keepValue then self.Value=multi and {} or self.Options[1] end
                refresh()
            end
            local function openPopup()
                if control.Disabled then return end
                window.Overlay:Close()
                local v=window:_viewport(); local w=math.max(button.AbsoluteSize.X,220); w=math.min(w,v.X-16)
                local optionH=38; local maxH=math.min(window.Mode=="Mobile" and 300 or 320,v.Y-24)
                local h=math.min(maxH,math.max(58,#control.Options*(optionH+3)+14))
                local x=math.clamp(button.AbsolutePosition.X,8,math.max(8,v.X-w-8))
                local below=button.AbsolutePosition.Y+button.AbsoluteSize.Y+5
                local y=(below+h<=v.Y-8) and below or math.max(8,button.AbsolutePosition.Y-h-5)
                local blocker=window.Overlay:CreateBlocker(900)
                local popup=New("Frame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=T.SurfaceRaised,BorderSizePixel=0,ZIndex=901},gui); Corner(popup,M.PopupRadius); Stroke(popup,0.16)
                local list=New("ScrollingFrame",{Position=UDim2.fromOffset(6,6),Size=UDim2.new(1,-12,1,-12),BackgroundTransparency=1,BorderSizePixel=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ScrollBarImageColor3=T.Accent,ZIndex=902},popup)
                New("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},list)
                for _,option in ipairs(control.Options) do
                    local active=multi and table.find(control.Value,option)~=nil or control.Value==option
                    local b=New("TextButton",{Size=UDim2.new(1,-2,0,optionH),BackgroundColor3=active and T.AccentFaint or T.Control,BorderSizePixel=0,Text=(active and "[x] " or "[ ] ")..optionDisplay(option),Font=Enum.Font.GothamMedium,TextColor3=active and T.Text or T.TextSoft,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,ZIndex=903},list); Corner(b,8); Padding(b,10,8,0,0); setHover(b,active and T.AccentFaint or T.Control,T.ControlHover)
                    b.MouseButton1Click:Connect(function()
                        if multi then
                            local idx=table.find(control.Value,option)
                            if idx then table.remove(control.Value,idx) else table.insert(control.Value,option) end
                            local nowSelected = table.find(control.Value, option) ~= nil
                            b.Text = (nowSelected and "[x] " or "[ ] ") .. optionDisplay(option)
                            b.BackgroundColor3 = nowSelected and T.AccentFaint or T.Control
                            b.TextColor3 = nowSelected and T.Text or T.TextSoft
                            refresh(); SafeCall(control.Name,control.Callback,control.Value)
                        else
                            control.Value=option; refresh(); SafeCall(control.Name,control.Callback,control.Value); window.Overlay:Close()
                        end
                    end)
                end
                window.Overlay:Set(popup,blocker,nil)
            end
            button.MouseButton1Click:Connect(openPopup)
            refresh(); control:_applyMode(window.Mode)
            if selected~=nil and selected~=false then task.defer(function() SafeCall(control.Name,control.Callback,control.Value) end) end
            return control
        end

        function tab:AddSlider(opts)
            opts=opts or {}
            local min=tonumber(opts.Min) or 0; local max=tonumber(opts.Max) or 100; if max<min then min,max=max,min end
            local rounding=tonumber(opts.Rounding) or 0
            local value=math.clamp(tonumber(opts.Default) or min,min,max)
            local control=rowBase(opts,"Slider")
            local holder=New("Frame",{BackgroundTransparency=1,BorderSizePixel=0,ZIndex=8},control.Row)
            local valueLabel=createText(holder,{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,0),Size=UDim2.fromOffset(56,18),Text="",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=T.Text,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=9})
            local bar=New("Frame",{Position=UDim2.new(0,0,1,-8),Size=UDim2.new(1,0,0,5),BackgroundColor3=T.Control,BorderSizePixel=0,ZIndex=9},holder); Corner(bar,5)
            local fill=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=10},bar); Corner(fill,5)
            local knob=New("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(13,13),BackgroundColor3=T.Text,BorderSizePixel=0,ZIndex=11},bar); Corner(knob,13)
            local hit=New("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.new(0,0,0.5,-15),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=12},bar)
            control.Action=holder; control.Hit=hit; control.ActionWidth=190; control.Value=value; control.Callback=opts.Callback
            local function setFromX(x,callCallback)
                local a=math.clamp((x-bar.AbsolutePosition.X)/math.max(1,bar.AbsoluteSize.X),0,1)
                local raw=min+(max-min)*a
                if rounding>0 then raw=math.floor(raw/rounding+0.5)*rounding else raw=math.floor(raw+0.5) end
                control.Value=math.clamp(raw,min,max)
                local ratio=(control.Value-min)/math.max(1e-6,max-min)
                fill.Size=UDim2.new(ratio,0,1,0); knob.Position=UDim2.new(ratio,0,0.5,0); valueLabel.Text=tostring(control.Value)
                if callCallback then SafeCall(control.Name,control.Callback,control.Value) end
            end
            function control:_positionAction(mode,h,stack)
                local hh=mode=="Mobile" and 38 or 32
                if stack then holder.Size=UDim2.new(1,-20,0,hh); holder.Position=UDim2.fromOffset(10,h-hh-7); self.ActionWidth=10
                else local w=mode=="Mobile" and 142 or 156; holder.Size=UDim2.fromOffset(w,hh); holder.Position=UDim2.new(1,-(w+10),0.5,-hh/2); self.ActionWidth=w+20 end
            end
            function control:SetValue(newValue,callCallback)
                if self.Disabled then return false end
                self.Value=math.clamp(tonumber(newValue) or self.Value,min,max)
                local ratio=(self.Value-min)/math.max(1e-6,max-min)
                fill.Size=UDim2.new(ratio,0,1,0); knob.Position=UDim2.new(ratio,0,0.5,0); valueLabel.Text=tostring(self.Value)
                if callCallback~=false then SafeCall(self.Name,self.Callback,self.Value) end
                return true
            end
            hit.InputBegan:Connect(function(input)
                if control.Disabled then return end
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then window.Input:BeginSlider(input,function(x) setFromX(x,true) end) end
            end)
            control:SetValue(value,false); control:_applyMode(window.Mode)
            task.defer(function() SafeCall(control.Name,control.Callback,control.Value) end)
            return control
        end

        function tab:AddTextBox(opts)
            opts=opts or {}
            local control=rowBase(opts,"TextBox")
            local placeholderSource=tostring(opts.Placeholder or "Type...")
            local placeholder=opts.PlaceholderKey and tr(opts.PlaceholderKey,placeholderSource) or localizeLegacy(placeholderSource)
            local box=New("TextBox",{BackgroundColor3=T.Control,BorderSizePixel=0,Text=tostring(opts.Default or ""),PlaceholderText=placeholder,PlaceholderColor3=T.Muted,TextColor3=T.Text,Font=Enum.Font.GothamMedium,TextSize=TX.Control,ClearTextOnFocus=opts.ClearOnFocus==true,ZIndex=8},control.Row)
            if opts.PlaceholderKey then LanguageManager:Bind(box,"PlaceholderText",opts.PlaceholderKey,placeholderSource,nil,false) else LanguageManager:Bind(box,"PlaceholderText",nil,placeholderSource,nil,true) end; Corner(box,8); Stroke(box,0.64)
            control.Action=box; control.Box=box; control.ActionWidth=190; control.Value=box.Text; control.Callback=opts.Callback
            function control:_positionAction(mode,h,stack)
                local hh=mode=="Mobile" and 34 or 28
                if stack then box.Size=UDim2.new(1,-20,0,hh); box.Position=UDim2.fromOffset(10,h-hh-8); self.ActionWidth=10
                else local w=mode=="Mobile" and 138 or 150; box.Size=UDim2.fromOffset(w,hh); box.Position=UDim2.new(1,-(w+10),0.5,-hh/2); self.ActionWidth=w+20 end
                box.TextSize=TX.Control
            end
            function control:SetValue(text,callCallback)
                if self.Disabled then return false end
                box.Text=tostring(text or ""); self.Value=box.Text
                if callCallback~=false then SafeCall(self.Name,self.Callback,box.Text,false) end
                return true
            end
            box.FocusLost:Connect(function(enterPressed)
                if control.Disabled then return end
                control.Value=box.Text; SafeCall(control.Name,control.Callback,box.Text,enterPressed)
            end)
            control:_applyMode(window.Mode)
            return control
        end
        tab.AddInput=tab.AddTextBox

        function tab:AddProgress(opts)
            opts=opts or {}
            local control=rowBase(opts,"Progress",74)
            local track=New("Frame",{Position=UDim2.new(0,12,1,-12),Size=UDim2.new(1,-24,0,4),BackgroundColor3=T.Control,BorderSizePixel=0,ZIndex=8},control.Row); Corner(track,4)
            local fill=New("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=9},track); Corner(fill,4)
            control.ProgressTrack=track; control.ProgressFill=fill
            function control:SetProgress(value,maximum,label)
                maximum=tonumber(maximum) or 100; value=math.clamp(tonumber(value) or 0,0,math.max(maximum,0)); local ratio=maximum>0 and value/maximum or 0
                Tween(fill,C.Motion.Normal,{Size=UDim2.new(ratio,0,1,0)})
                self:SetDesc(label or string.format("Progress %d / %d",value,maximum))
                self:SetStatus(string.format("%d%%",math.floor(ratio*100+0.5)),ratio>=1 and "completed" or "info")
            end
            local baseApply=control._applyMode
            function control:_applyMode(mode)
                baseApply(self,mode); self.Row.Size=UDim2.new(1,0,0,mode=="Mobile" and 82 or 74)
            end
            control:SetProgress(opts.Value or 0,opts.Max or opts.Maximum or 100,opts.Label); control:_applyMode(window.Mode)
            return control
        end

        function tab:AddInfoList(opts)
            opts=opts or {}
            local section=ensureSection()
            local order=#section.Controls+1
            local panel=New("Frame",{Size=UDim2.new(1,0,0,90),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=order,ZIndex=6},section.Body)
            local infoSourceTitle=opts.Title or opts.Name or "Information"
            local head=createText(panel,{Position=UDim2.fromOffset(12,6),Size=UDim2.new(1,-24,0,22),Text=opts.TitleKey and tr(opts.TitleKey,infoSourceTitle) or localizeLegacy(infoSourceTitle),Font=Enum.Font.GothamBold,TextSize=TX.RowTitle,ZIndex=7})
            if opts.TitleKey then bindKey(head,opts.TitleKey,infoSourceTitle) else bindLegacy(head,infoSourceTitle) end
            local rows=New("Frame",{Position=UDim2.fromOffset(12,32),Size=UDim2.new(1,-24,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=7},panel)
            local fixedColumns=math.clamp(tonumber(opts.Columns) or 0,0,2)
            local wrapValues=opts.WrapValues==true
            local grid=New("UIGridLayout",{CellSize=UDim2.new(0.5,-5,0,38),CellPadding=UDim2.fromOffset(8,5),SortOrder=Enum.SortOrder.LayoutOrder},rows)
            local control={Row=panel,Card=panel,Frame=panel,Type="InfoList",Name=opts.Title or opts.Name or "Information",Section=section,Tab=tab,_rowItems={},_cells={},_usedKeys={},_columns=nil,_fixedColumns=fixedColumns,_wrapValues=wrapValues}
            local function itemKey(item,index,label)
                if type(item)=="table" then
                    return tostring(item.Id or item.Key or item.LabelKey or ((label or "item").."#"..tostring(index)))
                end
                return tostring(label or "item").."#"..tostring(index)
            end
            function control:SetItems(items, forceRender)
                self._rowItems = type(items)=="table" and items or {}
                if forceRender~=true and window.ActiveTab~=tab then
                    self._deferredDirty=true
                    return
                end
                self._deferredDirty=false
                local used=self._usedKeys
                table.clear(used)
                local count=0
                local structureChanged=false
                for index,item in ipairs(self._rowItems) do
                    count=count+1
                    local label=type(item)=="table" and (item.Label or item[1]) or tostring(item)
                    local labelKey=type(item)=="table" and item.LabelKey or nil
                    local value=type(item)=="table" and (item.Value or item[2]) or ""
                    local key=itemKey(item,index,label)
                    -- Duplicate semantic labels are common for requirement rows. Preserve
                    -- stable identity by suffixing only actual collisions.
                    if used[key] then key=key.."#"..tostring(index) end
                    used[key]=true
                    local entry=self._cells[key]
                    if not entry or not IsInstanceAlive(entry.Cell) then
                        local cell=New("Frame",{BackgroundColor3=T.Control,BackgroundTransparency=0.26,BorderSizePixel=0,ZIndex=8,LayoutOrder=index},rows); Corner(cell,8)
                        local labelObj=createText(cell,{Position=UDim2.fromOffset(9,2),Size=UDim2.new(1,-18,0,15),Text="",TextColor3=T.Muted,TextSize=8,Font=Enum.Font.GothamMedium,ZIndex=9})
                        local valueObj=createText(cell,{Position=UDim2.fromOffset(9,16),Size=UDim2.new(1,-18,0,wrapValues and 44 or 18),Text="",TextColor3=T.Text,TextSize=11,Font=Enum.Font.GothamBold,TextWrapped=wrapValues,TextYAlignment=Enum.TextYAlignment.Top,TextTruncate=wrapValues and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd,ZIndex=9})
                        entry={Cell=cell,Label=labelObj,Value=valueObj}
                        self._cells[key]=entry
                        structureChanged=true
                    end
                    entry.Cell.LayoutOrder=index
                    local labelText=labelKey and tr(labelKey,label or labelKey) or localizeLegacy(label or "")
                    local valueText=tostring(value or "-")
                    if entry.Label.Text~=labelText then entry.Label.Text=labelText end
                    if entry.Value.Text~=valueText then entry.Value.Text=valueText end
                end
                for key,entry in pairs(self._cells) do
                    if not used[key] then
                        if entry.Cell and IsInstanceAlive(entry.Cell) then entry.Cell:Destroy() end
                        self._cells[key]=nil
                        structureChanged=true
                    end
                end
                local columns=window.Mode=="Mobile" and 1 or ((self._fixedColumns and self._fixedColumns>0) and self._fixedColumns or 2)
                if self._columns~=columns then structureChanged=true; self._columns=columns end
                local cellH=self._wrapValues and 68 or (columns==1 and 42 or 38)
                grid.CellSize=columns==1 and UDim2.new(1,0,0,cellH) or UDim2.new(0.5,-5,0,cellH)
                local rowsCount=math.ceil(count/columns)
                local rowHeight=rowsCount*(cellH+6)
                if rows.Size.Y.Offset~=rowHeight then structureChanged=true end
                rows.Size=UDim2.new(1,-24,0,rowHeight)
                panel.Size=UDim2.new(1,0,0,36+rowHeight+8)
                if structureChanged then tab:_queueRefresh() end
            end
            function control:_renderDeferred()
                if self._deferredDirty or next(self._cells)==nil then self:SetItems(self._rowItems,true) end
            end
            function control:_applyMode(mode)
                head.TextSize=mode=="Mobile" and 14 or TX.RowTitle
                self._columns=nil
                if window.ActiveTab==tab then self:SetItems(self._rowItems,true) else self._deferredDirty=true end
            end
            function control:SetVisible(visible)
                visible=visible~=false
                if self.Visible==visible then return self.Visible end
                self.Visible=visible
                if self._Feature then
                    self._Feature.ManualVisible=self.Visible
                    if window and window._queueVisibilityRefresh then window:_queueVisibilityRefresh() end
                elseif IsInstanceAlive(panel) then
                    panel.Visible=self.Visible
                    tab:_queueRelayout()
                end
                return self.Visible
            end
            function control:IsVisible()
                return IsInstanceAlive(panel) and panel.Visible==true
            end
            function control:SetDesc() end; function control:SetStatus() end; function control:SetAvailable() return true end
            window:_listenLanguage(function() if not panel.Parent then return false end; control:SetItems(control._rowItems); return true end)
            section.Controls[#section.Controls+1]=control; tab:_queueRelayout(); window:RegisterFeature(control,tab,opts); control:SetItems(opts.Items or {}); return control
        end

        function tab:AddDiscordInvite(opts)
            return self:AddParagraph({TitleKey="ui.external_link",Title=(opts and opts.Title) or "External link",DescriptionKey="ui.external_disabled",Content="External links are disabled in this build."})
        end

        navButton.MouseButton1Click:Connect(function() window:ShowTab(tab) end)
        self.Tabs[#self.Tabs+1]=tab; self.TabsByKey[key]=tab
        self.TabsByKey[tostring(requestedKey or key)]=tab
        for alias,targetKey in pairs(C.TabAliases or {}) do if targetKey==key then self.TabsByKey[alias]=tab end end
        window:_listenLanguage(function()
            if not tab.Page.Parent then return false end
            tab.Title=titleKey and tr(titleKey,sourceTitle) or localizeLegacy(sourceTitle)
            tab.MobileTitle=mobileTitleKey and tr(mobileTitleKey,def.MobileTitle or sourceTitle) or localizeLegacy(def.MobileTitle or sourceTitle)
            tab.Subtitle=subtitleKey and tr(subtitleKey,def.Subtitle or def.Group or RE4UI.HubName) or (def.Subtitle or def.Group)
            tab.GroupTitle=def.GroupKey and tr(def.GroupKey,def.Group) or def.Group
            if tab.NavTitle then tab.NavTitle.Text=tab.Title end
            if window.ActiveTab==tab then pageTitle.Text=tab.Title; pageSubtitle.Text=tostring(tab.Subtitle or tab.GroupTitle or tab.Group or RE4UI.HubName) end
            window:_refreshNavigation()
            return true
        end)
        tab:_applyMode(self.Mode)
        self:RefreshVisibility()
        return tab
    end

    -- Mobile navigation is created after tabs exist; refresh on every MakeTab through deferred rebuild.
    function window:_rebuildMobileNav()
        for _,tab in ipairs(self.Tabs) do tab.MobileButton=nil; tab.MobileIcon=nil; tab.MobileLabel=nil; tab.MobileMarker=nil end
        for _,child in ipairs(mobileNav:GetChildren()) do if child:IsA("GuiButton") then child:Destroy() end end
        local primary,used=self:_mobilePrimaryTabs()
        local remaining=0
        for _,tab in ipairs(self.Tabs) do if tab.Visible and not used[tab] then remaining=remaining+1 end end
        local entries={}
        for _,tab in ipairs(primary) do entries[#entries+1]={Tab=tab,Title=tab.MobileTitle} end
        if remaining>0 then entries[#entries+1]={More=true,Title=tr("ui.more","More")} end
        if #entries==0 then return end
        local cellScale=1/#entries
        for i,entry in ipairs(entries) do
            local tab=entry.Tab
            local b=New("TextButton",{Size=UDim2.new(cellScale,-2,1,-4),BackgroundTransparency=1,BorderSizePixel=0,Text="",AutoButtonColor=false,LayoutOrder=i,ZIndex=22},mobileNav)
            local active=tab and self.ActiveTab==tab
            if tab then
                local def=navDefinition[tab.Key] or {}
                local marker=New("Frame",{AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,-1),Size=UDim2.fromOffset(30,3),BackgroundColor3=T.Accent,BorderSizePixel=0,Visible=active,ZIndex=24},b); Corner(marker,2)
                local icon=New("ImageLabel",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,5),Size=UDim2.fromOffset(22,22),BackgroundTransparency=1,Image=def.Icon or "",ImageColor3=Color3.new(1,1,1),ImageTransparency=active and 0 or 0.30,ScaleType=Enum.ScaleType.Fit,ZIndex=23},b)
                local label=createText(b,{Position=UDim2.new(0,2,0,29),Size=UDim2.new(1,-4,1,-30),Text=entry.Title,Font=active and Enum.Font.GothamBold or Enum.Font.GothamMedium,TextColor3=active and T.Text or T.Muted,TextSize=self.TinyViewport and 8 or 10,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=23})
                tab.MobileButton=b; tab.MobileIcon=icon; tab.MobileLabel=label; tab.MobileMarker=marker
                b.MouseButton1Click:Connect(function() self:ShowTab(tab) end)
            else
                local moreIcon=New("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,9),Size=UDim2.fromOffset(18,10),BackgroundTransparency=1,ZIndex=23},b)
                for x=1,3 do local dot=New("Frame",{Size=UDim2.fromOffset(3,3),Position=UDim2.fromOffset((x-1)*7,3),BackgroundColor3=T.Muted,BorderSizePixel=0,ZIndex=24},moreIcon); Corner(dot,999) end
                createText(b,{Position=UDim2.new(0,2,0,29),Size=UDim2.new(1,-4,1,-30),Text=entry.Title,Font=Enum.Font.GothamMedium,TextColor3=T.Muted,TextSize=self.TinyViewport and 8 or 10,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=23})
                b.MouseButton1Click:Connect(function() self:_openMoreMenu() end)
            end
        end
    end

    local originalMakeTab=window.MakeTab
    function window:MakeTab(opts)
        local tab=originalMakeTab(self,opts)
        task.defer(function() self:_applyResponsive(false); self:RefreshVisibility() end)
        return tab
    end

    -- Header/window drag uses one render-step smoother instead of snapping every input event.
    window._dragTarget=nil
    window._metricFrames=0; window._metricElapsed=0
    local function readPingString()
        local network=Stats and Stats:FindFirstChild("Network")
        local server=network and network:FindFirstChild("ServerStatsItem")
        local item=server and (server:FindFirstChild("Data Ping") or server["Data Ping"])
        return item and item:GetValueString() or "--"
    end
    window._connections[#window._connections+1]=RunService.RenderStepped:Connect(function(dt)
        if window._dragTarget and main.Visible then
            local alpha=math.clamp((tonumber(dt) or 0.016)*24,0.18,0.72)
            main.Position=main.Position:Lerp(window._dragTarget,alpha)
        end
        if main.Visible then
            local delta=math.max(0.001,tonumber(dt) or 0.016)
            window._metricFrames=window._metricFrames+1
            window._metricElapsed=window._metricElapsed+delta
            if window._metricElapsed>=1 then
                local fps=math.floor(window._metricFrames/window._metricElapsed+0.5)
                window._metricFrames=0; window._metricElapsed=0
                metaFps.Text="FPS "..tostring(fps)
                local ok,ping=pcall(readPingString)
                metaPing.Text="Ping "..tostring(ok and ping or "--")
            end
        else
            window._metricFrames=0; window._metricElapsed=0
        end
    end)
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        local abs=input.Position
        local sb=searchButton.AbsolutePosition; local ss=searchButton.AbsoluteSize
        local mb=minimize.AbsolutePosition; local ms=minimize.AbsoluteSize
        if (abs.X>=sb.X and abs.X<=sb.X+ss.X and abs.Y>=sb.Y and abs.Y<=sb.Y+ss.Y) or (abs.X>=mb.X and abs.X<=mb.X+ms.X and abs.Y>=mb.Y and abs.Y<=mb.Y+ms.Y) then return end
        local start=main.Position; window.UserDragged=true
        window.Input:BeginDrag(input,start,function(delta)
            window._dragTarget=UDim2.new(start.X.Scale,start.X.Offset+delta.X,start.Y.Scale,start.Y.Offset+delta.Y)
        end,function()
            if window._dragTarget then main.Position=window._dragTarget end
            window._dragTarget=nil
            window:_clampMain()
        end)
    end)

    local logoStart=nil
    floatingLogo.InputBegan:Connect(function(input)
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        logoStart=floatingLogo.Position
        window.Input:BeginDrag(input,logoStart,function(delta)
            floatingLogo.Position=UDim2.fromOffset(logoStart.X.Offset+delta.X,logoStart.Y.Offset+delta.Y); window:_clampLogo()
        end,function(moved)
            if not moved then window:_setVisible(not main.Visible) end
        end)
    end)
    if UserInputService.MouseEnabled then
        floatingLogo.MouseEnter:Connect(function() Tween(logoScale,C.Motion.Fast,{Scale=1.06}) end)
        floatingLogo.MouseLeave:Connect(function() Tween(logoScale,C.Motion.Fast,{Scale=1}) end)
    end

    minimize.MouseButton1Click:Connect(function() window:_setVisible(false) end)
    searchButton.MouseButton1Click:Connect(function() window:OpenSearch() end)
    window._connections[#window._connections+1]=UserInputService.InputBegan:Connect(function(input,processed)
        if processed then return end
        if input.KeyCode==Enum.KeyCode.K and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then window:OpenSearch() end
    end)

    window:_listenLanguage(function()
        if not gui.Parent then return false end
        if not window.ActiveTab then pageTitle.Text=tr("nav.home","Home")
        else pageSubtitle.Text=tostring(window.ActiveTab.Subtitle or window.ActiveTab.GroupTitle or window.ActiveTab.Group or RE4UI.HubName) end
        window:_applyResponsive(false)
        window:RefreshVisibility()
        return true
    end)

    local savedScale=tonumber(RE4UI:GetPreference("uiScale",1)) or 1
    window.CompactDensity=RE4UI:GetPreference("compactDensity",false)==true
    window.ReducedMotion=RE4UI:GetPreference("reducedMotion",false)==true
    mainScale.Scale=math.clamp(savedScale,0.82,1.12)

    local cameraConn=nil
    local function bindCamera()
        if cameraConn then pcall(DisconnectConnection,cameraConn) end
        local camera=Workspace.CurrentCamera
        if camera then cameraConn=camera:GetPropertyChangedSignal("ViewportSize"):Connect(function() window.Overlay:Close(); window:_applyResponsive(false) end) end
    end
    window._connections[#window._connections+1]=Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() bindCamera(); window:_applyResponsive(true) end)
    bindCamera(); window:_applyResponsive(true); window:RefreshVisibility(true)
    gui.Destroying:Connect(function()
        window.Input:Destroy(); window.Overlay:Close(); window:_hideTooltip()
        for _,connection in ipairs(window._connections) do pcall(DisconnectConnection,connection) end
        if cameraConn then pcall(DisconnectConnection,cameraConn) end
        for _,callback in ipairs(window._languageListeners or {}) do LanguageManager:OffChanged(callback) end
        table.clear(window._languageListeners or {})
        LanguageManager:PruneBindings()
        for index=#(RE4UI._Windows or {}),1,-1 do
            if RE4UI._Windows[index]==window then table.remove(RE4UI._Windows,index) end
        end
        if RE4UI.LastWindow==window then RE4UI.LastWindow=nil end
    end)

    window.FeatureRegistry={
        Register=function(_,control,tab,opts) return window:RegisterFeature(control,tab,opts) end,
        Refresh=function() return window:RefreshVisibility() end,
        SetVisibility=function(_,id,condition) return window:SetFeatureVisibility(id,condition) end,
        Get=function(_,id) return window.FeatureById[id] end,
    }
    window.NavigationManager={Refresh=function() return window:_refreshNavigation() end,Show=function(_,tab) return window:ShowTab(tab) end}
    window.LayoutManager={Refresh=function(_,recenter) return window:_applyResponsive(recenter==true) end,Mode=function() return window.Mode end}
    window.LocalizationManager=LanguageManager
    window.NotificationManager={Push=function(_,opts) return window:Notify(opts) end}
    window.PreferenceManager={Get=function(_,key,defaultValue) return RE4UI:GetPreference(key,defaultValue) end,Set=function(_,key,value) return RE4UI:SetPreference(key,value) end}
    window.ThemeManager={
        Current=function() return C.Theme end,
        Fixed=true,
    }

    RE4UI.LastWindow=window
    return window
end

function RE4UI:CreateWindow(options) return self:MakeWindow(options) end
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
function RE4UI.ApplyESPPreset(gui,presetName)
    if not gui then return end; local text=gui:FindFirstChild("TextLabel"); local preset=C.Overlay.ESP.Presets[presetName]
    if text and preset then text.Font=preset.Font; text.TextColor3=preset.Color end
end
function RE4UI.CreateFloatingToggle(name,position,stateVarRef,realVarSetter)
    local playerGui=LocalPlayer:WaitForChild("PlayerGui"); local cfg=C.Overlay.FloatingToggle
    local guiName=tostring(name or "Feature").."MiniToggleGuiS"; local old=playerGui:FindFirstChild(guiName); if old then old:Destroy() end
    local gui=New("ScreenGui",{Name=guiName,ResetOnSpawn=false},playerGui)
    local button=New("TextButton",{Size=UDim2.fromOffset(cfg.Width,cfg.Height),Position=position or cfg.Positions[tostring(name or "")] or UDim2.fromOffset(cfg.Margin,cfg.Margin),BackgroundColor3=T.Control,BorderSizePixel=0,Text="",Font=Enum.Font.GothamBold,TextColor3=T.Text,TextSize=10,AutoButtonColor=false},gui); Corner(button,cfg.Radius); Stroke(button,0.42)
    local dot=New("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,9,0.5,0),Size=UDim2.fromOffset(7,7),BackgroundColor3=T.Bad,BorderSizePixel=0},button); Corner(dot,7)
    local function state() return stateVarRef and stateVarRef.value==true end
    local function render() local on=state(); button.Text=tostring(name or "Feature")..(on and "   ON" or "   OFF"); dot.BackgroundColor3=on and T.Good or T.Bad; button.BackgroundColor3=on and T.AccentFaint or T.Control end
    local dragging=false; local moved=false; local dragStart=nil; local startPos=nil
    button.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; moved=false; dragStart=input.Position; startPos=button.Position end
    end)
    local changeConn=UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart; if math.abs(delta.X)>3 or math.abs(delta.Y)>3 then moved=true end
            local camera=Workspace.CurrentCamera; local viewport=camera and camera.ViewportSize or Vector2.new(900,650)
            local x=math.clamp(startPos.X.Offset+delta.X,4,math.max(4,viewport.X-button.AbsoluteSize.X-4)); local y=math.clamp(startPos.Y.Offset+delta.Y,4,math.max(4,viewport.Y-button.AbsoluteSize.Y-4))
            button.Position=UDim2.fromOffset(x,y)
        end
    end)
    local endConn=UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    button.MouseButton1Click:Connect(function() if moved then moved=false; return end; if stateVarRef then stateVarRef.value=not state() end; SafeCall(tostring(name).."MiniToggle",realVarSetter,state()); render() end)
    gui.Destroying:Connect(function() pcall(function() changeConn:Disconnect() end); pcall(function() endConn:Disconnect() end) end)
    render(); return gui
end

-- ============================================================================
-- Context-aware legacy adapter -> Feature Registry metadata.
-- Legacy gameplay code keeps AddToggle/AddButton/... while visibility becomes data-driven.
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

local function currentSea()
    if RE4UI.CurrentSea and RE4UI.CurrentSea>0 then return RE4UI.CurrentSea end
    local env=RE4ResolveEnvLocal()
    if env.World3 then return 3 elseif env.World2 then return 2 elseif env.World1 then return 1 end
    return 0
end

local function copyOptions(opts)
    local out={}
    if type(opts)=="table" then for k,v in pairs(opts) do out[k]=v end end
    return out
end

local function intersectSeas(a,b)
    if type(a)~="table" then return type(b)=="table" and copyOptions(b) or nil end
    if type(b)~="table" then return copyOptions(a) end
    local out={}
    for _,x in ipairs(a) do
        for _,y in ipairs(b) do if tonumber(x)==tonumber(y) then out[#out+1]=tonumber(x); break end end
    end
    if #out==0 then return {-999} end
    return out
end

-- Framework-level fallbacks stay intentionally empty. Project-specific Sea/feature
-- rules are authoritative in main.lua Feature Registry and are loaded before any Window is built.
local DefaultLegacySeaRules={}
local DefaultSectionSeaRules={}
local DefaultFeatureSeaRules={}

RE4UI.FeatureMetadata = RE4UI.FeatureMetadata or {
    LegacySeaRules=DefaultLegacySeaRules,
    SectionSeaRules=DefaultSectionSeaRules,
    FeatureSeaRules=DefaultFeatureSeaRules,
    SectionLayoutProfiles={},
    Sections={}, Features={}, ItemCatalog={},
}

function RE4UI:ConfigureFeatureMetadata(metadata)
    if type(metadata)~="table" then return false,"metadata must be a table" end
    local configured={
        Version=metadata.Version or metadata.version,
        LegacySeaRules=type(metadata.LegacySeaRules)=="table" and metadata.LegacySeaRules or DefaultLegacySeaRules,
        SectionSeaRules=type(metadata.SectionSeaRules)=="table" and metadata.SectionSeaRules or DefaultSectionSeaRules,
        FeatureSeaRules=type(metadata.FeatureSeaRules)=="table" and metadata.FeatureSeaRules or DefaultFeatureSeaRules,
        SectionLayoutProfiles=type(metadata.SectionLayoutProfiles)=="table" and metadata.SectionLayoutProfiles or {},
        Sections=type(metadata.Sections)=="table" and metadata.Sections or {},
        Features=type(metadata.Features)=="table" and metadata.Features or {},
        ItemCatalog=type(metadata.ItemCatalog)=="table" and metadata.ItemCatalog or {},
        NPCSeaRules=type(metadata.NPCSeaRules)=="table" and metadata.NPCSeaRules or {},
        ProgressionCatalog=type(metadata.ProgressionCatalog)=="table" and metadata.ProgressionCatalog or {},
    }
    self.FeatureMetadata=configured
    return true,configured
end

local function metadataConfig()
    return type(RE4UI.FeatureMetadata)=="table" and RE4UI.FeatureMetadata or {}
end

-- Curated information architecture. These routes intentionally override stale
-- metadata so one legacy source cannot scatter unrelated sections across tabs.
local CuratedLegacyTabRules={Fruits="Items",SeaEvent="World",Mirage="World",Prehistoric="World",Shop="Items",Misc="Settings"}
local CuratedSectionTabRules={
    Main={["unlocked dungeon"]="Raid"},
    Settings={["stats upgrade"]="Progress",["esp"]="Settings"},
    Quests={
        ["tushita and yama"]="Progress",["cursed dual katana"]="Progress",["true triple katana sword"]="Progress",
        ["pole / god enal's"]="Progress",["pole / god enal"]="Progress",["items law / order sword"]="Progress",
        ["east blue misc"]="Progress",["rengoku sword"]="Progress",["cavender + twin hooks + bigmom"]="Progress",
        ["dark dragger + valkyrie"]="Progress",
    },
    Shop={["shop options"]="Items"},
    Misc={["server - function"]="Teleport"},
}
local CuratedSectionDisplayTitles={
    Shop={["shop options"]="Basic Abilities"},
    Misc={
        ["server - function"]="Server Navigation",
        ["player gui / others"]="Interface & Utilities",
        ["graphics / haki stats"]="Graphics & Haki",
        ["configure - god"]="Display & Movement",
    },
}
local function curatedSectionTab(legacy,title)
    legacy=tostring(legacy or "")
    local rules=CuratedSectionTabRules[legacy]
    return (rules and rules[tostring(title or ""):lower()]) or CuratedLegacyTabRules[legacy]
end
local function curatedSectionDisplayTitle(legacy,title)
    local rules=CuratedSectionDisplayTitles[tostring(legacy or "")]
    return rules and rules[tostring(title or ""):lower()] or nil
end

local function resolveSection(legacy,title,defaultKey)
    local source=tostring(title or "")
    local s=source:lower()
    local curated=curatedSectionTab(legacy,source)
    if curated then return curated end
    if legacy=="Info" then return "Home" elseif legacy=="Main" then return "Farm" elseif legacy=="Quests" then return "Progress" elseif legacy=="Raids" then return "Raid"
    elseif legacy=="Fish" or legacy=="Mirage" then return "World" elseif legacy=="SeaEvent" or legacy=="Prehistoric" then return "World"
    elseif legacy=="Fruits" then return "Items" elseif legacy=="Race" or legacy=="Drago" then return "Progress" elseif legacy=="Travel" then return "Teleport" elseif legacy=="Shop" then return "Items" elseif legacy=="Settings" then return "Settings"
    elseif legacy=="Misc" then if s:find("server") then return "Teleport" end; return "Settings" end
    return defaultKey or "Settings"
end

local function sectionSeas(legacy,title)
    local meta=metadataConfig()
    local base=(meta.LegacySeaRules or DefaultLegacySeaRules)[legacy]
    local rules=(meta.SectionSeaRules or DefaultSectionSeaRules)[legacy]
    local specific=rules and rules[tostring(title or ""):lower()] or nil
    local sectionMeta=meta.Sections and meta.Sections[legacy] and meta.Sections[legacy][tostring(title or ""):lower()] or nil
    if type(sectionMeta)=="table" and sectionMeta.Seas then specific=sectionMeta.Seas end
    return intersectSeas(base,specific),sectionMeta
end

local function seaAllowedNow(seas)
    if type(seas)~="table" or #seas==0 then return true end
    local current=tonumber(RE4UI.CurrentSea) or 0
    for _,sea in ipairs(seas) do if tonumber(sea)==current then return true end end
    return false
end

local function nullControl()
    local control={Value=false,Visible=false,Disabled=true,_RE4Null=true}
    local supported={SetValue=true,SetDesc=true,SetDescKey=true,SetStatus=true,SetAvailable=true,SetItems=true,SetOptions=true,RefreshOwnership=true,SetText=true,SetProgress=true,SetVisible=true}
    return setmetatable(control,{__index=function(self,key)
        if key=="SetValue" then return function(_,value) self.Value=value; return self end end
        if supported[key] then return function() return self end end
        return nil
    end})
end

local autoSections={}

-- Large Items source sections are split visually by control name. This changes
-- presentation only: routed controls still receive the exact same options/callbacks.
local ShopSuppressedSourceSections={
    ["weapon world 1"]=true,
    ["accessory seaevent"]=true,
}
local ShopGunNames={
    ["Buy SlingShot"]=true,["Buy Musket"]=true,["Buy Dual Flintlock"]=true,["Buy Flintlock"]=true,["Buy Cannon"]=true,["Buy Kabucha"]=true,
}
local ShopPrimaryCrafts={
    ["Craft DragonHeart"]=true,["Craft DragonStorm"]=true,["Craft Dino Hood"]=true,["Craft Shark Tooth Necklace"]=true,["Craft Terror Jaw"]=true,
}
local function curatedShopControlSection(sourceSection,source)
    local section=tostring(sourceSection or ""):lower()
    source=tostring(source or "")
    if section=="weapon world 1" then
        if ShopGunNames[source] then return {Title="Weapons · Guns",Id="items.weapons.guns",Column="Right",Order=30} end
        return {Title="Weapons · Swords",Id="items.weapons.swords",Column="Left",Order=30}
    elseif section=="accessory seaevent" then
        if ShopPrimaryCrafts[source] then return {Title="Sea Crafting",Id="items.crafting.sea",Column="Left",Order=40} end
        return {Title="Rare Crafting",Id="items.crafting.rare",Column="Right",Order=50}
    elseif section=="fragments shop" and source=="Buy Kabucha" then
        return {Title="Weapons · Guns",Id="items.weapons.guns",Column="Right",Order=30}
    end
    return nil
end

local function curatedCombatControlSection(source)
    source=tostring(source or "")
    if source=="Silent Aim" or source=="Fast Attack" or source=="Bring Mob" or source:find("Attack Range") then
        return {Title="Attack & Targeting",Id="combat.attack_targeting",Column="Left",Order=10}
    end
    if source=="Auto Use Skill Z Buddha" or source=="Auto Turn On Haki" or source=="Auto Turn On V3" or source=="Auto Turn On V4" or source=="Auto Turn On Spin Position" then
        return {Title="Combat Assist",Id="combat.assist",Column="Right",Order=10}
    end
    return nil
end

local function ensureCuratedControlSection(tab,spec,seas)
    if not tab or type(spec)~="table" then return nil end
    tab._curatedControlSections=tab._curatedControlSections or {}
    local id=tostring(spec.Id or spec.Title or "curated")
    local existing=tab._curatedControlSections[id]
    if existing and existing.Frame and IsInstanceAlive(existing.Frame) then tab.CurrentSection=existing; return existing end
    local section=tab:AddSection({Title=spec.Title,Id=id,PreferredColumn=spec.Column,Order=spec.Order,FullWidth=spec.FullWidth==true,__RE4Seas=seas})
    tab._curatedControlSections[id]=section
    tab.CurrentSection=section
    return section
end

local function ensureAutoSection(newTabs,key,title,seas)
    local token=key.."::"..title
    local tab=resolveTabFromMap(newTabs,key)
    local existing=autoSections[token]
    if existing and existing.Frame and IsInstanceAlive(existing.Frame) then
        if tab then tab.CurrentSection=existing end
        return existing
    end
    if not tab then return nil end
    local section=tab:AddSection({Title=title,__RE4Seas=seas})
    autoSections[token]=section
    tab.CurrentSection=section
    return section
end

local function makeLegacyRouter(legacyName,defaultKey,newTabs)
    local metaConfig=metadataConfig()
    local router={LegacyName=legacyName,DefaultKey=defaultKey,CurrentKey=defaultKey,CurrentSeas=(metaConfig.LegacySeaRules or DefaultLegacySeaRules)[legacyName]}
    local function target(self) return resolveTabFromMap(newTabs,self.CurrentKey) or resolveTabFromMap(newTabs,self.DefaultKey) or resolveTabFromMap(newTabs,"Settings") end

    function router:AddSection(section)
        local source=type(section)=="table" and (section.Title or section.Name or section[1]) or section
        self.CurrentSourceSection=source
        self.CurrentVisualSection=nil
        self.CurrentSectionSuppressed=false
        local curatedKey=curatedSectionTab(self.LegacyName,source)
        self.CurrentKey=canonicalTabKey(resolveSection(self.LegacyName,source,self.DefaultKey))
        local sectionMeta
        self.CurrentSeas,sectionMeta=sectionSeas(self.LegacyName,source)
        if not curatedKey and type(sectionMeta)=="table" and type(sectionMeta.Tab)=="string" and resolveTabFromMap(newTabs,sectionMeta.Tab) then self.CurrentKey=canonicalTabKey(sectionMeta.Tab) end
        local opts=type(section)=="table" and copyOptions(section) or {Title=section}
        local displayTitle=curatedSectionDisplayTitle(self.LegacyName,source)
        if displayTitle then opts.Title=displayTitle; opts.TitleKey=nil end
        opts.__RE4Seas=self.CurrentSeas
        if type(sectionMeta)=="table" then
            opts.Id=opts.Id or sectionMeta.Id
            opts.TitleKey=opts.TitleKey or sectionMeta.TitleKey
            opts.Icon=opts.Icon or sectionMeta.Icon
            opts.Order=opts.Order or sectionMeta.Order
            opts.PreferredColumn=opts.PreferredColumn or opts.Column or sectionMeta.PreferredColumn or sectionMeta.Column
            opts.FullWidth=opts.FullWidth==true or sectionMeta.FullWidth==true or tonumber(opts.Span or sectionMeta.Span)==2
            opts.Span=opts.Span or sectionMeta.Span
            opts.VisibilityCondition=opts.VisibilityCondition or sectionMeta.VisibilityCondition
        end
        opts.Id=opts.Id or ("section."..tostring(self.LegacyName).."."..tostring(source or "general")):lower():gsub("[^%w%.]+","_")
        if not seaAllowedNow(self.CurrentSeas) then
            self.CurrentSectionSkipped=true
            self.CurrentVisualSection=nil
            return nullControl()
        end
        self.CurrentSectionSkipped=false
        if self.LegacyName=="Shop" and ShopSuppressedSourceSections[tostring(source or ""):lower()] then
            self.CurrentSectionSuppressed=true
            return nullControl()
        end
        local created=target(self):AddSection(opts)
        self.CurrentVisualSection=created
        return created
    end

    for _,method in ipairs({"AddParagraph","AddToggle","AddButton","AddDropdown","AddSlider","AddTextBox","AddInput","AddStatus","AddProgress","AddInfoList","AddDiscordInvite"}) do
        router[method]=function(self,opts)
            -- If the owning legacy section is unavailable in the current Sea, do
            -- not let a child control fall through into the previous visible section.
            if self.CurrentSectionSkipped then return nullControl() end
            local source=type(opts)=="table" and (opts.Name or opts.Title) or ""
            local config=metadataConfig()
            local featureMeta=config.Features and config.Features[tostring(source or "")] or nil
            local itemMeta=config.ItemCatalog and config.ItemCatalog[tostring(source or "")] or nil
            local featureRules=(config.FeatureSeaRules or DefaultFeatureSeaRules)[tostring(source or "")]
            if type(itemMeta)=="table" and itemMeta.Seas then featureRules=itemMeta.Seas end
            if type(featureMeta)=="table" and featureMeta.Seas then featureRules=featureMeta.Seas end
            local seas=intersectSeas(self.CurrentSeas,featureRules)
            local routed=type(opts)=="table" and copyOptions(opts) or opts
            if not seaAllowedNow(seas) then return nullControl() end
            if type(routed)=="table" then
                routed.__RE4Seas=seas
                if type(featureMeta)=="table" then
                    routed.Id=routed.Id or featureMeta.Id
                    routed.TitleKey=routed.TitleKey or featureMeta.TitleKey
                    routed.DescriptionKey=routed.DescriptionKey or featureMeta.DescriptionKey
                    routed.Icon=routed.Icon or featureMeta.Icon
                    routed.Order=routed.Order or featureMeta.Order
                    routed.Category=routed.Category or featureMeta.Category
                    routed.VisibilityCondition=routed.VisibilityCondition or featureMeta.VisibilityCondition
                end
                if type(itemMeta)=="table" then
                    routed.ItemMetadata=itemMeta
                    local parts={}
                    local seaText=type(itemMeta.Seas)=="table" and (#itemMeta.Seas==3 and "Global" or ("Sea "..table.concat(itemMeta.Seas,"/"))) or "Global"
                    parts[#parts+1]=seaText
                    if itemMeta.Price~=nil then parts[#parts+1]=tostring(itemMeta.Price).." "..tostring(itemMeta.Currency or "") end
                    if itemMeta.Source and itemMeta.Source~="" then parts[#parts+1]=tostring(itemMeta.Source) end
                    if itemMeta.Requirement and itemMeta.Requirement~="" and itemMeta.Requirement~="None" then parts[#parts+1]=tostring(itemMeta.Requirement) end
                    local concise=table.concat(parts," / ")
                    if itemMeta.Note and itemMeta.Note~="" then concise=concise..(concise~="" and " / " or "")..tostring(itemMeta.Note) end
                    routed.Description=concise~="" and concise or routed.Description
                    routed.DescriptionKey=nil
                end
                routed.Id=routed.Id or (tostring(self.LegacyName).."."..tostring(source or method)):lower():gsub("[^%w%.]+","_")
            end
            local visualTab=target(self)
            if self.LegacyName=="Shop" then
                local visualSpec=curatedShopControlSection(self.CurrentSourceSection,source)
                if visualSpec then
                    ensureCuratedControlSection(visualTab,visualSpec,seas)
                    return visualTab and visualTab[method](visualTab,routed) or nullControl()
                elseif self.CurrentVisualSection and visualTab then
                    visualTab.CurrentSection=self.CurrentVisualSection
                end
            elseif self.CurrentVisualSection and visualTab then
                visualTab.CurrentSection=self.CurrentVisualSection
            end

            local combatSupport = source=="Silent Aim" or source=="Fast Attack" or source=="Bring Mob" or source=="Auto Use Skill Z Buddha" or source=="Auto Turn On Haki" or source=="Auto Turn On V3" or source=="Auto Turn On V4" or source=="Auto Turn On Spin Position" or tostring(source):find("Attack Range")
            if combatSupport then
                local tab=resolveTabFromMap(newTabs,"Combat")
                local visualSpec=curatedCombatControlSection(source)
                if visualSpec then ensureCuratedControlSection(tab,visualSpec,seas) else ensureAutoSection(newTabs,"Combat","Combat Assist",seas) end
                return tab and tab[method](tab,routed) or nullControl()
            elseif self.LegacyName=="Settings" and (source=="Auto Hop [Every 30 Minutes]" or source=="Turn On Bypass Teleport") then
                ensureAutoSection(newTabs,"Teleport","Travel Automation",seas)
                local tab=resolveTabFromMap(newTabs,"Teleport"); return tab and tab[method](tab,routed) or nullControl()
            elseif self.LegacyName=="Misc" and (source=="Rejoin Server" or source=="Hop Server" or source=="Hop Server Lowest Player" or source=="Hop Server Lowest Ping" or source=="Hop Server · Lowest Players" or source=="Hop Server · Best Available" or source=="Input Job ID" or source=="Teleport [Job ID]" or source=="Copy Job ID") then
                ensureAutoSection(newTabs,"Teleport","Server Navigation",seas)
                local tab=resolveTabFromMap(newTabs,"Teleport"); return tab and tab[method](tab,routed) or nullControl()
            end
            return visualTab and visualTab[method](visualTab,routed) or nullControl()
        end
    end
    return router
end

function RE4UI:MakeLegacyRouter(legacyName,defaultKey,newTabs)
    return makeLegacyRouter(legacyName,defaultKey,newTabs)
end

function RE4UI:CreateRuntimeBindings(ctx)
    ctx=type(ctx)=="table" and ctx or {}
    local constants=ctx.Constants or {}
    local booleanLease=ctx.BooleanLease
    local bindings={}
    function bindings:AddSimpleToggle(tab,key)
        local spec=constants.SimpleToggles and constants.SimpleToggles[tostring(key)]
        if type(spec)~="table" or not tab then error("[RE4 HUB/UIBinding] missing simple toggle spec: "..tostring(key)) end
        return tab:AddToggle({Name=spec.Name,Description=spec.Description,Default=spec.Default==true,Callback=function(value)
            if spec.Binding=="lease" then booleanLease:SetUser(spec.Flag,value) else _G[spec.Flag]=value end
        end})
    end
    function bindings:_controlSpec(key)
        local spec=constants.UIControls and constants.UIControls[tostring(key)]
        if type(spec)~="table" then error("[RE4 HUB/UIBinding] missing control spec: "..tostring(key)) end
        return spec
    end
    function bindings:AddToggle(tab,key,callback)
        local src=self:_controlSpec(key)
        return tab:AddToggle({Name=src.Name,Description=src.Description,Default=src.Default==true,Callback=callback})
    end
    function bindings:AddButton(tab,key,callback)
        local src=self:_controlSpec(key)
        return tab:AddButton({Name=src.Name,Description=src.Description,Callback=callback})
    end
    return bindings
end

function RE4UI:MountRuntimeSettings(ctx)
    ctx=type(ctx)=="table" and ctx or {}
    local RE4UI=self
    local RE4Tabs,RE4Config,Window=ctx.Tabs,ctx.Config,ctx.Window
    local RE4TeamManager,RE4Constants,plr=ctx.TeamManager,ctx.Constants,ctx.Player
    local RE4TrackSessionConnection=ctx.TrackConnection
    local GetInventorySnapshot,RE4Ownership=ctx.GetInventorySnapshot,ctx.Ownership
    local GetStyleProgress=ctx.GetStyleProgress or function() return nil end
    local RE4Scheduler,RE4ActionManager=ctx.Scheduler,ctx.ActionManager
RE4Tabs.Settings:AddSection({Title = "Interface", TitleKey = "settings.interface", Id = "settings.interface"})
do
local RE4LanguageDisplayToCode = {}
local RE4LanguageCodeToDisplay = {}
local RE4LanguageOptions = {}
local RE4LanguageDefault = "Tiếng Việt"
for _, language in ipairs(RE4UI:GetLanguageOptions()) do
	RE4LanguageDisplayToCode[language.Name] = language.Code
	RE4LanguageCodeToDisplay[language.Code] = language.Name
	RE4LanguageOptions[#RE4LanguageOptions + 1] = language.Name
	if language.Code == RE4UI:GetLanguage() then RE4LanguageDefault = language.Name end
end
local RE4LanguageControl
RE4LanguageControl = RE4Tabs.Settings:AddDropdown({
	Id = "settings.language",
	Name = "Language",
	TitleKey = "settings.language_title",
	Description = "Change the interface language without reloading the Hub.",
	DescriptionKey = "settings.language_desc",
	Options = RE4LanguageOptions,
	LocalizeOptions = false,
	Default = RE4LanguageDefault,
	Callback = function(Value)
		local code = RE4LanguageDisplayToCode[tostring(Value)]
		if code then
			local ok, applied = RE4UI:SetLanguage(code)
			if not ok then
				local fallbackLabel = RE4LanguageCodeToDisplay[applied]
				if fallbackLabel and RE4LanguageControl then task.defer(function() RE4LanguageControl:SetValue(fallbackLabel, false) end) end
				Window:Notify({Title = RE4Config.HubName, ContentKey = "ui.language_load_error", Content = "Language file could not be loaded.", Tone = "error"})
			end
		end
	end,
})
end
RE4Tabs.Settings:AddSlider({
	Id = "settings.ui_scale",
	Name = "UI Scale",
	TitleKey = "settings.scale_title",
	Description = "Scale the interface while preserving adaptive layout.",
	DescriptionKey = "settings.scale_desc",
	Min = 82, Max = 112,
	Default = math.floor((tonumber(RE4UI:GetPreference("uiScale", 1)) or 1) * 100 + 0.5),
	Rounding = 5,
	Callback = function(Value)
		Window:SetScale((tonumber(Value) or 100) / 100)
	end,
})
RE4Tabs.Settings:AddToggle({
	Id = "settings.compact_density",
	Name = "Compact Density",
	TitleKey = "settings.density_title",
	Description = "Reduce spacing on larger screens while preserving touch targets.",
	DescriptionKey = "settings.density_desc",
	Default = RE4UI:GetPreference("compactDensity", false) == true,
	Callback = function(Value) Window:SetCompactDensity(Value) end,
})
RE4Tabs.Settings:AddToggle({
	Id = "settings.reduced_motion",
	Name = "Reduced Motion",
	TitleKey = "settings.motion_title",
	Description = "Shorten transitions for a faster interface.",
	DescriptionKey = "settings.motion_desc",
	Default = RE4UI:GetPreference("reducedMotion", false) == true,
	Callback = function(Value) Window:SetReducedMotion(Value) end,
})
RE4Tabs.Settings:AddButton({
	Id = "settings.search",
	Name = "Search Hub",
	TitleKey = "settings.search_title",
	Description = "Find any visible feature quickly.",
	DescriptionKey = "settings.search_desc",
	ActionText = "Search",
	ActionTextKey = "action.search",
	Callback = function() Window:OpenSearch() end,
})
RE4Tabs.Settings:AddSection({ Title = "Startup & Team", TitleKey = "settings.team_section", Id = "settings.team", })
do
	local preferredTeam = RE4TeamManager:NormalizeTeam(RE4UI:GetPreference("preferredTeam", RE4TeamManager.PreferredTeam or RE4Constants.Teams.Pirates))
	local autoTeamDefault = RE4UI:GetPreference("autoTeam", RE4TeamManager.AutoEnabled ~= false) ~= false
	local teamStatusControl
	local function refreshTeamStatus()
		if not teamStatusControl then return end
		local current = RE4TeamManager:CurrentTeam()
		local teamLabel
		local tone = "waiting"
		if current == RE4Constants.Teams.Pirates then
			teamLabel = RE4UI:T("team.pirates", nil, "Pirates")
			tone = "good"
		elseif current == RE4Constants.Teams.Marines then
			teamLabel = RE4UI:T("team.marines", nil, "Marines")
			tone = "good"
		else
			teamLabel = RE4UI:T("team.not_selected", nil, "Not selected")
		end
		teamStatusControl:SetStatus(
			RE4UI:T("settings.team_status_value", {team = teamLabel}, "Current team: " .. tostring(teamLabel)),
			tone
		)
	end
	RE4Tabs.Settings:AddToggle({
		Id = "settings.auto_team",
		Name = "Auto Select Team",
		TitleKey = "settings.auto_team_title",
		Description = "Automatically select the preferred team when joining before gameplay automation starts.",
		DescriptionKey = "settings.auto_team_desc",
		Default = autoTeamDefault,
		Callback = function(Value)
			local enabled = Value == true
			RE4UI:SetPreference("autoTeam", enabled)
			RE4TeamManager:SetRuntimeConfig(enabled, preferredTeam)
			if enabled and not plr.Team then
				task.spawn(function()
					RE4TeamManager:Select(preferredTeam, {Force = false, AllowFallback = true})
					refreshTeamStatus()
				end)
			end
		end,
	})
	RE4Tabs.Settings:AddDropdown({
		Id = "settings.preferred_team",
		Name = "Preferred Team",
		TitleKey = "settings.preferred_team_title",
		Description = "Choose which side Auto Select Team should use on the next join.",
		DescriptionKey = "settings.preferred_team_desc",
		Options = {RE4Constants.Teams.Pirates, RE4Constants.Teams.Marines},
		OptionLabelKeys = { Pirates = "team.pirates", Marines = "team.marines", },
		Default = preferredTeam,
		Callback = function(Value)
			preferredTeam = RE4TeamManager:NormalizeTeam(Value)
			RE4UI:SetPreference("preferredTeam", preferredTeam)
			RE4TeamManager:SetRuntimeConfig(nil, preferredTeam)
			if RE4UI:GetPreference("autoTeam", true) ~= false and not plr.Team then
				task.spawn(function()
					RE4TeamManager:Select(preferredTeam, {Force = false, AllowFallback = true})
					refreshTeamStatus()
				end)
			end
		end,
	})
	RE4Tabs.Settings:AddButton({
		Id = "settings.apply_team",
		Name = "Apply Team Now",
		TitleKey = "settings.apply_team_title",
		Description = "Try to select the preferred team immediately using remote first, then the executor fallback.",
		DescriptionKey = "settings.apply_team_desc",
		ActionText = "Apply",
		ActionTextKey = "action.apply",
		Callback = function()
			local ok, methodOrError = RE4TeamManager:Select(preferredTeam, {Force = true, AllowFallback = true})
			refreshTeamStatus()
			if ok then
				Window:Notify({
					Id = "team:selected",
					Cooldown = 0.4,
					Title = RE4Config.HubName,
					ContentKey = "notify.team_selected",
					Params = {
						team = RE4UI:T(preferredTeam == RE4Constants.Teams.Marines and "team.marines" or "team.pirates", nil, preferredTeam),
						method = tostring(methodOrError or RE4TeamManager.LastMethod or "remote"),
					},
					Content = "Team selected.",
					Tone = "good",
					Duration = 2.4,
				})
			else
				Window:Notify({
					Id = "team:failed",
					Cooldown = 0.4,
					Title = RE4Config.HubName,
					ContentKey = "notify.team_select_failed",
					Params = {reason = tostring(methodOrError or RE4TeamManager.LastError or "unknown")},
					Content = "Unable to select team.",
					Tone = "error",
					Duration = 3,
				})
			end
		end,
	})
	teamStatusControl = RE4Tabs.Settings:AddStatus({
		Id = "settings.team_status",
		Name = "Team Status",
		TitleKey = "settings.team_status_title",
		Description = "Shows the team currently assigned by the game.",
		DescriptionKey = "settings.team_status_desc",
		Status = "Waiting",
		Tone = "waiting",
	})
	refreshTeamStatus()
	RE4TrackSessionConnection(plr:GetPropertyChangedSignal("Team"):Connect(function()
		task.defer(refreshTeamStatus)
	end))
	RE4UI:OnLanguageChanged(function()
		task.defer(refreshTeamStatus)
	end)
end
RE4Tabs.Settings:AddSection({Title="Runtime Safety",TitleKey="settings.runtime_safety_section",Id="settings.runtime_safety"})
RE4Tabs.Settings:AddButton({
	Id="settings.refresh_progress",
	Name="Refresh Progress Data",
	TitleKey="settings.refresh_progress_title",
	Description="Force-refresh inventory, ownership and fighting-style progression snapshot.",
	DescriptionKey="settings.refresh_progress_desc",
	ActionText="Refresh",
	ActionTextKey="action.refresh",
	Callback=function()
		GetInventorySnapshot(true); RE4Ownership.LastRefresh=0; RE4Ownership.Dirty=true
		local RE4StyleProgress=GetStyleProgress()
        if RE4StyleProgress and RE4StyleProgress.RefreshCompact then
            RE4StyleProgress.RefreshCompact(true)
		else
			GetInventorySnapshot(true); RE4Ownership:RefreshStyleServer(true); RE4Ownership:Refresh(true)
		end
	end,
})
local RE4SafetyStatus=RE4Tabs.Settings:AddStatus({
	Id="settings.runtime_safety_status",
	Name="Runtime Safety Status",
	TitleKey="settings.runtime_safety_status_title",
	Description="Shows action-lock and critical-item protection state.",
	DescriptionKey="settings.runtime_safety_status_desc",
	Status="Ready",Tone="good",
})
RE4Scheduler:Register("ui.runtime_safety",1,function()
	local critical=RE4ActionManager:CriticalItem(true)
	local count=RE4ActionManager:Count()
	if critical then
		RE4SafetyStatus:SetStatus(RE4UI:T("runtime_safety.protected",{item=tostring(critical)},"Protected · "..tostring(critical)),"warn")
	elseif count>0 then
		RE4SafetyStatus:SetStatus(RE4UI:T("runtime_safety.coordinating",{count=count},"Coordinating · "..tostring(count).." lock(s)"),"info")
	else
		RE4SafetyStatus:SetStatus(RE4UI:T("runtime_safety.ready",nil,"Ready"),"good")
	end
end,function()
	return Window and Window.Gui and Window.Gui.Parent~=nil and Window:IsVisible() and Window.ActiveTab==RE4Tabs.Settings
end)
end

function RE4UI:MountHomeDashboard(ctx)
    ctx=type(ctx)=="table" and ctx or {}
    local RE4UI=self
    local Tabs,RE4Tabs,Window=ctx.Tabs,ctx.NewTabs,ctx.Window
    local plr,ply=ctx.Player,ctx.Players
    local RunSer,Stats=ctx.RunService,ctx.Stats
    local RE4TrackSessionConnection,RE4Scheduler=ctx.TrackConnection,ctx.Scheduler
    local RE4Constants,RE4EnemyIndex=ctx.Constants,ctx.EnemyIndex
    local RE4GetEnv=ctx.GetEnv
    local replicated,Lighting=ctx.ReplicatedStorage,ctx.Lighting
    local SafeCommFQuery,RE4HubInfoProvider=ctx.SafeCommFQuery,ctx.HubInfoProvider
    local RE4SafeDisconnect,RE4SetClipboard=ctx.SafeDisconnect,ctx.SetClipboard
    local World1,World2,World3=ctx.World1==true,ctx.World2==true,ctx.World3==true
Tabs.Info:AddSection("Dashboard")
do
	local D={}
	D.HomeOverview=Tabs.Info:AddInfoList({Title="Player Overview",Items={}})
	D.HomeSystem=Tabs.Info:AddInfoList({Title="System Overview",TitleKey="home.system_overview",Items={}})
	D.FpsFrames=0; D.FpsStarted=tick(); D.MeasuredFps=0; D.FpsConnection=nil
	local function RE4HomeFPSFrame() D.FpsFrames=D.FpsFrames+1 end
	function D:StartFPS()
		if self.FpsConnection then return end
		self.FpsFrames=0; self.FpsStarted=tick()
		self.FpsConnection=RunSer.RenderStepped:Connect(RE4HomeFPSFrame)
	end
	function D:StopFPS() if self.FpsConnection then pcall(RE4SafeDisconnect,self.FpsConnection); self.FpsConnection=nil end end
	if RE4Tabs.Home and RE4Tabs.Home.OnShown then RE4Tabs.Home:OnShown(function() D:StartFPS() end) end
	if RE4Tabs.Home and RE4Tabs.Home.OnHidden then RE4Tabs.Home:OnHidden(function() D:StopFPS() end) end
	if ctx.ShutdownRegistry and ctx.ShutdownRegistry.Register then ctx.ShutdownRegistry:Register("home.dashboard",function() D:StopFPS() end) elseif Window and Window.Gui then Window.Gui.Destroying:Connect(function() D:StopFPS() end) end
	if Window and Window.ActiveTab==RE4Tabs.Home and Window:IsVisible() then D:StartFPS() end
	D.Context={Player=plr.Name,Level="-",Sea="-",SeaNumber=World3 and 3 or (World2 and 2 or 1),Race="-",Fruit="-",Weapon="-"}
	D.HomeOverviewItems={
		{Id="player",Label="Player",Value=plr.Name},
		{Id="level",Label="Level",Value="-"},
		{Id="sea",Label="Sea",Value="-"},
		{Id="race",Label="Race",Value="-"},
		{Id="beli",Label="Beli",Value="-"},
		{Id="fragments",Label="Fragments",Value="-"},
		{Id="fruit",Label="Fruit",Value="-"},
		{Id="weapon",Label="Weapon",Value="-"},
		{Id="players",LabelKey="home.players",Label="Players",Value="0"},
	}
	D.HomeSystemItems={
		{Id="fps",LabelKey="home.fps",Label="FPS",Value="0"},
		{Id="ping",LabelKey="home.ping",Label="Ping",Value="N/A"},
		{Id="memory",LabelKey="home.memory",Label="Memory",Value="N/A"},
		{Id="cpu",LabelKey="home.cpu",Label="CPU",Value="N/A"},
		{Id="date",LabelKey="home.date",Label="Date",Value="-"},
		{Id="time",LabelKey="home.time",Label="Time",Value="-"},
		{Id="place",LabelKey="home.place",Label="Place",Value="-"},
		{Id="job",LabelKey="home.job_id",Label="Job ID",Value=tostring(game.JobId or "-")},
		{Id="uptime",LabelKey="home.uptime",Label="Uptime",Value="00:00:00"},
	}
	D.DataValue=function(data,...)
		if not data then return "-" end
		for index=1,select("#",...) do
			local name=select(index,...)
			local obj=data:FindFirstChild(name)
			if obj then return obj.Value end
		end
		return "-"
	end
	D.SeaName=function()
		return World3 and RE4UI:T("sea.third",nil,"Third Sea")
			or (World2 and RE4UI:T("sea.second",nil,"Second Sea")
			or (World1 and RE4UI:T("sea.first",nil,"First Sea") or RE4UI:T("sea.unknown",nil,"Unknown Sea")))
	end
	local function RE4HomeReadPing()
		local item=Stats.Network.ServerStatsItem:FindFirstChild("Data Ping") or Stats.Network.ServerStatsItem["Data Ping"]
		return item and item:GetValueString()
	end
	local function RE4HomeReadMemory() return Stats:GetTotalMemoryUsageMb() end
	D.SafePing=function()
		local ok,value=pcall(RE4HomeReadPing)
		return ok and value or "N/A"
	end
	D.SafeMemory=function()
		local ok,value=pcall(RE4HomeReadMemory)
		return ok and type(value)=="number" and string.format("%.0f MB",value) or "N/A"
	end
	D.Uptime=function()
		local total=math.max(0,math.floor(workspace.DistributedGameTime or 0))
		return string.format("%02d:%02d:%02d",math.floor(total/3600),math.floor(total/60)%60,total%60)
	end
	D.PlayerCount=#ply:GetPlayers()
	RE4TrackSessionConnection(ply.PlayerAdded:Connect(function() D.PlayerCount=D.PlayerCount+1 end))
	RE4TrackSessionConnection(ply.PlayerRemoving:Connect(function() D.PlayerCount=math.max(0,D.PlayerCount-1) end))
	RE4Scheduler:Register("ui.home_dashboard",1,function()
		local data=plr:FindFirstChild("Data")
		local character=plr.Character
		local tool=character and character:FindFirstChildOfClass("Tool")
		local currentSea=D.SeaName()
		local level=D.DataValue(data,"Level")
		local currentRace=D.DataValue(data,"Race")
		local currentFruit=D.DataValue(data,"DevilFruit","Fruit")
		local currentWeapon=tool and tool.Name or RE4UI:T("ui.none",nil,"None")
		D.Context.Player=plr.Name
		D.Context.Level=level
		D.Context.Sea=currentSea
		D.Context.SeaNumber=World3 and 3 or (World2 and 2 or 1)
		D.Context.Race=currentRace
		D.Context.Fruit=currentFruit
		D.Context.Weapon=currentWeapon
		Window:SetContext(D.Context)
		local fpsNow=tick(); local fpsElapsed=fpsNow-(tonumber(D.FpsStarted) or fpsNow)
		if D.FpsConnection and fpsElapsed>0 then D.MeasuredFps=math.floor((tonumber(D.FpsFrames) or 0)/fpsElapsed+0.5); D.FpsFrames=0; D.FpsStarted=fpsNow end
		local overview=D.HomeOverviewItems
		overview[1].Value=plr.Name
		overview[2].Value=level
		overview[3].Value=currentSea
		overview[4].Value=currentRace
		overview[5].Value=D.DataValue(data,"Beli","Money")
		overview[6].Value=D.DataValue(data,"Fragments")
		overview[7].Value=currentFruit
		overview[8].Value=currentWeapon
		overview[9].Value=tostring(D.PlayerCount)
		D.HomeOverview:SetItems(overview)
		local system=D.HomeSystemItems
		system[1].Value=tostring(D.MeasuredFps)
		system[2].Value=D.SafePing()
		system[3].Value=D.SafeMemory()
		system[4].Value="N/A"
		system[5].Value=os.date("%d/%m/%Y")
		system[6].Value=os.date("%H:%M:%S")
		system[7].Value=tostring(game.PlaceId).." · "..currentSea
		system[8].Value=tostring(game.JobId or "-")
		system[9].Value=D.Uptime()
		D.HomeSystem:SetItems(system)
	end,function() return Window and Window.Gui and Window.Gui.Parent~=nil and Window:IsVisible() and Window.ActiveTab==RE4Tabs.Home end)
	Tabs.Info:AddSection({Title="Server Status",TitleKey="server_status.title",Id="home.server_status"})
	D.ServerStatus=Tabs.Info:AddInfoList({Title="Server Status",TitleKey="server_status.title",Items={}})
	D.MoonMap={
		[RE4Constants.MoonAssets.Phase4]="5/5",
		[RE4Constants.MoonAssets.Phase3]="4/5",
		[RE4Constants.MoonAssets.Phase2]="3/5",
		[RE4Constants.MoonAssets.Phase7]="2/5",
		[RE4Constants.MoonAssets.Phase5]="1/5",
	}
	D.Queries={
		Greybeard={"Greybeard"}, Saw={"The Saw"}, Factory={"Core"}, CursedCaptain={"Cursed Captain"}, Darkbeard={"Darkbeard"},
		Elite={"Diablo","Deandre","Urban"}, RipIndra={"rip_indra True Form","rip_indra"}, DoughKing={"Dough King"},
	}
	D.EnemyExistsList=function(wanted)
		local enemies=workspace:FindFirstChild(RE4Constants.Folders.Enemies); if not enemies then return false end
		for model in pairs(RE4EnemyIndex.Set) do
			local hum=model:FindFirstChildWhichIsA("Humanoid")
			if not hum or hum.Health>0 then
				local modelName=tostring(model.Name):lower():gsub("%b[]","")
				for _,name in ipairs(wanted) do
					local targetName=tostring(name):lower()
					if modelName==targetName or modelName:find(targetName,1,true) then return true end
				end
			end
		end
		return false
	end
	D.BossStateList=function(wanted)
		local tracker=rawget(RE4GetEnv(),"RE4BossTracker") or rawget(_G,"RE4BossTracker") or (ctx.GetBossTracker and ctx.GetBossTracker())
		if type(tracker)=="table" and type(tracker.Resolve)=="function" then return tracker:Resolve(wanted) end
		local fallback=D.EnemyExistsList(wanted)
		if fallback then return {State="Spawned",Spawned=true,Alive=true,Known=true,Source="live_fallback"} end
		for _,obj in ipairs(replicated:GetChildren()) do
			if obj:IsA("Model") then
				local modelName=tostring(obj.Name):lower():gsub("%b[]","")
				for _,name in ipairs(wanted) do
					local targetName=tostring(name):lower()
					if modelName==targetName or modelName:find(targetName,1,true) then return {State="Spawned",Spawned=true,Alive=true,Known=true,Source="replicated_fallback"} end
				end
			end
		end
		return {State="NotSpawned",Spawned=false,Alive=false,Known=true,Source="authoritative_absence_fallback"}
	end
	D.BossExistsList=function(wanted)
		local state=D.BossStateList(wanted)
		return state and state.State=="Spawned" or false
	end
	D.BossStatusValue=function(wanted)
		local state=D.BossStateList(wanted)
		if state and state.State=="Spawned" then return RE4UI:T("status.spawned",nil,"Spawned") end
		return RE4UI:T("status.not_spawned",nil,"Not Spawned")
	end
	D.LocationExists=function(name)
		local origin=workspace:FindFirstChild("_WorldOrigin"); local locations=origin and origin:FindFirstChild("Locations")
		return locations and locations:FindFirstChild(name)~=nil or false
	end
	D.StatusValue=function(found)
		return found and RE4UI:T("server_status.present",nil,"Present") or RE4UI:T("server_status.absent",nil,"Absent")
	end
	D.MoonValue=function()
		local sky=Lighting:FindFirstChildOfClass("Sky") or Lighting:FindFirstChild("Sky")
		local id=sky and tostring(sky.MoonTextureId or "") or ""
		return D.MoonMap[id] or "0/5"
	end
	D.ServerRows={}
	D.ServerStatusItems={}
	local function addServerRow(id,labelKey,label)
		local row={Id=id,LabelKey=labelKey,Label=label,Value="-"}
		D.ServerStatusItems[#D.ServerStatusItems+1]=row
		D.ServerRows[id]=row
		return row
	end
	addServerRow("sea","server_status.sea","Sea")
	addServerRow("moon","server_status.moon","Moon")
	if World1 then
		addServerRow("greybeard","server_status.greybeard","Greybeard")
		addServerRow("saw","server_status.saw","The Saw")
	elseif World2 then
		addServerRow("factory","server_status.factory","Factory")
		addServerRow("cursed_captain","server_status.cursed_captain","Cursed Captain")
		addServerRow("darkbeard","server_status.darkbeard","Darkbeard")
	elseif World3 then
		addServerRow("elite","server_status.elite","Elite")
		addServerRow("elite_killed","server_status.elite_killed","Elite Killed")
		addServerRow("rip_indra","server_status.rip_indra","rip_indra")
		addServerRow("dough_king","server_status.dough_king","Dough King")
		addServerRow("mirage","server_status.mirage","Mirage Island")
		addServerRow("kitsune","server_status.kitsune","Kitsune Island")
		addServerRow("prehistoric","server_status.prehistoric","Prehistoric Island")
		addServerRow("frozen","server_status.frozen","Frozen Dimension")
	end
	local function refreshServerStatus()
		if not (Window and Window.Gui and Window.Gui.Parent~=nil and Window:IsVisible() and Window.ActiveTab==RE4Tabs.Home) then return end
		local rows=D.ServerRows
		rows.sea.Value=D.SeaName()
		rows.moon.Value=D.MoonValue()
		if World1 then
			rows.greybeard.Value=D.BossStatusValue(D.Queries.Greybeard)
			rows.saw.Value=D.BossStatusValue(D.Queries.Saw)
		elseif World2 then
			local factory=ctx.GetFactoryState and ctx.GetFactoryState()
	rows.factory.Value=D.StatusValue(factory and factory:Resolve().Active or false)
			rows.cursed_captain.Value=D.BossStatusValue(D.Queries.CursedCaptain)
			rows.darkbeard.Value=D.BossStatusValue(D.Queries.Darkbeard)
		elseif World3 then
			local eliteProgress=SafeCommFQuery("EliteHunter.Progress",3,"EliteHunter","Progress")
			rows.elite.Value=D.BossStatusValue(D.Queries.Elite)
			rows.elite_killed.Value=tostring(eliteProgress or "N/A")
			rows.rip_indra.Value=D.BossStatusValue(D.Queries.RipIndra)
			rows.dough_king.Value=D.BossStatusValue(D.Queries.DoughKing)
			rows.mirage.Value=D.StatusValue(D.LocationExists("Mirage Island"))
			local map=workspace:FindFirstChild("Map")
			rows.kitsune.Value=D.StatusValue(map and map:FindFirstChild("KitsuneIsland")~=nil)
			rows.prehistoric.Value=D.StatusValue(D.LocationExists("Prehistoric Island"))
			rows.frozen.Value=D.StatusValue(D.LocationExists("Frozen Dimension"))
		end
		D.ServerStatus:SetItems(D.ServerStatusItems)
	end
	RE4Scheduler:Register("ui.server_status",3,refreshServerStatus,function()
		return Window and Window.Gui and Window.Gui.Parent~=nil and Window:IsVisible() and Window.ActiveTab==RE4Tabs.Home
	end)
	Tabs.Info:AddSection({Title="Community & Release",TitleKey="home.community_title",Id="home.community"})
	D.HubCommunity=Tabs.Info:AddInfoList({Title="Community & Release",TitleKey="home.community_title",Items={},Columns=1})
	local function copyText(value,successKey,successFallback)
		value=tostring(value or "")
		if value=="" then Window:Notify({Id="home.copy.empty",Cooldown=1,Tone="warn",ContentKey="home.link_unconfigured",Content="Link is not configured.",Duration=2.4}); return false end
		local ok=select(1,RE4SetClipboard(value))
		if not ok then Window:Notify({Id="home.copy.unsupported",Cooldown=1,Tone="warn",ContentKey="home.clipboard_unavailable",Content="Clipboard is unavailable in this executor.",Duration=2.4}); return false end
		Window:Notify({Id="home.copy.ok",Cooldown=0.5,Tone=ok and "good" or "error",ContentKey=ok and successKey or "home.clipboard_unavailable",Content=ok and successFallback or "Clipboard is unavailable in this executor.",Duration=2.4})
		return ok
	end
	Tabs.Info:AddButton({
		Id="home.copy_discord",Name="Copy Discord Invite",TitleKey="home.copy_discord",Description="Copy the official Discord invite loaded from GitHub Raw.",DescriptionKey="home.copy_discord_desc",ActionText="Copy",ActionTextKey="action.copy",
		Callback=function()
			local info=RE4HubInfoProvider:Get(); local discord=type(info.discord)=="table" and info.discord or {}
			copyText(discord.invite,"home.discord_copied","Discord invite copied.")
		end,
	})
	Tabs.Info:AddSection({Title="Latest Updates",TitleKey="home.latest_updates",Id="home.latest_updates",FullWidth=true,Span=2,Order=100})
	D.LatestUpdates=Tabs.Info:AddInfoList({Title="Latest Updates",TitleKey="home.latest_updates",Items={},Columns=1,WrapValues=true})
	function D:RefreshHubRemote()
		local info=RE4HubInfoProvider:Get()
		local discord=type(info.discord)=="table" and info.discord or {}
		local announcement=type(info.announcement)=="table" and info.announcement or {}
		local community={
			{Id="version",LabelKey="home.current_version",Label="Current Version",Value=tostring(RE4HubInfoProvider.DisplayVersion or ("V"..tostring(RE4HubInfoProvider.LocalVersion)))},
			{Id="discord",LabelKey="home.discord",Label="Discord",Value=(discord.enabled and discord.invite~="" and tostring(discord.label or discord.invite)) or RE4UI:T("home.discord_unconfigured",nil,"Not configured")},
		}
		if announcement.enabled==true and tostring(announcement.content or "")~="" then
			community[#community+1]={Id="announcement",LabelKey="home.announcement",Label="Announcement",Value=tostring(announcement.content)}
		end
		D.HubCommunity:SetItems(community,true)
		local rows={}
		for i,item in ipairs(type(info.changelog)=="table" and info.changelog or {}) do
			if i>5 then break end
			local version=tostring(item.version or "-")
			local date=tostring(item.date or "")
			local title=tostring(item.title or "")
			local content=tostring(item.content or "")
			local label="V"..version..(date~="" and (" · "..date) or "")
			local value=(title~="" and (title..(content~="" and " — " or "")) or "")..content
			rows[#rows+1]={Id="change."..tostring(i),Label=label,Value=value~="" and value or "-"}
		end
		D.LatestUpdates:SetItems(rows,true)
	end
	D:RefreshHubRemote()
	RE4HubInfoProvider:OnLoaded(function() if D.HubCommunity and D.LatestUpdates then D:RefreshHubRemote() end end)
	RE4UI:OnLanguageChanged(function() if D.HubCommunity and D.LatestUpdates then D:RefreshHubRemote() end end)
end
    return refreshServerStatus
end

function RE4UI:MountOwnershipSummary(ctx)
    ctx=type(ctx)=="table" and ctx or {}
    local RE4UI=self
    local Tabs,RE4Tabs,Window=ctx.Tabs,ctx.NewTabs,ctx.Window
    local RE4GetEnv=ctx.GetEnv
    local RE4InventoryCache,RE4OwnershipResolver=ctx.InventoryCache,ctx.OwnershipResolver
    local World1,World2,World3=ctx.World1==true,ctx.World2==true,ctx.World3==true
  local Summary={Controls={},LastSignature=nil}
  RE4GetEnv().RE4ItemsSummary=Summary
  local function currentSea() return World3 and 3 or (World2 and 2 or 1) end
  local function seaAllowed(meta)
	if type(meta)~="table" or type(meta.Seas)~="table" then return true end
	local sea=currentSea()
	for _,allowedSea in ipairs(meta.Seas) do if tonumber(allowedSea)==sea then return true end end
	return false
  end
  local function ownershipRows(wantOwned)
	if RE4InventoryCache.WeaponValid~=true then return {{RE4UI:T("items_summary.data",nil,"Inventory"),RE4UI:T("items_summary.waiting",nil,"Waiting for weapon snapshot")}} end
	local metadata=RE4GetEnv().RE4_FEATURE_METADATA
	local catalog=type(metadata)=="table" and metadata.ItemCatalog or nil
	local rows,used={},{}
	if type(catalog)=="table" then
	  for action,meta in pairs(catalog) do
		local itemType=type(meta)=="table" and tostring(meta.Type or "") or ""
		if seaAllowed(meta) and (itemType=="Sword" or itemType=="Gun" or itemType=="Accessory") then
		  local name=tostring(meta.Name or action)
		  local state=RE4OwnershipResolver:ResolveState(name,false)
		  local owned=state and state.Owned==true
		  local key=RE4InventoryCache:Normalize(name)
		  if owned==wantOwned and key~="" and not used[key] then used[key]=true; rows[#rows+1]={name,itemType} end
		end
	  end
	end
	table.sort(rows,function(a,b) return tostring(a[1]):lower()<tostring(b[1]):lower() end)
	if #rows==0 then return {{RE4UI:T("items_summary.items",nil,"Items"),RE4UI:T("ui.none",nil,"None")}} end
	return rows
  end
  local function signature(rows)
	local out={}
	for _,group in ipairs(rows) do
	  for _,row in ipairs(group) do out[#out+1]=tostring(row[1]).."="..tostring(row[2]) end
	  out[#out+1]="|"
	end
	return table.concat(out,";")
  end
  function Summary:IsVisible() return Window and Window.Gui and Window.Gui.Parent~=nil and Window:IsVisible() and Window.ActiveTab==RE4Tabs.Items end
  function Summary:Refresh(force)
	local owned=ownershipRows(true)
	local missing=ownershipRows(false)
	local sig=signature({owned,missing})
	if force~=true and sig==self.LastSignature then return end
	self.LastSignature=sig
	self.Controls.Owned:SetItems(owned)
	self.Controls.Missing:SetItems(missing)
  end
  Tabs.Shop:AddSection({Title="Ownership Status",Id="items.ownership"})
  Summary.Controls.Owned=Tabs.Shop:AddInfoList({Title="Owned Items",TitleKey="items_summary.owned",Items={}})
  Summary.Controls.Missing=Tabs.Shop:AddInfoList({Title="Not Owned Items",TitleKey="items_summary.not_owned",Items={}})
  RE4UI:OnLanguageChanged(function() if Summary:IsVisible() then Summary:Refresh(true) end end)
  if Summary:IsVisible() then Summary:Refresh(true) end
end



-- Runtime presentation modules. These own visual state only; gameplay state is supplied by context/getters.
function RE4UI:MountESP(ctx)
    ctx=type(ctx)=="table" and ctx or {}
    local Tabs,Scheduler=ctx.Tabs,ctx.Scheduler
    local Players=game:GetService("Players")
    local LocalPlayer=Players.LocalPlayer
    local CollectionService=game:GetService("CollectionService")
    local ESPPlayer,DevilFruitESP,IslandESP=false,false,false
    _G.ChestESP=false
    local number=math.random(1,1000000)
    local function round(v) return math.floor((tonumber(v) or 0)+0.5) end
    local function updateIsland()
        local origin=Workspace:FindFirstChild("_WorldOrigin")
        local locations=origin and origin:FindFirstChild("Locations")
        if not locations then return end
        for _,island in pairs(locations:GetChildren()) do pcall(function()
            if IslandESP and island.Name~="Sea" then
                if not island:FindFirstChild("NameEsp") then self.CreateESPBillboard(island,"NameEsp","Island")
                else island.NameEsp.TextLabel.Text=island.Name.."\n"..round((LocalPlayer.Character.Head.Position-island.Position).Magnitude/3).."m" end
            elseif island:FindFirstChild("NameEsp") then island.NameEsp:Destroy() end
        end) end
    end
    local function updatePlayers()
        for _,player in pairs(Players:GetPlayers()) do pcall(function()
            if player~=LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head=player.Character.Head; local guiName="NameEsp"..number
                if not ESPPlayer then if head:FindFirstChild(guiName) then head[guiName]:Destroy() end
                elseif not head:FindFirstChild(guiName) then self.CreateESPBillboard(head,guiName,(player.Team==LocalPlayer.Team) and "PlayerAlly" or "PlayerEnemy")
                else head[guiName].TextLabel.Text=player.Name.." | "..round((LocalPlayer.Character.Head.Position-head.Position).Magnitude/3).."m\nHP: "..round(player.Character.Humanoid.Health*100/player.Character.Humanoid.MaxHealth).."%" end
            end
        end) end
    end
    local function updateChest()
        for _,chest in pairs(CollectionService:GetTagged("_ChestTagged")) do pcall(function()
            if _G.ChestESP and not chest:GetAttribute("IsDisabled") then
                if not chest:FindFirstChild("ChestEsp") then self.CreateESPBillboard(chest,"ChestEsp","Chest")
                else chest.ChestEsp.TextLabel.Text="Chest\n"..round((LocalPlayer.Character.Head.Position-chest:GetPivot().Position).Magnitude/3).."m" end
            elseif chest:FindFirstChild("ChestEsp") then chest.ChestEsp:Destroy() end
        end) end
    end
    local function updateFruit()
        for _,fruit in pairs(Workspace:GetChildren()) do pcall(function()
            if DevilFruitESP and string.find(fruit.Name,"Fruit") and fruit:FindFirstChild("Handle") then
                local handle=fruit.Handle; local guiName="NameEsp"..number
                if not handle:FindFirstChild(guiName) then self.CreateESPBillboard(handle,guiName,"Fruit")
                else handle[guiName].TextLabel.Text=fruit.Name.."\n"..round((LocalPlayer.Character.Head.Position-handle.Position).Magnitude/3).."m" end
            elseif fruit:FindFirstChild("Handle") and fruit.Handle:FindFirstChild("NameEsp"..number) then fruit.Handle["NameEsp"..number]:Destroy() end
        end) end
    end
    Scheduler:Register("ui.esp",0.5,function()
        if ESPPlayer then updatePlayers() end; if _G.ChestESP then updateChest() end; if DevilFruitESP then updateFruit() end; if IslandESP then updateIsland() end
    end,function() return ESPPlayer or _G.ChestESP or DevilFruitESP or IslandESP end)
    Tabs.Settings:AddSection("ESP")
    Tabs.Settings:AddToggle({Name="Esp Player",Default=false,Callback=function(v) ESPPlayer=v; if not v then updatePlayers() end end})
    Tabs.Settings:AddToggle({Name="Esp Chest",Default=false,Callback=function(v) _G.ChestESP=v; if not v then updateChest() end end})
    Tabs.Settings:AddToggle({Name="Esp Fruit",Default=false,Callback=function(v) DevilFruitESP=v; if not v then updateFruit() end end})
    Tabs.Settings:AddToggle({Name="Esp Island",Default=false,Callback=function(v) IslandESP=v; if not v then updateIsland() end end})
end

function RE4UI:MountRuntimeMonitors(ctx)
    local Scheduler,Window,Constants,Ownership,Config=ctx.Scheduler,ctx.Window,ctx.Constants,ctx.Ownership,ctx.Config
    Scheduler:Register("ui.runtime_footer",0.75,function()
        local key,params,pct,tone="runtime.ready",nil,nil,"good"
        if _G.Raiding then key,tone="runtime.running_raid","running"
        elseif _G.Level then
            local targetName=tostring((ctx.GetFarmTarget and ctx.GetFarmTarget()) or "Auto Farm Level")
            key,params,tone="runtime.running_target",{target=self:TL(targetName)},"running"
            local enemies=Workspace:FindFirstChild(Constants.Folders.Enemies); local mob=enemies and enemies:FindFirstChild(targetName); local hum=mob and mob:FindFirstChildOfClass("Humanoid")
            if hum and hum.MaxHealth>0 then pct=(hum.Health/hum.MaxHealth)*100 end
        elseif _G.AutoFarmNear then key,tone="runtime.nearest","running"
        elseif _G.AutoDoughKing then key,tone="runtime.dough_king","running"
        elseif _G.Auto_Cake_Prince then key,tone="runtime.cake_prince","running"
        else local pulse=ctx.GetCombatPulse and ctx.GetCombatPulse(); if _G.Seriality and pulse and pulse:IsActive() then key,tone="runtime.fast_attack","info" end end
        Window:SetRuntimeStatusKey(key,params,pct,tone)
    end,function() return Window and Window.Gui and Window.Gui.Parent~=nil and Window:IsVisible() end)
    Scheduler:Register("ownership.controls",1,function()
        Ownership:UpdateControls(); local summary=ctx.GetEnv().RE4ItemsSummary; if summary and summary.IsVisible and summary:IsVisible() and summary.Refresh then summary:Refresh(false) end
    end,function() return Ownership.Dirty==true or tick()-(tonumber(Ownership.LastControlUpdate) or 0)>=Config.Runtime.Ownership.ControlSafetyInterval end)
end

local function re4StatusVisible(ctx) return ctx.Window and ctx.Window:IsVisible() and ctx.Window.ActiveTab==ctx.ActiveTab end
function RE4UI:MountCDKStatus(ctx)
    local view=ctx.Tab:AddParagraph({Title=" Number Cursed Dual Katana Quest ",Content="Quest Numbers :"})
    ctx.Scheduler:Register("ui.quest.cdk_status",0.5,function()
        local y1,y2,y3,t1,t2=ctx.GetState()
        if y1==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Yama quest 1")},"Quest: Yama quest 1")
        elseif y2==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Yama quest 2")},"Quest: Yama quest 2")
        elseif y3==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Yama quest 3")},"Quest: Yama quest 3")
        elseif t1==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Tushita quest 1")},"Quest: Tushita quest 1")
        elseif t2==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Tushita quest 2")},"Quest: Tushita quest 2")
        elseif t1==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Tushita quest 2")},"Quest: Tushita quest 2")
        elseif ctx.IsDone() then view:SetDescKey("dynamic.quest_number",{value=self:TL("CDK done!!")},"Quest: CDK done!!") end
    end,function() return re4StatusVisible(ctx) end)
end
function RE4UI:MountSoulGuitarStatus(ctx)
    local view=ctx.Tab:AddParagraph({Title="Get Quest Soul Guitar",Content=""})
    ctx.Scheduler:Register("ui.sea.soul_guitar_status",0.5,function() pcall(function()
        local q1,q2,q3,q4=ctx.GetState()
        if q1==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Quest1")},"Quest: Quest1")
        elseif q2==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Quest2")},"Quest: Quest2")
        elseif q3==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Quest3")},"Quest: Quest3")
        elseif q4==true then view:SetDescKey("dynamic.quest_number",{value=self:TL("Quest4")},"Quest: Quest4")
        elseif ctx.IsDone() then view:SetDescKey("dynamic.quest_number",{value=self:TL("Collect!!")},"Quest: Collect!!")
        else view:SetDescKey("dynamic.quest_number",{value=self:TL("No Quest!!")},"Quest: No Quest!!") end
    end) end,function() return re4StatusVisible(ctx) end)
end
function RE4UI:MountRaceTierStatus(ctx)
    local view=ctx.Tab:AddParagraph({Title="Tier V4",Content=""})
    ctx.Scheduler:Register("ui.race.tier_status",0.5,function() pcall(function() view:SetDescKey("dynamic.tier_v4",{value=ctx.Player.Data.Race.C.Value},"V4 Tier: "..tostring(ctx.Player.Data.Race.C.Value)) end) end,function() return re4StatusVisible(ctx) end)
end
function RE4UI:MountPrehistoricStatus(ctx)
    local view=ctx.Tab:AddParagraph({Title=" Prehistoric Island Status",Content=""})
    ctx.Scheduler:Register("ui.sea.prehistoric_status",0.5,function()
        local origin=Workspace:FindFirstChild("_WorldOrigin"); local locations=origin and origin:FindFirstChild("Locations"); local map=Workspace:FindFirstChild("Map")
        local found=(map and map:FindFirstChild("PrehistoricIsland")) or (locations and locations:FindFirstChild("Prehistoric Island"))
        view:SetDescKey("dynamic.boolean_found",{name=self:TL("Prehistoric Island"),value=self:T(found and "ui.yes" or "ui.no",nil,found and "Yes" or "No")},"Prehistoric Island: "..((found~=nil) and "True" or "False"))
    end,function() return re4StatusVisible(ctx) end)
end
function RE4UI:MountLeviathanSpyStatus(ctx)
    local view=ctx.Tab:AddParagraph({Title="Spy Status",Content=""})
    ctx.Scheduler:Register("ui.sea.spy_status",1.5,function()
        if ctx.World3 then pcall(function() local raw=ctx.SafeCommF("InfoLeviathan.Status","InfoLeviathan","1"); local value=raw and string.match(tostring(raw),"%d+"); if value then view:SetDescKey("dynamic.spy",{value=value},"Leviathan Spy: "..tostring(value)); if tonumber(value)==5 then view:SetDescKey("dynamic.spy",{value=self:TL("Already Done!!")},"Leviathan Spy: Already Done!!") end end end) end
    end,function() return ctx.World3 and re4StatusVisible(ctx) end)
end
function RE4UI:MountFrozenDimensionStatus(ctx)
    local view=ctx.Tab:AddParagraph({Title="Frozen Dimension status",Content=""})
    ctx.Scheduler:Register("ui.sea.frozen_status",1.0,function()
        if ctx.World3 then local origin=Workspace:FindFirstChild("_WorldOrigin"); local locations=origin and origin:FindFirstChild("Locations"); local found=locations and locations:FindFirstChild("Frozen Dimension")~=nil; view:SetDescKey("dynamic.boolean_found",{name=self:TL("Frozen Dimension"),value=self:T(found and "ui.yes" or "ui.no",nil,found and "Yes" or "No")},"Frozen Dimension: "..tostring(found)) end
    end,function() return ctx.World3 and re4StatusVisible(ctx) end)
end
function RE4UI:MountKitsuneStatus(ctx)
    local view=ctx.Tab:AddParagraph({Title=" Kitsune Island Status",Content=""})
    ctx.Scheduler:Register("ui.sea.kitsune_status",0.5,function()
        local map=Workspace:FindFirstChild("Map"); local origin=Workspace:FindFirstChild("_WorldOrigin"); local locations=origin and origin:FindFirstChild("Locations"); local found=(map and map:FindFirstChild("KitsuneIsland")) or (locations and locations:FindFirstChild("Kitsune Island"))
        view:SetDescKey("dynamic.boolean_found",{name=self:TL("Kitsune Island"),value=self:T(found and "ui.yes" or "ui.no",nil,found and "Yes" or "No")},"Kitsune Island: "..((found~=nil) and "True" or "False"))
    end,function() return re4StatusVisible(ctx) end)
end
function RE4UI:MountRaidProgress(ctx)
    local view=ctx.Tab:AddProgress({Title="Raid Progress",Value=0,Max=5})
    ctx.Scheduler:Register("ui.raid.progress",0.5,function()
        local runtime=ctx.GetRuntime and ctx.GetRuntime()
        if ctx.InRaid() then
            if _G.Raiding~=true then view:SetProgress(0,5,"Status: Raid active · Auto Raid off")
            else local island=runtime and runtime.Session and tonumber(runtime.Session.CurrentIndex) or tonumber(ctx.GetCurrentIsland and ctx.GetCurrentIsland()) or 0
                if island>=1 and island<=5 then view:SetProgress(island,5,"Status: Island "..tostring(island).." / 5 · "..tostring(runtime and runtime.State or "ACTIVE")) else view:SetProgress(0,5,"Status: "..tostring(runtime and runtime.State or "WAITING_FOR_SESSION")) end end
        else
            local state=runtime and tostring(runtime.State or "IDLE") or "IDLE"; local snap=runtime and runtime.Snapshot and runtime:Snapshot() or nil
            if state=="FINALIZING_NATIVE" then local reward=snap and snap.RewardObserved and "reward✓" or "reward…"; local returned=snap and snap.NativeReturnObserved and "return✓" or "return…"; view:SetProgress(5,5,"Status: Finalizing native · "..reward.." · "..returned)
            elseif state=="CYCLE_BLOCKED" then view:SetProgress(0,5,"Status: Cycle blocked · "..tostring(snap and snap.CycleBlockedReason or runtime.LastReason or "verification_failed"))
            else view:SetProgress(0,5,"Status: Waiting for raid") end
        end
    end,function() return re4StatusVisible(ctx) end)
end

function RE4UI:MountMirageMoonStatus(ctx)
    local moonView=ctx.Tab:AddParagraph({Title=" FullMoon Status ",Content=""})
    local mirageView=ctx.Tab:AddParagraph({Title=" Mirage Island Status ",Content=""})
    ctx.Scheduler:Register("ui.sea.mirage_status",0.5,function()
        local locations=ctx.GetLocations and ctx.GetLocations(); local found=(ctx.GetIsland and ctx.GetIsland()) or (locations and locations:FindFirstChild("Mirage Island"))
        mirageView:SetDescKey("dynamic.boolean_found",{name=self:TL("Mirage Island"),value=self:T(found and "ui.yes" or "ui.no",nil,found and "Yes" or "No")},"Mirage Island: "..((found~=nil) and "True" or "False"))
    end,function() return re4StatusVisible(ctx) end)
    ctx.Scheduler:Register("ui.sea.moon_status",0.5,function() pcall(function()
        local assets=ctx.Constants.MoonAssets; local moon=ctx.GetMoon and ctx.GetMoon()
        local value,extra,fallbackExtra
        if moon==assets.Phase0 then value="0 / 8"
        elseif moon==assets.Phase1 then value="1 / 8"
        elseif moon==assets.Phase2 then value="2 / 8"
        elseif moon==assets.Phase3 then value="3 / 8"; extra=self:T("ui.next_night",nil,"Next Night"); fallbackExtra="Next Night"
        elseif moon==assets.Phase4 then value="4 / 8"; extra=self:T("ui.full_moon",nil,"Full Moon"); fallbackExtra="Full Moon"
        elseif moon==assets.Phase5 then value="5 / 8"; extra=self:T("ui.last_night",nil,"Last Night"); fallbackExtra="Last Night"
        elseif moon==assets.Phase6 then value="6 / 8"
        elseif moon==assets.Phase7 then value="7 / 8" end
        if value then moonView:SetDescKey("dynamic.moon",{value=value..(extra and (" · "..extra) or "")},"Moon: "..value..(fallbackExtra and (" ["..fallbackExtra.."]") or "")) end
    end) end,function() return re4StatusVisible(ctx) end)
end

function RE4UI:CreateTeleportDirectory(ctx)
  ctx=type(ctx)=="table" and ctx or {}
  local RE4Constants=assert(ctx.Constants,"TeleportDirectory requires Constants")
  local replicated=ctx.ReplicatedStorage
  local Players=game:GetService("Players")
  local LocalPlayer=Players.LocalPlayer
  local GetFeatureMetadata=type(ctx.GetFeatureMetadata)=="function" and ctx.GetFeatureMetadata or function() return nil end
  local GetSea=type(ctx.GetSea)=="function" and ctx.GetSea or function() return 0 end
local RE4TeleportDirectory={Active=false,Connections={},NPCEntries={},NPCLabels={},RefreshQueued=false,PlayerDropdown=nil,NPCDropdown=nil}
function RE4TeleportDirectory:_disconnect()
  for _,connection in ipairs(self.Connections) do pcall(function() connection:Disconnect() end) end
  self.Connections={}
end
function RE4TeleportDirectory:_connect(signal,callback)
  if not signal then return nil end
  local connection=signal:Connect(callback); self.Connections[#self.Connections+1]=connection; return connection
end
function RE4TeleportDirectory:_root(model)
  if not model then return nil end
  if model:IsA("BasePart") then return model end
  if not model:IsA("Model") then return nil end
  return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
end
function RE4TeleportDirectory:_sea() return tonumber(GetSea()) or 0 end
function RE4TeleportDirectory:_cleanName(name) return tostring(name or ""):gsub("^%s+",""):gsub("%s+$","") end
function RE4TeleportDirectory:_allowed(name)
  local metadata=GetFeatureMetadata()
  local rules=metadata and metadata.NPCSeaRules
  local clean=self:_cleanName(name)
  local allowed=rules and (rules[clean] or rules[tostring(name or "")])
  if type(allowed)~="table" then return true end
  local sea=self:_sea()
  for _,value in ipairs(allowed) do if tonumber(value)==sea then return true end end
  return false
end
function RE4TeleportDirectory:_scanNPCs()
  local grouped={}
  local function bucket(name)
	local clean=self:_cleanName(name)
	if clean=="" or not self:_allowed(clean) then return nil end
	grouped[clean]=grouped[clean] or {Name=clean,Templates={},Live={}}
	return grouped[clean]
  end
  local templates=replicated and replicated:FindFirstChild(RE4Constants.Folders.NPCs)
  if templates then for _,obj in ipairs(templates:GetChildren()) do if obj:IsA("Model") then local b=bucket(obj.Name); if b then b.Templates[#b.Templates+1]=obj end end end end
  local folder=workspace:FindFirstChild(RE4Constants.Folders.NPCs)
  if folder then
	for _,obj in ipairs(folder:GetDescendants()) do
	  if obj:IsA("Model") then
		local root=self:_root(obj); local hum=obj:FindFirstChildWhichIsA("Humanoid")
		if root and root:IsA("BasePart") and (not hum or hum.Health>0) then local b=bucket(obj.Name); if b then b.Live[#b.Live+1]=obj end end
	  end
	end
  end
  self.NPCEntries={}; self.NPCLabels={}
  local names={}; for name in pairs(grouped) do names[#names+1]=name end
  table.sort(names,function(a,b) return a:lower()<b:lower() end)
  for _,name in ipairs(names) do
	local b=grouped[name]
	local template=b.Templates[1]
	local templateRoot=self:_root(template)
	local fallback=templateRoot and templateRoot.CFrame or nil
	table.sort(b.Live,function(a,bm)
	  local ar,br=self:_root(a),self:_root(bm)
	  if fallback and ar and br then
		local ad=(ar.Position-fallback.Position).Magnitude
		local bd=(br.Position-fallback.Position).Magnitude
		if ad~=bd then return ad<bd end
	  end
	  local ap=ar and ar.Position or Vector3.zero; local bp=br and br.Position or Vector3.zero
	  if ap.X~=bp.X then return ap.X<bp.X elseif ap.Y~=bp.Y then return ap.Y<bp.Y else return ap.Z<bp.Z end
	end)
	local primary=b.Live[1] or template
	local primaryRoot=self:_root(primary)
	self.NPCEntries[name]={Name=name,Model=primary,Root=primaryRoot,Template=template,Fallback=fallback,Index=1}
	self.NPCLabels[#self.NPCLabels+1]=name
	if #b.Live>1 then
	  for i,model in ipairs(b.Live) do
		local root=self:_root(model)
		local p=root and root.Position or Vector3.zero
		local label=string.format("%s · #%d · %.0f, %.0f, %.0f",name,i,p.X,p.Y,p.Z)
		self.NPCEntries[label]={Name=name,Model=model,Root=root,Template=template,Fallback=fallback,Index=i}
		self.NPCLabels[#self.NPCLabels+1]=label
	  end
	end
  end
end
function RE4TeleportDirectory:_players()
  local list={}
  for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then list[#list+1]=player.Name end end
  table.sort(list,function(a,b) return a:lower()<b:lower() end); return list
end
function RE4TeleportDirectory:Refresh()
  if not self.Active then return end
  self.RefreshQueued=false; self:_scanNPCs()
  if self.NPCDropdown and self.NPCDropdown.SetOptions then
	self.NPCDropdown:SetOptions(self.NPCLabels,true)
	if _G.SelectedNPC and not self.NPCEntries[_G.SelectedNPC] then _G.SelectedNPC=nil; pcall(function() self.NPCDropdown:SetValue(nil,false) end) end
  end
  if self.PlayerDropdown and self.PlayerDropdown.SetOptions then
	local players=self:_players(); self.PlayerDropdown:SetOptions(players,true)
	if _G.PlayersList and not Players:FindFirstChild(_G.PlayersList) then _G.PlayersList=nil; _G.TargetPlayerAim=nil; pcall(function() self.PlayerDropdown:SetValue(nil,false) end) end
  end
end
function RE4TeleportDirectory:QueueRefresh()
  if not self.Active or self.RefreshQueued then return end
  self.RefreshQueued=true
  task.defer(function() if self.Active then self:Refresh() else self.RefreshQueued=false end end)
end
function RE4TeleportDirectory:Start()
  if self.Active then self:Refresh(); return end
  self.Active=true; self:_disconnect()
  local folder=workspace:FindFirstChild(RE4Constants.Folders.NPCs)
  if folder then self:_connect(folder.DescendantAdded,function() self:QueueRefresh() end); self:_connect(folder.DescendantRemoving,function() self:QueueRefresh() end) end
  local templates=replicated and replicated:FindFirstChild(RE4Constants.Folders.NPCs)
  if templates then self:_connect(templates.ChildAdded,function() self:QueueRefresh() end); self:_connect(templates.ChildRemoved,function() self:QueueRefresh() end) end
  self:_connect(workspace.ChildAdded,function(child) if child.Name==RE4Constants.Folders.NPCs then self:Stop(); self:Start() end end)
  self:_connect(workspace.ChildRemoved,function(child) if child.Name==RE4Constants.Folders.NPCs then self:QueueRefresh() end end)
  self:_connect(Players.PlayerAdded,function() self:QueueRefresh() end); self:_connect(Players.PlayerRemoving,function() self:QueueRefresh() end)
  self:Refresh()
end
function RE4TeleportDirectory:Stop() self.Active=false; self.RefreshQueued=false; self:_disconnect() end
function RE4TeleportDirectory:ResolveNPC(label)
  local wanted=tostring(label or "")
  local entry=self.NPCEntries[wanted]
  if not entry then self:_scanNPCs(); entry=self.NPCEntries[wanted] end
  if not entry then return nil end
  local root=self:_root(entry.Model)
  if entry.Model and entry.Model.Parent and root and root.Parent then entry.Root=root; return entry end
  local folder=workspace:FindFirstChild(RE4Constants.Folders.NPCs); local candidates={}
  if folder then
	for _,obj in ipairs(folder:GetDescendants()) do
	  if obj:IsA("Model") and self:_cleanName(obj.Name)==entry.Name then
		local r=self:_root(obj); local hum=obj:FindFirstChildWhichIsA("Humanoid")
		if r and (not hum or hum.Health>0) then candidates[#candidates+1]={Model=obj,Root=r} end
	  end
	end
  end
  if #candidates>0 then
	local fallback=entry.Fallback
	table.sort(candidates,function(a,b)
	  if fallback then return (a.Root.Position-fallback.Position).Magnitude<(b.Root.Position-fallback.Position).Magnitude end
	  return a.Root.Position.X<b.Root.Position.X
	end)
	entry.Model=candidates[1].Model; entry.Root=candidates[1].Root
  else
	local templateRoot=self:_root(entry.Template)
	entry.Model=entry.Template; entry.Root=templateRoot
	if templateRoot then entry.Fallback=templateRoot.CFrame end
  end
  return entry
end
  return RE4TeleportDirectory
end

return RE4UI

--[[
RE4 HUB · CENTRAL RUNTIME CONFIG
Single source for runtime-tunable values. Application identity is read
from metadata.lua; deployment URLs/paths belong to main.lua Source Registry.
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
if type(Metadata)~="table" or tonumber(Metadata.Schema)~=1 then
    error("[RE4 HUB/Config] metadata.lua is required")
end

return {
    Schema = 1,
    Metadata = Metadata,
    HubName = Metadata.HubName,
    Version = Metadata.Version,
    Revision = Metadata.Revision,
    BuildName = Metadata.BuildName,
    DisplayVersion = Metadata.DisplayVersion,
    ReleaseStamp = Metadata.ConfigStamp,

    Runtime = {
        LegacyStep = 0.10,
        Scheduler = {
            TickRate = 0.04,
            MinInterval = 0.03,
            DefaultInterval = 0.10,
        },
        FeatureRuntime = {
            WaitSliceMin = 0.01,
            WaitSliceMax = 0.10,
        },
        MovementCoordinator = {
            TickInterval = 0.04,
        },
        ManagedLegacy = {
            RetryDelay = 0.75,
            SafetyInterval = 0.50,
        },
        Watchdog = {
            Interval = 2.0,
        },
        ActionManager = {
            DefaultTTL = 12.0,
        },
        QueryCache = {
            DefaultTTL = 1.0,
        },
        Cache = {
            DefaultTTL = 5.0,
            MaterialTTL = 2.5,
            WeaponTTL = 6.0,
            LegacyTTL = 2.5,
            BonesTTL = 1.5,
            InventoryFruitsTTL = 6.0,
            FruitsTTL = 15.0,
            UnlockablesTTL = 6.0,
        },
        CombatPulse = {
            TTL = 0.45,
            MinTTL = 0.15,
        },
        SpinPosition = {
            MinTTL = 0.25,
            DefaultTTL = 0.75,
            RefreshTTL = 0.65,
            SchedulerInterval = 0.20,
        },
        KillAura = {
            Interval = 2.0,
        },
        MovementSupport = {
            SafetyInterval = 0.50,
            RefreshInterval = 0.05,
        },
        Ownership = {
            RefreshInterval = 5.0,
            StyleRefreshInterval = 120.0,
            ControlSafetyInterval = 15.0,
        },
        ServerHop = {
            CheckInterval = 1.0,
            AutoHopInterval = 1800.0,
        },
        Raid = {
            -- RaidTimer is a UI signal, not authoritative completion. This short
            -- grace only absorbs HUD handoff/flicker before native finalization.
            EndUiGrace = 0.85,
            -- Bounded observation window for reward + native server relocation.
            -- No forced success/teleport is performed when reward is unconfirmed.
            NativeFinalizeTimeout = 12.0,
            ChipConfirmTimeout = 3.0,
            LawChipConfirmTimeout = 3.0,
            LawStartConfirmTimeout = 8.0,
            ChipWorkerSafetyInterval = 15.0,
            BasicChipBeliCost = 100000,
            AdvancedChipFragmentCost = 1000,
            -- This cooldown is scheduled only after a Beli purchase that this runtime
            -- actually confirmed; ambiguous transactions are fail-closed, never retried.
            BeliCooldown = 7200.0,
        },
    },

    Movement = {
        TweenSpeed = 200,
        Bring = {
            -- Conservative Bring envelope limits cross-floor/cross-room followers on compact vertical maps.
            -- Cadence, MaxMob and movement mechanics remain unchanged.
            Range = 350,
            Speed = 300,
            MinRange = 20,
            FollowerDistance = 200,
        },
        CombatTargetLock = {
            StaleTTL = 1.35,
            BringInterval = 0.12,
            RefillInterval = 0.25,
        },
        TravelResolver = {
            ArrivalRadius = 10,
            LocalDirectDistance = 900,
            SpecialTimeout = 12,
            MaxTweenTimeout = 220,
            PortalVerifyTimeout = 1.75,
            RecoveryWindow = 0.85,
            RootProgressEpsilon = 0.8,
            BlockProgressEpsilon = 0.35,
        },
        ManualTravel = {
            Priority = 70,
            UpdateInterval = 0.08,
            ArrivalRadius = 8,
        },
        FastTravel = {
            TweenSpeed = 200,
            EntranceOverhead = 0.55,
            MinTimeGain = 0.85,
            GlobalCooldown = 0,
            SamePortalCooldown = 0,
            AttemptDebounce = 0,
            ArrivalRadius = 650,
            VerifyTimeout = 1.35,
            VerifyStep = 0.05,
            MinObservedMove = 120,
            MinObservedGain = 80,
        },
    },

    Combat = {
        TargetCacheInterval = 0.12,
        SilentAim = {
            PredictionAmount = 0.10,
            MaxRange = 1000,
        },
        AttackSpeedModes = {
            ["Normal Attack"] = 0.25,
            ["Fast Attack"] = 0.15,
            ["Super Fast Attack"] = 0.05,
            ["Aura Attack"] = 0.10,
        },
        DefaultAttackSpeedMode = "Fast Attack",
        FastAttack = {
            AttackDistance = 65,
            BuddhaDistance = 999,
            AttackCooldown = 0.01,
            ComboResetTime = 0.30,
            MaxCombo = 4,
            ConfigRefreshInterval = 0.20,
        },
        PvP = {
            EnableRetryInterval = 1.25,
            EnableConfirmTimeout = 2.50,
            EnableConfirmStep = 0.08,
            TemporaryBlacklistTTL = 0.75,
            PvPDisabledBlacklistTTL = 4.0,
            ProtectionBlacklistTTL = 2.5,
            NoDamageBlacklistTTL = 4.0,
            NoDamageTimeout = 3.25,
            DamageProbeRange = 32,
            DamageEpsilon = 0.05,
            MinAttackWindows = 14,
        },
    },

    Fruit = {
        CollectStepInterval = 0.10,
        CollectRetryInterval = 0.25,
        IdleScanInterval = 0.40,
    },

    Fishing = {
        StepInterval = 0.10,
        RodRequestInterval = 1.00,
        RodEquipConfirmTimeout = 1.00,
        BaitActionInterval = 0.80,
        BaitSelectConfirmTimeout = 1.25,
        BaitLowStockThreshold = 2,
        BaitTargetStock = 10,
        BaitMaxStack = 99,
        BaitMaxCraftBatchesPerCycle = 3,
        CraftSettleDelay = 0.20,
        CraftConfirmTimeout = 1.60,
        CraftConfirmStep = 0.40,
        CraftFailureRetryDelay = 2.50,
        CastChargeDelay = 0.70,
        CastConfirmTimeout = 1.50,
        CastRetryDelay = 0.35,
        CatchStartDelay = 0.25,
        CatchPulseInterval = 0.08,
        CatchTimeout = 15.0,
        QuestIdleInterval = 0.35,
    },

    Localization = {
        Default = "vi",
        Fallback = "en",
        ManifestDelay = 2.0,
        Languages = {
            vi = "Tiếng Việt",
            en = "English",
            th = "ไทย",
            id = "Bahasa Indonesia",
        },
    },

    Release = {
        UIStamp = Metadata.UIStamp,
        HubInfoSchema = 1,
        UpdatedAt = Metadata.UpdatedAt,
    },
}

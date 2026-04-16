Config = {}

-- ============================================================================
-- General Settings
-- ============================================================================
Config.Debug = false
Config.Locale = 'en'

---@type 'auto' | 'qb' | 'qbox' | 'esx' | 'ox'
Config.Framework = 'auto'

---@type 'auto' | 'ox_target' | 'qb-target' | 'qtarget' | 'interact'
Config.Target = 'auto'

-- ============================================================================
-- Loop / Lap Settings
-- ============================================================================
Config.Loop = {
    maxLaps = 5,              -- Maximum number of laps a player can select (1-10)
    bonusMultiplier = 0.5,    -- Extra completion bonus per additional lap (0.5 = +50% per lap)
}

-- ============================================================================
-- Time-Based Demand System
-- ============================================================================
Config.TimeDemand = {
    enabled = true,

    -- Time periods with their modifiers
    -- passengerMultiplier: multiplied with stop's minNPC/maxNPC
    -- tipMultiplier: multiplied with tip chance
    -- fareMultiplier: multiplied with calculated fare
    -- eventWeightOverride: optional table to override specific event weights
    periods = {
        -- Morning rush hour (7:00 - 9:00)
        {
            name = 'morningRush',
            startHour = 7,
            endHour = 9,
            passengerMultiplier = 2.0,   -- Double passengers
            tipMultiplier = 1.5,         -- +50% tip chance
            fareMultiplier = 1.0,        -- Normal fare
            eventWeightOverride = nil,
        },
        -- Daytime (9:00 - 17:00)
        {
            name = 'daytime',
            startHour = 9,
            endHour = 17,
            passengerMultiplier = 1.0,   -- Normal
            tipMultiplier = 1.0,         -- Normal
            fareMultiplier = 1.0,        -- Normal
            eventWeightOverride = nil,
        },
        -- Evening rush hour (17:00 - 19:00)
        {
            name = 'eveningRush',
            startHour = 17,
            endHour = 19,
            passengerMultiplier = 2.0,   -- Double passengers
            tipMultiplier = 1.5,         -- +50% tip chance
            fareMultiplier = 1.0,        -- Normal fare
            eventWeightOverride = nil,
        },
        -- Evening (19:00 - 22:00)
        {
            name = 'evening',
            startHour = 19,
            endHour = 22,
            passengerMultiplier = 1.2,   -- Slightly more
            tipMultiplier = 1.2,         -- Slightly more tips
            fareMultiplier = 1.0,        -- Normal fare
            eventWeightOverride = {
                vipPickup = 35,          -- More VIPs in the evening
            },
        },
        -- Late night (22:00 - 2:00)
        {
            name = 'lateNight',
            startHour = 22,
            endHour = 2,
            passengerMultiplier = 0.5,   -- Half passengers
            tipMultiplier = 1.8,         -- Higher tips (grateful riders)
            fareMultiplier = 1.3,        -- Night surcharge built in
            eventWeightOverride = {
                drunkPassenger = 50,     -- More drunks at night
                vipPickup = 30,          -- VIPs going home
            },
        },
        -- Early morning (2:00 - 7:00)
        {
            name = 'earlyMorning',
            startHour = 2,
            endHour = 7,
            passengerMultiplier = 0.3,   -- Very few passengers
            tipMultiplier = 2.0,         -- Very grateful riders
            fareMultiplier = 1.3,        -- Night surcharge
            eventWeightOverride = nil,
        },
    },

    -- Weekend modifiers (applied ON TOP of time period multipliers)
    weekend = {
        enabled = true,
        days = { 0, 6 },                -- 0 = Sunday, 6 = Saturday (GTA day of week)
        passengerMultiplier = 0.8,       -- Slightly fewer commuters
        tipMultiplier = 1.3,             -- Tourists tip more
        vipWeightBonus = 15,             -- Extra weight added to vipPickup events
    },
}

-- ============================================================================
-- Daily Challenges System
-- ============================================================================
Config.DailyChallenges = {
    enabled = true,
    count = 3,               -- Number of challenges given per day
    resetHour = 6,           -- Hour (0-23) when daily challenges reset (server time)

    -- Challenge pool — server picks 'count' random challenges each day
    -- Types: 'trips', 'passengers', 'earnings', 'perfectRating', 'laps'
    pool = {
        -- Trip-based
        { type = 'trips',          target = 3,    reward = 150,  icon = 'fa-route',       difficulty = 'easy' },
        { type = 'trips',          target = 5,    reward = 300,  icon = 'fa-route',       difficulty = 'medium' },
        { type = 'trips',          target = 8,    reward = 500,  icon = 'fa-route',       difficulty = 'hard' },

        -- Passenger-based
        { type = 'passengers',     target = 15,   reward = 100,  icon = 'fa-users',       difficulty = 'easy' },
        { type = 'passengers',     target = 30,   reward = 250,  icon = 'fa-users',       difficulty = 'medium' },
        { type = 'passengers',     target = 50,   reward = 450,  icon = 'fa-users',       difficulty = 'hard' },

        -- Earnings-based
        { type = 'earnings',       target = 500,  reward = 200,  icon = 'fa-dollar-sign', difficulty = 'easy' },
        { type = 'earnings',       target = 1500, reward = 400,  icon = 'fa-dollar-sign', difficulty = 'medium' },
        { type = 'earnings',       target = 3000, reward = 700,  icon = 'fa-dollar-sign', difficulty = 'hard' },

        -- Perfect rating (complete N routes with 5-star rating)
        { type = 'perfectRating',  target = 1,    reward = 250,  icon = 'fa-star',        difficulty = 'medium' },
        { type = 'perfectRating',  target = 3,    reward = 600,  icon = 'fa-star',        difficulty = 'hard' },

        -- Lap-based (complete N total laps)
        { type = 'laps',           target = 5,    reward = 150,  icon = 'fa-repeat',      difficulty = 'easy' },
        { type = 'laps',           target = 10,   reward = 350,  icon = 'fa-repeat',      difficulty = 'medium' },
        { type = 'laps',           target = 20,   reward = 600,  icon = 'fa-repeat',      difficulty = 'hard' },
    },
}

-- ============================================================================
-- Bus Condition Management
-- ============================================================================
Config.BusCondition = {
    enabled = true,

    -- Fuel system
    fuel = {
        enabled = true,
        startLevel = 100.0,          -- Starting fuel % when bus is spawned
        consumptionRate = 0.02,      -- Fuel % consumed per second while moving
        idleRate = 0.004,            -- Fuel % consumed per second while idle (engine on)
        warningThreshold = 25.0,     -- Show yellow warning below this %
        criticalThreshold = 10.0,    -- Show red critical warning below this %
        refuelCostPerPercent = 3,    -- $ per 1% fuel to refuel at depot
    },

    -- Vehicle condition (combined engine + body health)
    condition = {
        enabled = true,
        warningThreshold = 40.0,     -- Show yellow warning below this %
        criticalThreshold = 20.0,    -- Show red warning + speed penalty below this %
        speedPenalty = 0.6,          -- Speed multiplier when engine health critical (0.6 = 40% reduction)
        repairCostPerPercent = 8,    -- $ per 1% to repair at depot
    },

    -- Auto repair/refuel when returning bus to depot (cost deducted)
    repairAtDepot = true,
}

-- ============================================================================
-- Driving Rating System
-- ============================================================================
Config.DrivingRating = {
    enabled = true,
    startScore = 100,         -- Starting score (max 100)

    -- Penalty events and their score deductions
    penalties = {
        hardBrake = {
            enabled = true,
            deduction = 5,          -- Score lost per hard brake
            speedThreshold = 30,    -- Min speed (km/h) to count as hard braking
            decelThreshold = 15,    -- Speed drop (km/h) per check to count as hard brake
            cooldown = 3000,        -- ms cooldown between hard brake detections
        },
        collision = {
            enabled = true,
            deduction = 10,         -- Score lost per collision
            cooldown = 5000,        -- ms cooldown between collision detections
        },
        speeding = {
            enabled = true,
            deduction = 2,          -- Score lost per speeding tick
            speedLimit = 80,        -- Speed limit in km/h
            interval = 5000,        -- How often speeding is checked (ms)
        },
        runRedLight = {
            enabled = true,
            deduction = 15,         -- Score lost per red light
            cooldown = 10000,       -- ms cooldown
        },
    },

    -- Star rating thresholds (score → stars)
    stars = {
        { min = 90, stars = 5, label = 'Excellent' },
        { min = 75, stars = 4, label = 'Good' },
        { min = 55, stars = 3, label = 'Average' },
        { min = 35, stars = 2, label = 'Poor' },
        { min = 0,  stars = 1, label = 'Terrible' },
    },

    -- Bonus/penalty based on rating
    tipBonus = {
        [5] = 2.0,   -- 5 stars: tip chance doubled
        [4] = 1.5,   -- 4 stars: +50% tip chance
        [3] = 1.0,   -- 3 stars: normal
        [2] = 0.5,   -- 2 stars: halved
        [1] = 0.0,   -- 1 star: no tips
    },
    completionBonusMultiplier = {
        [5] = 1.25,  -- 5 stars: +25% completion bonus
        [4] = 1.1,   -- 4 stars: +10%
        [3] = 1.0,   -- 3 stars: normal
        [2] = 0.8,   -- 2 stars: -20%
        [1] = 0.5,   -- 1 star: -50%
    },
}

-- ============================================================================
-- Commands & Keybinds
-- ============================================================================
Config.Commands = {
    openRoutes = {
        name = 'busloop',
        description = 'Open route selection (while in bus)',
        key = 'F7',
    },
    cancelRoute = {
        name = 'buscancel',
        description = 'Cancel current route',
        key = '',
    },
}

-- ============================================================================
-- Bus Depot (Garage Location)
-- ============================================================================
Config.Depot = {
    -- Depot center
    coords = vector3(463.84, -576.1, 28.5),

    -- Blip
    blip = {
        enabled = true,
        sprite = 513,
        color = 47,
        scale = 0.8,
        label = 'Bus Depot',
    },

    -- Where buses spawn
    busSpawnPoint = vector4(462.95, -605.85, 28.5, 213.18),

    -- Parking zone (return bus here after route)
    parkingZone = {
        coords = vector3(462.95, -605.85, 28.5),
        radius = 10.0,
    },

    -- NPCs at the depot
    npcs = {
        -- Bus dispatch NPC
        dispatch = {
            model = 's_m_y_airworker',
            coords = vector4(458.08, -596.84, 28.5, 235.08),
            scenario = 'WORLD_HUMAN_STAND_MOBILE',
            label = 'Bus Dispatch',
            icon = 'fas fa-bus',
        },
    },
}

-- ============================================================================
-- Available Buses
-- ============================================================================
Config.Buses = {
    {
        model = 'bus',
        label = 'City Bus',
        localeKey = 'labels.bus_city',
        maxPassengers = 15,
        requiredLevel = 1,
    },
    {
        model = 'airbus',
        label = 'Airport Shuttle',
        localeKey = 'labels.bus_airport',
        maxPassengers = 20,
        requiredLevel = 2,
    },
    {
        model = 'coach',
        label = 'Luxury Coach',
        localeKey = 'labels.bus_luxury',
        maxPassengers = 25,
        requiredLevel = 3,
    },
}

-- ============================================================================
-- Player Level System (saved to JSON)
-- ============================================================================
Config.Levels = {
    [1] = { name = 'Newcomer',    localeKey = 'labels.level_newcomer',    requiredTrips = 0,   bonus = 0 },
    [2] = { name = 'Growing',     localeKey = 'labels.level_growing',     requiredTrips = 50,  bonus = 5 },
    [3] = { name = 'Established', localeKey = 'labels.level_established', requiredTrips = 150, bonus = 10 },
    [4] = { name = 'Major',       localeKey = 'labels.level_major',       requiredTrips = 400, bonus = 15 },
    [5] = { name = 'Premium',     localeKey = 'labels.level_premium',     requiredTrips = 1000, bonus = 20 },
}

-- ============================================================================
-- Fare System
-- ============================================================================
Config.Fare = {
    baseFare = 3,
    zoneExtraFare = 1,
    nightSurcharge = 30,
    nightStart = 22,
    nightEnd = 6,
    studentDiscount = 30,
    elderlyDiscount = 50,
}

-- ============================================================================
-- Payment System (1st Person)
-- ============================================================================
Config.Payment = {
    cardChance = 40,
    cashExactChance = 25,
    cashOverpayChance = 30,
    cashUnderpayChance = 5,
    cardProcessTime = 1500,
    cardFailChance = 5,
    denominations = { 20, 10, 5, 1 },
    changeTimeLimit = 15,
    tipChance = 20,
    tipMin = 1,
    tipMax = 3,
    cameraTransitionTime = 800,
    cameraOffset = vector3(0.0, 0.5, 0.7),
}

-- ============================================================================
-- Route System
-- Routes are selectable bus loops. Bus stop locations are defined in bus.lua.
-- All routes listed here will appear in the Dashboard for selection.
-- ============================================================================
Config.Routes = {
    [1] = {
        id = 1,
        name = 'Loop #1',
        description = 'Custom route',
        color = '#3b82f6',
        requiredLevel = 1,
        basePay = 50,
        completionBonus = 100,
        estimatedTime = 15,
        stops = {
            { id = 1,  name = 'Bus Stop #3',      coords = vector4(308.71, -762.10, 29.24, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 2,  name = 'Bus Stop #5',      coords = vector4(262.23, -1124.56, 29.21, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 3,  name = 'Bus Stop #1',      coords = vector4(-272.29, -826.78, 31.70, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 4,  name = 'Bus Stop #4',      coords = vector4(-499.96, 20.90, 44.76, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 5,  name = 'Bus Stop #8',      coords = vector4(-690.06, -5.56, 38.18, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 6,  name = 'Bus Stop #9',      coords = vector4(-930.80, -126.50, 37.57, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 7,  name = 'Bus Stop #14',     coords = vector4(-684.00, -374.94, 34.19, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 8,  name = 'Bus Stop #2',      coords = vector4(-243.87, -710.24, 33.44, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 9,  name = 'Bus Stop #2',      coords = vector4(-253.09, -882.32, 30.66, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 10, name = 'Bus Stop #4',      coords = vector4(352.11, -1064.15, 29.40, 0.00), waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
        },
    },
    [2] = {
        id = 2,
        name = 'Loop #2',
        description = 'Custom route',
        color = '#8791a0',
        requiredLevel = 1,
        basePay = 50,
        completionBonus = 100,
        estimatedTime = 15,
        stops = {
            { id = 1,  name = 'Bus Stop #1',      coords = vector4(770.13, -935.98, 25.54, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 2,  name = 'Bus Stop #2',      coords = vector4(788.24, -1364.99, 26.44, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 3,  name = 'Bus Stop #3',      coords = vector4(825.64, -1634.54, 30.53, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 4,  name = 'Bus Stop #4',      coords = vector4(-105.45, -1684.01, 29.20, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 5,  name = 'Bus Stop #5',      coords = vector4(50.05, -1537.32, 29.19, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 6,  name = 'Bus Stop #6',      coords = vector4(359.04, -1785.44, 28.92, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 7,  name = 'Bus Stop #7',      coords = vector4(436.96, -2027.34, 23.31, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 8,  name = 'Bus Stop #8',      coords = vector4(-147.85, -2045.19, 22.95, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 9,  name = 'Bus Stop #9',      coords = vector4(768.75, -1751.52, 29.38, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 10, name = 'Bus Stop #6',      coords = vector4(807.31, -1357.20, 26.31, 0.00), waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 11, name = 'Bus Stop #8',      coords = vector4(785.38, -781.06, 26.33, 0.00), waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
        },
    },
    [3] = {
        id = 3,
        name = 'Loop #3',
        description = 'Custom route',
        color = '#7094cf',
        requiredLevel = 1,
        basePay = 50,
        completionBonus = 100,
        estimatedTime = 15,
        stops = {
            { id = 1,  name = 'Bus Stop #1',      coords = vector4(-708.19, -827.38, 23.45, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 2,  name = 'Bus Stop #2',      coords = vector4(-740.44, -755.26, 26.46, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 3,  name = 'Bus Stop #10',     coords = vector4(-1165.57, -400.93, 35.49, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 4,  name = 'Bus Stop #13',     coords = vector4(-1406.51, -567.28, 30.22, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 5,  name = 'Bus Stop #18',     coords = vector4(-153.77, 6209.21, 31.19, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 6,  name = 'Bus Stop #19',     coords = vector4(-212.45, 6175.96, 31.22, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 7,  name = 'Bus Stop #15',     coords = vector4(-1480.71, -634.76, 30.36, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 8,  name = 'Bus Stop #14',     coords = vector4(-684.00, -374.94, 34.19, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 9,  name = 'Bus Stop #15',     coords = vector4(-563.67, -846.34, 27.04, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
        },
    },
    [4] = {
        id = 4,
        name = 'Loop #4',
        description = 'Custom route',
        color = '#ec4899',
        requiredLevel = 1,
        basePay = 50,
        completionBonus = 100,
        estimatedTime = 15,
        stops = {
            { id = 1,  name = 'Bus Stop #8',      coords = vector4(-139.66, -1975.67, 22.81, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 2,  name = 'Bus Stop #11',     coords = vector4(-708.19, -827.38, 23.45, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 3,  name = 'Bus Stop #17',     coords = vector4(-1213.40, -1213.86, 7.59, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 4,  name = 'Bus Stop #16',     coords = vector4(-1171.51, -1466.63, 4.28, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 5,  name = 'Bus Stop #15',     coords = vector4(-1480.71, -634.76, 30.36, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 6,  name = 'Bus Stop #13',     coords = vector4(-1406.51, -567.28, 30.22, 0.00),  waitTime = 10, minNPC = 0, maxNPC = 3, zone = 3 },
            { id = 7,  name = 'Bus Stop #11',     coords = vector4(-1426.65, -89.70, 52.06, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 8,  name = 'Bus Stop #13',     coords = vector4(-643.60, -143.64, 37.70, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
            { id = 9,  name = 'Bus Stop #2',      coords = vector4(-243.87, -710.24, 33.44, 0.00),  waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 10, name = 'Bus Stop #2',      coords = vector4(-253.09, -882.32, 30.66, 0.00), waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 11, name = 'Bus Stop #4',      coords = vector4(352.11, -1064.15, 29.40, 0.00), waitTime = 10, minNPC = 1, maxNPC = 5, zone = 1 },
            { id = 12, name = 'Bus Stop #6',      coords = vector4(-147.85, -2045.19, 22.95, 0.00), waitTime = 10, minNPC = 1, maxNPC = 4, zone = 2 },
        },
    },
}

-- ============================================================================
-- NPC Settings
-- ============================================================================
Config.NPC = {
    types = {
        { type = 'normal',   chance = 50, fareMultiplier = 1.0 },
        { type = 'student',  chance = 20, fareMultiplier = 0.7 },
        { type = 'elderly',  chance = 15, fareMultiplier = 0.5 },
        { type = 'tourist',  chance = 10, fareMultiplier = 1.2 },
        { type = 'vip',      chance = 5,  fareMultiplier = 1.5 },
    },
    models = {
        'a_f_m_bevhills_01', 'a_f_m_bevhills_02', 'a_f_m_bodybuild_01',
        'a_f_m_business_02', 'a_f_m_downtown_01', 'a_f_m_eastsa_01',
        'a_f_m_eastsa_02', 'a_f_m_fatbla_01', 'a_f_m_ktown_01',
        'a_f_m_ktown_02', 'a_f_m_skidrow_01', 'a_f_m_soucent_01',
        'a_f_m_soucent_02', 'a_f_m_tourist_01', 'a_f_y_bevhills_01',
        'a_f_y_bevhills_02', 'a_f_y_bevhills_04', 'a_f_y_business_01',
        'a_f_y_business_04', 'a_f_y_eastsa_03', 'a_f_y_fitness_01',
        'a_f_y_fitness_02', 'a_f_y_hipster_01', 'a_f_y_hipster_02',
        'a_f_y_tourist_01', 'a_f_y_tourist_02', 'a_m_m_afriamer_01',
        'a_m_m_beach_01', 'a_m_m_bevhills_01', 'a_m_m_bevhills_02',
        'a_m_m_business_01', 'a_m_m_eastsa_01', 'a_m_m_eastsa_02',
        'a_m_m_farmer_01', 'a_m_m_fatlatin_01', 'a_m_m_malibu_01',
        'a_m_m_og_boss_01', 'a_m_m_soucent_01', 'a_m_m_soucent_03',
        'a_m_m_stlat_02', 'a_m_y_bevhills_01', 'a_m_y_bevhills_02',
        'a_m_y_business_01', 'a_m_y_business_03', 'a_m_y_downtown_01',
        'a_m_y_eastsa_01', 'a_m_y_eastsa_02', 'a_m_y_hipster_01',
        'a_m_y_hipster_02', 'a_m_y_ktown_01', 'a_m_y_latino_01',
    },
    studentModels = {
        'a_f_y_hipster_01', 'a_f_y_hipster_02',
        'a_m_y_hipster_01', 'a_m_y_hipster_02',
        'a_f_y_bevhills_01', 'a_m_y_bevhills_01',
    },
    elderlyModels = {
        'a_f_o_genstreet_01', 'a_f_o_salton_01', 'a_f_o_soucent_01',
        'a_m_o_beach_01', 'a_m_o_genstreet_01', 'a_m_o_salton_01',
        'a_m_o_soucent_01', 'a_m_o_tramp_01',
    },
    boardingTime = 3000,
    alightingTime = 2000,
    maxWaitAtStop = 30,
    minRideStops = 1,
    maxRideStops = 4,
}

-- ============================================================================
-- NPC Speech (Speech bubbles during payment)
-- ============================================================================
Config.NpcSpeech = {
    card = {
        'Card, please.',
        'I\'ll pay by card.',
        'Transit card.',
        'Beep!',
    },
    cashExact = {
        'Here you go, exact change.',
        'Here\'s the fare.',
        'No change needed.',
    },
    cashOver = {
        'Can I get change?',
        'Change, please.',
        'I only have a large bill...',
        'I need change back.',
    },
    cashUnder = {
        'This is all I have...',
        'I\'m a bit short...',
        'Sorry, that\'s all I got.',
    },
    changeReceived = {
        'Thank you.',
        'Thanks!',
        'Appreciate it.',
    },
    cardFailed = {
        'Huh? It didn\'t work?',
        'My card isn\'t reading.',
        'Let me try again.',
    },
    tip = {
        'Keep the change.',
        'No change needed, thanks.',
        'That\'s a tip for you.',
    },
    -- Random event speeches
    fareEvader = {
        'Just let me on, I forgot my wallet!',
        'Come on, just this once?',
        'I\'ll pay next time, I promise!',
        'I don\'t have money, but I need to get home!',
    },
    drunk = {
        '*hiccup* Where are we going?',
        'Hey driver... you\'re my best friend...',
        '*stumbles* One more stop... I think...',
        'This bus is spinning!',
    },
    sick = {
        'I don\'t feel so good...',
        'Can you stop? I think I\'m going to be sick...',
        'Please... I need a hospital...',
        'Everything is spinning...',
    },
    vipGreeting = {
        'Excellent service, driver!',
        'I appreciate the pickup.',
        'First class service!',
        'Worth every penny.',
    },
}

-- ============================================================================
-- UI / Sound / Database Settings
-- ============================================================================
Config.UI = {
    drag = false,
    position = { x = 50, y = 50 },
}

Config.Sounds = {
    cardBeep     = { name = 'Beep_Green',          ref = 'DLC_HEIST_HACKING_SNAKE_SOUNDS' },
    cardFail     = { name = 'Beep_Red',             ref = 'DLC_HEIST_HACKING_SNAKE_SOUNDS' },
    cashRegister = { name = 'PICK_UP',              ref = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    changeReturn = { name = 'PICK_UP_COLLECTIBLE',  ref = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    doorOpen     = { name = 'SELECT',               ref = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    doorClose    = { name = 'BACK',                 ref = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    routeComplete = { name = 'CHALLENGE_UNLOCKED',  ref = 'HUD_AWARDS' },
}

-- ============================================================================
-- Random Event System
-- ============================================================================
Config.Events = {
    enabled = true,
    triggerChance = 15,        -- % chance per stop to trigger a random event
    minStopsBetween = 3,       -- minimum stops between events

    fareEvader = {
        enabled = true,
        weight = 35,           -- relative chance weight among events
        reportBonus = 10,      -- $ bonus for reporting
        models = { 'a_m_y_skater_01', 'a_m_y_stwhi_02', 'a_f_y_hippie_01' },
    },
    drunkPassenger = {
        enabled = true,
        weight = 25,
        kickDelay = 5000,      -- ms delay when kicking off
        models = { 'a_m_m_tramp_01', 'a_m_m_stlat_02', 'a_m_y_mexthug_01' },
    },
    sickPassenger = {
        enabled = true,
        weight = 20,
        hospitalBonus = 50,    -- $ bonus for hospital detour
        hospitalCoords = vector3(-449.67, -340.83, 34.50), -- Pillbox Medical Center
        hospitalRadius = 30.0,
    },
    vipPickup = {
        enabled = true,
        weight = 20,
        bonusMin = 30,
        bonusMax = 80,
        models = { 'a_m_m_bevhills_02', 'a_f_m_bevhills_01', 'a_m_y_business_03' },
    },
}

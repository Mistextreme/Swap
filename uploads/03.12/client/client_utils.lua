-- ============================================================================
-- Client Utils (escrow_ignore) - Customizable hooks for nc-busjob
-- Users can modify these functions to integrate with their framework
-- ============================================================================

ClientUtils = {}

-- ============================================================================
-- Framework Detection & Initialization
-- ============================================================================

local Framework = nil   -- 'qb' | 'qbox' | 'esx' | 'ox'
local QBCore, ESX

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        Framework = Config.Framework
    elseif GetResourceState('qbx_core') == 'started' then
        Framework = 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        Framework = 'qb'
    elseif GetResourceState('ox_core') == 'started' then
        Framework = 'ox'
    elseif GetResourceState('es_extended') == 'started' then
        Framework = 'esx'
    else
        error('[nc-busjob] No supported framework detected! Set Config.Framework manually.')
    end

    if Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Framework == 'qbox' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    end

    print(('[nc-busjob] Client framework: %s'):format(Framework))
end

DetectFramework()

--- Get the detected framework name
--- @return string
function ClientUtils.GetFramework()
    return Framework
end

--- Get core framework object (QBCore or ESX)
--- @return table?
function ClientUtils.GetCoreObject()
    if Framework == 'qb' or Framework == 'qbox' then
        return QBCore
    elseif Framework == 'esx' then
        return ESX
    end
    return nil
end

--- Get player data
--- @return table
function ClientUtils.GetPlayerData()
    if Framework == 'qb' or Framework == 'qbox' then
        return QBCore.Functions.GetPlayerData() or {}
    elseif Framework == 'esx' then
        return ESX.GetPlayerData() or {}
    elseif Framework == 'ox' then
        return {}
    end
    return {}
end

--- Get vehicle plate (framework-agnostic, trimmed)
--- @param vehicle number
--- @return string
function ClientUtils.GetVehiclePlate(vehicle)
    if not vehicle or vehicle == 0 then return '' end
    local plate = GetVehicleNumberPlateText(vehicle)
    if not plate then return '' end
    return plate:gsub('^%s+', ''):gsub('%s+$', '')
end

--- Register player loaded event
--- @param cb function
function ClientUtils.OnPlayerLoaded(cb)
    if Framework == 'qb' or Framework == 'qbox' then
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', cb)
    elseif Framework == 'esx' then
        RegisterNetEvent('esx:playerLoaded', function(xPlayerData)
            cb(xPlayerData)
        end)
    elseif Framework == 'ox' then
        RegisterNetEvent('ox:playerLoaded', cb)
    end
end

--- Register player unloaded event
--- @param cb function
function ClientUtils.OnPlayerUnloaded(cb)
    if Framework == 'qb' or Framework == 'qbox' then
        RegisterNetEvent('QBCore:Client:OnPlayerUnload', cb)
    elseif Framework == 'esx' then
        RegisterNetEvent('esx:onPlayerLogout', cb)
    elseif Framework == 'ox' then
        RegisterNetEvent('ox:playerLogout', cb)
    end
end

--- Register job update event
--- @param cb function(jobData)
function ClientUtils.OnJobUpdate(cb)
    if Framework == 'qb' or Framework == 'qbox' then
        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
            cb(JobInfo)
        end)
    elseif Framework == 'esx' then
        RegisterNetEvent('esx:setJob', function(job)
            cb(job)
        end)
    elseif Framework == 'ox' then
        -- ox_core uses different system for groups
    end
end

-- ============================================================================
-- Target System Detection & Helpers
-- ============================================================================

local TargetSystem = nil  -- 'ox_target' | 'qb-target' | 'qtarget' | 'interact'

local function DetectTarget()
    if Config.Target ~= 'auto' then
        TargetSystem = Config.Target
    elseif GetResourceState('ox_target') == 'started' then
        TargetSystem = 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        TargetSystem = 'qb-target'
    elseif GetResourceState('qtarget') == 'started' then
        TargetSystem = 'qtarget'
    else
        TargetSystem = 'interact'
    end

    print(('[nc-busjob] Target system: %s'):format(TargetSystem))
end

DetectTarget()

--- Get the detected target system name
--- @return string
function ClientUtils.GetTargetSystem()
    return TargetSystem
end

--- Add target to a local entity (NPC)
--- @param entity number Entity handle
--- @param options table Array of target options { name, icon, label, canInteract, onSelect }
function ClientUtils.AddEntityTarget(entity, options)
    if TargetSystem == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, options)

    elseif TargetSystem == 'qb-target' then
        local qbOptions = {}
        for _, opt in ipairs(options) do
            qbOptions[#qbOptions + 1] = {
                type = 'client',
                icon = opt.icon,
                label = opt.label,
                canInteract = opt.canInteract,
                action = opt.onSelect,
            }
        end
        exports['qb-target']:AddTargetEntity(entity, { options = qbOptions, distance = 2.5 })

    elseif TargetSystem == 'qtarget' then
        local qtOptions = {}
        for _, opt in ipairs(options) do
            qtOptions[#qtOptions + 1] = {
                icon = opt.icon,
                label = opt.label,
                canInteract = opt.canInteract,
                action = opt.onSelect,
            }
        end
        exports.qtarget:AddTargetEntity(entity, { options = qtOptions, distance = 2.5 })

    elseif TargetSystem == 'interact' then
        -- E key fallback — handled by a proximity thread
        ClientUtils._interactEntities = ClientUtils._interactEntities or {}
        ClientUtils._interactEntities[entity] = options
        ClientUtils._startInteractLoop()
    end
end

--- Remove target from a local entity
--- @param entity number Entity handle
function ClientUtils.RemoveEntityTarget(entity)
    if TargetSystem == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity)
    elseif TargetSystem == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(entity)
    elseif TargetSystem == 'qtarget' then
        exports.qtarget:RemoveTargetEntity(entity)
    elseif TargetSystem == 'interact' then
        if ClientUtils._interactEntities then
            ClientUtils._interactEntities[entity] = nil
        end
    end
end

--- Internal: Start E key interaction loop (only runs if target = 'interact')
function ClientUtils._startInteractLoop()
    if ClientUtils._interactLoopRunning then return end
    ClientUtils._interactLoopRunning = true

    CreateThread(function()
        while next(ClientUtils._interactEntities or {}) do
            local sleep = 500
            local ped = PlayerPedId()
            local pCoords = GetEntityCoords(ped)

            for entity, options in pairs(ClientUtils._interactEntities) do
                if DoesEntityExist(entity) then
                    local dist = #(pCoords - GetEntityCoords(entity))
                    if dist < 2.5 then
                        sleep = 0
                        -- Find first interactable option
                        for _, opt in ipairs(options) do
                            local canInteract = true
                            if opt.canInteract then
                                canInteract = opt.canInteract()
                            end
                            if canInteract then
                                ClientUtils.ShowTextUI(('[E] %s'):format(opt.label), opt.icon)
                                if IsControlJustReleased(0, 38) then -- E key
                                    ClientUtils.HideTextUI()
                                    if opt.onSelect then opt.onSelect() end
                                end
                                break -- show only first valid option
                            end
                        end
                    end
                end
            end

            Wait(sleep)
        end

        ClientUtils.HideTextUI()
        ClientUtils._interactLoopRunning = false
    end)
end

-- ============================================================================
-- Notification System
-- ============================================================================

--- Show notification to player
--- @param msg string
--- @param type string 'success' | 'error' | 'info' | 'warning'
--- @param duration number? ms (default 5000)
function ClientUtils.ShowNotification(msg, type, duration)
    -- ox_lib (default)
    lib.notify({
        title = L('labels.bus_system'),
        description = msg,
        type = type or 'info',
        duration = duration or 5000,
    })

    -- QBCore:
    -- QBCore.Functions.Notify(msg, type, duration)

    -- okokNotify:
    -- exports['okokNotify']:Alert('Bus System', msg, duration or 5000, type or 'info')
end

-- ============================================================================
-- TextUI System
-- ============================================================================

--- Show TextUI prompt
--- @param msg string
--- @param icon string?
function ClientUtils.ShowTextUI(msg, icon)
    lib.showTextUI(msg, {
        icon = icon or 'fas fa-bus',
        position = 'right-center',
    })
end

--- Hide TextUI prompt
function ClientUtils.HideTextUI()
    lib.hideTextUI()
end

-- ============================================================================
-- Sound Effects
-- ============================================================================

--- Play a sound effect
--- @param soundName string
--- @param soundRef string
function ClientUtils.PlaySoundEffect(soundName, soundRef)
    PlaySoundFrontend(-1, soundName, soundRef, true)
end

--- Play card beep sound
function ClientUtils.PlayCardBeep()
    local s = Config.Sounds.cardBeep
    ClientUtils.PlaySoundEffect(s.name, s.ref)
end

--- Play card fail sound
function ClientUtils.PlayCardFail()
    local s = Config.Sounds.cardFail
    ClientUtils.PlaySoundEffect(s.name, s.ref)
end

--- Play cash register sound
function ClientUtils.PlayCashRegister()
    local s = Config.Sounds.cashRegister
    ClientUtils.PlaySoundEffect(s.name, s.ref)
end

--- Play change return sound
function ClientUtils.PlayChangeReturn()
    local s = Config.Sounds.changeReturn
    ClientUtils.PlaySoundEffect(s.name, s.ref)
end

--- Play route complete sound
function ClientUtils.PlayRouteComplete()
    local s = Config.Sounds.routeComplete
    ClientUtils.PlaySoundEffect(s.name, s.ref)
end

-- ============================================================================
-- Dispatch Integration
-- ============================================================================

--- Report incident (e.g., fare evasion)
--- @param type string 'fare_evasion' | 'accident' | 'breakdown'
--- @param coords vector3
function ClientUtils.ReportIncident(type, coords)
    -- ps-dispatch:
    -- exports['ps-dispatch']:CustomAlert({
    --     coords = coords,
    --     message = 'Bus incident report',
    --     dispatchCode = 'BUS-01',
    --     description = type,
    --     radius = 0,
    --     sprite = 513,
    --     color = 5,
    --     scale = 1.0,
    --     length = 3,
    -- })

    if Config.Debug then
        print(('[nc-busjob] Incident reported: %s at %s'):format(type, coords))
    end
end

-- ============================================================================
-- Mission Hooks (Events)
-- ============================================================================

--- Called when a route is started
--- @param routeId number
--- @param routeData table
function ClientUtils.OnRouteStarted(routeId, routeData)
    if Config.Debug then
        print(('[nc-busjob] Route started: %s (%s)'):format(routeData.name, routeId))
    end
end

--- Called when a route is completed
--- @param routeId number
--- @param earnings number
--- @param passengers number
function ClientUtils.OnRouteCompleted(routeId, earnings, passengers)
    if Config.Debug then
        print(('[nc-busjob] Route completed: %s | Earnings: $%s | Passengers: %s'):format(routeId, earnings, passengers))
    end
end

--- Called when a passenger boards the bus
--- @param npcType string
--- @param fare number
function ClientUtils.OnPassengerBoarded(npcType, fare)
    if Config.Debug then
        print(('[nc-busjob] Passenger boarded: %s | Fare: $%s'):format(npcType, fare))
    end
end

--- Called when payment is completed
--- @param method string 'card' | 'cash'
--- @param amount number
--- @param tip number
function ClientUtils.OnPaymentCompleted(method, amount, tip)
    if Config.Debug then
        print(('[nc-busjob] Payment: %s | Amount: $%s | Tip: $%s'):format(method, amount, tip))
    end
end

--- Called when a stop is reached
--- @param stopData table
--- @param stopIndex number
--- @param totalStops number
function ClientUtils.OnStopReached(stopData, stopIndex, totalStops)
    if Config.Debug then
        print(('[nc-busjob] Stop reached: %s (%s/%s)'):format(stopData.name, stopIndex, totalStops))
    end
end

--- Called when change is returned
--- @param needed number
--- @param given number
--- @param correct boolean
function ClientUtils.OnChangeReturned(needed, given, correct)
    if Config.Debug then
        print(('[nc-busjob] Change: needed=$%s, given=$%s, correct=%s'):format(needed, given, tostring(correct)))
    end
end

-- ============================================================================
-- Vehicle Customization
-- ============================================================================

--- Get allowed vehicle hash set from Config.Buses
--- @return table<number, boolean>
function ClientUtils.GetAllowedVehicleHashes()
    local hashes = {}
    for _, bus in ipairs(Config.Buses) do
        hashes[joaat(bus.model)] = true
    end
    return hashes
end

--- Check if player is in an allowed bus
--- @return boolean
function ClientUtils.IsInAllowedBus()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then return false end
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then return false end

    local model = GetEntityModel(vehicle)
    local allowed = ClientUtils.GetAllowedVehicleHashes()
    return allowed[model] == true
end

-- ============================================================================
-- Blip Customization
-- ============================================================================

--- Create a bus stop blip
--- @param coords vector3
--- @param name string
--- @param routeColor string hex color
--- @return number blip handle
function ClientUtils.CreateStopBlip(coords, name, routeColor)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 513) -- Bus icon
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 2) -- Green
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

--- Create next stop waypoint blip
--- @param coords vector3
--- @param name string
--- @return number blip handle
function ClientUtils.CreateNextStopBlip(coords, name)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 513)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 5) -- Yellow
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(L('labels.next_stop_blip', name))
    EndTextCommandSetBlipName(blip)
    return blip
end

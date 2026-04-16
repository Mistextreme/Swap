-- ============================================================================
-- Server Utils (escrow_ignore) - Customizable hooks for nc-busjob
-- Users can modify these functions to integrate with their framework
-- ============================================================================

ServerUtils = {}

-- ============================================================================
-- Framework Detection & Initialization
-- ============================================================================

local Framework = nil   -- 'qb' | 'qbox' | 'esx' | 'ox'
local QBCore, ESX, OxCore

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
    elseif Framework == 'ox' then
        -- ox_core uses lib/init
    end

    print(('[nc-busjob] Framework detected: %s'):format(Framework))
end

DetectFramework()

--- Get the detected framework name
--- @return string
function ServerUtils.GetFramework()
    return Framework
end

-- ============================================================================
-- Money Operations
-- ============================================================================

--- Add money to player
--- @param source number
--- @param amount number
--- @param moneyType string 'cash' | 'bank'
--- @param reason string?
--- @return boolean
function ServerUtils.AddMoneyToPlayer(source, amount, moneyType, reason)
    moneyType = moneyType or 'bank'

    if Framework == 'qb' or Framework == 'qbox' then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return false end
        return Player.Functions.AddMoney(moneyType, amount, reason or 'bus-earnings')

    elseif Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        if moneyType == 'bank' then
            xPlayer.addAccountMoney('bank', amount, reason or 'bus-earnings')
        else
            xPlayer.addMoney(amount, reason or 'bus-earnings')
        end
        return true

    elseif Framework == 'ox' then
        local player = Ox.GetPlayer(source)
        if not player then return false end
        if moneyType == 'bank' then
            local account = player.getAccount()
            if account then account.addBalance(amount) end
        else
            exports.ox_inventory:AddItem(source, 'money', amount)
        end
        return true
    end

    return false
end

--- Remove money from player
--- @param source number
--- @param amount number
--- @param moneyType string 'cash' | 'bank'
--- @param reason string?
--- @return boolean
function ServerUtils.RemoveMoneyFromPlayer(source, amount, moneyType, reason)
    moneyType = moneyType or 'bank'

    if Framework == 'qb' or Framework == 'qbox' then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return false end
        return Player.Functions.RemoveMoney(moneyType, amount, reason or 'bus-expense')

    elseif Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        if moneyType == 'bank' then
            xPlayer.removeAccountMoney('bank', amount, reason or 'bus-expense')
        else
            xPlayer.removeMoney(amount, reason or 'bus-expense')
        end
        return true

    elseif Framework == 'ox' then
        local player = Ox.GetPlayer(source)
        if not player then return false end
        if moneyType == 'bank' then
            local account = player.getAccount()
            if account then account.removeBalance(amount) end
        else
            exports.ox_inventory:RemoveItem(source, 'money', amount)
        end
        return true
    end

    return false
end

--- Get player balance
--- @param source number
--- @param moneyType string 'cash' | 'bank'
--- @return number
function ServerUtils.GetPlayerBalance(source, moneyType)
    moneyType = moneyType or 'bank'

    if Framework == 'qb' or Framework == 'qbox' then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return 0 end
        return Player.PlayerData.money[moneyType] or 0

    elseif Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return 0 end
        if moneyType == 'bank' then
            return xPlayer.getAccount('bank').money or 0
        else
            return xPlayer.getMoney() or 0
        end

    elseif Framework == 'ox' then
        local player = Ox.GetPlayer(source)
        if not player then return 0 end
        if moneyType == 'bank' then
            local account = player.getAccount()
            return account and account.get('balance') or 0
        else
            return exports.ox_inventory:GetItemCount(source, 'money') or 0
        end
    end

    return 0
end

-- ============================================================================
-- Item Operations
-- ============================================================================

--- Add item to player
--- @param source number
--- @param item string
--- @param count number
--- @return boolean
function ServerUtils.AddItem(source, item, count)
    local success = exports.ox_inventory:AddItem(source, item, count or 1)
    return success ~= nil
end

-- ============================================================================
-- Player Info
-- ============================================================================

--- Get player display name
--- @param source number
--- @return string
function ServerUtils.GetPlayerDisplayName(source)
    if Framework == 'qb' or Framework == 'qbox' then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return L('labels.unknown') end
        local charinfo = Player.PlayerData.charinfo
        return ('%s %s'):format(charinfo.firstname, charinfo.lastname)

    elseif Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return L('labels.unknown') end
        return xPlayer.getName() or L('labels.unknown')

    elseif Framework == 'ox' then
        local player = Ox.GetPlayer(source)
        if not player then return L('labels.unknown') end
        return ('%s %s'):format(player.get('firstName') or '', player.get('lastName') or '')
    end

    return L('labels.unknown')
end

--- Get player identifier (citizenId / identifier / stateId)
--- @param source number
--- @return string?
function ServerUtils.GetPlayerCitizenId(source)
    if Framework == 'qb' or Framework == 'qbox' then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return nil end
        return Player.PlayerData.citizenid

    elseif Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return nil end
        return xPlayer.getIdentifier()

    elseif Framework == 'ox' then
        local player = Ox.GetPlayer(source)
        if not player then return nil end
        return tostring(player.stateId)
    end

    return nil
end

--- Get player by identifier
--- @param citizenId string
--- @return table? Player object
function ServerUtils.GetPlayerByCitizenId(citizenId)
    if Framework == 'qb' or Framework == 'qbox' then
        return QBCore.Functions.GetPlayerByCitizenId(citizenId)

    elseif Framework == 'esx' then
        local xPlayers = ESX.GetExtendedPlayers()
        for _, xPlayer in pairs(xPlayers) do
            if xPlayer.getIdentifier() == citizenId then
                return xPlayer
            end
        end
        return nil

    elseif Framework == 'ox' then
        -- OX Core doesn't have a direct lookup by stateId
        return nil
    end

    return nil
end

-- ============================================================================
-- Logging
-- ============================================================================

--- Log an event
--- @param type string
--- @param message string
--- @param source number?
function ServerUtils.Log(type, message, source)
    if Config.Debug then
        local prefix = source and ('[Player %s]'):format(source) or '[System]'
        print(('[nc-busjob] %s %s: %s'):format(prefix, type, message))
    end

    -- Discord logging:
    -- TriggerEvent('qb-log:server:CreateLog', 'nc-busjob', type, 'green', message)
end

-- ============================================================================
-- Mission Hooks (Events)
-- ============================================================================

--- Called when a route is completed
--- @param source number
--- @param routeId number
--- @param earnings number
--- @param passengers number
function ServerUtils.OnRouteCompleted(source, routeId, earnings, passengers)
    ServerUtils.Log('ROUTE_COMPLETE',
        ('Route %s completed | Earnings: $%s | Passengers: %s'):format(routeId, earnings, passengers),
        source
    )
end

--- Called when payment is received
--- @param source number
--- @param paymentData table
function ServerUtils.OnPaymentReceived(source, paymentData)
    ServerUtils.Log('PAYMENT',
        ('Method: %s | Fare: $%s | Type: %s'):format(
            paymentData.method, paymentData.fare, paymentData.npcType
        ),
        source
    )
end



-- ============================================================================
-- Validation
-- ============================================================================

--- Validate if player can start a route
--- @param source number
--- @param routeId number
--- @return boolean, string?
function ServerUtils.CanStartRoute(source, routeId)
    -- Additional validation logic (e.g., require specific job)
    -- Returns true by default
    return true, nil
end



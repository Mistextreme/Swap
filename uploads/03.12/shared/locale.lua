-- ============================================================================
-- Locale System for nc-busjob
-- Loads language files based on Config.Locale
-- ============================================================================

Locale = {}
Locale._translations = {}

--- Load locale file
function Locale.load()
    local lang = Config.Locale or 'en'
    local path = ('lang/%s.lua'):format(lang)
    local chunk = LoadResourceFile(GetCurrentResourceName(), path)

    if not chunk then
        print(('[nc-busjob] ^1ERROR: Locale file not found: %s^0'):format(path))
        -- Fallback to English
        chunk = LoadResourceFile(GetCurrentResourceName(), 'lang/en.lua')
    end

    if chunk then
        local fn, err = load(chunk)
        if fn then
            Locale._translations = fn() or {}
            if Config.Debug then
                print(('[nc-busjob] ^2Locale loaded: %s^0'):format(lang))
            end
        else
            print(('[nc-busjob] ^1ERROR: Failed to parse locale file: %s^0'):format(err))
        end
    end
end

--- Get translation by dot-notation key
--- @param key string e.g. 'notify.payment_success'
--- @param ... any format arguments
--- @return string
function Locale.get(key, ...)
    local parts = {}
    for part in key:gmatch('[^%.]+') do
        parts[#parts + 1] = part
    end

    local value = Locale._translations
    for _, part in ipairs(parts) do
        if type(value) ~= 'table' then
            return key
        end
        value = value[part]
    end

    if type(value) ~= 'string' then
        return key
    end

    local args = { ... }
    if #args > 0 then
        local ok, result = pcall(string.format, value, ...)
        return ok and result or value
    end

    return value
end

--- Shorthand alias
L = function(key, ...)
    return Locale.get(key, ...)
end

-- Auto-load on resource start
Locale.load()

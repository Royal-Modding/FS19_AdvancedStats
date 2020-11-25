AdvancedStatsManager = {}
AdvancedStatsManager_mt = Class(AdvancedStatsManager, AbstractManager)

function AdvancedStatsManager:new(modName, modDirectory, gameEnv, modEnv, extendedSpecializations, customMt)
    self = AbstractManager:new(customMt or AdvancedStatsManager_mt)
    self.extendedSpecializations = extendedSpecializations
    self.modName = modName
    self.modDirectory = modDirectory
    self.gameEnv = gameEnv
    self.modEnv = modEnv
    return self
end

function AdvancedStatsManager:initDataStructures()
    self.statistics = {}
    self.statisticsById = {}
    self.nextId = 1
end

function AdvancedStatsManager:load()
    for _, specName in pairs(self.extendedSpecializations) do
        local specExtName = specName .. "Extension"

        local filename = Utils.getFilename("vehicles/specializations/" .. specName .. ".lua", self.modDirectory)
        source(filename)

        local spec = self.gameEnv[specName]
        local specExt = self.modEnv[specExtName]

        spec.initSpecialization = Utils.overwrittenFunction(spec.initSpecialization, specExt.initSpecialization)
        specExt.modName = self.modName
        specExt.modDirectory = self.modDirectory
        specExt.name = specExtName

        spec.advancedStatsSpecExt = specExt

        g_logManager:devInfo("[%s] Extended specialization '%s' from '%s' (%s)", AdvancedStats.name, specName, filename, specExtName)
    end
    return true
end

function AdvancedStatsManager:registerStatistic(prefix, name, unit, hide)
    local statKey = prefix .. "_" .. name
    local registered = true

    if not self.statistics[statKey] then
        local stat = {}
        stat.id = self:getNextId()
        stat.name = name
        stat.key = statKey
        stat.unit = unit or AdvancedStats.UNITS.ND
        stat.l10n = "ass_" .. prefix .. name
        stat.hide = hide or false
        if g_i18n:hasText(stat.l10n) then
            stat.text = g_i18n:getText(stat.l10n)
        else
            g_logManager:devWarning("Missing translation for '%s'", stat.l10n)
            stat.text = stat.name
        end
        self.statistics[stat.key] = stat
        self.statisticsById[stat.id] = stat.key
    else
        g_logManager:devError("[%s] Statistic '%s' with key '%s' already registered", self.name, name, statKey)
        registered = false
    end

    return registered, statKey
end

function AdvancedStatsManager:registerStatistics(prefix, stats)
    local registeredStats = {}
    for _, stat in pairs(stats) do
        local registered, key = self:registerStatistic(prefix, stat[1], stat[2], stat[3])
        if registered then
            registeredStats[stat[1]] = key
        end
    end
    return registeredStats
end

function AdvancedStatsManager:getStatistic(key)
    return self.statistics[key]
end

function AdvancedStatsManager:getStatisticById(id)
    return self.statistics[self.statisticsById[id]]
end

function AdvancedStatsManager.updateStatistic(vehicle, key, value)
    if vehicle.advancedStats ~= nil and vehicle.advancedStats[key] ~= nil then
        vehicle.advancedStats[key] = vehicle.advancedStats[key] + value
    else
        g_logManager:devError("Can't find stat %s onto vehicle %s", key, vehicle)
    end
end

function AdvancedStatsManager.getVehicleHasAdvancedStats(vehicle)
    return vehicle.advancedStats ~= nil
end

function AdvancedStatsManager.getVehicleHasStatistic(vehicle, key)
    return vehicle.advancedStats ~= nil and vehicle.advancedStats[key] ~= nil
end

function AdvancedStatsManager:getNextId()
    self.nextId = self.nextId + 1
    return self.nextId - 1
end

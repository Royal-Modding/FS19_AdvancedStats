---${title}

---@author ${author}
---@version r_version_r
---@date 16/12/2020

source(Utils.getFilename("specializations/events/ResetPartialStatsEvent.lua", g_currentModDirectory))

---@class AdvancedStats
---@field isServer boolean
---@field getNextDirtyFlag function
---@field getIsEntered function
---@field clearActionEventsTable function
---@field getIsActiveForInput function
---@field addActionEvent function
---@field raiseDirtyFlags function
---@field getName function
---@field spec_enterable table
---@field spec_autodrive table
AdvancedStats = {}
AdvancedStats.MOD_NAME = g_currentModName
AdvancedStats.UNITS = {}
AdvancedStats.UNITS["ND"] = 0
AdvancedStats.UNITS["HECTARE"] = 1
AdvancedStats.UNITS["LITRE"] = 2
AdvancedStats.UNITS["KILOMETRE"] = 3

function AdvancedStats.initSpecialization()
    AdvancedStats.hud = StatsHud:new()
end

function AdvancedStats.prerequisitesPresent(specializations)
    return true
end

function AdvancedStats.registerEvents(vehicleType)
    SpecializationUtil.registerEvent(vehicleType, "onLoadStats")
end

function AdvancedStats.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "getHasAdvancedStats", AdvancedStats.getHasAdvancedStats)
    SpecializationUtil.registerFunction(vehicleType, "getHasStatsToShow", AdvancedStats.getHasStatsToShow)
    SpecializationUtil.registerFunction(vehicleType, "getNextStatId", AdvancedStats.getNextStatId)
    SpecializationUtil.registerFunction(vehicleType, "registerStat", AdvancedStats.registerStat)
    SpecializationUtil.registerFunction(vehicleType, "registerStats", AdvancedStats.registerStats)
    SpecializationUtil.registerFunction(vehicleType, "updateStat", AdvancedStats.updateStat)
    SpecializationUtil.registerFunction(vehicleType, "getStat", AdvancedStats.getStat)
    SpecializationUtil.registerFunction(vehicleType, "getStats", AdvancedStats.getStats)
    SpecializationUtil.registerFunction(vehicleType, "getStatKeyById", AdvancedStats.getStatKeyById)
    SpecializationUtil.registerFunction(vehicleType, "getStatById", AdvancedStats.getStatById)
    SpecializationUtil.registerFunction(vehicleType, "forceStatsRefresh", AdvancedStats.forceStatsRefresh)
    SpecializationUtil.registerFunction(vehicleType, "resetPartialStats", AdvancedStats.resetPartialStats)
    SpecializationUtil.registerFunction(vehicleType, "getAdvancedStatsSpecTable", AdvancedStats.getAdvancedStatsSpecTable)
end

function AdvancedStats.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoad", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onPostLoad", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onWriteStream", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onReadStream", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onDraw", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onEnterVehicle", AdvancedStats)
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents", AdvancedStats)
end

function AdvancedStats:onPreLoad(savegame)
    if g_advancedStats ~= nil then
        g_advancedStats:addExportListener(self)
    end
    ---@type any
    self.spec_advancedStats = self[string.format("spec_%s.advancedStats", AdvancedStats.MOD_NAME)] or {}
    local spec = self.spec_advancedStats
    spec.statistics = {}
    spec.statisticsKeyById = {}

    spec.nextStatId = 1

    if self.isServer then
        spec.syncTimeout = 1000 -- send every 1 seconds
        spec.syncTimer = math.random() * spec.syncTimeout -- randomize timer to prevent synchronizing all statistics at the same frame
        spec.dirtyFlag = self:getNextDirtyFlag()
        spec.statsUpdateTime = g_time
        spec.statsSyncUpdateTime = spec.statsUpdateTime
    end

    -- no need to show stats hud on dedicated servers
    spec.canShowStatsHud = self.spec_enterable ~= nil and self.getIsEntered ~= nil and g_dedicatedServerInfo == nil
    if spec.canShowStatsHud then
        spec.refreshStatsHudTimeout = 500
        spec.refreshStatsHudTimer = spec.refreshStatsHudTimeout
        spec.showStatsHud = false
        spec.showPartialStats = false
    end

    SpecializationUtil.raiseEvent(self, "onLoadStats")
end

function AdvancedStats:onPostLoad(savegame)
    if savegame ~= nil and not savegame.resetVehicles then
        -- Loading advanced statistics from savegame
        local spec = self.spec_advancedStats
        -- Load old stats backward compatibility (1.0.0.0 to 2.0.0.0)
        --local oldStats = {}
        --local i = 0
        --while true do
        --    local key = string.format("%s.advancedStats.statistic(%d)", savegame.key, i)
        --    if not hasXMLProperty(savegame.xmlFile, key) then
        --        break
        --    end
        --    oldStats[getXMLString(savegame.xmlFile, key .. "#key")] = Utils.getNoNil(getXMLFloat(savegame.xmlFile, key .. "#value"), 0)
        --    i = i + 1
        --end

        -- Load new stats
        local key = string.format("%s.%s.%s", savegame.key, AdvancedStats.MOD_NAME, "advancedStats")
        for _, stat in pairs(spec.statistics) do
            local statXmlKey = string.format("%s.%s", key, stat.key)
            stat.total = getXMLFloat(savegame.xmlFile, statXmlKey .. "#total") or 0 --oldStats[stat.key] or 0
            stat.partial = getXMLFloat(savegame.xmlFile, statXmlKey .. "#partial") or 0
        end
    end
end

function AdvancedStats:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    -- TODO: in update o updatetick aggiornare l'action event: sia il testo che la visibilità, perchè se un veicolo non ha statistiche da mostrare l'input non deve essere abilitato
    local spec = self.spec_advancedStats
    if spec.canShowStatsHud and self:getIsEntered() then
        self:clearActionEventsTable(spec.actionEvents)
        if self:getIsActiveForInput(true, true) then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.ADVANCEDSTATS_TOGGLE, self, AdvancedStats.onToggleStatsHud, false, true, false, true, nil, nil, true)
            g_inputBinding:setActionEventTextVisibility(actionEventId, true)
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
            if spec.showStatsHud then
                if spec.showPartialStats then
                    g_inputBinding:setActionEventText(actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_HIDE"))
                else
                    g_inputBinding:setActionEventText(actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_SHOW_PARTIAL"))
                end
            else
                g_inputBinding:setActionEventText(actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_SHOW"))
            end
            _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.ADVANCEDSTATS_RESET, self, AdvancedStats.onResetStats, false, true, false, true, nil, nil, true)
            g_inputBinding:setActionEventTextVisibility(actionEventId, spec.showStatsHud and spec.showPartialStats)
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_HIGH)
            g_inputBinding:setActionEventText(actionEventId, g_i18n:getText("input_ADVANCEDSTATS_RESET"))
        end
    end
end

---@param streamId number
---@param connection any
function AdvancedStats:onWriteStream(streamId, connection)
    -- initial mp sync
    local spec = self.spec_advancedStats
    local statsCount = TableUtility.count(spec.statistics)
    streamWriteUInt16(streamId, statsCount)
    ---@type AdvancedStatistic
    for _, stat in pairs(spec.statistics) do
        streamWriteString(streamId, stat.key)
        streamWriteUInt16(streamId, stat.id)
        streamWriteString(streamId, stat.l10n)
        streamWriteUInt8(streamId, stat.unit)
        streamWriteBool(streamId, stat.hide)
        streamWriteFloat32(streamId, stat.total)
        streamWriteFloat32(streamId, stat.partial)
    end
end

---@param streamId number
---@param connection any
function AdvancedStats:onReadStream(streamId, connection)
    -- initial mp sync
    local spec = self.spec_advancedStats
    spec.statistics = {}
    local statsCount = streamReadUInt16(streamId)
    if statsCount > 0 then
        for _ = 1, statsCount do
            local stat = {}
            stat.key = streamReadString(streamId)
            stat.id = streamReadUInt16(streamId)
            stat.l10n = streamReadString(streamId)
            if g_i18n:hasText(stat.l10n) then
                stat.text = g_i18n:getText(stat.l10n)
            else
                stat.text = stat.key
            end
            stat.unit = streamReadUInt8(streamId)
            stat.hide = streamReadBool(streamId)
            stat.total = streamReadFloat32(streamId)
            stat.partial = streamReadFloat32(streamId)
            spec.statistics[stat.key] = stat
            spec.statisticsKeyById[stat.id] = stat.key
        end
    end
end

function AdvancedStats:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_advancedStats
    if self.isServer then
        spec.syncTimer = spec.syncTimer + dt
        if spec.syncTimer >= spec.syncTimeout and spec.statsUpdateTime ~= spec.statsSyncUpdateTime then
            spec.syncTimer = 0
            self:raiseDirtyFlags(spec.dirtyFlag)
            spec.statsSyncUpdateTime = spec.statsUpdateTime
        end
    end

    if spec.canShowStatsHud then
        spec.refreshStatsHudTimer = spec.refreshStatsHudTimer + dt
        if spec.showStatsHud and spec.refreshStatsHudTimer >= spec.refreshStatsHudTimeout and self:getIsEntered() then
            spec.refreshStatsHudTimer = 0
            AdvancedStats.hud:setVehicleData(AdvancedStatsUtil.getVehicleAndAttachments(self), spec.showPartialStats)
        end
    end
end

function AdvancedStats:onWriteUpdateStream(streamId, connection, dirtyMask)
    -- mp sync
    if not connection:getIsServer() then
        local spec = self.spec_advancedStats
        if streamWriteBool(streamId, bitAND(dirtyMask, spec.dirtyFlag) ~= 0) then
            -- write stats
            streamWriteUInt16(streamId, TableUtility.count(spec.statistics))
            for _, stat in pairs(spec.statistics) do
                streamWriteUInt8(streamId, stat.id)
                streamWriteFloat32(streamId, stat.total)
                streamWriteFloat32(streamId, stat.partial)
            end
        end
    end
end

function AdvancedStats:onReadUpdateStream(streamId, timestamp, connection)
    -- mp sync
    if connection:getIsServer() then
        if streamReadBool(streamId) then
            -- read stats
            local spec = self.spec_advancedStats
            local count = streamReadUInt16(streamId)
            if count > 0 then
                for _ = 1, count do
                    local statId = streamReadUInt8(streamId)
                    local statTotal = streamReadFloat32(streamId)
                    local statPartial = streamReadFloat32(streamId)
                    local statKey = self:getStatKeyById(statId)
                    if spec.statistics[statKey] ~= nil then
                        spec.statistics[statKey].total = statTotal
                        spec.statistics[statKey].partial = statPartial
                    end
                end
            end
        end
    end
end

function AdvancedStats:onDraw()
    local spec = self.spec_advancedStats
    if spec.canShowStatsHud and spec.showStatsHud and self:getIsEntered() and (self.spec_autodrive == nil or self.spec_autodrive.pullDownListExpanded == 0) then
        AdvancedStats.hud:render()
    end
end

function AdvancedStats:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_advancedStats
    for _, stat in pairs(spec.statistics) do
        setXMLFloat(xmlFile, string.format("%s.%s#total", key, stat.key), stat.total)
        setXMLFloat(xmlFile, string.format("%s.%s#partial", key, stat.key), stat.partial)
    end
end

function AdvancedStats:onEnterVehicle()
    --local spec = self.spec_advancedStats
    self:forceStatsRefresh()
end

function AdvancedStats.onToggleStatsHud(self, actionName, inputValue, callbackState, isAnalog, isMouse)
    local spec = self.spec_advancedStats
    if spec.showStatsHud then
        if spec.showPartialStats then
            spec.showStatsHud = false
            spec.showPartialStats = false
        else
            spec.showPartialStats = true
        end
    else
        spec.showStatsHud = true
    end
    local actionEvent = spec.actionEvents[InputAction.ADVANCEDSTATS_TOGGLE]
    if actionEvent ~= nil then
        if spec.showStatsHud then
            self:forceStatsRefresh()
            if spec.showPartialStats then
                g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_HIDE"))
            else
                g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_SHOW_PARTIAL"))
            end
        else
            g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_SHOW"))
        end
        g_inputBinding:setActionEventTextVisibility(spec.actionEvents[InputAction.ADVANCEDSTATS_RESET].actionEventId, spec.showStatsHud and spec.showPartialStats)
    end
end

function AdvancedStats.onResetStats(self, actionName, inputValue, callbackState, isAnalog, isMouse)
    local spec = self.spec_advancedStats
    if spec.showStatsHud and spec.showPartialStats then
        ResetPartialStatsEvent.sendToServer(self)
        if not self.isServer then
            self:resetPartialStats()
        end
    end
end

function AdvancedStats:getAdvancedStatsSpecTable(specName)
    if not self[specName] then
        self[specName] = {}
    end
    return self[specName]
end

function AdvancedStats:getHasAdvancedStats()
    return true
end

function AdvancedStats:getHasStatsToShow(checkPartial)
    local spec = self.spec_advancedStats
    for _, stat in pairs(spec.statistics) do
        if not stat.hide and ((not checkPartial and stat.total > 0) or (checkPartial and stat.partial > 0)) then
            return true
        end
    end
    return false
end

function AdvancedStats:getNextStatId()
    local spec = self.spec_advancedStats
    spec.nextStatId = spec.nextStatId + 1
    return spec.nextStatId - 1
end

---@param prefix string
---@param name string
---@param unit number
---@param hide boolean
---@return boolean success
---@return string key
function AdvancedStats:registerStat(prefix, name, unit, hide)
    if self.isServer then
        local spec = self.spec_advancedStats
        local statKey = prefix .. "_" .. name
        local registered = true

        if not spec.statistics[statKey] then
            ---@class AdvancedStatistic
            local stat = {}
            stat.id = self:getNextStatId()
            stat.name = name
            stat.key = statKey
            stat.unit = unit or AdvancedStats.UNITS.ND
            stat.l10n = "ass_" .. prefix .. name
            stat.hide = hide or false
            if g_i18n:hasText(stat.l10n) then
                stat.text = g_i18n:getText(stat.l10n)
            else
                g_logManager:devWarning("[%s] Missing translation for '%s'", AdvancedStats.MOD_NAME, stat.l10n)
                stat.text = stat.name
            end
            stat.total = 0
            stat.partial = 0
            spec.statistics[stat.key] = stat
            spec.statisticsKeyById[stat.id] = stat.key
        else
            g_logManager:devError("[%s] Statistic '%s' with key '%s' already registered", AdvancedStats.MOD_NAME, name, statKey)
            registered = false
        end

        return registered, statKey
    else
        g_logManager:devError("[%s] Statistics can be registered only server-side (%s > %s).", AdvancedStats.MOD_NAME, prefix, name)
        return false
    end
end

---@param prefix string
---@param stats any
---@return any
function AdvancedStats:registerStats(prefix, stats)
    local registeredStats = {}
    for _, stat in pairs(stats) do
        ---@type string
        local name = stat[1]
        ---@type number
        local unit = stat[2]
        ---@type boolean
        local hide = stat[3]
        local registered, key = self:registerStat(prefix, name, unit, hide)
        if registered then
            registeredStats[name] = key
        end
    end
    return registeredStats
end

---@param key string
---@param value number
function AdvancedStats:updateStat(key, value)
    if self.isServer then
        local spec = self.spec_advancedStats
        if spec.statistics ~= nil and spec.statistics[key] ~= nil then
            spec.statistics[key].total = spec.statistics[key].total + value
            spec.statistics[key].partial = spec.statistics[key].partial + value
            spec.statsUpdateTime = g_time
        else
            g_logManager:devError("[%s] Can't find stat %s onto vehicle %s", AdvancedStats.MOD_NAME, key, self:getName())
        end
    else
        g_logManager:devWarning("[%s] Stats can be updated only server-side ('%s' = %s)", AdvancedStats.MOD_NAME, key, value)
    end
end

---@param key string
---@return any stat
function AdvancedStats:getStat(key)
    return self:getStats()[key]
end

---@return any stats
function AdvancedStats:getStats()
    local spec = self.spec_advancedStats
    return spec.statistics
end

---@param id number stat id
---@return string statKey stat key
function AdvancedStats:getStatKeyById(id)
    local spec = self.spec_advancedStats
    return spec.statisticsKeyById[id]
end

---@param id number stat id
---@return any stat
function AdvancedStats:getStatById(id)
    local spec = self.spec_advancedStats
    return spec.statistics[self:getStatKeyById(id)]
end

function AdvancedStats:resetPartialStats(doNotForceStatsRefresh)
    local spec = self.spec_advancedStats
    for _, stat in pairs(spec.statistics) do
        stat.partial = 0
    end
    if not doNotForceStatsRefresh then
        self:forceStatsRefresh()
    end
end

function AdvancedStats:forceStatsRefresh()
    local spec = self.spec_advancedStats
    if self.isServer then
        spec.syncTimer = 0
        self:raiseDirtyFlags(spec.dirtyFlag)
    end
    if spec.canShowStatsHud then
        spec.refreshStatsHudTimer = spec.refreshStatsHudTimeout
    end
end

--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 29/10/2020

VehicleExtension = {}

function VehicleExtension:loadFinished(superFunc, i3dNode, arguments)
    local loadingState = superFunc(self, i3dNode, arguments)
    if self.loadingState == BaseMission.VEHICLE_LOAD_OK then
        if self.isServer then
            local position, rotation, isSave, propertyState, ownerFarmId, price, savegame, asyncCallbackFunction, asyncCallbackObject, asyncCallbackArguments, componentPositions = unpack(arguments)
            -- Creating advanced statistics for every specialization
            self.advancedStatsCount = 0
            self.advancedStats = {}
            for _, spec in pairs(self.specializations) do
                -- catch stats managed by specs
                local advancedStatsSpec = nil
                if spec.advancedStatistics ~= nil then
                    advancedStatsSpec = spec
                end

                -- catch stats managed by extended specs
                if spec.advancedStatsSpecExt ~= nil then
                    advancedStatsSpec = spec.advancedStatsSpecExt
                end

                if advancedStatsSpec ~= nil then
                    for _, statKey in pairs(advancedStatsSpec.advancedStatistics) do
                        self.advancedStats[statKey] = 0
                        self.advancedStatsCount = self.advancedStatsCount + 1
                    end
                end
            end
            if self.advancedStatsCount > 0 then
                if savegame ~= nil then
                    -- Loading advanced statistics from savegame
                    local statIndex = 0
                    while true do
                        local key = string.format("%s.advancedStats.statistic(%d)", savegame.key, statIndex)
                        if not hasXMLProperty(savegame.xmlFile, key) then
                            break
                        end
                        local sKey = getXMLString(savegame.xmlFile, key .. "#key")
                        if g_advancedStatsManager:getStatistic(sKey) ~= nil then
                            self.advancedStats[sKey] = Utils.getNoNil(getXMLFloat(savegame.xmlFile, key .. "#value"), 0)
                        end
                        statIndex = statIndex + 1
                    end
                end
            end

            self.advancedStatsSyncTimer = 0
            self.advancedStatsSyncTimeout = 10000 -- send every 10 seconds
            self.advancedStatsSyncHappened = false
        end
    end
    if loadingState ~= nil then
        return loadingState
    end
end

function VehicleExtension:saveToXMLFile(superFunc, xmlFile, key, usedModNames)
    superFunc(self, xmlFile, key, usedModNames)
    if self.advancedStats ~= nil then
        local statIndex = 0
        for sKey, sValue in pairs(self.advancedStats) do
            setXMLString(xmlFile, string.format("%s.advancedStats.statistic(%d)#key", key, statIndex), sKey)
            setXMLFloat(xmlFile, string.format("%s.advancedStats.statistic(%d)#value", key, statIndex), sValue)
            statIndex = statIndex + 1
        end
    end
end

function VehicleExtension:update(superFunc, dt)
    superFunc(self, dt)
    if self.isServer then
        self.advancedStatsSyncTimer = self.advancedStatsSyncTimer + dt
        if self.advancedStatsSyncHappened then
            self.advancedStatsSyncTimer = 0
            self.advancedStatsSyncHappened = false
        end
    end
end

function VehicleExtension:writeStream(superFunc, streamId, connection)
    superFunc(self, streamId, connection)
    -- initial mp sync
    VehicleExtension.writeStatsToStream(self, streamId)
end

function VehicleExtension:readStream(superFunc, streamId, connection)
    superFunc(self, streamId, connection)
    -- initial mp sync
    self.advancedStatsCount = 0
    self.advancedStats = {}
    VehicleExtension.readStatsFromStream(self, streamId)
end

function VehicleExtension:writeUpdateStream(superFunc, streamId, connection, dirtyMask)
    superFunc(self, streamId, connection, dirtyMask)
    -- mp sync
    if not connection.isServer then
        local send = self.advancedStatsSyncTimer >= self.advancedStatsSyncTimeout
        streamWriteBool(streamId, send)
        if send then
            -- write stats
            VehicleExtension.writeStatsToStream(self, streamId)
            self.advancedStatsSyncHappened = true
        end
    end
end

function VehicleExtension:readUpdateStream(superFunc, streamId, timestamp, connection)
    superFunc(self, streamId, timestamp, connection)
    -- mp sync
    if connection.isServer then
        if streamReadBool(streamId) then
            -- read stats
            VehicleExtension.readStatsFromStream(self, streamId)
        end
    end
end

function VehicleExtension:writeStatsToStream(streamId)
    streamWriteUInt16(streamId, self.advancedStatsCount)
    if self.advancedStatsCount > 0 then
        for sKey, sValue in pairs(self.advancedStats) do
            local stat = g_advancedStatsManager:getStatistic(sKey)
            streamWriteUInt16(streamId, stat.id)
            streamWriteFloat32(streamId, sValue)
        end
    end
end

function VehicleExtension:readStatsFromStream(streamId)
    self.advancedStatsCount = streamReadUInt16(streamId)
    if self.advancedStatsCount > 0 then
        for i = 1, self.advancedStatsCount do
            local stat = g_advancedStatsManager:getStatisticById(streamReadUInt16(streamId))
            self.advancedStats[stat.key] = streamReadFloat32(streamId)
        end
    end
end

function VehicleExtension:enterableRegisterEventListeners(superFunc)
    if superFunc ~= nil then
        superFunc(self)
    end

    SpecializationUtil.registerEventListener(self, "onDraw", Enterable)
end

function VehicleExtension:enterableOnLoad(superFunc, savegame)
    if superFunc ~= nil then
        superFunc(self, savegame)
    end

    if self.isServer then
        self.advancedStatsShowTimer = 1000
    else
        self.advancedStatsShowTimer = 10000
    end
    self.advancedStatsShowTimeout = self.advancedStatsShowTimer
    self.advancedStatsShow = false
end

function VehicleExtension:enterableOnUpdate(superFunc, dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if superFunc ~= nil then
        superFunc(self, dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    end

    self.advancedStatsShowTimer = self.advancedStatsShowTimer + dt
    if self.advancedStatsShow and self.advancedStatsShowTimer >= self.advancedStatsShowTimeout and self.getIsEntered ~= nil and self:getIsEntered() then
        self.advancedStatsShowTimer = 0
        AdvancedStats.hud:setVehicleData(AdvancedStats:getAttachedImplementsRecursively(self))
    end
end

function VehicleExtension:enterableOnDraw(superFunc, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    if superFunc ~= nil then
        superFunc(self, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    end

    if self.advancedStatsShow and self.getIsEntered ~= nil and self:getIsEntered() then
        -- hud works
        AdvancedStats.hud:render()
    end
end

function VehicleExtension:enterableOnRegisterActionEvents(superFunc, isActiveForInput, isActiveForInputIgnoreSelection)
    if superFunc ~= nil then
        superFunc(self, isActiveForInput, isActiveForInputIgnoreSelection)
    end

    if self:getIsEntered() then
        local spec = self.spec_enterable
        if self:getIsActiveForInput(true, true) then
            local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.ADVANCEDSTATS_TOGGLE, self, VehicleExtension.enterableOnToggleDisplay, false, true, false, true, nil, nil, true)
            g_inputBinding:setActionEventTextVisibility(actionEventId, true)
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
            if self.advancedStatsShow then
                g_inputBinding:setActionEventText(actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_HIDE"))
            else
                g_inputBinding:setActionEventText(actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_SHOW"))
            end
        end
    end
end

function VehicleExtension.enterableOnToggleDisplay(self, actionName, inputValue, callbackState, isAnalog)
    self.advancedStatsShow = not self.advancedStatsShow
    local spec = self.spec_enterable
    local actionEvent = spec.actionEvents[InputAction.ADVANCEDSTATS_TOGGLE]
    if actionEvent ~= nil then
        if self.advancedStatsShow then
            g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_HIDE"))
        else
            g_inputBinding:setActionEventText(actionEvent.actionEventId, g_i18n:getText("ass_ADVANCEDSTATS_SHOW"))
        end
    end
end

Vehicle.loadFinished = Utils.overwrittenFunction(Vehicle.loadFinished, VehicleExtension.loadFinished)
Vehicle.saveToXMLFile = Utils.overwrittenFunction(Vehicle.saveToXMLFile, VehicleExtension.saveToXMLFile)
Vehicle.update = Utils.overwrittenFunction(Vehicle.update, VehicleExtension.update)
Vehicle.writeStream = Utils.overwrittenFunction(Vehicle.writeStream, VehicleExtension.writeStream)
Vehicle.readStream = Utils.overwrittenFunction(Vehicle.readStream, VehicleExtension.readStream)
Vehicle.writeUpdateStream = Utils.overwrittenFunction(Vehicle.writeUpdateStream, VehicleExtension.writeUpdateStream)
Vehicle.readUpdateStream = Utils.overwrittenFunction(Vehicle.readUpdateStream, VehicleExtension.readUpdateStream)

Enterable.registerEventListeners = Utils.overwrittenFunction(Enterable.registerEventListeners, VehicleExtension.enterableRegisterEventListeners)
Enterable.onLoad = Utils.overwrittenFunction(Enterable.onLoad, VehicleExtension.enterableOnLoad)
Enterable.onUpdate = Utils.overwrittenFunction(Enterable.onUpdate, VehicleExtension.enterableOnUpdate)
Enterable.onDraw = Utils.overwrittenFunction(Enterable.onDraw, VehicleExtension.enterableOnDraw)
Enterable.onRegisterActionEvents = Utils.overwrittenFunction(Enterable.onRegisterActionEvents, VehicleExtension.enterableOnRegisterActionEvents)

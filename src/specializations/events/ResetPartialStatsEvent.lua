--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 21/12/2020

ResetPartialStatsEvent = {}
ResetPartialStatsEvent_mt = Class(ResetPartialStatsEvent, Event)

InitEventClass(ResetPartialStatsEvent, "ResetPartialStatsEvent")

function ResetPartialStatsEvent:emptyNew()
    local o = Event:new(ResetPartialStatsEvent_mt)
    o.className = "ResetPartialStatsEvent"
    return o
end

function ResetPartialStatsEvent:new(vehicle)
    local o = ResetPartialStatsEvent:emptyNew()
    o.vehicle = vehicle
    return o
end

function ResetPartialStatsEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.vehicle)
end

function ResetPartialStatsEvent:readStream(streamId, connection)
    self.vehicle = NetworkUtil.readNodeObject(streamId)
    self:run(connection)
end

function ResetPartialStatsEvent:run(connection)
    if g_server ~= nil then
        local vehicles = AdvancedStatsUtil.getVehicleAndAttachments(self.vehicle)
        for _, v in pairs(vehicles) do
            if v.resetPartialStats ~= nil then
                v:resetPartialStats()
            end
        end
    end
end

function ResetPartialStatsEvent.sendToServer(vehicle)
    g_client:getServerConnection():sendEvent(ResetPartialStatsEvent:new(vehicle))
end

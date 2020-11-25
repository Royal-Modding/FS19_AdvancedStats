--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

BaleGrabExtension = {}
BaleGrabExtension.advancedStatisticsPrefix = "BaleGrab"
BaleGrabExtension.advancedStatistics = {{"GrabbedBales", AdvancedStats.UNITS.ND}}

function BaleGrabExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    BaleGrabExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(BaleGrabExtension.advancedStatisticsPrefix, BaleGrabExtension.advancedStatistics)
end

if g_server ~= nil then
    function BaleGrabExtension:addDynamicMountedObject(superFunc, object)
        if self.spec_baleGrab.dynamicMountedObjects[object] == nil then
            g_advancedStatsManager.updateStatistic(self, BaleGrabExtension.advancedStatistics["GrabbedBales"], 1)
        end
        superFunc(self, object)
    end
    BaleGrab.addDynamicMountedObject = Utils.overwrittenFunction(BaleGrab.addDynamicMountedObject, BaleGrabExtension.addDynamicMountedObject)
end

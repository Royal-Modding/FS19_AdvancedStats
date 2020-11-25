--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 23/11/2020

ShovelExtension = {}
ShovelExtension.advancedStatisticsPrefix = "Shovel"
ShovelExtension.advancedStatistics = {{"LoadedLiters", AdvancedStats.UNITS.LITRE}}

function ShovelExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    ShovelExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(ShovelExtension.advancedStatisticsPrefix, ShovelExtension.advancedStatistics)
end

if g_server ~= nil then
    function ShovelExtension:registerEventListeners(superFunc)
        superFunc(self)
        SpecializationUtil.registerEventListener(self, "onFillUnitFillLevelChanged", ShovelExtension)
    end
    Shovel.registerEventListeners = Utils.overwrittenFunction(Shovel.registerEventListeners, ShovelExtension.registerEventListeners)

    function ShovelExtension:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
        if self.typeName == "shovel" and appliedDelta > 0 and g_advancedStatsManager.getVehicleHasStatistic(self, ShovelExtension.advancedStatistics["LoadedLiters"]) then
            g_advancedStatsManager.updateStatistic(self, ShovelExtension.advancedStatistics["LoadedLiters"], appliedDelta)
        end
    end
end

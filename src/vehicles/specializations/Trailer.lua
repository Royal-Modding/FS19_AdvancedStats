--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

TrailerExtension = {}
TrailerExtension.advancedStatisticsPrefix = "Trailer"
TrailerExtension.advancedStatistics = {{"LoadedLiters", AdvancedStats.UNITS.LITRE}}

function TrailerExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    TrailerExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(TrailerExtension.advancedStatisticsPrefix, TrailerExtension.advancedStatistics)
end

if g_server ~= nil then
    function TrailerExtension:registerEventListeners(superFunc)
        superFunc(self)
        SpecializationUtil.registerEventListener(self, "onFillUnitFillLevelChanged", TrailerExtension)
    end
    Trailer.registerEventListeners = Utils.overwrittenFunction(Trailer.registerEventListeners, TrailerExtension.registerEventListeners)

    function TrailerExtension:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
        if appliedDelta > 0 and g_advancedStatsManager.getVehicleHasStatistic(self, TrailerExtension.advancedStatistics["LoadedLiters"]) then
            g_advancedStatsManager.updateStatistic(self, TrailerExtension.advancedStatistics["LoadedLiters"], appliedDelta)
        end
    end
end

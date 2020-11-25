--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

LevelerExtension = {}
LevelerExtension.advancedStatisticsPrefix = "Leveler"
LevelerExtension.advancedStatistics = {{"MovedLiters", AdvancedStats.UNITS.LITRE}}

function LevelerExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    LevelerExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(LevelerExtension.advancedStatisticsPrefix, LevelerExtension.advancedStatistics)
end

if g_server ~= nil then
    function LevelerExtension:registerEventListeners(superFunc)
        superFunc(self)
        SpecializationUtil.registerEventListener(self, "onFillUnitFillLevelChanged", LevelerExtension)
    end
    Leveler.registerEventListeners = Utils.overwrittenFunction(Leveler.registerEventListeners, LevelerExtension.registerEventListeners)

    function LevelerExtension:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
        if appliedDelta > 0 then
            g_advancedStatsManager.updateStatistic(self, LevelerExtension.advancedStatistics["MovedLiters"], appliedDelta)
        end
    end
end

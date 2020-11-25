--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

ConveyorBeltExtension = {}
ConveyorBeltExtension.advancedStatisticsPrefix = "ConveyorBelt"
ConveyorBeltExtension.advancedStatistics = {{"MovedLiters", AdvancedStats.UNITS.LITRE}}

function ConveyorBeltExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    ConveyorBeltExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(ConveyorBeltExtension.advancedStatisticsPrefix, ConveyorBeltExtension.advancedStatistics)
end

if g_server ~= nil then
    function ConveyorBeltExtension:registerEventListeners(superFunc)
        superFunc(self)
        SpecializationUtil.registerEventListener(self, "onFillUnitFillLevelChanged", ConveyorBeltExtension)
    end
    ConveyorBelt.registerEventListeners = Utils.overwrittenFunction(ConveyorBelt.registerEventListeners, ConveyorBeltExtension.registerEventListeners)

    function ConveyorBeltExtension:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
        if appliedDelta > 0 then
            g_advancedStatsManager.updateStatistic(self, ConveyorBeltExtension.advancedStatistics["MovedLiters"], appliedDelta)
        end
    end
end

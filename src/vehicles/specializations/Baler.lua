--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

BalerExtension = {}
BalerExtension.advancedStatisticsPrefix = "Baler"
BalerExtension.advancedStatistics = {{"BaleCount", AdvancedStats.UNITS.ND}, {"LoadedLiters", AdvancedStats.UNITS.LITRE}}

function BalerExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    BalerExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(BalerExtension.advancedStatisticsPrefix, BalerExtension.advancedStatistics)
end

if g_server ~= nil then
    function BalerExtension:registerEventListeners(superFunc)
        superFunc(self)
        SpecializationUtil.registerEventListener(self, "onFillUnitFillLevelChanged", BalerExtension)
    end
    Baler.registerEventListeners = Utils.overwrittenFunction(Baler.registerEventListeners, BalerExtension.registerEventListeners)

    function BalerExtension:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
        if appliedDelta > 0 and g_advancedStatsManager.getVehicleHasStatistic(self, BalerExtension.advancedStatistics["LoadedLiters"]) then
            g_advancedStatsManager.updateStatistic(self, BalerExtension.advancedStatistics["LoadedLiters"], appliedDelta)
        end
    end

    function BalerExtension:dropBale(superFunc, baleIndex)
        superFunc(self, baleIndex)
        g_advancedStatsManager.updateStatistic(self, BalerExtension.advancedStatistics["BaleCount"], 1)
    end
    Baler.dropBale = Utils.overwrittenFunction(Baler.dropBale, BalerExtension.dropBale)
end

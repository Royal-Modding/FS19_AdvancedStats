--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

BaleWrapperExtension = {}
BaleWrapperExtension.advancedStatisticsPrefix = "BaleWrapper"
BaleWrapperExtension.advancedStatistics = {{"WrappedBales", AdvancedStats.UNITS.ND}}

function BaleWrapperExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    BaleWrapperExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(BaleWrapperExtension.advancedStatisticsPrefix, BaleWrapperExtension.advancedStatistics)
end

if g_server ~= nil then
    function BaleWrapperExtension:pickupWrapperBale(superFunc, bale, baleType)
        superFunc(self, bale, baleType)
        g_advancedStatsManager.updateStatistic(self, BaleWrapperExtension.advancedStatistics["WrappedBales"], 1)
    end
    BaleWrapper.pickupWrapperBale = Utils.overwrittenFunction(BaleWrapper.pickupWrapperBale, BaleWrapperExtension.pickupWrapperBale)
end

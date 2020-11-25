--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

BaleLoaderExtension = {}
BaleLoaderExtension.advancedStatisticsPrefix = "BaleLoader"
BaleLoaderExtension.advancedStatistics = {{"LoadedBales", AdvancedStats.UNITS.ND}}

function BaleLoaderExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    BaleLoaderExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(BaleLoaderExtension.advancedStatisticsPrefix, BaleLoaderExtension.advancedStatistics)
end

if g_server ~= nil then
    function BaleLoaderExtension:pickupBale(superFunc, nearestBale, nearestBaleType)
        superFunc(self, nearestBale, nearestBaleType)
        g_advancedStatsManager.updateStatistic(self, BaleLoaderExtension.advancedStatistics["LoadedBales"], 1)
    end
    BaleLoader.pickupBale = Utils.overwrittenFunction(BaleLoader.pickupBale, BaleLoaderExtension.pickupBale)
end

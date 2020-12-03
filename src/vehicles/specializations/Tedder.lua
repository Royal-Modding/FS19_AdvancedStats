--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 14/11/2020

TedderExtension = {}
TedderExtension.advancedStatisticsPrefix = "Tedder"
TedderExtension.advancedStatistics = {{"WorkedLitres", AdvancedStats.UNITS.LITRE, true}, {"WorkedHectares", AdvancedStats.UNITS.HECTARE}}

function TedderExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    TedderExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(TedderExtension.advancedStatisticsPrefix, TedderExtension.advancedStatistics)
end

if g_server ~= nil then
    function TedderExtension:processTedderArea(superFunc, workArea, dt)
        local spec = self.spec_tedder
        local area, _ = superFunc(self, workArea, dt)
        local ha = MathUtil.areaToHa(area, g_currentMission:getFruitPixelsToSqm())
        g_advancedStatsManager.updateStatistic(self, TedderExtension.advancedStatistics["WorkedHectares"], ha)
        g_advancedStatsManager.updateStatistic(self, TedderExtension.advancedStatistics["WorkedLitres"], spec.lastDroppedLiters / 2)
        return area, area
    end
    Tedder.processTedderArea = Utils.overwrittenFunction(Tedder.processTedderArea, TedderExtension.processTedderArea)
end

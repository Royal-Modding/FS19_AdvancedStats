--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 14/11/2020

WindrowerExtension = {}
WindrowerExtension.advancedStatisticsPrefix = "Windrower"
WindrowerExtension.advancedStatistics = {{"WorkedLitres", AdvancedStats.UNITS.LITRE, true}, {"WorkedHectares", AdvancedStats.UNITS.HECTARE}}

function WindrowerExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    WindrowerExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(WindrowerExtension.advancedStatisticsPrefix, WindrowerExtension.advancedStatistics)
end

if g_server ~= nil then
    function WindrowerExtension:processWindrowerArea(superFunc, workArea, dt)
        local lastDroppedLiters, area = superFunc(self, workArea, dt)
        local ha = MathUtil.areaToHa(area, g_currentMission:getFruitPixelsToSqm())
        g_advancedStatsManager.updateStatistic(self, WindrowerExtension.advancedStatistics["WorkedHectares"], ha)
        g_advancedStatsManager.updateStatistic(self, WindrowerExtension.advancedStatistics["WorkedLitres"], lastDroppedLiters / 2)
        return area, lastDroppedLiters
    end
    Windrower.processWindrowerArea = Utils.overwrittenFunction(Windrower.processWindrowerArea, WindrowerExtension.processWindrowerArea)
end

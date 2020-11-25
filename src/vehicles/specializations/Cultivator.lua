--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 28/10/2020

CultivatorExtension = {}
CultivatorExtension.advancedStatisticsPrefix = "Cultivator"
CultivatorExtension.advancedStatistics = {{"WorkedHectares", AdvancedStats.UNITS.HECTARE}}

function CultivatorExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    CultivatorExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(CultivatorExtension.advancedStatisticsPrefix, CultivatorExtension.advancedStatistics)
end

if g_server ~= nil then
    function CultivatorExtension:onEndWorkAreaProcessing(superFunc, dt)
        superFunc(self, dt)
        local lastStatsArea = self.spec_cultivator.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            g_advancedStatsManager.updateStatistic(self, CultivatorExtension.advancedStatistics["WorkedHectares"], ha)
        end
    end
    Cultivator.onEndWorkAreaProcessing = Utils.overwrittenFunction(Cultivator.onEndWorkAreaProcessing, CultivatorExtension.onEndWorkAreaProcessing)
end

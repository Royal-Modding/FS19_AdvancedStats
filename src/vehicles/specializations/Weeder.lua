--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 14/11/2020

WeederExtension = {}
WeederExtension.advancedStatisticsPrefix = "Weeder"
WeederExtension.advancedStatistics = {{"WorkedHectares", AdvancedStats.UNITS.HECTARE}}

function WeederExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    WeederExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(WeederExtension.advancedStatisticsPrefix, WeederExtension.advancedStatistics)
end

if g_server ~= nil then
    function WeederExtension:onEndWorkAreaProcessing(superFunc, dt)
        superFunc(self, dt)
        local lastStatsArea = self.spec_weeder.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            g_advancedStatsManager.updateStatistic(self, WeederExtension.advancedStatistics["WorkedHectares"], ha)
        end
    end
    Weeder.onEndWorkAreaProcessing = Utils.overwrittenFunction(Weeder.onEndWorkAreaProcessing, WeederExtension.onEndWorkAreaProcessing)
end

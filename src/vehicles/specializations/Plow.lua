--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 29/10/2020

PlowExtension = {}
PlowExtension.advancedStatisticsPrefix = "Plow"
PlowExtension.advancedStatistics = {{"WorkedHectares", AdvancedStats.UNITS.HECTARE}, {"CreatedHectares", AdvancedStats.UNITS.HECTARE}}

function PlowExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    PlowExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(PlowExtension.advancedStatisticsPrefix, PlowExtension.advancedStatistics)
end

if g_server ~= nil then
    function PlowExtension:onEndWorkAreaProcessing(superFunc, dt)
        superFunc(self, dt)
        local lastStatsArea = self.spec_plow.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            g_advancedStatsManager.updateStatistic(self, PlowExtension.advancedStatistics["WorkedHectares"], ha)
            if not self.spec_plow.workAreaParameters.limitToField then
                g_advancedStatsManager.updateStatistic(self, PlowExtension.advancedStatistics["CreatedHectares"], ha)
            end
        end
    end
    Plow.onEndWorkAreaProcessing = Utils.overwrittenFunction(Plow.onEndWorkAreaProcessing, PlowExtension.onEndWorkAreaProcessing)
end

--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

RollerExtension = {}
RollerExtension.advancedStatisticsPrefix = "Roller"
RollerExtension.advancedStatistics = {{"RolledHectares", AdvancedStats.UNITS.HECTARE}}

function RollerExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    RollerExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(RollerExtension.advancedStatisticsPrefix, RollerExtension.advancedStatistics)
end

if g_server ~= nil then
    function RollerExtension:processRollerArea(superFunc, workArea, dt)
        local realArea = superFunc(self, workArea, dt)
        if realArea > 0 then
            local ha = MathUtil.areaToHa(realArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            g_advancedStatsManager.updateStatistic(self, RollerExtension.advancedStatistics["RolledHectares"], ha)
        end
        return realArea
    end
    Roller.processRollerArea = Utils.overwrittenFunction(Roller.processRollerArea, RollerExtension.processRollerArea)
end

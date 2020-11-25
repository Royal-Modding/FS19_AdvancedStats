--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 23/11/2020

StumpCutterExtension = {}
StumpCutterExtension.advancedStatisticsPrefix = "StumpCutter"
StumpCutterExtension.advancedStatistics = {{"StumpCutted", AdvancedStats.UNITS.ND}}

function StumpCutterExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    StumpCutterExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(StumpCutterExtension.advancedStatisticsPrefix, StumpCutterExtension.advancedStatistics)
end

if g_server ~= nil then
    function StumpCutterExtension:crushSplitShape(superFunc)
        superFunc(self)
        g_advancedStatsManager.updateStatistic(self, StumpCutterExtension.advancedStatistics["StumpCutted"], 1)
    end
    StumpCutter.crushSplitShape = Utils.overwrittenFunction(StumpCutter.crushSplitShape, StumpCutterExtension.crushSplitShape)
end

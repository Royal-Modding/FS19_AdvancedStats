--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

CutterExtension = {}
CutterExtension.advancedStatisticsPrefix = "Cutter"
CutterExtension.advancedStatistics = {{"WorkedHectares", AdvancedStats.UNITS.HECTARE}}

function CutterExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    CutterExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(CutterExtension.advancedStatisticsPrefix, CutterExtension.advancedStatistics)
end

if g_server ~= nil then
    function CutterExtension:onEndWorkAreaProcessing(superFunc, dt, hasProcessed)
        superFunc(self, dt, hasProcessed)
        local lastStatsArea = self.spec_cutter.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            g_advancedStatsManager.updateStatistic(self, CutterExtension.advancedStatistics["WorkedHectares"], ha)
            CombineExtension.addWorkedArea(self.spec_cutter.workAreaParameters.combineVehicle, ha)
        end
    end
    Cutter.onEndWorkAreaProcessing = Utils.overwrittenFunction(Cutter.onEndWorkAreaProcessing, CutterExtension.onEndWorkAreaProcessing)
end

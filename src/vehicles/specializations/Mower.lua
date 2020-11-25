--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 14/11/2020

MowerExtension = {}
MowerExtension.advancedStatisticsPrefix = "Mower"
MowerExtension.advancedStatistics = {{"WorkedLitres", AdvancedStats.UNITS.LITRE}, {"WorkedHectares", AdvancedStats.UNITS.HECTARE}}

function MowerExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    MowerExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(MowerExtension.advancedStatisticsPrefix, MowerExtension.advancedStatistics)
end

if g_server ~= nil then
    function MowerExtension:onEndWorkAreaProcessing(superFunc, dt, hasProcessed)
        local spec = self.spec_mower

        local totalToDrop = 0
        for _, dropArea in ipairs(spec.dropAreas) do
            totalToDrop = totalToDrop + dropArea.litersToDrop
        end

        superFunc(self, dt, hasProcessed)

        local newTotalToDrop = 0
        for _, dropArea in ipairs(spec.dropAreas) do
            newTotalToDrop = newTotalToDrop + dropArea.litersToDrop
        end

        g_advancedStatsManager.updateStatistic(self, MowerExtension.advancedStatistics["WorkedLitres"], totalToDrop - newTotalToDrop)

        local lastStatsArea = spec.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            g_advancedStatsManager.updateStatistic(self, MowerExtension.advancedStatistics["WorkedHectares"], ha)
        end
    end
    Mower.onEndWorkAreaProcessing = Utils.overwrittenFunction(Mower.onEndWorkAreaProcessing, MowerExtension.onEndWorkAreaProcessing)
end

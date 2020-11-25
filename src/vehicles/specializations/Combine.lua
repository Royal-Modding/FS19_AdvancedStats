--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

CombineExtension = {}
CombineExtension.advancedStatisticsPrefix = "Combine"
CombineExtension.advancedStatistics = {{"ThreshedLiters", AdvancedStats.UNITS.LITRE}, {"SwathLiters", AdvancedStats.UNITS.LITRE}, {"WorkedHectares", AdvancedStats.UNITS.HECTARE}}

function CombineExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    CombineExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(CombineExtension.advancedStatisticsPrefix, CombineExtension.advancedStatistics)
end

function CombineExtension:addWorkedArea(hectares)
    g_advancedStatsManager.updateStatistic(self, CombineExtension.advancedStatistics["WorkedHectares"], hectares)
end

if g_server ~= nil then
    function CombineExtension:addCutterArea(superFunc, area, realArea, inputFruitType, outputFillType, strawRatio, farmId)
        local threshedLiters = superFunc(self, area, realArea, inputFruitType, outputFillType, strawRatio, farmId)
        g_advancedStatsManager.updateStatistic(self, CombineExtension.advancedStatistics["ThreshedLiters"], threshedLiters)
        return threshedLiters
    end
    Combine.addCutterArea = Utils.overwrittenFunction(Combine.addCutterArea, CombineExtension.addCutterArea)

    function CombineExtension:processCombineSwathArea(superFunc, workArea)
        local areas = superFunc(self, workArea)

        local spec = self.spec_combine
        if spec.isSwathActive then
            if spec.workAreaParameters.droppedLiters > 0 then
                g_advancedStatsManager.updateStatistic(self, CombineExtension.advancedStatistics["SwathLiters"], spec.workAreaParameters.droppedLiters)
            end
        end

        return areas
    end
    Combine.processCombineSwathArea = Utils.overwrittenFunction(Combine.processCombineSwathArea, CombineExtension.processCombineSwathArea)
end

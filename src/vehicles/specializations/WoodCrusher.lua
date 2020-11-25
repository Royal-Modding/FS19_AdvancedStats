--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 05/11/2020

WoodCrusherExtension = {}
WoodCrusherExtension.advancedStatisticsPrefix = "WoodCrusher"
WoodCrusherExtension.advancedStatistics = {{"CrushedLitres", AdvancedStats.UNITS.LITRE}, {"CrushedTrunks", AdvancedStats.UNITS.ND}}

function WoodCrusherExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    WoodCrusherExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(WoodCrusherExtension.advancedStatisticsPrefix, WoodCrusherExtension.advancedStatistics)
end

if g_server ~= nil then
    function WoodCrusherExtension:onCrushedSplitShape(superFunc, splitType, volume)
        g_advancedStatsManager.updateStatistic(self, WoodCrusherExtension.advancedStatistics["CrushedTrunks"], 1)
        g_advancedStatsManager.updateStatistic(self, WoodCrusherExtension.advancedStatistics["CrushedLitres"], volume * 1000 * splitType.woodChipsPerLiter)
        superFunc(self, splitType, volume)
    end
    WoodCrusher.onCrushedSplitShape = Utils.overwrittenFunction(WoodCrusher.onCrushedSplitShape, WoodCrusherExtension.onCrushedSplitShape)
end

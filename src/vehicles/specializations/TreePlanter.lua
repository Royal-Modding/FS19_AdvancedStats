--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 23/11/2020

TreePlanterExtension = {}
TreePlanterExtension.advancedStatisticsPrefix = "TreePlanter"
TreePlanterExtension.advancedStatistics = {{"PlantedTrees", AdvancedStats.UNITS.ND}}

function TreePlanterExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    TreePlanterExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(TreePlanterExtension.advancedStatisticsPrefix, TreePlanterExtension.advancedStatistics)
end

if g_server ~= nil then
    function TreePlanterExtension:createTree(superFunc)
        local spec = self.spec_treePlanter
        if g_treePlantManager:canPlantTree() and spec.mountedSaplingPallet ~= nil then
            g_advancedStatsManager.updateStatistic(self, TreePlanterExtension.advancedStatistics["PlantedTrees"], 1)
        end
        superFunc(self)
    end
    TreePlanter.createTree = Utils.overwrittenFunction(TreePlanter.createTree, TreePlanterExtension.createTree)
end

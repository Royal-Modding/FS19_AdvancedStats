--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 05/11/2020

WoodHarvesterExtension = {}
WoodHarvesterExtension.advancedStatisticsPrefix = "WoodHarvester"
WoodHarvesterExtension.advancedStatistics = {{"CutTrees", AdvancedStats.UNITS.ND}, {"CutTrunks", AdvancedStats.UNITS.ND}}

function WoodHarvesterExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    WoodHarvesterExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(WoodHarvesterExtension.advancedStatisticsPrefix, WoodHarvesterExtension.advancedStatistics)
end

if g_server ~= nil then
    function WoodHarvesterExtension:cutTree(superFunc, length, noEventSend)
        local spec = self.spec_woodHarvester
        if length == 0 then
            if spec.attachedSplitShape == nil and spec.curSplitShape ~= nil then
                g_advancedStatsManager.updateStatistic(self, WoodHarvesterExtension.advancedStatistics["CutTrees"], 1)
            end
        else
            if spec.attachedSplitShape ~= nil and spec.curSplitShape == nil then
                g_advancedStatsManager.updateStatistic(self, WoodHarvesterExtension.advancedStatistics["CutTrunks"], 1)
            end
        end
        superFunc(self, length, noEventSend)
    end
    WoodHarvester.cutTree = Utils.overwrittenFunction(WoodHarvester.cutTree, WoodHarvesterExtension.cutTree)
end

--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 05/11/2020

ExtendedWoodHarvester = {}
ExtendedWoodHarvester.MOD_NAME = g_currentModName
ExtendedWoodHarvester.SPEC_TABLE_NAME = string.format("spec_%s.extendedWoodHarvester", ExtendedWoodHarvester.MOD_NAME)

function ExtendedWoodHarvester.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedWoodHarvester.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedWoodHarvester)
end

function ExtendedWoodHarvester.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "cutTree", ExtendedWoodHarvester.cutTree)
end

function ExtendedWoodHarvester:onLoadStats()
    local spec = self[ExtendedWoodHarvester.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "WoodHarvester"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"CutTrees", AdvancedStats.UNITS.ND},
            {"CutTrunks", AdvancedStats.UNITS.ND}
        }
    )
end

function ExtendedWoodHarvester:cutTree(superFunc, length, ...)
    if self.isServer then
        local spec = self[ExtendedWoodHarvester.SPEC_TABLE_NAME]
        if length == 0 then
            if self.spec_woodHarvester.attachedSplitShape == nil and self.spec_woodHarvester.curSplitShape ~= nil then
                self:updateStat(spec.advancedStatistics["CutTrees"], 1)
            end
        else
            if self.spec_woodHarvester.attachedSplitShape ~= nil and self.spec_woodHarvester.curSplitShape == nil then
                self:updateStat(spec.advancedStatistics["CutTrunks"], 1)
            end
        end
    end
    superFunc(self, length, ...)
end

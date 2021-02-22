---${title}

---@author ${author}
---@version r_version_r
---@date 23/11/2020

---@class ExtendedTreePlanter : AdvancedStatsExtendedSpecialization
---@field spec_treePlanter any
ExtendedTreePlanter = {}
ExtendedTreePlanter.MOD_NAME = g_currentModName
ExtendedTreePlanter.SPEC_TABLE_NAME = string.format("spec_%s.extendedTreePlanter", ExtendedTreePlanter.MOD_NAME)

function ExtendedTreePlanter.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedTreePlanter.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedTreePlanter)
end

function ExtendedTreePlanter.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "createTree", ExtendedTreePlanter.createTree)
end

function ExtendedTreePlanter:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedTreePlanter.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "TreePlanter"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"PlantedTrees", AdvancedStats.UNITS.ND}
            }
        )
    end
end

function ExtendedTreePlanter:createTree(superFunc, ...)
    if self.isServer and g_treePlantManager:canPlantTree() and self.spec_treePlanter.mountedSaplingPallet ~= nil then
        local spec = self:getAdvancedStatsSpecTable(ExtendedTreePlanter.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["PlantedTrees"], 1)
    end
    superFunc(self, ...)
end

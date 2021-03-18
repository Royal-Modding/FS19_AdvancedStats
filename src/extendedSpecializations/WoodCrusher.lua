---${title}

---@author ${author}
---@version r_version_r
---@date 05/11/2020

---@class ExtendedWoodCrusher : AdvancedStatsExtendedSpecialization
ExtendedWoodCrusher = {}
ExtendedWoodCrusher.MOD_NAME = g_currentModName
ExtendedWoodCrusher.SPEC_TABLE_NAME = string.format("spec_%s.extendedWoodCrusher", ExtendedWoodCrusher.MOD_NAME)

function ExtendedWoodCrusher.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedWoodCrusher.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedWoodCrusher)
end

function ExtendedWoodCrusher.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "onCrushedSplitShape", ExtendedWoodCrusher.onCrushedSplitShape)
end

function ExtendedWoodCrusher:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedWoodCrusher.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "WoodCrusher"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"CrushedLitres", AdvancedStats.UNITS.VOLUME},
                {"CrushedTrunks", AdvancedStats.UNITS.ND}
            }
        )
    end
end

function ExtendedWoodCrusher:onCrushedSplitShape(superFunc, splitType, volume, ...)
    if self.isServer then
        local spec = self:getAdvancedStatsSpecTable(ExtendedWoodCrusher.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["CrushedTrunks"], 1)
        self:updateStat(spec.advancedStatistics["CrushedLitres"], volume * 1000 * splitType.woodChipsPerLiter)
    end
    superFunc(self, splitType, volume, ...)
end

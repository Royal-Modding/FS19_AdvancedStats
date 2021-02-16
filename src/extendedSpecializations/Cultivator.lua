---${title}

---@author ${author}
---@version r_version_r
---@date 28/10/2020

ExtendedCultivator = {}
ExtendedCultivator.MOD_NAME = g_currentModName
ExtendedCultivator.SPEC_TABLE_NAME = string.format("spec_%s.extendedCultivator", ExtendedCultivator.MOD_NAME)

function ExtendedCultivator.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedCultivator.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedCultivator)
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing", ExtendedCultivator)
end

function ExtendedCultivator:onLoadStats()
    local spec = self[ExtendedCultivator.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Cultivator"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"WorkedHectares", AdvancedStats.UNITS.HECTARE}
        }
    )
end

function ExtendedCultivator:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local lastStatsArea = self.spec_cultivator.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local spec = self[ExtendedCultivator.SPEC_TABLE_NAME]
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)
        end
    end
end

---${title}

---@author ${author}
---@version r_version_r
---@date 29/10/2020

---@class ExtendedPlow : AdvancedStatsExtendedSpecialization
---@field spec_plow any
ExtendedPlow = {}
ExtendedPlow.MOD_NAME = g_currentModName
ExtendedPlow.SPEC_TABLE_NAME = string.format("spec_%s.extendedPlow", ExtendedPlow.MOD_NAME)

function ExtendedPlow.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedPlow.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedPlow)
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing", ExtendedPlow)
end

function ExtendedPlow:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedPlow.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Plow"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"WorkedHectares", AdvancedStats.UNITS.HECTARE},
                {"CreatedHectares", AdvancedStats.UNITS.HECTARE}
            }
        )
    end
end

function ExtendedPlow:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local lastStatsArea = self.spec_plow.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local spec = self:getAdvancedStatsSpecTable(ExtendedPlow.SPEC_TABLE_NAME)
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)
            if not self.spec_plow.workAreaParameters.limitToField then
                self:updateStat(spec.advancedStatistics["CreatedHectares"], ha)
            end
        end
    end
end

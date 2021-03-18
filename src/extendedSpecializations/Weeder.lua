---${title}

---@author ${author}
---@version r_version_r
---@date 14/11/2020

---@class ExtendedWeeder : AdvancedStatsExtendedSpecialization
---@field spec_weeder any
ExtendedWeeder = {}
ExtendedWeeder.MOD_NAME = g_currentModName
ExtendedWeeder.SPEC_TABLE_NAME = string.format("spec_%s.extendedWeeder", ExtendedWeeder.MOD_NAME)

function ExtendedWeeder.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedWeeder.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedWeeder)
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing", ExtendedWeeder)
end

function ExtendedWeeder:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedWeeder.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Weeder"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"WorkedHectares", AdvancedStats.UNITS.AREA}
            }
        )
    end
end

function ExtendedWeeder:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local lastStatsArea = self.spec_weeder.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local spec = self:getAdvancedStatsSpecTable(ExtendedWeeder.SPEC_TABLE_NAME)
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)
        end
    end
end

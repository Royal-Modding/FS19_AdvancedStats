--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 14/11/2020

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
    local spec = self[ExtendedWeeder.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Weeder"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"WorkedHectares", AdvancedStats.UNITS.HECTARE}
        }
    )
end

function ExtendedWeeder:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local lastStatsArea = self.spec_weeder.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local spec = self[ExtendedWeeder.SPEC_TABLE_NAME]
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)
        end
    end
end

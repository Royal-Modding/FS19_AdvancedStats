---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

---@class ExtendedSowingMachine : AdvancedStatsExtendedSpecialization
---@field spec_sowingMachine any
---@field getVehicleDamage fun(): number
ExtendedSowingMachine = {}
ExtendedSowingMachine.MOD_NAME = g_currentModName
ExtendedSowingMachine.SPEC_TABLE_NAME = string.format("spec_%s.extendedSowingMachine", ExtendedSowingMachine.MOD_NAME)

function ExtendedSowingMachine.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedSowingMachine.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedSowingMachine)
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing", ExtendedSowingMachine)
end

function ExtendedSowingMachine:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedSowingMachine.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "SowingMachine"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"WorkedHectares", AdvancedStats.UNITS.AREA},
                {"UsedSeeds", AdvancedStats.UNITS.VOLUME_GRAINS}
            }
        )
    end
end

function ExtendedSowingMachine:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local lastStatsArea = self.spec_sowingMachine.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local spec = self:getAdvancedStatsSpecTable(ExtendedSowingMachine.SPEC_TABLE_NAME)
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)

            local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(self.spec_sowingMachine.workAreaParameters.seedsFruitType)
            local lastHa = MathUtil.areaToHa(self.spec_sowingMachine.workAreaParameters.lastChangedArea, g_currentMission:getFruitPixelsToSqm())
            local usage = fruitDesc.seedUsagePerSqm * lastHa * 10000

            local damage = self:getVehicleDamage()
            if damage > 0 then
                usage = usage * (1 + damage * SowingMachine.DAMAGED_USAGE_INCREASE)
            end

            self:updateStat(spec.advancedStatistics["UsedSeeds"], usage)
        end
    end
end

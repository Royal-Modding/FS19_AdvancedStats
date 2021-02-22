---${title}

---@author ${author}
---@version r_version_r
---@date 03/11/2020

---@class ExtendedMotorized : AdvancedStatsExtendedSpecialization
---@field spec_motorized any
---@field lastMovedDistance number
---@field getIsMotorStarted fun(): boolean
ExtendedMotorized = {}
ExtendedMotorized.MOD_NAME = g_currentModName
ExtendedMotorized.SPEC_TABLE_NAME = string.format("spec_%s.extendedMotorized", ExtendedMotorized.MOD_NAME)

function ExtendedMotorized.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedMotorized.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedMotorized)
    SpecializationUtil.registerEventListener(vehicleType, "onUpdate", ExtendedMotorized)
end

function ExtendedMotorized:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedMotorized.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Motorized"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"UsedFuel", AdvancedStats.UNITS.LITRE},
                {"UsedDef", AdvancedStats.UNITS.LITRE},
                {"TraveledDistance", AdvancedStats.UNITS.KILOMETRE}
            }
        )
    end
end

function ExtendedMotorized:onUpdate(dt)
    if self.isServer and self:getIsMotorStarted() then
        local spec = self:getAdvancedStatsSpecTable(ExtendedMotorized.SPEC_TABLE_NAME)
        local usedFuel = (self.spec_motorized.lastFuelUsage * dt) / (1000 * 60 * 60)
        local usedDef = (self.spec_motorized.lastDefUsage * dt) / (1000 * 60 * 60)
        self:updateStat(spec.advancedStatistics["UsedFuel"], usedFuel)
        self:updateStat(spec.advancedStatistics["UsedDef"], usedDef)
        self:updateStat(spec.advancedStatistics["TraveledDistance"], self.lastMovedDistance * 0.001)
    end
end

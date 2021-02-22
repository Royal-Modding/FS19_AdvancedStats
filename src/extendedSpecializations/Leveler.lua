---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

---@class ExtendedLeveler : AdvancedStatsExtendedSpecialization
ExtendedLeveler = {}
ExtendedLeveler.MOD_NAME = g_currentModName
ExtendedLeveler.SPEC_TABLE_NAME = string.format("spec_%s.extendedLeveler", ExtendedLeveler.MOD_NAME)

function ExtendedLeveler.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedLeveler.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedLeveler)
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged", ExtendedLeveler)
end

function ExtendedLeveler:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedLeveler.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Leveler"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"MovedLiters", AdvancedStats.UNITS.LITRE}
            }
        )
    end
end

function ExtendedLeveler:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isServer and appliedDelta > 0 then
        local spec = self:getAdvancedStatsSpecTable(ExtendedLeveler.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["MovedLiters"], appliedDelta)
    end
end

---${title}

---@author ${author}
---@version r_version_r
---@date 23/11/2020

---@class ExtendedShovel : AdvancedStatsExtendedSpecialization
ExtendedShovel = {}
ExtendedShovel.MOD_NAME = g_currentModName
ExtendedShovel.SPEC_TABLE_NAME = string.format("spec_%s.extendedShovel", ExtendedShovel.MOD_NAME)

function ExtendedShovel.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedShovel.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedShovel)
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged", ExtendedShovel)
end

function ExtendedShovel:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedShovel.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Shovel"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"LoadedLiters", AdvancedStats.UNITS.VOLUME}
            }
        )
    end
end

function ExtendedShovel:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isServer and appliedDelta > 0 then
        local spec = self:getAdvancedStatsSpecTable(ExtendedShovel.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["LoadedLiters"], appliedDelta)
    end
end

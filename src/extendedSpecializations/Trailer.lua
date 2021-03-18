---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

---@class ExtendedTrailer : AdvancedStatsExtendedSpecialization
ExtendedTrailer = {}
ExtendedTrailer.MOD_NAME = g_currentModName
ExtendedTrailer.SPEC_TABLE_NAME = string.format("spec_%s.extendedTrailer", ExtendedTrailer.MOD_NAME)

function ExtendedTrailer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedTrailer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedTrailer)
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged", ExtendedTrailer)
end

function ExtendedTrailer:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedTrailer.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Trailer"

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

function ExtendedTrailer:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isServer and appliedDelta > 0 then
        local spec = self:getAdvancedStatsSpecTable(ExtendedTrailer.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["LoadedLiters"], appliedDelta)
    end
end

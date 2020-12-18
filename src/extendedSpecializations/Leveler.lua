--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

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
    local spec = self[ExtendedLeveler.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Leveler"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"MovedLiters", AdvancedStats.UNITS.LITRE}
        }
    )
end

function ExtendedLeveler:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isServer and appliedDelta > 0 then
        local spec = self[ExtendedLeveler.SPEC_TABLE_NAME]
        self:updateStat(spec.advancedStatistics["MovedLiters"], appliedDelta)
    end
end

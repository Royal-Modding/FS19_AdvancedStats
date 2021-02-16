---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

ExtendedConveyorBelt = {}
ExtendedConveyorBelt.MOD_NAME = g_currentModName
ExtendedConveyorBelt.SPEC_TABLE_NAME = string.format("spec_%s.extendedConveyorBelt", ExtendedConveyorBelt.MOD_NAME)

function ExtendedConveyorBelt.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedConveyorBelt.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedConveyorBelt)
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged", ExtendedConveyorBelt)
end

function ExtendedConveyorBelt:onLoadStats()
    local spec = self[ExtendedConveyorBelt.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "ConveyorBelt"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"MovedLiters", AdvancedStats.UNITS.LITRE}
        }
    )
end

function ExtendedConveyorBelt:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isServer and appliedDelta > 0 then
        local spec = self[ExtendedConveyorBelt.SPEC_TABLE_NAME]
        self:updateStat(spec.advancedStatistics["MovedLiters"], appliedDelta)
    end
end

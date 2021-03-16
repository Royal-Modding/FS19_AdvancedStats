---${title}

---@author ${author}
---@version r_version_r
---@date 16/03/2021

---@class ExtendedFillTriggerVehicle : AdvancedStatsExtendedSpecialization
ExtendedFillTriggerVehicle = {}
ExtendedFillTriggerVehicle.MOD_NAME = g_currentModName
ExtendedFillTriggerVehicle.SPEC_TABLE_NAME = string.format("spec_%s.extendedFillTriggerVehicle", ExtendedFillTriggerVehicle.MOD_NAME)

function ExtendedFillTriggerVehicle.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedFillTriggerVehicle.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedFillTriggerVehicle)
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged", ExtendedFillTriggerVehicle)
end

function ExtendedFillTriggerVehicle:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedFillTriggerVehicle.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "FillTriggerVehicle"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"LoadedLiters", AdvancedStats.UNITS.LITRE}
            }
        )
    end
end

function ExtendedFillTriggerVehicle:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isServer and appliedDelta > 0 then
        local spec = self:getAdvancedStatsSpecTable(ExtendedFillTriggerVehicle.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["LoadedLiters"], appliedDelta)
    end
end

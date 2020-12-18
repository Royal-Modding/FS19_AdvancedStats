--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

ExtendedBaler = {}
ExtendedBaler.MOD_NAME = g_currentModName
ExtendedBaler.SPEC_TABLE_NAME = string.format("spec_%s.extendedBaler", ExtendedBaler.MOD_NAME)

function ExtendedBaler.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedBaler.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedBaler)
    SpecializationUtil.registerEventListener(vehicleType, "onFillUnitFillLevelChanged", ExtendedBaler)
end

function ExtendedBaler.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "dropBale", ExtendedBaler.dropBale)
end

function ExtendedBaler:onLoadStats()
    local spec = self[ExtendedBaler.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Baler"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"BaleCount", AdvancedStats.UNITS.ND},
            {"LoadedLiters", AdvancedStats.UNITS.LITRE}
        }
    )
end

function ExtendedBaler:dropBale(superFunc,...)
    superFunc(self, ...)
    if self.isServer then
        local spec = self[ExtendedBaler.SPEC_TABLE_NAME]
        self:updateStat(spec.advancedStatistics["BaleCount"], 1)
    end
end

function ExtendedBaler:onFillUnitFillLevelChanged(fillUnitIndex, fillLevelDelta, fillTypeIndex, toolType, fillPositionData, appliedDelta)
    if self.isServer and appliedDelta > 0 then
        local spec = self[ExtendedBaler.SPEC_TABLE_NAME]
        self:updateStat(spec.advancedStatistics["LoadedLiters"], appliedDelta)
    end
end

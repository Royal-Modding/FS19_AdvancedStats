--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

ExtendedBaleWrapper = {}
ExtendedBaleWrapper.MOD_NAME = g_currentModName
ExtendedBaleWrapper.SPEC_TABLE_NAME = string.format("spec_%s.extendedBaleWrapper", ExtendedBaleWrapper.MOD_NAME)

function ExtendedBaleWrapper.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedBaleWrapper.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedBaleWrapper)
end

function ExtendedBaleWrapper.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "pickupWrapperBale", ExtendedBaleWrapper.pickupWrapperBale)
end

function ExtendedBaleWrapper:onLoadStats()
    local spec = self[ExtendedBaleWrapper.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "BaleWrapper"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"WrappedBales", AdvancedStats.UNITS.ND}
        }
    )
end

function ExtendedBaleWrapper:pickupWrapperBale(superFunc, ...)
    superFunc(self, ...)
    if self.isServer then
        local spec = self[ExtendedBaleWrapper.SPEC_TABLE_NAME]
        self:updateStat(spec.advancedStatistics["WrappedBales"], 1)
    end
end

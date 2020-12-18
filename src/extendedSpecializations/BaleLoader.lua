--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

ExtendedBaleLoader = {}
ExtendedBaleLoader.MOD_NAME = g_currentModName
ExtendedBaleLoader.SPEC_TABLE_NAME = string.format("spec_%s.extendedBaleLoader", ExtendedBaleLoader.MOD_NAME)

function ExtendedBaleLoader.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedBaleLoader.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedBaleLoader)
end

function ExtendedBaleLoader.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "pickupBale", ExtendedBaleLoader.pickupBale)
end

function ExtendedBaleLoader:onLoadStats()
    local spec = self[ExtendedBaleLoader.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "BaleLoader"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"LoadedBales", AdvancedStats.UNITS.ND}
        }
    )
end

function ExtendedBaleLoader:pickupBale(superFunc, ...)
    superFunc(self, ...)
    if self.isServer then
        local spec = self[ExtendedBaleLoader.SPEC_TABLE_NAME]
        self:updateStat(spec.advancedStatistics["LoadedBales"], 1)
    end
end

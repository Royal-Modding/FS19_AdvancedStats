---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

---@class ExtendedBaleWrapper : AdvancedStatsExtendedSpecialization
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
    local spec = self:getAdvancedStatsSpecTable(ExtendedBaleWrapper.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "BaleWrapper"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"WrappedBales", AdvancedStats.UNITS.ND}
            }
        )
    end
end

function ExtendedBaleWrapper:pickupWrapperBale(superFunc, bale, baleType, ...)
    superFunc(self, bale, baleType, ...)
    if self.isServer and baleType ~= nil and bale.i3dFilename ~= baleType.wrapperBaleFilename then
        local spec = self:getAdvancedStatsSpecTable(ExtendedBaleWrapper.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["WrappedBales"], 1)
    end
end

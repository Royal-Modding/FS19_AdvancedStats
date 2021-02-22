---${title}

---@author ${author}
---@version r_version_r
---@date 23/11/2020

---@class ExtendedStumpCutter : AdvancedStatsExtendedSpecialization
ExtendedStumpCutter = {}
ExtendedStumpCutter.MOD_NAME = g_currentModName
ExtendedStumpCutter.SPEC_TABLE_NAME = string.format("spec_%s.extendedStumpCutter", ExtendedStumpCutter.MOD_NAME)

function ExtendedStumpCutter.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedStumpCutter.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedStumpCutter)
end

function ExtendedStumpCutter.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "crushSplitShape", ExtendedStumpCutter.crushSplitShape)
end

function ExtendedStumpCutter:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedStumpCutter.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "StumpCutter"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"StumpCutted", AdvancedStats.UNITS.ND}
            }
        )
    end
end

function ExtendedStumpCutter:crushSplitShape(superFunc, ...)
    superFunc(self, ...)
    if self.isServer then
        local spec = self:getAdvancedStatsSpecTable(ExtendedStumpCutter.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["StumpCutted"], 1)
    end
end

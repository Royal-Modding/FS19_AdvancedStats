---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

---@class ExtendedCombine : AdvancedStatsExtendedSpecialization
---@field spec_combine any
ExtendedCombine = {}
ExtendedCombine.MOD_NAME = g_currentModName
ExtendedCombine.SPEC_TABLE_NAME = string.format("spec_%s.extendedCombine", ExtendedCombine.MOD_NAME)

function ExtendedCombine.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedCombine.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedCombine)
end

function ExtendedCombine.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "addWorkedAreaStat", ExtendedCombine.addWorkedAreaStat)
end

function ExtendedCombine.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "processCombineSwathArea", ExtendedCombine.processCombineSwathArea)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addCutterArea", ExtendedCombine.addCutterArea)
end

function ExtendedCombine:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedCombine.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Combine"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"ThreshedLiters", AdvancedStats.UNITS.LITRE},
                {"SwathLiters", AdvancedStats.UNITS.LITRE},
                {"WorkedHectares", AdvancedStats.UNITS.HECTARE}
            }
        )
    end
end

function ExtendedCombine:addWorkedAreaStat(hectares)
    if self.isServer then
        local spec = self:getAdvancedStatsSpecTable(ExtendedCombine.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["WorkedHectares"], hectares)
    end
end

function ExtendedCombine:addCutterArea(superFunc, ...)
    local threshedLiters = superFunc(self, ...)
    if self.isServer then
        local spec = self:getAdvancedStatsSpecTable(ExtendedCombine.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["ThreshedLiters"], threshedLiters)
    end
    return threshedLiters
end

function ExtendedCombine:processCombineSwathArea(superFunc, ...)
    local areas = superFunc(self, ...)
    if self.isServer and self.spec_combine.isSwathActive and self.spec_combine.workAreaParameters.droppedLiters > 0 then
        local spec = self:getAdvancedStatsSpecTable(ExtendedCombine.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["SwathLiters"], self.spec_combine.workAreaParameters.droppedLiters)
    end
    return areas
end

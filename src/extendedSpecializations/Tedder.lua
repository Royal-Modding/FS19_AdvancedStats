---${title}

---@author ${author}
---@version r_version_r
---@date 14/11/2020

---@class ExtendedTedder : AdvancedStatsExtendedSpecialization
---@field spec_tedder any
ExtendedTedder = {}
ExtendedTedder.MOD_NAME = g_currentModName
ExtendedTedder.SPEC_TABLE_NAME = string.format("spec_%s.extendedTedder", ExtendedTedder.MOD_NAME)

function ExtendedTedder.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedTedder.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedTedder)
end

function ExtendedTedder.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "processTedderArea", ExtendedTedder.processTedderArea)
end

function ExtendedTedder:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedTedder.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Tedder"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"WorkedLitres", AdvancedStats.UNITS.VOLUME, true},
                {"WorkedHectares", AdvancedStats.UNITS.AREA, true}
            }
        )
    end
end

function ExtendedTedder:processTedderArea(superFunc, ...)
    local realArea = superFunc(self, ...)
    if self.isServer and realArea > 0 then
        local spec = self:getAdvancedStatsSpecTable(ExtendedTedder.SPEC_TABLE_NAME)
        local ha = MathUtil.areaToHa(realArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
        self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)
        self:updateStat(spec.advancedStatistics["WorkedLitres"], self.spec_tedder.lastDroppedLiters)
    end
    return realArea, realArea
end

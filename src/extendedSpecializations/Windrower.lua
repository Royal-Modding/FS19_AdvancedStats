---${title}

---@author ${author}
---@version r_version_r
---@date 14/11/2020

---@class ExtendedWindrower : AdvancedStatsExtendedSpecialization
ExtendedWindrower = {}
ExtendedWindrower.MOD_NAME = g_currentModName
ExtendedWindrower.SPEC_TABLE_NAME = string.format("spec_%s.extendedWindrower", ExtendedWindrower.MOD_NAME)

function ExtendedWindrower.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedWindrower.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedWindrower)
end

function ExtendedWindrower.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "processWindrowerArea", ExtendedWindrower.processWindrowerArea)
end

function ExtendedWindrower:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedWindrower.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Windrower"

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

function ExtendedWindrower:processWindrowerArea(superFunc, ...)
    local lastDroppedLiters, realArea = superFunc(self, ...)
    if self.isServer and realArea > 0 then
        local spec = self:getAdvancedStatsSpecTable(ExtendedWindrower.SPEC_TABLE_NAME)
        local ha = MathUtil.areaToHa(realArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
        self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)
        self:updateStat(spec.advancedStatistics["WorkedLitres"], lastDroppedLiters)
    end
    return lastDroppedLiters, realArea
end

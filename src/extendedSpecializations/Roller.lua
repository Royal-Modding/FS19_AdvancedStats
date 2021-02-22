---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

---@class ExtendedRoller : AdvancedStatsExtendedSpecialization
ExtendedRoller = {}
ExtendedRoller.MOD_NAME = g_currentModName
ExtendedRoller.SPEC_TABLE_NAME = string.format("spec_%s.extendedRoller", ExtendedRoller.MOD_NAME)

function ExtendedRoller.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedRoller.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedRoller)
end

function ExtendedRoller.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "processRollerArea", ExtendedRoller.processRollerArea)
end

function ExtendedRoller:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedRoller.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Roller"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"RolledHectares", AdvancedStats.UNITS.HECTARE}
            }
        )
    end
end

function ExtendedRoller:processRollerArea(superFunc, ...)
    local realArea = superFunc(self, ...)
    if self.isServer and realArea > 0 then
        local spec = self:getAdvancedStatsSpecTable(ExtendedRoller.SPEC_TABLE_NAME)
        local ha = MathUtil.areaToHa(realArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
        self:updateStat(spec.advancedStatistics["RolledHectares"], ha)
    end
    return realArea, realArea
end

---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

ExtendedCutter = {}
ExtendedCutter.MOD_NAME = g_currentModName
ExtendedCutter.SPEC_TABLE_NAME = string.format("spec_%s.extendedCutter", ExtendedCutter.MOD_NAME)

function ExtendedCutter.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedCutter.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedCutter)
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing", ExtendedCutter)
end

function ExtendedCutter:onLoadStats()
    local spec = self[ExtendedCutter.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Cutter"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"WorkedHectares", AdvancedStats.UNITS.HECTARE}
        }
    )
end

function ExtendedCutter:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local lastStatsArea = self.spec_cutter.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local spec = self[ExtendedCutter.SPEC_TABLE_NAME]
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)
            if self.spec_cutter.workAreaParameters.combineVehicle.addWorkedAreaStat ~= nil then
                self.spec_cutter.workAreaParameters.combineVehicle:addWorkedAreaStat(ha)
            end
        end
    end
end

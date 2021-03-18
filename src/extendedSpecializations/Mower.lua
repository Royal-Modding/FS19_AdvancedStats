---${title}

---@author ${author}
---@version r_version_r
---@date 14/11/2020

---@class ExtendedMower : AdvancedStatsExtendedSpecialization
---@field spec_mower any
ExtendedMower = {}
ExtendedMower.MOD_NAME = g_currentModName
ExtendedMower.SPEC_TABLE_NAME = string.format("spec_%s.extendedMower", ExtendedMower.MOD_NAME)

function ExtendedMower.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedMower.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedMower)
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing", ExtendedMower)
end

function ExtendedMower:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedMower.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Mower"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"WorkedLitres", AdvancedStats.UNITS.VOLUME, true},
                {"WorkedHectares", AdvancedStats.UNITS.AREA}
            }
        )
    end
end

function ExtendedMower:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local totalToDrop = 0
        for _, dropArea in ipairs(self.spec_mower.dropAreas) do
            totalToDrop = totalToDrop + dropArea.litersToDrop
        end

        local newTotalToDrop = 0
        for _, dropArea in ipairs(self.spec_mower.dropAreas) do
            newTotalToDrop = newTotalToDrop + dropArea.litersToDrop
        end

        local spec = self:getAdvancedStatsSpecTable(ExtendedMower.SPEC_TABLE_NAME)
        self:updateStat(spec.advancedStatistics["WorkedLitres"], totalToDrop - newTotalToDrop)

        local lastStatsArea = self.spec_mower.workAreaParameters.lastStatsArea
        if lastStatsArea > 0 then
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)
        end
    end
end

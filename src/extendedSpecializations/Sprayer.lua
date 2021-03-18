---${title}

---@author ${author}
---@version r_version_r
---@date 23/11/2020

---@class ExtendedSprayer : AdvancedStatsExtendedSpecialization
---@field spec_sprayer any
ExtendedSprayer = {}
ExtendedSprayer.MOD_NAME = g_currentModName
ExtendedSprayer.SPEC_TABLE_NAME = string.format("spec_%s.extendedSprayer", ExtendedSprayer.MOD_NAME)

function ExtendedSprayer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedSprayer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onPreLoad", ExtendedSprayer)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedSprayer)
    SpecializationUtil.registerEventListener(vehicleType, "onEndWorkAreaProcessing", ExtendedSprayer)
end

function ExtendedSprayer:onPreLoad()
    if self.isServer then
        local spec = self:getAdvancedStatsSpecTable(ExtendedSprayer.SPEC_TABLE_NAME)
        spec.fillTypeToHectaresStat = {}
        spec.fillTypeToHectaresStat[FillType.HERBICIDE] = "HerbicideHectares"
        spec.fillTypeToHectaresStat[FillType.FERTILIZER] = "FertilizerHectares"
        spec.fillTypeToHectaresStat[FillType.LIQUIDFERTILIZER] = "LiquidFertilizerHectares"
        spec.fillTypeToHectaresStat[FillType.LIME] = "LimeHectares"
        spec.fillTypeToHectaresStat[FillType.MANURE] = "ManureHectares"
        spec.fillTypeToHectaresStat[FillType.LIQUIDMANURE] = "LiquidManureHectares"
        spec.fillTypeToHectaresStat[FillType.DIGESTATE] = "DigestateHectares"

        spec.fillTypeToUsedStat = {}
        spec.fillTypeToUsedStat[FillType.HERBICIDE] = "UsedHerbicide"
        spec.fillTypeToUsedStat[FillType.FERTILIZER] = "UsedFertilizer"
        spec.fillTypeToUsedStat[FillType.LIQUIDFERTILIZER] = "UsedLiquidFertilizer"
        spec.fillTypeToUsedStat[FillType.LIME] = "UsedLime"
        spec.fillTypeToUsedStat[FillType.MANURE] = "UsedManure"
        spec.fillTypeToUsedStat[FillType.LIQUIDMANURE] = "UsedLiquidManure"
        spec.fillTypeToUsedStat[FillType.DIGESTATE] = "UsedDigestate"
    end
end

function ExtendedSprayer:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedSprayer.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "Sprayer"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"WorkedHectares", AdvancedStats.UNITS.AREA, true},
                {"UsedLitres", AdvancedStats.UNITS.VOLUME, true},
                {"UsedHerbicide", AdvancedStats.UNITS.VOLUME_LIQUIDS},
                {"HerbicideHectares", AdvancedStats.UNITS.AREA},
                {"UsedFertilizer", AdvancedStats.UNITS.VOLUME},
                {"FertilizerHectares", AdvancedStats.UNITS.AREA},
                {"UsedLiquidFertilizer", AdvancedStats.UNITS.VOLUME_LIQUIDS},
                {"LiquidFertilizerHectares", AdvancedStats.UNITS.AREA},
                {"UsedLime", AdvancedStats.UNITS.VOLUME},
                {"LimeHectares", AdvancedStats.UNITS.AREA},
                {"UsedManure", AdvancedStats.UNITS.VOLUME},
                {"ManureHectares", AdvancedStats.UNITS.AREA},
                {"UsedLiquidManure", AdvancedStats.UNITS.VOLUME_LIQUIDS},
                {"LiquidManureHectares", AdvancedStats.UNITS.AREA},
                {"UsedDigestate", AdvancedStats.UNITS.VOLUME_LIQUIDS},
                {"DigestateHectares", AdvancedStats.UNITS.AREA}
            }
        )
    end
end

function ExtendedSprayer:onEndWorkAreaProcessing(dt)
    if self.isServer then
        local lastStatsArea = self.spec_sprayer.workAreaParameters.lastStatsArea
        local usage = self.spec_sprayer.workAreaParameters.usage
        local fillType = self.spec_sprayer.workAreaParameters.sprayFillType
        if self.spec_sprayer.workAreaParameters.isActive then
            local spec = self:getAdvancedStatsSpecTable(ExtendedSprayer.SPEC_TABLE_NAME)

            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            self:updateStat(spec.advancedStatistics["WorkedHectares"], ha)

            self:updateStat(spec.advancedStatistics["UsedLitres"], usage)

            if spec.fillTypeToHectaresStat[fillType] ~= nil then
                self:updateStat(spec.advancedStatistics[spec.fillTypeToHectaresStat[fillType]], ha)
            end

            if spec.fillTypeToUsedStat[fillType] ~= nil then
                self:updateStat(spec.advancedStatistics[spec.fillTypeToUsedStat[fillType]], usage)
            end
        end
    end
end

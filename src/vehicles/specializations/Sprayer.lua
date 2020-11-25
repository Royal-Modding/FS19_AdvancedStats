--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 23/11/2020

SprayerExtension = {}
SprayerExtension.advancedStatisticsPrefix = "Sprayer"
SprayerExtension.advancedStatistics = {
    {"WorkedHectares", AdvancedStats.UNITS.HECTARE, true},
    {"UsedLitres", AdvancedStats.UNITS.LITRE, true},
    {"UsedHerbicide", AdvancedStats.UNITS.LITRE},
    {"HerbicideHectares", AdvancedStats.UNITS.HECTARE},
    {"UsedFertilizer", AdvancedStats.UNITS.LITRE},
    {"FertilizerHectares", AdvancedStats.UNITS.HECTARE},
    {"UsedLiquidFertilizer", AdvancedStats.UNITS.LITRE},
    {"LiquidFertilizerHectares", AdvancedStats.UNITS.HECTARE},
    {"UsedLime", AdvancedStats.UNITS.LITRE},
    {"LimeHectares", AdvancedStats.UNITS.HECTARE},
    {"UsedManure", AdvancedStats.UNITS.LITRE},
    {"ManureHectares", AdvancedStats.UNITS.HECTARE},
    {"UsedLiquidManure", AdvancedStats.UNITS.LITRE},
    {"LiquidManureHectares", AdvancedStats.UNITS.HECTARE},
    {"UsedDigestate", AdvancedStats.UNITS.LITRE},
    {"DigestateHectares", AdvancedStats.UNITS.HECTARE}
}

function SprayerExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    SprayerExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(SprayerExtension.advancedStatisticsPrefix, SprayerExtension.advancedStatistics)
end

if g_server ~= nil then
    function SprayerExtension:onEndWorkAreaProcessing(superFunc, dt, hasProcessed)
        local spec = self.spec_sprayer
        local lastStatsArea = spec.workAreaParameters.lastStatsArea
        local usage = spec.workAreaParameters.usage
        local fillType = spec.workAreaParameters.sprayFillType
        if spec.workAreaParameters.isActive then
            local ha = MathUtil.areaToHa(lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m

            g_advancedStatsManager.updateStatistic(self, SprayerExtension.advancedStatistics["WorkedHectares"], ha)
            g_advancedStatsManager.updateStatistic(self, SprayerExtension.advancedStatistics["UsedLitres"], usage)

            if SprayerExtension.fillTypeToHectaresStat[fillType] ~= nil then
                g_advancedStatsManager.updateStatistic(self, SprayerExtension.advancedStatistics[SprayerExtension.fillTypeToHectaresStat[fillType]], ha)
            end

            if SprayerExtension.fillTypeToUsedStat[fillType] ~= nil then
                g_advancedStatsManager.updateStatistic(self, SprayerExtension.advancedStatistics[SprayerExtension.fillTypeToUsedStat[fillType]], usage)
            end
        end
        superFunc(self, dt, hasProcessed)
    end
    Sprayer.onEndWorkAreaProcessing = Utils.overwrittenFunction(Sprayer.onEndWorkAreaProcessing, SprayerExtension.onEndWorkAreaProcessing)

    function SprayerExtension:onLoad(superFunc, savegame)
        superFunc(self, savegame)
        if SprayerExtension.fillTypeToHectaresStat == nil then
            SprayerExtension.fillTypeToHectaresStat = {}
            SprayerExtension.fillTypeToHectaresStat[FillType.HERBICIDE] = "HerbicideHectares"
            SprayerExtension.fillTypeToHectaresStat[FillType.FERTILIZER] = "FertilizerHectares"
            SprayerExtension.fillTypeToHectaresStat[FillType.LIQUIDFERTILIZER] = "LiquidFertilizerHectares"
            SprayerExtension.fillTypeToHectaresStat[FillType.LIME] = "LimeHectares"
            SprayerExtension.fillTypeToHectaresStat[FillType.MANURE] = "ManureHectares"
            SprayerExtension.fillTypeToHectaresStat[FillType.LIQUIDMANURE] = "LiquidManureHectares"
            SprayerExtension.fillTypeToHectaresStat[FillType.DIGESTATE] = "DigestateHectares"
        end
        if SprayerExtension.fillTypeToUsedStat == nil then
            SprayerExtension.fillTypeToUsedStat = {}
            SprayerExtension.fillTypeToUsedStat[FillType.HERBICIDE] = "UsedHerbicide"
            SprayerExtension.fillTypeToUsedStat[FillType.FERTILIZER] = "UsedFertilizer"
            SprayerExtension.fillTypeToUsedStat[FillType.LIQUIDFERTILIZER] = "UsedLiquidFertilizer"
            SprayerExtension.fillTypeToUsedStat[FillType.LIME] = "UsedLime"
            SprayerExtension.fillTypeToUsedStat[FillType.MANURE] = "UsedManure"
            SprayerExtension.fillTypeToUsedStat[FillType.LIQUIDMANURE] = "UsedLiquidManure"
            SprayerExtension.fillTypeToUsedStat[FillType.DIGESTATE] = "UsedDigestate"
        end
    end
    Sprayer.onLoad = Utils.overwrittenFunction(Sprayer.onLoad, SprayerExtension.onLoad)
end

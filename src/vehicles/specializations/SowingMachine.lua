--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

SowingMachineExtension = {}
SowingMachineExtension.advancedStatisticsPrefix = "SowingMachine"
SowingMachineExtension.advancedStatistics = {{"WorkedHectares", AdvancedStats.UNITS.HECTARE}, {"UsedSeeds", AdvancedStats.UNITS.LITRE}}

function SowingMachineExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    SowingMachineExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(SowingMachineExtension.advancedStatisticsPrefix, SowingMachineExtension.advancedStatistics)
end

if g_server ~= nil then
    function SowingMachineExtension:onEndWorkAreaProcessing(superFunc, dt, hasProcessed)
        superFunc(self, dt, hasProcessed)
        local spec = self.spec_sowingMachine
        if spec.workAreaParameters.lastStatsArea > 0 then
            local ha = MathUtil.areaToHa(spec.workAreaParameters.lastStatsArea, g_currentMission:getFruitPixelsToSqm()) -- 4096px are mapped to 2048m
            g_advancedStatsManager.updateStatistic(self, SowingMachineExtension.advancedStatistics["WorkedHectares"], ha)

            local fruitDesc = g_fruitTypeManager:getFruitTypeByIndex(spec.workAreaParameters.seedsFruitType)
            local lastHa = MathUtil.areaToHa(spec.workAreaParameters.lastChangedArea, g_currentMission:getFruitPixelsToSqm())
            local usage = fruitDesc.seedUsagePerSqm * lastHa * 10000

            local damage = self:getVehicleDamage()
            if damage > 0 then
                usage = usage * (1 + damage * SowingMachine.DAMAGED_USAGE_INCREASE)
            end

            g_advancedStatsManager.updateStatistic(self, SowingMachineExtension.advancedStatistics["UsedSeeds"], usage)
        end
    end
    SowingMachine.onEndWorkAreaProcessing = Utils.overwrittenFunction(SowingMachine.onEndWorkAreaProcessing, SowingMachineExtension.onEndWorkAreaProcessing)
end

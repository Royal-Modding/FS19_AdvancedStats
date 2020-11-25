--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 03/11/2020

MotorizedExtension = {}
MotorizedExtension.advancedStatisticsPrefix = "Motorized"
MotorizedExtension.advancedStatistics = {{"UsedFuel", AdvancedStats.UNITS.LITRE}, {"UsedDef", AdvancedStats.UNITS.LITRE}, {"TraveledDistance", AdvancedStats.UNITS.KILOMETRE}}

function MotorizedExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    MotorizedExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(MotorizedExtension.advancedStatisticsPrefix, MotorizedExtension.advancedStatistics)
end

if g_server ~= nil then
    function MotorizedExtension:updateConsumers(superFunc, dt, accInput)
        superFunc(self, dt, accInput)
        local spec = self.spec_motorized
        local usedFuel = (spec.lastFuelUsage * dt) / (1000 * 60 * 60)
        g_advancedStatsManager.updateStatistic(self, MotorizedExtension.advancedStatistics["UsedFuel"], usedFuel)
        local usedDef = (spec.lastDefUsage * dt) / (1000 * 60 * 60)
        g_advancedStatsManager.updateStatistic(self, MotorizedExtension.advancedStatistics["UsedDef"], usedDef)
    end
    Motorized.updateConsumers = Utils.overwrittenFunction(Motorized.updateConsumers, MotorizedExtension.updateConsumers)

    function MotorizedExtension:onUpdate(superFunc, dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
        superFunc(self, dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
        g_advancedStatsManager.updateStatistic(self, MotorizedExtension.advancedStatistics["TraveledDistance"], self.lastMovedDistance * 0.001)
    end
    Motorized.onUpdate = Utils.overwrittenFunction(Motorized.onUpdate, MotorizedExtension.onUpdate)
end

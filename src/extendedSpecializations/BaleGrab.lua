---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

---@class ExtendedBaleGrab : AdvancedStatsExtendedSpecialization
---@field spec_baleGrab any
ExtendedBaleGrab = {}
ExtendedBaleGrab.MOD_NAME = g_currentModName
ExtendedBaleGrab.SPEC_TABLE_NAME = string.format("spec_%s.extendedBaleGrab", ExtendedBaleGrab.MOD_NAME)

function ExtendedBaleGrab.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedBaleGrab.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedBaleGrab)
end

function ExtendedBaleGrab.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addDynamicMountedObject", ExtendedBaleGrab.addDynamicMountedObject)
end

function ExtendedBaleGrab:onLoadStats()
    local spec = self:getAdvancedStatsSpecTable(ExtendedBaleGrab.SPEC_TABLE_NAME)

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "BaleGrab"

    if self.isServer then
        spec.advancedStatistics =
            self:registerStats(
            spec.advancedStatisticsPrefix,
            {
                {"GrabbedBales", AdvancedStats.UNITS.ND}
            }
        )
    end
end

function ExtendedBaleGrab:addDynamicMountedObject(superFunc, object, ...)
    if self.isServer then
        if self.spec_baleGrab.dynamicMountedObjects[object] == nil then
            local spec = self:getAdvancedStatsSpecTable(ExtendedBaleGrab.SPEC_TABLE_NAME)
            -- TODO: Improve it, if the bale is not grabbed correctly will be counted many times
            self:updateStat(spec.advancedStatistics["GrabbedBales"], 1)
        end
        superFunc(self, object, ...)
    end
end

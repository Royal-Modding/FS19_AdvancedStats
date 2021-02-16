---${title}

---@author ${author}
---@version r_version_r
---@date 04/11/2020

ExtendedLivestockTrailer = {}
ExtendedLivestockTrailer.MOD_NAME = g_currentModName
ExtendedLivestockTrailer.SPEC_TABLE_NAME = string.format("spec_%s.extendedLivestockTrailer", ExtendedLivestockTrailer.MOD_NAME)

function ExtendedLivestockTrailer.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AdvancedStats, specializations)
end

function ExtendedLivestockTrailer.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoadStats", ExtendedLivestockTrailer)
end

function ExtendedLivestockTrailer.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "addAnimal", ExtendedLivestockTrailer.addAnimal)
end

function ExtendedLivestockTrailer:onLoadStats()
    local spec = self[ExtendedLivestockTrailer.SPEC_TABLE_NAME]

    spec.hasAdvancedStats = true
    spec.advancedStatisticsPrefix = "LivestockTrailer"

    spec.advancedStatistics =
        self:registerStats(
        spec.advancedStatisticsPrefix,
        {
            {"LoadedAnimals", AdvancedStats.UNITS.ND}
        }
    )
end

function ExtendedLivestockTrailer:addAnimal(superFunc, animal, ...)
    if self.isServer then
        local place = self.spec_livestockTrailer.animalTypeToPlaces[animal.subType.type]
        local used = place.numUsed
        superFunc(self, animal, ...)
        if place.numUsed > used then
            local spec = self[ExtendedLivestockTrailer.SPEC_TABLE_NAME]
            self:updateStat(spec.advancedStatistics["LoadedAnimals"], 1)
        end
    else
        superFunc(self, animal, ...)
    end
end

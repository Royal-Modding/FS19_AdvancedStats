--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 04/11/2020

LivestockTrailerExtension = {}
LivestockTrailerExtension.advancedStatisticsPrefix = "LivestockTrailer"
LivestockTrailerExtension.advancedStatistics = {{"LoadedAnimals", AdvancedStats.UNITS.ND}}

function LivestockTrailerExtension:initSpecialization(superFunc)
    if superFunc ~= nil then
        superFunc()
    end
    LivestockTrailerExtension.advancedStatistics = g_advancedStatsManager:registerStatistics(LivestockTrailerExtension.advancedStatisticsPrefix, LivestockTrailerExtension.advancedStatistics)
end

if g_server ~= nil then
    function LivestockTrailerExtension:addAnimal(superFunc, animal)
        local place = self.spec_livestockTrailer.animalTypeToPlaces[animal.subType.type]
        local used = place.numUsed
        superFunc(self, animal)
        if place.numUsed > used then
            g_advancedStatsManager.updateStatistic(self, LivestockTrailerExtension.advancedStatistics["LoadedAnimals"], 1)
        end
    end
    LivestockTrailer.addAnimal = Utils.overwrittenFunction(LivestockTrailer.addAnimal, LivestockTrailerExtension.addAnimal)
end

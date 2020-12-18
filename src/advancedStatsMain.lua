--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 16/12/2020

InitRoyalMod(Utils.getFilename("lib/rmod/", g_currentModDirectory))
InitRoyalUtility(Utils.getFilename("lib/utility/", g_currentModDirectory))
InitRoyalHud(Utils.getFilename("lib/hud/", g_currentModDirectory))

AdvancedStatsMain = RoyalMod.new(r_debug_r, false)

function AdvancedStatsMain:onValidateVehicleTypes(vehicleTypeManager, addSpecialization, addSpecializationBySpecialization, addSpecializationByVehicleType, addSpecializationByFunction)
    addSpecialization("advancedStats")

    addSpecializationBySpecialization("extendedBaleGrab", "baleGrab")
    addSpecializationBySpecialization("extendedBaleLoader", "baleLoader")
    addSpecializationBySpecialization("extendedBaler", "baler")
    addSpecializationBySpecialization("extendedBaleWrapper", "baleWrapper")
    addSpecializationBySpecialization("extendedCombine", "combine")
    addSpecializationBySpecialization("extendedConveyorBelt", "conveyorBelt")
    addSpecializationBySpecialization("extendedCultivator", "cultivator")
    addSpecializationBySpecialization("extendedCutter", "cutter")
    addSpecializationBySpecialization("extendedLeveler", "leveler")
    addSpecializationBySpecialization("extendedLivestockTrailer", "livestockTrailer")
    addSpecializationBySpecialization("extendedMotorized", "motorized")
    addSpecializationBySpecialization("extendedMower", "mower")
    addSpecializationBySpecialization("extendedPlow", "plow")
    addSpecializationBySpecialization("extendedRoller", "roller")
    addSpecializationBySpecialization("extendedSowingMachine", "sowingMachine")
    addSpecializationBySpecialization("extendedSprayer", "sprayer")
    addSpecializationBySpecialization("extendedStumpCutter", "stumpCutter")
    addSpecializationBySpecialization("extendedTedder", "tedder")
    addSpecializationBySpecialization("extendedTrailer", "trailer")
    addSpecializationBySpecialization("extendedTreePlanter", "treePlanter")
    addSpecializationBySpecialization("extendedWeeder", "weeder")
    addSpecializationBySpecialization("extendedWindrower", "windrower")
    addSpecializationBySpecialization("extendedWoodCrusher", "woodCrusher")
    addSpecializationBySpecialization("extendedWoodHarvester", "woodHarvester")

    addSpecializationByVehicleType("extendedShovel", "shovel")
end

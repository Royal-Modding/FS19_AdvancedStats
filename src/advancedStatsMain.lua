---${title}

---@author ${author}
---@version r_version_r
---@date 16/12/2020

InitRoyalMod(Utils.getFilename("lib/rmod/", g_currentModDirectory))
InitRoyalUtility(Utils.getFilename("lib/utility/", g_currentModDirectory))
InitRoyalHud(Utils.getFilename("lib/hud/", g_currentModDirectory))

AdvancedStatsMain = RoyalMod.new(r_debug_r, false)

function AdvancedStatsMain:initialize()
    local g_advancedStats = {
        exportListeners = {},
        userProfileDirectory = self.userProfileDirectory,
        addExportListener = function(this, object)
            table.insert(this.exportListeners, object)
        end,
        onExportAllVehiclesStats = function(this)
            this:exportVehiclesStats(this.exportListeners)
        end,
        onExportOwnVehiclesStats = function(this)
            local farmId = g_currentMission.player.farmId
            this:exportVehiclesStats(
                TableUtility.f_filter(
                    this.exportListeners,
                    function(v)
                        return v:getOwnerFarmId() == farmId
                    end
                )
            )
        end,
        exportVehiclesStats = function(this, vehicles)
            local statsTable = {}
            for _, v in pairs(vehicles) do
                for key, _ in pairs(v:getStats()) do
                    table.insert(statsTable, key)
                end
            end
            local file = io.open(Utils.getFilename("advancedStatsExport.tsv", this.userProfileDirectory), "w")
            file:write("Vehicle_Name")
            for _, key in pairs(statsTable) do
                file:write(string.format("\t%s_Total\t%s_Partial", key, key))
            end
            file:write("\n")

            for _, v in pairs(vehicles) do
                file:write(v:getName())
                for _, key in pairs(statsTable) do
                    local t = 0
                    local p = 0
                    local stat = v:getStat(key)
                    if stat ~= nil then
                        t = stat.total
                        p = stat.partial
                    end
                    file:write(string.format("\t%s\t%s", t, p))
                end
                file:write("\n")
            end

            file:close()
        end
    }
    addConsoleCommand("asExportAllStats", "Export stats of all vehicles.", "onExportAllVehiclesStats", g_advancedStats)
    addConsoleCommand("asExportOwnStats", "Export stats of own vehicles.", "onExportOwnVehiclesStats", g_advancedStats)
    self.gameEnv["g_advancedStats"] = g_advancedStats
    self.modEnv["g_advancedStats"] = g_advancedStats
end

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

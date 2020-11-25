--
-- ${title}
--
-- @author ${author}
-- @version ${version}
-- @date 28/10/2020

AdvancedStats = {}
AdvancedStats.name = g_currentModName
AdvancedStats.directory = g_currentModDirectory
AdvancedStats.modEnv = getfenv()
AdvancedStats.gameEnv = getfenv(0)
AdvancedStats.extendedSpecializations = {
    "Cultivator",
    "Plow",
    "Motorized",
    "BaleGrab",
    "BaleLoader",
    "Baler",
    "BaleWrapper",
    "Combine",
    "Cutter",
    "ConveyorBelt",
    "Trailer",
    "Leveler",
    "LivestockTrailer",
    "Roller",
    "SowingMachine",
    "WoodHarvester",
    "WoodCrusher",
    "Windrower",
    "Weeder",
    "Tedder",
    "Mower",
    "TreePlanter",
    "StumpCutter",
    "Sprayer",
    "Shovel"
}
AdvancedStats.UNITS = {}
AdvancedStats.UNITS["ND"] = 0
AdvancedStats.UNITS["HECTARE"] = 1
AdvancedStats.UNITS["LITRE"] = 2
AdvancedStats.UNITS["KILOMETRE"] = 3

local advancedStatsManager = AdvancedStatsManager:new(AdvancedStats.name, AdvancedStats.directory, AdvancedStats.gameEnv, AdvancedStats.modEnv, AdvancedStats.extendedSpecializations)
advancedStatsManager:load()
AdvancedStats.gameEnv["g_advancedStatsManager"] = advancedStatsManager
AdvancedStats.modEnv["g_advancedStatsManager"] = advancedStatsManager

InitRoyalUtility(Utils.getFilename("lib/utility/", g_currentModDirectory))
InitRoyalHud(Utils.getFilename("lib/hud/", g_currentModDirectory))

function AdvancedStats:loadMap()
    AdvancedStats.hud = StatsHud:new()
end

function AdvancedStats:loadSavegame()
end

function AdvancedStats:saveSavegame()
end

function AdvancedStats:update(dt)
end

function AdvancedStats:mouseEvent(posX, posY, isDown, isUp, button)
end

function AdvancedStats:keyEvent(unicode, sym, modifier, isDown)
end

function AdvancedStats:draw()
end

function AdvancedStats:delete()
end

function AdvancedStats:deleteMap()
end

function AdvancedStats:getAttachedImplementsRecursively(vehicle)
    local vehicles = {}
    local function addVehicle(v)
        table.insert(vehicles, v)
        if v.getAttachedImplements ~= nil then
            for _, impl in pairs(v:getAttachedImplements()) do
                addVehicle(impl.object)
            end
        end
    end
    addVehicle(vehicle)
    return vehicles
end

function AdvancedStats:getFullVehicleName(vehicle)
    local name = vehicle:getName()
    local storeItem = g_storeManager:getItemByXMLFilename(vehicle.configFileName)
    if storeItem ~= nil then
        local brand = g_brandManager:getBrandByIndex(storeItem.brandIndex)
        if brand ~= nil then
            local tempName = string.format("%s %s", brand.title, name)
            if string.len(tempName) <= 22 then
                name = tempName
            end
        end
    end
    return name
end

function AdvancedStats:getUnitText(unit)
    local text = ""
    if unit ~= nil and unit ~= AdvancedStats.UNITS.ND then
        text = " " .. g_i18n:getText(string.format("ass_Units_%d", unit))
    end
    return text
end

function AdvancedStats:formatValue(value, unit)
    if unit == AdvancedStats.UNITS.HECTARE then
        return string.format("%.3f%s", value, self:getUnitText(unit))
    end
    if unit == AdvancedStats.UNITS.KILOMETRE then
        return string.format("%.2f%s", value, self:getUnitText(unit))
    end
    if unit == AdvancedStats.UNITS.LITRE then
        return string.format("%.1f%s", value, self:getUnitText(unit))
    end
    return string.format("%s%s", value, self:getUnitText(unit))
end

function AdvancedStats:vehicleHasStatsToShow(vehicle)
    if vehicle.advancedStats ~= nil then
        for _, value in pairs(vehicle.advancedStats) do
            if value > 0 then
                return true
            end
        end
    end
    return false
end

addModEventListener(AdvancedStats)

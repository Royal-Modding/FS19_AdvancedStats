---${title}

---@author ${author}
---@version r_version_r
---@date 16/12/2020

AdvancedStatsUtil = {}

function AdvancedStatsUtil.getVehicleAndAttachments(vehicle)
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

function AdvancedStatsUtil.getVehicleHasAdvancedStats(vehicle)
    return vehicle.getHasAdvancedStats ~= nil and vehicle:getHasAdvancedStats()
end

function AdvancedStatsUtil.getFullVehicleName(vehicle)
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

function AdvancedStatsUtil.formatStatValueText(value, unit)
    if unit == AdvancedStats.UNITS.AREA then
        return string.format("%.3f%s", value, AdvancedStatsUtil.getUnitText(unit))
    end
    if unit == AdvancedStats.UNITS.LENGTH then
        return string.format("%.2f%s", value, AdvancedStatsUtil.getUnitText(unit))
    end
    if unit == AdvancedStats.UNITS.VOLUME then
        return string.format("%.1f%s", value, AdvancedStatsUtil.getUnitText(unit))
    end
    return string.format("%s%s", value, AdvancedStatsUtil.getUnitText(unit))
end

function AdvancedStatsUtil.getUnitText(unit)
    local text = ""
    if unit ~= nil and unit ~= AdvancedStats.UNITS.ND then
        text = " " .. g_i18n:getText(string.format("ass_Units_%d", unit))
    end
    return text
end

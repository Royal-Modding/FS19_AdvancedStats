---${title}

---@author ${author}
---@version r_version_r
---@date 23/11/2020

---@class StatsHud : RoyalHudControl
---@field superClass fun(): any
StatsHud = {}
StatsHud.style = {
    separatorColor = {1, 1, 1, 0.3},
    textHighlightColor = {0.991, 0.3865, 0.01, 1},
    textDefaultColor = {1, 1, 1, 1},
    width = 350,
    rowHeight = 26,
    topBottomPadding = 24,
    leftRightPadding = 48,
    titleSize = 20,
    textSize = 16
}
StatsHud.DUBUG_COLOR = {1, 0, 1, 1}
StatsHud_mt = Class(StatsHud, RoyalHudControl)

---@return StatsHud statsHud stats hud instace
function StatsHud:new()
    local width, height = StatsHud.style.width, 200
    local style = RoyalHudStyles.getStyle(StatsStyle, FS19Style)
    local xOffset = g_safeFrameOffsetX

    ---@type StatsHud
    local hud = RoyalHudControl:new("StatsHud", 1 - xOffset, 0 + g_safeFrameOffsetY, width, height, style, nil, StatsHud_mt)
    hud.guidanceSteeringXOffset = self:getNormalizedSize(54, 54)[1]
    hud:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_RIGHT)
    hud.panel = RoyalHudTitledPanel:new("StatsHudPanel", 0.5, 0.5, width, height, style, hud)
    hud.panel:setForceUpperCase(true)
    hud.partialStatsPanelTitle = g_i18n:getText("ass_PANEL_TITLE_2")
    hud.statsPanelTitle = g_i18n:getText("ass_PANEL_TITLE_1")

    hud.rowContainer = RoyalHud:new("rc", 0.5, 0.5, width - StatsHud.style.leftRightPadding, 200 - StatsHud.style.topBottomPadding, hud)

    hud.rows = {}
    hud.freeRows = {}
    hud:createRow(hud.rowContainer)
    hud:createRow(hud.rowContainer)
    hud:createRow(hud.rowContainer)
    hud:createRow(hud.rowContainer)
    hud:createRow(hud.rowContainer)

    hud.yOffsetVH = self:getNormalizedPosition(0, SpeedMeterDisplay.POSITION.DAMAGE_LEVEL_ICON[2])[2] + (self:getNormalizedPosition(0, SpeedMeterDisplay.SIZE.DAMAGE_LEVEL_ICON[2])[2] * 1.75)
    return hud
end

function StatsHud:getRenderPosition()
    local x, y = StatsHud:superClass().getRenderPosition(self)
    -- hud offset to prevent overlap with vhicle hud and guidance steering
    local xOffset = 0
    if g_guidanceSteering ~= nil then
        xOffset = xOffset - self.guidanceSteeringXOffset
    end
    return x + (xOffset * self.uiScale), y + (self.yOffsetVH * self.uiScale)
end

function StatsHud:setVehicleData(vehicles, showPartial)
    local displayData = {}
    for _, vehicle in pairs(vehicles) do
        if AdvancedStatsUtil.getVehicleHasAdvancedStats(vehicle) and vehicle:getHasStatsToShow(showPartial) then
            table.insert(displayData, {title = AdvancedStatsUtil.getFullVehicleName(vehicle):upper()})
            ---@type AdvancedStatistic
            for _, stat in pairs(vehicle:getStats()) do
                local value = stat.total
                if showPartial then
                    value = stat.partial
                end
                if value > 0 and not stat.hide then
                    table.insert(displayData, {title = stat.text, text = AdvancedStatsUtil.formatStatValueText(value, stat.unit)})
                end
            end
        end
    end
    if #displayData > 0 then
        self:setIsVisible(true)
        self:resetRows()
        if showPartial then
            self.panel:setTitle(self.partialStatsPanelTitle)
        else
            self.panel:setTitle(self.statsPanelTitle)
        end
        self:resizeY(#displayData)
        local posY = 0
        local h = StatsHud.style.rowHeight
        for i = #displayData, 1, -1 do
            local data = displayData[i]
            local row = self:getFreeRow()
            row.title:setText(data.title)
            row.text:setText(data.text or "")
            row:setPosition(nil, posY)
            row:setIsVisible(true)
            if data.text == nil then
                row.title:setOffset(1)
            else
                row.title:setOffset(6)
            end
            if posY == 0 then
                row.separator:setIsVisible(false)
            end
            posY = posY + h
        end
    else
        self:setIsVisible(false)
    end
end

function StatsHud:createRow(parent)
    ---@type RoyalHud
    local row = RoyalHud:new("row", 0, 0, StatsHud.style.width - StatsHud.style.leftRightPadding, StatsHud.style.rowHeight, parent)
    row:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    row.separator = RoyalHudOverlay:new("row_separator", 0, 0, StatsHud.style.width - StatsHud.style.leftRightPadding, 1, row)
    row.separator:setColor(StatsHud.style.separatorColor)
    row.separator:setAlignment(RoyalHud.ALIGNS_VERTICAL_MIDDLE, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    row.title = RoyalHudText:new("row_title", "Title", StatsHud.style.textSize, true, 0, 0, row)
    row.title:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    row.title:setColor(StatsHud.style.textDefaultColor)
    row.text = RoyalHudText:new("row_text", "Text", StatsHud.style.textSize, false, 1, 0, row)
    row.text:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_RIGHT)
    row.text:setColor(StatsHud.style.textDefaultColor)
    row.text:setOffset(-1)
    table.insert(self.rows, row)
    table.insert(self.freeRows, row)
    return row
end

function StatsHud:resetRows()
    self.freeRows = {}
    for _, row in ipairs(self.rows) do
        row:setIsVisible(false)
        table.insert(self.freeRows, row)
    end
end

function StatsHud:getFreeRow()
    if #self.freeRows < 1 then
        self:createRow(self.rowContainer)
    end
    return table.remove(self.freeRows)
end

function StatsHud:resizeY(rowsNumber)
    local neededY = (rowsNumber * StatsHud.style.rowHeight) + StatsHud.style.topBottomPadding
    self:setSize(nil, neededY)
    self.panel:setSize(nil, neededY)
    self.panel:setPosition(0.5, 0.5)
    self.rowContainer:setSize(nil, neededY - StatsHud.style.topBottomPadding)
    self.rowContainer:setPosition(0.5, 0.5)
end

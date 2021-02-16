--- Royal Hud

---@author Royal Modding
---@version 1.3.0.0
---@date 17/11/2020

--- RoyalHudTitledPanel class
---@class RoyalHudTitledPanel : RoyalHudPanel
RoyalHudTitledPanel = {}
RoyalHudTitledPanel_mt = Class(RoyalHudTitledPanel, RoyalHudPanel)

--- Create new hud panel with title
---@param name string name of the hud
---@param x number normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param y number normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param width number size in pixels
---@param height number size in pixels
---@param style? table style for thus control
---@param parent? table parent of the hud
---@return RoyalHudTitledPanel
function RoyalHudTitledPanel:new(name, x, y, width, height, style, parent, mt)
    ---@type RoyalHudTitledPanel
    local control = RoyalHudPanel:new(name, x, y, width, height, style, parent, mt or RoyalHudTitledPanel_mt)
    control.titleHud = RoyalHudText:new(name .. "_title", "", control.style.titledPanel.title.size, control.style.titledPanel.title.bold, 0, 1, control)
    control.titleHud:setAlignment(RoyalHud.ALIGNS_VERTICAL_BOTTOM, RoyalHud.ALIGNS_HORIZONTAL_LEFT)
    control.titleHud:setIsVisible(false)
    control.titleHud:setOffset(control.style.titledPanel.title.offset)
    control.title = ""
    control.forceUpper = false
    control:setForceUpperCase(control.style.titledPanel.title.forceUpper)
    return control
end

--- Set panel title
---@param title string title of panel
function RoyalHudTitledPanel:setTitle(title)
    if title ~= nil and title ~= "" then
        self.title = title
        self:forceUpperCase()
        self.titleHud:setText(self.title)
        self.titleHud:setIsVisible(true)
    else
        self.titleHud:setIsVisible(false)
    end
end

--- Set force upper case for panel title
---@param force boolean force?
function RoyalHudTitledPanel:setForceUpperCase(force)
    self.forceUpper = force
    self:setTitle(self.title)
end

--- Force upper case for panel title
function RoyalHudTitledPanel:forceUpperCase()
    if self.forceUpper then
        self.title = string.upper(self.title)
    end
end

--- Set the hud size
---@param width number @size in pixels
---@param height number @size in pixels
function RoyalHudTitledPanel:setSize(width, height)
    RoyalHudTitledPanel:superClass().setSize(self, width, height)
    if self.titleHud ~= nil then
        self.titleHud:setPosition(0, 1)
    end
end

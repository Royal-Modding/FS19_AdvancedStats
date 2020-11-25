--
-- Royal Hud
--
-- @author Royal Modding
-- @version 1.1.0.0
-- @date 10/11/2020

--- RoyalHudControl class
---@class RoyalHudControl : RoyalHud
RoyalHudControl = {}
RoyalHudControl_mt = Class(RoyalHudControl, RoyalHud)

--- Create new hud control
---@param name string @name of the hud
---@param x number @normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param y number @normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param width number @size in pixels
---@param height number @size in pixels
---@param style table|nil @style for thus control
---@param parent table|nil @parent of the hud
---@return RoyalHudControl
function RoyalHudControl:new(name, x, y, width, height, style, parent, mt)
    ---@type RoyalHudControl
    local control = RoyalHud:new(name, x, y, width, height, parent, mt or RoyalHudControl_mt)
    control.style = style or RoyalHudStyles.defaultStyle
    return control
end

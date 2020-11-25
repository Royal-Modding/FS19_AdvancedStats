--
-- Royal Hud
--
-- @author Royal Modding
-- @version 1.1.0.0
-- @date 11/11/2020

--- RoyalHudShadowText class
---@class RoyalHudShadowText : RoyalHudControl
RoyalHudShadowText = {}
RoyalHudShadowText_mt = Class(RoyalHudShadowText, RoyalHudControl)

--- Create new hud control
---@param name string @name of the hud
---@param text string @text to render
---@param size number @size of text
---@param bold boolean
---@param x number @normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param y number @normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param style table|nil @style for thus control
---@param parent table|nil @parent of the hud
---@return RoyalHudShadowText
function RoyalHudShadowText:new(name, text, size, bold, x, y, style, parent, mt)
    ---@type RoyalHudShadowText
    local control = RoyalHudControl:new(name, x, y, 0, 0, style, parent, mt or RoyalHudShadowText_mt)
    control.shadow = RoyalHudText:new(name .. "_shadow", text, size, bold, x, y, control)
    control.shadow:setOffset(style.shadowText.shadow.offset)
    control.shadow:setColor(style.shadowText.shadow.color)
    control.text = RoyalHudText:new(name .. "_text", text, size, bold, x, y, control)
    return control
end

--- Set text color
---@param r number|number[]
---@param g number|nil
---@param b number|nil
---@param a number|nil @alpha transparence
function RoyalHudShadowText:setTextColor(r, g, b, a)
    if type(r) == "table" then
        r = r[1] or 1
        g = r[2] or 1
        b = r[3] or 1
        a = r[4] or 1
    else
        r = r or 1
        g = g or 1
        b = b or 1
        a = a or 1
    end
    self.text:setColor(r, g, b, a)
end

--- Set shadow color
---@param r number|number[]
---@param g number|nil
---@param b number|nil
---@param a number|nil @alpha transparence
function RoyalHudShadowText:setShadowColor(r, g, b, a)
    if type(r) == "table" then
        r = r[1] or 0
        g = r[2] or 0
        b = r[3] or 0
        a = r[4] or 1
    else
        r = r or 0
        g = g or 0
        b = b or 0
        a = a or 1
    end
    self.shadow:setColor(r, g, b, a)
end

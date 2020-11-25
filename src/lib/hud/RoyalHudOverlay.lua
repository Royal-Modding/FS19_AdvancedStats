--
-- Royal Hud
--
-- @author Royal Modding
-- @version 1.1.0.0
-- @date 09/11/2020

--- RoyalHudOverlay class
---@class RoyalHudOverlay : RoyalHud
RoyalHudOverlay = {}
RoyalHudOverlay_mt = Class(RoyalHudOverlay, RoyalHud)

RoyalHudOverlay.DUBUG_COLOR = {1, 0, 0, 0.6}

--- Create new hud overlay
---@param name string @name of the hud
---@param x number @normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param y number @normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param width number @size in pixels
---@param height number @size in pixels
---@param parent table|nil @parent of the hud
---@return RoyalHudOverlay
function RoyalHudOverlay:new(name, x, y, width, height, parent, mt)
    ---@type RoyalHudOverlay
    local hud = RoyalHud:new(name, x, y, width, height, parent, mt or RoyalHudOverlay_mt)
    hud.overlayId = createImageOverlay(g_baseUIFilename)
    setOverlayUVs(hud.overlayId, unpack(g_colorBgUVs))
    return hud
end

--- Delete the overlay
---@param doNotApplyToChilds boolean
function RoyalHudOverlay:delete(doNotApplyToChilds)
    delete(self.overlayId)
    RoyalHudOverlay:superClass().delete(self, doNotApplyToChilds)
end

--- Render the overlay
---@param doNotApplyToChilds boolean
function RoyalHudOverlay:render(doNotApplyToChilds)
    if self.visible then
        local x, y = self:getRenderPosition()
        local w, h = self:getRenderSize()
        renderOverlay(self.overlayId, x, y, w, h)
    end
    RoyalHudOverlay:superClass().render(self, doNotApplyToChilds)
end

--- Set the overlay color
---@param r number|number[]
---@param g number|nil
---@param b number|nil
---@param a number|nil @alpha transparence
function RoyalHudOverlay:setColor(r, g, b, a)
    RoyalHudOverlay:superClass().setColor(self, r, g, b, a)
    setOverlayColor(self.overlayId, self.r, self.g, self.b, self.a)
end

--- Set the overlay color
---@param rotation number @rotation angle
---@param centerX number @rotation center x
---@param centerY number @rotation center y
function RoyalHudOverlay:setRotation(rotation, centerX, centerY)
    if self.rotation ~= rotation or self.rotationCenterX ~= centerX or self.rotationCenterY ~= centerY then
        self.rotation = rotation
        self.rotationCenterX = centerX
        self.rotationCenterY = centerY
        setOverlayRotation(self.overlayId, rotation, centerX, centerY)
    end
end

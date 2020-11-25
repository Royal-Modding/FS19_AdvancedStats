--
-- Royal Hud
--
-- @author Royal Modding
-- @version 1.1.0.0
-- @date 10/11/2020

--- RoyalHudImage class
---@class RoyalHudImage : RoyalHud
RoyalHudImage = {}
RoyalHudImage_mt = Class(RoyalHudImage, RoyalHud)

RoyalHudImage.DUBUG_COLOR = {0, 0, 1, 0.6}

--- Create new hud image
---@param name string @name of the hud
---@param path string @image path
---@param x number @normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param y number @normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param width number @size in pixels
---@param height number @size in pixels
---@param parent table|nil @parent of the hud
---@return RoyalHudImage
function RoyalHudImage:new(name, path, x, y, width, height, parent, mt)
    ---@type RoyalHudImage
    local hud = RoyalHud:new(name, x, y, width, height, parent, mt or RoyalHudImage_mt)
    hud.filename = path or g_baseUIFilename
    hud.overlayId = createImageOverlay(hud.filename)
    return hud
end

--- Delete the image
---@param doNotApplyToChilds boolean
function RoyalHudImage:delete(doNotApplyToChilds)
    if self.overlayId ~= 0 then
        delete(self.overlayId)
        self.overlayId = 0
    end
    RoyalHudImage:superClass().delete(self, doNotApplyToChilds)
end

--- Render the image
---@param doNotApplyToChilds boolean
function RoyalHudImage:render(doNotApplyToChilds)
    if self.visible and self.overlayId ~= 0 then
        local x, y = self:getRenderPosition()
        local w, h = self:getRenderSize()
        renderOverlay(self.overlayId, x, y, w, h)
    end
    RoyalHudImage:superClass().render(self, doNotApplyToChilds)
end

--- Set the image color
---@param r number|number[]
---@param g number|nil
---@param b number|nil
---@param a number|nil @alpha transparence
function RoyalHudImage:setColor(r, g, b, a)
    RoyalHudImage:superClass().setColor(self, r, g, b, a)
    if self.overlayId ~= 0 then
        setOverlayColor(self.overlayId, self.r, self.g, self.b, self.a)
    end
end

--- Set the image UVs
---@param u number @x positon in pixels
---@param v number @y positon in pixels
---@param width number @size in pixel
---@param height number @size in pixel
---@param refSize table<number, number> @image resolution in pixels
function RoyalHudImage:setUVs(u, v, width, height, refSize)
    refSize = refSize or {1024, 1024}
    local uvs = getNormalizedValues({u, v, width, height}, refSize)
    self:setNormalizedUVs({uvs[1], 1 - uvs[2] - uvs[4], uvs[1], 1 - uvs[2], uvs[1] + uvs[3], 1 - uvs[2] - uvs[4], uvs[1] + uvs[3], 1 - uvs[2]})
end

--- Set the image UVs
---@param uvs number[]
function RoyalHudImage:setNormalizedUVs(uvs)
    if uvs ~= self.uvs then
        if self.overlayId ~= 0 then
            self.uvs = uvs
            setOverlayUVs(self.overlayId, unpack(self.uvs))
        end
    end
end

--- Set the image rotation
---@param rotation number @rotation angle
---@param centerX number @rotation center x
---@param centerY number @rotation center y
function RoyalHudImage:setRotation(rotation, centerX, centerY)
    if self.rotation ~= rotation or self.rotationCenterX ~= centerX or self.rotationCenterY ~= centerY then
        self.rotation = rotation
        self.rotationCenterX = centerX
        self.rotationCenterY = centerY
        if self.overlayId ~= 0 then
            setOverlayRotation(self.overlayId, rotation, centerX, centerY)
        end
    end
end

--- Set the image path
---@param path string @image path
function RoyalHudImage:setImage(path)
    path = path or g_baseUIFilename
    if self.filename ~= path then
        if self.overlayId ~= 0 then
            delete(self.overlayId)
        end
        self.filename = path
        self.overlayId = createImageOverlay(path)
    end
end

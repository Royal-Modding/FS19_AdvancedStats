--- Royal Hud

---@author Royal Modding
---@version 1.3.0.0
---@date 09/11/2020

--- RoyalHud class
---@class RoyalHud
RoyalHud = {}
RoyalHud_mt = Class(RoyalHud)

RoyalHud.ALIGNS_VERTICAL_BOTTOM = 1
RoyalHud.ALIGNS_VERTICAL_MIDDLE = 2
RoyalHud.ALIGNS_VERTICAL_TOP = 3

RoyalHud.ALIGNS_HORIZONTAL_LEFT = 4
RoyalHud.ALIGNS_HORIZONTAL_CENTER = 5
RoyalHud.ALIGNS_HORIZONTAL_RIGHT = 6

RoyalHud.DUBUG_COLOR = {1, 1, 0, 1}

--- Create new hud
---@param name string name of the hud
---@param x number normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param y number normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param width number size in pixels
---@param height number size in pixels
---@param parent? table parent of the hud
---@return RoyalHud
function RoyalHud:new(name, x, y, width, height, parent, mt)
    ---@type RoyalHud
    local hud = setmetatable({}, mt or RoyalHud_mt)
    hud.parent = nil
    hud.name = name or ""
    hud.id = StringUtility.random(20)
    hud.key = string.format("[%s]%s", hud.id, hud.name)
    hud.childs = {}
    hud.orderedChilds = {}
    if parent ~= nil then
        parent:addChild(hud)
    end
    hud.uiScale = g_gameSettings:getValue("uiScale")
    hud.verticalAlign = RoyalHud.ALIGNS_VERTICAL_MIDDLE
    hud.horizontalAlign = RoyalHud.ALIGNS_HORIZONTAL_CENTER
    hud.offsetX = 0
    hud.offsetY = 0
    hud.defaultWidth = width or 1
    hud.defaultHeight = height or 1
    hud:setSize(hud.defaultWidth, hud.defaultHeight)
    hud:setPosition(x or 0.5, y or 0.5)
    hud.r = 1
    hud.g = 1
    hud.b = 1
    hud.a = 1
    hud.visible = true
    return hud
end

--- Set the hud offset
---@param offsetX? number offset x as pixel value
---@param offsetY? number offset y as pixel value
---@overload fun(offsets:number[]) offsets array
function RoyalHud:setOffset(offsetX, offsetY)
    if type(offsetX) == "table" then
        offsetY = offsetX[2]
        offsetX = offsetX[1]
    end
    if offsetX ~= nil then
        self.offsetX = self:getNormalizedPosition(offsetX, 0)[1]
    end
    if offsetY ~= nil then
        self.offsetY = self:getNormalizedPosition(0, offsetY)[2]
    end
end

--- Set the hud position
---@param x number normalized (relative to parent) position if the value is between 0 and 1 otherwise a pixel value
---@param y number normalized (relative to parent) position if the value is between 0 and 1 otherwise a pixel value
function RoyalHud:setPosition(x, y)
    if x ~= nil then
        -- if pixel value
        if x > 1 or x < 0 then
            self.x = self:getNormalizedPosition(x, 0)[1]
            if self.parent ~= nil then
                -- positions must be scaled since they are relative to parent size
                self.x = self.x * self.uiScale
            end
        else
            -- if the value is already normalized, make it relative to parent
            if self.parent ~= nil then
                self.x = x * self.parent.width
            else
                self.x = x
            end
        end
    end

    if y ~= nil then
        -- if pixel value
        if y > 1 or y < 0 then
            self.y = self:getNormalizedPosition(0, y)[2]
            if self.parent ~= nil then
                -- positions must be scaled since they are relative to parent size
                self.y = self.y * self.uiScale
            end
        else
            -- if the value is already normalized, make it relative to parent
            if self.parent ~= nil then
                self.y = y * self.parent.height
            else
                self.y = y
            end
        end
    end
end

--- Set the hud size
---@param width number size in pixels
---@param height number size in pixels
function RoyalHud:setSize(width, height)
    if width ~= nil then
        self.width = self:getNormalizedSize(width, 0)[1]
        self.width = self.width * self.uiScale
    end

    if height ~= nil then
        self.height = self:getNormalizedSize(0, height)[2]
        self.height = self.height * self.uiScale
    end
end

--- Set the hud color
---@param r number red value
---@param g number green value
---@param b number blue value
---@param a number alpha transparence
---@overload fun(rgba:number[]):number,number,number,number rgba color array
---@return number r
---@return number g
---@return number b
---@return number a
function RoyalHud:setColor(r, g, b, a)
    if type(r) == "table" then
        self.r = r[1] or self.r
        self.g = r[2] or self.g
        self.b = r[3] or self.b
        self.a = r[4] or self.a
    else
        self.r = r or self.r
        self.g = g or self.g
        self.b = b or self.b
        self.a = a or self.a
    end
    return self.r, self.g, self.b, self.a
end

--- Set the hud alignment
---@param vertical number | "RoyalHud.ALIGNS_VERTICAL_BOTTOM" | "RoyalHud.ALIGNS_VERTICAL_MIDDLE" | "RoyalHud.ALIGNS_VERTICAL_TOP" vertical alignment
---@param horizontal number | "RoyalHud.ALIGNS_HORIZONTAL_LEFT" | "RoyalHud.ALIGNS_HORIZONTAL_CENTER" | "RoyalHud.ALIGNS_HORIZONTAL_RIGHT" horizontal alignment
function RoyalHud:setAlignment(vertical, horizontal)
    self.verticalAlign = vertical or self.verticalAlign
    self.horizontalAlign = horizontal or self.horizontalAlign
end

--- Delete the hud
---@param doNotApplyToChilds boolean don't call on childerns
function RoyalHud:delete(doNotApplyToChilds)
    for _, c in ipairs(self.orderedChilds) do
        if not doNotApplyToChilds then
            c:delete(doNotApplyToChilds)
        else
            c.parent = nil
        end
    end
end

--- Reset the hud size
---@param doNotApplyToChilds boolean don't call on childerns
function RoyalHud:resetSize(doNotApplyToChilds)
    self:setSize(self.defaultWidth, self.defaultHeight)
    if not doNotApplyToChilds then
        for _, c in ipairs(self.orderedChilds) do
            c:resetSize(doNotApplyToChilds)
        end
    end
end

--- Set the hud visibility
---@param visible boolean visible?
---@param doNotApplyToChilds boolean don't call on childerns
function RoyalHud:setIsVisible(visible, doNotApplyToChilds)
    self.visible = visible
    if not doNotApplyToChilds then
        for _, c in ipairs(self.orderedChilds) do
            c:setIsVisible(visible, doNotApplyToChilds)
        end
    end
end

--- Set the hud debug state
---@param debug boolean debug enabled?
---@param doNotApplyToChilds boolean don't call on childerns
function RoyalHud:setDebug(debug, doNotApplyToChilds)
    self.debug = debug or false
    if not doNotApplyToChilds then
        for _, c in ipairs(self.orderedChilds) do
            c:setIsVisible(debug, doNotApplyToChilds)
        end
    end
end

--- Render the hud
---@param doNotApplyToChilds boolean don't call on childerns
function RoyalHud:render(doNotApplyToChilds)
    if self.debug or g_uiDebugEnabled then
        self:renderDebug()
    end
    if not doNotApplyToChilds then
        for _, c in ipairs(self.orderedChilds) do
            c:render(doNotApplyToChilds)
        end
    end
end

--- Update the hud
---@param dt number delta time
---@param doNotApplyToChilds boolean don't call on childerns
function RoyalHud:update(dt, doNotApplyToChilds)
    if not doNotApplyToChilds then
        for _, c in ipairs(self.orderedChilds) do
            c:update(dt, doNotApplyToChilds)
        end
    end
end

--- Additional debug renderings for the hud
function RoyalHud:renderDebug()
    local xPixel = 1 / g_screenWidth
    local yPixel = 1 / g_screenHeight

    local x, y = self:getRenderPosition()
    local w, h = self:getRenderSize()

    setOverlayColor(GuiElement.debugOverlay, self.DUBUG_COLOR[1], self.DUBUG_COLOR[2], self.DUBUG_COLOR[3], self.DUBUG_COLOR[4])

    renderOverlay(GuiElement.debugOverlay, x - xPixel, y - yPixel, w + 2 * xPixel, yPixel)
    renderOverlay(GuiElement.debugOverlay, x - xPixel, y + h, w + 2 * xPixel, yPixel)
    renderOverlay(GuiElement.debugOverlay, x - xPixel, y, xPixel, h)
    renderOverlay(GuiElement.debugOverlay, x + w, y, xPixel, h)
end

--- Add a child to the hud
---@param child RoyalHud child hud
function RoyalHud:addChild(child)
    if child.parent == nil then
        child.parent = self
        self.childs[child.key] = child
        table.insert(self.orderedChilds, child)
    end
end

--- Remove a child from the hud
---@param child RoyalHud child hud
function RoyalHud:removeChild(child)
    if child.parent ~= nil then
        child.parent = nil
    end
    self.childs[child.key] = nil
    TableUtility.f_remove(
        self.orderedChilds,
        function(c)
            return c.key == child.key
        end
    )
end

--- Get the hud alignment offset
---@return number x offset
---@return number y offset
function RoyalHud:getAlignmentOffset()
    local offsetX = 0
    local offsetY = 0

    if self.verticalAlign == RoyalHud.ALIGNS_VERTICAL_TOP then
        offsetY = -self.height
    elseif self.verticalAlign == RoyalHud.ALIGNS_VERTICAL_MIDDLE then
        offsetY = -self.height * 0.5
    end

    if self.horizontalAlign == RoyalHud.ALIGNS_HORIZONTAL_RIGHT then
        offsetX = -self.width
    elseif self.horizontalAlign == RoyalHud.ALIGNS_HORIZONTAL_CENTER then
        offsetX = -self.width * 0.5
    end

    return offsetX, offsetY
end

--- Get the hud rendering size
---@return number width size
---@return number height size
function RoyalHud:getRenderSize()
    return self.width, self.height
end

--- Get the hud rendering position
---@return number x horizontal position
---@return number y vertical position
function RoyalHud:getRenderPosition()
    local alignOffsetX, alignOffsetY = self:getAlignmentOffset()
    local x = self.x + self.offsetX + alignOffsetX
    local y = self.y + self.offsetY + alignOffsetY
    if self.parent ~= nil then
        local xP, yP = self.parent:getRenderPosition()
        x = x + xP
        y = y + yP
    end
    return x, y
end

--- Get normalized from pixels position
---@param x number x position in pixels at reference resolution (1920)
---@param y number y position in pixels at reference resolution (1080)
---@return number[] {x, y} position in pixels at actual resolution
function RoyalHud:getNormalizedPosition(x, y)
    local values = getNormalizedValues({x, y}, {g_referenceScreenWidth, g_referenceScreenHeight})
    return {values[1] * g_aspectScaleX, values[2] * g_aspectScaleY}
end

--- Get normalized from pixels size
---@param width number width in pixels at reference resolution (1920)
---@param height number height in pixels at reference resolution (1080)
---@return number[] {width, height} size in pixels at actual resolution
function RoyalHud:getNormalizedSize(width, height)
    local values = getNormalizedValues({width, height}, {g_referenceScreenWidth, g_referenceScreenHeight})
    return {values[1] * g_aspectScaleX, values[2] * g_aspectScaleY}
end

--- Royal Hud

---@author Royal Modding
---@version 1.3.0.0
---@date 11/11/2020

--- RoyalHudText class
---@class RoyalHudText : RoyalHud
---@field superClass fun(self:table):RoyalHud
RoyalHudText = {}
RoyalHudText_mt = Class(RoyalHudText, RoyalHud)

RoyalHudText.DUBUG_COLOR = {0, 1, 0, 0.6}
RoyalHudText.HIGH_CHARS_OFFSET = 0.2285714285714286

--- Create new hud text
---@param name string name of the hud
---@param text string text to render
---@param size number size of text
---@param bold boolean bold?
---@param x number normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param y number normalized (relative to parent) size if the value is between 0 and 1 otherwise a pixel value
---@param parent? table parent of the hud
---@return RoyalHudText
function RoyalHudText:new(name, text, size, bold, x, y, parent, mt)
    ---@type RoyalHudText
    local hud = RoyalHud:new(name, x, y, 0, 0, parent, mt or RoyalHudText_mt)
    hud.text = text or name
    hud.bold = bold or false
    hud.size = size or 10
    hud:setTextSize(hud.size)
    return hud
end

--- Render the text
---@param doNotApplyToChilds boolean don't call on childerns
function RoyalHudText:render(doNotApplyToChilds)
    if self.visible then
        local x, y = self:getRenderPosition()
        local _, h = self:getRenderSize()

        -- move text rendering higher to make "high chars" (q y p g j) fit into the text box
        y = y + (h * self.HIGH_CHARS_OFFSET)

        setTextBold(self.bold)
        setTextColor(self.r, self.g, self.b, self.a)
        setTextAlignment(RenderText.ALIGN_LEFT)
        renderText(x, y, self.size, self.text)
        setTextBold(false)
        setTextColor(1, 1, 1, 1)
    end
    RoyalHudText:superClass().render(self, doNotApplyToChilds)
end

--- Set the text size
---@param size number text size
function RoyalHudText:setTextSize(size)
    size = size or 20
    self.size = self:getNormalizedSize(0, size * self.uiScale)[2]
    self:setText(self.text)
end

--- Set the text
---@param text string text string
function RoyalHudText:setText(text)
    self.text = text
    setTextBold(self.bold)
    self.width = getTextWidth(self.size, self.text)
    self.height = getTextHeight(self.size, self.text)
    setTextBold(false)
    self:setAlignment(self.verticalAlign, self.horizontalAlign)
end

--- Avoid setSize inheritance
function RoyalHudText:setSize()
end

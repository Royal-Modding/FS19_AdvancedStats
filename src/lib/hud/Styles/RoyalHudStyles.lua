--
-- Royal Hud
--
-- @author Royal Modding
-- @version 1.1.0.0
-- @date 10/11/2020

--- RoyalHudStyles class
RoyalHudStyles = {}

--- Royal hud common type
---@class RoyalHudStyle
RoyalHudStyles.defaultStyle = {}
RoyalHudStyles.defaultStyle.panel = {}
RoyalHudStyles.defaultStyle.panel.bgColor = {0, 0, 0, 1}
RoyalHudStyles.defaultStyle.panel.borders = {}
RoyalHudStyles.defaultStyle.panel.borders["TOP"] = {}
RoyalHudStyles.defaultStyle.panel.borders["TOP"].color = {1, 1, 1, 1}
RoyalHudStyles.defaultStyle.panel.borders["TOP"].size = 5
RoyalHudStyles.defaultStyle.panel.borders["RIGHT"] = {}
RoyalHudStyles.defaultStyle.panel.borders["RIGHT"].color = {1, 1, 1, 1}
RoyalHudStyles.defaultStyle.panel.borders["RIGHT"].size = 5
RoyalHudStyles.defaultStyle.panel.borders["BOTTOM"] = {}
RoyalHudStyles.defaultStyle.panel.borders["BOTTOM"].color = {1, 1, 1, 1}
RoyalHudStyles.defaultStyle.panel.borders["BOTTOM"].size = 5
RoyalHudStyles.defaultStyle.panel.borders["LEFT"] = {}
RoyalHudStyles.defaultStyle.panel.borders["LEFT"].color = {1, 1, 1, 1}
RoyalHudStyles.defaultStyle.panel.borders["LEFT"].size = 5
RoyalHudStyles.defaultStyle.shadowText = {}
RoyalHudStyles.defaultStyle.shadowText.shadow = {}
RoyalHudStyles.defaultStyle.shadowText.shadow.color = {1, 1, 1, 0.75}
RoyalHudStyles.defaultStyle.shadowText.shadow.offset = {1, -1}
RoyalHudStyles.defaultStyle.titledPanel = {}
RoyalHudStyles.defaultStyle.titledPanel.title = {}
RoyalHudStyles.defaultStyle.titledPanel.title.size = 18
RoyalHudStyles.defaultStyle.titledPanel.title.bold = true
RoyalHudStyles.defaultStyle.titledPanel.title.offset = {0, 1}
RoyalHudStyles.defaultStyle.titledPanel.title.forceUpper = false

--- Get a style starting from another one
---@param style RoyalHudStyle|nil
---@param baseStyle RoyalHudStyle|nil
---@return RoyalHudStyle
function RoyalHudStyles.getStyle(style, baseStyle)
    local newStyle = Utility.clone(baseStyle or RoyalHudStyles.defaultStyle)
    if (style ~= nil) then
        Utility.overwrite(newStyle, style)
    end
    return newStyle
end

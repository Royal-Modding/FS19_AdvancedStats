--
-- Royal Hud
--
-- @author Royal Modding
-- @version 1.1.0.0
-- @date 10/11/2020

--- FS19Style class
---@type RoyalHudStyle
FS19Style = {}
FS19Style.colors = {}
FS19Style.colors["colorTransparent"] = {0, 0, 0, 0}
FS19Style.colors["colorGlass"] = {0.018, 0.016, 0.015, 0.6}
FS19Style.colors["colorGlass_50"] = {0.018, 0.016, 0.015, 0.25}
FS19Style.colors["colorGlassVeryLight"] = {0.718, 0.716, 0.715, 0.04}
FS19Style.colors["colorGlassExtremelyLight"] = {0.918, 0.916, 0.915, 0.15}
FS19Style.colors["colorGlassMedium"] = {0.118, 0.116, 0.115, 0.20}
FS19Style.colors["colorGlassDark"] = {0.018, 0.016, 0.015, 0.65}
FS19Style.colors["colorGlassLight"] = {0.718, 0.716, 0.715, 0.25}
FS19Style.colors["colorGlassLight_50"] = {0.718, 0.716, 0.715, 0.0625}
FS19Style.colors["colorGlassLight_75"] = {0.718, 0.716, 0.715, 0.09375}
FS19Style.colors["colorMainUI"] = {0.9910, 0.3865, 0.0100, 1}
FS19Style.colors["colorMainUIAlt"] = {0.9900, 0.4640, 0.0010, 1}
FS19Style.colors["colorDisabled"] = {0.4, 0.4, 0.4, 1}
FS19Style.colors["colorWhite"] = {1, 1, 1, 1}
FS19Style.colors["colorWhite_50"] = {1, 1, 1, 0.5}
FS19Style.colors["colorWhite_25"] = {1, 1, 1, 0.25}
FS19Style.colors["colorRed"] = {0.8069, 0.0097, 0.0097, 1}
FS19Style.colors["colorDarkRed"] = {0.2832, 0.0091, 0.0091, 1}
FS19Style.colors["colorBlue"] = {0.0742, 0.4341, 0.6939, 1}
FS19Style.colors["colorGreen"] = {0.3763, 0.6038, 0.0782, 1}
FS19Style.colors["colorGreen2"] = {0.2122, 0.5271, 0.0307, 1}
FS19Style.colors["colorBlack"] = {0, 0, 0, 1}
FS19Style.colors["colorBlack2"] = {0.0075, 0.0075, 0.0075, 1}
FS19Style.colors["colorBlack3"] = {0.013, 0.013, 0.013, 1}
FS19Style.colors["colorBlack3_97"] = {0.013, 0.013, 0.013, 0.97}
FS19Style.colors["colorBlack3_70"] = {0.013, 0.013, 0.013, 0.7}
FS19Style.colors["colorBlack3_0"] = {0.013, 0.013, 0.013, 0}
FS19Style.colors["colorDarkGrey"] = {0.0284, 0.0284, 0.0284, 1}
FS19Style.colors["colorDarkGrey_0"] = {0.0284, 0.0284, 0.0284, 0}
FS19Style.colors["colorDarkGrey2"] = {0.0630, 0.0630, 0.0630, 1}
FS19Style.colors["colorDarkGrey2_50"] = {0.0630, 0.0630, 0.0630, 0.5}
FS19Style.colors["colorDarkGrey2_70"] = {0.0630, 0.0630, 0.0630, 0.7}
FS19Style.colors["colorDarkGrey3"] = {0.0194, 0.0194, 0.0194, 1}
FS19Style.colors["colorDarkGrey4"] = {0.0723, 0.0723, 0.0723, 1}
FS19Style.colors["colorDarkGrey5"] = {0.1356, 0.1356, 0.1356, 1}
FS19Style.colors["colorDarkGrey6"] = {0.03, 0.03, 0.03, 1}
FS19Style.colors["colorDarkGrey7"] = {0.0212, 0.0212, 0.0212, 1}
FS19Style.colors["colorLightGrey"] = {0.0482, 0.0482, 0.0482, 1}
FS19Style.colors["colorDescriptionText"] = {0.2918, 0.2918, 0.2918, 1}
FS19Style.colors["colorDescriptionText2"] = {0.6, 0.6, 0.6, 1}
FS19Style.colors["colorDescriptionText3"] = {0.1845, 0.1845, 0.1845, 1}
FS19Style.colors["colorDescriptionText4"] = {0.6307, 0.6307, 0.6307, 1}
FS19Style.colors["colorTextShadow"] = {0.0630, 0.0630, 0.0630, 0.7}
FS19Style.panel = {}
FS19Style.panel.bgColor = FS19Style.colors["colorGlassDark"]
FS19Style.panel.borders = {}
FS19Style.panel.borders["TOP"] = {}
FS19Style.panel.borders["TOP"].color = FS19Style.colors["colorGlassLight"]
FS19Style.panel.borders["TOP"].size = 1
FS19Style.panel.borders["RIGHT"] = {}
FS19Style.panel.borders["RIGHT"].color = FS19Style.colors["colorGlassLight"]
FS19Style.panel.borders["RIGHT"].size = 1
FS19Style.panel.borders["BOTTOM"] = {}
FS19Style.panel.borders["BOTTOM"].color = FS19Style.colors["colorMainUI"]
FS19Style.panel.borders["BOTTOM"].size = 4
FS19Style.panel.borders["LEFT"] = {}
FS19Style.panel.borders["LEFT"].color = FS19Style.colors["colorGlassLight"]
FS19Style.panel.borders["LEFT"].size = 1
FS19Style.shadowText = {}
FS19Style.shadowText.shadow = {}
FS19Style.shadowText.shadow.color = FS19Style.colors["colorTextShadow"]
FS19Style.shadowText.shadow.offset = {1, -1}
FS19Style.titledPanel = {}
FS19Style.titledPanel.title = {}
FS19Style.titledPanel.title.size = 20
FS19Style.titledPanel.title.bold = true
FS19Style.titledPanel.title.offset = {1, -3}
FS19Style.titledPanel.title.forceUpper = true

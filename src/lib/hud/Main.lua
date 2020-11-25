--
-- Royal Hud
--
-- @author Royal Modding
-- @version 1.1.0.0
-- @date 09/11/2020

--- Initialize RoyalHud
---@param hudDirectory string
function InitRoyalHud(hudDirectory)
    if not Utility then
        g_logManager:error("Royal Hud can't be loaded because Utility library is missing")
        return false
    end
    source(Utils.getFilename("RoyalHud.lua", hudDirectory))
    source(Utils.getFilename("RoyalHudOverlay.lua", hudDirectory))
    source(Utils.getFilename("RoyalHudImage.lua", hudDirectory))
    source(Utils.getFilename("RoyalHudText.lua", hudDirectory))
    source(Utils.getFilename("Controls/RoyalHudControl.lua", hudDirectory))
    source(Utils.getFilename("Controls/RoyalHudPanel.lua", hudDirectory))
    source(Utils.getFilename("Controls/RoyalHudShadowText.lua", hudDirectory))
    source(Utils.getFilename("Controls/RoyalHudTitledPanel.lua", hudDirectory))
    source(Utils.getFilename("Styles/RoyalHudStyles.lua", hudDirectory))
    source(Utils.getFilename("Styles/FS19Style.lua", hudDirectory))

    g_logManager:devInfo("Royal Hud loaded successfully by " .. g_currentModName)
    return true
end

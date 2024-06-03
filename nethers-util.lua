G.SHADERS['hologramv2'] = love.graphics.newShader(SMODS.current_mod.path.."/assets/shaders/".."hologramv2.fs")
sendDebugMessage("Shaders injected!")

NETHER_UTIL = {}

function NETHER_UTIL.is_in_your_collection(card)
    if not G.your_collection then return false end
    for i = 1, 3 do
        if (G.your_collection[i] and card.area == G.your_collection[i]) then return true end
    end
    return false
end

return NETHER_UTIL
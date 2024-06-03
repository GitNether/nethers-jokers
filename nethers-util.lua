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

function NETHER_UTIL.check_if_joker_is_still_there(card)
    local other_joker = nil
    if not nether_util.is_in_your_collection(card) and card.ability.copied_joker then
        -- iterate over G.jokers.cards and find the joker with the same sort_id
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].sort_id == card.ability.copied_joker.sort_id then
                other_joker = G.jokers.cards[i]
                break
            end
        end
        if not other_joker then
            card.ability.copied_joker = nil
            card.children.floating_sprite.scale.x = 0
            card.children.floating_sprite.scale.y = 0
            card.children.floating_sprite:reset()
        end
    end
    return other_joker
end

return NETHER_UTIL
--- STEAMODDED HEADER
--- MOD_NAME: Nether's Jokers
--- MOD_ID: NethersJokers
--- MOD_AUTHOR: [Nether]
--- MOD_DESCRIPTION: Add new Jokers to the game
--- LOADER_VERSION_GEQ: 1.0.0
--- VERSION: 0.1.0

----------------------------------------------
------------MOD CODE -------------------------

_RELEASE_MODE = false

-- Config: Enable or disable additional jokers here
local CONFIG = {
    joker_masterplan = true,
}

if CONFIG.joker_masterplan then -- Masterplan Joker

        -- SMODS.Atlas{
    --     key = "masterplan",
    --     path = "masterplan.png",
    --     px = 71,
    --     py = 95
    -- }

    SMODS.Joker{
        key = "masterplan",
        name = "Masterplan",
        rarity = 3,
        discovered = true,
        unlocked = true,
        cost = 5,
        config = {},
        blueprint_compat = true,
        loc_txt = {
            name = "Masterplan",
            text = {
                "Copies the ability",
                "of rightmost {C:attention}Joker{}"
            }
        },
        loc_vars = function(self, info_queue, card)
            card.ability.blueprint_compat_ui = card.ability.blueprint_compat_ui or ''; card.ability.blueprint_compat_check = nil
            return { main_end = (card.area and card.area == G.jokers) and {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
                        {n=G.UIT.T, config={ref_table = card.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                    }}
                }}
            } or nil }
        end,
        calculate = function(self, card, context)
            local jokers = G.jokers.cards
            local other_joker = jokers[#jokers]
            if other_joker == card then
                other_joker = nil
            end
            if other_joker then
                context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                context.blueprint_card = context.blueprint_card or card
                if context.blueprint > #G.jokers.cards + 1 then return end
                local other_joker_ret = other_joker:calculate_joker(context)
                if other_joker_ret then 
                    other_joker_ret.card = context.blueprint_card or card
                    other_joker_ret.colour = G.C.RED
                    return other_joker_ret
                end
            end
        end,
        update = function(self, card, dt)
            if not card.area == G.jokers then return end
            local jokers = G.jokers.cards
            local other_joker = jokers[#jokers]
            if other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat then
                card.ability.blueprint_compat = 'compatible'
            else
                card.ability.blueprint_compat = 'incompatible'
            end
        end,
        --atlas = "masterplan"
    }
end
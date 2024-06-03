SMODS.Atlas{
    key = "blankjoker",
    path = "joker_blankjoker.png",
    px = 71,
    py = 95
}

SMODS.Joker{
    key = "blankjoker",
    name = "Blank Joker",
    rarity = 3,
    discovered = true,
    unlocked = true,
    cost = 5,
    blueprint_compat = true,
    loc_txt = {
        name = "Blank Joker",
        text = {
            "Copies the scoring",
            "of a {C:attention}random Joker{}",
            "{C:red}Changes every blind{}",
            "{C:inactive}(Currently: {X:inactive,C:white}#1#{}{C:inactive}){}"
        }
    },
    config = {},
    atlas = "blankjoker",
    soul_pos = {x = 0, y = 0},
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.copied_joker = nil
        card.children.floating_sprite.scale.x = 0
        card.children.floating_sprite.scale.y = 0
        card.children.floating_sprite:reset()
    end,
    load = function(self, card, card_table, other_card)
        sendDebugMessage("Loading..")
        local other_joker = nether_util.check_if_joker_is_still_there(card)
        if not other_joker then return end
        sendDebugMessage("other joker found!")
        card.children.floating_sprite.atlas = G.ASSET_ATLAS["Joker"]
        card.children.floating_sprite.scale.x = other_joker.children.center.scale.x
        card.children.floating_sprite.scale.y = other_joker.children.center.scale.y
        card.children.floating_sprite:set_sprite_pos(other_joker.config.center.pos)
        card.children.floating_sprite:reset()
    end,
    loc_vars = function(self, info_queue, card)
        nether_util.check_if_joker_is_still_there(card)
        return nether_util.is_in_your_collection(card) and nil or {vars={
                (card.ability.copied_joker and card.ability.copied_joker.name or "None"),
            }}
        end,
    calculate = function(self, card, context)
        if not nether_util.is_in_your_collection(card) then
            local other_joker = nether_util.check_if_joker_is_still_there(card)
            if other_joker then 
                card.children.floating_sprite.atlas = G.ASSET_ATLAS["Joker"]
                card.children.floating_sprite.scale.x = other_joker.children.center.scale.x
                card.children.floating_sprite.scale.y = other_joker.children.center.scale.y
                card.children.floating_sprite:set_sprite_pos(other_joker.config.center.pos)
                card.children.floating_sprite:reset()
            end
        end

        if context.selling_card then
            other_joker = nether_util.check_if_joker_is_still_there(card)
            if other_joker then
                if context.card.sort_id == card.ability.copied_joker.sort_id then
                    card.ability.copied_joker = nil
                    card.children.floating_sprite.scale.x = 0
                    card.children.floating_sprite.scale.y = 0
                    card.children.floating_sprite:reset()
                end
            end
        end

        if context.setting_blind then -- select random joker
            local jokers = G.jokers.cards
            -- collect all jokers with blueprint_compat (that are not self) into a table
            local jokers_with_blueprint_compat = {}
            for i = 1, #jokers do
                if jokers[i] ~= card and jokers[i].config.center.blueprint_compat then
                    table.insert(jokers_with_blueprint_compat, jokers[i])
                end
            end
            -- pick random joker out of table
            local other_joker = jokers_with_blueprint_compat[math.random(1, #jokers_with_blueprint_compat)]
            
            if not other_joker then return end
            
            -- save picked joker for later use
            card.ability.copied_joker = {name = other_joker.ability.name, sort_id = other_joker.sort_id}
            card.children.floating_sprite.atlas = G.ASSET_ATLAS["Joker"]
            card.children.floating_sprite.scale.x = other_joker.children.center.scale.x
            card.children.floating_sprite.scale.y = other_joker.children.center.scale.y
            card.children.floating_sprite:set_sprite_pos(other_joker.config.center.pos)
            card.children.floating_sprite:reset()
        end

        if not nether_util.is_in_your_collection(card) and card.ability.copied_joker then
            local other_joker = nil
            -- iterate over G.jokers.cards and find the joker with the same sort_id
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].sort_id == card.ability.copied_joker.sort_id then
                    other_joker = G.jokers.cards[i]
                    break
                end
            end
            if not other_joker then
                card.ability.copied_joker = nil
                return
            end

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
    end
}
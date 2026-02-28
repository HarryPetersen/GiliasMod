---@diagnostic disable: undefined-global

SMODS.Atlas {
    key = "haribow_atlas",
    path = "Haribow.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = "haribow",
    set = "Spectral",
    atlas = "haribow_atlas",
    pos = { x = 0, y = 0 },

    config = { extra = { destroy = 2, enhancement = "m_steel" } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.destroy, card.ability.extra.enhancement } }
    end,

    loc_txt = {
        name = "Haribow",
        text = {
            "Destroys {C:attention}#1#{} random",
            "cards in hand,",
            "Turn the rest into {C:attention}Steel Cards"
        }
    },

    can_use = function(self, card)
        return G.hand and G.hand.cards and #G.hand.cards > 0
    end,

    use = function(self, card, area, copier)
        if not G.hand or not G.hand.cards or #G.hand.cards == 0 then return end

        local destroyed_cards = {}
        local temp_hand = {}

        -- Copy hand safely
        for _, playing_card in ipairs(G.hand.cards) do
            temp_hand[#temp_hand + 1] = playing_card
        end

        -- Shuffle
        pseudoshuffle(temp_hand, pseudoseed('haribow'))

        -- Safe destroy amount
        local destroy_count = math.min(card.ability.extra.destroy, #temp_hand)

        for i = 1, destroy_count do
            destroyed_cards[#destroyed_cards + 1] = temp_hand[i]
        end

        -- Juice effect
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        -- Destroy cards
        SMODS.destroy_cards(destroyed_cards)

        -- Flip animation (avoid divide by zero)
        local hand_size = #G.hand.cards
        local denom = math.max(hand_size - 0.998, 0.001)

        for i = 1, hand_size do
            local percent = 1.15 - (i - 0.999) / denom * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    local c = G.hand.cards[i]
                    if c then
                        c:flip()
                        play_sound('card1', percent)
                        c:juice_up(0.3, 0.3)
                    end
                    return true
                end
            }))
        end

        -- Apply enhancement
        for i = 1, hand_size do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local c = G.hand.cards[i]
                    if c then
                        local enh_key = card.ability.extra.enhancement
                        c:set_ability(G.P_CENTERS[enh_key])
                    end
                    return true
                end
            }))
        end

        delay(0.2)

        -- Flip back
        for i = 1, hand_size do
            local percent = 0.85 + (i - 0.999) / denom * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    local c = G.hand.cards[i]
                    if c then
                        c:flip()
                        play_sound('tarot2', percent, 0.6)
                        c:juice_up(0.3, 0.3)
                    end
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))

        delay(0.5)
    end,
}
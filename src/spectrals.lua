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

    config = { extra = { destroy = 2, enhancement = "Steel" } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.destroy, card.ability.extra.enhancement} }
    end,

    loc_txt = {
        name = "Haribow",
        text = {
            "Destroys {C:attention}#1#{} random",
            "cards in hand,",
            "Turn the rest into {C:attention}#2# Cards"
        }
    },

    use = function(self, card, area, copier)
        local destroyed_cards = {}
        local temp_hand = {}

        for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
        table.sort(temp_hand,
            function(a, b)
                return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card
            end
        )

        pseudoshuffle(temp_hand, 'haribow')

        for i = 1, card.ability.extra.destroy do destroyed_cards[#destroyed_cards + 1] = temp_hand[i] end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        SMODS.destroy_cards(destroyed_cards)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand do
            local percent = 1.15 - (i - 0.999) / (#G.hand - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand[i]:flip()
                    play_sound('card1', percent)
                    G.hand[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        
        delay(0.2)

        for i = 1, #G.hand do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand[i]:set_ability(card.ability.extra.enhancement)
                    return true
                end
            }))
        end
        for i = 1, #G.hand do
            local percent = 0.85 + (i - 0.999) / (#G.hand - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand[i]:juice_up(0.3, 0.3)
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
    can_use = function(self, card)
        return G.hand and #G.hand > 0
    end,
}
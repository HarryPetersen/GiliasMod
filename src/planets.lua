---@diagnostic disable: undefined-global

SMODS.Atlas {
    key = "stone_lover_atlas",
    path = "StoneLover.png",
    px = 71,
    py = 95
}

SMODS.Consumable{
    key = "stone_lover",
    set = "Planet",
    cost = 3,
    atlas = "stone_lover_atlas",
    pos = { x = 0, y = 0 },

    config = { hand_type = "GM_Cluster", softlock = true },

    in_pool = function(self, args)
        local ht = (self.config and self.config.hand_type) or "GM_Cluster"
        local game = G.GAME
        local hd = game and game.hands and game.hands[ht]
        if not hd then return false end
        return (hd.played or hd.times_played or 0) > 0
    end,

    loc_txt = {
        name = "Stone Lover",
        text = {
            "(lvl.#1#) Level up",
            "{C:attention}#2#{}",
            "+{C:mult}#3#{} Mult",
            "+{C:chips}#4#{} Chips",
        }
    },

    loc_vars = function(self, info_queue, card)
        local ht =
            (card.ability and card.ability.consumeable and card.ability.consumeable.hand_type)
            or (card.config and card.config.center and card.config.center.config and card.config.center.config.hand_type)
            or (self.config and self.config.hand_type)
            or "GM_Cluster"

        local hands = (G.GAME and G.GAME.hands) or {}
        local hand_data = hands[ht]

        if not hand_data then
            return { vars = { 1, localize(ht, 'poker_hands') or "Cluster", 0, 0, colours = { G.C.UI.TEXT_DARK } } }
        end

        return {
            vars = {
                hand_data.level,
                localize(ht, 'poker_hands') or "Cluster",
                hand_data.l_mult,
                hand_data.l_chips,
                colours = {
                    (hand_data.level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, hand_data.level)])
                }
            }
        }
    end
}
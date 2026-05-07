---@diagnostic disable: undefined-global

SMODS.Atlas {
    key = "fun",
    path = "fun.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = "fun",
    atlas = "fun",
    loc_txt = {
        name = "Fun Deck",
        text = {
            "+#1# Joker Slots",
        },
    },
    pos = { x = 3, y = 2 },
    config = { joker_slots = 5 },
    unlocked = true,

    apply = function(self, back)
        G.GAME.starting_params.joker_slots =
            G.GAME.starting_params.joker_slots + self.config.joker_slots
    end,

    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.joker_slots } }
    end,
}
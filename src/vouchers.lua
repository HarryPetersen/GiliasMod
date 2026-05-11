---@diagnostic disable: undefined-global

SMODS.Atlas{
    key = "pizzatime_atlas",
    path = "PizzaTime.png",
    px = 71,
    py = 95
}

SMODS.Voucher{
    key = "PizzaTime",
    atlas = "pizzatime_atlas",
    pos = { x = 0, y = 0 },
    cost = 10,

    loc_txt = {
        name = "Pizza Time",
        text = {
            "{C:attention}+1{} Booster Pack",
            "available in each shop"
        }
    },

    redeem = function(self, card)
        SMODS.change_booster_limit(1)
    end
}
--- spectral packs more likely
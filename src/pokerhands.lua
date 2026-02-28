---@diagnostic disable: undefined-global

SMODS.PokerHand {
    key = "Cluster",
    visible = false,

    mult = 15,
    chips = 150,
    l_mult = 3,
    l_chips = 30,

    loc_txt = {
        name = "Cluster",
        description = {
            "Five Stone cards"
        }
    },

    example = {
        { 'S_A', true, enhancement = 'm_stone' },
        { 'H_2', true, enhancement = 'm_stone' },
        { 'D_5', true, enhancement = 'm_stone' },
        { 'C_9', true, enhancement = 'm_stone' },
        { 'S_K', true, enhancement = 'm_stone' },
    },

    evaluate = function(parts, hand)
        if #hand ~= 5 then return {} end

        for _, card in ipairs(hand) do
            local center = card.config and card.config.center
            if not center then return {} end

            if center.key ~= "c_stone" and center.key ~= "m_stone" then
                return {}
            end
        end

        return { hand }
    end
}
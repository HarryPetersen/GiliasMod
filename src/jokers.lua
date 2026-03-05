---@diagnostic disable: undefined-global

SMODS.Atlas {
    key = "duo_atlas",
    path = "Duo.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "focus_atlas",
    path = "Focus.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "sneaky_atlas",
    path = "Sneak.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "christmas_atlas",
    path = "Christmas.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "bunk_atlas",
    path = "Bunk.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "lilies_atlas",
    path = "Lilies.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "sillyboi_atlas",
    path = "SillyBoi.png",
    px = 71, 
    py = 95
}

SMODS.Joker {
    key = "awesome_duo",
    name = "Awesome Duo",
    atlas = "duo_atlas",
    pos = { x = 0, y = 0 },
    rarity = 4,
    cost = 20,
    blueprint_compat = false,
    eternal_compat = true,

    loc_txt = {
        name = "Awesome Duo",
        text = {
            "At end of Boss Blind,",
            "Create a {C:dark_edition}Negative{} copy",
            "of a random joker",
            "(Awesome Duo excluded)"
        },
    },

    calculate = function(self, card, context)
        card.ability.extra = card.ability.extra or {}
        card.ability.extra.duplicated = card.ability.extra.duplicated or false

        if context.beat_boss and not card.ability.extra.duplicated then
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end
            end

            if #jokers > 0 then
                local chosen_joker = pseudorandom_element(jokers, pseudorandom(seed))
                local copied_joker = copy_card(chosen_joker, nil, nil, nil,
                chosen_joker.edition and chosen_joker.edition.negative)
                copied_joker:set_edition("e_negative", true)
                copied_joker:add_to_deck()
                G.jokers:emplace(copied_joker)

                card.ability.extra.duplicated = true
                return { message = localize('k_duplicated_ex') }
            else
                return { message = localize('k_no_other_jokers') }
            end
        end

        if context.setting_blind then
            card.ability.extra.duplicated = false
        end
    end
}

SMODS.Joker {
    key = "focus",
    name = "focus",
    atlas = "focus_atlas",
    pos = { x = 0, y = 0},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,

    loc_txt = {
        name = "Focus",
        text = {
            "Gives {C:mult}#1#{} Mult for",
            "each {C:attention}Stone Card",
            "in your {C:attention}full deck",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        },
    },

    config = { extra = { mult = 9 } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone

        local stone_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_stone') then stone_tally = stone_tally + 1 end
            end
        end
        return { vars = { card.ability.extra.mult, stone_tally * card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local stone_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, "m_stone") then stone_tally = stone_tally + 1 end
            end
            return {
                mult = card.ability.extra.mult * stone_tally,
            }
        end
    end,

    in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                return true
            end
        end
        return false
    end
}

SMODS.Joker {
    key = "sneaky",
    name = "sneaky",
    atlas = "sneaky_atlas",
    pos = { x = 0, y = 0},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,

    loc_txt = {
        name = "Sneaky",
        text = {
            "Adds {C:mult}+400{} Mult",
        },
    },

    config = { extra = { mult = 400 }, },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = "christmas",
    name = "christmas",
    atlas = "christmas_atlas",
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { dollars = 10 } },

    loc_txt = {
        name = "Christmas",
        text = {
            "Earn {C:money}$#1#{}",
            "for each {C:attention}Steel card{}",
            "held in hand at end of round"
        },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round
            and context.cardarea == G.hand
            and context.individual
            and context.other_card
        then
            local per = (card.ability and card.ability.extra and card.ability.extra.dollars) or 0
            if per <= 0 then return end

            local c = context.other_card
            local center = c.config and c.config.center
            local key = center and center.key

            if key == "m_steel" or key == "c_steel" then
                return { dollars = per }
            end
        end
    end
}

SMODS.Joker{
    key = "bunk",
    name = "Bunk",
    atlas = "bunk_atlas",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { chips = 20 } },

    loc_txt = {
        name = "Bunk",
        text = {
            "Earn {C:chips}+#1#{} Chips",
            "for each High Card played",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
        },
    },

    loc_vars = function(self, info_queue, card)
        local game = G.GAME or G.Game
        local highcards_played = 0

        if game and game.hands and game.hands["High Card"] and game.hands["High Card"].played then
            highcards_played = game.hands["High Card"].played
        end

        local per = (card.ability and card.ability.extra and card.ability.extra.chips) or 0
        return { vars = { per, per * highcards_played } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local game = G.GAME or G.Game
            local highcards_played = 0

            if game and game.hands and game.hands["High Card"] and game.hands["High Card"].played then
                highcards_played = game.hands["High Card"].played
            end

            return {
                chips = highcards_played * (card.ability.extra.chips or 0)
            }
        end
    end
}

SMODS.Joker {
    key = "lilies",
    name = "lilies",
    atlas = "lilies_atlas",
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 12,
    blueprint_compat = true,
    eternal_compat = true,

    config = { extra = { x_chips = 6, type = 'Three of a Kind' } },

    loc_txt = {
        name = "Lilies",
        text = {
            "{C:chips}x#1#{} Chips if played",
            "hand contains",
            "a {C:attention}#2#"
        },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_chips, localize(card.ability.extra.type, 'poker_hands') } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                xchips = card.ability.extra.x_chips
            }
        end
    end
}

local SillyBoi = {}

local SB_PER_ROW  = 5
local SB_ROWS     = 3
local SB_PER_PAGE = SB_PER_ROW * SB_ROWS

local function sb_total_pages(count)
  return math.max(1, math.ceil((count or 0) / SB_PER_PAGE))
end

local function sb_deepcopy(t)
  if type(t) ~= 'table' then return t end
  local out = {}
  for k, v in pairs(t) do out[k] = sb_deepcopy(v) end
  return out
end

local function sb_get_log()
  if not (G and G.GAME) then return nil end
  G.GAME.sillyboi_sold_jokers = G.GAME.sillyboi_sold_jokers or {}
  return G.GAME.sillyboi_sold_jokers
end

local function sb_is_silly_key(k)
  return type(k) == 'string' and (k == 'j_sillyboi' or k:match('_sillyboi$') or k:match('sillyboi$'))
end

local function sb_extract_stickers(card)
  local stickers = {}
  if card and card.ability then
    if card.ability.eternal then stickers[#stickers+1] = 'eternal' end
    if card.ability.rental then stickers[#stickers+1] = 'rental' end
    if card.ability.perishable then stickers[#stickers+1] = 'perishable' end
  end
  return (#stickers > 0) and stickers or nil
end

local function sb_joker_capacity()
  if not (G and G.jokers) then return 0 end
  local cap = G.jokers.config.card_limit or 0
  for _, c in ipairs(G.jokers.cards or {}) do
    if c.edition and c.edition.negative then cap = cap + 1 end
  end
  return cap
end

local function sb_has_space_for_joker()
  if not (G and G.jokers and G.jokers.cards) then return false end
  return #G.jokers.cards < sb_joker_capacity()
end

local function sb_add_sold_joker(card)
  local log = sb_get_log()
  if not log then return end
  if not (card and card.ability and card.ability.set == 'Joker') then return end
  if not (card.config and card.config.center and card.config.center.key) then return end

  if sb_is_silly_key(card.config.center.key) then return end

  log[#log+1] = {
    key = card.config.center.key,
    edition = card.edition and sb_deepcopy(card.edition) or nil,
    stickers = sb_extract_stickers(card),
  }
end

local function sb_prune_silly_from_log()
  local log = sb_get_log()
  if not log then return end
  for i = #log, 1, -1 do
    if log[i] and sb_is_silly_key(log[i].key) then
      table.remove(log, i)
    end
  end
end


local function sb_make_preview_card(entry)
  if not (entry and entry.key) then return nil end
  local center = G.P_CENTERS and G.P_CENTERS[entry.key]
  if not center then return nil end

  local c = Card(0, 0, G.CARD_W, G.CARD_H, nil, center, nil, 'sb_prev')

  if c and c.states then
    if c.states.click then c.states.click.can = false end
    if c.states.drag then c.states.drag.can = false end

    if c.states.hover then c.states.hover.can = false end
  end

  if entry.edition and c and c.set_edition then
    pcall(function() c:set_edition(entry.edition, true) end)
  end

  if entry.stickers and c then
    for _, s in ipairs(entry.stickers) do
      if s == 'eternal' and c.set_eternal then pcall(function() c:set_eternal(true) end) end
      if s == 'rental' and c.set_rental then pcall(function() c:set_rental(true) end) end
      if s == 'perishable' and c.set_perishable then pcall(function() c:set_perishable(true) end) end
    end
  end

  if c and c.T then c.T.scale = 0.78 end

  return c
end


do
  local old_reset = SMODS.current_mod.reset_game_globals
  SMODS.current_mod.reset_game_globals = function(run_start)
    if old_reset then old_reset(run_start) end

    if run_start and G and G.GAME then
      G.GAME.sillyboi_sold_jokers = {}

      if G.FUNCS and G.FUNCS.sell_card and not G.FUNCS._sillyboi_sell_hooked then
        G.FUNCS._sillyboi_sell_hooked = true
        local original_sell_card = G.FUNCS.sell_card
        G.FUNCS.sell_card = function(e)
          local c = e and e.config and e.config.ref_table
          sb_add_sold_joker(c)
          return original_sell_card(e)
        end
      end
    end
  end
end


local function sb_open_refresh_overlay()
  if G.FUNCS.exit_overlay_menu then G.FUNCS.exit_overlay_menu() end
  G.E_MANAGER:add_event(Event({
    trigger = 'after',
    delay = 0.0,
    func = function()
      G.SETTINGS.paused = true
      G.FUNCS.overlay_menu{ definition = create_UIBox_sillyboi_recreate() }
      return true
    end
  }))
end

function G.FUNCS.sillyboi_page_left(e)
  local log = sb_get_log() or {}
  local total = sb_total_pages(#log)
  G.GAME.sillyboi_recreate_page = math.max(1, (G.GAME.sillyboi_recreate_page or 1) - 1)
  if total > 1 then sb_open_refresh_overlay() end
end

function G.FUNCS.sillyboi_page_right(e)
  local log = sb_get_log() or {}
  local total = sb_total_pages(#log)
  G.GAME.sillyboi_recreate_page = math.min(total, (G.GAME.sillyboi_recreate_page or 1) + 1)
  if total > 1 then sb_open_refresh_overlay() end
end

function create_UIBox_sillyboi_recreate()
  local log = sb_get_log() or {}
  sb_prune_silly_from_log()

  local total = sb_total_pages(#log)
  local page = math.min(math.max(G.GAME.sillyboi_recreate_page or 1, 1), total)
  G.GAME.sillyboi_recreate_page = page

  local nodes = {}

  nodes[#nodes+1] = {n=G.UIT.R, config={align="cm", padding=0.08}, nodes={
    {n=G.UIT.T, config={text="Choose a sold Joker to recreate", colour=G.C.UI.TEXT_LIGHT, scale=0.45, shadow=true}}
  }}

  if #log == 0 then
    nodes[#nodes+1] = {n=G.UIT.R, config={align="cm", padding=0.2}, nodes={
      {n=G.UIT.T, config={text="No Jokers sold yet this run.", colour=G.C.UI.TEXT_INACTIVE, scale=0.4}}
    }}
  else
    local start_idx = #log - (page - 1) * SB_PER_PAGE
    local end_idx = math.max(1, start_idx - SB_PER_PAGE + 1)
    local idx = start_idx

    local grid_rows = {}

    for r = 1, SB_ROWS do
      local row_nodes = {}
      for c = 1, SB_PER_ROW do
        if idx >= end_idx then
          local entry = log[idx]

          if entry and sb_is_silly_key(entry.key) then
            row_nodes[#row_nodes+1] = {n=G.UIT.B, config={w=1.35, h=1.9}}
          else
            local preview = sb_make_preview_card(entry)
            if not preview then
              row_nodes[#row_nodes+1] = {n=G.UIT.B, config={w=1.35, h=1.9}}
            else
              row_nodes[#row_nodes+1] = {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.03 },
                nodes = {
                  {
                    n = G.UIT.O,
                    config = {
                      object = preview,
                      button = 'sillyboi_recreate_from_log',
                      id = tostring(idx),
                      hover = true,
                      shadow = true,
                    }
                  }
                }
              }
            end
          end

          idx = idx - 1
        else
          row_nodes[#row_nodes+1] = {n=G.UIT.B, config={w=1.35, h=1.9}}
        end
      end
      grid_rows[#grid_rows+1] = {n=G.UIT.R, config={align="cm", padding=0.02}, nodes=row_nodes}
    end

    nodes[#nodes+1] = {n=G.UIT.C, config={align="cm", padding=0.05}, nodes=grid_rows}

    if total > 1 then
      local left_enabled  = page > 1
      local right_enabled = page < total

      nodes[#nodes+1] = {n=G.UIT.R, config={align="cm", padding=0.08}, nodes={
        UIBox_button({
          label = {"<"},
          button = left_enabled and 'sillyboi_page_left' or nil,
          colour = left_enabled and G.C.RED or G.C.UI.BACKGROUND_INACTIVE,
          minw = 1.0,
          minh = 0.7,
          scale = 0.4,
        }),
        {n=G.UIT.C, config={align="cm", r=0.1, colour=G.C.RED, minw=4.0, minh=0.7, padding=0.08}, nodes={
          {n=G.UIT.T, config={text=("Page "..tostring(page).."/"..tostring(total)), colour=G.C.UI.TEXT_LIGHT, scale=0.4, shadow=true}}
        }},
        UIBox_button({
          label = {">"},
          button = right_enabled and 'sillyboi_page_right' or nil,
          colour = right_enabled and G.C.RED or G.C.UI.BACKGROUND_INACTIVE,
          minw = 1.0,
          minh = 0.7,
          scale = 0.4,
        })
      }}
    end
  end

  return create_UIBox_generic_options({
    back_func = 'exit_overlay_menu',
    contents = {
      {n=G.UIT.C, config={align="cm", padding=0.15}, nodes=nodes}
    }
  })
end

function G.FUNCS.sillyboi_recreate_from_log(e)
  local log = sb_get_log() or {}
  local idx = tonumber(e and e.config and e.config.id)
  local entry = idx and log[idx]
  if not entry then return end
  if sb_is_silly_key(entry.key) then return end

  if not sb_has_space_for_joker() then
    attention_text({
      text = localize('k_no_room_ex'),
      scale = 0.9,
      hold = 1.2,
      backdrop_colour = G.C.RED,
      major = G.ROOM_ATTACH
    })
    return
  end

  G.E_MANAGER:add_event(Event({
    trigger = 'after',
    delay = 0.0,
    func = function()
      SMODS.add_card({
        set = 'Joker',
        area = G.jokers,
        key = entry.key,
        edition = entry.edition,
        stickers = entry.stickers,
        no_edition = true
      })
      if G.FUNCS.exit_overlay_menu then G.FUNCS.exit_overlay_menu() end
      return true
    end
  }))
end


local function sillyboi_open_menu()
  if not (G and G.FUNCS and G.FUNCS.overlay_menu) then return end
  sb_prune_silly_from_log()
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{ definition = create_UIBox_sillyboi_recreate() }
end

SMODS.Joker{
  key = "sillyboi",
  name = "Silly Boi",
  atlas = "sillyboi_atlas",
  pos = { x = 0, y = 0 },
  rarity = 2,
  cost = 10,
  blueprint_compat = false,
  eternal_compat = false,

  loc_txt = {
    name = "Silly Boi",
    text = {
      "When sold",
      "Choose one joker sold this run",
      "and recreate it"
    },
  },

  calculate = function(self, card, context)
    if context.selling_self then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.0,
        func = function()
          G.GAME.sillyboi_recreate_page = 1
          sillyboi_open_menu()
          return true
        end
      }))
      return { message = "Resurrected!" }
    end
  end,
}
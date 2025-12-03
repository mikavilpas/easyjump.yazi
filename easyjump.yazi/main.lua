--- @since 25.5.31

-- stylua: ignore
local SINGLE_LABELS = {
  "p", "b", "e", "t", "a", "o", "i", "n", "s", "r", "h", "l", "d", "c",
  "u", "m", "f", "g", "w", "v", "k", "j", "x", "y", "q"
}

-- stylua: ignore
local NORMAL_DOUBLE_LABELS = {
  "au", "ai", "ao", "ah", "aj", "ak", "al", "an",
  "su", "si", "so", "sh", "sj", "sk", "sl", "sn",
  "du", "di", "do", "dh", "dj", "dk", "dl", "dn",
  "fu", "fi", "fo", "fh", "fj", "fk", "fl", "fn",
  "gu", "gi", "go", "gh", "gj", "gk", "gl", "gn",
  "eu", "ei", "eo", "eh", "ej", "ek", "el", "en",
  "ru", "ri", "ro", "rh", "rj", "rk", "rl", "rn",
  "cu", "ci", "co", "ch", "cj", "ck", "cl", "cn",
  "wu", "wi", "wo", "wh", "wj", "wk", "wl", "wn",
  "tu", "ti", "to", "th", "tj", "tk", "tl", "tn",
  "vu", "vi", "vo", "vh", "vj", "vk", "vl", "vn",
  "xu", "xi", "xo", "xh", "xj", "xk", "xl", "xn",
  "bu", "bi", "bo", "bh", "bj", "bk", "bl", "bn",
  "qu", "qi", "qo", "qh", "qj", "qk", "ql", "qn",
  "ap", "ay", "am", "sp", "sy", "sm", "dp", "dy",
  "dm", "fp", "fy", "fm", "gp", "gy", "gm", "ep",
  "ey", "em", "rp", "ry", "rm", "cp", "cy", "cm",
  "wp", "wy", "wm", "tp", "ty", "tm", "vp", "vy",
  "vm", "xp", "xy", "xm", "bp", "by", "bm", "qp",
  "qy", "qm",
}

-- stylua: ignore
local INPUT_KEY = {
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
  "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
  "u", "v", "w", "x", "y", "z", "<Esc>", "<Backspace>",
}

-- labels for single keys, corresponding to the file index the label points to
---@type table<string, number>
local SINGLE_KEY_FILES = {}
for i, v in ipairs(SINGLE_LABELS) do
  SINGLE_KEY_FILES[v] = i
end

-- labels for double keys, corresponding to the file index the label points to
---@type table<string, number>
local DOUBLE_KEY_FILES = {}
for i, v in ipairs(NORMAL_DOUBLE_LABELS) do
  DOUBLE_KEY_FILES[v] = i
end

local INPUT_CANDS = {}
for _, v in ipairs(INPUT_KEY) do
  table.insert(INPUT_CANDS, { on = v })
end

local render = ya.sync(function()
  if type(ui.render) == "function" then
    -- ya.render was deprecated in
    -- https://github.com/sxyazi/yazi/commit/ffdd74b6abf552fd65738642aec50ca898fb26dd
    -- (2025-07-03)
    ui.render()
  else
    ya.render()
  end
end)

local status_ej = function(self)
  local style = self:style()
  return ui.Line({
    ui.Span("[EJ] "):style(style.main),
  })
end

---@param st easyjump.state
local toggle_ui = ya.sync(function(st)
  if st.entity_label_id or st.status_ej_id then
    Entity:children_remove(st.entity_label_id)
    Status:children_remove(st.status_ej_id)
    st.entity_label_id = nil
    st.status_ej_id = nil
    Entity._inc = Entity._inc - 1
    Status._inc = Status._inc - 1
    render()
    return
  end

  local entity_label = function(self)
    local file = self._file
    local pos = st.files_indices[tostring(file.url)]
    if not pos then
      return ui.Line({})
    elseif st.current_files_count > #SINGLE_LABELS then
      if
        st.double_first_key ~= nil
        and NORMAL_DOUBLE_LABELS[pos]:sub(1, 1) == st.double_first_key
      then
        return ui.Line({
          ui.Span(NORMAL_DOUBLE_LABELS[pos]:sub(1, 1)):fg(st.opt_first_key_fg),
          ui.Span(NORMAL_DOUBLE_LABELS[pos]:sub(2, 2) .. " ")
            :fg(st.opt_icon_fg),
        })
      else
        return ui.Line({
          ui.Span(NORMAL_DOUBLE_LABELS[pos] .. " "):fg(st.opt_icon_fg),
        })
      end
    else
      return ui.Line({ ui.Span(SINGLE_LABELS[pos] .. " "):fg(st.opt_icon_fg) })
    end
  end
  st.entity_label_id = Entity:children_add(entity_label, 2001)

  st.status_ej_id = Status:children_add(status_ej, 1001, Status.LEFT)
  render()
end)

---@param state easyjump.state
---@param str string
local update_double_first_key = ya.sync(function(state, str)
  state.double_first_key = str
end)

local function read_input_todo(
  current_files_count,
  cursor,
  offset,
  first_key_of_label
)
  ---@type number?
  local cand = nil
  ---@type string?
  local key
  ---@type number
  local key_num_count = 0

  while true do
    cand = ya.which({ cands = INPUT_CANDS, silent = true })

    -- not candy key, continue get input
    if cand == nil then
      goto nextkey
    end

    -- hit exit easyjump
    if INPUT_KEY[cand] == "<Esc>" or INPUT_KEY[cand] == "z" then
      return
    end

    -- hit single key
    if current_files_count <= #SINGLE_LABELS then
      key = INPUT_KEY[cand]
      local file_index = SINGLE_KEY_FILES[key]
      if file_index == nil or file_index > current_files_count then
        goto nextkey
      else
        -- ya.mgr_emit is deprecated in https://github.com/sxyazi/yazi/pull/2653
        (ya.mgr_emit or ya.emit)("arrow", { file_index - cursor - 1 + offset })
        return
      end
    end

    -- hit backout a double key
    if
      INPUT_KEY[cand] == "<Backspace>"
      and current_files_count > #SINGLE_LABELS
    then
      key_num_count = 0 -- backout to get the first double key
      update_double_first_key(nil) -- apply to the render change for first key
      goto nextkey
    end

    -- hit the first double key
    if key_num_count == 0 and current_files_count > #SINGLE_LABELS then
      key = INPUT_KEY[cand]
      if first_key_of_label[key] then
        key_num_count = key_num_count + 1
        update_double_first_key(key) -- apply to the render change for first key
      else
        key_num_count = 0 -- get the first double key fail, continue to get it
      end
      goto nextkey
    end

    -- hit the second double key
    if key_num_count == 1 and current_files_count > #SINGLE_LABELS then
      local double_key = key .. INPUT_KEY[cand]
      local file_index = DOUBLE_KEY_FILES[double_key]
      if file_index == nil or file_index > current_files_count then -- get the second double key fail, continue to get it
        goto nextkey
      else
        -- ya.mgr_emit is deprecated in https://github.com/sxyazi/yazi/pull/2653
        (ya.mgr_emit or ya.emit)("arrow", { file_index - cursor - 1 + offset })
        return
      end
    end

    ::nextkey::
  end
end

---@class(exact) easyjump.state
---@field opt_icon_fg string
---@field opt_first_key_fg string
---@field entity_label_id number
---@field status_ej_id number
---@field files_indices table<string, number> # file url to index
---@field current_files_count number
---@field double_first_key string

-- init to record file position and the file num
---@param state easyjump.state
local init = ya.sync(function(state)
  state.files_indices = {}
  local first_key_of_label = {}
  local folder = cx.active.current

  local visible_files = folder.window
  state.current_files_count = #visible_files

  for i, file in ipairs(visible_files) do
    state.files_indices[tostring(file.url)] = i
    if state.current_files_count > #SINGLE_LABELS then
      first_key_of_label[NORMAL_DOUBLE_LABELS[i]:sub(1, 1)] = ""
    end
  end

  return state.current_files_count,
    folder.cursor,
    folder.offset,
    first_key_of_label
end)

---@param state easyjump.state
local clear_state = ya.sync(function(state)
  state.files_indices = nil
  state.current_files_count = nil
  state.double_first_key = nil
end)

return {
  ---@param state easyjump.state
  setup = function(state, opts)
    opts = opts or {}
    state.opt_icon_fg = opts.icon_fg or "#fda1a1"
    state.opt_first_key_fg = opts.first_key_fg or "#df6249"
  end,

  entry = function(_, _)
    local current_files_count, cursor, offset, first_key_of_label = init()

    if current_files_count == nil or current_files_count == 0 then
      return
    end

    toggle_ui()

    read_input_todo(current_files_count, cursor, offset, first_key_of_label)

    toggle_ui()
    clear_state()
  end,
}

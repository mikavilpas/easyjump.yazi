--- @since 25.5.31

-- Default hint key configuration
-- IMPORTANT: first_keys and second_keys must NOT overlap
-- stylua: ignore
local DEFAULT_FIRST_KEYS = {
  "a", "s", "d", "f", "g", "e", "r", "c", "w", "t", "v", "x", "b", "q"
}

-- stylua: ignore
local DEFAULT_SECOND_KEYS = {
  "u", "i", "o", "h", "j", "k", "l", "n", "p", "y", "m"
}

-- Default single labels (for backward compatibility with original order)
-- stylua: ignore
local DEFAULT_SINGLE_LABELS = {
  "p", "b", "e", "t", "a", "o", "i", "n", "s", "r", "h", "l", "d", "c",
  "u", "m", "f", "g", "w", "v", "k", "j", "x", "y", "q"
}

-- Default double labels (for backward compatibility with original order)
-- stylua: ignore
local DEFAULT_DOUBLE_LABELS = {
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

---@param str string
---@return string[]
local function string_to_table(str)
  local result = {}
  for i = 1, #str do
    table.insert(result, str:sub(i, i))
  end
  return result
end

---@param keys string|string[]
---@return string[]
local function normalize_keys(keys)
  if type(keys) == "string" then
    return string_to_table(keys)
  end
  return keys
end

--- Generate single labels from first_keys and second_keys combined
---@param first_keys string[]
---@param second_keys string[]
---@return string[]
local function generate_single_labels(first_keys, second_keys)
  local labels = {}
  -- Add all first_keys
  for _, k in ipairs(first_keys) do
    table.insert(labels, k)
  end
  -- Add all second_keys
  for _, k in ipairs(second_keys) do
    table.insert(labels, k)
  end
  return labels
end

--- Generate double labels from first_keys × second_keys
---@param first_keys string[]
---@param second_keys string[]
---@return string[]
local function generate_double_labels(first_keys, second_keys)
  local labels = {}
  for _, fk in ipairs(first_keys) do
    for _, sk in ipairs(second_keys) do
      table.insert(labels, fk .. sk)
    end
  end
  return labels
end

--- Generate input key candidates
---@param first_keys string[]
---@param second_keys string[]
---@return string[]
local function generate_input_keys(first_keys, second_keys)
  local keys = {}
  local seen = {}
  -- Add all first_keys
  for _, k in ipairs(first_keys) do
    if not seen[k] then
      table.insert(keys, k)
      seen[k] = true
    end
  end

  -- Add all second_keys
  for _, k in ipairs(second_keys) do
    if not seen[k] then
      table.insert(keys, k)
      seen[k] = true
    end
  end

  -- Add control keys
  table.insert(keys, "<Esc>")
  table.insert(keys, "<Backspace>")
  return keys
end

--- Build lookup table from label list
---@param labels string[]
---@return table<string, number>
local function build_label_lookup(labels)
  local lookup = {}
  for i, v in ipairs(labels) do
    lookup[v] = i
  end
  return lookup
end

--- Build input candidates for ya.which
---@param input_keys string[]
---@return table[]
local function build_input_cands(input_keys)
  local cands = {}
  for _, v in ipairs(input_keys) do
    table.insert(cands, { on = v })
  end
  return cands
end

--- Validate that first_keys and second_keys don't overlap
---@param first_keys string[]
---@param second_keys string[]
---@return boolean, string?
local function validate_keys(first_keys, second_keys)
  local first_set = {}
  for _, k in ipairs(first_keys) do
    first_set[k] = true
  end
  for _, k in ipairs(second_keys) do
    if first_set[k] then
      return false,
        "Key '"
          .. k
          .. "' appears in both first_keys and second_keys. They must not overlap."
    end
  end
  return true, nil
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
    elseif st.current_files_count > #st.single_labels then
      if
        st.double_first_key ~= nil
        and st.double_labels[pos]:sub(1, 1) == st.double_first_key
      then
        return ui.Line({
          ui.Span(st.double_labels[pos]:sub(1, 1)):fg(st.opt_first_key_fg),
          ui.Span(st.double_labels[pos]:sub(2, 2) .. " "):fg(st.opt_icon_fg),
        })
      else
        return ui.Line({
          ui.Span(st.double_labels[pos] .. " "):fg(st.opt_icon_fg),
        })
      end
    else
      return ui.Line({
        ui.Span(st.single_labels[pos] .. " "):fg(st.opt_icon_fg),
      })
    end
  end
  st.entity_label_id = Entity:children_add(entity_label, 2001)

  st.status_ej_id = Status:children_add(status_ej, 1001, Status.LEFT)
  render()
end)

---@param state easyjump.state
---@param str string?
local update_double_first_key = ya.sync(function(state, str)
  state.double_first_key = str
end)

-- State machine for reading input keys
-- Each state is a separate function. Type annotations document which fields are used.

---@alias easyjump.SecondKeyResult
---| "backspace" go back to first key state
---| "cancelled" user cancelled
---| "jumped" successfully jumped to file

--- State: Single-key mode (≤25 files)
--- Waits for a single key press and jumps to the file
--- Uses: input_cands, input_keys, single_key_files, current_files_count, cursor, offset
---@param ctx easyjump.InitResult
local function read_single_key(ctx)
  while true do
    local cand = ya.which({ cands = ctx.input_cands, silent = true })

    if cand == nil then
      -- invalid key, wait for next
    elseif ctx.input_keys[cand] == "<Esc>" or ctx.input_keys[cand] == "z" then
      return -- cancelled
    else
      local key = ctx.input_keys[cand]
      local file_index = ctx.single_key_files[key]
      if file_index and file_index <= ctx.current_files_count then
        -- ya.mgr_emit is deprecated in https://github.com/sxyazi/yazi/pull/2653
        (ya.mgr_emit or ya.emit)(
          "arrow",
          { file_index - ctx.cursor - 1 + ctx.offset }
        )
        return -- jumped
      end
      -- invalid key for current file count, wait for next
    end
  end
end

--- State: Double-key mode - waiting for first key
--- Returns the first key pressed, or nil if cancelled
--- Uses: input_cands, input_keys, first_key_of_label
---@param ctx easyjump.InitResult
---@return string? first_key
local function read_double_first_key(ctx)
  while true do
    local cand = ya.which({ cands = ctx.input_cands, silent = true })

    if cand == nil then
      -- invalid key, wait for next
    elseif ctx.input_keys[cand] == "<Esc>" or ctx.input_keys[cand] == "z" then
      return nil -- cancelled
    elseif ctx.input_keys[cand] == "<Backspace>" then
      -- already at first key state, ignore backspace
    else
      local key = ctx.input_keys[cand]
      if ctx.first_key_of_label[key] then
        update_double_first_key(key) -- update UI to highlight first key
        return key -- transition to second key state
      end
      -- invalid first key, wait for next
    end
  end
end

--- State: Double-key mode - waiting for second key
--- Returns the result of the second key input
--- Uses: input_cands, input_keys, double_key_files, current_files_count, cursor, offset
---@param ctx easyjump.InitResult
---@param first_key string
---@return easyjump.SecondKeyResult
local function read_double_second_key(ctx, first_key)
  while true do
    local cand = ya.which({ cands = ctx.input_cands, silent = true })

    if cand == nil then
      -- invalid key, wait for next
    elseif ctx.input_keys[cand] == "<Esc>" or ctx.input_keys[cand] == "z" then
      return "cancelled"
    elseif ctx.input_keys[cand] == "<Backspace>" then
      update_double_first_key(nil) -- clear UI highlight
      return "backspace" -- transition back to first key state
    else
      local second_key = ctx.input_keys[cand]
      local double_key = first_key .. second_key
      local file_index = ctx.double_key_files[double_key]
      if file_index and file_index <= ctx.current_files_count then
        -- ya.mgr_emit is deprecated in https://github.com/sxyazi/yazi/pull/2653
        (ya.mgr_emit or ya.emit)(
          "arrow",
          { file_index - ctx.cursor - 1 + ctx.offset }
        )
        return "jumped"
      end
      -- invalid second key, wait for next
    end
  end
end

--- Main input handler with explicit state machine
---@param ctx easyjump.InitResult
local function read_input(ctx)
  -- Single-key mode: direct jump with one key press
  if ctx.current_files_count <= #ctx.single_labels then
    read_single_key(ctx)
    return
  end

  -- Double-key mode: state machine with explicit transitions
  while true do
    -- State 1: Wait for first key
    local first_key = read_double_first_key(ctx)
    if not first_key then
      return -- cancelled
    end

    -- State 2: Wait for second key
    local result = read_double_second_key(ctx, first_key)
    if result == "jumped" or result == "cancelled" then
      return
    end
    -- result == "backspace": loop back to first key state
  end
end

---@class(exact) easyjump.state
---@field opt_icon_fg string
---@field opt_first_key_fg string
---@field single_labels string[]
---@field double_labels string[]
---@field input_keys string[]
---@field single_key_files table<string, number>
---@field double_key_files table<string, number>
---@field input_cands table[]
---@field entity_label_id number
---@field status_ej_id number
---@field files_indices table<string, number> # file url to index
---@field current_files_count number
---@field double_first_key string?

---@class easyjump.InitResult
---@field current_files_count number
---@field cursor number
---@field offset number
---@field first_key_of_label table<string, string>
---@field single_labels string[]
---@field input_keys string[]
---@field single_key_files table<string, number>
---@field double_key_files table<string, number>
---@field input_cands table[]

-- init to record file position and the file num
---@param state easyjump.state
---@return easyjump.InitResult?
local init = ya.sync(function(state)
  state.files_indices = {}
  local first_key_of_label = {}
  local folder = cx.active.current

  local visible_files = folder.window
  state.current_files_count = #visible_files

  for i, file in ipairs(visible_files) do
    state.files_indices[tostring(file.url)] = i
    if state.current_files_count > #state.single_labels then
      first_key_of_label[state.double_labels[i]:sub(1, 1)] = ""
    end
  end

  return {
    current_files_count = state.current_files_count,
    cursor = folder.cursor,
    offset = folder.offset,
    first_key_of_label = first_key_of_label,
    single_labels = state.single_labels,
    input_keys = state.input_keys,
    single_key_files = state.single_key_files,
    double_key_files = state.double_key_files,
    input_cands = state.input_cands,
  }
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

    -- Configure hint keys
    local using_custom_keys = opts.first_keys ~= nil or opts.second_keys ~= nil
    local first_keys = normalize_keys(opts.first_keys or DEFAULT_FIRST_KEYS)
    local second_keys = normalize_keys(opts.second_keys or DEFAULT_SECOND_KEYS)

    -- Validate that first_keys and second_keys don't overlap
    local valid, err = validate_keys(first_keys, second_keys)
    if not valid then
      ya.notify({
        title = "easyjump",
        content = err .. " Falling back to defaults.",
        timeout = 5,
        level = "error",
      })
      -- Fall back to defaults
      first_keys = DEFAULT_FIRST_KEYS
      second_keys = DEFAULT_SECOND_KEYS
      using_custom_keys = false
    end

    -- Generate labels
    -- Use default labels for backward compatibility unless custom keys are provided
    if using_custom_keys then
      state.single_labels = generate_single_labels(first_keys, second_keys)
      state.double_labels = generate_double_labels(first_keys, second_keys)
    else
      state.single_labels = DEFAULT_SINGLE_LABELS
      state.double_labels = DEFAULT_DOUBLE_LABELS
    end
    state.input_keys = generate_input_keys(first_keys, second_keys)

    -- Build lookup tables
    state.single_key_files = build_label_lookup(state.single_labels)
    state.double_key_files = build_label_lookup(state.double_labels)
    state.input_cands = build_input_cands(state.input_keys)
  end,

  entry = function(_, _)
    local ctx = init()

    if ctx == nil or ctx.current_files_count == 0 then
      return
    end

    toggle_ui()
    read_input(ctx)
    toggle_ui()
    clear_state()
  end,
}

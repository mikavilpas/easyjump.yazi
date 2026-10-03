local M = {}

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
        ya.emit("arrow", { file_index - ctx.cursor - 1 + ctx.offset })
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
---@param update_double_first_key fun(key: string?)
---@return string? first_key
local function read_double_first_key(ctx, update_double_first_key)
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
---@param update_double_first_key fun(key: string?)
---@return easyjump.SecondKeyResult
local function read_double_second_key(ctx, first_key, update_double_first_key)
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
        ya.emit("arrow", { file_index - ctx.cursor - 1 + ctx.offset })
        return "jumped"
      end
      -- invalid second key, wait for next
    end
  end
end

--- Main input handler with explicit state machine
---@param ctx easyjump.InitResult
---@param update_double_first_key fun(key: string?) highlights the first key of double labels in the UI
function M.read_input(ctx, update_double_first_key)
  -- Single-key mode: direct jump with one key press
  if ctx.current_files_count <= #ctx.single_labels then
    read_single_key(ctx)
    return
  end

  -- Double-key mode: state machine with explicit transitions
  while true do
    -- State 1: Wait for first key
    local first_key = read_double_first_key(ctx, update_double_first_key)
    if not first_key then
      return -- cancelled
    end

    -- State 2: Wait for second key
    local result =
      read_double_second_key(ctx, first_key, update_double_first_key)
    if result == "jumped" or result == "cancelled" then
      return
    end
    -- result == "backspace": loop back to first key state
  end
end

return M

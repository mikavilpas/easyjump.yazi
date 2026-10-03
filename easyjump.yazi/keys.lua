local M = {}

-- Default hint key configuration
-- IMPORTANT: first_keys and second_keys must NOT overlap
-- stylua: ignore
M. DEFAULT_FIRST_KEYS = {
  "a", "s", "d", "f", "g", "e", "r", "c", "w", "t", "v", "x", "b", "q"
}

-- stylua: ignore
M. DEFAULT_SECOND_KEYS = {
  "u", "i", "o", "h", "j", "k", "l", "n", "p", "y", "m"
}

-- Default single labels (for backward compatibility with original order)
-- stylua: ignore
M. DEFAULT_SINGLE_LABELS = {
  "p", "b", "e", "t", "a", "o", "i", "n", "s", "r", "h", "l", "d", "c",
  "u", "m", "f", "g", "w", "v", "k", "j", "x", "y", "q"
}

-- Default double labels (for backward compatibility with original order)
-- stylua: ignore
M. DEFAULT_DOUBLE_LABELS = {
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
function M.normalize_keys(keys)
  if type(keys) == "string" then
    return string_to_table(keys)
  end
  return keys
end

return M

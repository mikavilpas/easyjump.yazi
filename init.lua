-- stylua: ignore
local SINGLE_KEYS = {
	"p", "b", "e", "t", "a", "o", "i", "n", "s", "r", "h", "l", "d", "c",
	"u", "m", "f", "g", "w", "v", "k", "j", "x", "y", "q"
}

-- stylua: ignore
local NORMAL_DOUBLE_KEYS = {
	"au", "ai", "ao", "ah", "aj", "ak", "al", "an", "su", "si", "so", "sh",
	"sj", "sk", "sl", "sn", "du", "di", "do", "dh", "dj", "dk", "dl", "dn",
	"fu", "fi", "fo", "fh", "fj", "fk", "fl", "fn", "gu", "gi", "go", "gh", 
	"gj", "gk", "gl", "gn", "eu", "ei", "eo", "eh", "ej", "ek", "el", "en", 
	"ru", "ri", "ro", "rh", "rj", "rk", "rl", "rn", "cu",

	"ci", "co", "ch", "cj", "ck", "cl", "cn", "wu", "wi", "wo", "wh", "wj",
	"wk", "wl", "wn", "tu", "ti", "to", "th", "tj", "tk", "tl", "tn", "vu",
	"vi", "vo", "vh", "vj", "vk", "vl", "vn", "xu", "xi", "xo", "xh", "xj",
	"xk", "xl", "xn", "bu", "bi", "bo", "bh", "bj", "bk", "bl", "qp", "qy",
	"qm",

	"bn", "qu", "qi", "qo", "qh", "qj", "qk", "ql", "qn", "ap", "ay", "am",
	"fp", "fy", "fm", "ep", "ey", "em", "sp", "sy", "sm", "dp", "dy", "dm",
	"gp", "gy", "gm", "rp", "ry", "rm", "cp", "cy", "cm", "wp", "wy", "wm",
	"xp", "xy", "xm", "tp", "ty", "tm", "vp", "vy", "vm", "bp", "by", "bm",

}

local SINGAL_POS = {["j"] = 22, ["x"] = 23, ["y"] = 24, ["q"] = 25, ["p"] = 1, ["b"] = 2, ["e"] = 3, ["t"] = 4, ["a"] = 5, ["o"] = 6, ["i"] = 7, ["n"] = 8, ["s"] = 9, ["r"] = 10, ["h"] = 11, ["l"] = 12, ["d"] = 13, ["c"] = 14, ["u"] = 15, ["m"] = 16, ["f"] = 17, ["g"] = 18, ["w"] = 19, ["v"] = 20, ["k"] = 21}
local DOUBLE_POS = {["bu"] = 97, ["bi"] = 98, ["bo"] = 99, ["bh"] = 100, ["bj"] = 101, ["bk"] = 102, ["bl"] = 103, ["qp"] = 104, ["qy"] = 105, ["qm"] = 106, ["bn"] = 107, ["qu"] = 108, ["qi"] = 109, ["qo"] = 110, ["qh"] = 111, ["qj"] = 112, ["qk"] = 113, ["ql"] = 114, ["qn"] = 115, ["ap"] = 116, ["ay"] = 117, ["am"] = 118, ["fp"] = 119, ["fy"] = 120, ["fm"] = 121, ["ep"] = 122, ["ey"] = 123, ["em"] = 124, ["sp"] = 125, ["sy"] = 126, ["sm"] = 127, ["dp"] = 128, ["dy"] = 129, ["dm"] = 130, ["gp"] = 131, ["gy"] = 132, ["gm"] = 133, ["rp"] = 134, ["ry"] = 135, ["rm"] = 136, ["cp"] = 137, ["au"] = 1, ["ai"] = 2, ["ao"] = 3, ["ah"] = 4, ["aj"] = 5, ["ak"] = 6, ["al"] = 7, ["an"] = 8, ["su"] = 9, ["si"] = 10, ["so"] = 11, ["sh"] = 12, ["sj"] = 13, ["sk"] = 14, ["sl"] = 15, ["sn"] = 16, ["ty"] = 147, ["tm"] = 148, ["vp"] = 149, ["vy"] = 150, ["vm"] = 151, ["bp"] = 152, ["by"] = 153, ["bm"] = 154, ["do"] = 19, ["tp"] = 146, ["xm"] = 145, ["xy"] = 144, ["xp"] = 143, ["wm"] = 142, ["wy"] = 141, ["wp"] = 140, ["cm"] = 139, ["cy"] = 138, ["du"] = 17, ["di"] = 18, ["dh"] = 20, ["dj"] = 21, ["dk"] = 22, ["dl"] = 23, ["dn"] = 24, ["fu"] = 25, ["fi"] = 26, ["fo"] = 27, ["fh"] = 28, ["fj"] = 29, ["fk"] = 30, ["fl"] = 31, ["fn"] = 32, ["gu"] = 33, ["gi"] = 34, ["go"] = 35, ["gh"] = 36, ["gj"] = 37, ["gk"] = 38, ["gl"] = 39, ["gn"] = 40, ["eu"] = 41, ["ei"] = 42, ["eo"] = 43, ["eh"] = 44, ["ej"] = 45, ["ek"] = 46, ["el"] = 47, ["en"] = 48, ["ru"] = 49, ["ri"] = 50, ["ro"] = 51, ["rh"] = 52, ["rj"] = 53, ["rk"] = 54, ["rl"] = 55, ["rn"] = 56, ["cu"] = 57, ["ci"] = 58, ["co"] = 59, ["ch"] = 60, ["cj"] = 61, ["ck"] = 62, ["cl"] = 63, ["cn"] = 64, ["wu"] = 65, ["wi"] = 66, ["wo"] = 67, ["wh"] = 68, ["wj"] = 69, ["wk"] = 70, ["wl"] = 71, ["wn"] = 72, ["tu"] = 73, ["ti"] = 74, ["to"] = 75, ["th"] = 76, ["tj"] = 77, ["tk"] = 78, ["tl"] = 79, ["tn"] = 80, ["vu"] = 81, ["vi"] = 82, ["vo"] = 83, ["vh"] = 84, ["vj"] = 85, ["vk"] = 86, ["vl"] = 87, ["vn"] = 88, ["xu"] = 89, ["xi"] = 90, ["xo"] = 91, ["xh"] = 92, ["xj"] = 93, ["xk"] = 94, ["xl"] = 95, ["xn"] = 96}


local INPUT_KEY = {
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
	"o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "<Esc>"
}

local INPUT_CANDS = {
	{ on = "a" }, { on = "b" }, { on = "c" }, { on = "d" }, { on = "e" },
	{ on = "f" }, { on = "g" }, { on = "h" }, { on = "i" }, { on = "j" },
	{ on = "k" }, { on = "l" }, { on = "m" }, { on = "n" }, { on = "o" },
	{ on = "p" }, { on = "q" }, { on = "r" }, { on = "s" }, { on = "t" },
	{ on = "u" }, { on = "v" }, { on = "w" }, { on = "x" }, { on = "y" },
	{ on = "z" }, { on = "<Esc>" }
}

local toggle_ui = ya.sync(function(st)

	if st.icon or st.mode then
		File.icon, Status.mode, st.icon, st.mode = st.icon, st.mode, nil, nil
		ya.render()
		return
	end

	st.icon, st.mode = File.icon, Status.mode

	File.icon = function(self, file)

		local icon = file:icon()
		local span_icon_before = file:is_hovered() and ui.Span(" " .. file:icon().text .. " ") or ui.Span(" " .. file:icon().text .. " "):style(icon.style)
		
		local pos = st.file_pos[tostring(file.url)]
		if not pos then
			return st.icon(self, file)
		elseif st.current_num > #SINGLE_KEYS then
			if st.double_first_key ~= nil and NORMAL_DOUBLE_KEYS[pos]:sub(1,1) == st.double_first_key then
				return ui.Line {span_icon_before,ui.Span(NORMAL_DOUBLE_KEYS[pos]:sub(1,1)):fg(st.opt_first_key_fg),ui.Span(NORMAL_DOUBLE_KEYS[pos]:sub(2,2) .. " "):fg(st.opt_icon_fg)}
			else
				return ui.Line {span_icon_before,ui.Span(NORMAL_DOUBLE_KEYS[pos] .. " "):fg(st.opt_icon_fg)}
			end
		else
			return ui.Line {span_icon_before,ui.Span(SINGLE_KEYS[pos] .. " "):fg(st.opt_icon_fg)}
		end
	end

	Status.mode = function(self)
		local style = self.style()
		return ui.Line {
			ui.Span(THEME.status.separator_open):fg(style.bg),
			ui.Span(" EJ-" .. tostring(cx.active.mode):upper() .. " "):style(style),
		}
	end

	ya.render()
end)


local apply = ya.sync(function(state, arg_cand)

	local pos = tonumber(arg_cand)
	local folder = Folder:by_kind(Folder.CURRENT)
	ya.manager_emit("arrow",{ pos - folder.cursor - 1 + folder.offset})	
	return true
end)


local update_double_first_key = ya.sync(function(state, str)
	state.double_first_key = str
	ya.render()
end)

local function is_first_key_valid(key,current_num)
	for i, value in ipairs(NORMAL_DOUBLE_KEYS) do
		if i > current_num then
			return false
		end
		if value:sub(1,1) == key then
			return true
		end
	end

	return false
end

local function read_input_todo (arg_current_num)

	local current_num = tonumber(arg_current_num)
	local cand = nil
	local key
	local key_num_count = 0
	local pos
	local double_key

	while true do
		cand = ya.which { cands = INPUT_CANDS, silent = true }
		if cand == nil then
			goto nextkey
		end

		if INPUT_KEY[cand] == "<Esc>" then
			return true
		end

		if current_num <= #SINGLE_KEYS then
			key = INPUT_KEY[cand]	
			pos = SINGAL_POS[key]
			if pos == nil or pos > current_num then
				goto nextkey
			else
				return apply(pos, current_num)
			end
		end		

		if key_num_count == 0 and current_num > #SINGLE_KEYS then
			key = INPUT_KEY[cand]
			if is_first_key_valid(key,current_num) then	
				key_num_count =  key_num_count + 1		
				update_double_first_key(key)
			else
				key_num_count = 0
			end
			goto nextkey
		end

		if key_num_count == 1 and current_num > #SINGLE_KEYS then
			double_key = key .. INPUT_KEY[cand]
			pos = DOUBLE_POS[double_key]
			if pos == nil or pos > current_num then
				goto nextkey
			else
				return apply(pos, current_num)
			end
		end

		::nextkey::
	end
end


local init_normal_action = ya.sync(function(state)

	state.file_pos = {}

	if #SINGLE_KEYS >= Current.area.h then
		state.current_num = Current.area.h -- Fast path
	else
		state.current_num = #Folder:by_kind(Folder.CURRENT).window
	end

	for i, file in ipairs(Folder:by_kind(Folder.CURRENT).window) do
		state.file_pos[tostring(file.url)] = i
	end

	return state.current_num
end)

local set_opts_default = ya.sync(function(state)
	if (state.opt_icon_fg == nil) then
		state.opt_icon_fg = "#fda1a1"
	end
	if (state.opt_first_key_fg == nil) then
		state.opt_first_key_fg = "#df6249"
	end
end)

local clear_state_str = ya.sync(function(state)
	state.file_pos = nil
	state.current_num = nil
	state.double_first_key = nil
end)

return {
	setup = function(state, opts)
		-- Save the user configuration to the plugin's state
		if (opts ~= nil and opts.icon_fg ~= nil ) then
			state.opt_icon_fg  = opts.icon_fg
		end
		if (opts ~= nil and opts.first_key_fg ~= nil ) then
			state.opt_first_key_fg  = opts.first_key_fg
		end
	end,

	entry = function(_, args)

		set_opts_default()

		local want_exit = false
		local first_enter = true
		local current_num

		while true do
			-- enter normal, keep or select mode
			current_num = init_normal_action()

			if current_num == nil or current_num == 0 then
				break
			end

			if first_enter then 
				toggle_ui()
				first_enter = false 
			end
			want_exit = read_input_todo(current_num)

			if want_exit == true then
				break
			end
		end


		if first_enter == false then
			toggle_ui()
		end

		clear_state_str()
	end
}

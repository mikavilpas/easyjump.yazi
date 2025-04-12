-- stylua: ignore
local SINGLE_LABLES = {
	"p", "b", "e", "t", "a", "o", "i", "n", "s", "r", "h", "l", "d", "c",
	"u", "m", "f", "g", "w", "v", "k", "j", "x", "y", "q"
}

-- stylua: ignore
local NORMAL_DOUBLE_LABLES = {
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
	
	"ap", "ay", "am",
	"sp", "sy", "sm",
	"dp", "dy", "dm",
	"fp", "fy", "fm",
	"gp", "gy", "gm",
	"ep", "ey", "em",
	"rp", "ry", "rm",
	"cp", "cy", "cm",
	"wp", "wy", "wm",
	"tp", "ty", "tm",
	"vp", "vy", "vm",
	"xp", "xy", "xm",
	"bp", "by", "bm",
	"qp", "qy", "qm",

}

local INPUT_KEY = {
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
	"o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "<Esc>","<Backspace>"
}

local SINGLE_POS = {["k"] = 21, ["j"] = 22, ["x"] = 23, ["y"] = 24, ["q"] = 25, ["p"] = 1, ["b"] = 2, ["e"] = 3, ["t"] = 4, ["a"] = 5, ["o"] = 6, ["i"] = 7, ["n"] = 8, ["s"] = 9, ["r"] = 10, ["h"] = 11, ["l"] = 12, ["d"] = 13, ["c"] = 14, ["u"] = 15, ["m"] = 16, ["f"] = 17, ["g"] = 18, ["w"] = 19, ["v"] = 20}
local DOUBLE_POS = {["au"] = 1, ["ai"] = 2, ["ao"] = 3, ["ah"] = 4, ["aj"] = 5, ["ak"] = 6, ["al"] = 7, ["an"] = 8, ["su"] = 9, ["si"] = 10, ["so"] = 11, ["sh"] = 12, ["sj"] = 13, ["sk"] = 14, ["sl"] = 15, ["sn"] = 16, ["du"] = 17, ["di"] = 18, ["dh"] = 20, ["dj"] = 21, ["dk"] = 22, ["dl"] = 23, ["dn"] = 24, ["fu"] = 25, ["fi"] = 26, ["fo"] = 27, ["fh"] = 28, ["fj"] = 29, ["fk"] = 30, ["fl"] = 31, ["fn"] = 32, ["gu"] = 33, ["gi"] = 34, ["go"] = 35, ["gh"] = 36, ["gj"] = 37, ["gk"] = 38, ["gl"] = 39, ["gn"] = 40, ["eu"] = 41, ["ei"] = 42, ["eo"] = 43, ["eh"] = 44, ["ej"] = 45, ["do"] = 19, ["el"] = 47, ["en"] = 48, ["ru"] = 49, ["ri"] = 50, ["ro"] = 51, ["rh"] = 52, ["rj"] = 53, ["rk"] = 54, ["rl"] = 55, ["rn"] = 56, ["cu"] = 57, ["ci"] = 58, ["co"] = 59, ["ch"] = 60, ["cj"] = 61, ["ck"] = 62, ["cl"] = 63, ["cn"] = 64, ["wu"] = 65, ["wi"] = 66, ["wo"] = 67, ["wh"] = 68, ["wj"] = 69, ["wk"] = 70, ["wl"] = 71, ["wn"] = 72, ["tu"] = 73, ["ti"] = 74, ["to"] = 75, ["th"] = 76, ["tj"] = 77, ["tk"] = 78, ["tl"] = 79, ["tn"] = 80, ["vu"] = 81, ["vi"] = 82, ["vo"] = 83, ["vh"] = 84, ["vj"] = 85, ["vk"] = 86, ["vl"] = 87, ["vn"] = 88, ["xu"] = 89, ["xi"] = 90, ["xo"] = 91, ["xh"] = 92, ["xj"] = 93, ["xk"] = 94, ["xl"] = 95, ["xn"] = 96, ["bu"] = 97, ["bi"] = 98, ["bo"] = 99, ["bh"] = 100, ["bj"] = 101, ["bk"] = 102, ["bl"] = 103, ["bn"] = 104, ["qu"] = 105, ["qi"] = 106, ["qo"] = 107, ["qh"] = 108, ["qj"] = 109, ["qk"] = 110, ["ql"] = 111, ["qn"] = 112, ["ap"] = 113, ["ay"] = 114, ["am"] = 115, ["sp"] = 116, ["sy"] = 117, ["sm"] = 118, ["dp"] = 119, ["dy"] = 120, ["dm"] = 121, ["fp"] = 122, ["fy"] = 123, ["fm"] = 124, ["gp"] = 125, ["gy"] = 126, ["gm"] = 127, ["ep"] = 128, ["ey"] = 129, ["em"] = 130, ["rp"] = 131, ["ry"] = 132, ["rm"] = 133, ["cp"] = 134, ["cy"] = 135, ["cm"] = 136, ["wp"] = 137, ["wy"] = 138, ["wm"] = 139, ["ty"] = 141, ["tm"] = 142, ["vp"] = 143, ["vy"] = 144, ["vm"] = 145, ["xp"] = 146, ["xy"] = 147, ["xm"] = 148, ["bp"] = 149, ["by"] = 150, ["bm"] = 151, ["qp"] = 152, ["qy"] = 153, ["qm"] = 154, ["tp"] = 140, ["ek"] = 46}

local INPUT_CANDS = {
	{ on = "a" }, { on = "b" }, { on = "c" }, { on = "d" }, { on = "e" },
	{ on = "f" }, { on = "g" }, { on = "h" }, { on = "i" }, { on = "j" },
	{ on = "k" }, { on = "l" }, { on = "m" }, { on = "n" }, { on = "o" },
	{ on = "p" }, { on = "q" }, { on = "r" }, { on = "s" }, { on = "t" },
	{ on = "u" }, { on = "v" }, { on = "w" }, { on = "x" }, { on = "y" },
	{ on = "z" }, { on = "<Esc>" },{ on = "<Backspace>" }
}

local toggle_ui = ya.sync(function(st)

	if st.entity_lable_id or st.status_ej_id then
		Entity:children_remove(st.entity_lable_id)
		Status:children_remove(st.status_ej_id)
		st.entity_lable_id = nil
		st.status_ej_id = nil
		Entity._inc = Entity._inc - 1
		Status._inc = Status._inc - 1
		ya.render()
		return
	end

	local entity_lable = function(self)
		local file = self._file
		local pos = st.file_pos[tostring(file.url)]
		if not pos then
			return ui.Line{}
		elseif st.current_num > #SINGLE_LABLES then
			if st.double_first_key ~= nil and NORMAL_DOUBLE_LABLES[pos]:sub(1,1) == st.double_first_key then
				return ui.Line {ui.Span(NORMAL_DOUBLE_LABLES[pos]:sub(1,1)):fg(st.opt_first_key_fg),ui.Span(NORMAL_DOUBLE_LABLES[pos]:sub(2,2) .. " "):fg(st.opt_icon_fg)}
			else
				return ui.Line {ui.Span(NORMAL_DOUBLE_LABLES[pos] .. " "):fg(st.opt_icon_fg)}
			end
		else
			return ui.Line {ui.Span(SINGLE_LABLES[pos] .. " "):fg(st.opt_icon_fg)}
		end
	end
	st.entity_lable_id  = Entity:children_add(entity_lable,2001)

	local status_ej = function(self)
		local style = self:style()
		return ui.Line {
			ui.Span("[EJ] "):style(style.main),
		}
	end
	st.status_ej_id = Status:children_add(status_ej,1001,Status.LEFT)

	ya.render()
end)

local update_double_first_key = ya.sync(function(state, str)
	state.double_first_key = str
end)

local function read_input_todo (current_num,cursor,offset,first_key_of_lable)

	local cand = nil
	local key
	local key_num_count = 0
	local pos
	local double_key

	while true do
		cand = ya.which { cands = INPUT_CANDS, silent = true }

		-- not candy key, continue get input
		if cand == nil then
			goto nextkey
		end

		-- hit exit easyjump
		if INPUT_KEY[cand] == "<Esc>" or INPUT_KEY[cand] == "z"  then
			return
		end

		-- hit singal key
		if current_num <= #SINGLE_LABLES then
			key = INPUT_KEY[cand]	
			pos = SINGLE_POS[key]
			if pos == nil or pos > current_num then
				goto nextkey
			else
				ya.mgr_emit("arrow",{ pos - cursor - 1 + offset })	
				return
			end
		end		

		-- hit backout a double key
		if INPUT_KEY[cand] == "<Backspace>" and current_num > #SINGLE_LABLES then
			key_num_count = 0 -- backout to get the first double key
			update_double_first_key(nil) -- apply to the render change for first key
			goto nextkey
		end

		-- hit the first double key
		if key_num_count == 0 and current_num > #SINGLE_LABLES then
			key = INPUT_KEY[cand]
			if first_key_of_lable[key] then	 
				key_num_count =  key_num_count + 1		
				update_double_first_key(key) -- apply to the render change for first key
			else
				key_num_count = 0 -- get the first double key fail, continue to get it
			end
			goto nextkey
		end

		-- hit the second double key
		if key_num_count == 1 and current_num > #SINGLE_LABLES then
			double_key = key .. INPUT_KEY[cand]
			pos = DOUBLE_POS[double_key]
			if pos == nil or pos > current_num then -- get the second double key fail, continue to get it
				goto nextkey
			else
				ya.mgr_emit("arrow",{ pos - cursor - 1 + offset })	
				return
			end
		end

		::nextkey::
	end
end

-- init to record file position and the file num
local init = ya.sync(function(state)

	state.file_pos = {}
	local first_key_of_lable = {}
	local folder = cx.active.current

	state.current_num = #folder.window

	for i, file in ipairs(folder.window) do
		state.file_pos[tostring(file.url)] = i
		if state.current_num > #SINGLE_LABLES then
			first_key_of_lable[NORMAL_DOUBLE_LABLES[i]:sub(1,1)] = ""
		end
	end

	return state.current_num,folder.cursor,folder.offset,first_key_of_lable
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

	entry = function(_, _)

		set_opts_default()

		local current_num,cursor,offset,first_key_of_lable = init()

		if current_num == nil or current_num == 0 then
			return
		end
	
		toggle_ui()

		read_input_todo(current_num,cursor,offset,first_key_of_lable)

		toggle_ui()
		clear_state_str()
	end
}

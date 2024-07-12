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
		elseif st.current_num > #SINGLE_LABLES then
			if st.double_first_key ~= nil and NORMAL_DOUBLE_LABLES[pos]:sub(1,1) == st.double_first_key then
				return ui.Line {span_icon_before,ui.Span(NORMAL_DOUBLE_LABLES[pos]:sub(1,1)):fg(st.opt_first_key_fg),ui.Span(NORMAL_DOUBLE_LABLES[pos]:sub(2,2) .. " "):fg(st.opt_icon_fg)}
			else
				return ui.Line {span_icon_before,ui.Span(NORMAL_DOUBLE_LABLES[pos] .. " "):fg(st.opt_icon_fg)}
			end
		else
			return ui.Line {span_icon_before,ui.Span(SINGLE_LABLES[pos] .. " "):fg(st.opt_icon_fg)}
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
	for i, value in ipairs(NORMAL_DOUBLE_LABLES) do
		if i > current_num then
			return false
		end
		if value:sub(1,1) == key then
			return true
		end
	end

	return false
end

local function is_whole_key_valid(key,current_num)

	if current_num > #SINGLE_LABLES then 
		for i, value in ipairs(NORMAL_DOUBLE_LABLES) do
			if i > current_num then
				return nil
			end
			if value == key then
				return i
			end
		end
	else
		for i, value in ipairs(SINGLE_LABLES) do
			if i > current_num then
				return nil
			end
			if value == key then
				return i
			end
		end
	end

	return nil
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

		if current_num <= #SINGLE_LABLES then
			key = INPUT_KEY[cand]	
			pos = is_whole_key_valid(key,current_num)
			if pos == nil or pos > current_num then
				goto nextkey
			else
				return apply(pos, current_num)
			end
		end		

		if key_num_count == 0 and current_num > #SINGLE_LABLES then
			key = INPUT_KEY[cand]
			if is_first_key_valid(key,current_num) then	
				key_num_count =  key_num_count + 1		
				update_double_first_key(key)
			else
				key_num_count = 0
			end
			goto nextkey
		end

		if key_num_count == 1 and current_num > #SINGLE_LABLES then
			double_key = key .. INPUT_KEY[cand]
			pos = is_whole_key_valid(double_key,current_num)
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

	if #SINGLE_LABLES >= Current.area.h then
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

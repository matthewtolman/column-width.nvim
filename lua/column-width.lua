local ColumnWidth = {}

local column_width_excludes = {
	'qf',
	'man',
	'md',
	'help',
	'checkhealth',
	'lazy',
	'packer',
	'NvimTree',
	'Telescope',
	'WhichKey',
}

local __default_colors = {
	['zig'] = '#f69a1b',
	['javascript'] = '#f1f134',
	['cpp'] = '#519aba',
	['c++'] = '#519aba',
	['c'] = '#589eff',
	['rust'] = '#dea584',
	['erlang'] = '#b83998',
	['elixir'] = '#a075c4',
	['typescript'] = '#519aba',
	['lua'] = '#51a0cf',
	['clojure'] = '#8dc149',
	['java'] = '#c93d44',
	['kotlin'] = '#7f51ff',
	['cs'] = '#57640c',
	['sass'] = '#e8507f',
	['css'] = '#42a5f5',
	['html'] = '#e44d26',
	['python'] = '#ffbc05',
	['go'] = '#00a8d1',
	['json'] = '#bdbd3e',
	['toml'] = 'lightgrey',
	['yaml'] = 'grey',
}

local __default_exclusions = {
	'qf',
	'man',
	'md',
	'help',
	'checkhealth',
	'lazy',
	'packer',
	'NvimTree',
	'Telescope',
	'WhichKey',
}

local __default_width = 80
local __default_color = '#444455'

local __default_widths = {}

function table.copy(t)
  local u = { }
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
end


local function fallbackWidth()
	return __default_width
end

local function fallbackColor()
	return __default_color
end

local function defaultWidths()
	return table.copy(__default_widths)
end

local function defaultColors()
	return table.copy(__default_colors)
end

local function defaultExclusions()
	return table.copy(__default_exclusions)
end

local column_width_default = fallbackWidth()
local column_widths = defaultWidths()
local color_col_enabled = false

local column_width_color_default = fallbackColor()
local column_width_colors = defaultColors()

local function setColorColumn()
	for _, exclusion in ipairs(column_width_excludes) do
		if vim.bo.filetype == exclusion then
			-- hide the color column
			vim.api.nvim_buf_set_var(0, "init_cc", 0)
			vim.cmd("let &colorcolumn = 0")
			return
		end
	end

	if vim.fn.exists("b:init_cc") == 0 then
		vim.api.nvim_buf_set_var(0, "init_cc", 1)
	end

	if color_col_enabled == false then
		vim.cmd("let &colorcolumn = 0")
		return
	end

	local width = (column_widths[vim.bo.filetype] or column_width_default) + 1
	-- b:init_cc is a buffer-local variable for allowing only showing the
	-- color column in the *current* buffer
	if vim.fn.exists("b:init_cc") ~= 0 then
		vim.cmd("let &colorcolumn = " .. width)
	else
		-- Set the buffer info on initial load
		vim.cmd("setlocal colorcolumn=" .. width)
	end

	-- Adjust the column
	local color = column_width_colors[vim.bo.filetype] or column_width_color_default
	local cmd2 = "hi ColorColumn guibg=" .. color
	vim.cmd(cmd2)
end

function ColumnWidth.set(language, field, value)
	if field == "color" or field == "col" or field == "c" then
		if language == "" or language == nil then
			column_width_color_default = value
			column_width_colors = {}
		else
			column_width_colors[language] = value
		end
	elseif field == "width" or field == "wid" or field == "w" then
		column_width_default = value
		column_widths = {}
	else
		error(string.format("Unknown field: %s. Expected one of c[ol[or]], w[id[th]]", field))
	end

	setColorColumn()
end

function ColumnWidth.reset()
	column_width_colors = defaultColors()
	column_widths = defaultWidths()
	column_width_default = fallbackWidth()
	column_width_color_default = fallbackColor()
	column_width_excludes = defaultExclusions()

	setColorColumn()
end

function ColumnWidth.clear(language, field)
	if field == "color" or field == "col" or field == "c" then
		if language == "" or language == nil then
			if column_width_colors[vim.bo.filetype] then
				column_width_colors[vim.bo.filetype] = nil
			else
				column_width_color_default = ColumnWidth.fallbackColor()
			end
		else
			column_width_colors[language] = nil
		end
	elseif field == "width" or field == "wid" or field == "w" then
		if language == "" or language == nil then
			if column_widths[vim.bo.filetype] then
				column_widths[vim.bo.filetype] = nil
			else
				column_width_default = ColumnWidth.fallbackWidth()
			end
		else
			column_widths[language] = nil
		end
	else
		error(string.format("Unknown field: %s. Expected one of c[ol[or]], w[id[th]]", field))
	end

	setColorColumn()
end

function ColumnWidth.exclude(filetype)
	table.insert(column_width_excludes, filetype)
	setColorColumn()
end

local function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function ColumnWidth.include(filetype)
	local index = indexOf(column_width_excludes, filetype)
	if index then
		table.remove(column_width_excludes, index)
	end
	setColorColumn()
end

function ColumnWidth.toggle()
	if color_col_enabled then
		color_col_enabled = false
	else
		color_col_enabled = true
	end
	setColorColumn()
end

function ColumnWidth.show()
	color_col_enabled = true
	setColorColumn()
end

function ColumnWidth.hide()
	color_col_enabled = false
	setColorColumn()
end

function ColumnWidth.defaultColors()
	return defaultColors()
end

function ColumnWidth.defaultExclusions()
	return defaultExclusions()
end

function ColumnWidth.defaultBindings()
	return {
			toggle = '<leader>ct',
			show = '<leader>cs',
			hide = '<leader>ch',
		}
end

function ColumnWidth.setup(opts)
	if not opts then
		opts = {}
	end

	setmetatable(opts, {
		__index = {
			enabled = false,
			colors = ColumnWidth.defaultColors(),
			exclusions = ColumnWidth.defaultExclusions(),
			widths = {},
			defaultWidth = 80,
			defaultColor = '#444455',
			bind = true,
			bindings = ColumnWidth.defaultBindings(),
		}
	})

	__default_colors = table.copy(opts.colors)
	column_width_colors = opts.colors

	__default_exclusions = table.copy(opts.exclusions)
	column_width_excludes = opts.exclusions

	__default_width = opts.defaultWidth
	column_width_default = opts.defaultWidth

	__default_color = opts.defaultColor
	column_width_color_default = opts.defaultColor

	__default_widths = table.copy(opts.widths)
	column_widths = opts.widths

	color_col_enabled = opts.enabled

	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		pattern = "*",
		callback = function(_)
			setColorColumn()
		end
	})

	-- Toggle and remove color column info when leaving a buffer
	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		pattern = "*",
		callback = function(_)
			vim.cmd("let &colorcolumn = 0")
		end
	})

	if opts.bind ~= false then
		ColumnWidth.keybinds(opts.bindings)
	end
end

function ColumnWidth.keybinds(bindings)
	if not bindings then
		bindings = {}
	end

	setmetatable(bindings, {
		__index = ColumnWidth.defaultBindings()
	})

	if bindings.toggle ~= '' then
		vim.keymap.set({ 'n', 'v' }, bindings.toggle, ColumnWidth.toggle, { desc = '[T]oggle column width' })
	end

	if bindings.show ~= '' then
		vim.keymap.set({ 'n', 'v' }, bindings.show, ColumnWidth.show, { desc = '[S]how column width' })
	end

	if bindings.hide ~= '' then
		vim.keymap.set({ 'n', 'v' }, bindings.hide, ColumnWidth.hide, { desc = '[H]ide column width' })
	end
end

return ColumnWidth

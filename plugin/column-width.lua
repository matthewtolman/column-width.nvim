vim.api.nvim_create_user_command(
	"ColumnWidthToggle",
	function (_)
		local ColumnWidth = require("column-width")
		ColumnWidth.toggle()
	end,
	{
		desc = "Toggles showing the column width indicator",
		nargs = 0,
	}
)

vim.api.nvim_create_user_command(
	"ColumnWidthHide",
	function (_)
		local ColumnWidth = require("column-width")
		ColumnWidth.hide()
	end,
	{
		desc = "Hides the column width indicator",
		nargs = 0,
	}
)

vim.api.nvim_create_user_command(
	"ColumnWidthShow",
	function (_)
		local ColumnWidth = require("column-width")
		ColumnWidth.show()
	end,
	{
		desc = "Shows the column width indicator",
		nargs = 0,
	}
)

vim.api.nvim_create_user_command(
	"ColumnWidthSetField",
	function (opts)
		local ColumnWidth = require("column-width")

		local args = {}
		local kwargs = {}

		for _, arg in ipairs({ unpack(opts.fargs, 1) }) do
		    local key, value = string.match(arg, "^(.*)=(.*)$")

		    if value == "" then
			value = nil
		    end

		    if not key then
			table.insert(args, tonumber(arg) or arg)
		    else
			kwargs[key] = tonumber(value) or value
		    end
		end

		local language = nil
		local field = nil
		local value = nil

		local numArgs = #args
		if numArgs > 0 and not vim.tbl_isempty(kwargs) then
			error("Cannot mix keyword and positional args")
		end

		if numArgs >= 3 then
			language = args[1]
			field = args[2]
			value = args[3]
		elseif numArgs == 2 then
			field = args[1]
			value = args[2]
		elseif numArgs == 1 then
			error("Expected [language] field value, received just value" .. numArgs)
		else
			language = kwargs['language'] or kwargs['lang'] or kwargs['l']
			field = kwargs['field'] or kwargs['f'] or error('Missing f[ield]')
			value = kwargs['value'] or kwargs['val'] or kwargs['v'] or error('Missing v[al[ue]]')
		end

		ColumnWidth.set(language, field, value)
	end,
	{
		desc = "Sets a specific field of the column width indicator (color or width). May limit it to either just a specific language/filetype, or apply to all filetypes.\nUsage:\n\t:ColorWidthSetField [language] (c[ol[or]]|w[id[th]]) value\n\nExamples:\n\t:ColorWidthSetField color blue\n\t:ColorWidthSetField cpp wid 150\n\t:ColorWidthSetField cs c #442200",
		nargs = '+',
	}
)

vim.api.nvim_create_user_command(
	"ColumnWidthClearField",
	function (opts)
		local ColumnWidth = require("column-width")

		local args = {}
		local kwargs = {}

		for _, arg in ipairs({ unpack(opts.fargs, 1) }) do
		    local key, value = string.match(arg, "^(.*)=(.*)$")

		    if value == "" then
			value = nil
		    end

		    if not key then
			table.insert(args, tonumber(arg) or arg)
		    else
			kwargs[key] = tonumber(value) or value
		    end
		end

		local language = nil
		local field = nil

		local numArgs = #args
		if numArgs > 0 and not vim.tbl_isempty(kwargs) then
			error("Cannot mix keyword and positional args")
		end

		if numArgs >= 2 then
			language = args[1]
			field = args[2]
		elseif numArgs == 1 then
			field = args[1]
		else
			language = kwargs['language'] or kwargs['lang'] or kwargs['l']
			field = kwargs['field'] or kwargs['f'] or error('Missing f[ield]')
		end

		ColumnWidth.clear(language, field)
	end,
	{
		desc = "Clears any language overrides (including defaults) for a field of the column width indicator (color or width). May limit it to either just a specific language/filetype, or apply to all filetypes.\nUsage:\n\t:ColorWidthClearField [language] (c[ol[or]]|w[id[th]])\n\nExamples:\n\t:ColorWidthSetField color\n\t:ColorWidthSetField cpp wid\n\t:ColorWidthSetField cs c",
		nargs = '+',
	}
)

vim.api.nvim_create_user_command(
	"ColumnWidthReset",
	function (_)
		local ColumnWidth = require("column-width")
		ColumnWidth.reset()
	end,
	{
		desc = "Resets to default configuration",
		nargs = 0,
	}
)

vim.api.nvim_create_user_command(
	"ColumnWidthExclude",
	function (opts)
		local ColumnWidth = require("column-width")
		ColumnWidth.exclude(opts.fargs[2] or vim.bo.filetype)
	end,
	{
		desc = "Excludes a filetype/language from having a column width indicator. If nothing is provided, will exclude current filetype/language.",
		nargs = '?',
	}
)

vim.api.nvim_create_user_command(
	"ColumnWidthInclude",
	function (opts)
		local ColumnWidth = require("column-width")
		ColumnWidth.include(opts.fargs[2] or vim.bo.filetype)
	end,
	{
		desc = "Excludes a filetype/language from having a column width indicator. If nothing is provided, will exclude current filetype/language.",
		nargs = 1,
	}
)


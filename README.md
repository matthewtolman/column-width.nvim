## Column-Width

Shows a column width indicator for the currently active panel. Allows changing the indicator color based on the type of file
being edited.

> Note: This is meant to be a fun personal column width indicator. If you want something robust, featureful, or accepting
contributions, this is not it.

### Commands

* `:ColumnWidthToggle` - toggles inidcator
* `:ColumnWidthShow` - shows indicator
* `:ColumnWidthHide` - hides indicator
* `:ColumnWidthReset` - resets to initial configuration
* `:ColumnWidthExclude` - Excludes a file type from showing the indicator
* `:ColumnWidthInclude` - Includes a file type in showing the indicator
* `:ColumnWidthSetField` - Sets a field value (optionally restricted to a language)
    * Example: `:ColumnWidthSetField cpp color red`
    * Fields: *color* or *width*
* `:ColumnWidthClearField` - Clears the value for a field (will use the global default value, not the original value)

### Configuration

Will need to call `setup()` and pass in a table of options (for Lazy, use `opts = {...}`).
Setup can have the following:

* `enabled` - Whether the indicator is enabled (default: false)
* `colors` - table of language to colors
* `exlusions` - list of exclusions
* `widths` - table of language to column widths
* `defaultWidth` - global default width
* `defaultColor` - global default color
* `bind` - whether to add key bindings (default: true)
* `bindings` - table of bindings for actions
    * `toggle` - keybindings for toggling
    * `show` - keybindings for showing
    * `hide` - keybindings for hiding

## Similar Projects

* [Bekaboo/deadcolumn.nvim](https://github.com/Bekaboo/deadcolumn.nvim)
* [m4xshen/smartcolumn.nvim](https://github.com/m4xshen/smartcolumn.nvim)
* [lukas/reineke/virt-column.nvim](https://github.com/lukas-reineke/virt-column.nvim)
* [xiyaowong/virtcolumn.nvim](https://github.com/xiyaowong/virtcolumn.nvim)


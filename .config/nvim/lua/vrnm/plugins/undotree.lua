return {
	"mbbill/undotree",
	config = function()
		vim.cmd([[
                if !exists('g:undotree_SetFocusWhenToggle')
                    let g:undotree_SetFocusWhenToggle = 1
                endif
      ]])
	end,
}

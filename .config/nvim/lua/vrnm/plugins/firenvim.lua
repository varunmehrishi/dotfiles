return {
	"glacambre/firenvim",
	init = function()
		require("vrnm.firenvim").setup()

		local manual_only = {
			cmdline = "neovim",
			content = "text",
			priority = 0,
			selector = 'textarea:not([readonly], [aria-readonly="true"]), [contenteditable]:not([contenteditable="false"], [aria-readonly="true"])',
			takeover = "never",
		}
		local complex_manual_only = vim.tbl_extend("force", {}, manual_only, {
			priority = 100,
		})

		vim.g.firenvim_config = {
			localSettings = {
				[".*"] = manual_only,

				-- Keep complex web editors untouched unless Firenvim is
				-- explicitly invoked with its browser shortcut.
				["https?://docs\\.google\\.com/(document|spreadsheets|presentation)/"] = complex_manual_only,
				["https?://([^/]+\\.)?(quip\\.com|notion\\.so|figma\\.com|canva\\.com|slack\\.com|office\\.com|microsoft365\\.com|officeapps\\.live\\.com)/"] = complex_manual_only,
			},
		}
	end,
	build = function()
		vim.fn["firenvim#install"](0)
	end,
}

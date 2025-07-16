return {
	"mrcjkb/rustaceanvim",
	version = "^6", -- Latest version (v6)
	ft = { "rust" }, -- Only load for Rust files
	dependencies = {
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap", -- For debugging support
	},
	config = function()
		-- Set up rustaceanvim with modern configuration
		vim.g.rustaceanvim = {
			-- Plugin configuration
			tools = {
				-- Automatically reload workspace when Cargo.toml changes
				reload_workspace_from_cargo_toml = true,

				-- Hover actions configuration
				hover_actions = {
					auto_focus = true,
					border = "rounded",
				},

				-- Code action groups
				code_action_group = {
					auto_focus = true,
					border = "rounded",
				},

				-- Automatically set virtual text for diagnostics
				on_initialized = function()
					vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
						pattern = { "*.rs" },
						callback = function()
							vim.lsp.codelens.refresh()
						end,
					})
				end,
			},

			-- DAP configuration
			dap = {
				adapter = {
					type = "executable",
					command = "lldb-vscode",
					name = "rt_lldb",
				},
			},

			-- LSP server configuration
			server = {
				on_attach = function(client, bufnr)
					-- Call your standard LSP on_attach function
					require("vrnm.lsp.handlers").on_attach(client, bufnr)

					-- Add Rust-specific keybindings
					local opts = { buffer = bufnr, noremap = true, silent = true }

					-- Runnables
					vim.keymap.set("n", "<leader>rr", function()
						vim.cmd.RustLsp("runnables")
					end, opts)

					-- Debugging
					vim.keymap.set("n", "<leader>rd", function()
						vim.cmd.RustLsp("debuggables")
					end, opts)

					-- Expand macro
					vim.keymap.set("n", "<leader>rem", function()
						vim.cmd.RustLsp("expandMacro")
					end, opts)

					-- Open Cargo.toml
					vim.keymap.set("n", "<leader>roc", function()
						vim.cmd.RustLsp("openCargo")
					end, opts)

					-- Parent module
					vim.keymap.set("n", "<leader>rpm", function()
						vim.cmd.RustLsp("parentModule")
					end, opts)

					-- Join lines
					vim.keymap.set("n", "<leader>rjl", function()
						vim.cmd.RustLsp("joinLines")
					end, opts)

					-- Hover actions
					vim.keymap.set("n", "<leader>rha", function()
						vim.cmd.RustLsp("hover", "actions")
					end, opts)

					-- Hover range
					vim.keymap.set("n", "<leader>rhr", function()
						vim.cmd.RustLsp("hover", "range")
					end, opts)

					-- Move item down
					vim.keymap.set("n", "<leader>rmd", function()
						vim.cmd.RustLsp("moveItem", "down")
					end, opts)

					-- Move item up
					vim.keymap.set("n", "<leader>rmu", function()
						vim.cmd.RustLsp("moveItem", "up")
					end, opts)

					-- View crate graph
					vim.keymap.set("n", "<leader>rv", function()
						vim.cmd.RustLsp("crateGraph")
					end, opts)

					-- Reload workspace
					vim.keymap.set("n", "<leader>rw", function()
						vim.cmd.RustLsp("reloadWorkspace")
					end, opts)

					-- SSR (Structural Search Replace)
					vim.keymap.set("n", "<leader>rss", function()
						vim.cmd.RustLsp("ssr")
					end, opts)

					-- External docs
					vim.keymap.set("n", "<leader>rxd", function()
						vim.cmd.RustLsp("externalDocs")
					end, opts)

					-- Inlay hints
					vim.keymap.set("n", "<leader>rh", function()
						vim.cmd.RustLsp("inlayHints", "enable")
					end, opts)

					vim.keymap.set("n", "<leader>rhd", function()
						vim.cmd.RustLsp("inlayHints", "disable")
					end, opts)

					vim.keymap.set("n", "<leader>th", function()
						vim.cmd.RustLsp("inlayHints", "toggle")
					end, opts)
				end,

				-- Enhanced rust-analyzer settings
				settings = {
					["rust-analyzer"] = {
						-- Enable all features
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							runBuildScripts = true,
						},

						-- Automatically import dependencies
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},

						-- Enable proc macro support
						procMacro = {
							enable = true,
						},

						-- Enable clippy on save
						checkOnSave = true,
						check = {
							command = "clippy",
							extraArgs = { "--all", "--", "-W", "clippy::all" },
						},

						-- Enable code lens
						lens = {
							enable = true,
							methodReferences = true,
							references = true,
							implementations = true,
						},

						-- Inlay hints
						inlayHints = {
							bindingModeHints = {
								enable = true,
							},
							chainingHints = {
								enable = true,
							},
							closingBraceHints = {
								enable = true,
								minLines = 1,
							},
							closureReturnTypeHints = {
								enable = "always",
							},
							lifetimeElisionHints = {
								enable = "always",
								useParameterNames = true,
							},
							maxLength = 25,
							parameterHints = {
								enable = true,
							},
							reborrowHints = {
								enable = "always",
							},
							renderColons = true,
							typeHints = {
								enable = true,
								hideClosureInitialization = false,
								hideNamedConstructor = false,
							},
						},
					},
				},
			},
		}
	end,
}

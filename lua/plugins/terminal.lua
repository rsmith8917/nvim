-- ============================================================================
-- TERMINAL PLUGINS
-- ============================================================================

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				-- Size of terminal
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				-- Open terminal in insert mode
				open_mapping = [[<c-\>]],
				-- Hide number column in terminal buffers
				hide_numbers = true,
				-- Don't show terminal in bufferline
				shade_terminals = true,
				shading_factor = 2,
				-- Start terminals in insert mode
				start_in_insert = true,
				-- Persist terminal size
				persist_size = true,
				-- Persist terminal mode when switching windows
				persist_mode = true,
				-- Close terminal window when process exits
				close_on_exit = true,
				-- Command to use for shell
				shell = vim.o.shell,
				-- Auto scroll to bottom on terminal output
				auto_scroll = true,
				-- Default direction for new terminals
				direction = "float",
				-- Floating terminal configuration
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
				-- Window highlights
				highlights = {
					Normal = {
						link = "Normal",
					},
					NormalFloat = {
						link = "Normal",
					},
					FloatBorder = {
						link = "FloatBorder",
					},
				},
				-- Terminal-specific keymaps (when in terminal mode)
				on_open = function(term)
					vim.cmd("startinsert!")
					-- Allow easy navigation out of terminal
					vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = term.bufnr, desc = "Exit terminal mode" })
					vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { buffer = term.bufnr, desc = "Move to left window" })
					vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { buffer = term.bufnr, desc = "Move to window below" })
					vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { buffer = term.bufnr, desc = "Move to window above" })
					vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { buffer = term.bufnr, desc = "Move to right window" })
				end,
			})

			-- Create some useful terminal instances
			local Terminal = require("toggleterm.terminal").Terminal

			-- Lazygit terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
				float_opts = {
					border = "curved",
				},
				hidden = true,
				-- Function to run on opening the terminal
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				end,
			})

			-- Make lazygit terminal globally accessible
			_G.lazygit_toggle = function()
				lazygit:toggle()
			end

			-- Python REPL terminal
			local python = Terminal:new({
				cmd = "python3",
				direction = "float",
				hidden = true,
			})

			_G.python_toggle = function()
				python:toggle()
			end

			-- Node REPL terminal
			local node = Terminal:new({
				cmd = "node",
				direction = "float",
				hidden = true,
			})

			_G.node_toggle = function()
				node:toggle()
			end
		end,
	},
}

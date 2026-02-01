-- UI Settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

-- Indentation
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.undofile = true
vim.o.clipboard = "unnamedplus"
vim.g.mapleader = " "

-- Bindings
vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Go to beginning of line" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "Go to end of line" })
vim.keymap.set({ "n", "v" }, "J", "<C-d>", { desc = "Scroll down" })
vim.keymap.set({ "n", "v" }, "K", "<C-u>", { desc = "Scroll up" })

-- Diagnostics
vim.diagnostic.config({
	underline = true,
	virtual_text = true,
	virtual_lines = false,
	signs = true,
	update_in_insert = false,
})
vim.lsp.inlay_hint.enable(true)
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:i",
	callback = function()
		vim.lsp.inlay_hint.enable(false)
	end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "i:*",
	callback = function()
		vim.lsp.inlay_hint.enable(true)
	end,
})

-- plugins
vim.pack.add({
	{ src = "https://github.com/cocopon/iceberg.vim" },
	{ src = "https://github.com/jinh0/eyeliner.nvim" },
	{ src = "https://github.com/echasnovski/mini.files" },
	{ src = "https://github.com/echasnovski/mini.pairs" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-mini/mini.completion" },
	{ src = "https://github.com/nvim-mini/mini.snippets" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }
})

-- colorscheme
vim.cmd("set termguicolors")
vim.cmd("set bg=dark")
vim.cmd("colorscheme iceberg")
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#6c7189", italic = true })

-- eyeliner
require "eyeliner".setup {
	highlight_on_key = true,
	dim = true,
	max_length = 9999,
}

-- mini.files
local mf = require "mini.files";
mf.setup {
	options = {
		permanent_delete = false,
	},
	mappings = {
		close       = 'q',
		go_in       = 'L',
		go_in_plus  = 'l',
		go_out      = 'H',
		go_out_plus = 'h',
	},
}
local mf_toggle = function()
	if not mf.close() then
		mf.open(vim.api.nvim_buf_get_name(0))
	end
end

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesExplorerOpen",
	callback = function()
		mf.reveal_cwd()
	end,
})

vim.keymap.set("n", "<leader>e", mf_toggle);

-- mini.pairs
require "mini.pairs".setup()

-- cmp
require "mini.completion".setup {
	delay = { completion = 5, info = 5, signature = 5 },
	mappings = {
		scroll_down = "<Tab>",
		scroll_up = "<S-Tab>"
	}
}

-- mini.pick
require "mini.pick".setup {
	mappings = {
		move_down      = '<Tab>',
		move_up        = '<S-Tab>',
		toggle_info    = '<C-d>',
		toggle_preview = '<C-u>',
	},
}
vim.keymap.set("n", "<leader>f", "<CMD>Pick files<CR>")
vim.keymap.set("n", "<leader>g", "<CMD>Pick grep<CR>")
vim.keymap.set("n", "<leader>h", "<CMD>Pick help<CR>")

vim.keymap.set('i', '<Tab>', function()
	return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true, noremap = true })

-- lsp
local servers = {
	"lua_ls",
	"rust_analyzer"
}
vim.lsp.enable(servers)
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local buf = vim.lsp.buf

		vim.keymap.set("n", "<leader>k", buf.hover, opts)
		vim.keymap.set("n", "gD", buf.declaration, opts)
		vim.keymap.set("n", "gd", buf.definition, opts)
		vim.keymap.set({ "n", "v" }, "<leader>r", buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>a", buf.code_action, opts)
		vim.keymap.set({ "n", "v" }, "+", function()
			buf.format({ async = true })
		end, opts)
	end,
})



-- Treesitter
require "nvim-treesitter".setup {
	auto_install = false,
	sync_install = false,
	ignore_install = {},
	ensure_installed = {},
	modules = {},
	highlight = {
		enable = true,
	},
}
require "treesitter-context".setup {
	enable = true,
	line_numbers = true,
}

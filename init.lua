vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 3 ways to refer to command-line commands: '<cmd>commandhere', ':commandhere' vim.cmd.commandhere'
vim.keymap.set("n", "<leader>ep", vim.cmd.Explore)

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set({"n", "i"}, "<A-c>", "<cmd>%y<CR>")

-- vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Sigma yank-substitute remap
vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch)
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<S-CR>", "<nop>")

-- See: `:help quickfix`
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>b", "<cmd>!chmod u+x %<CR>")

vim.keymap.set("n", "<F2>", "<cmd>split term://bash<enter>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>") -- <Esc><Esc> won"t work on all terminal emulators
vim.keymap.set("n", "<F7>", "<cmd>!gcc % && ./a.out <CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" }) -- Diagnostic keymap

-- See: `:help wincmd` - list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- Write, quit
vim.keymap.set({"n", "i"},"<A-s>", "<cmd>wall<CR>")
vim.keymap.set({"n", "i"},"<A-q>", "<cmd>qall<CR>")

-- NOTE: ### MEGA KEYBINDING ###

function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end


vim.keymap.set("n", "<leader>z", function()
	if (vim.opt.nrformats:get()[3] == "alpha") then
		vim.opt.nrformats:remove{"alpha"}
		vim.notify(tprint(vim.opt.nrformats:get()))
	else
		vim.opt.nrformats:append{"alpha"}
		vim.notify(tprint(vim.opt.nrformats:get()))
	end
end) -- Increment character alphabetically



vim.schedule(function() -- Schedule the setting after `UiEnter` because it can increase startup-time.
	vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- Cursor line highlight
vim.opt.colorcolumn = '80'

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.autochdir = true
vim.opt.undofile = false

vim.opt.incsearch = true

vim.opt.ignorecase = true
vim.opt.smartcase = true -- Case sensitive when capital letters

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 8
vim.opt.showmode = false -- Since mode is already in the statusline
vim.opt.breakindent = true
vim.opt.undofile = true -- Save undo history

vim.opt.updatetime = 150 -- Decrease update time
vim.opt.timeoutlen = 1000 -- Ex: leader key timeout

vim.opt.signcolumn = 'yes' -- For symbols on the left
vim.opt.mouse = 'a' -- Enable mouse mode

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Sets how neovim will display certain whitespaces.

vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3 -- Tree listing



-- See `:help lua-guide-autocommands`

-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank { timeout = 60 }
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	desc = 'Do :set formatoptions-=cro', -- since runtime files would override it otherwise
	group = vim.api.nvim_create_augroup('robberfox-commentformat', { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove{ 'c', 'r', 'o' }
	end
})

vim.api.nvim_create_autocmd("BufEnter", {
	desc = 'Prevent style overrides from /usr/share/nvim/runtime/...',
	group = vim.api.nvim_create_augroup('robberfox-tab', { clear = true }),
	callback = function()
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		vim.opt.softtabstop = 4
		vim.opt.expandtab = false
	end
})

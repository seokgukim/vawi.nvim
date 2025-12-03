local M = {}
local utils = require("vawi.utils")

function M.setup()
	-- Auto clear Hangul IME on entering Normal mode
	vim.api.nvim_create_autocmd("ModeChanged", {
		pattern = "*:n",
		callback = function()
			pcall(utils.set_ime_off)
		end,
	})
end

return M

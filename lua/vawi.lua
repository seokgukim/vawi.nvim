local M = {}
local utils = require("vawi.utils")

-- Default configuration
local config = {
	auto_trigger = true,
	keep_state = false,
}

-- Store the last IME state (1 for Hangul, 0 for English)
local last_ime_state = 0

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	-- User Commands
	vim.api.nvim_create_user_command("VawiToggle", function()
		utils.toggle_ime()
	end, {})
	vim.api.nvim_create_user_command("VawiHangul", function()
		utils.set_ime_on()
	end, {})
	vim.api.nvim_create_user_command("VawiEnglish", function()
		utils.set_ime_off()
	end, {})

	vim.api.nvim_create_user_command("VawiAutoToggle", function()
		config.auto_trigger = not config.auto_trigger
		print("Vawi auto trigger: " .. tostring(config.auto_trigger))
	end, {})
	vim.api.nvim_create_user_command("VawiAutoEnable", function()
		config.auto_trigger = true
	end, {})
	vim.api.nvim_create_user_command("VawiAutoDisable", function()
		config.auto_trigger = false
	end, {})

	vim.api.nvim_create_user_command("VawiKeepStateToggle", function()
		config.keep_state = not config.keep_state
		print("Vawi keep state: " .. tostring(config.keep_state))
	end, {})
	vim.api.nvim_create_user_command("VawiKeepStateEnable", function()
		config.keep_state = true
	end, {})
	vim.api.nvim_create_user_command("VawiKeepStateDisable", function()
		config.keep_state = false
	end, {})

	-- Trigger on InsertLeave: Turn IME off and optionally remember previous state
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			if not config.auto_trigger then
				return
			end

			utils.set_ime_off(function(output)
				if config.keep_state then
					-- output should be like "10" or "00"
					if output and #output >= 1 then
						local prev = output:sub(1, 1)
						if prev == "1" then
							last_ime_state = 1
						else
							last_ime_state = 0
						end
					end
				end
			end)
		end,
	})

	-- Trigger on InsertEnter: Restore IME state if configured
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			if not config.auto_trigger then
				return
			end

			if config.keep_state and last_ime_state == 1 then
				utils.set_ime_on()
			end
		end,
	})
end

return M

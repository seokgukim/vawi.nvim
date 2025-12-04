local M = {}

function M.get_plugin_root()
	local source = debug.getinfo(1, "S").source:sub(2)
	-- source is .../vawi/lua/vawi/utils.lua
	-- we want .../vawi
	return vim.fn.fnamemodify(source, ":h:h:h")
end

local function get_exe_path()
	local home = vim.fn.expand("~")
	-- detect WSL
	local is_wsl = false
	if vim.env.WSL_DISTRO_NAME and vim.env.WSL_DISTRO_NAME ~= "" then
		is_wsl = true
	else
		local ok, uname = pcall(vim.loop.os_uname)
		if ok and uname and uname.release and uname.release:lower():find("microsoft") then
			is_wsl = true
		end
	end

	-- if running under WSL prefer VAWI_PATH or vawi on PATH and invoke via cmd.exe
	if is_wsl and vim.fn.executable("cmd.exe") == 1 then
		local vawi_path = vim.env.VAWI_PATH
		if vawi_path and vawi_path ~= "" then
			return "cmd.exe", { "/C", vawi_path }
		elseif vim.fn.executable("vawi.exe") == 1 then
			return "cmd.exe", { "/C", "vawi.exe" }
		end
	end

	local exe_candidates = { "vawi.exe" }

	-- Add bundled vawi.exe
	local plugin_root = M.get_plugin_root()
	table.insert(exe_candidates, plugin_root .. "/bin/vawi.exe")
	table.insert(exe_candidates, plugin_root .. "/bin/x64/Release/vawi.exe")

	if home ~= "" then
		table.insert(exe_candidates, home .. "/vawi.exe")
	end

	for _, exe in ipairs(exe_candidates) do
		if vim.fn.executable(exe) == 1 then
			return exe, {}
		end
	end
	return nil, nil
end

function M.run_vawi(action, callback)
	local exe, args = get_exe_path()
	if not exe then
		return false
	end

	local cmd_args = { exe }
	if args then
		for _, v in ipairs(args) do
			table.insert(cmd_args, v)
		end
	end
	table.insert(cmd_args, action)

	if callback then
		local output = ""
		vim.fn.jobstart(cmd_args, {
			on_stdout = function(_, data)
				if data then
					output = output .. table.concat(data, "")
				end
			end,
			on_exit = function()
				callback(output)
			end,
		})
	else
		vim.fn.jobstart(cmd_args, { detach = true })
	end
	return true
end

function M.set_ime_off(callback)
	return M.run_vawi("off", callback)
end

function M.set_ime_on(callback)
	return M.run_vawi("on", callback)
end

function M.toggle_ime(callback)
	return M.run_vawi("toggle", callback)
end

return M

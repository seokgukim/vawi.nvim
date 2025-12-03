local M = {}

function M.get_plugin_root()
	local source = debug.getinfo(1, "S").source:sub(2)
	-- source is .../vawi/lua/vawi/utils.lua
	-- we want .../vawi
	return vim.fn.fnamemodify(source, ":h:h:h")
end

function M.set_ime_off()
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
			pcall(vim.fn.jobstart, { "cmd.exe", "/C", vawi_path, "off" }, { detach = true })
			return true
		elseif vim.fn.executable("vawi.exe") == 1 then
			pcall(vim.fn.jobstart, { "cmd.exe", "/C", "vawi.exe", "off" }, { detach = true })
			return true
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
			vim.fn.jobstart({ exe, "off" }, { detach = true })
			return true
		end
	end
	return false
end

return M

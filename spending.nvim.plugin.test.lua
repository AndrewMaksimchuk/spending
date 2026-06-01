local plugin = assert(dofile("spending.nvim.plugin.lua"))

local function test(describe, it)
	local success, err = pcall(it)

	if not success then
		print("Test failed: " .. tostring(err))
	else
		print("[ SUCCESS ] " .. describe .. "\n")
	end
end

test("format_number_2", function()
	assert(plugin.format_number_2(1) == "01", "Expected correct number format '01'")
	assert(plugin.format_number_2(12) == "12", "Expected correct number format '12'")
end)

-- UUID v7 generator
-- RFC 9562: https://www.rfc-editor.org/rfc/rfc9562.html

local M = {}

-- Generate a UUIDv7 (timestamp-based UUID)
-- Format: xxxxxxxx-xxxx-7xxx-yxxx-xxxxxxxxxxxx
-- Where:
--   x is random
--   7 is the version (0111 in binary)
--   y is the variant (10xx in binary)
function M.generate_v7()
	-- Get current timestamp in milliseconds since Unix epoch
	local timestamp_ms = math.floor(os.time() * 1000 + (vim.loop.hrtime() / 1000000) % 1000)

	-- Helper to generate random hex string of specified length
	local function random_hex(length)
		local hex = ""
		for _ = 1, length do
			hex = hex .. string.format("%x", math.random(0, 15))
		end
		return hex
	end

	-- Convert timestamp to hex (48 bits / 12 hex chars)
	local time_hex = string.format("%012x", timestamp_ms)

	-- Generate random bits
	local rand_a = random_hex(3) -- 12 bits for section 3
	local rand_b = random_hex(16) -- 64 bits for sections 4 and 5 (1 variant source + 3 + 12 hex chars)

	-- Set version to 7 (0111)
	local version = "7"

	-- Set variant to 10xx: take first hex char of rand_b and set top bits to 10
	local variant_char = tonumber(rand_b:sub(1, 1), 16)
	local variant = string.format("%x", bit.bor(bit.band(variant_char, 0x3), 0x8))

	-- Construct UUID: timestamp(8)-timestamp(4)-version(1)rand_a(3)-variant(1)rand_b(3)-rand_b(12)
	local uuid = string.format(
		"%s-%s-%s%s-%s%s-%s",
		time_hex:sub(1, 8), -- 8 chars: timestamp part 1
		time_hex:sub(9, 12), -- 4 chars: timestamp part 2
		version, -- 1 char: version 7
		rand_a, -- 3 chars: random bits
		variant, -- 1 char: variant bits (10xx)
		rand_b:sub(2, 4), -- 3 chars: random bits
		rand_b:sub(5, 16) -- 12 chars: random bits
	)

	return uuid
end

-- Insert a UUIDv7 at the cursor position
function M.insert_uuid()
	local uuid = M.generate_v7()
	local pos = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local row = pos[1] - 1
	local col = pos[2]

	-- Insert UUID at cursor position
	local new_line = line:sub(1, col) .. uuid .. line:sub(col + 1)
	vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })

	-- Move cursor to end of inserted UUID
	vim.api.nvim_win_set_cursor(0, { row + 1, col + #uuid })
end

return M

local ffi = require("ffi")
local ftcsv = require("ftcsv")
local Tensor = require("anolis.tensor").tensor2D

local io = {}

function io.fromCSV(filepath, has_headers)
    local parsed = ftcsv.parse(filepath, {headers = false})
    local start_row = has_headers and 2 or 1
    local n_rows = #parsed - (has_headers and 1 or 0)
    local n_cols = #(parsed[1])

    local out = Tensor(n_rows, n_cols)
    local td = out.data

    local category_map = {}
    local current_category_id = 0 

    local flat_index = 0
    
    for r = start_row, #parsed do
        local row = parsed[r]

        for c = 1, n_cols do
            local rc = row[c]
            local val = tonumber(rc) 

            -- If it's not a number, it's a categorical string
            if val == nil then
                if category_map[rc] == nil then
                    -- Assign a brand new integer ID to this new string
                    current_category_id = current_category_id + 1
                    category_map[rc] = current_category_id
                end
                
                val = category_map[rc]
            end

            td[flat_index] = val
            flat_index = flat_index + 1
        end
    end

    return out
end

function io.toTable(tensor)
    local out = {}

    for c = 0, tensor.cols - 1 do
        out[c + 1] = {}
        for r = 0, tensor.rows - 1 do
            out[c + 1][r + 1] = tensor:get(r, c)
        end
    end

    return out
end

return io
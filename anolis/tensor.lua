local ffi = require("ffi")

ffi.cdef[[
    typedef struct {
        int rows;
        int cols;
        float data[?];
    } tensor2d_t;
]]

local Tensor
local operations = {}

function operations:get(row, col) 
    return self.data[(row * self.cols) + col]
end

function operations:at(index)
    return self.data[index]
end

function operations:set(r, c, val)
    self.data[(r * self.cols) + c] = val
end

function operations:setAt(index, val)
    self.data[index] = val
end

function operations:fill(val)
    for i = 0, (self.rows * self.cols) - 1 do
        self.data[i] = val
    end
end

function operations:copyFromTensor(src_tensor)
    if self.rows ~= src_tensor.rows or self.cols ~= src_tensor.cols then
        error("Tensor dimensions must match to perform a raw memory copy")
    end
    
    local num_elements = self.rows * self.cols
    local bytes = num_elements * ffi.sizeof("float")
    
    ffi.copy(self.data, src_tensor.data, bytes)
end

function operations:clone()
    local out = Tensor(self.rows, self.cols)
    local n = self.rows * self.cols
    local bytes = n * ffi.sizeof("float")
    ffi.copy(out.data, self.data, bytes)
    return out
end

function operations:partition(low, high)
    local pivot = self.data[high]

    local i = low - 1
    for j = low, high, 1 do
        if self.data[j] <= pivot then
            i = i + 1
            local di = self.data[i]
            self.data[i] = self.data[j]
            self.data[j] = di
        end
    end

    local di = self.data[i + 1]
    self.data[i + 1] = self.data[high]
    self.data[high] = di

    return i + 1
end

function operations:qsort(low, high)
    if low < high then
        local pi = self:partition(low, high)
        self:qsort(low, pi - 1)
        self:qsort(pi + 1, high)
    end
end

local tensor2D_c = ffi.metatype("tensor2d_t", {
    __index = operations,
    __tostring = function(self)
        return string.format("Tensor2D: %dx%d", self.rows, self.cols)
    end
})

local function Tensor(rows, cols)
    local instance = tensor2D_c(rows * cols)
    instance.rows = rows
    instance.cols = cols

    return instance
end

return {
    tensor2D = Tensor
}
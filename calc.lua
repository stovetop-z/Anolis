local math = require("math")
local ffi = require("ffi")
local Tensor = require("anolis.tensor")
local calc = {}

function calc.add(t1, t2, length)
    local result = Tensor.tensor2D(t1.rows, t1.cols)
    local d1 = t1.data
    local d2 = t2.data
    local d_res = result.data

    for i = 0, length - 1, 1 do
        d_res[i] = d1[i] + d2[i]
    end

    return result
end

function calc.subtract(t1, t2, length)
    local result = Tensor.tensor2D(t1.rows, t1.cols)
    local d1 = t1.data
    local d2 = t2.data
    local d_res = result.data

    for i = 0, length - 1, 1 do
        d_res[i] = d1[i] - d2[i]
    end

    return result
end

function calc.scalarMultiply(scalar, t)
    local result = Tensor.tensor2D(t.rows, t.cols)
    local d = t.data
    local d_res = result.data

    for i = 0, t.rows * t.cols - 1, 1 do
        d_res[i] = d[i] * scalar
    end

    return result
end

function calc.statistics(t)
    local n = t.rows * t.cols
    local len = n - 1
    local difft = t:clone()
    difft:qsort(0, n - 1)
    local d = difft.data
    local dt = t.data
    local stats = {
        max = dt[0], min = dt[0], 
        sum = 0, mean = 0, median = 0, 
        Q1 = 0, Q3 = 0, IQR = 0, 
        variance = 0, std = 0, 
        argmax = 0, argmin = 0
    }


    for i = 0, len do
        local x = dt[i]

        if x > stats.max then
            stats.max = x
            stats.argmax = i
        end
        if x < stats.min then
            stats.min = x
            stats.argmin = i
        end

        stats.sum = stats.sum + x
    end
    stats.median = d[math.floor(len / 2)]
    stats.Q1 = d[math.floor(len / 4)]
    stats.Q3 = d[len - math.floor(len / 4)]
    stats.IQR = stats.Q3 - stats.Q1
    stats.mean = stats.sum / n

    for i = 0, len do
        stats.variance = stats.variance + (dt[i] - stats.mean)^2
    end
    stats.variance = stats.variance / n
    stats.std = math.sqrt(stats.variance)

    return stats
end

return calc
local ffi = require("ffi")
local Tensor = require("anolis.tensor")
local math = require("math")
local calc = require("anolis.calc")
local preprocessor = {}

preprocessor.__index = preprocessor

function preprocessor:new(t)
    local self = setmetatable({}, preprocessor)
    self.tensor = t:clone()
    self.n = t.rows * t.cols
    self.len = self.n - 1
    self.stats = calc.statistics(t)

    return self
end

function preprocessor:standardScaler()
    local t = self.tensor:clone()
    local d = t.data

    local mean = self.stats.mean
    local std = self.stats.std

    for i = 0, self.len do
        local x = d[i]
        d[i] = (x - mean) / std
    end

    return t
end

function preprocessor:minMaxScaler()
    local t = self.tensor:clone()
    local d = t.data

    local max = self.stats.max
    local min = self.stats.min 

    for i = 0, self.len do
        d[i] = (d[i] - min) / (max - min)
    end

    return t
end

function preprocessor:robustScaler()
    local t = self.tensor:clone()
    local d = t.data

    local mean = self.stats.mean
    local IQR = self.stats.IQR

    for i = 0, self.len do
        d[i] = (d[i] - mean) / IQR
    end

    return t
end

function preprocessor:maxAbsScaler()
    local t = self.tensor:clone()
    local d = t.data

    local max = self.stats.max
    local min = self.stats.min

    for i = 0, self.len do
        d[i] = d[i] / math.max(math.abs(max), math.abs(min))
    end

    return t
end

return preprocessor
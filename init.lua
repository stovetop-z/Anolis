local anolis = {
    _VERSION = "0.0.1",
    config = {
        debug_mode = false,
        use_gpu = false, -- not integrated yet
    }
}

anolis.tensor = require("anolis.tensor").tensor2D
anolis.calc = require("anolis.calc")
anolis.preprocessor = require("anolis.preprocessor")
anolis.io = require("anolis.io")

anolis.setSeed = function(seed)
    math.randomseed(seed)
end

return anolis
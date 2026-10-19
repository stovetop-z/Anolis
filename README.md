# Anolis

Anolis is an early-stage Lua library for working with two-dimensional numeric tensors. It provides basic tensor storage and access, arithmetic and summary statistics, CSV import, and data scaling helpers.

## Requirements

- LuaJIT, for its `ffi` module
- [`ftcsv`](https://github.com/FourierTransformer/ftcsv), for CSV parsing

## Installation

Clone this repository into a directory named `anolis` on your Lua module path. For example, if it is at `~/lua/anolis`, set `LUA_PATH` so LuaJIT can find modules in `~/lua`:

```sh
export LUA_PATH="$HOME/lua/?.lua;$HOME/lua/?/init.lua;;"
```

Install `ftcsv` in a location included in LuaJIT's module search path. Then, from any directory, load the library with:

```lua
local anolis = require("anolis")
```

## Quick start

```lua
local anolis = require("anolis")

local values = anolis.tensor(2, 3)
values:set(0, 0, 1)
values:set(0, 1, 2)
values:set(0, 2, 3)
values:set(1, 0, 4)
values:set(1, 1, 5)
values:set(1, 2, 6)

print(values)                 -- Tensor2D: 2x3
print(values:get(1, 2))       -- 6

local stats = anolis.calc.statistics(values)
print(stats.mean)             -- 3.5
print(stats.min, stats.max)   -- 1  6
```

Tensor rows and columns are zero-indexed. `at` and `setAt` use a zero-indexed flat position.

## Available modules

- `anolis.tensor(rows, cols)` creates a tensor backed by LuaJIT FFI memory. Tensor methods include `get`, `set`, `at`, `setAt`, `fill`, `clone`, `copy_from`, and `qsort`.
- `anolis.calc` provides `add`, `subtract`, `scalarMultiply`, and `statistics`. `add` and `subtract` accept two tensors and an element count: `anolis.calc.add(a, b, a.rows * a.cols)`.
- `anolis.io.fromCSV(path, has_headers)` reads CSV values into a tensor. Non-numeric strings are assigned integer category IDs. `anolis.io.toTable(tensor)` converts tensor data to a Lua table organized by column.
- `anolis.preprocessor` contains standard, min-max, robust, and max-absolute scaling helpers.

## Current status

This project is a work in progress. Scaling operations also do not handle constant-valued input safely. Check the implementation before relying on results for production or statistical work.

-- .nya.d\color.lua

local _M = {}

_M.attr = {
  reset     = 0,
  bold      = 1,
  underline = 4,
  blink     = 5,
  reverse   = 7,
}

_M.fg = {
  black   = 30,
  red     = 31,
  green   = 32,
  yellow  = 33,
  blue    = 34,
  magenta = 35,
  cyan    = 36,
  white   = 37,
}

_M.bg = {
  black   = 40,
  red     = 41,
  green   = 42,
  yellow  = 43,
  blue    = 44,
  magenta = 45,
  cyan    = 46,
  white   = 47,
}

function _M.color(...)
  local esc = '$e[' .. table.concat({...}, ';') .. 'm'
  return function(...)
    return esc .. table.concat({...}, ' ') .. '$e[0m'
  end
end

return _M

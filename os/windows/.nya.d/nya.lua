-- .nya.d\nya.lua

local _M = {}

_M.builtins = {}

if nyagos ~= nil then
  _M.builtins.source = 'source'

  _M.alias   = nyagos.setalias
  _M.command = nyagos.setalias
  _M.eval    = nyagos.eval
  _M.exec    = nyagos.exec
  _M.getenv  = nyagos.getenv
  _M.setenv  = nyagos.setenv
  _M.suffix  = suffix

  function _M.dir(path)
    local rv = {}
    for _, n in ipairs(nyagos.glob(path .. [[\*]])) do
      table.insert(rv, n)
    end
    return rv
  end

  function _M.errorlevel()
    return tonumber(nyagos.getenv('ERRORLEVEL'))
  end

  function _M.is_dir(path)
    local st = nyagos.stat(path)
    return st and st.isdir
  end

  function _M.print(...)
    nyagos.write(...)
    nyagos.write('\n')
  end

  function _M.printf(fmt, ...)
    nyagos.write(fmt:format(...))
  end
else
  _M.builtins.source = 'cmdsource'

  _M.eval   = nyaos.eval
  _M.exec   = nyaos.exec
  _M.getenv = os.getenv
  _M.setenv = nyaos.putenv

  function _M.alias(name, cmd)
    nyaos.alias[name] = cmd
  end

  function _M.command(name, func)
    nyaos.command[name] = function(...)
      local args = {...}
      args[0] = name
      return func(args)
    end
  end

  function _M.dir(path)
    path = path:gsub('\\+$', '')
    local rv = {}
    for n in nyaos.dir(path) do
      if n == '.' or n == '..' then
      else
        table.insert(rv, path .. '\\' .. n)
      end
    end
    return rv
  end

  function _M.errorlevel()
    return tonumber(nyaos.option.errorlevel or 0)
  end

  function _M.is_dir(path)
    local st = nyaos.stat(path)
    return st and st.directory
  end

  function _M.print(...)
    nyaos.write(...)
    nyaos.write('\n')
  end

  function _M.printf(fmt, ...)
    nyaos.write(fmt:format(...))
  end

  function _M.suffix(sfx, cmd)
    nyaos.suffix[sfx] = cmd
  end
end

return _M

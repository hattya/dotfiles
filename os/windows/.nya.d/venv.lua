-- .nya.d\venv.lua

local _M = {}

_M.VEnv = {
  virtualenv = 'py -m virtualenv',
}

function _M.VEnv:workon_home()
  local v = share.nya.getenv('WORKON_HOME')
  if not v or v == '' then
    self:error('%WORKON_HOME% is not set!')
  end
  return v
end

function _M.VEnv:error(...)
  error('venv: ' .. table.concat({...}, ' '))
end

function _M.VEnv:errorf(fmt, ...)
  self:error(fmt:format(...))
end

function _M.VEnv:list()
  local list = {}
  for _, p in ipairs(share.nya.dir(self:workon_home())) do
    if share.nya.is_dir(p) then
      local n, _ = p:gsub('.+\\', '')
      table.insert(list, n)
    end
  end
  return list
end

function _M.VEnv:exists(name)
  for _, n in ipairs(self:list()) do
    if n == name then
      return true
    end
  end
  return false
end


function _M.deactivate(venv)
  local nya = share.nya

  if not nya.getenv('VIRTUAL_ENV') then
    return
  end

  share.environ = share.environ:pop{id = share.venv.id}
  -- suffix
  nya.suffix('.py',   'py')
  nya.suffix('.pyz',  'py')
  nya.suffix('.pyw',  'pyw')
  nya.suffix('.pyzw', 'pyw')
end

function _M.workon(venv, name)
  local nya = share.nya

  if not venv:exists(name) then
    venv:errorf("'%s' does not exist!", name)
  end

  apply = function(stack)
    -- environ
    local virtual_env = venv:workon_home() .. '\\' .. name
    nya.setenv('VIRTUAL_ENV', virtual_env)
    nya.setenv('PYTHONHOME', '')
    local v = stack:getenv('PATH')
    table.insert(v, 1, virtual_env .. '\\Scripts')
    stack:setenv('PATH', v)
    -- suffix
    nya.suffix('py',   'python')
    nya.suffix('pyz',  'python')
    nya.suffix('pyw',  'pythonw')
    nya.suffix('pyzw', 'pythonw')
  end
  share.environ = share.environ:push{id = share.venv.id, name = name, apply = apply}
end


share.venv = {
  id       = 'Python',
  venv     = _M.VEnv,
  commands = {
    workon     = _M.workon,
    deactivate = _M.deactivate,
  },
}

function _M.command(args)
  local nya = share.nya
  local self = share.venv.venv

  if #args < 1 then
    return
  end

  local cmd
  local choice = {}
  for k, v in pairs(share.venv.commands) do
    if k:sub(1, #args[1]) == args[1] then
      choice[k] = v
      table.insert(choice, k)
    end
  end
  if #choice == 0 then
    nya.printf("unknown command '%s'\n", args[1])
    return 1
  elseif #choice == 1 then
    cmd = choice[choice[1]]
  else
    cmd = choice[args[1]]
    if not cmd then
      nya.printf("command '%s' is ambiguous:\n    %s\n", args[1], table.concat(choice, ' '))
      return 1
    end
  end

  table.remove(args, 1)
  local ok, rv = pcall(cmd, share.venv.venv, table.unpack(args))
  if not ok then
    nya.print(rv)
    return 1
  end
  return rv
end

return _M

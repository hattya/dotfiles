-- .nya.d\environ.lua

local _M = {}

_M.stack = {}

function _M:peek()
  if #self.stack == 0 then
    return nil
  end
  return self.stack[1]
end

function _M:push(args)
  local nya = share.nya
  -- restore
  self:pop{id = args.id}
  -- save
  local environ
  if not args.vars or #args.vars == 0 then
    environ = self:environ()
  else
    environ = {}
    for _, k in ipairs(args.vars) do
      environ[k] = nya.getenv(k)
    end
  end
  -- apply
  if args.apply then
    args.apply(self)
  end
  table.insert(self.stack, 1, {
    id      = args.id,
    name    = args.name,
    apply   = args.apply,
    environ = environ,
  })
  return self
end

function _M:pop(args)
  local nya = share.nya

  local keep = {}
  for _, data in ipairs(self.stack) do
    if data.id == args.id then
      break
    elseif data.apply then
      table.insert(keep, data)
    end
  end
  if #keep < #self.stack then
    -- pop
    local data
    for i = 0, #keep do
      data = table.remove(self.stack, 1)
    end
    -- restore
    for k, v in pairs(data.environ) do
      nya.setenv(k, v)
    end
    -- remove remaining vars
    for k, _ in pairs(self:environ()) do
      if not data.environ[k] then
        nya.setenv(k, '')
      end
    end
    -- re-apply
    for i = #keep, 1, -1 do
      keep[i].apply(self)
    end
  end
  return self
end

function _M:environ()
  local nya = share.nya

  local environ = {}
  local out = nya.eval('set') .. '\n'
  for l in out:gmatch('(.-)\n') do
    if l:sub(1, 2) ~= '=' then
      local k, v = l:match('([^=]+)=(.+)')
      if k then
        environ[k] = v
      end
    end
  end
  return environ
end

function _M:getenv(k)
  local nya = share.nya

  local v = {}
  for s in nya.getenv(k):gmatch('[^;]+') do
    table.insert(v, s)
  end
  return v
end

function _M:setenv(k, v)
  local nya = share.nya

  for i, s in ipairs(v) do
    v[i], _ = s:gsub('%%([%w_%(%)]+)%%', nya.getenv)
  end
  nya.setenv(k, table.concat(v, ';'))
end

return _M

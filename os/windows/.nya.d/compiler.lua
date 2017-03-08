-- .nya.d\compiler.lua

local _M = {}

share.compiler = {
  _VCVarsAll = [[%%ProgramFiles(x86)%%\Microsoft Visual Studio %s\VC\vcvarsall.bat]],
  _MinGW     = [[%Cellar%\MinGW\bin]],
  _Clang     = [[%Cellar%\LLVM\bin]],

  id = [[C/C++]],
  vs = {
    ['2010'] = '10.0',
    ['2012'] = '11.0',
    ['2013'] = '12.0',
    ['2015'] = '14.0',
  },
}

function _M.command(args)
  local nya  = share.nya
  local self = share.compiler

  if #args < 1 then
    share.environ = share.environ:pop{id = self.id}
    return
  end

  local name = args[1]:lower()
  local abbr = name
  if name:sub(1, 2) == 'vs' then
    local vs  = name:sub(3)
    local ver = self.vs[vs]
    if not ver then
      return 1
    end
    local arch = 'x64'
    if args[2] then
      arch = args[2]
    end
    name  = ('Visual Studio %s %s'):format(vs, arch)
    abbr  = ('vs%s-%s'):format(vs, arch)
    apply = function(stack)
      nya.exec(('%s "%s" %s >NUL'):format(nya.builtins.source, self._VCVarsAll:format(ver), arch))
    end
  elseif name == 'mingw' then
    name  = 'MinGW'
    abbr  = name
    apply = function(stack)
      local v = stack:getenv('PATH')
      table.insert(v, 1, self._MinGW)
      stack:setenv('PATH', v)
    end
  elseif name == 'clang' then
    name  = 'LLVM/Clang'
    abbr  = name
    apply = function(stack)
      local v = stack:getenv('PATH')
      table.insert(v, 1, self._Clang)
      stack:setenv('PATH', v)
    end
  else
    nya.printf("%s: unknown compiler '%s'\n", args[0], name)
    return 1
  end
  nya.printf('\27[32;1m>>> \27[33;1mActivating %s\27[0m\n', name)
  share.environ = share.environ:push{id = self.id, name = abbr, apply = apply}
end

return _M

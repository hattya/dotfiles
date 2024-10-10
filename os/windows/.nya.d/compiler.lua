-- .nya.d\compiler.lua

local _M = {}

share.compiler = {
  _VC100VarsAll = [[%%ProgramFiles(x86)%%\Microsoft Visual Studio %s\VC\vcvarsall.bat]],
  _VC150VarsAll = [[%s\Microsoft Visual Studio\%s\*\VC\Auxiliary\Build\vcvarsall.bat]],
  _MinGW        = [[%Cellar%\MinGW\bin]],
  _Clang        = [[%Cellar%\LLVM\bin]],

  id = [[C/C++]],
  vs = {
    ['2010'] = '10.0',
    ['2012'] = '11.0',
    ['2013'] = '12.0',
    ['2015'] = '14.0',
    ['2017'] = '15.0',
    ['2019'] = '16.0',
    ['2022'] = '17.0',
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
      local vcvarsall
      if tonumber(vs) < 2017 then
        vcvarsall = self._VC100VarsAll:format(ver)
      else
        local j = self._VC150VarsAll:find('*')
        for _, n in ipairs({
          'ProgramFiles',
          'ProgramFiles(x86)'
        }) do
          for _, p in ipairs(nya.dir(self._VC150VarsAll:sub(1, j-2):format(nya.getenv(n), vs))) do
            if nya.is_dir(p) then
              vcvarsall = p .. self._VC150VarsAll:sub(j+1, -1)
              break
            end
          end
        end
      end
      nya.exec(('%s "%s" %s >NUL'):format(nya.builtins.source, vcvarsall, arch))
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

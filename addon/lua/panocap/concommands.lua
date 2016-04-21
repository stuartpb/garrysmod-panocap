-- Copyright 2016 Stuart P. Bentley.
-- This work may be used freely as long as this notice is included.
-- The work is provided "as is" without warranty, express or implied.

local exports = {}
local convars = include('panocap/convars.lua')
local rendering = include('panocap/rendering.lua')

local function addCommand(name, params, cb)
  return concommand.Add(name, function(ply, cmd, args)
    for i=1, #params do
      local arg = args[i]
      local paramType = string.match(params[i], '^%S+')
      if paramType == 'number' then arg = tonumber(arg) end
    end
    cb(ply, unpack(args))
  end) -- TODO: Add help info, autocomplete
end

local faceNames = {'front', 'right', 'back', 'left', 'top', 'bottom'}
local function filenameFormatter(pattern)
  local time = os.time()
  local replacements = {
    d = os.date('%F', time),
    t = os.date('%T', time),
    m = game.GetMap(),
  }
  return function(face)
    replacements.f = faceNames[face]
    replacements.i = face
    return string.gsub(pattern, '%%(%a)', replacements)
  end
end

function exports.init()
  addCommand('panocap_cubic', {}, function(player)
    local filename = convars.filename()
    local filetype = convars.filetype()
    if not string.find(filename, '%.') then
      filename = filename .. '.' .. filetype
    end

    local filenamer = filenameFormatter(filename)

    local angle = player:EyeAngles()
    local axes = {'pitch', 'yaw', 'roll'}
    for i = 1, #axes do
      local axis = axes[i]
      local snap = convars['snap_'..axis]()
      if snap > 0 then angle:SnapTo(axis, snap) end
    end

    local imagedata = rendering.renderCube{
      format = filetype,
      quality = convars.jpeg_quality(),
      res = convars.width(),
      angle = angle
    }

    -- TODO: Some way of selecting an alternative destination
    for i = 1, #imagedata do
      local f = file.Open(filenamer(i), "wb", "DATA")
      f:Write(imagedata[i])
      f:Close()
    end
  end)
end

return exports

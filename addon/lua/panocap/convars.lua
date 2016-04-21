-- Copyright 2016 Stuart P. Bentley.
-- This work may be used freely as long as this notice is included.
-- The work is provided "as is" without warranty, express or implied.

local module = {}

local convars = {
  filetype = 'png',
  jpeg_quality = 95,
  width = 2048,
  filename = '%m_%d-%t_%f',
  snap_pitch = 360,
  snap_yaw = 90,
  snap_roll = 360,
}

local convarTypeGetters = {
  boolean = 'GetBool'
  number = 'GetFloat'
  string = 'GetString'
}

for convar, defval in pairs(convars) do
  -- TODO: add help text (5th param) after Next Update lands
  local handle = CreateClientConVar('panocap_' .. convar, defval, true, false)
  local getter = convarTypeGetters[type(defval)]
  module[convar] = function ()
    return handle[getter](handle)
  end
end

return module

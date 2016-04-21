-- Copyright 2016 Stuart P. Bentley.
-- This work may be used freely as long as this notice is included.
-- The work is provided "as is" without warranty, express or implied.

local exports = {}
function exports.init()
  include('panocap/concommands.lua').init()
  include('panocap/panel.lua').init()
end
return exports

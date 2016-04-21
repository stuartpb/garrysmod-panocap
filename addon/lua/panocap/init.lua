-- Copyright 2016 Stuart P. Bentley.
-- This work may be used freely as long as this notice is included.
-- The work is provided "as is" without warranty, express or implied.

local module = {}
function module.init()
  require('panocap/concommands').init()
  require('panocap/panel').init()
end
return module

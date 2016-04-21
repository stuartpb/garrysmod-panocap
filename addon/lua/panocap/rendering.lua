-- Copyright 2016 Stuart P. Bentley.
-- This work may be used freely as long as this notice is included.
-- The work is provided "as is" without warranty, express or implied.

local rendering = {}

function rendering.renderCube(opts)
  local front = opts.angle or Angle(0, 0, 0)
  local angles = {
    front,
    Angle(front.p, front.y + 90, front.r),
    Angle(front.p, front.y + 180, front.r),
    Angle(front.p, front.y - 90, front.r),
    Angle(front.p + 90, front.y, front.r),
    Angle(front.p - 90, front.y, front.r),
  }
  local res = opts.res or 2048
  local format = opts.format or 'png'
  if format == 'jpg' then format = 'jpeg' end
  local captureData = {
    format = format,
    quality = opts.quality or (format == 'jpeg' and 95 or nil),
    h = res, w = res, x = 0, y = 0,
  }
  function booldefault(opt, def)
    local val = opts[opt]
    return val == nil and def or val
  end

  local viewData = {
    origin = opts.origin,
    x = 0, y = 0, w = res, h = res, aspectratio = 1,
    dopostprocess = booldefault('postprocess', true),
    drawmonitors = booldefault('drawmonitors', true),
    -- TODO: opt to draw these on the front face?
    drawviewmodel = false, drawhud = false,
  }

  -- I'm assuming this is the best/only way to do variable resolution
  -- TODO: ensure render target res is next highest power of 2
  -- TODO: don't allocate new smaller render targets
  local rtName = 'panocap_cubic_' .. res

  -- TODO: Render 6 views to separate targets, then capture each?
  -- Probably doesn't matter (should all be one frame either way)
  render.PushRenderTarget(GetRenderTarget(rtName, res, res))
  local images = {}
  for i = 1, #angles do
    viewData.angles = angles[i]
    render.RenderView(viewData)
    images[i] = render.Capture(captureData)
  end
  render.PopRenderTarget()
  return images
end

return rendering

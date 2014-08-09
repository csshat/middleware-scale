module.exports = (layer, settings, next) ->
  isNumber = (n) ->
    not isNaN(parseFloat(n)) and isFinite(n)

  scale = settings.scale / 100
  # Prevent dividing by zero or infinity
  scale = 1 if scale is 0 or isNumber(scale) is false

  # Short-circuit middleware when scale is 100% (no-op)
  return next() if scale is 1

  roundingList =
    'Round (1.5 –> 2)': 'round'
    'Floor (1.5 –> 1)': 'floor'
    'Ceil (1.4 –> 2)': 'ceil'
    'No rounding': false
  rounding = roundingList[settings.scaleRoundingMethod]

  processValue = (value) ->
    return value if typeof value isnt 'number'

    if rounding isnt false
       Math[rounding](value * scale)
    else
      Number((value * scale).toFixed(1))

  # Bounds
  for key, value of layer.bounds || {}
    layer.bounds[key] = processValue value

  # Shadows
  for shadow, index in layer.shadows || []
    for key, value of shadow
      layer.shadows[index][key] = processValue value

  # Radius
  for key, value of layer.radius || {}
    layer.radius[key] = processValue value

  # Border
  if layer.border?.width?
    layer.border.width = processValue layer.border.width

  # Font size
  if layer.textStyles?.length
    for textStyle in layer.textStyles when textStyle.font?.size?
      textStyle.font.size = processValue textStyle.font.size

  if layer.baseTextStyle?.font?.size?
    layer.baseTextStyle.font.size = processValue layer.baseTextStyle.font?.size

  next()

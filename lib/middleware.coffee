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

  # Bounds
  for key, value of layer.bounds?
    if rounding isnt false
      layer.bounds[key] = Math[rounding](value * scale)
    else
      layer.bounds[key] = Number((value * scale).toFixed(1))

  # Shadows
  for shadow, index in layer.shadows?
    for key, value of shadow
      if isNumber(value)
        if rounding isnt false
          layer.shadows[index][key] = Math[rounding](value * scale)
        else
          layer.shadows[index][key] = Number((value * scale).toFixed(1))

  # Radius
  for key, value of layer.radius?
    if rounding isnt false
      layer.bounds[key] = Math[rounding](value * scale)
    else
      layer.bounds[key] = Number((value * scale).toFixed(1))

  # Border
  if layer.border?
    value = layer.border.width
    if rounding isnt false
      layer.border.width = Math[rounding](value * scale)
    else
      layer.bounds.width = Number((value * scale).toFixed(1))

  # Font size
  if layer.textStyles? and layer.textStyles.length > 1
    for textStyle, index in layer.textStyles
      if (typeof textStyle.font isnt 'undefined') and (typeof textStyle.font.size isnt 'undefined')
        value = layer.textStyles[index].font.size
        if rounding isnt false
          layer.textStyles[index].font.size = Math[rounding](value * scale)
        else
          layer.textStyles[index].font.size  = Number((value * scale).toFixed(1))
  else if layer.baseTextStyle?
    if typeof layer.baseTextStyle.font.size isnt 'undefined'
      value = layer.baseTextStyle.font.size
      if rounding isnt false
        layer.baseTextStyle.font.size = Math[rounding](value * scale)
      else
        layer.baseTextStyle.font.size = Number((value * scale).toFixed(1))

  next()

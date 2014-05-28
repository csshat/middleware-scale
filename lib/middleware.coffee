module.exports = (layer, settings, next) ->
  layer.backgroundColor = settings.replaceWithThisColor
  next()

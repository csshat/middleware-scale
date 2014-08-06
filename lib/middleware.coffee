color = require 'tinycolor2'

module.exports = (layer, settings, next) ->
  layer.background =
    color: color(settings.replaceWithThisColor).toRgb()

  layer.notifications.push "Background color was replaced with #{settings.replaceWithThisColor}"

  next()

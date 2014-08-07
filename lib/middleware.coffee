color = require 'tinycolor2'

module.exports = (layer, settings, next) ->
  layer.background =
    color: color(settings.replaceWithThisColor).toRgb()

  if settings.beAnnoyingWithNotifications is true
    layer.notifications.push "Background color was replaced with #{settings.replaceWithThisColor}"

  next()

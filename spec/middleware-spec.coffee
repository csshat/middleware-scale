# require main module (defined as `main` in package.json)
middleware = require '..'

# layer object to test on
layer = {}

# simulate next method of middleware chain
next = null

describe 'Background replacer middleware', ->
  beforeEach ->
    layer = { notifications: [] }
    next = jasmine.createSpy()

  it 'should set backgroundColor depending on settings', ->
    middleware(layer, { replaceWithThisColor: 'red' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.background.color).toEqual { r: 255, g: 0, b: 0, a: 1 }

  it 'should add a notification to layer', ->
    middleware(layer, { replaceWithThisColor: 'red', beAnnoyingWithNotifications: true }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.notifications.length).toEqual 1

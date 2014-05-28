# require main module
middleware = require '..'

# layer object to test on
layer = {}

# simulate next method of middleware chain
next = null

describe 'Background replacer middleware', ->
  beforeEach ->
    layer = {}
    next = jasmine.createSpy()

  it 'should set backgroundColor depending on settings', ->
    middleware(layer, { replaceWithThisColor: 'red' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.backgroundColor).toEqual 'red'

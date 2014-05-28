# require main module
middleware = require '..'

# layer object to test on
layer = {}

describe 'Background replacer middleware', ->
  beforeEach ->
    layer = {}

  it 'should set backgroundColor depending on settings', ->
    middleware(layer, { replaceWithThisColor: 'red' })
    expect(layer.backgroundColor).toEqual 'red'

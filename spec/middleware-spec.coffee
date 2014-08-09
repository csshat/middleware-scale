# require main module (defined as `main` in package.json)
middleware = require '..'

# layer object to test on
layer = {}

# simulate next method of middleware chain
next = null

describe 'Scale middleware', ->
  beforeEach ->
    layer = {
      bounds: {
        top: 255
        left: 363
        bottom: 264
        right: 397
        width: 34
        height: 9
        test: 4.4
        another: 3.1
      }
      shadows: [
        {
          x: 0
          y: -1
          blur: 0
          choke: 0
          color: {
            r: 54
            g: 54
            b: 54
            a: 1
          },
          inset: false
        }
        {
          x: 3
          y: -4
          blur: 0
          choke: 0
          color: {
            r: 54
            g: 54
            b: 54
            a: 1
          },
          inset: false
        }
      ]
      baseTextStyle: {
        font: size: 10
      }
      textStyles: [
        {
          font: {
            size: 10
          }
        }
        {
          font: {
            size: 30
          }
        }
      ]
      border:
        width: 4
    }
    next = jasmine.createSpy()

  it 'should scale values up depending on settings', ->
    middleware(layer, { scale: 200, scaleRoundingMethod: 'Round (1.5 –> 2)' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.bounds).toEqual { top: 510, left: 726, bottom: 528, right: 794, width: 68, height: 18, test: 9, another: 6 }

  it 'should scale values down depending on settings', ->
    middleware(layer, { scale: 50, scaleRoundingMethod: 'Round (1.5 –> 2)' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.bounds).toEqual { top: 128, left: 182, bottom: 132, right: 199, width: 17, height: 5, test: 2, another: 2 }

  it 'should round the value down depending on settings', ->
    middleware(layer, { scale: 200, scaleRoundingMethod: 'Floor (1.5 –> 1)' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.bounds.test).toEqual 8

  it 'should round the value up depending on settings', ->
    middleware(layer, { scale: 200, scaleRoundingMethod: 'Ceil (1.4 –> 2)' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.bounds.another).toEqual 7

  it 'should not round the value depending on settings', ->
    middleware(layer, { scale: 50, scaleRoundingMethod: 'No rounding' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.bounds.another).toEqual 1.6

  it 'should set scale to base', ->
    middleware(layer, { scale: 'bullshit', scaleRoundingMethod: 'No rounding' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.bounds.another).toEqual 3.1

  it 'should scale shadow depending on settings', ->
    middleware(layer, { scale: '200', scaleRoundingMethod: 'Round (1.5 –> 2)' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.shadows[0]).toEqual {
        x: 0
        y: -2
        blur: 0
        choke: 0
        color: {
          r: 54
          g: 54
          b: 54
          a: 1
        },
        inset: false
      }
      expect(layer.shadows[1]).toEqual {
        x: 6
        y: -8
        blur: 0
        choke: 0
        color: {
          r: 54
          g: 54
          b: 54
          a: 1
        },
        inset: false
      }

  it 'should set scale to font size', ->
    middleware(layer, { scale: '200', scaleRoundingMethod: 'Round (1.5 –> 2)' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.textStyles[0].font).toEqual { size: 20 }

  it 'should set scale to border', ->
    middleware(layer, { scale: '200', scaleRoundingMethod: 'Round (1.5 –> 2)' }, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.border.width).toEqual 8

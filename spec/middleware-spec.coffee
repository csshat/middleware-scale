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
      paths: [
        [
          {
            rect: [13, 10, 69, 63]
          }
        ],
        [
          {
            ellipse: [60, 7, 25, 23]
          }
        ],
        [
          {
            move: [62, 40]
          },
          {
            bezier: [57.714844, 25.019531, 45, 26, 45, 26]
          },
          {
            bezier: [45, 26, 33.003906, 14.550781, 25, 16]
          },
          {
            bezier: [16.996094, 17.449219, 24.660156, 32.140625, 28, 52]
          },
          {
            bezier: [31.339844, 71.859375, 38.851562, 68.824219, 53, 67]
          },
          {
            bezier: [67.148438, 65.175781, 66.285156, 54.980469, 62, 40]
          }
        ],
        [
          {
            move: [46, 15]
          },
          {
            line: [9, 10]
          },
          {
            line: [46, 15]
          }
        ]
      ]
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

  it 'should scale path coordinates depending on settings', ->
    middleware(layer, { scale: 50, scaleRoundingMethod: 'No rounding'}, next)

    waitsFor ->
      next.callCount > 0

    runs ->
      expect(layer.paths[0]).toEqual [
        rect: [6.5, 5, 34.5, 31.5]
      ]

      expect(layer.paths[1]).toEqual [
        ellipse: [30, 3.5, 12.5, 11.5]
      ]

      expect(layer.paths[2]).toEqual [
        {
          move: [31, 20]
        },
        {
          bezier: [28.9, 12.5, 22.5, 13, 22.5, 13]
        },
        {
          bezier: [22.5, 13, 16.5, 7.3, 12.5, 8]
        },
        {
          bezier: [8.5, 8.7, 12.3, 16.1, 14, 26]
        },
        {
          bezier: [15.7, 35.9, 19.4, 34.4, 26.5, 33.5]
        },
        {
          bezier: [33.6, 32.6, 33.1, 27.5, 31, 20]
        }
      ]

      expect(layer.paths[3]).toEqual [
        {
          move: [23, 7.5]
        },
        {
          line: [4.5, 5]
        },
        {
          line: [23, 7.5]
        }
      ]

assert = require "assert"
GuideNotation = require "
  #{ process.cwd() }/src/documents/guideguide/js/lib/GuideNotation.js.coffee
"
GN = GuideNotation.notation
Unit = GuideNotation.unit


describe 'GuideNotation', ->
  describe 'Parse Commands', ->
    it 'should return an empty array when no commands are given', ->
      assert.strictEqual GN.parseCommandList().length, 0
      assert.strictEqual GN.parseCommandList("").length, 0

    it 'should parse guide commands', ->
      assert GN.parseCommandList("|")[0].isGuide

describe 'Gaps', ->

describe 'Units', ->

  describe 'Object from string', ->

    it 'should return null if given nothing', ->
      assert.strictEqual Unit.from(""), null
      assert.strictEqual Unit.from(), null

    it 'should return null when a bad value is given', ->
      assert.strictEqual Unit.from("foo"), null
      assert.strictEqual Unit.from("1foo"), null

    it 'should return null base if nothing is given', ->
      assert.strictEqual Unit.from("1foo"), null

    it 'should return a unit object when a unit pair is given', ->
      assert.deepEqual Unit.from("1px"), {"string":"1px","value":1,"type":"px"}

    it 'should should allow spaces', ->
      assert.deepEqual Unit.from("1 px"), {"string":"1px","value":1,"type":"px"}

  describe 'Base value from unit object', ->

    it 'should return null when a bad value is given', ->
      assert.deepEqual Unit.asBaseUnit("foo"), null

    it 'should return an integer when one is given', ->
      assert.deepEqual Unit.asBaseUnit(), null
      assert.deepEqual Unit.asBaseUnit({}), null
      assert.deepEqual Unit.asBaseUnit(""), null

    it 'should return an integer when given a unit object', ->
      assert.deepEqual Unit.asBaseUnit(Unit.from("1cm")), 28.346456692913385
      assert.deepEqual Unit.asBaseUnit(Unit.from("1in")), 72
      assert.deepEqual Unit.asBaseUnit(Unit.from("1mm")), 2.8346456692913384
      assert.deepEqual Unit.asBaseUnit(Unit.from("1px")), 1
      assert.deepEqual Unit.asBaseUnit(Unit.from("1pt")), 1
      assert.deepEqual Unit.asBaseUnit(Unit.from("1pica")), 12

    it 'should adjust for resolution when resolution is given', ->
      assert.deepEqual Unit.asBaseUnit(Unit.from("1in"), 300), 300

  describe 'Preferred name', ->

    it 'should not get the preferred name if nothing is given', ->
      assert.equal Unit.preferredName(), null
      assert.equal Unit.preferredName(""), null

    it 'should get preferred name for unit strings', ->

      assert.equal Unit.preferredName(), null
      assert.equal Unit.preferredName(""), null

      cm = ['centimeter', 'centimeters', 'centimetre', 'centimetres', 'cm']
      for str in cm
        assert.equal Unit.preferredName(str), "cm"

      for str in ['inch', 'inches', 'in']
        assert.equal Unit.preferredName(str), "in"

      mm = ['millimeter', 'millimeters', 'millimetre', 'millimetres', 'mm']
      for str in mm
        assert.equal Unit.preferredName(str), "mm"

      for str in ['pixel', 'pixels', 'px']
        assert.equal Unit.preferredName(str), "px"

      for str in ['point', 'points', 'pts', 'pt']
        assert.equal Unit.preferredName(str), "points"

      for str in ['pica', 'picas']
        assert.equal Unit.preferredName(str), "picas"

      for str in ['percent', 'pct', '%']
        assert.equal Unit.preferredName(str), "%"

  describe 'To string', ->
    it 'should return null when given nothing', ->
      assert.strictEqual Unit.toString(), null
      assert.strictEqual Unit.toString(""), null

    it 'should return string when given a unit object', ->
      assert.equal Unit.toString(Unit.from("1px")), "1px"

    it 'should return string when given a string', ->
      assert.equal Unit.toString("1px"), "1px"

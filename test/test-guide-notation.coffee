assert = require "assert"
GuideNotation = require "
  #{ process.cwd() }/src/documents/guideguide/js/lib/GuideNotation.js.coffee
"
GN = GuideNotation.notation
Unit = GuideNotation.unit
Gap = GuideNotation.gap


describe 'GuideNotation', ->

  describe 'Parse Commands', ->

    it 'should return an empty array when no commands are given', ->
      assert.strictEqual GN.parseCommandList().length, 0
      assert.strictEqual GN.parseCommandList("").length, 0

    it 'should parse guide commands', ->
      assert GN.parseCommandList("|")[0].isGuide

describe 'Gaps', ->

  describe 'Evalutations', ->

    it 'should succeed for variables', ->
      assert.strictEqual Gap.isVariable("$"), true
      assert.strictEqual Gap.isVariable("$ = | 10px |"), true
      assert.strictEqual Gap.isVariable("$foo = | 10px |"), true

    it 'should fail for non-variables', ->
      assert.strictEqual Gap.isVariable(""), false
      assert.strictEqual Gap.isVariable("foo"), false
      assert.strictEqual Gap.isVariable("1"), false
      assert.strictEqual Gap.isVariable("1px"), false

    it 'should succeed for arbitrary gaps', ->
      assert.strictEqual Gap.isArbitrary("1cm"), true
      assert.strictEqual Gap.isArbitrary("1in"), true
      assert.strictEqual Gap.isArbitrary("1mm"), true
      assert.strictEqual Gap.isArbitrary("1px"), true
      assert.strictEqual Gap.isArbitrary("1pt"), true
      assert.strictEqual Gap.isArbitrary("1pica"), true
      assert.strictEqual Gap.isArbitrary("1%"), true

    it 'should fail for non-arbitrary gaps', ->
      assert.strictEqual Gap.isArbitrary(""), false
      assert.strictEqual Gap.isArbitrary("1"), false
      assert.strictEqual Gap.isArbitrary("foo"), false
      assert.strictEqual Gap.isArbitrary("$"), false
      assert.strictEqual Gap.isArbitrary("$A = | 10px |"), false

    it 'should succeed for wildcards', ->
      assert.strictEqual Gap.isWildcard("~"), true

    it 'should fail for non-wildcards', ->
      assert.strictEqual Gap.isWildcard("~10px"), false
      assert.strictEqual Gap.isWildcard(""), false
      assert.strictEqual Gap.isWildcard("1px"), false
      assert.strictEqual Gap.isWildcard("foo"), false
      assert.strictEqual Gap.isWildcard("$A"), false

    it 'should succeed for percents', ->
      assert.strictEqual Gap.isPercent("10%"), true

    it 'should fail for non-percents', ->
      assert.strictEqual Gap.isPercent("%"), false
      assert.strictEqual Gap.isPercent("~10px"), false
      assert.strictEqual Gap.isPercent(""), false
      assert.strictEqual Gap.isPercent("1px"), false
      assert.strictEqual Gap.isPercent("foo"), false
      assert.strictEqual Gap.isPercent("$"), false

    it 'should succeed for fills', ->
      assert.strictEqual Gap.isFill("~*"), true
      assert.strictEqual Gap.isFill("$*"), true
      assert.strictEqual Gap.isFill("1px*"), true

    it 'should fail for non-fills', ->
      assert.strictEqual Gap.isFill("foo"), false
      assert.strictEqual Gap.isFill("10px*2"), false

  describe 'Function', ->

    it 'should reject parsing bad values', ->
      assert.strictEqual Gap.parse(""), null
      assert.strictEqual Gap.parse("foo"), null
      assert.strictEqual Gap.parse("1foo"), null

    it 'should succeed parsing good values', ->
      assert.strictEqual Gap.parse("1px"), "1px"
      assert.strictEqual Gap.parse("$"), "$"

    it 'should parse wildcards', ->
      assert.deepEqual Gap.parse("~").isWildcard, true
      assert.deepEqual Gap.parse("~*").isWildcard, true
      assert.deepEqual Gap.parse("~*2").isWildcard, true

  describe 'utility', ->

    it 'should count wildcard multiples', ->
      assert.equal Gap.getWildcardMultiples("~"), 1
      assert.equal Gap.getWildcardMultiples("~*"), 1
      assert.equal Gap.getWildcardMultiples("~*2"), 2


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

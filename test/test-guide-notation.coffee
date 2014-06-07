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

  it 'can get the preferred name for unit strings', ->

    for str in ['centimeter', 'centimeters', 'centimetre', 'centimetres', 'cm']
      assert.equal Unit.preferredName(str), "cm"

    for str in ['inch', 'inches', 'in']
      assert.equal Unit.preferredName(str), "in"

    for str in ['millimeter', 'millimeters', 'millimetre', 'millimetres', 'mm']
      assert.equal Unit.preferredName(str), "mm"

    for str in ['pixel', 'pixels', 'px']
      assert.equal Unit.preferredName(str), "px"

    for str in ['point', 'points', 'pts', 'pt']
      assert.equal Unit.preferredName(str), "points"

    for str in ['pica', 'picas']
      assert.equal Unit.preferredName(str), "picas"

    for str in ['percent', 'pct', '%']
      assert.equal Unit.preferredName(str), "%"

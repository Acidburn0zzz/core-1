assert = require "assert"
GN = require "
  #{ process.cwd() }/src/documents/guideguide/js/lib/GuideNotation.js.coffee
"

describe 'Parse Commands', ->
  it 'should return an empty array when no commands are given', ->
    assert.strictEqual GN.parseCommandList().length, 0
    assert.strictEqual GN.parseCommandList("").length, 0

  it 'should parse guide commands', ->
    assert.equal GN.parseCommandList("|")[0], "|"

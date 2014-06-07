class GuideNotation

  constructor: (args = {}) ->

  # Convert a string of gap and guide commands into an object.
  #
  # Returns a command object
  parseCommandList: (string) ->
    commands = []
    return commands if !string or string == ""
    bits = string.replace(/^\s+|\s+$/g, '').replace(/\s\s+/g, ' ').split(/\s/)

    for command, index in bits
      commands.push if command == "|" then isGuide:true else command

    commands

if (typeof module != 'undefined' && typeof module.exports != 'undefined')
  module.exports = new GuideNotation()
else
  window.GuideNotation = new GuideNotation()

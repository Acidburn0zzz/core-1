class GuideNotation

  constructor: (args = {}) ->

  # Convert a string of gap and guide commands into an object.
  #
  # Returns a command object
  parseCommandList: (string) =>
    commands = []
    return commands if !string or string == ""
    ["|"]


if (typeof module != 'undefined' && typeof module.exports != 'undefined')
  module.exports = new GuideNotation()
else
  window.GuideNotation = new GuideNotation()

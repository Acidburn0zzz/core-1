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

#
# Unit is a utility for parsing and validating unit strings
#
class Unit

  constructor: (args = {}) ->

  from: (string = "") =>
    string = string.replace /\s/g, ''
    bits = string.match(/([-0-9\.]+)([a-z%]+)?/i)
    return null if !string or string == "" or !bits?
    return null if bits[2] and !@preferredName(bits[2])

    # Integer
    if bits[1] and !bits[2]
      value = parseFloat bits[1]
      return if value.toString() == bits[1] then value else null

    # Unit pair
    string: string
    value: parseFloat bits[1]
    type: @preferredName bits[2]

  # Parse a string and change it to a friendly unit
  #
  #   string - string to be parsed
  #
  # Returns a string or null, if invalid
  preferredName: (string) ->
    switch string
      when 'centimeter', 'centimeters', 'centimetre', 'centimetres', 'cm'
        'cm'
      when 'inch', 'inches', 'in'
        'in'
      when 'millimeter', 'millimeters', 'millimetre', 'millimetres', 'mm'
        'mm'
      when 'pixel', 'pixels', 'px'
        'px'
      when 'point', 'points', 'pts', 'pt'
        'points'
      when 'pica', 'picas'
        'picas'
      when 'percent', 'pct', '%'
        '%'
      else
        null

  # Convert the given value of type to the base unit of the application.
  # This accounts for reslution, but the resolution must be set if it changes.
  # The result is either pixels or points.
  #
  #   unit       - unit object
  #   resolution - dots per inch
  #
  # Returns a number
  asBaseUnit: (unit, resolution = 72) ->
    return null unless unit? and unit.value? and unit.type?

    # convert to inches
    switch unit.type
      when 'cm'     then unit.value = unit.value / 2.54
      when 'in'     then unit.value = unit.value / 1
      when 'mm'     then unit.value = unit.value / 25.4
      when 'px'     then unit.value = unit.value / resolution
      when 'points' then unit.value = unit.value / resolution
      when 'picas'  then unit.value = unit.value / 6
      else
        return null

    # convert to base units
    unit.value * resolution


if (typeof module != 'undefined' && typeof module.exports != 'undefined')
  module.exports =
    notation: new GuideNotation()
    unit: new Unit()
else
  window.GuideNotation = new GuideNotation()
  window.Unit = new Unit()

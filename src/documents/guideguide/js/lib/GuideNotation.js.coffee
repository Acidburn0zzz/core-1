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
# A gap command tells the guide parser to move ahead by the specified distance.
#
class Gap
  variableRegexp: /^\$([^\*]+)?(\*(\d+)?)?$/i
  arbitraryRegexp: /^(([-0-9\.]+)?[a-z%]+)(\*(\d+)?)?$/i
  wildcardRegexp: /^~(\*(\d*))?$/i

  constructor: (args = {}) ->

  isVariable: (string = "") =>
    @variableRegexp.test string.replace /\s/g, ''

  isArbitrary: (string = "") =>
    return false if !@arbitraryRegexp.test string.replace /\s/g, ''
    return false if new Unit().from(string) == null
    true

  isWildcard: (string = "") =>
    @wildcardRegexp.test string.replace /\s/g, ''

  isPercent: (string = "") ->
    unit = (new Unit).from(string.replace /\s/g, '')
    unit? and unit.type == '%'

  isFill: (string = "") ->
    if @isVariable string
      bits = @variableRegexp.exec string
      return bits[2] && !bits[3]
    else if @isArbitrary string
      bits = @arbitraryRegexp.exec string
      return bits[3] && !bits[4]
    else if @isWildcard string
      bits = @wildcardRegexp.exec string
      return bits[1] && !bits[2] || false
    else
      false

  parse: (string = "") ->
    string = string.replace /\s/g, ''
    if @isVariable string
      string
    else if @isArbitrary string
      string
    else if @isWildcard string
      string
    else
      null

#
# Unit is a utility for parsing and validating unit strings
#
class Unit

  constructor: (args = {}) ->

  # Parse a string and change it to a unit object
  #
  #   string - unit string to be parsed
  #
  # Returns an object or null if invalid
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
  # This accounts for reslution, but the resolution must be manually changed.
  # The result is pixels/points.
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

  # Convert a unit object to a string or format a unit string to conform to the
  # unit string standard
  #
  #   unit = string or object
  #
  # Returns a string
  toString: (unit = "") =>
    return null if unit == ""
    return @toString(@from(unit)) if typeof unit == "string"

    "#{ unit.value }#{ unit.type }"

if (typeof module != 'undefined' && typeof module.exports != 'undefined')
  module.exports =
    notation: new GuideNotation()
    unit: new Unit()
    gap: new Gap()
else
  window.GuideNotation = new GuideNotation()
  window.Unit = new Unit()
  window.Gap = new Gap()

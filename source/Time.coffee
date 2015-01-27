scheduler = (window.scheduler ?= {})

class scheduler.Time
  @pad: (value) -> if value < 10 then '0' + value else value

  constructor: (@hour, @minute) ->

  compare: (time) ->
    if @hour != time.hour
      if @hour < time.hour
        return -1
      else
        return 1
    if @minute < time.minute
      return -1
    if @minute > time.minute
      return 1
    return 0

  lt: (time) ->
    return @compare(time) < 0

  lte: (time) ->
    return @compare(time) <= 0

  eq: (time) ->
    return @compare(time) == 0

  neq: (time) ->
    return @compare(time) != 0

  gt: (time) ->
    return @compare(time) > 0

  gte: (time) ->
    return @compare(time) >= 0

  toString: ->
    return "#{scheduler.Time.pad @hour}:#{scheduler.Time.pad @minute}"

class scheduler.Interval
  constructor: (@start, @end) ->
    if @start.gt @end
      throw "Invalid interval, start comes after end: #{@start.toString()} - #{@end.toString()}"

  length: ->
    startMinute = @start.hour * 60 + @start.minute
    endMinute = @end.hour * 60 + @end.minute
    new endMinute - startMinute

  # This interval hard overlaps another interval if they soft overlap or if their
  # endpoints are equal. For example, 3-4PM hard overlaps 4-5PM.
  hardOverlaps: (interval) ->
    if @start.lt interval.start
      return @end.lte interval.start
    return @start.gte interval.end

  # This interval soft overlaps another interval if they don't overlap except for
  # sharing a common end point. For example, 3-4PM doesn't soft overlap 4-5PM
  # but 3-4PM soft overlaps 3:30-5PM.
  softOverlaps: (interval) ->
    if @start.lt interval.start
      return @end.lt interval.start
    return @start.gt interval.end

  toString: ->
    return "#{@start.toString()} - #{@end.toString()}"


scheduler = (window.scheduler ?= {})

parseNumber = (value) -> if value? then +value else 0

parseTimeInterval = (time) ->
  timeRegex = /^(\d{1,2})(\d{2})?-(\d{1,2})(\d{2})?((AM)|(PM))$/g
  matches = timeRegex.exec time
  if matches == null
    throw "Invalid time format: #{time}."
  startHour    = (parseNumber matches[1]) % 12
  startMinute  = parseNumber matches[2]
  endHour      = (parseNumber matches[3]) % 12
  endMinute    = parseNumber matches[4]
  endIsMorning = matches[6]?
  startIsMorning = ((startHour > endHour) != endIsMorning)
  startHour += 12 if not startIsMorning
  endHour += 12 if not endIsMorning
  startTime = new scheduler.Time startHour, startMinute
  endTime = new scheduler.Time endHour, endMinute
  return new scheduler.Interval startTime, endTime

DAY_ABBREVS = [
  'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'
]

class scheduler.Section extends Backbone.Model
  defaults:
    course     : undefined
    number     : undefined
    type       : undefined
    location   : undefined
    instructor : undefined
    meetings   : undefined
    time       : undefined

  @FromRow: (course, row) ->
    number = row.Section
    type = row.Component
    location = row.Location
    instructor = row.instructor
    meetings = ['M', 'T', 'W', 'TH', 'F', 'S', 'SU'].map (day) -> !!row[day]
    time = parseTimeInterval row.Time
    return new scheduler.Section {
      number, type, location, instructor, meetings, time
    }

  getMeetingDaysString: ->
    _(DAY_ABBREVS).zip @get 'meetings'
      .filter ([abbrev, meeting]) -> meeting
      .map ([abbrev, meeting]) -> abbrev
      .value()
      .join ''

  getMeetingTimesString: ->
    @getMeetingDaysString() + ' ' + @get('time').toString()

  toString: ->
    @get('type') + ' ' + @get('number')

  hardOverlaps: (section) ->
    @get('time').hardOverlaps section.get('time')

  softOverlaps: (section) ->
    @get('time').softOverlaps section.get('time')

class scheduler.SectionCollection extends Backbone.Collection
  model: scheduler.Section
  comparator: (section) -> section.get 'number'

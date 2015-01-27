schedules = (window.schedules ?= {})

$ ->
  semester = scheduler.Semester.FromCSV 'Winter 2015', schedules.WN2015
  eecs482 = semester.lookUpCourse 'EECS 482'
  console.log eecs482.toString()
  sections = eecs482.get 'sections'
  sections.each (section) ->
    console.log '  ' + section.toString() + ' - ' + section.getMeetingTimesString()
  console.log 'Soft overlapping sections:'
  sections.each (section) ->
    console.log '  ' + section.toString() + ' - ' + section.getMeetingTimesString()
    sections.each (other) ->
      if section != other and section.softOverlaps other
        console.log '   ' + other.toString() + ' - ' + other.getMeetingTimesString()
  console.log 'Edge overlapping sections:'
  sections.each (section) ->
    console.log '  ' + section.toString() + ' - ' + section.getMeetingTimesString()
    sections.each (other) ->
      if section != other and section.hardOverlaps(other) and not section.softOverlaps(other)
        console.log '   ' + other.toString() + ' - ' + other.getMeetingTimesString()


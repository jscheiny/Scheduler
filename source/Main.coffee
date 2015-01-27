schedules = (window.schedules ?= {})

$ ->
  semester = scheduler.SemesterModel.FromCSV 'Winter 2015', schedules.WN2015
  eecs482 = semester.lookUpCourse 'EECS 482'
  console.log eecs482.toString()
  eecs482.get('sections').each (section) ->
    console.log '  ' + section.toString() + ' - ' + section.getMeetingTimesString()

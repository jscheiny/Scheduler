schedules = (window.schedules ?= {})

$ ->
  parsed = Papa.parse window.schedules.WN2015, {header: true}
  semester = new scheduler.SemesterModel {name: 'Winter 2015', parsed}
  eecs482 = semester.lookUpCourse 'EECS 482'
  console.log eecs482.toString()
  eecs482.get('sections').each (section) ->
    console.log section.get('type') + ' ' + section.get('number') + ' - ' +
                section.getMeetingTimesString()

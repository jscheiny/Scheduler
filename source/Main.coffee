schedules = (window.schedules ?= {})

$ ->
  parsed = Papa.parse window.schedules.WN2015, {header: true}
  semester = new scheduler.SemesterModel {name: 'Winter 2015', parsed}
  semesterView = new scheduler.SemesterView model: semester
  semesterView.render()

scheduler = (window.scheduler ?= {})

class scheduler.SectionModel extends Backbone.Model
  defaults: ->
    course     : undefined
    number     : undefined
    type       : undefined
    location   : undefined
    instructor : undefined
    meetings   : undefined
    time       : undefined

  @Create: (course, row) ->
    number = row.Section
    type = row.Component
    location = row.Location
    instructor = row.instructor
    meetings = ['M', 'T', 'W', 'TH', 'F', 'S', 'SU'].map (day) -> !!row[day]
    time = row.Time
    return new scheduler.SectionModel {
      number, type, location, instructor, meetings, time
    }

class scheduler.SectionCollection extends Backbone.Collection
  model: scheduler.SectionModel
  comparator: (section) -> section.get 'number'

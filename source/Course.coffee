scheduler = (window.scheduler ?= {})

class scheduler.Course extends Backbone.Model
  defaults: ->
    department : undefined
    number     : undefined
    title      : undefined
    credits    : NaN
    sections   : new scheduler.SectionCollection()
    sectionsByNumber : {}

  addSection: (section) ->
    @get('sections').add section
    @get('sectionsByNumber')[section.get('number')] = section

  toString: ->
    return @get('department').get('shortName') + ' ' + @get('number') + ' - ' +
           @get('title')

class scheduler.CourseCollection extends Backbone.Collection
  model: scheduler.Course
  comparator: (course) -> course.get 'number'

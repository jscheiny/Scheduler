scheduler = (window.scheduler ?= {})

class scheduler.CourseModel extends Backbone.Model
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
  model: scheduler.CourseModel
  comparator: (course) -> course.get 'number'

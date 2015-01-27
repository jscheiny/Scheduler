scheduler = (window.scheduler ?= {})

class scheduler.Department extends Backbone.Model
  defaults: ->
    shortName       : undefined
    fullName        : undefined
    academicGroup   : undefined
    courses         : new scheduler.CourseCollection()
    coursesByNumber : {}

  addCourse: (course) ->
    @get('courses').add course
    @get('coursesByNumber')[course.get('number')] = course

  hasCourse: (courseNumber) ->
    return @get('coursesByNumber')[courseNumber] != undefined

  getCourse: (courseNumber) ->
    return @get('coursesByNumber')[courseNumber]

  toString: -> @get 'shortName'

class scheduler.DepartmentCollection extends Backbone.Collection
  model: scheduler.Department
  comparator: (dept) -> dept.get 'shortName'

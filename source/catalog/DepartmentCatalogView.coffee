scheduler = (window.scheduler ?= {})
catalog = (scheduler.catalog ?= {})

class catalog.DepartmentView extends Backbone.Marionette.LayoutView
  template  : scheduler.templates['catalog.DepartmentView']
  tagName   : 'li'
  className : 'department'

  regions:
    courses: '.course-list'

  onRender: ->
    @courses.show new CourseListView
      collection: @model.get('courses')

class CourseListView extends Backbone.Marionette.CollectionView
  childView : catalog.CourseView

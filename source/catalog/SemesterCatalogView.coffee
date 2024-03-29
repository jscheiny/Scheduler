scheduler = (window.scheduler ?= {})
catalog = (scheduler.catalog ?= {})

class catalog.SemesterView extends Backbone.Marionette.LayoutView
  el        : 'body'
  template  : scheduler.templates['catalog.SemesterView']
  className : 'semester'

  regions:
    departments: '.department-list'

  onRender: ->
    @departments.show new DepartmentListView
      collection: @model.get('departments')

class DepartmentListView extends Backbone.Marionette.CollectionView
  childView : catalog.DepartmentView

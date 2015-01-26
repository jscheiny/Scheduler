scheduler = (window.scheduler ?= {})
catalog = (scheduler.catalog ?= {})

class catalog.CourseView extends Backbone.Marionette.ItemView
  template  : scheduler.templates['catalog.CourseView']
  tagName   : 'li'
  className : 'course'

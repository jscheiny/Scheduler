scheduler = (window.scheduler ?= {})
catalog = (scheduler.catalog ?= {})

class catalog.CourseView extends Backbone.Marionette.ItemView
  template  : Handlebars.templates['CourseView']
  tagName   : 'li'
  className : 'course'

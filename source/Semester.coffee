scheduler = (window.scheduler ?= {})

class scheduler.SemesterModel extends Backbone.Model
  defaults: ->
    name        : undefined
    departments : new scheduler.DepartmentCollection()
    deptByShort : {}

  initialize: (options) ->
    {parsed} = options
    errorIndices = _.pluck(parsed.errors, 'row')
    for row, index in parsed.data
      if index not in errorIndices
        @_parseRow row

  _parseRow: (row) ->
    department = @_parseDepartment row
    number = row['Catalog Nbr'].trim()
    title = row['Course Title'].trim()
    credits = +row['Units']
    if department.hasCourse number
      course = department.getCourse number
    else
      course = new scheduler.CourseModel {department, number, title, credits}
    department.addCourse course
    course.addSection scheduler.SectionModel.Create(course, row)

  _parseDepartment: (row) ->
    combinedName = row.Subject.trim()
    open = combinedName.indexOf '('
    close = combinedName.indexOf ')'
    fullName = combinedName.substring(0, open).trim()
    shortName = combinedName.substring open + 1, close
    academicGroup = row['Acad Group'].trim()
    findDept = @get('deptByShort')[shortName]
    if findDept?
      return findDept
    else
      dept = new scheduler.DepartmentModel {shortName, fullName, academicGroup}
      @_addDepartment dept
      return dept

  _addDepartment: (dept) ->
    @get('departments').add(dept)
    @get('deptByShort')[dept.get('shortName')] = dept

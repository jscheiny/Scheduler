scheduler = (window.scheduler ?= {})

class scheduler.Semester extends Backbone.Model
  defaults: ->
    name        : undefined
    departments : new scheduler.DepartmentCollection()
    deptByShort : {}

  @FromCSV: (name, csv) ->
    start = new Date()
    parsed = Papa.parse csv, {header: true}
    semester = new scheduler.Semester {name, parsed}
    end = new Date()
    elapsed = (end.getTime() - start.getTime()) / 1000
    console.debug "Time to model semester: #{elapsed}s"
    return semester

  initialize: (options) ->
    {parsed} = options
    errorIndices = _.pluck(parsed.errors, 'row')
    for row, index in parsed.data
      if index not in errorIndices
        @_parseRow row

  getDepartment: (shortName) ->
    return @get('deptByShort')[shortName]

  lookUpCourse: (desc) ->
    parts = desc.split(/\s+/)
    return undefined if parts.length != 2
    [name, number] = parts
    dept = @getDepartment name
    return undefined unless dept?
    return dept.getCourse number

  _parseRow: (row) ->
    if row.Time == 'ARR'
      return
    department = @_parseDepartment row
    number = row['Catalog Nbr'].trim()
    title = row['Course Title'].trim()
    credits = +row['Units']
    if department.hasCourse number
      course = department.getCourse number
    else
      course = new scheduler.Course {department, number, title, credits}
    department.addCourse course
    course.addSection scheduler.Section.FromRow course, row

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
      dept = new scheduler.Department {shortName, fullName, academicGroup}
      @_addDepartment dept
      return dept

  _addDepartment: (dept) ->
    @get('departments').add(dept)
    @get('deptByShort')[dept.get('shortName')] = dept

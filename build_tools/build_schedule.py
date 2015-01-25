import sys, os.path, string

def Handle(path, template):
    contents = open(path).read()
    contents = contents.replace("'", "\\'").replace("\n", "\\n")
    basename = os.path.basename(path)
    name = os.path.splitext(basename)[0]
    outPath = 'build/schedules/%s.js' % basename
    with open(outPath, 'w') as handler:
        handler.write(template.substitute(name = name, schedule = contents))
    print 'Schedule compiled: %s.js' % path

def Main():
    template = string.Template(open('build_tools/schedule_template.txt').read())
    schedules = sys.argv[1:]
    for sched in schedules:
        Handle(sched, template)

if __name__ == '__main__':
    Main()

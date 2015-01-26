# Scheduler

To replace schedulizer...

## Filesystem

The top level folders are:

- `schedules` - Contains the raw schedule `.csv` files which get converted into javascript in `build/schedules/`.
- `styles` - Contains the `.less` files which get converted into CSS and put into `build/styles/`.
- `source` - Contains the source `.coffee` files which get compiled into javascript and put into `build/source`.
- `templates` - Contains the template `.handlebars` files which get compiled into a single javascript file in `build/templates`.
- `external` - Contains external `.js` files to be included in the project
- `html` - Contains HTML template files (`.handlebars`), which get parsed and evaluated as `.html` files and put at the top level of `build/`.

Any file of these folders may be nested and their nesting structure will be preserved in the output directory. For example `source/catalog/CourseView.coffee` will compile to `build/source/catalog/CourseView.js`. Additionally, each of these folders may have a top level `dependencies.json` file which declares any source file dependencies that exist in that directory. For example, the `external` folder has the following dependencies:

```json
{
  "backbone.marionette.js": [
    "backbone.js"
  ],
  "backbone.js": [
    "lodash.js"
  ],
  "papaparse.js": [
    "jquery-1.11.1.min.js"
  ]
}
```

As can be seen, the general format is `"source": ["depedencies"...]`.

## Building

To build simply run grunt:

```$ grunt```

Eventually, there will be multiple grunt tasks for production and release but for the moment there is just the `default` task, which does the following:

- `clean` - Cleans the `build` directory.
- `coffee` - Compiles the coffee files in `source` into `build/source`.
- `copy` - Copies the files in `external` into `build/external`.
- `handlebars` - Compiles the handlebars templates in `templates` into `build/templates/templates.js`. In javascript, to access a template in `templates/namespace/view.handlebars` do the following:
```javascript
template = scheduler.templates['namespace.view']
```
- `less` - Compiles the less files in `styles` into `build/styles`.
- `schedule` - Compiles schedules in `schedules` into `build/schedules`. In javascript, to access the schedule `schedules/WN2015.csv` do the following:
```javascript
contents = schedules.WN2015
```
- `html` - Compiles handlebars files from `html` into `build` (note, not into a subfolder e.g. `build/html`). Since these are `handlebars` files, they have certain template variables that can be used. The template variables are simply the directories of source files. Consider the following sample.handlebars:

```handlebars
<html>
<head>
  {{#each source}}
    {{script this}}
  {{/each}}
</head>
<body></body>
</html>
```

When compiled, this will look like:

```html
<html>
<head>
  <script type="text/javascript" src="source/Source1.js"></script>
  <script type="text/javascript" src="source/Source2.js"></script>
  <script type="text/javascript" src="source/sub1/Source3.js"></script>
  <script type="text/javascript" src="source/sub1/sub2/Source4.js"></script>
</head>
<body></body>
</html>
```

# Compile build tools utilities
coffee -c -o build_tools build_tools/*.coffee

# Cleanup
if [ "$(ls -A build)" ]; then
  rm -rf build
fi

# Compile sources
if [ "$(ls -A source/*.coffee)" ]; then
  coffee -c -o build source/*.coffee
  echo 'Source compiled:'
  ls build/*.js
else
  echo "No source files to compile."
fi

# Copy externals
mkdir build/external
cp external/*.js build/external

# Compile templates
if [ "$(ls -A templates/*.handlebars)" ]; then
  handlebars templates/*.handlebars > build/Templates.js
  echo "Templates compiled."
else
  echo "No templates to compile."
fi

# Compile styles
if [ "$(ls -A styles/*.less)" ]; then
  lessc styles/*.less > build/stylesheet.css
  echo "Style sheets compiled:"
  ls build/*.css
else
  echo "No style sheets to compile."
fi

# Compile schedules
mkdir build/schedules
python build_tools/build_schedule.py schedules/*.csv

# Compile html sources
node build_tools/build_html.js \
  --stylesheets build/stylesheet.css \
  --sources build/*.js \
  --externals build/external/*.js \
  --schedules build/schedules/*.js \
  --html templates/html/*.handlebars

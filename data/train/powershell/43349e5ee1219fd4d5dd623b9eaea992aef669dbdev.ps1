$coffeeFiles=@(
    "utils",
    "app",
    "controllers",
    "directives",
    "kendo-rest-grid",
    "services"
)
$coffeeFiles = $coffeeFiles | % {"src/coffee/$_.coffee"}

$builddir="app/static"
jade -P src/index.jade -O $builddir
jade -P src/auth_recv.jade -O $builddir
jade -P src/partials -O $builddir/partials
stylus -o $builddir/css src/styl/style.styl
coffee -l -b -o $builddir/js -j out.js $coffeeFiles
Copy-Item -ea 0 -r src/css $builddir 
Copy-Item -ea 0 -r src/images $builddir
Copy-Item -ea 0 -r src/js $builddir

if {![info exists dbhandle]} {
   set dbfile xotcllib.mk
   mk::file open db $dbfile
   set dbhandle db
}

mk::view layout $dbhandle.Component {name timest:I versioninfo isclosed:I userid:I defcounter:I basedon:I infoid {ComponentObject {objectid:I deforder:I}} {ComponentRequire name}}

mk::view layout $dbhandle.Object {name timest:I versioninfo isclosed:I defbody metadata userid:I basedon:I type infoid {ObjectMethod methodid:I}}

mk::view layout $dbhandle.Method {name timest:I versioninfo category objectname basedon:I userid:I body type infoid}

mk::view layout $dbhandle.Configmap {name timest:I versioninfo isclosed:I userid:I basedon:I prescript postscript infoid {ConfigmapComponent {componentid:I loadorder:F}} {ConfigmapChildren {configmapchildid:I loadorder:F}}}

mk::view layout $dbhandle.Info {infotext}

mk::view layout $dbhandle.Userlib {name longname}

mk::row append $dbhandle.Info infotext "0 row dummy"

mk::file commit $dbhandle

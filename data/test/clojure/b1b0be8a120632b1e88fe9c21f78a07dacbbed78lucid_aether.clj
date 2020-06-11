(ns documentation.lucid-aether
  (:use hara.test))
  
[[:chapter {:title "Introduction"}]]

"`lucid.aether` is used to as an interface to manage dependencies. It is meant to replace [pomegranate](https://github.com/cemerick/pomegranate) for package installation, dependency resolution and other tasks"

"Add to `project.clj` dependencies:

    [im.chit/lucid.aether \"{{PROJECT.version}}\"]

All functionality is in the `lucid.aether` namespace:"

(comment
   (use 'lucid.aether))

[[:chapter {:title "API"
            :link "lucid.aether"
            :exclude ["populate-artifact"]}]]

[[:api {:namespace "lucid.aether"
          :title ""
          :exclude ["populate-artifact"]}]]

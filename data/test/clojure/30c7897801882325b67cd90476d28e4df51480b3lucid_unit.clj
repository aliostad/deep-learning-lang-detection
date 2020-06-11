(ns documentation.lucid-unit)

[[:chapter {:title "Introduction"}]]

"`lucid.unit` allows for management of unit tests as well as docstrings and function meta data. It works by analysing source and test code to manage all related information to a function within the test file."

[[:section {:title "Installation"}]]

"Add to `project.clj` dependencies:"

[[{:stencil true}]]
(comment
  [im.chit/lucid.unit "{{PROJECT.version}}"])

"All functionality is in the `lucid.unit` namespace:"

(comment
  (require '[lucid.unit :as unit]))

[[:chapter {:title "API" :link "lucid.unit"}]]

[[:api {:title "" :namespace "lucid.unit"}]]

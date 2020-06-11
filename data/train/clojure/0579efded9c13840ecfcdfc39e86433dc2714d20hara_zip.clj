(ns documentation.hara-zip
  (:use hara.test)
  (:require [hara.zip :as zip]
            [hara.event :refer :all]))

[[:chapter {:title "Introduction"}]]

"
[hara.zip](https://github.com/zcaudate/hara/blob/master/src/hara/zip.clj) provides a customisable zipper implementation for navigating datastructures"

[[:section {:title "Installation"}]]

"
Add to `project.clj` dependencies:

    [im.chit/hara.zip \"{{PROJECT.version}}\"]
    
All functionality is found contained in the `hara.zip` namespace"

(comment (require '[hara.zip :as zip]))

[[:chapter {:title "Index"}]]

[[:api {:namespace "hara.zip"
        :title ""
        :display #{:tags}}]]

[[:chapter {:title "API"}]]

[[:section {:title "Basics"}]]

[[:api {:namespace "hara.zip"
        :title ""
        :only ["zipper"
               "seq-zip"
               "vector-zip"
               "up"
               "down"
               "left"
               "right"
               "end"
               "cursor"
               "cursor-str"
               "from-cursor"
               "next"
               "prev"
               "find-next"
               "find-prev"
               ]}]]

[[:section {:title "Direction"}]]

[[:api {:namespace "hara.zip"
        :title ""
        :only ["move-up"
               "move-down"
               "move-left"
               "move-right"
               "move-top-most"
               "move-bottom-most"
               "move-left-most"
               "move-right-most"
               "move-up?"
               "move-down?"
               "move-left?"
               "move-right?"
               "top-most?"
               "bottom-most?"
               "left-most?"
               "right-most?"]}]]

[[:section {:title "Elements"}]]

[[:api {:namespace "hara.zip"
        :title ""
        :only ["node"
               "siblings"
               "left-node"
               "right-node"
               "left-nodes"
               "right-nodes"
               "root-node"]}]]

[[:section {:title "Editing"}]]

[[:api {:namespace "hara.zip"
        :title ""
        :only ["delete-left"
               "delete-right"
               "insert-left"
               "insert-right"
               "replace-left"
               "replace-right"
               "prewalk"
               "postwalk"
               "surround"
               "traverse"
               "history"]}]]

[[:chapter {:title "Boundaries"}]]

[[:section {:title "Default Behavior"}]]

"How zippers respond when crossing boundaries can be set. In general, movement will not throw an exception:"

(fact
  (-> (zip/from-cursor '[1 2 |])
      (zip/move-right)
      (zip/cursor))
  => '([1 2 |])

  (-> (zip/from-cursor '[| 1 2])
      (zip/move-left)
      (zip/cursor))
  => '([| 1 2]))

"Whilst deletions and replacements will."

(fact
  (-> (zip/from-cursor '[1 2 |])
      (zip/delete-right))
  
  => (throws-info {:fn :delete-right
                   :op :delete
                   :tag :no-right})

  (-> (zip/from-cursor '[| 1 2])
      (zip/replace-left 1))
  => (throws-info {:fn :replace-left,
                   :op :replace,
                   :tag :no-left}))

[[:section {:title "Overrides"}]]

"However, default behavior can be rewritten through the `hara.event` condition system. In this case a move-left call which previously resulted in the zipper staying where is is is now staring put:"

(fact
  (manage
   (-> (zip/from-cursor '[| 1 2])
       (zip/move-left))
   (on {:tag :no-left}
       e
       (fail)))
  => (throws-info {:fn :move-left,
                   :op :move,
                   :tag :no-left}))

"And a `delete-right` call which previously threw an exception will continue as normal:"

(fact
  (manage
   (-> (zip/from-cursor '[1 2 |])
       (zip/delete-right)
       (zip/cursor))
   (on {:tag :no-right}
       [zip]
       (continue zip)))
  => '([1 2 |]))

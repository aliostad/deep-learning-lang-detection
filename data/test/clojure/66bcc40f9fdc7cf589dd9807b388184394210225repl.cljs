(ns ggj17.repl
  (:require [re-frame.core :as re-frame]))

(def db (re-frame/subscribe [:db]))

(:scene @db)
(:questions @db)

(def scene (re-frame/subscribe [:scene]))

(:characters @scene)

(:character @db)
(:foot @db)
(:objects @db)
(:dialogue @db)
(:realness @db)
(keys @db)

(re-frame/dispatch [:set-character "characters/rex.svg"])
(re-frame/dispatch [:set-objects [{:name "foot"
                                   :file "objects/foot.svg"
                                   :x "80%"
                                   :y "70%"
                                   :width "7%"
                                   :action #(js/alert "Foot!")}]])


(re-frame/dispatch [:set-dialogue
                    {:character :rex
                     :file "characters/rex-face.svg"
                     :type :question
                     :id 5}])

(re-frame/dispatch [:set-dialogue
                    {:character :sam
                     :file "characters/sam-face.svg"
                     :type :answer
                     :id 0}])

(re-frame/dispatch [:set-dialogue nil])

(re-frame/dispatch [:set-dialogue
                    {:character :adam
                     :type :answer
                     :file "characters/adam-face.svg"
                     :id 0}])

(re-frame/dispatch [:set-dialogue
                    {:character :luce
                     :type :answer
                     :file "characters/scarlett-face.svg"
                     :id 0}])


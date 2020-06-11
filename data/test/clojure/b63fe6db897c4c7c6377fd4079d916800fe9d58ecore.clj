(ns hunt-for-the-thief-who-stole-rock.core
  (:require
   [clojure.java.browse :as browse]
   [hunt-for-the-thief-who-stole-rock.visualization.svg :refer [xml]])
  (:gen-class))

(def heists [{:location "Cologne, Germany"
              :instrument "Guitar"
              :lat 50.95
              :lng 6.97}
             {:location "Zurich, Switzerland"
              :instrument "Bass"
              :lat 47.37
              :lng 8.55}
             {:location "Marseille, France"
              :instrument "Synth"
              :lat 43.30
              :lng 5.37}
             {:location "Zurich, Switzerland"
              :instrument "Drums"
              :lat 47.37
              :lng 8.55}
             {:location "Vatican City"
              :instrument "Lead Singer's Microphone"
              :lat 41.90
              :lng 12.45}])

(defn url
  [filename]
  (str "file:///"
       (System/getProperty "user.dir")
       "/"
       filename))

(defn template
  [contents]
  (str "<style>polyline { fill:none; stroke:#5881d8; stroke-width:3}</style>"
       contents))

(defn -main
  [& args]
  (let [filename "map.html"]
    (->> heists
         (xml 50 100)
         template
         (spit filename))
    (browse/browse-url (url filename))))

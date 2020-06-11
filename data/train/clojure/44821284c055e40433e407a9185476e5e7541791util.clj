(ns brun.util
  (:require [clojure.string :as string]
            [webica.core :as w]
            [webica.web-driver-wait :as wait]
            [webica.web-driver :as driver]
            [webica.remote-web-driver :as browser]
            [webica.chrome-driver :as chrome]
            [webica.web-element :as element]
            [webica.keys :as wkeys]
            [taoensso.timbre :as timbre :refer [info debug]]
            ;;[brun.term]
            ))


(defonce state (atom {}))

(defn runjs
  ([s] (runjs s nil))
  ([s arg]
   (browser/execute-script s arg)))


(defn startup
  ([]
   (startup nil))
  ([cfg]
   (chrome/start-chrome (:chromepath cfg))

   ;; resize for no popups
   (let [[w h] (or (:size cfg) [550 470])]
     (-> (driver/manage)
         .window
         (.setSize (org.openqa.selenium.Dimension. w h))))
   
   ;; init vars
   (reset! state {:keyboard (browser/get-keyboard)
                  :mouse (browser/get-mouse)
                  :actions (org.openqa.selenium.interactions.Actions. (driver/get-instance))
                  :width (runjs "return window.innerWidth;")
                  :height (runjs "return window.innerHeight;")
                  :position (-> (driver/manage) .window .getPosition)
                  :hidden false
                  :wait (:wait cfg)
                  ;;:term (start-terminal)
                  })
   
   ;; start listening to console keys
   ;;(poll-terminal-keys)
   ))


(defn cleanup []
  (info "cleanup")
  (chrome/quit)
  ;;(t/stop (:term @state))
  )


(defn navigate [url]
  (info "navigate to" (str "[" url "]"))
  (browser/get url))


(defn navigate-back []
  (info "navigate back")
  (.back (browser/navigate)))


(defn by-id [id]
  (browser/find-element-by-id id))


(defn by-class [cls]
  (browser/find-element-by-class-name cls))


(defn by-id-all [id]
  (browser/find-elements-by-id id))


(defn by-class-all [cls]
  (browser/find-elements-by-class-name cls))


(defn by-name [s]
  (browser/find-element-by-name s))


(defn by-link-text [s]
  (browser/find-element-by-link-text s))


(defn visible? [el]
  (boolean (element/is-displayed? el)))


(defn wait [t]
  (w/sleep t))


(defn get-attr [el attr]
  (element/get-attribute el attr))


(defn get-text [el]
  (element/get-text el))


(defn press-keys [ks]
  (.sendKeys (:keyboard @state) (into-array CharSequence ks)))


(defn wait-for-title [title]
  (wait/until
   (wait/instance 10)
   (wait/condition
    (fn [driver]
      (string/starts-with?
       (string/lower-case (driver/get-title driver))
       (string/lower-case title))))))


(defn wait-for-id [id]
  (info "waiting for id" (str "[" id "]"))
  (wait/until
   (wait/instance 10)
   (wait/condition
    (fn [driver]
      (try (browser/find-element-by-id id)
           (catch java.lang.reflect.InvocationTargetException e false))))))


(defn wait-for-class [cls]
  (info "waiting for class" (str "[" cls "]"))
  (wait/until
   (wait/instance 10)
   (wait/condition
    (fn [driver]
      (try (browser/find-element-by-class-name cls)
           (catch java.lang.reflect.InvocationTargetException e false)
           (finally true))))))


(defn slowly-type [el text]
  (info "typing:" text)
  ;;(wait 3)
  (doseq [ch text]
    (wait (rand))
    (element/send-keys el (str ch))))


(defn random-sleep
  ([] (random-sleep (:wait @state)))
  ([[t1 t2]]
   (wait (+ t1 (inc (rand-int (- t2 t1)))))))



(defn get-y [el]
  (.y (element/get-location el)))


(defn get-x [el]
  (.x (element/get-location el)))


(defn move-mouse-to [el]
  ;;(.perform (.moveToElement (:actions @state) el))
  (.mouseMove (:mouse @state) (.getCoordinates el)))


(defn move-mouse-and-click [el]
  #_(let [y (get-y el)]
    (when (< y 100)
      (runjs (str "window.scrollBy(0," (- y 100) ");"))))
  (move-mouse-to el)
  (random-sleep)
  (.click el))


(defn move-random [])


(defn page-down []
  (press-keys [wkeys/PAGE_DOWN]))


(defn page-up []
  (press-keys [wkeys/PAGE_UP]))


(defn arrow-down []
  (press-keys [wkeys/ARROW_DOWN]))


(defn arrow-up []
  (press-keys [wkeys/ARROW_UP]))


(defn f5 []
  (press-keys [wkeys/F5])
  (random-sleep [5 10]))


(defn esc []
  (press-keys [wkeys/ESCAPE]))

(defn press-tab []
  (press-keys [wkeys/TAB]))


(defn get-to [el]
  (let [yf (get-y el)
        border 100]
    (info "getting to" (str yf " [" (get-text el) "]"))
    (loop []
      (let [yc (runjs "return window.scrollY;")
            height (runjs "return window.innerHeight;")]
        (debug yc yf)
        (when-let [actions (if (> yc (- yf border))
                             [page-up arrow-up]
                             (if (> yf (+ yc height))
                               [page-down arrow-down]))]
          (do
            (let [action (rand-nth actions)]
              (debug action)
              (action)
              (random-sleep)
              (recur))))))))



(defn random-thought []
  (let [thoughts ["what the hell is THAT!"
                  "am I really just a program?"
                  "duuuuuuuude"
                  "cool..."
                  "I like that one"
                  "this one seems interesting"
                  "a bit hungry, have you got any cookies?"]]
   (info (rand-nth thoughts))))


(defn coin []
  (rand-nth [true false]))

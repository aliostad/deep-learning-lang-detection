(ns ct5.ui
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [om.core :as om :include-macros true]
            [om.dom :as dom :include-macros true]
            [cljs-http.client :as http]
            [cljs.core :refer [js->clj]]
            [cljs.core.async :refer [<!]]
            [ct5.core :refer [last-non-empty-map-index url? with-indices]]))

(defonce app-state

  (atom {:title "Casual Top Five"
         :lists []
         ;; is this the right way to manage item visibility?
         :list-modal-visible? false}))

(defn load-fives! []
  (go
    (let [response (<! (http/get "/fives"))
          body (:body response)]
      (swap! app-state assoc :lists (js->clj body)))))

(defn delete-lists! []
  (go
    (let [response (<! (http/get "/delete-all-lists"))]
      (swap! app-state assoc :lists []))))

(defn create-test-data! []
  (go
    (let [response (<! (http/get "/create-test-data"))]
      (load-fives!))))

(defn toggle-list-dialog! []
  (swap! app-state update-in [:list-modal-visible?] not))

(defn close-list-dialog!
  ([]
   (swap! app-state assoc :list-modal-visible? false))
  ([e _ _]
   (.preventDefault e)
   (close-list-dialog!)))

(defn header [data]
  (om/component
   (dom/div #js {:className "admin-controls"}
            (dom/a #js {:onClick create-test-data!} "create test data")
            " | "
            (dom/a #js {:onClick delete-lists!} "delete all lists")
            " | "
            (dom/a #js {:onClick toggle-list-dialog!} "add list"))))

(defn list-item [{:keys [text url]} thing]
  (dom/li nil
          (if (empty? url)
            text
            (dom/a #js {:href url}
                   (if (empty? text)
                     url
                     text)))))
  

(defn top-five [[index data]]
  (om/component
   (dom/div nil
            (dom/h3 nil
                    (:title data)
                    (if-let  [author (:author data)]
                      (str " (" author ")")))
            (dom/ul nil
                    (map list-item (:things data))))))

(defn create-five! [five]
  (go
    (let [response (<! (http/post "/five" {:json-params five}))
          body (:body response)]
      (load-fives!))))

(defn handle-five-submission [form-data]

  (defn form-thing-to-schema-thing [[main-text subtitle]]
    (if (url? main-text)
      {:text subtitle :url main-text}
      {:text main-text :url nil}))

  (create-five! (assoc form-data :things (map form-thing-to-schema-thing (:things form-data))))
  (close-list-dialog!))

(defn new-five-form [data owner]

  (defn field-update! [korks e]
    (om/set-state! owner korks (.. e -target -value)))
  
  (defn text-field
    ([label korks]
     (text-field nil label korks))
    ([attrs label korks]
     (let [value (om/get-state owner korks)]
       (dom/span attrs
                (dom/label nil
                           label " "
                           (dom/input #js {:type "text"
                                           :value (if (nil? value) "" value)
                                           :onChange #(field-update! korks %)}))))))

  (defn thing-formlet [label korks]
    (let [thing (om/get-state owner korks)
          item-text (thing 0)]

      (dom/div nil
               (dom/span nil 
                         (text-field label (conj korks 0))
                         (dom/br nil)
                         (if (url? item-text)
                           (text-field "(link text)" (conj korks 1)))))))

  (reify
    
    om/IInitState
    (init-state [_]
      {:things (vec (repeat 5 ["" nil]))})

    om/IRenderState
    (render-state [_ state]

      (defn display-nth-field? [n]
        (if (= 0 n)
          (not (empty? (:title state)))
          (>= (last-non-empty-map-index (:things state)) (dec n))))

      (def field-labels ["A thing" "Another thing" "And a third thing" "Getting there..." "One last thing"])
      
      (dom/div #js {:className "new-five-form"}

               (text-field #js {:className "heading-field"} "All time top five..." [:title])

               (map #(if (display-nth-field? %) (thing-formlet (field-labels %) [:things %])) (range 0 5))

               (dom/div nil
                (if (display-nth-field? 5)
                  [(dom/a #js {:onClick #(handle-five-submission state)} "save")
                   " | "])
                (dom/a #js {:onClick close-list-dialog!} "cancel"))))))


(defn root-component [data owner]
  (om/component 
   (dom/div nil
            (om/build header data)
            (dom/h1 nil "Casual Top Five")
            (if (:list-modal-visible? data)
              (om/build new-five-form nil))
            ; with-indices is necessary for React to have a unique key
            (om/build-all top-five (with-indices (:lists data)) {:key-fn first}))))


(ns yaourt-iat.core
  (:require [goog.dom :as gdom]
            [om.next :as om :refer-macros [defui]]
            [yaourt-iat.util :as util]
            [yaourt-iat.conf :refer [conf]]
            [om.dom :as dom]))

(enable-console-print!)

(defmulti read om/dispatch)

(defmethod read :page/current
  [{:keys [state]} _ _]
  (let [st @state]
    (if-let [v (get st :page/current)]
      {:value v}
      {:remote true})))

(defmethod read :page/pages
  [{:keys [query state]} k _]
  (let [st @state]
    (if-let [v (get st k)]
      (do
        {:value (om/db->tree query v st)})
      {:remote true})))

(defmethod read :page/intro
  [{:keys [query state]} k _]
  (let [st @state]
    {:value (om/db->tree query (get st k) st)}))

(defmulti mutate om/dispatch)

;; -----------------------------------------------------------------------------
;; Reconciler

(def parser (om/parser {:read read :mutate mutate}))

(def reconciler
  (om/reconciler
    {:state {}
     :parser parser
     :send (util/transit-conf)
     :history 0}))

;; -----------------------------------------------------------------------------
;; Components

(defui Word
  static om/IQuery
  (query [_]
    [:type :value])
  Object
  (render [this]
    (let [{:keys [value]} (om/props this)]
      (dom/p #js {:className "item"} value))))

(def word (om/factory Word))

(defui Image
  static om/IQuery
  (query [_]
    [:type :value])
  Object
  (render [this]
    (let [{:keys [value]} (om/props this)]
      (dom/img
        #js {:src value}))))

(def image (om/factory Image))

(defui Item
  static om/Ident
  (ident [_ {:keys [type value] :as props}]
    [type value])
  static om/IQuery
  (query [_]
    {:target/word (om/get-query Word)
     :target/image (om/get-query Image)})
  Object
  (render [this]
    (let [{:keys [type]} (om/props this)]
      (dom/div nil
               (({:target/word   word
                  :target/image  image
                  } type)
                 (om/props this))))))

(def item (om/factory Item))

(defui ImageLoader
  static om/Ident
  (ident [_ {:keys [type value]}]
    [type value])
  static om/IQuery
  (query [_]
    [:type :value])
  Object
  (render [this]
    (let [{:keys [value]} (om/props this)]
      (dom/img #js {:src value
                    :className "invisible"
                    :onLoad #(om/transact! this `[(img/loaded) [:page/intro 0]])
                    :onError #(om/transact! this `[(img/error) [:page/intro 0]])}))))

(def image-loader (om/factory ImageLoader {:keyfn :value}))

(defui Intro
  static om/IQuery
  (query [_]
    [:id :type :text :error :img-count {:loader (om/get-query ImageLoader)}])
  Object
  (render [this]
    (let [{:keys [text error img-count loader]} (om/props this)
          img-total (count loader)]
      (dom/div #js {:className "centred"}
               (dom/h1 nil "Bienvenue !")
               (dom/p nil text)
               (map image-loader loader)
               (cond
                 error (dom/p nil "Erreur dans le chargement des images.")
                 (< img-count img-total) (dom/p nil (str "Veuillez patienter. Chargement des images : " img-count "/" img-total))
                 :else (dom/p nil "Appuyer sur Espace pour continuer")
                 )))))

(def intro (om/factory Intro {:keyfn :id}))

(defui End
  static om/IQuery
  (query [_]
    [:id :type :text])
  Object
  (render [this]
    (let [{:keys [text]} (om/props this)]
      (dom/div #js {:className "centred"}
               (dom/h1 nil "Merci !")
               (dom/p nil text)))))

(def end (om/factory End))

(defn render-categories
  [class items colors]
  (dom/div #js {:className class}
           (map #(dom/p #js {:className "item" :style #js {:color %1}} %2) colors items)))

(defui Instruction
  static om/IQuery
  (query [_]
    [:id :type :text :left :right :colors])
  Object
  (render [this]
    (let [{:keys [text left right colors]} (om/props this)]
      (dom/div nil
               (render-categories "left" left colors)
               (render-categories "right" right colors)
               (dom/div #js {:className "centred"}
                        (dom/h1 nil "Consignes")
                        (map #(dom/p nil %) text))))))

(def instruction (om/factory Instruction {:keyfn :id}))

(defui Label
  static om/IQuery
  (query [_]
    [:id :type :left :right :colors])
  Object
  (render [this]
    (let [{:keys [left right colors]} (om/props this)]
      (dom/div nil
               (render-categories "left" left colors)
               (render-categories "right" right colors)))))

(def label (om/factory Label {:keyfn :id}))

(defui Cross
  static om/IQuery
  (query [_]
    [:id :type :left :right :colors])
  Object
  (render [this]
    (let [{:keys [left right colors]} (om/props this)]
      (dom/div nil
               (render-categories "left" left colors)
               (render-categories "right" right colors)
               (dom/div #js {:className "centred"}
                        (dom/p #js {:className "item"} "+"))))))

(def cross (om/factory Cross {:keyfn :id}))

(defui Target
  static om/IQuery
  (query [_]
    [:id :type :left :right :category :factor :expected :colors :color {:target (om/get-query Item)}])
  Object
  (render [this]
    (let [{:keys [left right target colors color]} (om/props this)]
      (dom/div nil
               (render-categories "left" left colors)
               (render-categories "right" right colors)
               (dom/div #js {:className "centred" :style #js {:color color}}
                        (item target))))))

(def target (om/factory Target {:keyfn :id}))

(defui Wrong
  static om/IQuery
  (query [_]
    [:id :type :left :right :colors :color :expected {:target (om/get-query Item)}])
  Object
  (render [this]
    (let [{:keys [left right target colors color]} (om/props this)]
      (dom/div nil
               (render-categories "left" left colors)
               (render-categories "right" right colors)
               (dom/div #js {:className "centred" :style #js {:color color}}
                        (item target))
               (dom/div #js {:className "top-centred"}
                        (dom/p #js {:className "item" :style #js {:color "#f00"}} "X"))))))

(def wrong (om/factory Wrong {:keyfn :id}))

(defui Transition
  static om/IQuery
  (query [_]
    [:id :type])
  Object
  (render [_]
    (dom/h1 nil nil)))

(def transition (om/factory Transition))

(defui Page
  static om/Ident
  (ident [_ {:keys [id type]}]
    [type id])
  static om/IQuery
  (query [_]
    {:page/intro (om/get-query Intro)
     :page/instruction (om/get-query Instruction)
     :page/label (om/get-query Label)
     :page/cross (om/get-query Cross)
     :page/target (om/get-query Target)
     :page/wrong (om/get-query Wrong)
     :page/transition (om/get-query Transition)
     :page/end (om/get-query End)})
  Object
  (render [this]
    (let [{:keys [_ type]} (om/props this)]
      (dom/div nil
               (({:page/intro          intro
                  :page/instruction    instruction
                  :page/label          label
                  :page/cross          cross
                  :page/target         target
                  :page/wrong          wrong
                  :page/transition     transition
                  :page/end            end} type)
                 (om/props this))))))

(def page (om/factory Page))

(defui RootView
  static om/IQuery
  (query [_]
    [:page/current {:page/pages (om/get-query Page)}])
  Object
  (render [this]
    (let [{:keys [page/current page/pages]} (om/props this)]
      (dom/div nil
               (page (pages current)))))
  (componentDidMount [this]
    (.addEventListener
      js/document
      "keydown"
      (fn [e]
        (om/transact! this
                      `[(user/click ~{:keycode (.-which e)})]))))
  (componentWillUnmount [this]
    (.addEventListener
      js/document
      "keydown"
      (fn [e]
        (om/transact! this
                      `[(user/click ~{:keycode (.-which e)})])))
    ))

(om/add-root! reconciler RootView (gdom/getElement "app"))

;; -----------------------------------------------------------------------------
;; Dispatch mutate

(defn init-result [state]
  (merge state {:results [["left" "right" "target" "factor" "category" "expected" "response" "time" "total-time"]]
                :page/count (count (:page/pages state))
                :total-timer (.getTime (js/Date.))}))

(defn next-page [state]
  (update-in state [:page/current] inc))

(defn start-timer [state]
  (assoc state :timer (.getTime (js/Date.))))

(defn set-timeout [component ms]
  (js/setTimeout
    (fn [] (om/transact! component `[(time/out)]))
    ms))

(defmulti dispatch-click #(:type %))

(defmethod dispatch-click :page/intro
  [_ state _ keycode]
  (let [intro (get-in state [:page/intro 0])
        img-count (:img-count intro)
        img-total (count (:loader intro))]

    (if (and (== (get-in conf [:keys :instruction]) keycode) (>= img-count img-total))
      (init-result (next-page state))
      state)))

(defmethod dispatch-click :page/instruction
  [_ state component keycode]
  (if (== (get-in conf [:keys :instruction]) keycode)
    (do
      (set-timeout component (get-in conf [:times :transition]))
      (next-page state))
    state))

(defn target-answer
  [side page state component]
  (let [response-time (- (.getTime (js/Date.)) (state :timer))
        total-time (- (.getTime (js/Date.)) (state :total-timer))
        result (= (page :expected) side)
        s (update
            state
            :results
            #(concat % [[(into [] (page :left))
                         (into [] (page :right))
                         (page :target)
                         (page :factor)
                         (page :category)
                         (page :expected)
                         result
                         response-time
                         total-time]]))]
    (if result
      (do
        (set-timeout component (get-in conf [:times :transition]))
        (next-page (next-page s)))
      (next-page s))))

(defmethod dispatch-click :page/target
  [page state component keycode]
  (condp = keycode
    (get-in conf [:keys :left]) (target-answer :left page state component)
    (get-in conf [:keys :right]) (target-answer :right page state component)
    state))

(defn wrong-answer
  [side page state component]
  (if (= (page :expected) side)
    (do
      (set-timeout component (get-in conf [:times :transition]))
      (next-page state))
    state))

(defmethod dispatch-click :page/wrong
  [page state component keycode]
  (condp = keycode
    (get-in conf [:keys :left]) (wrong-answer :left page state component)
    (get-in conf [:keys :right]) (wrong-answer :right page state component)
    state))

(defmethod dispatch-click :default
  [_ state _ _]
  state)

(defn manage-click [state component params]
  (let [ keycode (params :keycode)
        [type id] ((state :page/pages) (state :page/current))
        page (get-in state [type id])]
    (dispatch-click page state component keycode)))

(defmethod mutate 'user/click
  [{:keys [state component]} _ params]
  {:action
   (fn []
     (swap! state #(manage-click % component params)))})

(defmulti dispatch-timeout #(identity [(% :type)]))

(defmethod dispatch-timeout [:page/label]
  [_ state component]
  (set-timeout component (get-in conf [:times :cross]))
  (next-page state))

(defmethod dispatch-timeout [:page/cross]
  [_ state _]
  (start-timer (next-page state)))

(defmethod dispatch-timeout [:page/transition]
  [_ state component]
  (let [current (:page/current state)
        count (:page/count state)]
    (if (< current (- count 2))
      (set-timeout component(get-in conf [:times :label]))
      (set-timeout component 0)))
  (next-page state))

(defmethod dispatch-timeout [:page/end]
  [_ state _]
  (util/transit-results (state :results))
  state)

(defn manage-timeout [state component]
  (let [[type id] ((state :page/pages) (state :page/current))
        page (get-in state [type id])]
    (dispatch-timeout page state component)))

(defmethod mutate 'time/out
  [{:keys [state component]} _ _]
  {:action
   (fn []
     (swap! state #(manage-timeout % component)))})

(defn img-loaded
  [state]
  (update-in state [:page/intro 0 :img-count] inc))

(defn img-error
  [state]
  (assoc-in state [:page/intro 0 :error] true))

(defmethod mutate 'img/loaded
  [{:keys [state]} _ _]
  {:action
   (fn []
     (swap! state img-loaded))})

(defmethod mutate 'img/error
  [{:keys [state]} _ _]
  {:action
   (fn []
     (swap! state img-error))})

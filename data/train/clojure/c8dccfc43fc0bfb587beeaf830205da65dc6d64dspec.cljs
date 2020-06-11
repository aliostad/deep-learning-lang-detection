(ns caliban.spec
  (:require [reagent.core :as r]
            [cljs.spec.alpha :as s]
            [cljs.spec.test.alpha]
            [clojure.string :as str]
            [caliban.id3 :refer [ID3]]
            [caliban.render]
            [caliban.d3]
            [clojure.test.check.generators :as cg]))

;; General

(s/def ::width int?)
(s/def ::height int?)
(s/def ::react-component any?)
(s/def ::handler fn?)

;; D3-SVG Children

(s/def :d3-svg.child.attrs/id keyword?)
(s/def :d3-svg.child.attrs/getter fn?)
(s/def :d3-svg.child.attrs/config map?)
(s/def :d3-svg.child.attrs/utils map?)

(s/def :d3-svg.child/type #(satisfies? ID3 (new %)))
(s/def :d3-svg.child/attrs (s/keys :req-un [:d3-svg.child.attrs/id
                                            :d3-svg.child.attrs/getter]
                                   :opt-un [:d3-svg.child.attrs/config
                                            :d3-svg.child.attrs/utils]))

(s/def ::d3-svg.child (s/cat :type :d3-svg.child/type
                             :attr :d3-svg.child/attrs))

;;; D3-SVG Hiccup Form

(s/def :d3-svg/id keyword?)
(s/def :d3-svg/data coll?)
(s/def :d3-svg/options (s/keys :req-un [:d3-svg/id
                                        :d3-svg/data]))

(s/def :d3-svg/children (s/* (s/spec ::d3-svg.child)))

(s/def :d3-svg/hiccup (s/cat :comp ::react-component
                             :options :d3-svg/options
                             :children :d3-svg/children))

;;; ID3 Elements

(s/def :id3/element #(satisfies? ID3 %))
(s/def :element/instance #(satisfies? ID3 %))

;; Common

(s/def :element.utils/scale fn?)
(s/def :element.utils/translate fn?)

(s/def :element/getter fn?)
(s/def :element/utils (s/keys :opt-un [:element.utils/scale
                                       :element.utils/translate]))

(defmulti element (fn [coll]
                    (let [type-key (as-> (type (:instance coll)) $
                                         (.-cljs$lang$ctorStr $)
                                         (str/split $ "/")
                                         (last $)
                                         (keyword $))]
                      type-key)))

(defmethod element :Line
  [_]
  (s/keys :req-un [:element/instance
                   :element.Line/config
                   :element/getter]
          :opt-un [:element/utils]))

(defmethod element :VerticalBar
  [_]
  (s/keys :req-un [:element/instance
                   :element.VerticalBar/config
                   :element/getter]
          :opt-un [:element/utils]))

(defmethod element :Axis
  [_]
  (s/keys :req-un [:element/instance
                   :element.Axis/config
                   :element/getter]
          :opt-un [:element/utils]))


(defmethod element :GridAxis
  [_]
  (s/keys :req-un [:element/instance
                   :element.GridAxis/config
                   :element/getter]
          :opt-un [:element/utils]))

(defmethod element :LinePoints [_]
  (s/keys :req-un [:element/instance
                   :element.LinePoints/config
                   :element/getter]
          :opt-un [:element/utils]))

(defmethod element :LineTooltips [_]
  (s/keys :req-un [:element/instance
                   :element.LineTooltips/config
                   :element/getter]
          :opt-un [:element/utils]))

(defmethod element :LineHover [_]
  (s/keys :req-un [:element/instance
                   :element.LineHover/config
                   :element/getter]
          :opt-un [:element/utils]))

(defmethod element :Brush [_]
  (s/keys :req-un [:element/instance]))

(defmethod element :LineZoom [_]
  (s/keys :req-un [:element/instance]))

(defmethod element :Zoomer [_]
  (s/keys :req-un [:element/instance]))

(defmethod element :ClipPath [_]
  (s/keys :req-un [:element/instance]))

(defmethod element :VerticalHoverGridLine [_]
  (s/keys :req-un [:element/instance]))

(s/def ::element (s/multi-spec element ::element))
(s/def :state/elements (s/every #(s/valid? ::element (-> % vals first))))

;; State Utils

(s/def :state.utils/scale (s/or
                            :fn fn?
                            :fns (s/every fn?)))                   ;; scale returns a vector of different scale-fns
(s/def :state.utils/translate fn?)                          ;; translate returns only one function

;; State

(s/def :state/data vector?)
(s/def :state/id keyword?)
(s/def :state/svg-size (s/keys :req-un [::width ::height]))
(s/def :state/utils (s/keys :opt-un [:state.utils/scale
                                     :state.utils/translate]))

(s/def ::state (s/keys :req-un [:state/data
                                :state/id
                                :state/svg-size
                                :state/elements]
                       :opt-un [:state/utils]))

;; JS Data

(s/def ::data #(or (= (type %) js/Array)
                   (false? %)))

;; Draw Loop

(s/fdef caliban.render/make-state
        :args (s/alt
                :one-arg (s/cat :comp ::react-component)
                :two-args (s/cat :component ::react-component
                                 :hiccup (s/spec :d3-svg/hiccup)))
        :ret ::state)

(s/fdef caliban.d3/draw
        :args (s/cat :state ::state
                     :initial-draw? (s/* any?)))

;;; ID3 Fns

(s/fdef caliban.id3/initialize-selection
        :args (s/cat :this :element/instance
                     :state ::state
                     :data ::data)
        :ret :id3/element)

(s/fdef caliban.id3/select
        :args (s/cat :this :element/instance
                     :state ::state
                     :data ::data)
        :ret :id3/element)

(s/fdef caliban.id3/data
        :args (s/cat :element :element/instance
                     :state ::state
                     :data ::data)
        :ret :id3/element)

(s/fdef caliban.id3/render
        :args (s/cat :this :element/instance
                     :state ::state
                     :data ::data)
        :ret :id3/element)

(s/fdef caliban.id3/render-enter
        :args (s/cat :this :element/instance
                     :state ::state
                     :data ::data)
        :ret :id3/element)

(s/fdef caliban.id3/render-exit
        :args (s/cat :this :element/instance))

;;; Instrumentation
(comment
(cljs.spec.test.alpha/instrument `caliban.id3/initialize-selection)
(cljs.spec.test.alpha/instrument `caliban.id3/data)
(cljs.spec.test.alpha/instrument `caliban.id3/select)
(cljs.spec.test.alpha/instrument `caliban.id3/render)
(cljs.spec.test.alpha/instrument `caliban.id3/render-enter)
(cljs.spec.test.alpha/instrument `caliban.id3/render-exit)
(cljs.spec.test.alpha/instrument `caliban.d3/draw)
(cljs.spec.test.alpha/instrument `caliban.render/make-state))

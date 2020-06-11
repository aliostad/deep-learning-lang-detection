(ns flapjax.core
  (:use-macros
    [hlisp.macros :only [<- <<- def-values]])
  (:require 
    [clojure.string :as string]
    [jayq.core      :as jq]
    [jayq.util      :as ju]
    [flapjax.dom    :as dom]
    F))

(declare receiverE sendE consB)

(def EventStream  F/EventStream)
(def Behavior     F/Behavior)

;;;;;;;;;;;;;;;;;;;;;;;;;;;  UTILITY FUNCTIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn startsWith
  [streamE v]
  (.startsWith streamE v))

(defn changes
  [sourceB]
  (.changes sourceB))

;;;;;;;;;;;;;;;;;;;;;;;;;  EVENT STREAM FUNCTIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def oneE   F/oneE)
(def zeroE  F/zeroE)
(def mapE   F/mapE)
(def mergeE F/mergeE)

(defn switchE
  [streamE]
  (.switchE streamE))

(defn filterE
  [streamE pred]
  (.filterE streamE pred))

(defn constantE
  [streamE v]
  (.constantE streamE v))

(defn collectE
  [streamE init f]
  (.collectE streamE init f))

(defn notE
  [streamE]
  (.notE streamE))

(defn filterRepeatsE
  [streamE]
  (.filterRepeatsE streamE))

(def receiverE F/receiverE)
(def sendEvent F/sendEvent)

(defn sendE
  [streamE v]
  (.sendEvent streamE v))

(defn snapshotE
  [streamE]
  (.snapshotE streamE))

(defn onceE
  [streamE]
  (.onceE streamE))

(defn skipFirstE
  [streamE]
  (.skipFirstE streamE))

(defn delayE
  [streamE intervalB]
  (.delayE streamE intervalB))

(defn blindE
  [streamE intervalB]
  (.blindE streamE intervalB))

(defn calmE
  [streamE intervalB]
  (.calmE streamE intervalB))

(def timerE F/timerE)

;;;;;;;;;;;;;;;;;;;;;;;;;;;  BEHAVIOR FUNCTIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def constantB F/constantB)

(defn delayB
  [sourceB intervalB]
  (.delayB sourceB intervalB))

(defn valueNow
  [sourceB]
  (.valueNow sourceB))

(defn switchB
  [sourceBB]
  (.switchB sourceBB))

(def andB F.Behavior/andB)
(def orB  F.Behavior/orB)

(defn notB
  [valueB]
  (.notB valueB))

(def liftB F/liftB)
(def condB F/condB)

(defn liftB*
  [& args]
  (apply liftB (last args) (butlast args)))

(defn ifB
  [predicateB consequentB alternativeB]
  (.ifB predicateB consequentB alternativeB))

(def timerB F/timerB)

(defn blindB
  [sourceB intervalB]
  (.blindB sourceB intervalB))

(defn calmB
  [sourceB intervalB]
  (.calmB sourceB intervalB))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  HLISP SPECIFIC  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn isE?
  [stream]
  (= (type stream) EventStream))

(defn isB?
  [stream]
  (= (type stream) Behavior))

(defn E->B
  ([streamE]
   (E->B streamE nil))
  ([streamE v] 
   (startsWith (filterRepeatsE streamE) v)))

(defn B->E
  [valueB]
  (filterRepeatsE (changes valueB)))

;;;;;;;;;;;;;;;;;;;;;;;;;  EVENT STREAM FUNCTIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn mapE*
  [argE f]
  (mapE f argE))

(defn distinctE
  [streamE]
  (-> streamE
    (collectE [::nil #{}] #(if (contains? %2 %1) [::nil %2] [%1 (conj %2 %1)]))
    (filterE (comp (partial not= ::nil) first))
    (mapE* first))) 

(defn filterRepeatsE
  [streamE]
  (-> streamE
    (collectE [::nil ::nil] #(vector %1 (if (= %1 (first %2)) ::nil %1)))
    (filterE #(not= ::nil (second %)))
    (mapE* first)))

(defn skipE
  [streamE n]
  (if (= n 1)
    (skipFirstE streamE)
    (skipE (skipFirstE streamE) (dec n))))

(defn initE
  ([v]
   (initE (receiverE) v))
  ([streamE v] 
   (jq/$ #(sendE streamE v)) 
   streamE))

(defn doInitE
  ([f] 
   (doInitE (receiverE) f)) 
  ([streamE f]
   (jq/$ #(sendE streamE (f)))
   streamE))

(defn doE
  [streamE f]
  (mapE (fn [v] (f v) v) streamE))

(defn consE
  [& streamEs]
  (B->E (apply consB (mapv E->B streamEs))))

(defn applyE
  [streamE f]
  (mapE (partial apply f) streamE))

(defn caseE
  [& streamvals]
  (apply mergeE (mapv (partial apply constantE) (partition 2 streamvals))))

(defn compE
  [streamE1 streamE2]
   (mapE (partial sendE streamE1) streamE2))

(defn truthE
  [streamE]
  (filterE streamE identity))

(defn extractValueE
  [streamE valB]
  (mapE #(valueNow valB) streamE))

(defn getE
  ([streamE k]
   (mapE #(get % k) streamE)) 
  ([streamE k not-found]
   (mapE #(get % k not-found) streamE)))

(defn getInE
  ([streamE ks]
   (mapE #(get-in % ks) streamE)) 
  ([streamE ks not-found]
   (mapE #(get-in % ks not-found) streamE)))

(defn atomE
  [atom]
  (let [retE (receiverE)]
    (add-watch atom (gensym) #(sendE retE %4))
    retE))

;;;;;;;;;;;;;;;;;;;;;;;;;;;  BEHAVIOR FUNCTIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn consB
  [& sourceBs]
  (apply liftB vector sourceBs))

(defn applyB
  [f & argBs]
  (apply liftB (partial apply f) argBs))

(defn getB
  ([sourceB k]
   (liftB #(get % k) sourceB)) 
  ([sourceB k not-found]
   (liftB #(get % k not-found) sourceB)))

(defn getInB
  ([sourceB ks] 
   (liftB #(get-in % ks) sourceB))
  ([sourceB ks not-found]
   (liftB #(get-in % ks not-found) sourceB)))

(defn whenB
  [predicateB consequentB]
  (ifB predicateB consequentB (constantB nil)))

(defn whenNotB
  [predicateB alternativeB]
  (ifB predicateB (constantB nil) alternativeB))

(defn =B
  [sourceB v]
  (liftB #(= v %) sourceB))

(defn not=B
  [sourceB v]
  (liftB #(not= v %) sourceB))

(defn locationHashB
  [dfl]
  (-> (timerE 50)
    (<- mapE #(.-hash js/window.location))
    (<- mapE #(if (string/blank? %) dfl (subs % 1)))
    (E->B dfl)))

(defn logB
  [inB tag]
  (mapE #(js/console.log tag (ju/clj->js %))
        (filterRepeatsE (mergeE (B->E inB) (oneE (valueNow inB))))))

(defn atomB
  [atom]
  (E->B (atomE atom) @atom))

(defn filterRepeatsB
  [inB]
  (E->B (changes inB) (valueNow inB)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  CORE EVENTS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn core-event
  [event & [default]]
  (let [r (receiverE)]
    (->
      (jq/$ "body")
      (.on event (fn [ev]
                   (sendE r ev)
                   (if default (default ev) true))))
    r))

(def *submit*     (core-event "submit" (constantly false)))
(def *click*      (core-event "click"))
(def *dblclick*   (core-event "dblclick"))
(def *change*     (core-event "change"))
(def *mousedown*  (core-event "mousedown"))
(def *mouseup*    (core-event "mouseup"))
(def *mouseover*  (core-event "mouseover"))
(def *mouseout*   (core-event "mouseout"))
(def *blur*       (core-event "hl-blur"))
(def *focus*      (core-event "hl-focus"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  NOZZLES  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn onE
  [event e]
  (-> event
    (filterE (dom/filter-id (dom/id e)))
    (filterE dom/filter-not-disabled)))

(def onSubmitE      (partial onE *submit*))
(def onClickE       (partial onE *click*))
(def onDblClickE    (partial onE *dblclick*))
(def onMouseDownE   (partial onE *mousedown*))
(def onMouseUpE     (partial onE *mouseup*))
(def onMouseOverE   (partial onE *mouseover*))
(def onMouseOutE    (partial onE *mouseout*))

(defn onBlurE
  [e]
  (dom/delegate-blur! e)
  (onE *blur* e))

(defn onChangeE
  [e]
  (mapE #(dom/value! e) (onE *change* e)))

(defn onHoverE
  [e]
  (let [ins   (onMouseOverE e)
        outs  (onMouseOutE  e)]
    (caseE ins true outs false)))

(defn onActiveE
  [e]
  (let [downs (onMouseDownE e)
        ups   (mergeE (onMouseOutE e) *mouseup*)]
    (caseE downs true ups false)))

(defn domValueB
  [elem]
  (let [values-e (mapE #(dom/value! elem) (onChangeE elem))]
    (E->B (mergeE (doInitE #(dom/value! elem)) values-e))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  SPIGOTS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn dotoDom
  [f]
  (fn [e streamE]
    (doE streamE (partial f e))
    e))

(def domAttr          (dotoDom (partial apply dom/attr!)))
(def domText          (dotoDom dom/text!))
(def domNodeValue     (dotoDom dom/set-nodeValue!))
(def domRemoveAttr    (dotoDom (partial apply dom/remove-attr!)))
(def domCss           (dotoDom dom/css!))
(def domAddClass      (dotoDom dom/add-class!))
(def domRemoveClass   (dotoDom dom/remove-class!))
(def domToggle        (dotoDom dom/toggle!))
(def domSlideToggle   (dotoDom dom/slide-toggle!))
(def domFadeToggle    (dotoDom dom/fade-toggle!))
(def domValue         (dotoDom dom/value!))
(def domFocus         (dotoDom dom/focus!))
(def domSelect        (dotoDom dom/select!))

(defn domToggleClass
  ([e streamE]
   (doE streamE (partial apply dom/toggle-class! e))
   e)
  ([e css-class streamE]
   (doE streamE (partial dom/toggle-class! e css-class))
   e))




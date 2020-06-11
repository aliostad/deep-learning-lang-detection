(ns me.chans-mixin
  (:require-macros [cljs.core.async.macros :refer [go-loop go]])
  (:require [cljs.core.async :as async :refer [chan >! <!]]
            [rum.core :as rum]
            [me.utils :as u]))

;; slave
;; --------------------------------------------------------------

;; helpers

(defn notify [s m]
  ((:notify s) m))

(defn dispatch [s m]
  ((:dispatch s) m))

(defn- parse-notif [n]
  (if (fn? n)
    n
    (fn [s & xs] (into [n s] xs))))

(defn dispatcher [state {:keys [actions notifications after before]
                         :or {before identity
                              after identity}}]
  (fn [& messages]
    (before state messages)
    (doseq [[type & args] messages]
      (let [action (get actions type)
            notif (parse-notif (get notifications type type))]
        (swap! state #(apply action % args))
        (notify @state (apply notif @state args))))
    (after state messages)))

;; mixin

(defn channelled [{:keys [before after actions notifications] :as opts}]
  {:init
   (fn [s]
     (let [s (assoc s :state (atom nil))
           dispatch (dispatcher (:state s) opts)
           {:keys [in-chan out-chan]
            :or {in-chan (chan)
                 out-chan (chan)}}
           (first (:rum/args s))]

       (swap! (:state s)
              assoc
              :in-chan in-chan
              :out-chan out-chan
              :dispatch-sync dispatch
              :dispatch #(go (async/>! in-chan %&))
              :notify #(go (async/>! out-chan %)))

       (go-loop []
                (apply dispatch (async/<! in-chan))
                (recur))

       s))})

;; ------------------ next --------------------------------------------------

(defn dispatcher* [state {:keys [actions notifications after before]}]
  (fn [& messages]
    (before state messages)
    (let [new-state
          (reduce
            (fn [sval [type & args]]
              (let [action (get actions type)
                    notif (parse-notif (get notifications type type))
                    state-new-value (apply action sval args)]
                (notify state-new-value (apply notif state-new-value args))))
            (if (implements? IDeref state)
              @state
              state)
            messages)]
      (after new-state messages))))

;; mixin

(defn channelled* [opts]
  (let [opts (merge {:before identity
                     :after identity
                     :actions {}
                     :notifications {}}
                    opts)]
    {:init
     (fn [s]
       (let [{:keys [in-chan out-chan]
              :or {in-chan (chan)
                   out-chan (chan)}}
             (first (:rum/args s))

             dispatch (dispatcher* s opts)
             ]

         (assoc s
           ::channelled
           {:in-chan in-chan
            :out-chan out-chan
            :dispatch-sync dispatch
            :dispatch #(go (async/>! in-chan %&))
            :notify #(go (async/>! out-chan %))})

         (go-loop []
                  (apply dispatch (async/<! in-chan))
                  (recur))

         s))}))

(defn time-traveller
  "intended to bring undo/redo stuff to your channelled comp"
  [{:keys [save size]}]
  {:init (fn [s]
           (assoc s
             :history
             {:cmds []
              :states [(save (:state s))]}))})


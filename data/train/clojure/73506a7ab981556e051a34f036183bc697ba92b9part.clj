(ns alda.lisp.score.part
  (:require [djy.char                   :refer (char-range)]
            [clojure.set                :as    set]
            [clojure.string             :as    str]
            [alda.lisp.attributes       :refer (*initial-attr-vals*)]
            [alda.lisp.events           :refer (apply-global-attributes)]
            [alda.lisp.events.voice     :refer (end-voice-group)]
            [alda.lisp.model.event      :refer (update-score)]
            [alda.lisp.model.instrument :refer (*stock-instruments*)]
            [alda.parser                :refer (parse-input)]))

(defn- generate-id
  [name]
  (let [rand-char (fn [] (rand-nth (concat (char-range \0 \9)
                                           (char-range \a \z)
                                           (char-range \A \Z))))
        id (apply str (take 5 (repeatedly rand-char)))]
    (str name \- id)))

(defn- new-part
  "Returns a new instance of a stock instrument identified by `stock-inst`,
   with initial values for tempo, current-offset, volume, octave, etc. as
   specified in *initial-attr-vals*.

   Attribute values can be manually overridden via the rest arg `attrs`,
   e.g.: (new-part 'piano' :volume 0.75)

   Throws an error if `stock-inst` is not a valid identifier for a stock Alda
   instrument (see alda.lisp.instrument.*)."
  [stock-inst & attrs]
  (if-let [{:keys [initial-vals]} (*stock-instruments* stock-inst)]
    (merge *initial-attr-vals*
           {:id (generate-id stock-inst)}
           initial-vals
           (apply hash-map attrs))
    (throw (Exception.
             (format "Unrecognized instrument: %s" stock-inst)))))

(defn- id-matches-name
  [id name]
  (re-find (re-pattern (str \^ name \- ".{5}")) id))

(defn- look-up
  "Looks for an instrument named i.e. 'name-XXXXX' in `instruments`.

   Returns either the ID of the first instrument found or nil."
  [instruments name]
  (first (for [[id inst] instruments :when (id-matches-name id name)]
           (:id inst))))

(defn- existing-named-instances
  [{:keys [nicknames instruments] :as score} name]
  (when-let [ids (get nicknames name)]
    (for [id ids] (get instruments id))))

(defn- existing-instances-of-stock-instrument
  [{:keys [nicknames instruments] :as score} name]
  (let [named (->> nicknames
                   vals
                   (filter #(and (= (count %) 1)
                                 (id-matches-name (first %) name)))
                   (map first)
                   set)]
    (when (not (empty? named))
      (for [id named] (get instruments id)))))

(defn- existing-unnamed-instances
  [{:keys [nicknames instruments] :as score} name]
  (let [named (->> nicknames
                   vals
                   (apply concat)
                   (filter #(id-matches-name % name))
                   set)
        all   (->> instruments
                   keys
                   (filter #(id-matches-name % name))
                   set)
        ids   (set/difference all named)]
    (when (not (empty? ids))
      (for [id ids] (get instruments id)))))

(defn- determine-current-instruments
  "Given a score and an instrument call (a map with names and nickname keys),
   determines the instrument instances that will become the :current-instruments
   of the score.

   Returns the updated score. In addition to updating :current-instruments, new
   :instruments and :nicknames may be added."
  [{:keys [nicknames instruments] :as score}
   {:keys [names nickname]}]
  (let [instances
        (cond
          ; e.g. foo, foo "bar"
          (= (count names) 1)
          (let [name (first names)]
            (cond
              ; if there is a nickname, then `name` is expected to be a stock
              ; instrument, not a reference to an existing instance
              (and nickname (existing-named-instances score name))
              (throw
                (Exception.
                  (format
                    "Can't assign alias \"%s\" to existing instance \"%s\"."
                    nickname
                    name)))

              ; can't redefine an existing nickname
              (and nickname (existing-named-instances score nickname))
              (throw
                (Exception.
                  (format
                    (str "The alias \"%s\" has already been assigned to "
                         "another instrument/group.")
                    nickname)))

              ; can't use both unnamed and named instances of the same
              ; instrument
              (or (and nickname
                       (existing-unnamed-instances score name))
                  (and (not nickname)
                       (existing-instances-of-stock-instrument score name)))
              (throw
                (Exception.
                  (format
                    (str "Ambiguous instrument reference \"%s\": can't use "
                         "both unnamed and named instances of the same "
                         "instrument in a score.")
                    name)))

              ; always create a new instance if there's a nickname
              nickname
              [(new-part name)]

              :else
              (or (existing-named-instances score name)
                  (existing-unnamed-instances score name)
                  [(new-part name)])))

          ; duplicate names, e.g. piano/piano, foo/foo
          (> (count names) (count (distinct names)))
          (throw (Exception. (str "Invalid instrument grouping: "
                                  (str/join "/" names))))

          ; e.g. foo/bar, foo/bar "baz"
          (> (count names) 1)
          (let [insts (for [name names]
                        (let [named   (existing-named-instances score name)
                              unnamed (existing-unnamed-instances score name)]
                          (cond
                            named   [:named (for [inst named]
                                              (assoc inst :called name))]
                            unnamed [:stock
                                     (for [inst unnamed]
                                       (assoc inst :called name))]
                            :else   [:stock
                                     [(assoc (new-part name) :called name)]])))
                kinds (distinct (map first insts))]
            (cond
              ; can't use both named and stock instruments in a group
              (> (count kinds) 1)
              (throw
                (Exception.
                  (format
                    (str "Invalid instrument grouping \"%s\": can't use both "
                         "stock instruments and named instances in a group.")
                    (str/join "/" names))))

              ; always create new instances when creating a named group
              ; consisting of stock instruments
              (and nickname (= kinds [:stock]))
              (for [name names] (assoc (new-part name) :called name))

              :else
              (mapcat second insts))))]
    (assoc score
      :nicknames           (if nickname
                             (merge nicknames
                                    {nickname (map :id instances)}
                                    (into {}
                                      (for [[called instances]
                                            (group-by :called instances)
                                            :when called]
                                        [(str nickname \. called)
                                         (map :id instances)])))
                             nicknames)
      :instruments         (reduce (fn [insts {:keys [id] :as inst}]
                                     (assoc insts id inst))
                                   instruments
                                   instances)
      :current-instruments (set (map :id instances)))))

(defn- invalid-instrument-call-error!
  [x]
  (throw (Exception. (str "Invalid instrument call: " (pr-str x)))))

(defn- parse-instrument-call
  [s]
  (let [events (-> s
                   (str/replace #":$" "")
                   (str/replace #"'" "\"")
                   (str \:)
                   (parse-input :output :events))
        part   (first events)
        call   (:instrument-call part)]
    (if (and (= 1 (count events)) call)
      call
      (invalid-instrument-call-error! s))))

(defmethod update-score :part
  [score {:keys [instrument-call events] :as part}]
  (let [instrument-call (cond
                          (map? instrument-call)
                          instrument-call

                          (string? instrument-call)
                          (parse-instrument-call instrument-call)

                          :else
                          (invalid-instrument-call-error! instrument-call))
        score (-> score
                  end-voice-group
                  (determine-current-instruments instrument-call))]
    (reduce update-score
            score
            (cons (apply-global-attributes) events))))


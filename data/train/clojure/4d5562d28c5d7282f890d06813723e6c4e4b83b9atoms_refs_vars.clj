(ns brave-and-true.ch10.atoms-refs-vars)

;;atoms refs and vars

;;Atoms -- manage the state of individual identities

;;create new atom and bind it to the name fred
(def fred (atom {:cuddle-hunger-level  0
                 :percent-deteriorated 0}))
;;get the current state of fred
;;unlike futures delays and promises, deref on an atom
;;never blocks because it doesn't have to
;;give me the current value that fred is pointing to
@fred

;;swap! -- update an atom
(swap! fred
       (fn [current-state]
         (merge-with + current-state {:cuddle-hunger-level 1})))

;;swap! only takes 1 arg, current-state, but we can also pass it a function that takes
;;multiple args.
(defn increase-cuddle-hunger-level
  [zombie-state increase-by]
  (merge-with + zombie-state {:cuddle-hunger-level increase-by})
  )

(increase-cuddle-hunger-level @fred 4)

@fred
;;notice that this doesn't update fred, but now we can call swap!

(swap! fred increase-cuddle-hunger-level 10)

@fred
;;fred is changed

;;that was cool, but clojure has a way to do this
;;update-in -- takes 3 args a collection, a vector to id what to change, and an update fn
(update-in {:a {:b 3}} [:a :b] inc)

(swap! fred update-in [:cuddle-hunger-level] + 10)

;;atoms will let you look at previous state
(let [num (atom 1)
      s1 @num]
  (swap! num inc)
  (println "State 1:" s1)
  (println "Current state:" @num))

;;atoms are thread-safe and implement CAS semantics.
;;sometimes you want to update an atom without checking its current value, though
;;reset!
(reset! fred {:cuddle-hunger-level  0
              :percent-deteriorated 0})

;;watches and validators
;;watch -- a function that takes four arguments: a key, the reference being watched,
;;its previous state, and its new state.
;; You can register any number of watches with a reference type.
(defn shuffle-speed
  [zombie]
  (* (:cuddle-hunger-level zombie)
     (- 100 (:percent-deteriorated zombie))))

(defn shuffle-alert
  [key watched old-state new-state]
  (let [sph (shuffle-speed new-state)]
    (if (> sph 5000)
      (do
        (println "Run, you fool!")
        (println "The zombie's SPH is now " sph)
        (println "This message brought to your courtesy of " key))
      (do
        (println "All's well with " key)
        (println "Cuddle hunger: " (:cuddle-hunger-level new-state))
        (println "Percent deteriorated: " (:percent-deteriorated new-state))
        (println "SPH: " sph)))))

(reset! fred {:cuddle-hunger-level  22
              :percent-deteriorated 2})
(add-watch fred :fred-shuffle-alert shuffle-alert)
(swap! fred update-in [:percent-deteriorated] + 1)

(swap! fred update-in [:cuddle-hunger-level] + 30)

;;validators -- allow you to specify valid allowable states for a reference
(defn percent-deteriorated-validator
  [{:keys [percent-deteriorated]}]
  (and (>= percent-deteriorated 0)
       (<= percent-deteriorated 100)))

(def bobby
  (atom
    {:cuddle-hunger-level 0 :percent-deteriorated 0}
    :validator percent-deteriorated-validator))

;(swap! bobby update-in [:percent-deteriorated] + 200)
;;=> java.lang.IllegalStateException: Invalid reference state

(swap! bobby update-in [:percent-deteriorated] + 50)
;;=>{:cuddle-hunger-level 0, :percent-deteriorated 50}

;;Refs -- manage the state of multiple identities using transaction semantics
;;they are atomic, consistant, and isolated

(def sock-varieties
  #{"darned" "argyle" "wool" "horsehair" "mulleted"
    "passive-aggressive" "striped" "polka-dotted"
    "athletic" "business" "power" "invisible" "gollumed"})

(defn sock-count
  [sock-variety count]
  {:variety sock-variety
   :count   count})

(defn generate-sock-gnome
  "Create an initial sock gnome state with no socks"
  [name]
  {:name  name
   :socks #{}})

(def sock-gnome (ref (generate-sock-gnome "Barumpharumph")))
(def dryer (ref {:name  "LG 1337"
                 :socks (set (map #(sock-count % 2) sock-varieties))}))

(:socks @dryer)

(defn steal-sock
  [gnome dryer]
  (dosync
    (when-let [pair (some #(if (= (:count %) 2) %) (:socks @dryer))]
      (let [updated-count (sock-count (:variety pair) 1)]
        (alter gnome update-in [:socks] conj updated-count)
        (alter dryer update-in [:socks] disj pair)
        (alter dryer update-in [:socks] conj updated-count)))))
(steal-sock sock-gnome dryer)

(:socks @sock-gnome)

(defn similar-socks
  [target-sock sock-set]
  (filter #(= (:variety %) (:variety target-sock)) sock-set))

(similar-socks (first (:socks @sock-gnome)) (:socks @dryer))

(def counter (ref 0))
(future
  (dosync
    (alter counter inc)
    (println @counter)
    (Thread/sleep 500)
    (alter counter inc)
    (println @counter)))
(Thread/sleep 250)
(println @counter)

;;commute -- like alter but without retry. only use when we're certain a ref can not end
;;up in an invalid state

(defn sleep-print-update
  [sleep-time thread-name update-fn]
  (fn [state]
    (Thread/sleep sleep-time)
    (println (str thread-name ": " state))
    (update-fn state)))
(def counter (ref 0))
(future (dosync (commute counter (sleep-print-update 100 "Thread A" inc))))
(future (dosync (commute counter (sleep-print-update 150 "Thread B" inc))))

;;Vars -- associations between symbols and objects. No used to manage state, but they
;;do have some concurrency goodness hiding inside

;;dynamic binding
;;create a global name that should refer to different values in different contexts

(def ^:dynamic *notification-address* "dobby@elf.org")
;; ^:dynamic tells clojure that the var is dynamic and the name is enclosed by earmuffs
;; you can temporarily change the value by using binding
(binding [*notification-address* "test@elf.org"]
  *notification-address*)

;;you can also stack them
(binding [*notification-address* "tester-1@elf.org"]
  (println *notification-address*)
  (binding [*notification-address* "tester-2@elf.org"]
    (println *notification-address*))
  (println *notification-address*))

;;Dynamic vars are most often used to name a resource that one or more functions target.
;;*out*, for example, represents the standard output for print operations.
;; In your program, you could re-bind *out* so that print statements write to a file

(comment
  (binding [*out* (clojure.java.io/writer "print-output")]
           (println "A man who carries a cat by the tail learns
something he can learn in no other way.
-- Mark Twain"))
         (slurp "print-output"))

;;you can also use them for configuration. the built-in var *print-length*
;; allows you to specify how many items in a collection Clojure should print:
(println ["Print" "all" "the" "things!"])
(binding [*print-length* 1]
  (println ["Print" "just" "one!"]))

;;it’s possible to set! dynamic vars that have been bound.
;;set! allows you convey information out of a function without having to return it as an argument
(def ^:dynamic *troll-thought* nil)
(defn troll-riddle
  [your-answer]
  (let [number "man meat"]
    (when (thread-bound? #'*troll-thought*)
      (set! *troll-thought* number))
    (if (= number your-answer)
      "TROLL: You can cross the bridge!"
      "TROLL: Time to eat you, succulent human!")))

(binding [*troll-thought* nil]
  (println (troll-riddle 2))
  (println "SUCCULENT HUMAN: Oooooh! The answer was" *troll-thought*))

;;You use the thread-bound? function at to check that the var has been bound, and if it has,
;;you set! *troll-thought* to the troll’s thought at. Notice thread-bound? takes the var itself as
;;an arg, not the value it refers to

;;alter-var-root alters the root (inital var value)
(def power-source "hair")
(alter-var-root #'power-source (fn [_] "7 eleven parking lot"))
power-source

;;with-redefs -- temporarily alter the var root. probably only use with testing (i.e redefine data from
;;a network call

;;pmap -- stateless concurrency (parallel map)
(def alphabet-length 26)
;; Vector of chars, A-Z
(def letters (mapv (comp str char (partial + 65)) (range alphabet-length)))

(defn random-string
  "Returns a random string of specified length"
  [length]
  (apply str (take length (repeatedly #(rand-nth letters)))))

(defn random-string-list
  [list-length string-length]
  (doall (take list-length (repeatedly (partial random-string string-length)))))

(def orc-names (random-string-list 3000 7000))

(time (dorun (map clojure.string/lower-case orc-names)))
;;"Elapsed time: 212.206294 msecs"
(time (dorun (pmap clojure.string/lower-case orc-names)))
;;"Elapsed time: 73.472337 msecs"

(def orc-name-abbrevs (random-string-list 20000 300))
(time (dorun (map clojure.string/lower-case orc-name-abbrevs)))
; => "Elapsed time: 78.23 msecs"
(time (dorun (pmap clojure.string/lower-case orc-name-abbrevs)))
; => "Elapsed time: 124.727 msecs"

;;here the overhead of creating/coordinating the threads for pmap made it take longer
;;a solution could be to increase the amount of work done by each thread in pmap

(time
  (dorun
    (apply concat
           (pmap (fn [name] (doall (map clojure.string/lower-case name)))
                 (partition-all 1000 orc-name-abbrevs)))))
;;"Elapsed time: 41.34423 msecs"

;;now we can define a partitioning pmap that just takes 1 collection
(defn ppmap
  "Partitioned pmap, for grouping map ops together to make parallel
  overhead worthwhile"
  [grain-size f & colls]
  (apply concat
         (apply pmap
                (fn [& pgroups] (doall (apply map f pgroups)))
                (map (partial partition-all grain-size) colls))))
(time (dorun (ppmap 1000 clojure.string/lower-case orc-name-abbrevs)))


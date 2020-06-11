(ns imogen.genetic
  "The basics of a genetic algorithm.")

;; Let's start setting up some of the genetic stuff.

(defprotocol Evolving
  "A set of methods a creature will have to respond to to evolve. Most
methods return either `this` or a new instance."
  (make-new [this]
    "Return an empty/default copy")
  (mutate [this]
    "Mutates a creature. This is where you'd add Spidey powers.")
  (cross-breed [this other]
    "Combine two creatures' genes to create offspring"))

(defprotocol Fitness
  "A pair of methods to calculate and retrieve a creature's fitness."
  (calculate-fitness [this environment]
    "Calculate the creature's fitness (based on environment), and
    store it in e.g. the key :fitness, then return the creature.")
  (get-fitness [this]
    "Fetch the fitness"))

;; A few helpers, based on an assumption that genes will be a sequence
;; of floats between 0 and 1.

(defn alter-rand
  "Use `f` to alter the value at a random index, replacing with 0, 1,
   or many values."
  [xs f]
  (let [n (rand-int (count xs))
        [hs ts] (split-at n xs)]
    (concat hs (f (first ts)) (rest ts))))

(defn drop-rand
  "Drop the value at a random index."
  [xs]
  (alter-rand xs (fn [_] nil)))

(defn insert-rand
  "Insert a new value into the sequence."
  [xs]
  (alter-rand xs (fn [x] (if (nil? x) [(rand)] [(rand) x]))))

(defn append-rand
  "Append a new value to the end."
  [xs]
  (concat xs [(rand)]))

(defn change-rand
  "Swaps the value at a random index for a new rand."
  [xs]
  (alter-rand xs (fn [x] [(rand)])))

(def mutators
  "Default set of mutation operations."
  [drop-rand insert-rand append-rand change-rand])

;; `Creature` provides some reasonable default behaviours for some of
;; the `Evolving` methods. `Fitness` will be specific to your application.
(defrecord Creature
    [^int age ^int generation genes]

  Evolving
  
  (make-new [this]
    (assoc this
      :age 0
      :generation (inc (:generation this))
      :genes ()))
  
  (mutate [this]
    (update-in this [:genes] (rand-nth mutators)))
  
  (cross-breed [this other]
    (let [args [this other]
          genes (apply map #(rand-nth %&) (map :genes args))]
      (assoc (Creature. 0 0 ())
        :genes genes
        :generation (inc (apply max (map :generation args)))))))

;; Now we'll start on some population-level stuff; functions that
;; manage a group of creatures.

(defrecord Population
    [env size members generation])

(defn population
  "Create a population. `ctor` tells us how to create the first
  generation, `env` is the environment that the population will be
  judged fit by, and `size` is how many in each generation."
  [ctor env size]
  (Population. env size (take size (repeatedly ctor)) 0))

(defn cull
 "Kill off all but a certain number of the population. Defaults to keeping 1/3."
 ([pop]
    (cull pop (int (/ (:size pop) 3))))
 ([pop keepn]
    (let [max-age (:max-age (:env pop))
          members (if max-age (filter #(<= (:age %) max-age) (:members pop))
                      (:members pop))]
      (assoc pop :members (take keepn members)))))

(defn regenerate
  "Rebuild a (probably just-culled) population up to size by
  cross-breeding the remaining members. Currently the alpha (most fit)
  gets all the glory."
  [{:keys [size env members] :as pop}]
  (->>
   (concat (map #(update-in % [:age] inc) members)
           (take (- size (count members))
                 (repeatedly
                  #(mutate
                    (cross-breed (first members)
                                 (first (shuffle (rest members))))))))
   (pmap #(calculate-fitness % env))
   (sort-by get-fitness)
   (assoc (update-in pop [:generation] inc) :members)))

(defn iterate-population
  "Run a single evaluate/cull/regenerate cycle"
  [{:keys [env members] :as pop} hook-func]
  (let [new-pop (-> pop
                    cull
                    regenerate)]
    (hook-func new-pop)
    new-pop))

(defn run-population
  "generate a lazy sequence of successive generations, calling hook-func for each."
  [start-pop hook-func]
  (iterate #(iterate-population % hook-func) start-pop))

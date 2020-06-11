(ns gemini.core)

(defn inversion?
  [c1 n1 c2 n2]
  (and (= c1 n2) (= n1 c2)))

(defn deletion?
  [c1 c2 n1]
  (and (not= c1 c2) (= n1 c2)))

(defn insertion?
  [c1 c2 n2]
  (and (not= c1 c2) (= c1 n2)))

(defn search-error
  [s1 s2]
  (let [c1 (first (seq s1))
        c2 (first (seq s2))]

    (cond
     (and (nil? c1) (nil? c2)) nil
     (= c1 c2) {:type :equal :s1 (rest s1) :s2 (rest s2)}
     (nil? c1) {:type :delete :char c2 :s1 nil :s2 (rest s2)}
     (nil? c2) {:type :insert :char c1 :s1 (rest s1) :s2 nil}
     (inversion? c1 (second s1) c2 (second s2)) {:type :inv :char [c1 (second s1)] :s1 (drop 2 s1) :s2 (drop 2 s2)}
     (deletion? c1 c2 (second s1)) {:type :delete :char c1 :s1 (drop 2 s1) :s2 (rest s2)}
     (insertion? c1 c2 (second s2)) {:type :insert :char c2 :s1 (rest s1) :s2 (drop 2 s2)}
     (not= c1 c2) {:type :sub :char [c1 c2] :s1 (rest s1) :s2 (rest s2)}
     :else {:type :unknown :s1 (rest s1) :s2 (rest s2)})))

(defn dbg-compare-word
  "Debug function displays the comparison between 2 words."
  [w1 w2]
  (loop [s1 (seq w1) s2 (seq w2)]
    (if-not (and (nil? (seq s1)) (nil? (seq s2)))
      (let [diff (search-error s1 s2)]
        (println "s1:" s1 "s2:" s2 "diff:" diff)
        (recur (:s1 diff) (:s2 diff))))))


(defn compare-word
  "Returns the common characters and errors between 2 words. The result is inside a lazy sequence."
  [w1  w2]
  (lazy-seq
   (let [s1 (seq w1) s2 (seq w2)]
     (if (or s1 s2)
       (let [curr (search-error s1 s2)]
         (cons {:type (:type curr) :char (:char curr)}  (compare-word (:s1 curr) (:s2 curr))))))))

(defn find-errors
  "Returns in a lazy sequence only the mistakes found between 2 words."
  [w1 w2]
  (filter #(not= (:type %) :equal) (compare-word w1 w2)))

(defn candidates?
  "Says if 2 words are candidates to be the same. The limit argument is the number of mistakes
   from which 2 words cannot be considerated as the same."
  [w1 w2 limit]
  (< (count (take limit (find-errors w1 w2))) limit))

(defn matching-env
  "Returns a new matching environment. the n argument is optional and is the default max errors
   when matching 2 words.
   Note: The environment max-errors is overriden by the max-errors defined in rules."
  [& [n]]
  (let [e {:rules []}]
    (if n
      (assoc e :max-errors n)
      e)))

(defn validate-positive-value
  "Checks if a value is greater than 0. If not then an exception is thrown.
   The name argument is the attribute name as it will be in the exception message."
  [name val]
  (when-not (nil? val)
    (when-not (or (number? val) (< val 1)) 
      (throw (Exception. (str "The " name " attribute must be a positive number"))))))

(defn manage-max-errors
  [e r]
  (if (nil? (:max-errors r))
    (assoc r :max-errors (:max-errors e))
    r))

(defn manage-all-authorized
  [r]
  (if-let [all (get-in r [:authorized :all])]
    (assoc r :authorized {:inv all :sub all :insert all :delete all})
    r))

(defn rule
  "Adds a new rule to the matching environment. The first arg is the environment to update.
   The following arguments define the new rule. The syntax of these arguments is like a map
   where the key is an attribute name.
   The known attributes are:
     :length The rule is applied for the words with this length.
     :max-length The rule is applied for the words with length is at more the given length.
     :min-length The rule is applied for the words with length is at least the given length.
     :authorized A map gives the max errors of each type.
     :forbidden A vector with the error types are not authorized.
     :max-errors The max number of errors authorized for this rule (overrides the ME default value)."
  [env & {:keys [length max-length min-length authorized max-errors forbidden] :as rule}]

   (when-not (or (nil? length) (nil? max-length))
     (throw (Exception. "You can't define a length and a max-length attributes.")))

   (when-not (or (nil? length) (nil? min-length))
     (throw (Exception. "You can't define a length and a min-length attributes.")))

   (validate-positive-value "max-length" max-length)
   (validate-positive-value "min-length" min-length)
   (validate-positive-value "length" length)
   (validate-positive-value "max-errors" max-errors)

  (when-not (or (nil? authorized) (map? authorized))
    (throw (Exception. "The value of the authorized attribute must be a map.")))

  (when-not (or (nil? forbidden) (vector? forbidden))
    (throw (Exception. "The value of the authorized attribute must be a vector.")))

  (let [current-rules (:rules env)
        rule-to-add (-> (manage-max-errors env rule)
                        (manage-all-authorized))]
    
    (when-not (:max-errors rule-to-add)
    (throw (Exception. "You must define the max-errors attribute (either in the matching environment or the rule declaration).")))


    (assoc env :rules (conj current-rules (into {} (filter #(not (nil? (val %))) rule-to-add))))))

(defn pass-max-errors
  [r c]
  (if-let [m (:max-errors r)] 
    (<= (:errors c) m)
    true))

(defn pass-authorized
  [r c]
  (if-let [es (:authorized r)]
    (reduce (fn [status type]
              (when status
                (<= (get c type) (get es type)))) true (keys es))
    true))

(defn pass-forbidden
  [r c]
  (if-let [es (:forbidden r)]
    (reduce (fn [status type]
              (when status
                (= 0 (get c type)))) true es)
    true))

(defn continue-ruling?
  [r c]
  (every? (fn [f] (f r c)) [pass-max-errors pass-authorized pass-forbidden]))

(defn inc-error-counter
  [c k]
  (assoc c k (inc (get c k))))

(defn update-errors-counters
  [c e]
  (-> (inc-error-counter c :errors)
      (inc-error-counter (:type e))
      (assoc :accepted false)))


;; Question: is the inner function is put ouside the loop?
(defn accepted-rule
  [rs w1 w2]
  (some (fn [r]
          (let [max-l (:max-length r)
                min-l (:min-length r)
                l (:length r)]
            (if (and (nil? max-l) (nil? min-l) (nil? l))
              r
              (let [w1-l (count w1) w2-l (count w2)]
                (if (and (= l w1-l) (= l w2-l))
                  r
                  (when (or max-l min-l)
                    (let [max-gap (if max-l max-l 0)
                          min-gap (if min-l min-l 0)]
                      (when (and (<= w1-l max-gap) (>= w1-l min-gap) (<= w2-l max-gap) (>= w2-l min-gap))
                        r)))))))) rs))

(defn ruled-candidates-fn
  "Returns the matching function that 'ate' the rules from an environment.
   The returned function takes 2 arguments: the 2 words to compare each other."
  [env]
  (fn [w1 w2]
    (let [counters (atom {:errors 0 :inv 0 :delete 0 :sub 0 :insert 0 :accepted false})
          rule (accepted-rule (:rules env) w1 w2)]
      
      (doseq [e (find-errors w1 w2)
              :while (continue-ruling? rule (swap! counters update-errors-counters e))]
        (swap! counters #(assoc % :accepted true)))

      (or (= 0 (:errors @counters)) (:accepted @counters)))))

(defmacro def-matching-env
  "A macro that returns a ruled candidates function based upon the default max errors count and
   the rules to apply while the matching.
   NOTE: The macro adds the default rule. This rule is the last one and has only one attribute: the max-errors.
         This attribute is defined by the environment default max-errors value."
  [max-errors & rules]
  `(-> (matching-env ~max-errors)
       ~@rules
       (rule)
       (ruled-candidates-fn)))

(defn fuzzy-filter-fn
  "Returns a function that filters collection by using a matching function.
   The first argument of the fuzzy-filter-fn is the matching function returned by the def-matching-env macro.
   The fns arguments are (in the order): the cleansing function for the input data and the next one is to clean the collection items.
   If you clean only the collection item, you pass identity function as the input data cleansing function.

   The cleansing functions must take one argument: the data to clean.

   The returned function take 2 args: the collection and the input data."
  [matching-fn & fns]
  (let [define-cleansing (fn [fn] (if fn fn identity))
        input-cleansing (define-cleansing (first fns))
        coll-cleansing (define-cleansing (second fns))]
    
    (fn [coll s]
      (let [clean-s (input-cleansing s)]
        (filter #(matching-fn clean-s (coll-cleansing %)) coll)))))

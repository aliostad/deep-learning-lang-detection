(ns ninjudd.division
  (:refer-clojure :exclude [char?]))

(defn token [pred]
  (fn [stream]
    (let [val (first stream)]
      (when (pred val)
        [val [val] (rest stream)]))))

(defn one [val]
  (token #(= val %)))

(def either some-fn)

(defn end []
  (fn [stream]
    (when (empty? stream)
      [nil [] stream])))

(defn- char? [char]
  #+clj  (clojure.core/char? char)
  #+cljs (and (string? char)
              (= 1 (count char))))

(defn- char-code [char]
  #+clj  (int char)
  #+cljs (.charCodeAt char 0))

(defn char-range [from to]
  (token (fn [ch]
           (and (char? ch)
                (apply <= (map char-code [from ch to]))))))

(defn lowercase-letter []
  (char-range \a \z))

(defn uppercase-letter []
  (char-range \A \Z))

(defn digit []
  (char-range \0 \9))

(defn letter []
  (either (lowercase-letter)
          (uppercase-letter)))

(defn whitespace-char []
  (token #{\space \tab \newline}))

(defn word-char []
  (either (letter)
          (digit)
          (one \_)))

(defn symbol-char []
  (either (word-char)
          (one \-)))

(defn maybe [parse]
  (fn [stream]
    (or (parse stream)
        [nil [] stream])))

(defn is-not [parse]
  (fn [stream]
    (when (and (seq stream)
               (not (parse stream)))
      (let [val (first stream)]
        [val [val] (rest stream)]))))

(defn all [& parsers]
  (fn [stream]
    (reduce (fn [[result consumed stream] parse]
              (if-let [[val c stream] (parse stream)]
                [(conj result val) (into consumed c) stream]
                (reduced nil)))
            [[] [] stream]
            parsers)))

(defn verify [parse pred]
  (fn [stream]
    (when-let [[val consumed stream] (parse stream)]
      (when (pred val)
        [val consumed stream]))))

(defn exclude-trailing
  "After parsing, apply rparse to the consumed stream in reverse, removing anything that matches
  and then reparsing."
  [parse rparse]
  (fn [stream]
    (when-let [[val consumed stream] (parse stream)]
      (if-let [[_ rtail rhead] (rparse (reverse consumed))]
        (when-let [[val consumed head] (parse (reverse rhead))]
          [val consumed (concat head (reverse rtail) stream)])
        [val consumed stream]))))

(defn followed-by [parse pred]
  (fn [stream]
    (when-let [[val consumed stream] (parse stream)]
      (when (pred stream)
        [val consumed stream]))))

(defn siphon []
  (fn [stream]
    [stream stream nil]))

(defn transform [parse f & args]
  (fn [stream]
    (when-let [[val consumed stream] (parse stream)]
      [(apply f val args) consumed stream])))

(defn with-consumed [parse]
  (fn [stream]
    (when-let [[val consumed stream] (parse stream)]
      [[val consumed] consumed stream])))

(defn ignore [parse]
  (transform parse (constantly nil)))

(defn str* [parse]
  (transform parse (partial apply str)))

(defn- to-int [string]
  #+clj  (Integer. string)
  #+cljs (js/parseInt string))

(defn int* [parse]
  (transform (str* parse) to-int))

(defn concat* [parse]
  (transform parse (partial apply concat)))

(defn string [s]
  (str* (apply all (map one s))))

(defn >>
  "Run all the given parsers, ignoring all but the last value."
  [& parsers]
  (transform (apply all parsers) peek))

(defn <<
  "Run all the given parsers, ignoring all but the first value."
  [& parsers]
  (transform (apply all parsers) first))

(defn ><
  "Run the three given parsers, ignoring all but the middle value."
  [left middle right]
  (transform (all left middle right) second))

(defn prefix [& parsers]
  (transform (apply all parsers)
             (fn [vals]
               (into (pop vals) (peek vals)))))

(defn many
  ([parse min max]
     (fn [stream]
       (loop [result []
              consumed []
              stream stream]
         (if-let [[val c stream] (when (or (nil? max)
                                           (< (count result) max))
                                   (parse stream))]
           (recur (conj result val) (into consumed c) stream)
           (when (or (nil? min)
                     (<= min (count result)))
             [result consumed stream])))))
  ([parse min]
     (many parse min nil))
  ([parse]
     (many parse nil nil)))

(defn repeated [parse n]
  (many parse n n))

(defn whitespace []
  (many (whitespace-char)))

(defn until-whitespace []
  (many (is-not (whitespace-char))))

(defn trim-whitespace [parse]
  (>< (whitespace) parse (whitespace)))

(defn scan
  "Scan stream until you can successfully parse a val, returning a vector of two or less items.
  The first item will be a skipped sequence, if anything was skipped. The second will be the
  sucessfully parsed val, if there is one."
  [parse & [skip?]]
  (let [skip? (or skip? (constantly false))]
    (fn [stream]
      (loop [head []
             stream stream]
        (if (seq stream)
          (if-let [[val c stream] (and (not (skip? (peek head)))
                                       (parse stream))]
            [(if (seq head)
               [head val]
               [nil val])
             (into head c) stream]
            (recur (conj head (first stream))
                   (rest stream)))
          (when (seq head)
            [[head] head stream]))))))

(defn scan-all
  "Scan an entire stream, returning a list of alternating skipped sequences and parsed values."
  [parse & [pred?]]
  (concat* (many (scan parse pred?))))

(defn parse
  "Return a function that runs the given parser, trims all whitespace and returns the result.
  Expects the entire input to be consumed by the parser."
  [parser]
  (comp first (<< (trim-whitespace (parser))
                  (end))))

(defn ??
  "Print debugging info after running the given parser."
  [parse]
  (fn [stream]
    (let [result (parse stream)]
      (prn 'parsing stream '=> result)
      result)))

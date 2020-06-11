(ns utilities.parse
    (:use
        clojure.set
        utilities.core
    )
    (:import 
        utilities.parse.InvalidSyntaxException
    )
)

(defn default-ISE [msg]
    (InvalidSyntaxException. msg)
)

(defn str->stream [str]
    (lazy-seq
        (if (empty? str)
            [[:eof {:gen-ISE default-ISE}]]
            (let [[x & xs] str]
                (cons [x {:gen-ISE default-ISE}]
                    (str->stream xs)
                )
            )
        )
    )
)

(defn reader->stream! [^java.io.Reader rdr]
    (lazy-seq
        (let [ch (.read rdr)]
            (if (< ch 0)
                [[:eof {:gen-ISE default-ISE}]]
                (let [ch (char ch)]
                    (cons [ch {:gen-ISE default-ISE}] 
                        (reader->stream! rdr)
                    )
                )
            )
        )
    )
)

(defn positional-ISE [line column msg]
    (let [msg (format "%s at %d:%d" msg line column)]
        (InvalidSyntaxException. msg)
    )
)

(defn- positional-stream' [s line column]
    (lazy-seq
        (when-not (empty? s)
            (let [[[ch add :as x] & xs] s
                this [ch (assoc add :gen-ISE (partial positional-ISE line column))]
                ]
                (case ch
                    :eof [x]
                    \newline (cons this
                        (positional-stream' xs (inc line) 1)
                    )
                    (cons this
                        (positional-stream' xs line (inc column))
                    )
                )
            )
        )
    )
)

(defn positional-stream [stream]
    (positional-stream' stream 1 1)
)

(defn gen-ISE [stream msg]
{
    :pre [(not (empty? stream))]
}
    (let [[[_ addition]] stream]
        (throw ((:gen-ISE addition) msg))
    )
)

(defn- char-parser [pred format-eof format-char stream]
{
    :pre [(not (empty? stream))]
}
    (let [[[x] & xs] stream]
        (cond
            (pred x) [xs x]
            (not= x :eof) (gen-ISE stream (format-char x))
            :else (gen-ISE stream (format-eof))
        )
    )
)

(defn expect-char-if [pred]
    (partial char-parser pred
        #(format "unexpected eof")
        #(format "unexpected '%c'" %)
    )
)

(defn expect-char [ch]
    (partial char-parser #(= ch %)
        #(format "expect '%c'" ch)
        #(format "expect '%c' but '%c'" ch %)
    )
)

(defn expect-any-char []
    (expect-char-if (fn [ch] (not= ch :eof)))
)

(defn- expect-eof-parser [stream]
{
    :pre [(not (empty? stream))]
}
    (let [[[x] & _] stream]
        (if (= x :eof)
            [stream :eof]
            (throw (gen-ISE stream "expect eof but not"))
        )
    )
)

(defn expect-eof []
    (partial expect-eof-parser)
)

(defn- string-parser' [str stream]
{
    :pre [(not (empty? stream))]
}
    (if (empty? str)
        stream
        (let [
            [x & xs] str
            [strm] ((expect-char x) stream)
            ]
            (recur xs strm)
        )
    )
)

(defn- string-parser [str stream]
{
    :pre [(not (empty? stream))]
}
    (try
        [(string-parser' str stream) str]
    (catch InvalidSyntaxException ex
        (throw (gen-ISE stream (format "expect \"%s\"" str)))
    ))
)

(defn expect-string [str]
    (partial string-parser str)
)

(defn- skip-while-parser' [pred stream]
    (let [[[ch] & nxt-strm] stream]
        (if (pred ch)
            (recur pred nxt-strm)
            [stream nil]
        )
    )
)

(defn- skip-while-parser [pred stream]
    (skip-while-parser' pred stream)
)

(defn skip-while [pred]
    (partial skip-while-parser pred)
)

(defn- choice-parser' [p stream]
    (try
        (let [[strm res] (p stream)]
            [nil strm res]
        )
    (catch InvalidSyntaxException ex
        [ex nil nil]
    ))
)

(defn- choice-parser [last-ise parsers stream]
    (if (empty? parsers)
        (throw last-ise)
        (let [[p & ps] parsers
                [ise strm res] (choice-parser' p stream)
            ]
            (if ise
                (recur ise ps stream)
                [strm res]
            )
        )
    )
)

(defn choice [& parsers]
{
    :pre [(not (empty? parsers))]
}
    (partial choice-parser nil parsers)
)

(defn- choice*-parser [last-ise args stream]
    (cond
        (empty? args) (throw last-ise)
        (= 1 (count args)) [stream (first args)]
        :else (let [
            [res-fn parser & rest-args] args
            [ise strm res] (choice-parser' parser stream)
            ]
            (if ise
                (recur ise rest-args stream)
                [strm (res-fn res)]
            )
        )
    )
)

(defn choice* [& args]
{
    :pre [(not (empty? args))]
}
    (partial choice*-parser nil args)
)

(defn- optional-parser [parser stream]
    (try
        (parser stream)
    (catch InvalidSyntaxException _
        [stream nil]
    ))
)

(defn optional [parser]
    (partial optional-parser parser)
)

(defn- many' [parser stream parsed]
    (try
        (let [[strm prsd] (parser stream)]
            (conj! parsed prsd)
            [true strm]
        )
    (catch InvalidSyntaxException _
        [false nil]
    ))
)

(defn- many-parser [parser stream]
    (let [parsed (transient [])]
        (loop [stream stream]
            (let [[continue strm] (many' parser stream parsed)]
                (if continue
                    (recur strm)
                    [stream (persistent! parsed)]
                )
            )
        )
    )
)

(defn many [parser]
    (partial many-parser parser)
)

(defn- many1-parser [parser stream]
    (let [[strm1 prsd1] (parser stream)
            [strm2 prsd2] ((many parser) strm1)
        ]
        [strm2 (cons prsd1 prsd2)]
    )
)

(defn many1 [parser]
    (partial many1-parser parser)
)

(defn- chain-parser [parsers stream]
    (if (empty? parsers)
        [stream []]
        (let [[p & ps] parsers
                [strm1 prsd1] (p stream)
                [strm2 prsd2] (chain-parser ps strm1)
            ]
            [strm2 (cons prsd1 prsd2)]
        )
    )
)

(defn chain [& parsers]
    (partial chain-parser parsers)
)

(defn- between-parser' [middle-prsd right-parser middle-parser stream]
    (let [[strm right-prsd] ((optional right-parser) stream)]
        (if right-prsd
            [strm right-prsd]
            (let [[strm2 mid-prsd] (middle-parser stream)]
                (conj! middle-prsd mid-prsd)
                (recur middle-prsd right-parser middle-parser strm2)
            )
        )
    )
)

(defn- between-parser [left-parser right-parser middle-parser stream]
    (let [[strm1 prsd1] (left-parser stream)
            middle-prsd (transient [])
            [strm2 right-prsd] 
                (between-parser' middle-prsd right-parser middle-parser strm1)
        ]
        [strm2 [prsd1 right-prsd (persistent! middle-prsd)]]
    )
)

(defn between [left-parser right-parser middle-parser]
    (partial between-parser left-parser right-parser middle-parser)
)

(defn foresee-parser [parser stream]
    (let [[_ prsd] (parser stream)]
        [stream prsd]
    )
)

(defn foresee [parser]
    (partial foresee-parser parser)
)


(def digit #{\0 \1 \2 \3 \4 \5 \6 \7 \8 \9})

(def hexdigit (union #{\a \b \c \d \e \f \A \B \C \D \E \F} digit))

(def letter 
    (set 
        (for [x (range 128)
                :let [ch (char x)]
                :let [gta (>= (Character/compare ch \a) 0)] 
                :let [ltz (<= (Character/compare ch \z) 0)]
                :let [gtA (>= (Character/compare ch \A) 0)]
                :let [ltZ (<= (Character/compare ch \Z) 0)]
                :when (or
                    (and gta ltz)
                    (and gtA ltZ)
                )
            ]
            ch
        )
    )
)

(def whitespace #{\space \tab \formfeed \newline})

(defn- extract-string-between! [sb end-stream start-stream]
    (if (= start-stream end-stream)
        (str sb)
        (let [[[ch] & rest-stream] start-stream]
            (throw-if (= ch :eof)
                IllegalArgumentException.
                "stream ends before it hits end position"
            )
            (.append sb ch)
            (recur sb end-stream rest-stream)
        )
    )
)

(defn extract-string-between [start-stream end-stream]
    (let [sb (StringBuilder.)]
        (extract-string-between! sb end-stream start-stream)
    )
)

(defn left-recursive-parser [real-parser stream]
    (let [[[ch opts] & xs] stream]
        (if-let [lr (:left-recursive opts)]
            (if (contains? lr real-parser)
                (gen-ISE stream "recursion")
                (let [new-opts (assoc opts :left-recursive (conj lr real-parser))]
                    (real-parser (cons [ch new-opts] xs))
                )
            )
            (let [new-opts (assoc opts :left-recursive #{real-parser})]
                (real-parser (cons [ch new-opts] xs))
            )
        )
    )
)

(defn left-recursive [parser]
    (partial left-recursive-parser parser)
)

(defn- separated-list-parser [element-parser separator-parser stream]
    (let [
        [strm prsd] (->> stream
            ((chain
                element-parser
                (many
                    (chain
                        separator-parser
                        element-parser
                    )
                )
            ))
        )
        prsd (cons
            (first prsd)
            (for [[_ x] (second prsd)] x)
        )
        ]
        [strm prsd]
    )
)

(defn separated-list [element-parser separator-parser]
    (partial separated-list-parser element-parser separator-parser)
)

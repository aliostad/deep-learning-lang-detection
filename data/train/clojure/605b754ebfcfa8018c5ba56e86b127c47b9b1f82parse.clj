(ns puretest.utilities.parse
    (:use
        testing.core
    )
    (:require
        [utilities.parse :as prs]
    )
    (:import
        [java.io StringReader]
        [utilities.parse InvalidSyntaxException]
    )
)

(suite "str->stream"
    (:fact str->stream
        (prs/str->stream "ab")
        :is
        [
            [\a {:gen-ISE prs/default-ISE}]
            [\b {:gen-ISE prs/default-ISE}]
            [:eof {:gen-ISE prs/default-ISE}]
        ]
    )
)

(suite "reader->stream"
    (:fact reader->stream
        (->> "ab"
            (StringReader.)
            (prs/reader->stream!)
        )
        :is
        [
            [\a {:gen-ISE prs/default-ISE}]
            [\b {:gen-ISE prs/default-ISE}]
            [:eof {:gen-ISE prs/default-ISE}]
        ]
    )
)

(defn extract-line-column [res stream]
    (if (empty? stream)
        res
        (let [[_ & xs] stream]
            (try
                (prs/gen-ISE stream "msg")
            (catch InvalidSyntaxException ex
                (extract-line-column (conj res (.getMessage ex)) xs)
            ))
        )
    )
)

(suite "positional-stream"
    (:fact positional-stream
        (extract-line-column []
            (prs/positional-stream (prs/str->stream "ab\nc"))
        )
        :is
        [
            "msg at 1:1"
            "msg at 1:2"
            "msg at 1:3"
            "msg at 2:1"
            "msg"
        ]
    )
)

(defn extract-stream [stream]
    (vec (map first stream))
)

(defn extract-result [result]
    (let [[stream result] result]
        [(extract-stream stream) result]
    )
)

(suite "expect-char"
    (:fact char-match
        (->> "abc"
            (prs/str->stream)
            ((prs/expect-char \a))
            (extract-result)
        )
        :is
        [[\b \c :eof] \a]
    )
    (:fact char-eof
        (fn []
            (->> ""
                (prs/str->stream)
                ((prs/expect-char \a))
            )
        )
        :throws InvalidSyntaxException
    )
    (:fact char-unmatch
        (fn []
            (->> "abc"
                (prs/str->stream)
                ((prs/expect-char \b))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "expect-char-if"
    (:fact char-if-match
        (->> "ab"
            (prs/str->stream)
            ((prs/expect-char-if #{\a}))
            (extract-result)
        )
        :is
        [[\b :eof] \a]
    )
    (:fact char-if-unmatch
        (fn []
            (->> "ba"
                (prs/str->stream)
                ((prs/expect-char-if #{\a}))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "digit"
    (:testbench
        (fn [test]
            (doseq [x (range 128)]
                (test (char x))
            )
        )
    )
    (:fact digit
        (fn [ch]
            (boolean (prs/digit ch))
        )
        :eq
        (fn [ch]
            (Character/isDigit ch)
        )
    )
)

(suite "letter"
    (:testbench
        (fn [test]
            (doseq [x (range 128)]
                (test (char x))
            )
        )
    )
    (:fact letter
        (fn [ch]
            (boolean (prs/letter ch))
        )
        :eq
        (fn [ch]
            (Character/isLetter ch)
        )
    )
)

(suite "expect-any-char"
    (:fact any-char-match
        (->> "a"
            (prs/str->stream)
            ((prs/expect-any-char))
            (extract-result)
        )
        :is
        [[:eof] \a]
    )
    (:fact any-char-eof
        (fn []
            (->> ""
                (prs/str->stream)
                ((prs/expect-any-char))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "expect-eof"
    (:fact eof-eof
        (->> ""
            (prs/str->stream)
            ((prs/expect-eof))
            (extract-result)
        )
        :is
        [[:eof] :eof]
    )
    (:fact eof-noeof
        (fn []
            (->> "abc"
                (prs/str->stream)
                ((prs/expect-eof))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "expect-string"
    (:fact str-normal
        (->> "abc"
            (prs/str->stream)
            ((prs/expect-string "ab"))
            (extract-result)
        )
        :is
        [[\c :eof] "ab"]
    )
    (:fact str-eof
        (fn []
            (->> ""
                (prs/str->stream)
                ((prs/expect-string "ab"))
            )
        )
        :throws InvalidSyntaxException
    )
    (:fact str-short
        (fn []
            (->> "a"
                (prs/str->stream)
                ((prs/expect-string "ab"))
            )
        )
        :throws InvalidSyntaxException
    )
    (:fact str-unmatch
        (fn []
            (->> "acb"
                (prs/str->stream)
                ((prs/expect-string "ab"))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "skip-while"
    (:fact skip-while
        (->> "1a"
            (prs/str->stream)
            ((prs/skip-while prs/digit))
            (extract-result)
        )
        :is
        [[\a :eof] nil]
    )
    (:fact skip-while:empty
        (->> "a"
            (prs/str->stream)
            ((prs/skip-while prs/digit))
            (extract-result)
        )
        :is
        [[\a :eof] nil]
    )
)

(suite "choice"
    (:fact choice-first
        (->> "abc"
            (prs/str->stream)
            ((prs/choice (prs/expect-char \a) (prs/expect-string "ab")))
            (extract-result)
        )
        :is
        [[\b \c :eof] \a]
    )
    (:fact choice-second
        (->> "bcd"
            (prs/str->stream)
            ((prs/choice (prs/expect-char \a) (prs/expect-string "bc")))
            (extract-result)
        )
        :is
        [[\d :eof] "bc"]
    )
    (:fact choice-unmatch
        (fn []
            (->> "xyz"
                (prs/str->stream)
                ((prs/choice (prs/expect-char \a) (prs/expect-string "bc")))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "choice*"
    (:fact choice*:first
        (->> "a"
            (prs/str->stream)
            ((prs/choice*
                {\a :a, \b :b} (prs/expect-char \a)
                {\a :a, \b :b} (prs/expect-char \b)
            ))
            (extract-result)
        )
        :is
        [[:eof] :a]
    )
    (:fact choice*:second
        (->> "b"
            (prs/str->stream)
            ((prs/choice*
                {\a :a, \b :b} (prs/expect-char \a)
                {\a :a, \b :b} (prs/expect-char \b)
            ))
            (extract-result)
        )
        :is
        [[:eof] :b]
    )
    (:fact choice*:default
        (->> "c"
            (prs/str->stream)
            ((prs/choice*
                {\a :a, \b :b} (prs/expect-char \a)
                {\a :a, \b :b} (prs/expect-char \b)
                :default
            ))
            (extract-result)
        )
        :is
        [[\c :eof] :default]
    )
    (:fact choice*:unmatch
        (fn []
            (->> "c"
                (prs/str->stream)
                ((prs/choice*
                    {\a :a, \b :b} (prs/expect-char \a)
                    {\a :a, \b :b} (prs/expect-char \b)
                ))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "optional"
    (:fact optional-match
        (->> "ab"
            (prs/str->stream)
            ((prs/optional (prs/expect-char \a)))
            (extract-result)
        )
        :is
        [[\b :eof] \a]
    )
    (:fact optional-unmatch
        (->> "ab"
            (prs/str->stream)
            ((prs/optional (prs/expect-char \z)))
            (extract-result)
        )
        :is
        [[\a \b :eof] nil]
    )
)

(suite "many"
    (:fact many-one
        (->> "ab"
            (prs/str->stream)
            ((prs/many (prs/expect-char \a)))
            (extract-result)
        )
        :is
        [[\b :eof] [\a]]
    )
    (:fact many-many
        (->> "aab"
            (prs/str->stream)
            ((prs/many (prs/expect-char \a)))
            (extract-result)
        )
        :is
        [[\b :eof] [\a \a]]
    )
    (:fact many-none
        (->> "b"
            (prs/str->stream)
            ((prs/many (prs/expect-char \a)))
            (extract-result)
        )
        :is
        [[\b :eof] []]
    )
)

(suite "many1"
    (:fact many1-one
        (->> "ab"
            (prs/str->stream)
            ((prs/many1 (prs/expect-char \a)))
            (extract-result)
        )
        :is
        [[\b :eof] [\a]]
    )
    (:fact many1-many
        (->> "aab"
            (prs/str->stream)
            ((prs/many1 (prs/expect-char \a)))
            (extract-result)
        )
        :is
        [[\b :eof] [\a \a]]
    )
    (:fact many1-none
        (fn []
            (->> "b"
                (prs/str->stream)
                ((prs/many1 (prs/expect-char \a)))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "chain"
    (:fact chain-match-both
        (->> "abc"
            (prs/str->stream)
            ((prs/chain (prs/expect-char \a) (prs/expect-char \b)))
            (extract-result)
        )
        :is
        [[\c :eof] [\a \b]]
    )
    (:fact chain-match-one
        (fn []
            (->> "abc"
                (prs/str->stream)
                ((prs/chain (prs/expect-char \a) (prs/expect-char \z)))
            )
        )
        :throws InvalidSyntaxException
    )
    (:fact chain-match-none
        (fn []
            (->> "abc"
                (prs/str->stream)
                ((prs/chain (prs/expect-char \y) (prs/expect-char \b)))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "between"
    (:fact between-match
        (->> "{a{a}}"
            (prs/str->stream)
            ((prs/between (prs/expect-char \{) (prs/expect-char \}) (prs/expect-any-char)))
            (extract-result)
        )
        :is
        [[\} :eof] [\{ \} [\a \{ \a]]]
    )
    (:fact between-unmatch
        (fn []
            (->> "{a{b"
                (prs/str->stream)
                ((prs/between (prs/expect-char \{) (prs/expect-char \}) (prs/expect-any-char)))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "foresee"
    (:fact foresee-match
        (->> "a"
            (prs/str->stream)
            ((prs/foresee (prs/expect-char \a)))
            (extract-result)
        )
        :is
        [[\a :eof] \a]
    )
    (:fact foresee-unmatch
        (fn []
            (->> "b"
                (prs/str->stream)
                ((prs/foresee (prs/expect-char \a)))
            )
        )
        :throws InvalidSyntaxException
    )
)

(suite "extract-string-between"
    (:fact extract-string-between-normal
        (let [start-stream (prs/str->stream "ab")
                end-stream (next start-stream)
            ]
            (prs/extract-string-between start-stream end-stream)
        )
        :is
        "a"
    )
    (:fact extract-string-between-eof
        (fn []
            (let [start-stream (prs/str->stream "ab")]
                (prs/extract-string-between start-stream nil)
            )
        )
        :throws IllegalArgumentException
    )
)

(defn char-rule [stream]
    (let [[strm prsd] (->> stream ((prs/expect-char-if #{\1 \2 \3})))]
        (case prsd
            \1 [strm 1]
            \2 [strm 2]
            \3 [strm 3]
        )
    )
)

(defn plus-rule [expr-parser stream]
    (let [[strm1 prsd1] (->> stream
            ((prs/chain expr-parser (prs/expect-char \+) expr-parser))
        )
        ]
        [strm1 [+ (first prsd1) (last prsd1)]]
    )
)

(defn plus-rule1 [expr-parser parsed stream]
    (let [[strm1 prsd1] (->> stream
            ((prs/chain (prs/expect-char \+) expr-parser))
        )
        ]
        [strm1 [+ parsed (last prsd1)]]
    )
)

(defn expression [stream]
    (let [recursive-expression (prs/left-recursive expression)
        [strm1 prsd1] (->> stream
            ((prs/choice
                (partial plus-rule recursive-expression)
                char-rule
            ))
        )
        [strm2 prsd2] (->> strm1
            ((prs/optional
                (partial plus-rule1 recursive-expression prsd1)
            ))
        )
        ]
        (if prsd2
            [strm2 prsd2]
            [strm1 prsd1]
        )
    )
)

(suite "left recursion"
    (:fact left-recursion
        (->> "1+2+3" ; EXP=EXP+EXP | 1 | 2 | 3
            (prs/str->stream)
            (expression)
            (second)
        )
        :is
        [+ 1 [+ 2 3]]
    )
)

(suite "separated list"
    (:fact separated-list:single
        (->> "a"
            (prs/str->stream)
            ((prs/separated-list (prs/expect-char-if prs/letter) (prs/expect-char \.)))
            (extract-result)
        )
        :is
        [[:eof] [\a]]
    )
    (:fact separated-list:multiple
        (->> "a.b"
            (prs/str->stream)
            ((prs/separated-list (prs/expect-char-if prs/letter) (prs/expect-char \.)))
            (extract-result)
        )
        :is
        [[:eof] [\a \b]]
    )
)

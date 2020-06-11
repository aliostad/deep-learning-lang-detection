(ns ccp.core-test
  (:require [clojure.test :refer :all]
            [ccp.core :as p]))

(deftest string-parse-stream-test
  (testing "String parse stream"
           (let [s (p/parse-stream "Hello!")
                 state (p/get-state s)]
             (is (= (p/next-elem s) \H))
             (is (= (do (p/reset s) (p/next-elem s)) \H))
             (is (= (p/next-elem s) \e))
             (is (= (do (p/set-user-state s 1) (p/get-user-state s)) 1))
             (is (= (p/prev-elem s) \H))
             (is (= (p/prev-elem s) nil))
             (is (= (p/get-user-state s) 1))
             (is (= (do (p/set-user-state s 2) (p/get-user-state s)) 2))
             (is (= (p/next-elem s) \H))
             (is (= (p/current-elem s) \H))
             (is (= (p/get-user-state s) 2))
             (is (= (do (p/next-elem s)
                      (p/next-elem s)
                      (p/next-elem s)
                      (p/next-elem s)
                      (p/next-elem s)
                      (p/next-elem s))
                    nil))
             (is (= (do (p/restore-state s state) (p/next-elem s)) \H)))))

(deftest sequence-parse-stream-test
  (testing "Sequence parse stream"
           (let [s (p/parse-stream [\H \e \l \l \o \!])
                 state (p/get-state s)]
             (is (= (p/next-elem s) \H))
             (is (= (do (p/reset s) (p/next-elem s)) \H))
             (is (= (p/next-elem s) \e))
             (is (= (do (p/set-user-state s 1) (p/get-user-state s)) 1))
             (is (= (p/prev-elem s) \H))
             (is (= (p/prev-elem s) nil))
             (is (= (p/get-user-state s) 1))
             (is (= (do (p/set-user-state s 2) (p/get-user-state s)) 2))
             (is (= (p/next-elem s) \H))
             (is (= (p/current-elem s) \H))
             (is (= (p/get-user-state s) 2))
             (is (= (do (p/next-elem s)
                      (p/next-elem s)
                      (p/next-elem s)
                      (p/next-elem s)
                      (p/next-elem s)
                      (p/next-elem s))
                    nil))
             (is (= (do (p/restore-state s state) (p/next-elem s)) \H)))))

(deftest line-col-test
  (testing "line-col function"
    (is (= (#'ccp.core/line-col "" -1) '(1 1)))
    (is (= (#'ccp.core/line-col "" 0) '(1 1)))
    (is (= (#'ccp.core/line-col "abc" 0) '(1 1)))
    (is (= (#'ccp.core/line-col "abc" 2) '(1 3)))
    (is (= (#'ccp.core/line-col "abc\nabc" 3) '(1 4)))
    (is (= (#'ccp.core/line-col "abc\nabc" 4) '(2 1)))
    (is (= (#'ccp.core/line-col "abc\rabc" 3) '(1 4)))
    (is (= (#'ccp.core/line-col "abc\rabc" 4) '(2 1)))
    (is (= (#'ccp.core/line-col "abc\r\nabc" 3) '(1 4)))
    (is (= (#'ccp.core/line-col "abc\r\nabc" 4) '(1 4)))
    (is (= (#'ccp.core/line-col "abc\r\nabc" 5) '(2 1)))
    (is (= (#'ccp.core/line-col "abc\n\nabc" 5) '(3 1)))
    (is (= (#'ccp.core/line-col "abc\n\nabc" 6) '(3 2)))))

(deftest parse-stream-test
  (testing "parse-stream function"
    (is (satisfies? p/ParseStream (p/parse-stream "")))
    (is (satisfies? p/ParseStream (p/parse-stream "abc")))
    (is (satisfies? p/ParseStream (p/parse-stream [])))
    (is (satisfies? p/ParseStream (p/parse-stream [1 2 3])))
    (is (satisfies? p/ParseStream (p/parse-stream {})))
    (is (satisfies? p/ParseStream (p/parse-stream {:a 1 :b 2})))
    (is (satisfies? p/ParseStream (p/parse-stream #{})))
    (is (satisfies? p/ParseStream (p/parse-stream #{1 2 3})))
    (is (satisfies? p/ParseStream (p/parse-stream '())))
    (is (satisfies? p/ParseStream (p/parse-stream '(1 2 3))))))

(deftest parser-error-test
  (testing "parser-error functions"
           (is (p/parser-error? (p/parser-error (p/parse-stream "") "error message")))
           (let [p (p/parse-stream "")]
             (is (= (p/parser-error-stream (p/parser-error p "")) p)))
           (let [e "error message"]
             (is (= (p/parser-error-message (p/parser-error (p/parse-stream "") e)) e)))
           (let [p (p/parse-stream "") s (p/get-state p)]
             (is (= (p/parser-error-state (p/parser-error p "")) s)))))

(defn take-elems
  [ps n]
  (loop [n n]
        (if (zero? n) ps
          (do (p/next-elem ps)
            (recur (dec n))))))
  
(deftest string-parse-stream-char-sequence-test
  (testing "char-sequence functions"
           (is (= (.charAt (p/char-sequence (take-elems (p/parse-stream "abc") 1)) 0) \a))
           (is (= (.charAt (p/char-sequence (take-elems (p/parse-stream "abc") 3)) 0) \c))
           (is (= (.charAt (p/char-sequence (take-elems (p/parse-stream "abc") 1)) 2) \c))
           (is (= (.charAt (p/char-sequence (take-elems (p/parse-stream "abcde") 3)) 2) \e))
           (is (= (.length (p/char-sequence (take-elems (p/parse-stream "abc") 1))) 3))
           (is (= (.length (p/char-sequence (take-elems (p/parse-stream "abc") 3))) 1))
           (is (= (.length (p/char-sequence (take-elems (p/parse-stream "abc") 1))) 3))
           (is (= (.length (p/char-sequence (take-elems (p/parse-stream "abcde") 3))) 3))
           (is (= (.toString (p/char-sequence (take-elems (p/parse-stream "abc") 1))) "abc"))
           (is (= (.toString (p/char-sequence (take-elems (p/parse-stream "abc") 3))) "c"))
           (is (= (.toString (p/char-sequence (take-elems (p/parse-stream "abc") 2))) "bc"))
           (is (= (.toString (p/char-sequence (take-elems (p/parse-stream "abcde") 3))) "cde"))
           (is (= (.toString (.subSequence (p/char-sequence (take-elems (p/parse-stream "abcde") 1)) 1 4)) "bcd"))
           (is (= (.toString (.subSequence (.subSequence (p/char-sequence (take-elems (p/parse-stream "abcde") 1)) 1 4) 0 2)) "bc"))))

(deftest n-args-test
  (testing "n-args function"
  (is (= (#'ccp.core/n-args (fn [] 1)) 0))
  (is (= (#'ccp.core/n-args (fn [a] 1)) 1))
  (is (= (#'ccp.core/n-args (fn [a b] 1)) 2))
  (is (= (#'ccp.core/n-args (fn [a b c] 1)) 3))))

(deftest rewind-test
  (testing "rewind parser combinator"
           (is (= \a
                  (let [p (p/parse-stream "abc")]
                    (do ((p/rewind (fn [ps] (p/next-elem ps) (p/parser-error ps "error occured"))) p) (p/next-elem p)))))
           (is (= \b
                  (let [p (p/parse-stream "abc")]
                    (do (p/next-elem p) ((p/rewind (fn [ps] (p/next-elem ps) (p/parser-error ps "error occured"))) p) (p/next-elem p)))))))

(deftest restore-test
  (testing "restore parser combinator"
           (is (= \a
                  (let [p (p/parse-stream "abc")]
                    (do ((p/restore (fn [ps] (p/next-elem ps) (p/next-elem ps))) p) (p/next-elem p)))))
           (is (= \b
                  (let [p (p/parse-stream "abc")]
                    (do (p/next-elem p) ((p/restore (fn [ps] (p/next-elem ps) (p/next-elem ps))) p) (p/next-elem p)))))))

(deftest return-test
  (testing "return parser combinator"
           (is (= \a ((fn [ps] (p/next-elem ps)) (p/parse-stream "abc"))))
           (is (= 1 ((p/return (fn [ps] (p/next-elem ps)) 1) (p/parse-stream "abc"))))))

(deftest null-test
  (testing "null parser combinator"
           (is (= nil ((p/null (fn [ps] (p/next-elem ps))) (p/parse-stream "abc"))))))

(deftest user-state-test
  (testing "user state parser combinators"
           (let [p (p/parse-stream "abc")]
             (is (= 123
                    ((fn [ps] (p/next-elem ps)
                        (p/user-state ps)
                        ((p/set-user-state! 123) ps)
                        (p/next-elem ps)
                        (p/user-state ps)) p))))
           (let [p (p/parse-stream "abc")]
             (is (= 124
                    ((fn [ps] (p/next-elem ps)
                        ((p/set-user-state! 123) ps)
                        ((p/modify-user-state! inc) ps)
                        (p/next-elem ps)
                        (p/user-state ps)) p))))))


(deftest defer-test
  (testing "defer parser combinator"
           (do 
              (declare my-undeclared-parser)
              (let [p (p/defer my-undeclared-parser)]
                (def my-undeclared-parser (fn [ps] 123))                
                (is (= 123 (p (p/parse-stream "123"))))))))

(deftest satisfy-test
  (testing "satisfy parser combinator"
           (is (= \a ((p/satisfy (fn [p] (= \a p)) "not a") (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/satisfy (fn [p] (= \a p)) "not a") (p/parse-stream "bc"))))))

(deftest satisfy-char-test
  (testing "satisfy-char parser combinator"
           (is (= \a ((p/satisfy-char (fn [p] (= \a p)) "not a") (p/parse-stream [\a]))))
           (is (= \a ((p/satisfy-char (fn [p] (= \a p)) "not a") (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/satisfy-char (fn [p] (= \a p)) "not a") (p/parse-stream ["a"]))))))

(deftest chr-test
  (testing "chr parser combinator"
           (is (= \a ((p/chr \a) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/chr \a) (p/parse-stream "bc"))))))

(deftest digit-test
  (testing "digit parser"
           (is (= \1 (p/digit (p/parse-stream "123"))))
           (is (p/parser-error? (p/digit (p/parse-stream "abc"))))))

(deftest non-digit-test
  (testing "non-digit parser"
           (is (= \a (p/non-digit (p/parse-stream "abc"))))
           (is (p/parser-error? (p/non-digit (p/parse-stream "123"))))))
             
(deftest ws-test
  (testing "ws parser"
           (is (= \space (p/ws (p/parse-stream " "))))
           (is (= \return (p/ws (p/parse-stream "\r"))))
           (is (= \newline (p/ws (p/parse-stream "\n"))))
           (is (p/parser-error? (p/ws (p/parse-stream "abc"))))))

(deftest non-ws-test
  (testing "non-ws parser"
           (is (p/parser-error? (p/non-ws (p/parse-stream " "))))
           (is (p/parser-error? (p/non-ws (p/parse-stream "\r"))))
           (is (p/parser-error? (p/non-ws (p/parse-stream "\n"))))
           (is (is (= \a (p/non-ws (p/parse-stream "abc")))))))

(deftest alpha-test
  (testing "alpha parser"
           (is (= \a (p/alpha (p/parse-stream "a"))))
           (is (= \0 (p/alpha (p/parse-stream "0"))))
           (is (p/parser-error? (p/alpha (p/parse-stream " "))))))

(deftest non-alpha-test
  (testing "non-alpha parser"
           (is (p/parser-error? (p/non-alpha (p/parse-stream "a"))))
           (is (p/parser-error? (p/non-alpha (p/parse-stream "0"))))
           (is (is (= \space (p/non-alpha (p/parse-stream " ")))))))

(deftest upper-test
  (testing "upper parser"
           (is (= \A (p/upper (p/parse-stream "A"))))
           (is (p/parser-error? (p/upper (p/parse-stream "a"))))))

(deftest non-upper-test
  (testing "non-upper parser"
           (is (= \a (p/non-upper (p/parse-stream "a"))))
           (is (p/parser-error? (p/non-upper (p/parse-stream "A"))))))

(deftest lower-test
  (testing "lower parser"
           (is (= \a (p/lower (p/parse-stream "a"))))
           (is (p/parser-error? (p/lower (p/parse-stream "A"))))))

(deftest non-lower-test
  (testing "non-lower parser"
           (is (= \A (p/non-lower (p/parse-stream "A"))))
           (is (p/parser-error? (p/non-lower (p/parse-stream "a"))))))

(deftest any-char-test
  (testing "any-char parser"
           (is (= \a (p/any-char (p/parse-stream "a"))))
           (is (p/parser-error? (p/any-char (p/parse-stream [1]))))))

(deftest bol-test
  (testing "bol parser"
           (is (= nil (p/bol (p/parse-stream "abc"))))
           (is (= nil (p/bol (take-elems (p/parse-stream "abc\n") 4))))
           (is (p/parser-error? (p/bol (take-elems (p/parse-stream "abc") 2))))))

(deftest eol-test
  (testing "eol parser"
           (is (= \newline (p/eol (p/parse-stream ""))))
           (is (= \newline (p/eol (take-elems (p/parse-stream "abc\n") 3))))
           (is (p/parser-error? (p/eol (take-elems (p/parse-stream "abc") 2))))))

(deftest bos-test
  (testing "bos parser"
           (is (= nil (p/bos (p/parse-stream "abc"))))
           (is (p/parser-error? (p/bos (take-elems (p/parse-stream "abc") 2))))))

(deftest eos-test
  (testing "eos parser"
           (is (= nil (p/eos (take-elems (p/parse-stream "") 1))))
           (is (p/parser-error? (p/eos (take-elems (p/parse-stream "abc") 2))))))

(deftest any-elem-test
  (testing "any-elem parser"
           (is (= \a (p/any-elem (p/parse-stream "a"))))
           (is (= 1 (p/any-elem (p/parse-stream [1]))))))

(deftest elem-test
  (testing "elem parser combinator"
           (is (= \a ((p/elem \a) (p/parse-stream "a"))))
           (is (= 1 ((p/elem 1) (p/parse-stream [1]))))
           (is (p/parser-error? ((p/elem 1) (p/parse-stream [2]))))))

(deftest match-test
  (testing "match parser combinator"
           (is (= "abc" ((p/match "[abc]{3}") (p/parse-stream "abc"))))
           (is (= "123" ((p/match "[0-9]+") (p/parse-stream "123"))))
           (is (p/parser-error? ((p/match "[0-9]+") (p/parse-stream "abc"))))))

(deftest collect-test
  (testing "collect parser combinator"
           (is (= [] ((p/collect 0) (p/parse-stream "123"))))
           (is (= [\1 \2 \3] ((p/collect 3) (p/parse-stream "123"))))
           (is (p/parser-error? ((p/collect 3) (p/parse-stream "ab"))))))

(deftest consume-test
  (testing "consume parser combinator"
           (is (= nil ((p/consume 0) (p/parse-stream "123"))))
           (is (= nil ((p/consume 3) (p/parse-stream "123"))))
           (is (p/parser-error? ((p/consume 3) (p/parse-stream "ab"))))))

(deftest string-test
  (testing "string parser combinator"
           (is (= "abc" ((p/string "abc") (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/string "abc") (p/parse-stream "abe"))))
           (is (p/parser-error? ((p/string "abc") (p/parse-stream "ab"))))))

(deftest >>-test
  (testing ">> parser combinator"
           (is (= \a ((p/>> p/any-elem) (p/parse-stream "abc"))))
           (is (= \b ((p/>> p/any-elem p/any-elem) (p/parse-stream "abc"))))
           (is (= \c ((p/>> p/any-elem p/any-elem p/any-elem) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/>> p/any-char p/any-char) (p/parse-stream "a"))))))

(deftest >>!-test
  (testing ">>! parser combinator"
           (is (= nil ((p/>>! (p/null p/any-elem)) (p/parse-stream "abc"))))
           (is (= \b ((p/>>! (p/null p/any-elem) p/any-elem (p/null p/any-elem)) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/>>! p/any-char p/any-char) (p/parse-stream "a"))))))

(deftest <<-test
  (testing "<< parser combinator"
           (is (= \a ((p/<< p/any-elem) (p/parse-stream "abc"))))
           (is (= \a ((p/<< p/any-elem p/any-elem) (p/parse-stream "abc"))))
           (is (= \a ((p/<< p/any-elem p/any-elem p/any-elem) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/<< p/any-char p/any-char) (p/parse-stream "a"))))))

(deftest <<!-test
  (testing "<<! parser combinator"
           (is (= nil ((p/<<! (p/null p/any-elem)) (p/parse-stream "abc"))))
           (is (= \b ((p/<<! (p/null p/any-elem) p/any-elem) (p/parse-stream "abc"))))
           (is (= \c ((p/<<! (p/null p/any-elem) (p/null p/any-elem) p/any-elem) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/<<! p/any-char p/any-char) (p/parse-stream "a"))))))

(deftest >>=-test
  (testing ">>= parser combinator"
           (is (= "ab" ((p/>>= p/any-elem #(str % "b")) (p/parse-stream "abc"))))
           (is (= "ab" ((p/>>= p/any-elem #(str %1 (p/any-elem %2))) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/>>= (p/chr \b) #(str % "b")) (p/parse-stream "abc"))))))

(deftest letp-test
  (testing "letp parser combinator"
           (is (= [\a \b] ((p/letp [a (p/chr \a) b (p/chr \b)] [a b]) (p/parse-stream "ab"))))
           (is (= 3 ((p/letp [a p/any-elem b p/any-elem] (+ a b)) (p/parse-stream [1 2]))))
           (is (p/parser-error? ((p/letp [a (p/chr \a) b (p/chr \b)] [a b]) (p/parse-stream "bb"))))))

(deftest <*>-test
  (testing "<*> parser combinator"
           (is (= [\a] ((p/<*> p/any-char) (p/parse-stream "abc"))))
           (is (= [\a \b] ((p/<*> p/any-char p/any-char) (p/parse-stream "abc"))))
           (is (= [\a \b \c] ((p/<*> p/any-char p/any-char p/any-char) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/<*> p/any-char p/any-char p/any-char) (p/parse-stream "ab"))))))

(deftest <*!>-test
  (testing "<*!> parser combinator"
           (is (= [\b] ((p/<*!> (p/null p/any-char) p/any-char) (p/parse-stream "abc"))))
           (is (= [\a] ((p/<*!> p/any-char (p/null p/any-char)) (p/parse-stream "abc"))))
           (is (= [\a \c] ((p/<*!> p/any-char (p/null p/any-char) p/any-char) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/<*!> p/any-char (p/null p/any-char) p/any-char) (p/parse-stream "ab"))))))

(deftest <str*>-test
  (testing "<str*> parser combinator"
           (is (= "a" ((p/<str*> p/any-char) (p/parse-stream "abc"))))
           (is (= "ab" ((p/<str*> p/any-char p/any-char) (p/parse-stream "abc"))))
           (is (= "abc" ((p/<str*> p/any-char p/any-char p/any-char) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/<str*> p/any-char p/any-char p/any-char) (p/parse-stream "ab"))))))

(deftest <keyword>-test
  (testing "<keyword> parser combinator"
           (is (= :abc ((p/<keyword> (p/string "abc")) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/<keyword> (p/string "abc")) (p/parse-stream "ab"))))))

(deftest <keyword*>-test
  (testing "<keyword*> parser combinator"
           (is (= :abc ((p/<keyword*> p/any-char p/any-char p/any-char) (p/parse-stream "abc"))))
           (is (p/parser-error? ((p/<keyword*> p/any-char p/any-char p/any-char) (p/parse-stream "ab"))))))

(deftest <|>-test
  (testing "<|> parser combinator"
           (is (= \c ((p/<|> (p/chr \a) (p/chr \b) (p/chr \c)) (p/parse-stream "c"))))
           (is (p/parser-error? ((p/<|> (p/chr \a) (p/chr \b) (p/chr \c)) (p/parse-stream "d"))))))

(deftest <?>-test
  (testing "<?> parser combinator"
           (is (= \a ((p/<?> (p/chr \a) "a") (p/parse-stream "a"))))
          (let [e ((p/<?> (p/chr \a) "a") (p/parse-stream "d"))]
            (is (and (p/parser-error? e) (= (p/parser-error-message e) "a"))))))

(deftest fail-test
  (testing "fail parser combinator"
    (is (p/parser-error? ((p/fail p/any-char) (p/parse-stream "a"))))
    (is (p/parser-error? ((p/fail (p/chr \b)) (p/parse-stream "a"))))))

(deftest fail-message-test
  (testing "fail-message function"
    (is (= (p/fail-message (p/chr \a)) "\\a character"))
    (is (= (p/fail-message p/any-char) "any character"))))

(deftest no-test
  (testing "no parser combinator"
    (is (= nil ((p/no (p/chr \b)) (p/parse-stream "a"))))
    (is (p/parser-error? ((p/no p/any-char) (p/parse-stream "a"))))))

(deftest option-test
  (testing "option parser combinator"
    (is (= \a ((p/option (p/chr \a) \b) (p/parse-stream "a"))))
    (is (= \b ((p/option (p/restore (p/chr \a)) \b) (p/parse-stream "c"))))))

(deftest op-expr-test
  (testing "op-expr parser combinator"
    (is (= '(\+ \a \b) ((p/op-expr p/any-char [(p/op (p/chr \+) 1)]) (p/parse-stream "a+b"))))
    (is (= '(\+ (\+ \a \b) \c) ((p/op-expr p/any-char [(p/op (p/chr \+) 1)]) (p/parse-stream "a+b+c"))))
    (is (= '(\+ \a (\* \b \c)) ((p/op-expr p/any-char [(p/op (p/chr \+) 1) (p/op (p/chr \*) 2)]) (p/parse-stream "a+b*c"))))
    (is (= '(\* (\+ \a \b) \c)) ((p/op-expr p/any-char [(p/op (p/chr \+) 1) (p/op (p/chr \*) 1)]) (p/parse-stream "a+b*c")))))

(deftest many-test
  (testing "many parser combinator"
    (is (= [\a \b \c] ((p/many p/any-char) (p/parse-stream "abc"))))
    (is (= [\a \a \a] ((p/many (p/chr \a)) (p/parse-stream "aaa"))))
    (is (= [] ((p/many (p/chr \a)) (p/parse-stream "bc"))))))

(deftest many1-test
  (testing "many1 parser combinator"
    (is (= [\a \b \c] ((p/many1 p/any-char) (p/parse-stream "abc"))))
    (is (= [\a \a \a] ((p/many1 (p/chr \a)) (p/parse-stream "aaa"))))
    (is (p/parser-error? ((p/many1 (p/chr \a)) (p/parse-stream "bc"))))))

(deftest many-till-test
  (testing "many-till parser combinator"
    (is (= [\a \b] ((p/many-till p/any-char (p/chr \c)) (p/parse-stream "abc"))))
    (is (= [] ((p/many-till p/any-char (p/chr \a)) (p/parse-stream "aaa"))))
    (is (p/parser-error? ((p/many-till p/any-char (p/chr \d)) (p/parse-stream "abc"))))))

(deftest many1-till-test
  (testing "many1-till parser combinator"
    (is (= [\a \b] ((p/many1-till p/any-char (p/chr \c)) (p/parse-stream "abc"))))
    (is (= [\a] ((p/many1-till p/any-char (p/chr \a)) (p/parse-stream "aaa"))))
    (is (p/parser-error? ((p/many1-till p/any-char (p/chr \d)) (p/parse-stream "abc"))))))

(deftest atleast-test
  (testing "atleast parser combinator"
    (is (= \a ((p/atleast p/any-char 1 1) (p/parse-stream "abc"))))
    (is (= nil ((p/atleast (p/chr \b) 0 1) (p/parse-stream "abc"))))
    (is (= [\a \b \c] ((p/atleast p/any-char 2 3) (p/parse-stream "abcdef"))))
    (is (p/parser-error? ((p/atleast (p/chr \a) 2 3) (p/parse-stream "abcdef"))))))

(deftest flat-test
  (testing "flat parser combinator"
    (is (= [\a \b \c] ((p/flat (p/<*> p/any-char p/any-char p/any-char)) (p/parse-stream "abc"))))
    (is (= [\a \b \c] ((p/flat (p/<*> p/any-char (p/<*> p/any-char p/any-char))) (p/parse-stream "abc"))))
    (is (= [\a \b \c] ((p/flat (p/<*> p/any-char (p/<*> p/any-char (p/<*> p/any-char)))) (p/parse-stream "abc"))))
    (is (p/parser-error? ((p/flat (p/<*> (p/chr \a) (p/chr \d))) (p/parse-stream "abcdef"))))))

(deftest between-test
  (testing "between parser combinator"
    (is (= \b ((p/between p/any-char p/any-char p/any-char) (p/parse-stream "abc"))))
    (is (= \b ((p/between p/any-char p/any-char (p/chr \c)) (p/parse-stream "abc"))))
    (is (p/parser-error? ((p/between (p/chr \b) p/any-char (p/chr \c)) (p/parse-stream "abc"))))
    (is (p/parser-error? ((p/between (p/chr \a) p/any-char (p/chr \b)) (p/parse-stream "abc"))))))

(deftest between?-test
  (testing "between? parser combinator"
    (is (= \b ((p/between? p/any-char p/any-char p/any-char) (p/parse-stream "abc"))))
    (is (= \b ((p/between? p/any-char p/any-char (p/chr \c)) (p/parse-stream "abc"))))
    (is (= \a ((p/between? (p/chr \b) p/any-char (p/chr \c)) (p/parse-stream "abc"))))
    (is (p/parser-error? ((p/between? (p/chr \a) p/any-char (p/chr \b)) (p/parse-stream "abc"))))))

(deftest separated-test
  (testing "separated parser combinator"
    (is (= [\a \c] ((p/separated p/any-char p/any-char) (p/parse-stream "abc"))))
    (is (p/parser-error? ((p/separated p/any-char p/any-char) (p/parse-stream "abce"))))
    (is (p/parser-error? ((p/separated (p/chr \b) p/any-char) (p/parse-stream "abce"))))
    (is (= [\a] ((p/separated (p/chr \a) (p/chr \a)) (p/parse-stream "abce"))))))

(deftest separated!-test
  (testing "separated! parser combinator"
    (is (= [\a \c] ((p/separated! p/any-char p/any-char) (p/parse-stream "abc"))))
    (is (= [\a \c] ((p/separated! p/any-char p/any-char) (p/parse-stream "abce"))))
    (is (p/parser-error? ((p/separated! (p/chr \b) p/any-char) (p/parse-stream "abce"))))
    (is (= [\a] ((p/separated (p/chr \a) (p/chr \a)) (p/parse-stream "abce"))))))



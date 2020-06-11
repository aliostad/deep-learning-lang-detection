(ns cas.language
  (:require [clojure.string :as string]))

;;
;; Defines the language that Robot programs are written in
;;

;; Tokenizes a splitted part of source, ie "124" or "KEYWORD"
(defn- tokenize-source-thing [obj]
  (cond
    (re-matches #"[0-9]+" obj) ;; literal int
    (js/parseInt obj)

    ;; keywords
    (= obj "FOR")
    :for

    (= obj "WHILE")
    :while

    (= obj "SUB")
    :sub

    (= obj "DO")
    :do

    (= obj "DONE")
    :done

    (= obj "(")
    :open-paren

    (= obj ")")
    :close-paren

    ;; otherwise, it's a user defined string
    true
    obj

    )
  )

(defn- parse-ident [stream]
  (assert (string? (stream :peek)))
  (stream :eat))

(defn- parse-var-list [stream]
  (assert (= (stream :eat) :open-paren))

  (loop [args []]
    (if (= (stream :peek) :close-paren)
      args)
    (recur (conj args (parse-ident stream)))))

(defn- parse-ident-atom [stream]
  (let [ident (stream :eat)]
    (case (stream :peek)
      :open-paren
      [:func-call ident (parse-var-list stream)]

      true ident)))

(defn- parse-atom [stream]
  (if (integer? (stream :peek))
    (stream :eat)
    (parse-ident-atom stream)))

(defn- parse-dm [stream]
  (let [left (parse-atom stream)]
    (case (stream :peek)
      "/" (do (stream :eat) [:div left (parse-dm stream)])
      "*" (do (stream :eat) [:div left (parse-dm stream)])
      true left)))

(defn- parse-pm [stream]
  (let [left (parse-dm stream)]
    (case (stream :peek)
      "+" [:add left (parse-pm stream)]
      "-" [:sub left (parse-pm stream)]
      true left)))

(defn- parse-assign [stream]
  (let [left (parse-pm stream)]
    (case (stream :peek)
      "="  (do (stream :eat) [:assign left (parse-assign stream)])
      "+=" (do (stream :eat) [:assign left [:add left (parse-assign stream)]])
      "*=" (do (stream :eat) [:assign left [:mul left (parse-assign stream)]])
      "/=" (do (stream :eat) [:assign left [:div left (parse-assign stream)]])
      "-=" (do (stream :eat) [:assign left [:sub left (parse-assign stream)]])
      true left)))

(defn- parse-expression [stream]
  (parse-assign stream))

;;
;; Anything of the form: DO expression_list... DONE
;;
(defn- parse-block [stream]
  (assert (= (stream :eat) :do))

  [:block (loop [x []]
            (if (= (stream :peek) :done)
              x
              (recur (concat x (parse-expression stream)))))]
  )

;;
;; FOR i = 0; i < 10; i += 1
;; DO
;;   SOME_FUNCTION (i)
;; DONE
;;
(defn- parse-for [stream]
  (assert (= (stream :eat) :for))

  (let [init (parse-expression stream)
        cond (parse-expression stream)
        loop (parse-expression stream)
        blck (parse-block stream)]
    [:for init cond loop blck]
    ))

;;
;; WHILE i < 2;
;; DO
;;   i += 1;
;; DONE
;;
(defn- parse-while [stream]
  (assert (= (stream :eat) :while))

  (let [cond (parse-expression stream)
        blck (parse-block stream)]
    [:while cond blck]))

;;
;; IF i == 2;
;; DO
;;   PRINT ( "TWO" )
;; DONE
;;
(defn- parse-if [stream]
  (assert (= (stream :eat) :if))

  (let [cond (parse-expression stream)
        blck (parse-block stream)]
    [:if cond blck]
    )
  )

;;
;; SUB ident ( param )
;; DO
;;   WHILE param < 10; DO
;;     param += 1;
;;   DONE
;; DONE
;;
(defn parse-sub [stream]
  (assert (= (stream :eat) :sub))

  (let [identifier (parse-ident stream)
        param-list (parse-var-list stream)
        block      (parse-block stream)]
    [:sub identifier param-list block]
    )
  )

(defn- parse-top-level [stream]
  (case (stream :peek)
    :for (parse-for stream)
    :while (parse-while stream)
    :if (parse-if stream)
    :sub (parse-sub stream)
    true (parse-expression stream)
    )
  )

(defn- parse [stream]
  (loop [x []]
    (if (= (stream :peek) :eof)
      x
      (recur (concat x (parse-top-level stream))))))

(defn- token-stream [toks]
  (let [idx (atom 0)]
    (fn [action]
      (case action
        :peek (get toks idx)

        :eat (let [ret (get toks idx)]
               (swap! idx inc)
               ret)
        ))))


;; called once when making the generator
(defn- make-ast [text]
  (parse (token-stream (map tokenize-source-thing (string/split text #" "))))
  )

;; Interface to language runtime
(defn generate-program-context [text timeout]
  (let [ast (make-ast text)
        idx 0]
    (fn [state] ;; action generator
      )
  ))

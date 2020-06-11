(ns spec-talks.advanced
  (:require [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [clojure.spec.test :as stest]))

;; Sequences
;; cat
(s/def ::ingredient (s/cat :quantity number? :unit keyword?))
(s/conform ::ingredient [2 :teaspoon]) ;;=> {:quantity 2, :unit :teaspoon}

;; *
(s/conform (s/* keyword?) []) ;;=> []
(s/conform (s/* keyword?) [:a]) ;;=> [:a]
(s/conform (s/* keyword?) [:a :b]) ;;=> [:a :b]

;; +
(s/conform (s/+ keyword?) []) ;;=> :clojure.spec/invalid
(s/conform (s/+ keyword?) [:a]) ;;=> [:a]
(s/conform (s/+ keyword?) [:a :b]) ;;=> [:a :b]

;; ?
(s/conform (s/? keyword?) []) ;;=> nil
(s/conform (s/? keyword?) [:a]) ;;=> :a
(s/conform (s/? keyword?) [:a :b]) ;;=> :clojure.spec/invalid

;; alt
(s/def ::config (s/*
                  (s/cat :prop string?
                         :val  (s/alt :s string? :b boolean?))))
(s/conform ::config ["-server" "foo" "-verbose" true "-user" "joe"])
;;=> [{:prop "-server", :val [:s "foo"]}
;;    {:prop "-verbose", :val [:b true]}
;;    {:prop "-user", :val [:s "joe"]}]

;; Entity Map
;; keys
(def email-regex #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$")
(s/def ::email-type (s/and string? #(re-matches email-regex %)))

(s/def ::acctid int?)
(s/def ::first-name string?)
(s/def ::last-name string?)
(s/def ::email ::email-type)

(s/def ::person (s/keys :req [::first-name ::last-name ::email]
                        :opt [::phone]))

(s/valid? ::person
  {::first-name "Elon"
   ::last-name "Musk"
   ::email "elon@example.com"}) ;;=> true

(s/explain ::person
  {::first-name "Elon"})
;;=> val: #:spec-talks.advanced{:first-name "Elon"}
;;   fails spec: :spec-talks.advanced/person
;;   predicate: (contains? % :spec-talks.advanced/last-name)
;;
;;   val: #:spec-talks.advanced{:first-name "Elon"}
;;   fails spec: :spec-talks.advanced/person
;;   predicate: (contains? % :spec-talks.advanced/email)

(s/explain ::person
  {::first-name "Elon"
   ::last-name "Musk"
   ::email "n/a"})
;;=> In: [:spec-talks.advanced/email]
;;   val: "n/a"
;;   fails spec: :spec-talks.advanced/email-type
;;   at: [:spec-talks.advanced/email]
;;   predicate: (re-matches email-regex %)

;; Validation
;; s/assert
(defn person-name
  [person]
  (let [p (s/assert ::person person)]
    (str (::first-name p) " " (::last-name p))))

(s/check-asserts true)
(person-name 100)
;;=> ExceptionInfo Spec assertion failed
;;   val: 100 fails predicate: map?
;;   :clojure.spec/failure  :assertion-failed
;;   #:clojure.spec{:problems [{:path [], :pred map?, :val 100, :via [], :in []}],
;;                  :failure :assertion-failed}

;; pre/post
(defn person-name
  [person]
  {:pre [(s/valid? ::person person)]
   :post [(s/valid? string? %)]}
  (str (::first-name person) " " (::last-name person)))

(person-name 42)
;;=> java.lang.AssertionError: Assert failed: (s/valid? :spec-talks.advanced/person person)

;; fdef
(s/fdef clojure.core/symbol
  :args (s/alt :separate (s/cat :ns string? :n string?)
               :str string?
               :sym symbol?)
  :ret symbol?)

;; Intrumentation and Testing
;; instrument
(stest/instrument `symbol)
(symbol 'foo)
;;=> foo
(symbol 1)
;;=> ExceptionInfo Call to #'clojure.core/symbol did not conform to spec:
;;   In: [0] val: 1 fails at: [:args :separate :ns] predicate: string?
;;   In: [0] val: 1 fails at: [:args :str] predicate: string?
;;   In: [0] val: 1 fails at: [:args :sym] predicate: symbol?
;;   :clojure.spec/args  (1)
;;   :clojure.spec/failure  :instrument

;; check
(stest/check `symbol)
;;=> ({:spec #object[...],
;;     :clojure.spec.test.check/ret {:result true,
;;                                   :num-tests 1000,
;;                                   :seed 1484554638749},
;;     :sym clojure.core/symbol})

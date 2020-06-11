(ns gyfu.xpath-spec
  (:require [clojure.spec :as s]
            [clojure.spec.test :as stest]
            [gyfu.xpath :as xpath])
  (:import (net.sf.saxon.s9api XPathCompiler XdmValue)
           (gyfu.saxon QNameable)))

(s/def ::prefix string?)
(s/def ::uri string?)
(s/def ::namespace (s/keys :req-un [::prefix ::uri]))

;; TODO: Instaparse XPath expression in spec?
(s/def ::xpath-expression string?)
(s/def ::xpath-compiler (partial instance? XPathCompiler))
(s/def ::xdmvalue (partial instance? XdmValue))

;; TODO
;;
;; This should validate that the first item in a pair satisfies QNameable and that the second item in the pair is either
;; an XdmNode or has an XdmAtomicValue constructor, but I couldn't figure out how to write a spec like that yet.
(s/def ::binding #(even? (count %)))
(s/def ::bindings (s/* ::binding))

(s/def ::xpath-fn-args
  (s/and
   (s/cat :compiler   ::xpath-compiler
          :context    ::xdmvalue
          :expression ::xpath-expression
          :bindings   ::bindings)))

(s/fdef xpath/select
        :args ::xpath-fn-args :ret ::xdmvalue)

(s/fdef xpath/match
        :args ::xpath-fn-args :ret ::xdmvalue)

(s/fdef xpath/is?
        :args ::xpath-fn-args :ret boolean?)

(s/fdef xpath/value-of
        :args ::xpath-fn-args :ret string?)

(stest/instrument `xpath/select)
(stest/instrument `xpath/match)
(stest/instrument `xpath/is?)
(stest/instrument `xpath/value-of)


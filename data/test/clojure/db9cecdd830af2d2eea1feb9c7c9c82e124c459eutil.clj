(ns hara.event.condition.util
  (:require [hara.event.common :as common]))

(def sp-forms {:anticipate '#{catch finally}
               :raise      '#{option default catch finally}
               :raise-on   '#{option default catch finally}
               :manage     '#{on on-any option}})

(defn is-special-form
  ""
  ([k form]
     (and (instance? clojure.lang.ISeq form)
          (symbol? (first form))
          (contains? (sp-forms k) (first form))))
  ([k form syms]
     (if (list? form)
       (or (get syms (first form)) (is-special-form k form)))))

(defn parse-option-forms
  ""
  [forms]
  (into {}
        (for [[type key & body] forms
              :when (= type 'option)]
          [key `(fn ~@body)])))

(defn parse-default-form
  ""
  [forms]
  (if-let [default (->> forms
                        (filter
                         (fn [[type]]
                           (= type 'default)))
                        (last)
                        (next))]
    (vec default)))

(defn parse-on-handler-forms
  ""
  [forms]
  (vec (for [[type chk bindings & body] forms
             :when (= type 'on)]
         (let [chk (if (= chk '_)
                     (quote '_)
                     chk)]
           {:checker chk
            :fn (common/handler-form bindings body)}))))

(defn parse-on-any-handler-forms
  ""
  [forms]
  (vec (for [[type bindings & body] forms
             :when (= type 'on-any)]
         {:checker (quote '_)
          :fn (common/handler-form bindings body)})))

(defn parse-try-forms
  ""
  [forms]
  (vec (for [[type & body :as form] forms
             :when (#{'finally 'catch} type)]
         form)))

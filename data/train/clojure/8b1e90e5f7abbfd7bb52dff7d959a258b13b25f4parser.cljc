(ns xact.parser
  (:require [clojure.spec :as s]
            [xact.schema :as schema]
            [xact.util :refer [invariant]]
            #?(:cljs goog.log)))

(s/def ::key-spec keyword?)

(s/def ::parameterized-key
  (s/and seq?
         (s/cat :key ::key
                :params map?)))

(s/def ::key
  (s/conformer
    (fn [val]
      (if (s/valid? ::key-spec val)
        {:dispatch-key val}
        (let [param-key (s/conform ::parameterized-key val)]
          (if-not (s/invalid? param-key)
            (merge (:key param-key)
                   {:params (:params param-key)})
            ::s/invalid))))
    (fn [{:keys [dispatch-key params]}]
      (if-not (nil? params)
        (list dispatch-key params)
        dispatch-key))))

(s/def ::mutation
  (s/and seq?
        (s/cat :dispatch-key symbol?
               :params (s/? map?))))

(s/def ::join-spec
  (s/and map?
         #(== (count %) 1)
         (s/map-of ::key ::query-root)))

(declare expr->ast)

(s/def ::join
  (s/conformer
    (fn [join]
      (if (s/valid? ::join-spec join)
        (let [entry (first join)
              query (val entry)]
          {:dispatch-key (key entry)
           :query query
           :children (into [] (map expr->ast) query)})
        ::s/invalid))
    (fn [{:keys [dispatch-key query]}]
      {dispatch-key query})))

(s/def ::expr-spec
  (s/or :key ::key
        :join ::join
        ;; TODO: this is wrong, read queries can't have mutations
        :mutation ::mutation))

(s/def ::expr
  (s/conformer
    #(s/conform ::expr-spec %)
    (fn [{:keys [type] :as ast}]
      (s/unform ::expr-spec [type ast]))))

(s/def ::query-root
  (s/and vector?
         (complement empty?)
         (s/coll-of ::expr)))

(defn expr->ast
  [expr]
  (let [ret (s/conform ::expr expr)]
    ;; TODO: probably also throw here
    (invariant (not (s/invalid? ret)) (str "Not valid: " expr))
    (assoc (val ret) :type (key ret))))

(defn ast->expr
  [ast]
  (s/unform ::expr ast))

(defn query->ast [query]
  {:type :root
   :children (into [] (map expr->ast) query)})

(defn ast->query [{:keys [children]}]
  (into [] (map ast->expr) children))

(defn parse [env q]
  (letfn [(step [ret expr]
            (let [{:keys [dispatch-key query params] :as ast} (expr->ast expr)
                  env (assoc env
                        :query query
                        :ast ast)
                  handler (schema/handler dispatch-key)]
              (when (nil? handler)
                ;; TODO: maybe we should just assoc an error or allow providing
                ;; a default handler for unrecognized keys
                (throw (ex-info (str "No handler for key: " dispatch-key) {:key dispatch-key})))
              (assoc ret dispatch-key (handler env dispatch-key))))]
    (reduce step {} q)))

(ns ribol.cljs)

(defn- hash-map?
  [x] (instance? clojure.lang.APersistentMap x))

(defn- hash-set?
 [x] (instance? clojure.lang.APersistentSet x))

(defmacro error
  ([e] (list 'throw (list 'js/Error. (list 'str e))))
  ([e & more]
    (list 'throw (list 'js/Error. (concat (list 'str e) more)))))

(defmacro continue [& body]
  `{::type :continue ::value (do ~@body)})

(defmacro default [& args]
 `{::type :default ::args (list ~@args)})

(defmacro choose [label & args]
 `{::type :choose ::label ~label ::args (list ~@args)})

(defmacro fail
 ([] {::type :fail})
 ([contents]
    `{::type :fail ::contents ~contents}))

(def sp-forms {:anticipate #{'catch 'finally}
               :raise #{'option 'default 'catch 'finally}
               :raise-on #{'option 'default 'catch 'finally}
               :manage #{'on 'on-any 'option}})

(defn- is-special-form
  ([k form]
     (and (list? form)
          (symbol? (first form))
          (contains? (get sp-forms k) (first form))))
  ([k form syms]
     (if (list? form)
       (or (get syms (first form)) (is-special-form k form)))))

(defn- parse-option-forms [forms]
  (into {}
        (for [[type key & body] forms
              :when (= type 'option)]
          [key `(fn ~@body)])))

(defn- parse-default-form [forms]
  (if-let [default (->> forms
                        (filter
                         (fn [[type]]
                           (= type 'default)))
                        (last)
                        (next))]
    (vec default)))

(defmacro escalate [contents & forms]
  (let [[contents forms]
        (if (is-special-form :raise contents)
          [nil (cons contents forms)]
          [contents forms])]
    `{::type :escalate
      ::contents ~contents
      ::options ~(parse-option-forms forms)
      ::default ~(parse-default-form forms)}))

(defmacro raise
  "Raise an issue with the content to be either a keyword, hashmap or vector, optional message
  and raise-forms - 'option' and 'default'"
  [content & [msg & forms]]
  (let [[msg forms] (if (is-special-form :raise msg)
                      ["" (cons msg forms)]
                      [msg forms])
        options (parse-option-forms forms)
        default (parse-default-form forms)]
    (list 'let ['issue# (list 'ribol.cljs/create-issue content msg options default)]
       (list 'ribol.cljs/raise-loop 'issue# 'ribol.cljs/*managers*
                   (list 'merge (list :optmap 'issue#) 'ribol.cljs/*optmap*)))))

(defn- parse-on [chk params body]
 (let [bind (cond (vector? params)   [{:keys params}]
                  (hash-map? params) [params]
                  (symbol? params)    [params]
                  :else (throw (Exception. (str "params " params " should be a vector hashmap or symbol"))))]

   {:checker chk
    :fn `(fn ~bind ~@body)}))

(defn- parse-on-handler-forms [forms]
 (vec (for [[type chk params & body] forms
            :when (= type 'on)]
        (let [chk (if (= chk '_) (quote '_) chk)]
          (parse-on chk params body)))))

(defn- parse-on-any-handler-forms [forms]
 (vec (for [[type params & body] forms
            :when (= type 'on-any)]
        (parse-on (quote '_)  params body))))

(defn- parse-try-forms [forms]
 (for [[type & body :as fform] forms
       :when (#{'finally 'catch} type)]
   fform))

(defmacro manage
 "This creats the 'manage' dynamic scope form. The body will be executed
 in a dynamic context that allows handling of issues with 'on' and 'option' forms."
 [& forms]
 (let [sp-fn #(is-special-form :manage % #{'finally 'catch})
       body-forms (vec (filter (complement sp-fn) forms))
       sp-forms (filter sp-fn forms)
       id (keyword (gensym))
       options  (parse-option-forms sp-forms)
       on-handlers (parse-on-handler-forms sp-forms)
       on-any-handlers (parse-on-any-handler-forms sp-forms)
       try-forms (parse-try-forms sp-forms)
       optmap (zipmap (keys options) (repeat id))
       manager {:id id
                :handlers (vec (concat on-handlers on-any-handlers))
                :options options}]
   (list 'binding ['ribol.cljs/*managers* (list 'cons manager 'ribol.cljs/*managers*)
                   'ribol.cljs/*optmap* (list 'merge optmap 'ribol.cljs/*optmap*)]
      (concat 
        ['try
         (concat
           ['try]
           body-forms
           [(list 'catch 'ExceptionInfo 'ex#
            (list 'ribol.cljs/manage-signal manager 'ex#))])]
        try-forms))))

(defn- make-catch-forms [exceptions sp-forms]
    (cons
     (list 'catch 'ExceptionInfo 'e#
                 (concat '[ribol.cljs/raise [(ex-data e#) {:origin e#}]] sp-forms))
     (map (fn [ex]
            (list 'catch (:type ex) 't#
                  (concat ['ribol.cljs/raise [(:content ex) {:origin 't#}]] sp-forms)))
          exceptions)))

(defn- make-catch-elem [[ex content]]
    (cond (symbol? ex) [{:type ex :content content}]
          (vector? ex) (map (fn [t] {:type t :content content})
                            ex)
          :else (throw (Exception.
                         (str "RAISE_ON: " ex
                              " can only be a classname or vector of classnames")))))

(defn- make-catch-list [bindings]
  (mapcat make-catch-elem (partition 2 bindings)))

(defmacro raise-on
    "Raises an issue with options and defaults when an exception is encountered
  when the body has been evaluated"
    [bindings form & forms]
    (let [exceptions (make-catch-list bindings)
          raise-on-fn #(is-special-form :raise-on % #{'catch 'finally})
          raise-fn    #(is-special-form :raise % #{'catch 'finally})
          forms (cons form forms)
          body-forms (filter (complement raise-on-fn) forms)
          raise-on-forms (filter raise-on-fn forms)
          try-forms (filter (complement raise-fn) raise-on-forms)
          raise-forms (filter raise-fn raise-on-forms)
          catch-forms (make-catch-forms exceptions raise-forms)]
      `(try ~@body-forms ~@catch-forms ~@try-forms)))

(defmacro raise-on-all [content form & forms]
  "Raises an issue with options and defaults when any exception is encountered
  as the body is being evaluated"
  (concat ['ribol.cljs/raise-on ['js/Object content] form] forms))

(defn- parse-anticipate-pair [[extype res]]
  (cond (hash-set? extype)
        (mapcat #(parse-anticipate-pair [% res]) extype)

        (symbol? extype)
        `((catch ~extype t# ~res))

        (or (keyword? extype) (hash-map? extype) (vector? extype))
        `((catch ~'ExceptionInfo t#
            (if (check-contents (ex-data t#)
                                ~extype)
              ~res
              (throw t#))))))

(defmacro anticipate [exvec & body]
  "Anticipates exceptions and decides what to do with them"
  (let [pairs (partition 2 exvec)
        anticipate-fn    #(is-special-form :anticipate % #{'catch 'finally})
        body-forms (filter (complement anticipate-fn) body)
        try-forms (filter anticipate-fn body)
        catches (mapcat parse-anticipate-pair pairs)]
    `(try ~@body-forms
          ~@catches
          ~@try-forms)))

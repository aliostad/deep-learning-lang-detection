(ns algebra.signature.monoid
  (:refer-clojure :exclude [name])
  (:require [potemkin :refer :all]
            [algebra.signature.magma :as magma]
            [clojure.tools.logging :as log :only [debug info]]))

(clojure.core/println "loading algebra.signature.monoid")

(import '(algebra.signature.magma.Operators))

;(import-vars [algebra.signature [magma]])
;; (import-fn magma/mag)
;; (import-fn magma/magfn)

;;(defn foo [] (Operators/magfn 3 3 4))

;; constants
(def id (atom 0))

;; operators
(defprotocol Operators
  "Operator Signature for Monoids"
  (typ [a] [t a])
;  (idem [a] [t a])
  (structure [a] [t a]) ;; returns Keyword
  (** [a b] [t a b])
  (constants [t]))

;; laws
(declare dispatch-type get-struct-kw try-load-model)

(defn closure
  [a]
  (log/info "monoid law: associativity" a)
  (let [dt (dispatch-type)
        log (log/debug "dispatch type: " dt)]
    (if-let [t (= (typ a) (class dt))]
      true
      (throw (RuntimeException. (str "dt: " (class dt) " not= " (class a)))))))

(defn associativity
  [a b c]
  (log/info "monoid law: associativity")
  (let [s1 (** (** a b) c)
        s2 (** a (** b c))]
    (log/debug "(a * b) * c " s1)
    (log/debug "a * (b * c) " s2)
    (println "(a ** b) ** c = a ** (b ** c) ?  " (= s1 s2))))

(require '(algebra.models.monoid))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; meta operations - part of the public sig, but constant across models (i.e. non-semantic ops)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def installed-structs
  (array-map
   :default 'algebra.structure.monoid.default
   :n0 'algebra.structure.monoid.N0
   :n1 'algebra.structure.monoid.n1
   :quotient-3 'algebra.structure.monoid.q3
   ))

(def ^:dynamic *active-model* :default)

;; map struct keys to dispatch param objects
;; FIXME: call this struct-types? it represents the type of the
;; underlying structure, which happens to be used for dispatch
(defonce dispatch-types (atom {}))

(defn dispatch-type ;; FIXME struct-type?
  "Gets the struct object for a keyword or struct.  The struct object
  will be used to parameterize Group operations by struct type; in
  effect this is a way of dynamically selecting a model to determine
  the interpretion of an operation.

  Arg is keyword-or-struct (kors)."
  ([]
   (do
     ;; (log/debug "dispatch-type 0")
     (dispatch-type *active-model*)))
  ([kors]
   (do
     ;; (log/debug "dispatch-type 1" kors)
    (let [k (get-struct-kw kors)
          ;; log (log/debug "struct k: " k)
          obj (@dispatch-types k)
          ;; log (log/debug "struct: " obj)
          ]
      (if k
        (or obj
           (if (try-load-model k) (@dispatch-types k))
           ;; Why? (when-not (keyword? m) m)
           nil)
        nil)))))

(declare try-load-model get-struct-kw dispatch-type)

(defn activate!
  "Set the active model, which determines interpretation of Group ops.  Arg is key-or-struct."
  ([kors]
   (log/debug "activate!: " kors)
    (when (keyword? kors)
      (let [m (try-load-model kors)
            log (log/debug "m: " m)
            c (constants m)
            e (:id c)
            kw (get-struct-kw kors)]
        (log/debug "loaded model: " m)
        (alter-var-root (var *active-model*)
                        (fn [_] kw))
        (log/debug "*active-model*: " *active-model*)
        (log/debug "dispatch-types: " @dispatch-types)
        (log/debug "@id: " @id " to " e)
        (reset! id e)
        (log/debug "@id: " @id)
        ;; (alter-var-root (var *id*)
        ;;                 (fn [_] e))

        ))))

(defn install!
  "Registers a structure (in the form of an object of the struct type) for use in a model."
  ([sobj]  ;; structure object
   (do
     (log/debug "install 1: " sobj (type sobj))
     (let [kw (structure sobj)]
       (log/debug "install 1 kw: " kw)
       (install! kw sobj))))
  ([key sobj]
   (do
     (log/debug "install 2: " key sobj)
     (if (keyword? key)
       (do
         (log/info (str "dispatch-types: " @dispatch-types))
;         (log/info (str "registering " (name sobj), ", model type: " (class sobj)))
         (swap! dispatch-types assoc key sobj)
         (log/info (str "dispatch-types: " @dispatch-types))
         )
       (throw (RuntimeException. "arg1 must be clojure keyword"))))))

(defn active-model? [t]
  (log/debug "active-model?" t)
  )

(defn active-model [t]
  (log/debug "active-model")
  *active-model*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defn- get-struct-kw
  "Returns keyword for struct"
  [struct]
  ;; (log/debug "get-struct-kw: " struct)
  (if (keyword? struct)
    struct
    ;; else invoke `structure` op on implementation
    (structure struct)))

(defn- try-load-model
  ([k]
   (log/debug "try-load-model: " k)
   (log/debug "    dispatch-types: " @dispatch-types)
   (log/debug "    installed-structs: " installed-structs)
   (if-let [model (@dispatch-types k)]
     (do
          (log/debug "model: " model)
          model)
     (if-let [ns-sym (installed-structs k)]
       (do
         (log/debug "ns-sym: " ns-sym)
         (try
           ;; NOTE: in core.matrix, implementations are expected to
           ;; register on load, so they populate dispatch-types
           ;; appropriately when :required.
           (do (require ns-sym)
               (@dispatch-types k))
           (catch Throwable t nil)))
       ;; (log/debug "struct " k "not found")
       ))))

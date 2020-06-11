(ns vinzi.hib-connect.globals
  (:import java.util.Date)
  (:import java.sql.Timestamp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Functions for debugging
;;

(defmacro hib_prl [& args]
;;  (apply println args)  (flush)
  )
(defmacro br_pr [& args]
;;  (apply println args)  (flush)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Atoms used to store a list of translators
;;  And the functions to manage and use this lists.
;;

(def to-java (atom {}))
(def to-clj (atom {}))


(defn get-type-id
  "The 'get-type-id' is used to retrieve the class/type of a function.
   It takes the 'str' of type because otherwise multiple definitions
   result in different keys (however, the string-representation is the same)."
  [obj]
  ;; Warning: don't use keywords, as the keyword of type always equals nil
  (str (type obj)))

(defn add-to-clj
  "The type of 'obj' is determined and it is stored in the atom 'to-clj'."
  [obj translateFunc]
  (let [cls (get-type-id obj)] 
    (swap! to-clj #(assoc % cls translateFunc))))

(defn get-to-clj
  "Look up the translator to tranforma java-object 'obj' to a clojure structure"
  [obj]
  (let [cls (get-type-id obj)
	func (get @to-clj cls)]
    (when (nil? func)
      (println "The translator to clojure for class " cls " could not be found!")
      (assert func))
    func))

(defn add-to-java
  "The type of 'obj' is determined and it is stored in the atom 'to-java'."
  [obj translateFunc]
  (let [cls (get-type-id obj)] 
    (swap! to-java #(assoc % cls translateFunc))))

(defn get-to-java
  "Look up the translator to tranforma java-object 'obj' to a clojure structure"
  [obj]
  (let [cls (get-type-id obj)
	func (get @to-java cls)]
    (when (nil? func)
      (println "The translator to clojure for '" cls "' could not be found!")
      (println "  the object is: " obj)
      (assert func))
    func))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Functions for translation between the clojure and java domain.
;;


(defn transferGenerator
  "The generaric translator (closure). Currently there are two instances,
    ie.  trans-to-Clj and trans-to-java."
  [transGen]
  (fn [rec] (let [translator (transGen rec)]
    (when (nil? translator)
      (hib_prl "No translator found for ttem " rec)
      (flush)
      (assert translator))
    (translator rec))))

;; translates a java-object to a clj-instance.
(def gl_trans-to-clj (transferGenerator get-to-clj))


(defn transl-obj-array-to-clj
  "Hibernate SELECT statements can return an list of object arrays. This
   translater translates the contents of the object array to the clj-domain."
  [objs]
  (map gl_trans-to-clj objs))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Default translators
;;  Add some default (identity) translators for the (immutible) java base types.
;;


(defn inspect-obj [obj]
  (println "Waring: received an object with class: " (class obj))
  (println "Visible fields are: "
	   (map #(.getName %) (seq (.getFields (class obj)))))
  (println "Returning object unmodified")
  obj)


(defn- init-to-clj-translators []
  (letfn [(init-numeric-types []
			 ;; Long can not be constructed from value!
			 ;; Constructor (Long. int) does not exist
			 (add-to-clj (Long. "1") identity)
			 (add-to-clj (Byte. "1") identity)
			 (add-to-clj (Short. "1") identity)
			 
			 (add-to-clj (Integer. 1) identity)
			 (add-to-clj (Float. 1.0) identity)
			 (add-to-clj (Double. 1.0) identity))
	  (init-date-types []
			   (add-to-clj (Date.) identity)
			   (add-to-clj (Timestamp. 0) identity))
	  (init-char-types []
			   (add-to-clj ""  identity)
			   (add-to-clj (Character. \c)  identity))
	  (init-object-types []
			    (add-to-clj (Object.) inspect-obj)
			    (add-to-clj (to-array '()) transl-obj-array-to-clj))]
	  (init-numeric-types)
	  (init-date-types)
	  (init-char-types)
	  (init-object-types)
	  nil))

(init-to-clj-translators)
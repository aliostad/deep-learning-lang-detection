(ns multimethods)

;; dispatch method
(defn dispatch [m] (:os m))

;; the multi-method
(defmulti cool dispatch)

(dispatch {:os ::unix})

;; implementation for unix
(defmethod cool ::unix [m]
  (do
    (println "UNIX is cool!")
    true))

;; implementation for bsd
(defmethod cool ::bsd [m]
  (do
    (println "BSD is coolish!")
    true))

;; implementation for windows
(defmethod cool ::windows [m]
  (do
    (println "Windows is not cool!")
    false))

(cool {:os ::windows})

;; linux extends unix
(derive ::linux ::unix)

;; osx extends unix
(derive ::osx ::unix)

;; osx also extends bsd
(derive ::osx ::bsd)

(isa? ::linux ::unix)

;; resolve multiple inheritance issue
(prefer-method cool ::unix ::bsd)

(cool {:os ::osx})
(cool {:os ::bsd})

((juxt + - / *) 1 2)



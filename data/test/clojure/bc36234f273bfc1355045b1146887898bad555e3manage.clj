(ns zhuli.manage
 (:require [zhuli.path :as path] [zhuli.mass.core :as mass])) 

(defn scan [path extention]
  (if (path/dir? path)
    (cons path (filter #(not (nil? %)) (map #(scan (path/join path %) extention) (path/listdir path))))
	(if (.endsWith path extention)
	    (list path (path/modified path))
		nil)))
		
(defmacro time-elapsed [action & all]
  (let [start (gensym 'start') result (gensym 'result')]
  `(let [~start (System/currentTimeMillis) ~result (do ~@all)]
	(println (str ~action " takes " (- (System/currentTimeMillis) ~start) " ms"))
	~result)))

; watch a source code directory, and call functions when source is changed
; each target is a map
; eg. {:path "hello/src" :extention ".cljs" :callback some-function}
; callback is the function to call when there is change in source      

(defn watch-source [& targets]
  (let [scan-target (fn [target] (scan (:path target) (:extention target)))]
    (loop [results (map scan-target targets)]
      (let [new-results (map scan-target targets)]
        ;(println new-results)
	(dorun (map 
          (fn [new-result result target]
            (if (not (= new-result result))
	      ((:callback target)) ; call the callback function
	      nil))
          new-results results targets))
	(Thread/sleep 500)
	(recur new-results)))))

;src-path may be a file or a directory, so is out-path
(defn mass-build [src-path out-path]
  (if (path/dir? src-path)
    (dorun (map #(mass-build (path/join src-path %) (path/join out-path %)) (path/listdir src-path)))
    (if (.endsWith src-path ".mass")
      (do (println "compiling" src-path) (mass/compile-file src-path (clojure.string/replace out-path #"\.mass" ".css")))
      nil)))
(defn print-exception [e]
  (println (.getMessage e))
  (let [cause (.getCause e)]
    (if (not (nil? cause))
      (do
        (println "is caused by:")
        (print-exception cause))
      nil)))

(defn watch-project [cljs-build-callback]
  (watch-source 
    {:path "src" :extention ".cljs" :callback 
      (fn []
        (println "compiling ClojureScript source...")
        (try
          (cljs-build-callback)
          (catch Exception e (print-exception e)))
        (flush))}
    {:path "mass_src" :extention ".mass" :callback 
      (fn []
        (try 
          (mass-build "mass_src" "mass_out")
          (catch Exception e (print-exception e)))
        (flush))}))



(defn test-watch-source []
  (watch-source {:path "hello_world\\src" :extention ".cljs" :callback (fn [] (println "clojure sciprt source change."))}
                {:path "hello_world\\mass_src" :extention ".mass" :callback (fn [] (println "mass source change."))}))

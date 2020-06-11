(ns yatrace.core.command
  (:require [clojure.string :as s]
            [clojure.java.io :as io]
            [yatrace.core.instrument :as instrument]
            [yatrace.core :as core]
            [yatrace.helper :as helper])
  (:use [clojure.pprint :only [ pprint]])
  (:import [java.lang.instrument Instrumentation]))

(defn- make-method-filter
  [class-method]
  (cond (string? class-method)
        (let [method  (second (s/split class-method #"\."))]
          (if (nil? method)
            (constantly true)
            (fn [cn mn]
              (#{method} mn))))
        :else
        (let [[_ method-filter] class-method]
          method-filter)))

(defn- make-class-filter
  [class-method]
  (cond
   (string? class-method)
   #{(first (s/split class-method #"\."))}
   :else
   (let [[class-filter _] class-method]
     class-filter)))

(defn- default-handler [evt]
  (pprint (helper/to-tree (:ctx evt))))

(defn trace [class-method & {:keys [package handler background], :or {package ".*" handler default-handler background false}}]
  (let [lock (Object.)]
    (locking lock 
      (let [method-filter (make-method-filter class-method)
            class-filter (make-class-filter class-method)
            classes (instrument/get-candidates core/instrumentation class-filter  :package package)
            transformer (instrument/class-trace-transformer method-filter class-filter)
            reset-task (doto
                           (Thread. #(locking lock
                                       (instrument/reset-class core/instrumentation transformer (instrument/get-candidates core/instrumentation class-filter :package package))))
                         (.setDaemon true)
                         (.start))
            transform-task (future
                             (instrument/probe-class core/instrumentation transformer classes))]
        @transform-task
        (core/reset-queue)
        (doseq [evt (repeatedly core/take-queue)]
          (do (println (apply str (repeat 40 "=")))
              (println (format "%s event from %s@%H" (name (:type evt)) (class (:thread evt)) (.hashCode (:thread evt))))
              (handler evt)
              (when (instance? Throwable (get-in evt [:ctx :result-or-exception]))
                (.printStackTrace ^Throwable (get-in evt [:ctx :result-or-exception]) *out*))))))))

(defn- resource-name-of [^Class klass]
  (-> (.getName klass)
      (s/replace \. \/)
      ((partial str "/") ".class")))

(defn- location-of [^Class klass]
  (let [code-source (-> klass
                        (.getProtectionDomain)
                        (.getCodeSource))]
    (if (not (nil? code-source))
      (.getLocation code-source)
      (.getResource klass (resource-name-of klass))))
  )

(defn- source-of [^Class klass]
  (let [s (location-of klass)]
    (if (.exists (io/file s))
      s
      nil)))

(defn- native-string [o]
  (if (nil? o)
    nil
    (format "%s@%H" (.getName (type o)) (.hashCode o))))

(defn- to-string-or-native-string [o]
  (let [s (str o)
        try-native? (not (.startsWith s (str
                                          (.getName (type o))
                                          "@")))]
    (if try-native?
      (native-string o)
      s)))

(defn- print-classloader-tree
  ([^ClassLoader loader]
      (print-classloader-tree loader "-"))
  ([^ClassLoader loader indents]
     (if (nil? loader)
       nil
       (do
         (println indents (to-string-or-native-string loader))
         (recur (.getParent loader) (str "  " indents))))))

(defn loaded [class-name & {:keys [verbose] :or {verbose false}}]
  (let [class-filter (make-class-filter class-name)
        classes (instrument/get-candidates core/instrumentation class-filter)]
    (doseq [^Class klass classes]
      (println  (.getName klass) "->" (source-of klass))
      (if verbose
        (print-classloader-tree (.getClassLoader klass)))
      (println))))
;;  LocalWords:  ns pprint defn cond fn











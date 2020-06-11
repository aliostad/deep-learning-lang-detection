(ns arduinofun.core
  (:gen-class)
  (:use [overtone.live]
        [overtone.inst.piano]))

  


(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

(def usb-tty "tty.usbmodem1421")
(def usb-t "cu.usbmodem1421")




(def buffers-atom (atom []))
(def n 1024) ; 1 KiB

(defn exhaust-stream
  ([stream n] (exhaust-stream stream n '()))
  ([stream n buf-so-far]
   (let [new-buf (byte-array n)
         read-len (.read stream new-buf)
         buf-with-new (concat buf-so-far (take read-len new-buf))]
     
     (if (< read-len n)
       buf-with-new
       (recur stream n buf-with-new)))))

(defn do-stuff []
  (println 0)
  (piano (note :c3)))

(defn funfun [x]
  (cond 
    (= x 48) (println 0)
    (= x 49) (do-stuff)
    :default nil)) 
#_(require '[serial.core :as serial])
#_(def port (serial/open usb-tty :baud-rate 9600))
#_(serial/listen! port (fn [stream] (swap! buffers-atom concat (exhaust-stream stream n))))
#_(serial/listen! port (fn [stream] (funfun (.read stream))))



(ns org.jmonde.otp
  (:gen-class))

(defn- input-stream [file]
  (java.io.BufferedInputStream. (java.io.FileInputStream. file)))

(defn- output-stream [file]
  (java.io.BufferedOutputStream. (java.io.FileOutputStream. file)))

(defn- seed [args]
  (let [k (map #(- (long %) 31) (apply str (interpose " " args)))]
    (reduce #(+' (*' 100 %) %2) 0 k)))

(defn -main [& args]
  (let [r (java.util.Random. (unchecked-long (seed args)))
        max (int 256)]
    (with-open [^java.io.BufferedInputStream input (input-stream java.io.FileDescriptor/in)
                ^java.io.BufferedOutputStream output (output-stream java.io.FileDescriptor/out)]
      (loop [x (.read input)]
        (if (< x 0)
          0
          (let [y (int (bit-xor (.nextInt r max) x))]
            (.write output y)
            (recur (.read input))))))))

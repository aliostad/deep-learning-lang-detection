(ns dameon.visual-cortex.stream-test
  (require [dameon.visual-cortex.stream :as stream]
           [dameon.smart-atom :as smart-atom])
  (use clojure.test))

(import '[org.opencv.core Mat CvType])


(deftest test-update-mat
  (let [foo (atom 1) bar (atom 1)
        mat (Mat. 200 200 CvType/CV_8UC3)
        stream (stream/->Base-stream

                [(stream/->Base-stream
                  []
                  [(fn [obj]
                     (do (smart-atom/delete (:smart-mat obj))
                         (swap! bar (fn [b] identity :derp))))]
                  :bar)]

                [#(do (swap! foo (fn [f] identity :changed)) (smart-atom/delete (:smart-mat %1)))]

                :foo)]
    (stream/update-mat stream (smart-atom/create mat))
    (Thread/sleep 1000)
    (is (= @foo :changed))
    (is (= @bar :derp))
    (is (.empty mat))))

(run-tests)

(ns tensor.core-test
  (:require [tensor.core :refer :all]
            [clojure.test :refer :all]))

(deftest load-env-opts
  (testing "that the env map is correctly updated based on given options"
    (are [opts result-env] (= result-env
                              (#'tensor.core/update-env opts {:a :a :b :b :c :c}))
         ;; :env option replaces any detected environment
         {:env {:e :e}} {:e :e}
         ;; :env option takes precedence over all other :env-* options
         {:env {:e :e} :env-only :a :env-include {:d :d} :env-exclude :b} {:e :e}
         {:env-only :a} {:a :a}
         {:env-only [:a]} {:a :a}
         {:env-only [:a :b]} {:a :a :b :b}
         {:env-include {:e :e}} {:a :a :b :b :c :c :e :e}
         {:env-include {:a :e}} {:a :e :b :b :c :c}
         {:env-exclude :a} {:b :b :c :c}
         {:env-exclude [:a]} {:b :b :c :c}
         ;; :env-only takes precedence over :env-exclude
         {:env-only :a :env-include {:d :d} :env-exclude :b} {:a :a :d :d}
         ;; k/v pairs added with :env-include are not affected by :env-only or :env-exclude
         {:env-only :a :env-include {:d :d}} {:a :a :d :d}
         {:env-include {:d :d} :env-exclude :b} {:a :a :c :c :d :d})))


(deftest resolve-and-load-streamspec
  (binding [*streams* (atom (into
                             {}
                             (map (fn [sname]
                                    {sname
                                     (fn [env & args]
                                       {:name sname
                                        :env env
                                        :args args})})
                                  [:a/stream
                                   :b/stream
                                   :c/stream
                                   :d/stream])))]

    ;; (a/stream :a 1 2 "a" "b" (b/stream :b c/stream "e" (d/stream "aa" prn :e)))
    (is (=
         {:name :a/stream
          :env {:blarg :honk}
          :args [:a 1 2 "a" "b"
                 {:name :b/stream
                  :env {:blarg :honk}
                  :args [:b
                         {:name :c/stream
                          :env {:blarg :honk}
                          :args nil}
                         "e"
                         {:name :d/stream
                          :env {:blarg :honk}
                          :args ["aa" 'prn :e]}]}]}
         (load-stream-fn
          'a/stream
          {:blarg :honk}
          '(:a 1 2 "a" "b" (b/stream :b c/stream "e" (d/stream "aa" prn :e))))))

    ;; a/stream
    (is (= {:name :a/stream
            :env {:blarg :honk}
            :args nil}
           (load-stream-fn 'a/stream {:blarg :honk})))

    ;; (a/stream locally-bound-symbol)
    (is (= {:name :a/stream
            :env {:blarg :honk
                  :locally-bound-symbol :foo}
            :args ['locally-bound-symbol]}
           (load-stream-fn 'a/stream
                           {:blarg :honk :locally-bound-symbol :foo}
                           '(locally-bound-symbol))))

    ;; (a/stream c/stream)
    (is (= {:name :a/stream
            :env {:blarg :honk}
            :args [{:name :c/stream
                    :env {:blarg :honk}
                    :args nil}]}
           (load-stream-fn 'a/stream {:blarg :honk} '(c/stream))))))

(deftest load-streams-fn-tests
  (testing "Ensure regression hasn't occurred and load-streams-fn isn't returning a lazy-seq"
    (with-redefs [load-stream-fn (fn [& _])]
      (is (realized? (load-streams-fn nil (range 100)))))))

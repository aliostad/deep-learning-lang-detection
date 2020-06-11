(ns is-algo-proto.main
  (:gen-class)
  (:use clojure.contrib.command-line))

(require '[is-algo-proto.core :as core])

(defn -main
  [& args]
  (with-command-line args
    "Usage: isalgo [-f json|svg] -i input.json -o output.json|svg"
    [[input i "name of the input dispatch file"]
     [format f "output format" "json"]
     [output o "output filename"]
     [priorities? p? "enable to just dump priorities"]]
     (let [scheduled-dispatch (core/task-schedule (core/read-json-file input))]
      (if priorities?
        (core/write-json-file ((core/debug-priorities scheduled-dispatch) :tasks) output)
        (case format
          "svg" (spit output (core/svg-schedule scheduled-dispatch))
          "json" (core/scheduled-dispatch-to-json-file scheduled-dispatch output))))))

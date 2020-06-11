;; Based on http://stackoverflow.com/a/16627950/17964
(ns try-travis.shell)

(defn- print-stream
  [stream]
  (let [stream-seq (->> stream
                        (java.io.InputStreamReader.)
                        (java.io.BufferedReader.)
                        line-seq)]
    (doseq [line stream-seq]
      (println line))))

;; Used in build process for executing cljsbuild, which may run long.
;; Streaming output provides immediate feedback rather than waiting
;; for output after the entire build process has completed.
(defn exec-stream
  "Executes a shell command, streaming stdout and stderr to shell"
  [command & args]
  (let [runtime  (Runtime/getRuntime)
        proc     (.exec runtime (into-array (cons command args)))
        stdout   (.getInputStream proc)
        stderr   (.getErrorStream proc)
        _        (future (print-stream stdout))
        _        (future (print-stream stderr))
        proc-ret (.waitFor proc)]
      proc-ret))

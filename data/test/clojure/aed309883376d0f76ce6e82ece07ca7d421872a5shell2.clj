;   Copyright (c) Rich Hickey. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file epl-v10.html at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns clojure.java.shell2
  "Use (sh ...) to launch a sub-process.  Pipe between
  processes and Clojure functions with (pipe ...)"
  (:use
    [clojure.java.io :only (as-file copy output-stream reader writer)]
    [clojure.string :only [join]])
  (:import
    [java.io ByteArrayOutputStream StringWriter StringReader
             PrintWriter PipedInputStream PipedOutputStream File]
    [java.nio.charset Charset]))

(def ^:dynamic *sh-dir* nil)
(def ^:dynamic *sh-env* nil)
(def ^:dynamic *encoding* "UTF-8")

;; The java.io.PipedInputStream uses by default a PIPE_SIZE (buffer) of 1 kb.
;; When processing large data-streams this results in lots of
;; thread-switching. Therefore we set the pipe-size to 32kb (hard-coded),
;; which resulted in approx 9x speed improvement on a 88 Mb data-stream.
;; We will introduced an adjustable parameters only if there is a real need.
(def pipe-size (* 32 1024))

(defmacro with-sh-dir
  "Sets the directory for use with sh, see sh for details."
  [dir & forms]
  `(binding [*sh-dir* ~dir]
     ~@forms))

(defmacro with-sh-env
  "Sets the environment for use with sh, see sh for details."
  [env & forms]
  `(binding [*sh-env* ~env]
     ~@forms))

(defmacro with-sh-encoding
  "Sets the encoding for use with sh"
  [enc & forms]
  `(binding [*encoding* ~enc]
     ~@forms))

(defn- parse-args
  [args]
  (let [default-opts {:out-enc *encoding* :in-enc *encoding*
                      :out :capture :err :capture
                      :dir *sh-dir* :env *sh-env*}
        [cmd opts] (if (coll? (first args))
                     [(first args) (rest args)]
                     (split-with string? args))]
    [cmd (merge default-opts (apply hash-map opts))]))

(defn- ^"[Ljava.lang.String;" as-env-strings
  "Helper so that callers can pass a Clojure map for the :env to sh."
  [arg]
  (cond
   (nil? arg) nil
   (map? arg) (into-array String (map (fn [[k v]] (str (name k) "=" v)) arg))
   true arg))

(defn- stream-to-bytes
  [in]
  (with-open [bout (ByteArrayOutputStream.)]
    (copy in bout)
    (.toByteArray bout)))

(defn- stream-to-string
  ([in] (stream-to-string in (.name (Charset/defaultCharset))))
  ([in enc]
     (with-open [bout (StringWriter.)]
       (copy in bout :encoding enc)
       (.toString bout))))

(defn- stream-to-enc
  [stream enc]
  (if (= enc :bytes)
    (stream-to-bytes stream)
    (stream-to-string stream enc)))

(defn- handle-stream
  "Based on opt, handle the given stream.  See the :out option to (sh) for the
   meaning of opt. In the fn case, the fn should accept one arg, which will be
   the OutputStream. Run in a thread, and the return value is returned
   immediately in a future."
  [opt strm-in system-stream enc]
  (future
    (cond
      (= opt :capture)
        (stream-to-enc strm-in enc)
      (= opt :pass)
        (copy strm-in system-stream :encoding enc)
      (instance? File opt)
        (with-open [os (output-stream opt)]
          (copy strm-in os :encoding enc))
      (fn? opt)
        (opt strm-in)
      ; otherwise, assume it is an OutputStream or Writer
      :else
        (copy strm-in opt :encoding enc))))

(defn- manage-process
  [proc input-future out out-enc err]
  (with-open [stdout (.getInputStream proc)
              stderr (.getErrorStream proc)]
    (let [out-value (handle-stream out stdout System/out out-enc)
          err-value (handle-stream err stderr System/err *encoding*)
          exit-code (.waitFor proc)]
      @input-future  ;make sure input is done, before checking out/err
      {:exit exit-code :out @out-value :err @err-value})))

(defn- manage-process-with-merge
  [proc input-future out out-enc err]
  (with-open [stdout (.getInputStream proc)
              stderr (.getErrorStream proc)
              pipe-out (PipedOutputStream.)
              pipe-in (PipedInputStream. pipe-out pipe-size)
	      ]
      (let [f-out (future (copy stdout pipe-out))
            f-err (future (copy stderr pipe-out))
            out-value (if (= out :merge)
                        (future nil)
                        (handle-stream out pipe-in System/out out-enc))
            err-value (if (= err :merge)
                        (future nil)
                        (handle-stream err pipe-in System/err *encoding*))
            exit-code (.waitFor proc)]
        ;make sure input is done, before checking out/err
        @input-future
        @f-out
        @f-err
        ; close pipe-out, or the out-value future will never complete
        (.close pipe-out)
        {:exit exit-code :out @out-value :err @err-value})))

(defn sh
  "Passes the given strings to Runtime.exec() to launch a sub-process.

  (sh command* options)

  command can either be inline Strings, or a Seq of Strings.

  Options are

  :in      May be given followed by any legal input source for
           clojure.java.io/copy, e.g. InputStream, Reader, File, byte[],
           or String, to be fed to the sub-process's stdin.
  :out     May be given followed by :capture, a File, :pass, :err, or a fn.
           For...
           - :capture - the sub-process's stdout will be stored in String or
             byte array as specified by :out-enc.
           - File - output is written to the file
           - :pass - sub-process's stdout is passed to the main process
             stdout.
           - :merge - send output to stderr
           - OutputStream or Writer - output is written to this stream/writer
           - fn - The fn is called with the stdout InputStream as an argument
             (stream is closed automatically). The fn is run in a Thread, but
             sh blocks until the Thread completes. This can be used, for
             example, to filter the stream.
           Defaults to :capture
  :err     Same as :out
  :in-enc  Option may be given followed by a String, used as a character
           encoding name (for example \"UTF-8\" or \"ISO-8859-1\") to
           convert the input string specified by the :in option to the
           sub-process's stdin.  Defaults to UTF-8.
           If the :in option provides a byte array, then the bytes are passed
           unencoded, and this option is ignored.
  :out-enc Option may be given followed by :bytes or a String. If a
           String is given, it will be used as a character encoding
           name (for example \"UTF-8\" or \"ISO-8859-1\") to convert
           the sub-process's stdout to a String which is returned.
           If :bytes is given, the sub-process's stdout will be stored
           in a byte array and returned.  Defaults to UTF-8.
  :env     Override the process env with a map (or the underlying Java
           String[] if you are a masochist).
  :dir     Override the process dir with a String or java.io.File.

  You can bind :env or :dir for multiple operations using with-sh-env
  and with-sh-dir. Streaming is managed through buffers.

  sh returns a map of
    :exit => sub-process's exit code
    :out  => sub-process's stdout (as byte[] or String)
    :err  => sub-process's stderr (String via platform default encoding)"
  [& args]
  (let [[cmd opts] (parse-args args)
        proc (.exec (Runtime/getRuntime)
               ^"[Ljava.lang.String;" (into-array cmd)
               (as-env-strings (:env opts))
               (as-file (:dir opts)))
        {:keys [in out err in-enc out-enc]} opts
        input-future (future
                       ; if input is provided, forward it to the proc
                       (if in (with-open [os (.getOutputStream proc)]
                                (copy in os :encoding in-enc))
                              (.close (.getOutputStream proc))))]
    (when (and (= out :merge) (= err :merge))
      (throw (IllegalArgumentException.
          "Both :out and :err can not be set to :merge.")))
    (if (or (= out :merge) (= err :merge))
      (manage-process-with-merge proc input-future out out-enc err)
      (manage-process proc input-future out out-enc err))))

(defn- form-starts-with-sym?
  "The first element of form is tested to see if it is a
  symbol that resolves to the value test-value. test-value
  is NOT expected to be a symbol."
  [form test-value]
  (and (or (list? form) (seq? form))
       (symbol? (first form))
       (when-let [first-var (resolve (first form))]
         (= (var-get first-var) test-value))))

(defn- test-and-close
  "Periodically (50 ms) test each future; if done, close it's in and out."
  [futures-and-outs]
  ; Usually the futures will be realized and their respective streams closed
  ; in order.  But if one fails, derefing it will allow a trapped Exception
  ; to escape and flow up the stack.
  (loop [remaining futures-and-outs]
    (let [filtered (filter
                     (fn [[in f out]]
                       (if (future-done? f)
                         (do (deref f)
                             (and out (.close out))
                             (and in (.close in))
                             false)
                         true))
                     remaining)]
      (when (pos? (count filtered))
        (Thread/sleep 50)
        (recur filtered)))))

(defmacro pipe
  "Each form is a (sh ...) form or a fn of two args (fn [in out] ...).
  Where you can read from in, and write to out. If a fn is first in the
  pipe, it is 1-arg (fn [out] ...).  If the fn is last, it is 1-arg
  (fn [in] ...).  See wrap and wrap-text-lines for some convenience
  functions that allow the use of simpler fns.

  All processes/fns are started in their own threads with data piped
  from one proc/fn to the next.  The threads will complete when the
  initial input stream closes and all subsequent procs/fns complete
  their work.

  Pipe will close all streams that _it_ opens.  Do not try to return or
  otherwise save the in or out streams given to one of the functions.

  Streaming is managed through buffers, so there may still be a delay."
  [& forms]
  (case (count forms)
    0 [nil]
    1 `[~@forms]
    (let [tail-form (last forms)
          middle-forms (-> forms rest butlast)
          head-form (first forms)

          ftail
            (if (form-starts-with-sym? tail-form sh)
              `#(~@tail-form :in %1)
              tail-form)
          fmiddle
            (map (fn [f]
                   (if (form-starts-with-sym? f sh)
                     `#(~@f :in %1 :out %2)
                     f))
                 middle-forms)
          fhead
            (if (form-starts-with-sym? head-form sh)
              `#(~@head-form :out %1)
              head-form)

          pipe-syms
            (vec (for [_ (range (dec (count forms)))]
                   {:in (gensym) :out (gensym)}))

          pipe-bindings
            (apply concat
               (for [{:keys [in out]} pipe-syms]
                 `[~out (PipedOutputStream.)
		   ~in (PipedInputStream. ~out pipe-size)
		   ]))

          future-syms
            (for [_ (range (count forms))]
              (gensym))

          ; the procs will be started in reverse order, so the receiver
          ; is waiting for data before a source generates data
          future-bindings
            (concat
              `[~(last future-syms) (future (~ftail ~(-> pipe-syms last :in)))]
              (apply concat
                 (for [i (range (- (count forms) 2) 0 -1)]
                   `[~(nth future-syms i)
                     (future (~(nth fmiddle (dec i))
                              ~(get-in pipe-syms [(dec i) :in])
                              ~(get-in pipe-syms [i :out])))]))
              `[~(first future-syms) (future (~fhead ~(-> pipe-syms first :out)))])

          ; Make sure each proc finishes, then close its streams
          test-and-close-args
            (for [i (range 0 (count forms))]
              [(get-in pipe-syms [(dec i) :in])
               (nth future-syms i)
               (get-in pipe-syms [i :out])])

          results
            (for [i (range 0 (count forms))]
              `(deref ~(nth future-syms i)))]

      `(with-open [~@pipe-bindings]
         (let [~@future-bindings]
           (#'test-and-close [~@test-and-close-args])
           [~@results])))))

; helper - convenience wrapper for functions that participate in pipes

(def ^:private ^:const eol (System/getProperty "line.separator"))

(defn- stream-seq
  [input-seq output]
  (loop [input input-seq]
    (let [line (first input)]
      (when line
        (copy (StringReader. (str line eol)) output)
        ; flush after every line
        (.flush output)
        (recur (rest input))))))

(defmacro close-first
  [[sym expr] & body]
  `(let [[closeable# ~sym] ~expr]
    (if closeable#
      (try ~@body (finally (.close closeable#)))
      (do ~@body))))

(defn wrap
  "Wrap the function f in another function with transformations
  on the input and output based on the options. The options are:

  :in  :stream   - (default) f will be called with an InputStream as 1st arg
       :reader   - f will be called with a BufferedReader as 1st arg
       :line-seq - f will be called with a LazySeq of text lines
       :none     - There is no input, so f has only 1 arg (out). This is
                   intended for when f is the head of pipe

  :out :stream        - (default) f is called with an OutputStream as 2nd arg
       :writer        - f is called with a Buffered PrintWriter as 2nd arg
       :forward       - f is called with no 2nd arg, the return value of f is
                        written to the out stream, as per clojure.core/spit
       :forward-lines - f is called with no 2nd arg. The return value of f
                        should be Seqable, and each element is streamed as a
                        String, separated by the system line.separator, to out
       :none          - f has no 2nd arg.  This is intended for when f is the
                        tail of a pipe

  NOTE: :forward and :none will block until all input is received, as they
        need to capture the return value of the function.
        :forward-lines will stream one line at a time

  :rv  :wrap     - (default) Return value of f is wrapped in Map that looks like
                   the RV of sh.  E.g. {:exit 0 :out RV-of-f :err nil}
       :identity - Return value of f is not wrapped, so f is free to return a
                   Map with values for :exit :out :err or anything else
                   (including non-Maps) as it pleases

  Return value of wrap is the return value of f."
  [f & {in-opt :in out-opt :out rv-opt :rv
        :or {in-opt :stream out-opt :stream rv-opt :wrap}}]
  (let [inputfn
          (condp = in-opt
            :stream #(vector nil %)
            :reader #(let [r (reader %)] [r r])
            :line-seq #(let [r (reader %)] [r (line-seq r)])
            :none nil)
        rvfn
          (condp = rv-opt
            :wrap (fn [x] {:exit 0 :out x :err nil})
            :identity identity)
        forwardfn
          (fn [rv out]
            (spit out rv)
            (rvfn nil))
        forward-linesfn
          (fn [rv out]
            (stream-seq rv out)
            (rvfn nil))]
    (cond
      (and (= in-opt :none) (= out-opt :none))
        (throw (IllegalArgumentException. ":in and :out can not both be :none"))

      (= in-opt :none)
        (condp = out-opt
          :stream
            (fn [out] (rvfn (f out)))
          :writer
            (fn [out]
              (with-open [o (PrintWriter. (writer out))]
                (rvfn (f o))))
          :forward (fn [out] (forwardfn (f) out))
          :forward-lines (fn [out] (forward-linesfn (f) out)))

      (= out-opt :none)
        (fn [in] (close-first [i (inputfn in)] (rvfn (f i))))

      :else
        (condp = out-opt
          :stream
            (fn [in out]
              (close-first [i (inputfn in)]
                (rvfn (f i out))))
          :writer
            (fn [in out]
              (close-first [i (inputfn in)]
                (with-open [o (PrintWriter. (writer out))]
                  (rvfn (f i o)))))
          :forward
            (fn [in out]
              (close-first [i (inputfn in)]
                (forwardfn (f i) out)))
          :forward-lines
            (fn [in out]
              (close-first [i (inputfn in)]
                (forward-linesfn (f i) out))))

        )))

(defn wrap-text-lines
  "A wrapper to create a pipe-able fn that receives input as a Seq of lines and
  whose return value is a seq of lines that is written as text.  This is a
  non-streaming fn (see NOTE for clojure.java.shell2/wrap)."
  [f]
  (wrap f :in :line-seq :out :forward-lines))

(comment

(println (sh "ls" "-l"))
(println (sh "ls" "-l" "/no-such-thing"))
(println (sh "sed" "s/[aeiou]/oo/g" :in "hello there\n"))
(println (sh "sed" "s/[aeiou]/oo/g" :in (java.io.StringReader. "hello there\n")))
(println (sh "cat" :in "x\u25bax\n"))
(println (sh "echo" "x\u25bax"))
(println (sh "echo" "x\u25bax" :out-enc "ISO-8859-1")) ; reads 4 single-byte chars
(println (sh "cat" "myimage.png" :out-enc :bytes)) ; reads binary file into bytes[]
(println (sh "cmd" "/c dir 1>&2"))

(-> (pipe
      (sh "echo" "sweet home alabama\nno place like home\nmi casa es su casa")
      (wrap (fn [in] (doall (filter (partial re-find #"home") in)))
            :in :line-seq :out :forward-lines)
      (sh "tee" "/tmp/foo")  ; this is helpful for debugging
      (sh "wc" "-l"))
    last
    :out)
;Result: "       2"

; see clojure.java.test-shell2 for more examples

)

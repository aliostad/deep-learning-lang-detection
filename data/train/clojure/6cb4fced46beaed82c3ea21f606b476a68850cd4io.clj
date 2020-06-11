(ns ma3.io
	(:import
		(java.io File
             InputStream FileInputStream
						 OutputStream FileOutputStream
						 BufferedWriter OutputStreamWriter
             BufferedReader InputStreamReader)))

;; file
;;----------------
(defn delete-file
  "delete file"
  [#^String f]
	(.delete (File. f)))

(defn file-extension 
  "get file extension"
  [#^String f]
	(if-let [match (re-seq #"\.(\w+)$" f)]
		(nth (first match) 1)))

(defn file-head
  "get file head"
  [#^String f]
  (if-let [match (re-seq #"([^\/]+)\.\w+$" f)]
    (nth (first match) 1)))

(defn file-list
  "get files if match"
  [#^String dirpath & [{:keys [type]}]]
  (let [flist (if-let [d (File. dirpath)] (.listFiles d) nil)
        typefn (if type
                  (fn [file]
                    (if (and
                          (not= file nil)
                          (= type (file-extension (.getName file))))
                        file))
                  identity)
        filefn (fn [file]
                  (if (.isFile file) file nil))]
    (if flist
      (map #(.getPath %) (filter (comp typefn filefn) flist)))))

(declare str2file lazy-input-line tois)

(defn file-join
  "file join"
  [dstfile & files]
  (str2file dstfile (apply str (flatten (map #(lazy-input-line (tois %)) files)))))

;; stream
;;----------------
(defn tois
  "input inputStream"
  #^InputStream [#^String f]
  (FileInputStream. (File. f)))

(defn toos #^OutputStream [#^String f]
	"String to OutputStream"
	(FileOutputStream. (File. f)))

(defn tobw
  "String to buffered writer"
  #^BufferedWriter
  [#^String f]
  (BufferedWriter. (OutputStreamWriter. (toos f))))

(defn lazy-input [#^InputStream input-stream]
	"lazy sequence for input character"
	(let [step (fn step []
					(let [c (.read input-stream)]
						(when-not (== c -1)
							(cons (char c) (lazy-seq (step))))))]
		(lazy-seq (step))))

(defn lazy-input-line [#^InputStream input-stream]
	"lazy sequence for input line"
	(let [rd (BufferedReader. (InputStreamReader. input-stream))]
		(let [step (fn step []
					(let [line (.readLine rd)]
						(when-not (= line nil)
							(cons line (lazy-seq (step))))))]
			(lazy-seq (step)))))

(defn is2str [#^InputStream is]
	"get context string from input stream"
	(apply str (lazy-input-line is)))

(defn is2file [#^InputStream is outpath]
	"save context string from inputstream"
	(with-open [os (FileOutputStream. (File. outpath))]
		(let [data (byte-array (int (Math/pow 2 13)))]
			(loop []
				(let [readed (. is read data)]
					(when-not (== readed -1)
						(.write os data 0 readed)
						(recur)))))))

(defn str2file
  "write string to file"
  [#^String filepath #^String contents]
  (with-open [bw (tobw filepath)]
    (.write bw contents 0 (.length contents))))



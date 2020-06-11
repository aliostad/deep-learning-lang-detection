; TextMash - simple IDE for Clojure
; 
; Copyright (C) 2011 Aleksander Naszko
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;
; You must not remove this notice, or any other, from this software.

(ns textmash.stream
	(:use (textmash commons))
	(:import (javax.swing JMenuBar JMenu JMenuItem AbstractAction)
	(java.awt Dimension) (java.io File InputStream OutputStream
		BufferedReader InputStreamReader PrintStream
		PipedInputStream PipedOutputStream)))

(defn piped-stream[]
	(let[ pi (PipedInputStream.) po (PipedOutputStream.)]
		(.connect pi po)
			[pi (PrintStream. po)]))

(defn- transfer-stub[read-fn print-fn cond-fn in out encoding ]
	(bound-daemon
		(let [ br (BufferedReader. (InputStreamReader. in))  ]
			(doseq [x (take-while #(cond-fn %1) (repeatedly #(read-fn br)))]
				(print-fn out x)))))

(defn transfer-chars
	([ in out ]
		(transfer-chars in out "UTF-8"))
	([ in out enc ]
		(transfer-stub #(.read %1) #(.print %1 (char %2)) #(not= %1 -1) in out enc)))

(defn transfer-lines
	([ in out ]
		(transfer-lines in out "UTF-8"))
	([ in out enc ]
		(transfer-stub #(.readLine %1) #(.println %1 %2) #(not (nil? %1))  in out enc)))

(defn join-inputs-by-line[ & ins]
	(let [ po (PipedOutputStream.) ps (PrintStream. po) pi (PipedInputStream.) ]
		(.connect pi po)
		(doseq [x ins ]
			(transfer-lines x ps))
				pi))

(defn process[ working-dir cmds ]
	(let [pb (ProcessBuilder. cmds) ]
		(.directory pb (File. working-dir))
		(.redirectErrorStream pb true)
		(let [ p (.start pb)]
			[(.getInputStream p) (.getOutputStream p)])))

(defn print-process[ encoding working-dir cmds ]
	(let [[in out] (process working-dir cmds)]
		(transfer-chars in
			(PrintStream. (System/out) true encoding) encoding) out))

(defn hang-up[]
	(-> (Thread/currentThread) (.join)))









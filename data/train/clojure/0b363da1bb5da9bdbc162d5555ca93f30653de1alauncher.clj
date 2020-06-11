; TextMash - simple IDE for Clojure
; 
; Copyright (C) 2011 Aleksander Naszko
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;
; You must not remove this notice, or any other, from this software.

(ns textmash.launcher
	(:use (textmash stream communication config))
	(:import (javax.swing JMenuBar JMenu JMenuItem AbstractAction)
	(java.awt Dimension) (java.io InputStream OutputStream
		BufferedReader InputStreamReader PrintStream
		PipedInputStream PipedOutputStream)))

(process (get-cfg :working-dir) (get-cfg :terminal-launcher { :title "Test" }))



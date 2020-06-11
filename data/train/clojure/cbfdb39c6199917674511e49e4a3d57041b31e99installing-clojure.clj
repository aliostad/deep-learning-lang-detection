(ns my-clojure-project-notes.installing-clojure)

; What this episode will cover:
;  * Installing Java -- (Required to run Clojure)
;  * Installing Leiningen -- A commandline tool used to build and manage Clojure projects
;  * Installing Atom -- The IDE we'll be using in this tutorial

; Open a terminal window

; Make sure Java is installed by running:
; java -version

; If you don't have java installed, OSX will prompt you to install it
; Download link: https://www.java.com/en/download/
; [Follow the Java install prompts]

; After Java is installed
; Open your terminal and run
; java -version
; [You should see your version of Java installed]


; curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > lein
; sudo mkdir -p /usr/local/bin/
; sudo mv lein /usr/local/bin/lein
; sudo chmod a+x /usr/local/bin/lein

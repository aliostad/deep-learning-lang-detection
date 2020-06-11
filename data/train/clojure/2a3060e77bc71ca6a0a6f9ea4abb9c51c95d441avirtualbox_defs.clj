(use 'calculator.core) 
(use 'clojure.test)
(require '[clojure.java.shell :as sh])

; helpers
(defn start-the-machine [vm-name]
	(sh/sh "bash" "-c" 
		(str "VBoxManage startvm " vm-name " --type headless" )))
(defn stop-the-machine [vm-name]
	(sh/sh "bash" "-c" 
		(str "VBoxManage controlvm " vm-name " poweroff" )))
(defn check-port [IP port]
	(sh/sh "bash" "-c" 
		(str "nc -z " IP " " port)))

; BDD
(When #"^I start the VM \"(.*?)\"$" [VM]
	(start-the-machine VM))

(And #"^Wait (.*?) seconds" [seconds]
	(Thread/sleep (Integer/parseInt seconds)))

(Then #"^IP \"(.*?)\" has port \"(.*?)\" opened$" [IP port]
	(let [cmd (check-port IP port)]
		(assert (= 0 (:exit cmd)))))

(Then #"^I can stop the VM \"(.*?)\"$" [VM]
	(stop-the-machine VM))
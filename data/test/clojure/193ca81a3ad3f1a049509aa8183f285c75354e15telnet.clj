(ns anansi.test.receptor.host-interface.telnet
  (:use [anansi.receptor.host-interface.telnet] :reload)
  (:use [anansi.ceptr]
        [anansi.receptor.host]
        [anansi.test.helpers :only [write connect *result*]])
  (:use [clojure.test]
        [clojure.contrib.io :only [writer]]
        [aleph.tcp]
        [lamina.core]
        [gloss.core]))

(defn make-test-connection
  "Create a server and a client for testing purposes.
Returns a two item vector of a writable stream that is a client, and the output stream of the server"
  ([connection-function]
     (let [out (java.io.StringWriter.)
           client-stream (java.io.PipedWriter.)
           r (java.io.BufferedReader. (java.io.PipedReader. client-stream))
           sigs @*signals*
           thread (Thread. #(binding [*server-state-file-name* "testing-server.state"
                                      *done* false
                                      *changes* (ref 0)
                                      ;*user-name* "eric"
                                      *receptors* (ref {})
                                      *signals* (ref sigs)
                                      *err* (java.io.PrintWriter. (writer "/dev/null"))
                                      ]
                              (make-receptor host-def nil {})
                              (connection-function r out)))
           ]
       (doto thread  .start)
       [client-stream out])
     ))

(def *len* (ref 0))
(defn- len [s] (count (.toString s)))
(defn- setlen [s]
  (dosync (ref-set *len* (len s))))
(defn- wait [s]
  (while (= @*len* (len s)) (Thread/sleep 1))
  (setlen s)
  )

(deftest telnet-interface
  
  (let [h (make-receptor host-def nil {})
        r (make-receptor telnet-def h {})]
    (testing "server"
      (is (thrown-with-msg? RuntimeException #"Server not started."
            (--> interface->stop h r)))
      (--> interface->start h r {:port 12345})
      (is (= #{:server-socket :connections} (set (keys (contents r :server)))))
      (let [rch (tcp-client {:host "localhost", :port 12345, :frame (string :utf-8 :delimiters ["\n"])})]
        (is (= (wait-for-message @rch) ""))
        (is (= (wait-for-message @rch) "Welcome to the Anansi server."))
        )
      (is (thrown-with-msg? RuntimeException #"Server already started."
            (--> interface->start h r {:port 12345})))
      )
    
    (let [z-addr (s-> self->host-user h "zippy")
          [client-stream server-stream] (make-test-connection (make-handle-connection h r))
          ]
      (testing "welcome"
        (wait server-stream)
        (is  (.endsWith (.toString server-stream) "\nWelcome to the Anansi server.\n\nEnter your user name: ")))
      (testing "authenticate"
        (.write client-stream "eric\n")
        (wait server-stream)
        (is (.endsWith (.toString server-stream) "ERROR authentication failed for user: eric\nEnter your user name: "))
        (.write client-stream "zippy\n")
        (wait server-stream)
        (is (re-find #"OK \{:session \"[0-9a-f]+\", :creator \[\]\}\n\n> $"(.toString server-stream) ))
        )
      (testing "unknown command"
        (.write client-stream "badcommand eric\n")
        (wait server-stream)
        (is (re-find #"ERROR Unknown command: 'badcommand'\n"(.toString server-stream) )))
      (testing "new-user"
        (.write client-stream "new-user zippy\n")
        (wait server-stream)
        (is (re-find #"ERROR username 'zippy' in use\n\n> " (.toString server-stream) ))
        (.write client-stream "new-user zippo\n")
        (wait server-stream)
        (is (re-find #"OK [0-9]+\n\n> " (.toString server-stream) )))
      (testing "send-signal"
        (.write client-stream "send 0 receptor.host.ceptr->ping\n")
        (wait server-stream)
        (is (re-find #"OK Hi [0-9]+! This is the host.\n\n> " (.toString server-stream) ))
        ))
    ))

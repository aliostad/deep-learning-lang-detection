; refs - manage coordinated, synchronous changes to shared state
; atoms - manage uncoordinated, synchronous changes to shared state
; agents - manage asynchronous changes to shared state
; vars - manage thread-local state

; == 5.1 Concurrency, Parallelism, and Locking

; == 5.2 Refs and Software Transactional Memory

(def current-track (ref "Mars, the Bringer of War"))

(deref current-track)

@current-track

; -- ref-set

(ref-set current-track "Venus, the Bringer of Peace")

(dosync (ref-set current-track "Venus, the Bringer of Peace"))

; -- Transactional Properties

; guaranteed properties:
; * updates are atomic
; * updates are consistent
; * updates are isolated
; * updates are NOT durable, because they are in-memory

(def current-track (ref "Venus, the Bringer of Peace"))
(def current-composer (ref "Holst"))

(dosync
    (ref-set current-track "Credo")
    (ref-set current-composer "Byrd"))

; -- Alter

(defrecord Message [sender text])

(user.Message. "Aaron" "Hello")

(def messages (ref ()))

; bad idea
(defn naive-add-message [msg]
    (dosync (ref-set messages (cons msg @messages))))

(defn add-message [msg]
    (dosync (alter messages conj msg)))

; order matters for alter
; (cons item sequence)
; (conj sequence item)

(add-message (user.Message. "user 1" "hello"))

(add-message (user.Message. "user 2" "howdy"))

; -- How STM Works: MVCC

; Multiversion Concurrency Control

; -- commute

(defn add-message-commute [msg]
    (dosync (commute messages conj msg)))

; -- Prefer alter

(def counter (ref 0))

(defn next-counter [] (dosync (alter counter inc)))

(next-counter)

(next-counter)

; -- Adding Validation to Refs

(def validate-message-list
    (partial every? #(and (:sender %) (:text %))))

(def messages (ref () :validator validate-message-list))

(add-message "not a valid message")

@messages

(add-message (user.Message. "Aaron" "Real Message"))

; == 5.3 Use Atoms for Uncoordinated, Synchronous Updates

(def current-track (atom "Venus, the Bringer of Peace"))

(deref current-track)

@current-track

(reset! current-track "Credo")

(def current-track (atom {:title "Credo" :composer "Byrd"}))

(reset! current-track {:title "Spem in Alium" :composer "Tallis"})

(swap! current-track assoc :title "Sancte Deus")

; == 5.4 Use Agents for Asynchronous Updates

(def counter (agent 0))

(send counter inc)

@counter

; -- Validating Agents and Handling Errors

(def counter (agent 0 :validator number?))

(send counter (fn [_] "boo"))

@counter

(agent-errors counter)

(clear-agent-errors counter)

@counter

; -- Including Agents in Transactions

(def output-dir "/Users/matthewj/git/github/copperlight/programming-clojure-workbook/")

(def backup-agent (agent (str output-dir "messages-backup.clj")))

(defn add-message-with-backup [msg]
    (dosync
        (let [snapshot (commute messages conj msg)]
            (send-off backup-agent (fn [filename]
                (spit filename snapshot)
                filename))
            snapshot)))

(add-message-with-backup (user.Message. "John" "Message One"))

(add-message-with-backup (user.Message. "Jane" "Message Two"))

; -- The Unified Update Model

; function application, ref: alter, atom: swap!, agent: send-off
; function (commutative), ref: commute
; function (non-blocking), agent: send
; simple setter, ref: ref-set, atom: reset!

; vars do not participate in the unified update model

; == 5.5 Managing Per-Thread State with Vars

(def ^:dynamic foo 10)

(.start (Thread. (fn [] (println foo))))

(binding [foo 42] foo)

(defn print-foo [] (println foo))

(let [foo "let foo"] (print-foo))

(binding [foo "bound foo"] (print-foo))

; -- Acting at a Distance

(defn ^:dynamic slow-double [n]
    (Thread/sleep 100)
    (* n 2))

(defn calls-slow-double []
    (map slow-double [1 2 1 2 1 2]))

(time (dorun (calls-slow-double)))

(defn demo-memoize []
    (time
        (dorun
            (binding [slow-double (memoize slow-double)]
                (calls-slow-double)))))

(demo-memoize)

; -- Working with Java Callback APIs

; refs and stm: coordinated, syncrhonous updates -  pure functions
; atoms: uncoordinated, synchronous updates - pure functions
; agents: uncoordinated, asynchronous updates - any functions
; vars: thread-local dynamic scopes - any functions
; java locks: coordinated, synchronous updates - any functions

; == 5.6 A Clojure Snake

see reader/snake.clj

(use 'examples.snake)

(game)


; -- Snakes Without Refs

(defn update-positions [{snake :snake, apple :apple, :as game}]
    (if (eats? snake apple)
        (merge game {:apple (create-apple) :snake (move snake :grow)})
        (merge game {:snake (move snake)})))

(actionPerformed [e]
    (swap! game update-positions)
    (when (lose? (@game :snake))
        (swap! game reset-game)
        (JOptionPane/showMessageDialog frame "You lose!")))

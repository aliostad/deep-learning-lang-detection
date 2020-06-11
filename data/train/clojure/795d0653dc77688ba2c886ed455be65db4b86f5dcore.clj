(ns all-the-while.core
  "This is a simple task manager, basically a way to manage multiple
   long running functions in a future. In some situations, using a scheduling
   model like ScheduledThreadPoolExecutors is the right way to go, but
   for my purposes I wanted the sleep timing of each iteration to be handled
   internally by the function, not by the scheduler itself. While it is possible
   to just run the scheduler at a really fast interval, it feels kind of wrong.
   This little module lets you create, start, stop and remove tasks in a
   reasonably generic way, the only impositions being a) the task is run in
   an infinite-until-stopped loop and b) the task is run in a future.")

(defonce atw-tasks* (ref {}))
(declare stop-task)
(declare task-running?)

(defn create-task
  "Given a name and a function, creates a new task unless the
   task already exists. If the :sleep option is given, the while loop
   will sleep that many msecs after calling the function. This makes it
   work similar to a scheduler. In general, though, the main intent of
   this module in the first place is to allow task management with tasks
   that handle their own waiting, so don't use this feature."
  [task-name fun & {:keys [sleep]}]
  (let [task-name (keyword task-name)]
    (if-let [t (task-name @atw-tasks*)]
      false
      (do
        (dosync
         (alter atw-tasks* assoc task-name
                {:status :stopped
                 :future nil
                 :function fun
                 :sleep (if (number? sleep) (or sleep 0) 0)}))
        true))))

(defn remove-task
  "Removes a task. If the task is running, it will be stopped first."
  [task-name]
  (let [task-name (keyword task-name)]
    (if-let [t (task-name @atw-tasks*)]
      (do
        (when (task-running? task-name)
          (stop-task task-name))
        (dosync 
         (alter atw-tasks* dissoc task-name))
        true)
      false)))
        

(defn task-running?
  "Returns true if the task is currently running."
  [task-name]
  (if (= :running (get-in @atw-tasks* [task-name :status]))
    true
    false))

(defn task-status
  "Returns the status of each known job."
  []
  (let [task-names (keys @atw-tasks*)]
    (zipmap task-names
            (map #(get-in @atw-tasks* [% :status]) task-names))))

(defn start-task
  "Starts a task if the task exists and isn't already running."
  [task-name]
  (let [task-name (keyword task-name)]
    (when-let [t (task-name @atw-tasks*)]
      (when-not (task-running? task-name)
        (let [fun (:function t)
              sleep-time (:sleep t)]
            (dosync
             (alter atw-tasks* assoc-in [task-name :status] :running)
             (alter atw-tasks* assoc-in [task-name :future] 
                    (future 
                      (while (= :running (get-in @atw-tasks*
                                                 [task-name :status]))
                        (do
                          (fun)
                          (when (> sleep-time 0)
                            (Thread/sleep sleep-time))))))))))))

(defn start-all-tasks
  "Starts any stopped tasks."
  []
  (doseq [t (keys @atw-tasks*)]
    (start-task t)))

(defn stop-task
  "Stops a task if it exists and is running. If :wait is supplied,
   waits :wait msecs before cancelling the future and updating the task. If
   no :wait is supplied, waits the :sleep amount of time. The general idea is
   to allow the current iteration to complete, but no guarantees are made."
  [task-name & {:keys [wait]}]
  (let [task-name (keyword task-name)]
    (if-let [t (task-name @atw-tasks*)]
      (when (task-running? task-name)
        (dosync
         (alter atw-tasks* assoc-in [task-name :status] :stopped)
         (Thread/sleep (or wait ( or (:sleep t) 0)))
         (future-cancel (get-in @atw-tasks* [task-name :future]))
         (alter atw-tasks* assoc-in [task-name :future] nil))))))

(defn stop-all-tasks
  "Stops all running tasks with their default :wait time, or supply :wait
   to stop all tasks with the same :wait param."
  [& {:keys [wait]}]
   (doseq [t (keys @atw-tasks*)]
    (if wait
      (stop-task t :wait wait)
      (stop-task t))))

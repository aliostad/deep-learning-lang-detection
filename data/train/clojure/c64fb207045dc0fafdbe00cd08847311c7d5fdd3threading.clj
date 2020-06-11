(ns neko.threading
  "Utilities used to manage multiple threads on Android."
  (:use [neko.debug :only [safe-for-ui]])
  (:import android.view.View
           android.os.Looper
           android.os.Handler))

;; ### UI thread utilities

(defn on-ui-thread?
  "Returns true if the current thread is a UI thread."
  []
  (identical? (Thread/currentThread)
              (.getThread ^Looper (Looper/getMainLooper))))

(defmacro on-ui
  "Runs the macro body on the UI thread.  If this macro is called on the UI
  thread, it will evaluate immediately."
  [& body]
  `(if (on-ui-thread?)
     (safe-for-ui ~@body)
     (.post (Handler. (Looper/getMainLooper)) (fn [] (safe-for-ui ~@body)))))

(defn on-ui*
  "Functional version of `on-ui`, runs the nullary function on the UI thread."
  [f]
  (on-ui (f)))

(defmacro post
  "Causes the macro body to be added to the message queue.  It will execute on
  the UI thread.  Returns true if successfully placed in the message queue."
  [view & body]
  `(.post ^View ~view (fn [] ~@body)))

(defmacro post-delayed
  "Causes the macro body to be added to the message queue.  It will execute on
  the UI thread.  Returns true if successfully placed in the message queue."
  [view millis & body]
  `(.postDelayed ^View ~view (fn [] ~@body) ~millis))

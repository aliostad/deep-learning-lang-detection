(ns claw.plugin
  "A plugin is a modular library that can be started and stopped by
  the framework. It is defined by a name, four functions and a
  state. The functions are:

    - pre-function
    - start-function
    - stop-function
    - post-function

  Pre-function is run once when the entire system is booted, and
  post-function is run once when the system is shut
  down. Start-function and stop-function are run as many times as
  required to start and stop the service, within a single instance of
  the framework.

  The state is a keyword which describes whether the plugin has been
  initialized and whether it's running. (Plugins can maintain whatever
  internal state they like, too.)

  The plugin's name is a globally unique string which identifies it in
  the plugin registry. If you'd like to create multiple copies of a
  given plugin, use partial to set up the functions, then name them as
  appropriate to distinguish them.

  claw.core provides an initial execution context and starts some
  configurable default plugins at startup. Additional context may be
  created by individual plugins at runtime.

TODO: Would it be better for plugins to manage their own state
independently, in their own namespaces?

TODO: add a \"fail on plugin failure\" mode that crashes the app if
any plugin fails to load.
"
  (:require [clansi.core :as ansi]
            [onelog.core :as log])
  (:refer-clojure :exclude [name]))



;; TODO: change state management to a proper finite state machine.
;; For now, there are the following states:
;;
;;  - :shutdown - Pre-function has not been run yet, or plugin has been run, stopped, and post-function has been run to reset to original state.
;;  - :ready - pre-function has been run, but not started yet.
;;  - :running - start-function has been run; the plugin is fully operational.
;;  - :stopped - stop-function has been run, the plugin is not operational,
;;                but post-function has not been run. The plugin may be restarted
;;                without re-running pre-function.
;;  - :error - Generic fatal error. TODO: add recoverable errors?
;;
;; TODO: Maybe keep track of what protocols each plugin requires and
;; provides... automatic dependency resolution? Or is this just
;; reinventing the Maven / Leiningen wheel?
;;
;; TODO: Support for plugins that can be started more than once,
;; e.g. a Postgres plugin that allows simultaneous connection to
;; multiple databases.
;;
;; TODO: Can this be done more cleanly by using Robert Hooke to
;; decorate functions with state registration hooks, rather than with
;; this wrapper protocol?
;;
(defprotocol Plugin
  "Methods to manage the lifecycle of a generic plugin."

  (name [plugin] "Returns the plugin's name.")
  (state [plugin] "Returns the plugin's current state.")

  (preload! [plugin args]
    "Runs pre-function if the plugin is in the :shutdown state,
    otherwise does nothing.")

  
  (start! [plugin args]
    "Starts the plugin with start-function if it's :ready. Should update state as appropriate.")

  (stop! [plugin args]
    "Stops the plugin with stop-function if it's :running. Should update state as
     appropriate.")

  (shutdown! [plugin args]
    "Returns to :shutdown state if it's :stopped, stopping the plugin and running any
     post-function (once) if necessary. Should update state as
     appropriate.")  )

;; Global plugin registry
(defonce plugins (atom {}))


(defrecord InternalPlugin [name pre-function start-function stop-function post-function state]
  Plugin
  (name [plugin] name)
  (state [plugin] @state)

  (preload! [plugin args]
    (log/debug (str "    -- Preloading plugin '" name "' with args: " args " in state: " @state))
    (if (= @state :shutdown)
      (swap! state (constantly (pre-function args))) ;; Because pre-function may have side effects.
      (log/warn "preload! called on plugin '" name "' when in state " @state ". Plugin needs to be in :shutdown state to call preload!.")))

  (start! [plugin args]
    (log/debug (str "    -- Starting plugin '" name "' with args: " args  " in state: " @state))

    (if (= @state :ready)      
      (swap! state (constantly (start-function args)))
      (log/warn "start! called on plugin '" name "' when in state " @state ". Plugin needs to be in :ready state to call start!.")))

  (stop! [plugin args]
    (log/debug (str "    -- Stopping plugin '" name "' with args: " args  " in state: " @state))
    (if (= @state :running)
      (swap! state (constantly (stop-function args)))
      (log/warn "stop! called on plugin '" name "' when in state " @state ". Plugin needs to be in :running state to call stop!.")))

  (shutdown! [plugin args]
    (log/debug (str "    -- Shutting down plugin '" name "' with args: " args  " in state: " @state))
    (stop! plugin nil)
    (if (= @state :stopped)      
      (swap! state (constantly (post-function args)))
      (log/warn "shutdown! called on plugin '" name "' when in state " @state ". Plugin needs to be in :stopped state to call shutdown!."))))



(defn new-plugin!
  "Creates a new plugin with an atom to hold its state. Use partial if
  you want to easily make multiple copies with different names."
  [pre-function start-function stop-function post-function name]
  (InternalPlugin. name pre-function start-function stop-function post-function (atom :shutdown)))

(defn register-plugin!
  "Registers the plugin in the global registry, and calls its
  pre-function, if it has not already been registered."
  [plugin & args]
  (when-not (contains? @plugins (name plugin))
    (preload! plugin args)
    (swap! plugins assoc (name plugin) plugin)))

(defn unregister-plugin!
  "Shuts down the plugin if running, calls post-function, and unregisters the plugin in the global registry."
  [plugin & args]
  (shutdown! plugin args)
  (swap! plugins dissoc (name plugin)))

(defn start-plugin!
  "Starts the given plugin with the given arguments, requiring its
  namespace and saving it in the global plugin registry under its name
  if necessary.
  Logs any exceptions.
"
  [plugin & args]
  (register-plugin! plugin)
  (start! plugin args))

(defn stop-plugin!
  "Stops the given plugin with the given arguments. Does not remove it from the registry"
  [plugin & args]
  (stop! plugin args))


(defn- log-plugin-load!
  "Logs an info message noting that the specified plugin has been
loaded, and prints a similar message to the console, to aid debugging
in cases where the logging plugin itself hasn't loaded yet.

 Will not try to log anything unless the claw.logging namespace has
been loaded, to avoid causing Log4J to print warning spam about the
logging system being unconfigured to the console.
"
  [plugin-symbol]
  (binding [onelog.core/*copy-to-console* true]
    (log/info  " * Loading plugin "  (ansi/style plugin-symbol :cyan :bright)  "...")))

(defn- log-plugin-error!
  "Logs an info message noting that the specified plugin has been
loaded, and prints a similar message to the console, to aid debugging
in cases where the logging plugin itself hasn't loaded yet.

 Will not try to log anything unless the claw.logging namespace has
been loaded, to avoid causing Log4J to print warning spam about the
logging system being unconfigured to the console.
"
  [& args]
  (binding [onelog.core/*copy-to-console* true]
    (log/error (apply str "Error loading plugin: " args))))

(defn- log-plugin-exception!
  "Logs an exception that occurred loading a plugin according to the
  same semantics as log-plugin-load! (cf.)

TODO: print / log stack traces"
  [plugin-symbol exception]
  (binding [onelog.core/*copy-to-console* true]
    (log/error (str "  -- Error loading plugin " plugin-symbol ": "))
    (log/error (log/throwable exception))))

(defn start-plugin-by-symbol!
  "Loads the given symbol's namespace and then starts the plugin, logging any errors."
  [plugin-symbol]
  (log-plugin-load! plugin-symbol)
  (try
    (let [nspace (symbol (namespace plugin-symbol))]
      (require nspace)
      (start-plugin! (var-get (resolve plugin-symbol))))
    
    ;; TODO: There could be other NullPointerExceptions that aren't related to not being able to find the plugin.
    ;; Detect the difference and log appropriately.
    (catch NullPointerException t 
      (log-plugin-error! "Couldn't find requested plugin " plugin-symbol ))
    (catch Throwable t
      (log-plugin-exception! plugin-symbol t))))


(defn start-plugins!
  "Given a list of namespace-qualified symbols, requires all namespaces and loads the specified plugins.

TODO: add a \"die on exception\" option that halts and exits rather than continuing with startup.
"
  [plugins]
  (dorun (map
          (fn [plugin-symbol] (claw.plugin/start-plugin-by-symbol! plugin-symbol))
          plugins)))

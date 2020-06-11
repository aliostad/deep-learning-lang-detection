(ns conskit.protocols)

(defprotocol Action
  "Actions can be invoked"
  (invoke [this request] "Invoke this action"))

(defprotocol ActionRegistry
  "Functions to manage an instance of ActionRegistry"
  (register-controllers! [this controllers] [this controllers interceptors]
    "Registers a list of controllers in the form:

     [c1 c2] or [[c1 options] [c2 options]]

     where options can be {:exclude [:actionnames]} or {:include [:actionnames]}
     used to filter which actions in the controller will be registered.

     Any interceptors passed in here will be used to wrap all actions. They can be specified as:

     [in1 in2] or [[in1 options] [in2 options]]

     where options at the moment can be {:except :ignore-annotation :config :settings} which specifies an annotation
     that can be used to exclude a particular action or controller from being wrapped as well as the default config
     to be passed to the interceptor")
  (register-bindings! [this bindings]
    "Registers a map of bindings that will be provided to controllers at startup time.
     These bindings can then be used in actions")
  (register-interceptors! [this interceptors]
    "Registers a list of interceptors that will be used to wrap actions depending the presence of a particular
     annotation. the list is in the form:

     [in1 in2] or [[in1 config][in2 config]]

     where config is the default configuration provided if the annotation is just specified as true. if the config
     on provided by the annotation and the config here are maps then this config will be merged with the annotation'ss
     otherwise for any other type it will be replaced by the annotation value")
  (get-action [this id]
    "Retrieve an action from the registry")
  (select-meta-keys [this key-seq] [this id key-seq]
    "Is effectively the result of mapping selectkeys on the metadata of a one or all action(s)"))

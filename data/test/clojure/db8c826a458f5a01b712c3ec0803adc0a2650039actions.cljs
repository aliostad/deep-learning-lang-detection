(ns {{name}}.cards.actions
  (:require [{{name}}.components.actions :refer [counter]])
  (:require-macros [devcards.core :refer [defcard]]))

(defcard counter
  "# Action dispatch with pit-dispatch
  ## Create actions
  The macro **defaction* is used to create new actions.

  An action should to contain:

    - a **name**: a symbol corresponding to the name of the action.
    - one or more **actions**: those should be following the format of a function.
      In case of multiple of them, each should be surrounded by parenthesis. (cf. examples)

  The function will be applied to a **map** corresponding at the previous dereferenced state.

  If you need to recur on the action, the keyword `reaction` will allow you to do so.

  Reaction works also in case you need to call another arity of the same function.

  ## Dispatch action
  The function **dispatch!** allows you to dispatch a list of action on a given atom.

  The parameters needed after dispatch are:

    - an **atom**.
    - one or more **action references**.

  An action reference can be in two formats:

    - a keyword alone corresponding to the action name. This will call the action without any parameters.
    - a vector containing the keywordized name of the action, and the parameters.

  ## Code snippet: Creating actions

  ```
  ;; Requiring function
  (ns example
     (:require [pit-dispatch.core :refer-macros [defaction! defaction]]))

  ;; Simple action
  (defaction inc
     [m] (update :count inc))

  ;; Simple action with parentheses
  (defaction dec
     ([m] (update :count dec)))

  ;; Multi-arity action using reaction
  (defaction log
     ([m] (reaction m m))
     ([m string] (do (println string)
                     m)))

  ;; Side effect action
  (defaction! side-effect
     [state]
     (swap! state dissoc :count))
  ```

  ## Code snippet: Calling actions

  ```
  ;; Requiring functions
  (ns example
     (:require [pit-dispatch.core :refer-macros [dispatch!]]))

  ;; Atom definition
  (def state (atom {}))

  (dispatch! state :inc)

  (dispatch! state [:dec])

  (dispatch! state [:log \"Action:\"]
                   :inc
                   [:log])

  (dispatch! state [:log]
                   [! :side-effect])
  ```
  "
  (fn [state]
    (counter state))
  {}
  {:inspect-data true})

(ns alchemy.gui.core
  (:require [alchemy.gui.lwjgl.display :as display]
            [alchemy.gui.lwjgl.render :as render]
            [alchemy.gui.lwjgl.buffer :as buffer]
            [alchemy.gui.lwjgl.input :as input]
            [alchemy.message :as message]))

;; copied this from game, consider combining the similarities somehow
(defn process-messages
  "processes any received messages"
  [data mailbox]
  (loop [data data
         messages (message/receive mailbox)]
    (if (empty? messages)
      data
      ;; process first message
      (let [message (first messages)
            ;; update data based on message
            data (case (:tag message)
                   :state (assoc data :shared-state (:data message))
                   :close (assoc data :continue? false)
                   data)]
        (recur data (rest messages))))))

(defn run-gui
  "runs a lwjgl window application and renders the state"
  [mailbox]
  (display/setup-display 800 600 [0 0 0])
  ;; loop for each frame using the state and relevant data
  (loop [state nil
         data {:continue? true ; set false to stop processing
               :shared-state (atom nil) ; replaced with state from game
               }
         buffers {}]
    (let [data (process-messages data mailbox)
          buffers (buffer/manage-buffers state buffers)
          inputs (input/keyboard-events)]
      (message/send mailbox :game :inputs inputs)
      (display/await-frame state)
      (display/clear-screen)
      (render/render state buffers)
      (display/update-display)
      (if (and (not (display/display-closed?))
               (:continue? data))
        (recur @(:shared-state data) data buffers)
        (message/send mailbox :game :close))))
  (display/close-display))

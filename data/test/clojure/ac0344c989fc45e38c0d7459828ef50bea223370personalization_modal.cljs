(ns pharmacy.components.personalization-modal
  (:require
   [pharmacy.components.utils.modal :refer [make-modal]]
   [re-frame.core :as re-frame :refer [dispatch]]))

(defn personalization-modal [modal-shown]
  (make-modal modal-shown
              #(dispatch [:personalization-modal false])
               "Non-Personalized Score"
               [:div
                [:p "This drug score has not yet been tailored to you."]
                [:br]
                [:p "Please answer a few questions so that we can personalize your scores."]]

               {:on-click #(dispatch [:personalization-modal false])
                :text "I understand"}))

(ns pandu.db
  )

(def pandu-user
  { :id nil
    :email nil
    :role  nil
    })


(def pandu-base-event
  { :id nil
    :user-id nil
    :description nil
    :due-date nil
    :notify-at "0"          ;; select value
    :post-to nil
    :enabled? true
  })

(def pandu-event
  (merge pandu-base-event {
      :created-at nil
      :notify-at-date nil     ;; utc date-time
      :last-notified-at nil   ;; utc date-time
    }))


(def show-add-modal-props
  (merge {:mode "add"
          :action "show"
          :form-due-date nil
          :form-validation-errors []} pandu-event))

(defn show-edit-modal-props
  [event]
  (merge {:mode "edit"
          :action "show"
          :form-due-date nil
          :form-validation-errors []} event))

(def pandu-notification
  { :id nil         ;; (.now js/Date)
    :type nil       ;; "error" | "info" | "success" | "warning"
    :msg nil        ;; text displayed in the toast
  })

; (def ajax-channel
;   { :status 'waiting'
;     :queue ()
;     })


(def app-db
  {
    ; :connected? false           ;; true == we are able to make ajax calls

    :loading? false             ;; true == in an ajax calling, waiting for response

    :logged-in? false           ;; whether the users is authenticated or not
    :login-error nil           ;; if login fails, we store the reason why here

    :active-panel :login-panel  ;; the current panel being displayed to the user

    :user pandu-user            ;; the current user's record

    :events nil

    :add-modal-props nil        ;; event used to add/edit modal

    :notifications-queue  nil   ;; queue used to manage toast notification messages

    :ajax-queue nil             ;; queue used to manage pending ajax calls
  })



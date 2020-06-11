(ns sane-tabber.routes
  (:require [secretary.core :as secretary :include-macros true]
            [re-frame.core :refer [subscribe dispatch]]
            [sane-tabber.websockets :as ws]

            [sane-tabber.home.views :refer [home-page]]
            [sane-tabber.new-tournament.views :refer [new-tournament-page]]
            [sane-tabber.dashboard.views :refer [dashboard-page]]
            [sane-tabber.registration.views :refer [registration-page]]
            [sane-tabber.registration-view.views :refer [registration-view-page]]
            [sane-tabber.rounds.views :refer [rounds-page]]
            [sane-tabber.pairings.views :refer [pairings-page]]
            [sane-tabber.ballots.views :refer [ballots-page]]
            [sane-tabber.reporting.views :refer [reporting-page]]
            [sane-tabber.editors.rooms.views :refer [rooms-editor-page]]
            [sane-tabber.editors.judges.views :refer [judges-editor-page]]
            [sane-tabber.editors.teams.views :refer [teams-editor-page]]
            [sane-tabber.editors.schools.views :refer [schools-editor-page]]
            [sane-tabber.settings.views :refer [settings-page]]))

(secretary/set-config! :prefix "#")

(def pages
  {:home              #'home-page
   :new-tournament    #'new-tournament-page
   :dashboard         #'dashboard-page
   :registration      #'registration-page
   :registration-view #'registration-view-page
   :rounds            #'rounds-page
   :pairings          #'pairings-page
   :ballots           #'ballots-page
   :reporting         #'reporting-page
   :room-editor       #'rooms-editor-page
   :judge-editor      #'judges-editor-page
   :team-editor       #'teams-editor-page
   :school-editor     #'schools-editor-page
   :settings          #'settings-page})

(defn page []
  (let [active (subscribe [:active-page])]
    (fn []
      [:div (when @active [(get pages @active)])])))

(secretary/defroute "/" []
                    (dispatch [:get-tournaments])
                    (dispatch [:set-active-page :home]))
(secretary/defroute "/new" []
                    (dispatch [:set-active-page :new-tournament]))
(secretary/defroute "/:tid/dashboard" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:set-active-page :dashboard]))
(secretary/defroute "/:tid/registration" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:get-tournament tid])
                    (dispatch [:get-teams tid])
                    (dispatch [:get-schools tid])
                    (dispatch [:get-judges tid])
                    (dispatch [:get-speakers tid])
                    (ws/make-websocket! (str "/ws/" tid "/editor/teams") #(dispatch [:update-teams %]) :teams)
                    (ws/make-websocket! (str "/ws/" tid "/editor/speakers") #(dispatch [:update-speakers %]) :speakers)
                    (ws/make-websocket! (str "/ws/" tid "/editor/judges") #(dispatch [:update-judges %]) :judges)
                    (dispatch [:set-active-page :registration]))
(secretary/defroute "/:tid/registration-view" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:get-tournament tid])
                    (dispatch [:get-teams tid])
                    (dispatch [:get-schools tid])
                    (dispatch [:get-speakers tid])
                    (ws/make-websocket! (str "/ws/" tid "/editor/teams") #(dispatch [:update-teams %]) :teams)
                    (ws/make-websocket! (str "/ws/" tid "/editor/speakers") #(dispatch [:update-speakers %]) :speakers)
                    (dispatch [:set-active-page :registration-view]))
(secretary/defroute "/:tid/pairings" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:get-tournament tid])
                    (dispatch [:get-rounds tid])
                    (dispatch [:get-teams tid])
                    (dispatch [:set-active-page :rounds]))
(secretary/defroute "/:tid/pairings/:rid" [tid rid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:set-active-round rid])
                    (dispatch [:get-tournament tid])
                    (dispatch [:get-teams tid])
                    (dispatch [:get-schools tid])
                    (dispatch [:get-judges tid])
                    (dispatch [:get-rooms tid])
                    (dispatch [:get-round-rooms tid rid])
                    (dispatch [:get-stats tid rid])
                    (ws/make-websocket! (str "/ws/" tid "/editor/teams") #(dispatch [:update-teams %]) :teams)
                    (ws/make-websocket! (str "/ws/" tid "/editor/judges") #(dispatch [:update-judges %]) :judges)
                    (ws/make-websocket! (str "/ws/" tid "/editor/scratches") #(dispatch [:update-scratches %]) :scratches)
                    (ws/make-websocket! (str "/ws/" tid "/editor/speakers") #(dispatch [:update-speakers %]) :speakers)
                    (ws/make-websocket! (str "/ws/" tid "/editor/rooms") #(dispatch [:update-rooms %]) :rooms)
                    (ws/make-websocket! (str "/ws/" tid "/" rid "/round-rooms") #(dispatch [:update-round-rooms %]) :round-rooms)
                    (dispatch [:set-active-page :pairings]))
(secretary/defroute "/:tid/ballots" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:get-tournament tid])
                    (dispatch [:get-rounds tid])
                    (dispatch [:get-teams tid])
                    (dispatch [:get-schools tid])
                    (dispatch [:get-judges tid])
                    (dispatch [:get-speakers tid])
                    (dispatch [:get-rooms tid])
                    (dispatch [:set-active-page :ballots]))
(secretary/defroute "/:tid/reporting" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:set-active-page :reporting]))
(secretary/defroute "/:tid/editor/rooms" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:get-rooms tid])
                    (ws/make-websocket! (str "/ws/" tid "/editor/rooms") #(dispatch [:update-rooms %]))
                    (dispatch [:set-active-page :room-editor]))
(secretary/defroute "/:tid/editor/judges" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:get-judges tid])
                    (dispatch [:get-teams tid])
                    (dispatch [:get-scratches tid])
                    (dispatch [:get-schools tid])
                    (ws/make-websocket! (str "/ws/" tid "/editor/judges") #(dispatch [:update-judges %]) :judges)
                    (ws/make-websocket! (str "/ws/" tid "/editor/scratches") #(dispatch [:update-scratches %]) :scratches)
                    (dispatch [:set-active-page :judge-editor]))
(secretary/defroute "/:tid/editor/teams" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:get-tournament tid])
                    (dispatch [:get-teams tid])
                    (dispatch [:get-schools tid])
                    (dispatch [:get-speakers tid])
                    (ws/make-websocket! (str "/ws/" tid "/editor/teams") #(dispatch [:update-teams %]) :teams)
                    (ws/make-websocket! (str "/ws/" tid "/editor/speakers") #(dispatch [:update-speakers %]) :speakers)
                    (dispatch [:set-active-page :team-editor]))
(secretary/defroute "/:tid/editor/schools" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:set-active-page :school-editor]))
(secretary/defroute "/:tid/settings" [tid]
                    (dispatch [:set-active-tournament tid])
                    (dispatch [:get-users tid])
                    (dispatch [:get-tournament tid])
                    (dispatch [:set-active-page :settings]))
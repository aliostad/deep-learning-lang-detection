(ns experiment.views.templates
  (:use
   experiment.infra.models
   noir.core
   hiccup.core
   hiccup.page-helpers
   hiccup.form-helpers
   handlebars.templates)
  (:require
   [noir.response :as response]
   [experiment.views.bootstrap :as boot]))


;; # Dynamic Template Loader API endpoint

(defpage load-template [:get "/api/templates/:id"]
  {:keys [id]}
  (response/content-type
   "text/html"
   (html-template
    (get-template id))))

;;
;; Template Views for System Objects
;;

;; # Breadcrumbs

(deftemplate breadcrumbs-view
  [:ul.breadcrumb
   (%each path
          [:li {:class (% class)}
           [:a {:href (% url)} (% name)]
           [:span.divider "/"]])
   (%with tail
          [:li {:class "active"}
           [:a {:href (% url)} (% name)]])])

;; # Pagination

(deftemplate pagination-view
  [:ul
   (%each this
          [:li {:class (% class)} [:a {:href "#"} (% text)]])])

;; # Scheduling

(deftemplate scheduler-view
  [:div
   [:div.page-header
    [:h1 "Configure Instrument Tracker"]]
   [:ul#schedTab.nav.nav-tabs
    (%if daily [:li [:a {:href "#daily"} "Daily"]])
    (%if weekly [:li [:a {:href "#weekly"} "Weekly"]])
    (%if periodic [:li [:a {:href "#periodic"} "Periodic"]])]
   [:div.tab-content.well
    [:div#daily.tab-pane]
    [:div#weekly.tab-pane]
    [:div#periodic.tab-pane]]
   [:div.controls
    [:button.btn.btn-primary.accept "Configure"]
    [:button.btn.cancel "Cancel"]]])


;; # Instrument Templates

(deftemplate journal-page
  [:div.row.journal-page
   [:div.span7.jvl]
   [:div.span5.jvp]])

(deftemplate journal-view
  [:div.well
   [:div.journal-header
    [:span.pull-left
     [:p {:style "text-align: center;"} (% date-str)]]
    [:span.pull-right
     [:span#purpose.btn-group
      [:a.btn.btn-mini.dropdown-toggle
       {:data-toggle "dropdown"
        :href "#" 
        :style "margin-right: 10px;"}
       (% annotation) " " [:span.caret]]
      [:ul.dropdown-menu
       [:li [:a.option {:href "#"} "Note"]]
       [:li [:a.option {:href "#"} "Change"]]
       [:li [:a.option {:href "#"} "Adverse"]]]]
     "&nbsp;"
     [:span#sharing.btn-group
      [:a.btn.btn-mini.dropdown-toggle
       {:data-toggle "dropdown"
        :href "#" 
        :style "margin-right: 10px;"}
       (% sharing) " " [:span.caret]]
      [:ul.dropdown-menu
       [:li [:a.option {:href "#"} "Private"]]
       [:li [:a.option {:href "#"} "Friends"]]
       [:li [:a.option {:href "#"} "Public"]]]]]
    [:div.clear]]
   [:form {:style "clear: both;"}
    [:hr]
    (boot/ctrl-group
     ["Tagline" "short"]
     (boot/input {:id "journal-short" :maxlength "40"} "text" "short" (% short)))
    (boot/ctrl-group
     ["Long Entry" "content"]
     (boot/textarea {:rows "15"
                     :cols "80"
                     :class "input-xlarge"
                     :id "journal-content"
                     :style "resize: none;"}
                    "content"
                    (% content)))]])

(deftemplate journal-list
  [:div
   [:span [:h2.pull-left "Journal Entries"]
    [:span.pull-right [:button.btn.btn-primary.new "New Entry"]]]
   [:table.table
    [:thead
     [:tr
      [:th "Date"]
      [:th "Description"]
      [:th "Type"]
      [:th "Sharing"]]]
    [:tbody
     (%each journals
            [:tr {:data (% id)}
             [:td.time
              (% date-str)]
             [:td.short
              (% short)]
             [:td.anno
              (% annotation)]
             [:td.sharing
              (% sharing)]
             [:td.del
              [:button.btn.btn-mini.btn-danger.del
               [:i.icon-remove.icon-white]]]
             ])]]])

;; Dashboard Overview Page

(deftemplate overview-page
  [:div 
   [:div.row
    [:div#summary-pane.span12]]
   [:div.row
    [:div#calendar-pane.span4]
    [:div#feeds-pane.span4 [:p " "]]
    [:div#journal-pane.span4]]])

(deftemplate dashboard-help
  [:div.help-pane
;;   [:h3 {:style "text-align: center;"} "Help"]
   [:p "This page contains a summary of your activity.  What can you do?"]
   [:dl
    [:dt "Select a trial"]
    [:dd "You can select between more than one trial by clicking on the arrows in the upper right corner under 'Select Trial'."]
    [:dt "Pause a trial"]
    [:dd "If you are busy, you can pause the trial
        temporarily which will stop all data collection and pause the analysis.
        If you pause for more than a few days, you may have to repeat."]]])

;; Related Objects List

(deftemplate related-objects
  [:div.related-objects
   [:table.table
    [:thead
     [:th
      [:td "Type"]
      [:td "Name"]]]
    [:tbody
     (%each this
            [:tr
             [:td (% type)]
             [:td (% name)]])]]])

;; TIMELINE

(deftemplate timeline-header
  [:div#timeline-header {:style "height: 60px;"}
   [:div.page-header
    [:span {:style "display: inline;"}
     [:h1.pull-left "Timeline"]
     [:div.pull-right.btn-group
       [:a.btn.dropdown-toggle {:data-toggle "dropdown" :href "#"}
        "Show/Hide "
        [:span.caret]]
      [:ul.dropdown-menu]]
     [:div.pull-right {:style "padding-left: 10px;"} [:p] ]
     [:div.pull-right 
      [:input {:type "text" :name "timelinerange" :value (% range) :id "timelinerange"}]]]
    [:div {:style "clear:both;"}]]])
    
;; EVENT LOG

(deftemplate event-log
  [:div
   [:div.page-header
    [:div
     [:h1.pull-left "Event Log"]
     [:span.pull-right {:style "display: inline;"}
      [:input {:type "text" :name "eventrange" :value (% range) :id "eventrange"}]]
     [:div {:style "clear: both;"}]]]
   [:div.row
    [:div#eventlist.span7]
    [:div#eventother.span5 [:p]]]])

(deftemplate event-view
  [:div.event-view
   (%if editable
        [:div {:style "float: right;"}
         [:a.edit-event {:href "#"}
          [:i.icon-edit]]])
   [:div
    (%if success [:i.icon-ok])
    (%if fail [:i.icon-remove])
    (%if instrument
         (%with instrument
                [:b (% variable) " (" (% service) ")"
                 [:a.view-timeline {:href "#"}
                  [:i.icon-eye-open]]]))
    (%unless instrument
             [:b "Treatment Reminder" [:i.icon-comment]])]
   [:div (% local-time) ":&nbsp;" (% message)] ;; (% status) " " 
   (%if result-val
        [:div.response (% result-time) ":&nbsp;" [:b "Response: '"] (% result-val) "'"])
   (%if error [:div.error (% error)])
   [:div.event-editor.hidden
    [:input.event-data {:type "text"}]
    [:button.btn.btn-primary.submit-event {:type "button"} "Record"]
    [:button.btn.cancel-event {:type "button"} "Cancel"]]])


;; TRIAL

(deftemplate trial-view-frame
  [:div.well
   [:div#trial-pane-wrapper
    (%if empty
         [:h2 {:style "text-align:center;margin-left:auto;margin-right:auto;margin-top:100px;width:10em"}
          [:a {:href "/explore/search/query/show experiments/p1"} "Find an Experiment, Start a Trial"]])]
   [:p]])

(defelem render-decorated-button [name & [icon-class]]
  [:a {:href "#"}
   [:button.btn.btn-small 
    [:i {:class (or icon-class "")}] name]])

(deftemplate trial-view-header
  [:div.trial-header
   [:div.trial-title-bar 
    [:div.pull-left {:style "padding-bottom: 12px;"}
     [:h3 " Trial: " (% experiment.title)]]
    [:div.pull-right {:style "padding-bottom: 12px;"}
     [:div.trial-nav-note {:style "margin-top: -10px; font-size: tiny; text-align: center;"}
      "Select Trial"]
     [:div.btn-group
      [:button.btn.btn-mini.prev [:i.icon-chevron-left]]
      [:button.btn.btn-mini.next [:i.icon-chevron-right]]]]]
   [:div.trial-info-bar.clear-both 
    [:div.pull-left.trial-stats
     [:p [:b "Started: "]
      [:span.label.label-info (% start_str)]]
     (%unless donep
              [:p [:b "Current status: "]
               (%unless pausedp [:span.label.label-success (% status_str)])
               (%if pausedp [:span.label.label-warning (% status_str)])])
     (%if donep
          [:p [:b "Ended: "]
           [:span.label.label-fail (% end_str)]])]
    [:div.pull-right.trial-actions.btn-group
     (%unless pausedp
              (render-decorated-button
               {:class "pause" :rel "tooltip" :title "Pause the trial"}
               "Pause" "icon-pause"))
     (%if pausedp
          (render-decorated-button
           {:class "resume" :rel "tooltip" :title "Resume the trial"}
           "Resume" "icon-play"))
     (%unless donep
              (render-decorated-button
               {:class "cancel" :rel "tooltip" :title "Terminate the trial"}
               "Cancel" "icon-stop"))
     (%if donep
          (render-decorated-button
           {:class "archive" :rel "tooltip" :title "Archive the Trial"}
           "Archive" "icon-eject"))]]
    [:hr.clear-both]])
    
    
(deftemplate trial-table
  [:div.trial-table
   [:h2.trial-table-header]
   [:ul.trial-table-list
    (%each trials
	   [:li.trial-table-list-entry
	    [:span.trial-title (% experiment.title)]
	    [:p (%with stats
		       (%str "Run for " (% elapsed) " days with " (% remaining) " days remaining"))]])]])

(deftemplate configure-trial-view
  [:div.configure-trial
   [:div.row
    [:div.page-header
     [:div.span7
      [:h1 "Configuring new trial"]]
     [:div.span4]
     [:div {:style "clear:both;"}]]]
   [:div.row
    [:div.span12
     [:div
      (%with experiment
             (%with treatment
                    [:h3 "For treatment: " (% name)]))]
     [:div#configureForm]
     [:div#configureTrackers]
     [:hr]]]
   [:div.row
    [:div.span3 [:p]]
    [:div.span5
     [:button.btn.btn-large.btn-success.accept.pull-left
      {:type "button"} "Create"]
     [:button.btn.btn-large.btn-danger.cancel.pull-right
      {:type "button"} "Cancel"]]]])
     
   

(defn tag-list []
  [:div.tags
   (%each tags
    [:span.label.label-info (% this)] "&nbsp;")])

;; TREATMENT

(deftemplate treatment-list-view
  [:div.result.treatment-list-view
   [:h3 [:a.title {:href "#" :data-id (% id)} ;; (%str "/explore/view/" (% type) "/" (% id)) }
         [:i.icon-play] " " (% name)]]
   [:p (% description)]
   [:div.tags
    (%each tags
           [:span.label.label-info (% this)] "&nbsp;")]])

(deftemplate treatment-row-view
  [:tr [:td [:a.title {:href "#" :data-id (% id) :data-type (% type)}
             [:i.icon-play] " " (% name)]]])

(deftemplate treatment-view
  [:div.treatment-view.object-view
   [:div.row
    [:div.page-header
     [:div.span7
      [:h1 (% name)]]
     [:div.span4
      [:span.pull-right
       [:button.btn.btn-large.btn-primary.experiment {:type "button"} "Create Experiment"]
       (%if owner [:button.btn.btn-large.edit {:type "button"} "Edit"])
       [:button.btn.btn-large.clone {:type "button"} "Clone"]]]
     [:div {:style "clear:both;"}]]]
   [:div.row
    [:div.span5
     [:h3 "Protocol"]
     [:p (%code description-html)]
     [:p [:b "Behavior"]]
     [:p
      [:span "Onset period of " (% dynamics.onset) " days, &nbsp;"]
      [:span "Washout period of " (% dynamics.washout) " days"]]
     [:p [:b "Tags "]
      [:a.add-tag {:href "#"} [:i.icon-plus-sign]]]
     [:p.tags
      (%each tags
             [:span.label.label-info (% this)] "&nbsp;")]
     [:div#discuss]]
    [:div.span1 [:p]]
    [:div.span6
     ;; Related, Discussion
     [:div#related]]
;;     [:div.row.conversations [:h2 "Conversations"]]
     ]])

(deftemplate treatment-editor
  [:div.treatment-edit.object-editor
   [:div.row
    [:div.page-header
     [:div.span7
      (%if name [:h1 "Editing " (% name)])
      (%unless name [:h1 "Create a new Treatment"])]
     [:div.span4]
     [:div {:style "clear:both"}]]]
   [:div.row
    [:div.span12
     [:div#editForm]]]
   [:div.row
    [:div.span3 [:p]]
    [:div.span5
     [:button.btn.btn-large.btn-success.accept.pull-left
      {:type "button"}
      (%if name "Update")
      (%unless name "Create")]
     [:button.btn.btn-large.btn-danger.cancel.pull-right
      {:type "button"} "Cancel"]]]])

;; INSTRUMENT

(deftemplate instrument-list-view
  [:div.result.instrument-list-view
   [:h3 [:a.title {:href "#" :data-id (% id) :data-type (% type)} ;; (%str "/explore/view/" (% type) "/" (% id)) }
         [:i.icon-eye-open {:style "vertical-align:middle"}] " " (% variable) " (" (% service) ")"]]
   [:p (% description)]
   [:p.tags
    (%each tags
      [:span.label.label-info (% this)] "&nbsp;")]])


(deftemplate instrument-short-table
  [:div {:class "instrument-short-table"}
   [:ul
    (%each instruments
	   [:li
	    [:a {:href (%strcat "/app/search/instrument/" (% id))}
	     [:span {:class "variable"} (% name)]
	     [:span {:class "type"} (% service)]]])
    ]])

(deftemplate instrument-row-view
  [:tr [:td [:a.title {:href "#" :data-id (% id) :data-type (% type)}
             [:i.icon-eye-open] " " (% variable) " -- " (% service)]]])

(deftemplate instrument-view
  [:div.instrument-view
   [:div.row
    [:div.page-header
     [:div.span8
      [:h1 (%if tracked [:a {:href "/dashboard/timeline"} (% variable)])
           (%unless tracked (% variable))
       " -- " [:a {:href "/account/services"} (% service)]]]
     [:div.span3
      [:span.pull-right
       (%if owner [:button.btn.btn-large.edit "Edit"])
       (%if tracked [:button.btn.btn-large.untrack "Untrack"])
       (%unless tracked [:button.btn.btn-large.track "Track"])]]
     [:div {:style "clear:both;"}]]]
   [:div.row
    [:div.span5
     [:h3 "Description"]
     [:p (%code description-html)]
     [:p [:b "Tags "]
      [:a.add-tag {:href "#"} [:i.icon-plus-sign]]]
     [:p.tags
      (%each tags
             [:span.label.label-info (% this)] "&nbsp;")]]
    [:div.span1 [:p]]
    [:div.span6
     ;; Related, Discussion
     [:div#related]
     ]]])
     

(deftemplate instrument-editor
  [:div.instrument-edit.object-editor
   [:div.row
    [:div.page-header
     [:div.span7
      [:h1 "Editing " (% variable) " -- " (% service)]]
     [:div.span4]
     [:div {:style "clear:both"}]]]
   [:div.row
    [:div.span12
     [:div#editForm]]]
   [:div.row
    [:div.span3 [:p]]
    [:div.span5
     [:button.btn.btn-large.btn-success.accept.pull-left
      {:type "button"} "Update"]
     [:button.btn.btn-large.btn-danger.cancel.pull-right
      {:type "button"} "Cancel"]]]])

;; EXPERIMENT
   
(deftemplate experiment-list-view
  [:div.result.experiment-list-view
   [:h3 [:a.title {:href "#" :data-id (% id)} ;; (%str "/explore/view/" (% type) "/" (% id)) }
        [:i.icon-random] " " (% treatment.name)]]
   [:p (% title)]
   [:ul
    (%each instruments
           [:li (% variable) "(measured by " (% service) ")"])]])

(deftemplate experiment-row-view
  [:tr [:td [:a.title {:href "#" :data-id (% id)}
             [:i.icon-random] " " (% title)]]])
  
(deftemplate experiment-view
  [:div.experiment-view
   [:div.row
    [:div.page-header
     [:div.span8
      [:h1 {:href ""}
       (% title)]]
     [:div.span3
      [:span.pull-right
       [:button.btn.btn-primary.btn-large.run {:type "button"} "Start Trial"]
       (%if owner [:button.btn.btn-large.edit {:type "button"} "Edit"])
       [:button.btn.btn-large.clone {:type "button"} "Clone"]]]
     [:div {:style "clear:both;"}]]]
   [:div.row
    [:div.span5
     (%with treatment
            [:h3 "Protocol"]
            [:p "&nbsp; from: " [:a.view {:href "#" :data-id (% id)} (% name)]]
            [:p (%code description-html)])
     [:p [:b "Outcome Measure"]]
     (%each outcome
            [:p [:a.view {:href "#" :data-id (% id)} (% variable) " -- " (% service)]
             "&nbsp;"
             [:a.timeline {:href "/dashboard/timeline" :data-id (% id)}
              [:i.icon-eye-open]]])
     [:p [:b "Other Measures"]]
     (%each covariates 
            [:p [:a.view {:href "#" :data-id (% id)} (% variable) " -- " (% service)]
             "&nbsp;"
             [:a.timeline {:href "/dashboard/timeline" :data-id (% id)}
              [:i.icon-eye-open]]])
     [:p [:b "Tags: "] [:a.add-tag {:href "#"} [:i.icon-plus-sign]]]
     [:p.tags
      (%each tags
             [:span.label.label-info (% this)] "&nbsp;")]]
    [:div.span1 [:p]]
    [:div.span6
     [:div#related]
     [:div#trials]]]
   [:div.row
    [:div#discuss.span12]]])
;;   [:h2 "Schedule"]
;;   [:div.schedule "Schedule view TBD"]])

(deftemplate experiment-editor
  [:h1 "Experiment Creator Coming Soon"])

;; COMMENT

(deftemplate comment-short-view
  [:div.comment-short
   [:p.comment-text (% content)]
   [:p.comment-sig
    (%strcat "@" (% username))
    " at " (% date-str)]])






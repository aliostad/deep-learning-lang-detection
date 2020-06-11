(ns bmihw.submit
  (:require [bmihw.common :refer [auth fb drunk?]]
            [reagent.core :refer [render-component]]
            [reagent-forms.core]
            [clojure.string :refer [trim split join]]
            [ajax.core :refer [GET]]))

(defn success! []
  (doseq [elem (-> js/document (.querySelectorAll "input") array-seq)]
    (set! (.-value elem) ""))
  (js/alert "YOU SUBMITTED SUCCESSFULLY."))

(defn submit-to-fb! []
  (let [provider (get @auth "provider")
        target-username (.-value (.querySelector js/document (str "#" provider "-username")))
        keyword (.-value (.querySelector js/document (str "#" provider "-keyword")))
        content (.-value (.querySelector js/document (str "#" provider "-content")))
        state {:target-username target-username
               :keyword keyword
               :content content
               :drunk @drunk?}]
    (cond
      (not (or (seq target-username) (seq keyword)))
      (js/alert "YOU NEED A USERNAME OR KEYWORD.")
      
      (not (seq content))
      (js/alert "YOU NEED CONTENT.")
      
      :else
      (.push fb
        (clj->js (merge state
                        (select-keys @auth ["uid" "provider"])
                        (select-keys (get @auth provider) ["accessToken" "accessTokenSecret" "username"])))
        (fn [error]
          (if error
            (js/alert (str "ERROR: " error))
            (success!)))))))

(defn set-name! [name]
  (let [elem (.querySelector js/document "#twitter-username")]
    (set! (.-value elem) name)))

(defn friends-component [friends-edn]
  [:div
   "Quickly set a user:"
   [:br]
   (for [friend friends-edn]
     [:button {:on-click #(set-name! (:screen_name friend))}
      [:img {:src (:profile_image_url friend)}]
      [:br]
      (:name friend)])])

(defn get-friends! []
  (GET "/twitter-friends"
       {:params (select-keys (get @auth "twitter") ["accessToken" "accessTokenSecret" "username"])
        :handler (fn [response-str]
                   (let [response-edn (cljs.reader/read-string response-str)
                         elem (.querySelector js/document "#twitter-friends")]
                     (if-let [error (:error response-edn)]
                       (js/alert (str "ERROR: " error))
                       (render-component [friends-component response-edn]
                                         (.querySelector js/document "#twitter-friends")))))
        :error-handler (fn [{:keys [status status-text]}]
                         (js/alert (str "ERROR: " status " " status-text)))})
  nil)

(defn submit-page []
  [:div [:h2 "Schedule your insult."]
   [:div
    [:div
     (case (get @auth "provider")
       "twitter"
       [:div
        "When a tweet is sent by "
        [:input {:id "twitter-username" :type :text :placeholder "Username" :class "control small"}]
        [:br]
        "and/or a tweet contains "
        [:input {:id "twitter-keyword" :type :text :placeholder "Keyword" :class "control small"}]
        [:br]
        "write the following tweet:"
        [:br]
        [:input {:id "twitter-content" :type :text :placeholder "Content" :class "control big"}]
        [:br]
        [:button {:id "submit" :class "control" :on-click submit-to-fb!}
         "SCHEDULE IT!"]
        [:br]
        [:div {:id "twitter-friends"}
         (get-friends!)]]
       
       "github"
       [:div
        "When a commit is made by "
        [:input {:id "github-username" :type :text :placeholder "Username" :class "control small"}]
        [:br]
        "and it contains "
        [:input {:id "github-keyword" :type :text :placeholder "Keyword" :class "control small"}]
        [:br]
        "write the following issue:"
        [:br]
        [:input {:id "github-content" :type :text :placeholder "Content" :class "control big"}]
        [:br]
        [:button {:id "submit" :class "control" :on-click submit-to-fb!}
         "SCHEDULE IT!"]]
       
       ; else
       [:a {:href "/"} "Return to home."])]
    [:br]
    [:div [:a {:href "#/manage"} "Manage Submissions"]]]])

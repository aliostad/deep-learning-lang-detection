(ns tinyforum.views.common
  (:require [noir.response :as resp])
  (:require [noir.session :as sess])
  (:require [tinyforum.models.users :as users])
  (:require [noir.util.crypt :as crypt])
  (:use [noir.core :only [defpartial defpage]]
        [tinyforum.util.utils]
        [tinyforum.models.static :only [get-masthead get-footer]]
        [tinyforum.models.comments :only [cid-is-valid?]]
        [clojure.string :only [split]]
        [tinyforum.models.removal :only [user-delete!]]
        [markdown.core]
        [hiccup.element :only  [link-to]] 
        [hiccup.form :only [form-to
                            label text-field label
                            password-field submit-button]]
        [hiccup.page :only [include-css include-js html5]]))

(defn map-tag [tag xs]
  (map (fn [x] [tag x]) xs))

(defn strip-email-domain [email]
  (first (split email #"@")))

(defn flash! [m] (sess/flash-put! :message m) nil)
(defn err! [e] (sess/put! :err e) nil)
(defn err-read [] (sess/get :err) nil)
(defn err-clear! [] (sess/remove! :err) nil)
(defn seen? [id] (if (sess/get :seen) 
                   (in? (clojure.string/split (sess/get :seen) #" ") (str id))
                   nil))
(defn comment-seen? [cid] (if (sess/get :c-seen) 
                            (in? (clojure.string/split (sess/get :c-seen) #" ") 
                                 (str cid))
                            nil))
(defn saw! [id] 
  (sess/put! :seen 
             (if (sess/get :seen)
               (clojure.string/join #" "
                 (set (conj 
                          (filter cid-is-valid? (clojure.string/split (sess/get :seen) #" "))
                          (str id))))
               (str id))))
(defn comment-saw! [cid] 
  (sess/put! :c-seen 
             (if (sess/get :c-seen)
               (clojure.string/join 
                 #" " (set (conj 
                          (clojure.string/split (sess/get :c-seen) #" ")
                          (str cid))))
               (str cid))))

(defn create-user [email password]
  (users/user-set-email! email email)
  (users/user-set-pass! email password)
  (sess/put! :email email)
  (users/user-get email))

(defn check-login [email password regis]
  (if (some empty? [email password])
    (and (err! "Please complete all fields.")
        nil)
    (if-not (re-find email-regex email)
      (and (err! "Not a valid email address.") (resp/redirect "/login")) 
      (if-let [user (users/user-get email)]
        (if (crypt/compare password (:pass user))
          (do
            (sess/put! :email email)
            user)
          (and (err! "Username and/or password did not match a registered user") 
               (resp/redirect "/login")))
        (if regis 
          (create-user email password)
          (and (err! "Username and/or password did not match a registered user") 
               (resp/redirect "/login")))))))

(defn logged-in? []
  (if (= nil (sess/get :email))
    false
    true))

(defpartial site-layout [& content]
            (html5
              [:head
               [:title "tinyforum"]
               (include-js "http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js")
               (include-js "/js/shCore.js")
               (include-js "/js/shBrushBash.js")
               (include-js "/js/shBrushCpp.js")
               (include-js "/js/shBrushJava.js")
               (include-js "/js/shBrushPython.js")
               (include-js "/js/shBrushClojure.js")
               (include-js "/js/main.js")
               (include-css "/css/bootstrap-responsive.css")
               (include-css "/css/bootstrap.css")
               (include-css "/css/shCore.css")
               (include-css "/css/shThemeDefault.css")
               (include-css "/css/style.css")]
              [:body
               [:div.main-container
               [:div.masthead 
                [:ul.nav.nav-pills.pull-right
                 [:li [:a {:href "/"} "Home"]]
                 [:li [:a {:href "/faq"} "FAQ"]]
                 (if-not (logged-in?)
                   [:li [:a {:href "/login"} "Login"]] 
                   (list [:li (link-to "/manage" "Manage")] 
                         [:li (form-to [:post "/logout"]
                                (submit-button {:id "logout"} "Logout"))]))]
                [:h3.muted (get-masthead)]]
                (when-let [u (sess/get :email)]
                  [:h3.currentuser (str "user: " u) 
                   (if (users/is-admin? u)[:b {:style "color:#90c8e0;"} " (admin)"])])
                [:hr]
                [:div.headingbar
                 (if-let [err (sess/get :err)]
                   [:div.error [:h4#errorcontent err]]
                   (when-let [message (sess/flash-get :message)]
                             [:div.message [:h4#messagecontent message]]))
                 (err-clear!)
                 content]
                [:hr]
                [:div.footer (md-to-html-string (get-footer))]
                ]]))

(defpartial please-login []
            [:div.nologin {:style ""}
             [:h4 "please login to post"]])

(defpartial login-form []
  (form-to [:post "/login"]
           [:fieldset {:style "margin-left: 34%"}
            [:label "email:"]
            (text-field "e")
            [:label "password:"]
            (password-field "p")
            [:br] (submit-button "Submit")]))

(defpartial register-form []
  (form-to [:post "/register"]
           [:fieldset {:style "margin-left: 34%"}
            [:label "email:"]
            (text-field "re")
            [:label "password:"]
            (password-field "rp")
            [:label "re-enter password:"]
            (password-field "rp-too")
            [:br](submit-button "Submit")]))

(defpage "/logout" []
  (site-layout
    (if (logged-in?)
      [:h2 "I don't think you want to be here..."])))

(defpage [:post "/logout"] []
  (sess/remove! :email) 
  (resp/redirect (sess/get :referral)))

(defpage "/login" []
  (site-layout
    [:h2 {:style "text-align:center;"} "Login?"] 
    (login-form)
    [:br] [:hr] [:br]
    [:h2 {:style "text-align:center;"} "Register?"]
    (register-form)))

(defpage "/register" []
  (resp/redirect "/login"))

(defpage [:post "/login"] {:keys [e p]}
  (if (check-login e p false) 
    (do (flash! (str "You have logged in successfully."))
    (resp/redirect (sess/get :referral))) 
    (resp/redirect "/login")))

(defpage [:post "/register"] {:keys [re rp rp-too]}
  (if (= rp rp-too) 
    (if-let [res (check-login re rp true)] 
        (resp/redirect (or (sess/get :referral) "/") )
        (resp/redirect "/login"))
    (or (err! "Passwords entered do not match.")
         (resp/redirect "/login"))))

(defpage [:post "/user/:email/remove"] {:keys [email]}
  (if (users/is-admin? (sess/get :email))
    (or (flash! (str "User " email " deleted."))
    (user-delete! email)))
  (resp/redirect (or (sess/get :referral) "/")))


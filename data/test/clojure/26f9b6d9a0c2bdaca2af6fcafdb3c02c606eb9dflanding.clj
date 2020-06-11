(ns checkmate.views.landing)

(defn render []
  {:body
   [:div.jumbotron
    [:div.container
     [:h1 "Check-Mate" [:small "A checklist app for you and your phone."]]
     [:p "Check-Mate's intent is to provide you a simple way to manage personal checklists."]
     [:p "Check-Mate is in private beta right now, meaning if you want to use it, you have to send me a " [:a {:href "mailto:scheibenkaes+checkmate@googlemail.com"} "message"] " and I'll provide you an account to it."]
     [:p [:a.btn.btn-default {:href "/az"} "Login"]]]]})

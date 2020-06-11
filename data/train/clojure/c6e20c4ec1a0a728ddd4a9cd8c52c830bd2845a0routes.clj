(ns recipe.routes
  (:use compojure.core
	[hiccup core page-helpers]
        recipe.manage-redis
	recipe.scraperecipe
	[recipe.wordlabels :only (boring-keywords)]
        [hiccup.middleware :only (wrap-base-url)] :reload)
  (:require [compojure.route :as route]
            [compojure.handler :as handler]
            [compojure.response :as response]))

(defn start-lookup [unsearched-keywords]
    (doseq [unsearched unsearched-keywords]
	(search-and-add-keyword unsearched)))
	

(defn get-recipe-html-vec [keywords]
    (let [good-keywords (filter #(and (= :good (check-keyword %)) (not (boring-keywords %))) keywords)
	  ingredients (construct-recipe good-keywords)]
	(if (empty? ingredients) "Gosh, I have no idea. Is that even food?"
	    (into [:ul] (map #(vector :li %) ingredients)))))


(defn page [keywords]
  (println "keys:" keywords)
  (let [display-title  (clojure.string/join " " (map clojure.string/capitalize keywords))
	unsearched-keywords (filter #(= :search (check-keyword %)) keywords)
	need-to-search (not (empty? unsearched-keywords))]
    (do
      (.start (Thread. #(start-lookup unsearched-keywords)))
      (html5
       [:head 
	[:title (str "Recipe-Roulette:" display-title)]
	[:link {:rel "icon" :type "image/png" :href "/images/favicon.png"}]
	(include-css "/css/bootstrap.css")
	(include-js "/scripts/jquery.js")
	(include-js "/scripts/main.js")
	[:script {:type "text/javascript"} (str "var random_title = \"" (clojure.string/join "-" (n-random-keywords 3)) "\";")]
	(if need-to-search
	  (include-js "/scripts/searching.js") "")
	[:script {:type "text/javascript"} (str "var recipe_title_string = \"" (clojure.string/join "-" keywords) "\";")]]
       [:body
	[:div.container {:style "width: 700px; text-align: center;"}
	 [:h1.page-title "Recipe Roulette"] 		
	 [:div.well
	  [:h1.recipe-title {:style "padding-bottom: 30px;"} display-title]
	  [:div
	   (if need-to-search
	     [:div 
	      [:h3 (str "I've never encountered " (clojure.string/join " or " unsearched-keywords) " before.")]
	      [:h4 "searching the internet..."]
              [:div#main-content-div]]
	     (get-recipe-html-vec keywords))
	   ]]
	 [:h3.lead "Make up a recipe name:"]
	 [:p [:input#main-input {:class "span3" :type "text"} ]]
	 [:p [:button#make-recipe-btn {:class "large btn primary"} "Create Recipe"]
	  " "
	  [:button#random-btn {:class "large btn primary"} "Random Recipe"]]
	 [:hr {:style "margin-top: 50px;"}]
	 [:p.smalltext "This AI creates random recipes using data scoured from the internet. 
	       It was built on a whim by Benjie Holson."]
	 [:p.smalltext "Built with "
			    [:a {:href "http://clojure.org/"} "clojure"] ", " 
			    [:a {:href "http://coffeescript.org/" } "coffeescript"]", " 
			    [:a {:href "redis.io"} "redis"] " and " 
			    [:a {:href "http://twitter.github.com/bootstrap/"} "twitter-bootstrap"] 
			    " using the superhero swatch from " 
			    [:a {:href "http://bootswatch.com/#swatches"} "bootswatch"]]
	 [:p.smalltext "The source is available" 
	  [:a {:href "https://github.com/robobenjie/Recipe-Roulette"} " here"] "."]
	 [:p.smalltext "Discuss on " [:a {:href "http://news.ycombinator.org/item?id=3681071"} "Hacker News"]]
	 ]]))))


(defn recipe-page [keyword-string]
  (page (clojure.string/split (clojure.string/lower-case (clojure.string/replace keyword-string #"[\(\)\[\]]" ""))  #"-")))

(defn random-page []
  (page (n-random-keywords 3)))

(defn get-recently-scraped [keyword-string]
  (let [keywords (clojure.string/split (clojure.string/lower-case keyword-string)  #"-")
        titles (mapcat recently-scraped keywords)]
    (html5 (into [:ul]  (map #(vector :li %) titles)))))

(defroutes main-routes
  (GET "/" [] (random-page))
  (GET "/:keywords" [keywords] (recipe-page keywords))
  (POST "/waiting" [search-string] (do (println "got"search-string "from client") (get-recently-scraped search-string)))
  (route/resources "/")
  (route/not-found "404rd!"))




(def app
  (-> (handler/site main-routes)
      (wrap-base-url)))
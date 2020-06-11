;;      Filename: home_page.cljs
;; Creation Date: Monday, 01 December 2014 06:22 PM AEDT
;; Last Modified: Sunday, 15 February 2015 02:32 PM AEDT
;;        Author: Tim Cross <theophilusx AT gmail.com>
;;   Description:
;;

(ns mcljs.views.home-page)

(defn home-page []
  [:div.container
   [:div.row
    [:div.col-md-6
     [:h2 "Home Page"]
     [:p (str "This is my learning playground. It doesn't really do "
              "anything useful. I use this project to experiment with "
              "Clojure and ClojureScript, along with various web "
              "related libraries.")]
     [:p (str "Originally, this project started as a re-interpretation of "
              "the problems defined in Mimmo Cosenza's Modern ClojureScript "
              "tutorial ")
      [:a {:href "https://github.com/magomimmo/modern-cljs.git"}
       "https://github.com/magomimmo/modern-cljs.git"]]
     [:p (str "The difference with what is done here is that rather than just "
              "copy the solutions provided in the modern-cljs tutorial, I've "
              "used the problems as a guide and looked for alternative "
              "libraries to find a similar solution. In particular, my "
              "objectives were to -")]
     [:ul
      [:li "Experiment with a more modern environment. In particular"
       [:ul
        [:li (str "Use Selmer for templates and remove the need to "
                  "use Enlive to inject code to support a browser REPL")]
        [:li (str "Try out Austin rather than the basic brepl "
                  "environment")]
        [:li (str "Use the Reagent libraries to manage the DOM")]
        [:li (str "Use clj-ajax to communicate between the client "
                  "and the server. However, later I hope to look at "
                  "some alternatives for this type of functionality")]
        [:li (str "Experiment with generating RESTful type services "
                  "and creating a web API")]
        [:li (str "Look at using CLJX to share code between server and "
                  "client e.g. single code base for data validation.")]]]
      [:li (str "Learn modern HTML and CSS. The last time I did any real web "
                "programming was back in the late 1990's with Java 1.0. "
                "Back then, CSS was just beginning to gain traction, XHTML "
                "was still being argued about and nobody had heard of AJAX! "
                "Things have evolved a lot. I need to get back up to speed.")]
      [:li (str "Have somewhere to try out ideas, test new libraries and "
                "try to learn by doing.")]
      [:li (str "Work out how to best configure my development environment. "
                "I've been using Emacs since version 19 and to some extent "
                "have no other choice. I am a blind programmer who prefers "
                "the Linux environment. One of the best solutions for blind "
                "and vision impaired programmers is Emacspeak, an Emacs lisp "
                "package which provides Text-to-speech support for emacs")]]]
    [:div.col-md-6
     [:p (str "I've been programming for 30 years and yet still feel like a "
              "novice. My style is evolving daily and I frequently gain new "
              "understanding, skills and techniques. I'm often amazed when "
              "reading code written by others because it seems so elegant, "
              "clear and concise. Something which still challenges me as my "
              "code looks ugly and clunky. I often think I'll never be a "
              "great programmer, only an average one. Regardless, it is a "
              "task I still enjoy after 30 years and while the growth may be "
              "slow, I am better now than I was before!")]
     [:p (str "A final warning. The code in this project is rough. "
              "It is my experiment workbench and not written to be understood "
              "by others, be maintainable or in many cases, even be clear. "
              "So, this begs the question, why make it available to others? "
              "There are a number of reasons. I use GitHub as my primary code "
              "repository and public repos are free. I also know that often, "
              "even poorly structured examples of using a library, defining a "
              "project or configuring a service can be useful and finally, "
              "why not? It is possible I will get feedback, which will help me "
              "in developing my understanding, skills or techniques.")]]]])

[:div {:style "text-align: center"}
  [:h1 "Getting Started"]]

[:div {:class "instructions"}
  [:h2 "First Things First"]
  [:p "Getting started with a new Gaeshi Application is a piece of cake, but first you need to have your environment set up."]

  [:p "Lets make sure we have everything we need and then we can dive into starting our new Gaeshi App!"]

  [:ol
    [:li "Gaeshi uses Leiningen to help manage all the dependencies, so lets make sure you have that first.  Use the instructions from " [:a {:href "https://github.com/technomancy/leiningen"} "github.com/technomancy/leiningen"] " to get the newest version."]
    [:li "Next you will need to have Gaeshi installed.  We can use Leiningen to help with this.  Run:"
      [:p [:code "lein plugin install gaeshi/kuzushi 0.5.2"]]
      "Leiningen will pull the Gaeshi plugin from the webz and unpack it for you."]
    [:li "Now that you have Gaeshi, it will be useful to have an easy reference to it."
      [:p "Add:  "
        [:code "/Users/__user__/.lein/bin/gaeshi"]
        "  to your $PATH"
      ]
    ]
  ]
]
[:div {:class "instructions"}
  [:h2 "Making a New Gaeshi App"]
  [:p "Great!  Now we can get started on our new web application."]

  [:ol
    [:li "Gaeshi will do all the work for us here.  Just run: "
      [:p [:code "gaeshi new my_new_gaeshi_app"]]
      "  and Gaeshi will build the necessary file structure."]
    [:li "We are almost there, but first we need to use Leiningen to get our dependencies settled.  Run: "
      [:p
        [:code "cd my_new_gaeshi_app"]
        [:br]
        [:code "lein deps"]
      ]
      "This could take a little while if it is the first time you have used Leiningen."
    ]
    [:li "Excellent.  Now we can checkout our fantastical new app!  Run:"
      [:p [:code "gaeshi server"]]
      "Voila!  The app is running on " [:a {:href "http://localhost:8080"} "localhost:8080"]
    ]
  ]
]

[:p
  [:a {:href "/getting-started/deploying" :style "font-size: 16px"} "Now learn how to deploy to Google App Engine!"]
]



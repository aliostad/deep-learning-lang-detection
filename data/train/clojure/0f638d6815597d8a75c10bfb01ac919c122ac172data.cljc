(ns bahay.data)

(def asset-url
  "http://assets.byimplication.com/site/")

(def roles
  {:cof #:role{:id :cof
               :label "Co-Founder"}
   :dev #:role{:id :dev
               :label "Developer"
               :icon-id "developer"
               :reqs ["Any language"
                      "Ideally familiar with functional programming"
                      "Bonus if involved in open source projects"]}
   :des #:role{:id :des
               :label "Designer"
               :icon-id "designer"
               :reqs ["UI/UX"
                      "Preferably comfy with code"]}
   :biz #:role{:id :biz
               :label "Business Analyst"}
   :mkt #:role{:id :mkt
               :label "Marketer"
               :icon-id "marketer"
               :reqs ["Can manage social media accounts"
                      "Can handle marketing efforts for multiple projects"]}
   :pm #:role{:id :pm
              :label "Project Manager"
              :icon-id "manager"
              :reqs ["Can direct projects"
                     "Can get things done"]}})

(def people
  (->>
    [#:person{:nick-name "Levi"
              :display-name "Levi Tan Ong"
              :roles [:cof :dev :des]
              :link "http://github.com/levitanong"}
     #:person{:nick-name "Phi"
              :display-name "Philip Cheang"
              :roles [:cof :dev :des :mkt]
              :link "http://phi.ph"}
     #:person{:nick-name "Rodz"
              :display-name "Rodrick Tan"
              :roles [:cof :biz :pm]}
     #:person{:nick-name "Kenneth"
              :display-name "Kenneth Yu"
              :roles [:cof :biz :pm]
              :link "http://twitter.com/kennethgyu"}
     #:person{:nick-name "Wil"
              :display-name "Wilhansen Li"
              :roles [:cof :dev]
              :link "http://wilhansen.li"}
     #:person{:nick-name "Pepe"
              :display-name "Pepe Bawagan"
              :roles [:dev]
              :link "http://syk0saje.com"}
     #:person{:nick-name "Albert"
              :display-name "Albert Dizon"
              :roles [:dev]}
     #:person{:nick-name "Sesky"
              :display-name "Jonathan Sescon"
              :roles [:dev]
              :link "https://github.com/jrsescon"}
     #:person{:nick-name "Patsy"
              :display-name "Patricia Lascano"
              :roles [:des]}
     #:person{:nick-name "Alvin"
              :display-name "Alvin Dumalus"
              :roles [:dev]
              :link "https://github.com/alvinfrancis"}
     #:person{:nick-name "Thomas"
              :display-name "Thomas Dy"
              :roles [:dev]
              :link "http://pleasantprogrammer.com"}
     #:person{:nick-name "Jim"
              :display-name "James Choa"
              :roles [:dev]
              :link "https://github.com/trigger-happy"}
     #:person{:nick-name "Enzo"
              :display-name "Lorenzo Vergara"
              :roles [:dev]}
     #:person{:nick-name "J"
              :display-name "John Ugalino"
              :roles [:dev]}]
    (map-indexed
      (fn [index person]
        (-> person
          (assoc
            :person/id index
            :person/image-url (str asset-url
                                "people/"
                                (:person/nick-name person)
                                ".png"))
          (update :person/roles (partial mapv roles)))))
    (vec)))

(def services
  {:ui #:service{:id :ui
                 :label "UI/UX"
                 :icon-id "design"
                 :writeup "We not only think about what the product looks like, but how it will work."}
   :dev #:service{:id :dev
                  :label "Development"
                  :icon-id "development"
                  :writeup "We use cutting edge techniques in building fast, fully featured apps."}
   :dir #:service{:id :dir
                  :label "Business Direction"
                  :icon-id "business"
                  :writeup "Our business specialists ensure that products make sense."}
   :big #:service{:id :big
                  :label "Big Data"
                  :icon-id "big-data"
                  :writeup "Our data scientists are able to create sophisticated models."}})

(def projects
  [#:project{:id :sakay
             :label "Sakay"
             :ownership :in-house
             :services [(services :dev)
                        (services :ui)
                        (services :big)]
             :featured true
             :accent "#2a6d45"
             :image-url (str asset-url "projects/sakay/sakay-timedate-mockup.jpg")}
   #:project{:id :openrecon
             :label "Open Reconstruction"
             :ownership :client
             :services [(services :dev) (services :ui)]}
   #:project{:id :storylark
             :label "Storylark"
             :ownership :in-house
             :services [(services :dev) (services :ui)]}
   #_{:project/id :wildfire
    :project/name "Wildfire"}])

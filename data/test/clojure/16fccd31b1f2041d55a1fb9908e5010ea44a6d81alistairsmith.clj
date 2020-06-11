(ns cvproducer.alistairsmith)

(def cv {
  :name "Alistair Smith"
  :email "alistairsmith@flightofstairs.org"
  :phone "07512853460"

  :addr { :current   [ "15/1 Orwell Place" "Edinburgh" "EH11 2AD" ]
          :permanent [ "Blairmore Cottage" "Grantown on Spey" "PH26 3PL" ] }

  :skills [ { :title "Languages"      :body [ "Groovy" "Java" "Clojure" "C#" "SQL" "JavaScript" ] }
            { :title "Design"         :body [ "Database, Algorithm and OO design" "Design Patterns" ] }
            { :title "Administration" :body [ "Linux (various)" "Windows" "LAMP stack" "DBMS" ] }
            { :title "Other"          :body [ "Agile and Kanban" "Static and Dynamic Analysis" "Test-driven development" "Continuous integration" "OS Design" "AI" ] } ]

  :education [ { :title "University of Strathclyde"
                 :course "Software Engineering"
                 :body [ "Secured a 10-week paid research internship over the summer of 2009, have demonstrated my coursework to university applicants at open days in 2nd, 3rd and 4th years, and was a lab demonstrator for 1st and 3rd year classes." ]
                 :awards [ "BSc Hons. 1st class"
                           "Young Software Engineer of the Year winner: Best Engineered Project"
                           "Charles Babbage prize for best honours project"
                           "Sword Ciboodle prize runner-up for best project"
                           "Dean's List for each applicable year of study (2007, 2008, 2009)" ] }

               { :title "Grantown Grammar"
                 :body [ "2 Advanced Highers: Mathematics and Computing"
                         "5 Highers: Mathematics, Computing, Business Management, Chemistry and Physics"] } ]

  :employment [ { :employer "Amazon Development Centre Scotland"
                  :title "Software Development Engineer"
                  :dates { :from "July 2012" :to "Present" }
                  :body [ "Worked on a team responsible for real-time services used by Amazon. Agile practises are widely used." ] }

                { :employer "Defence Science and Technology Laboratory"
                  :title "Software Engineer"
                  :dates { :from "August 2010" :to "July 2011" }
                  :body [ "Worked as a member of a small software department. I had a great deal of freedom to design and implement solutions as I chose. Technologies I used included C#, Java, Python, Haskell, Evolutionary computation, and Trusted Computing. Areas of work included analysis of large datasets, creating tools to work with program disassembles, and recovering missing data through stochastic methods." ] }

                { :employer "EPSRC/University of Strathclyde"
                  :title "Research Intern"
                  :dates { :from "June 2009" :to "September 2009" }
                  :body [ "The subject was \"Capturing Task Related Knowledge.\" I worked largely independently to explore ways of finding other resources relevant to the set of resources currently being used. I learned and gained experience on how to manage a medium-sized software project from start to finish." ] } ] } )

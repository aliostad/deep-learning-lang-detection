(ns comamitc.config)

(def career [{:id 1
              :span "June 2015 - Current"
              :company "CMN"
              :link "http://CMN.com"
              :job-title "Full-Stack Engineer"
              :job-desc ["Architect and engineer proprietary lead-generation software platform that powers our Clients' sales pipelines."]}
             {:id 2
              :span "Sept 2012 - June 2015"
              :company "PROS"
              :link "http://pros.com"
              :job-title "Sr. Software Engineer"
              :job-desc ["Sr. Engineer for enterprise wide tools and automation technology aimed to drive down operating costs and increase the Organization's ability to scale."
                         "Acted as the central point of technical communication and manager for the offshore and in-house development teams."
                         "Winner of 2014 Innovation Cell Program - Developed a predictive scoring web application enabling the sales force by prioritizing sales actionables."]}
             {:id 3
              :span "Dec 2010 - Sept 2012"
              :company "Wipro"
              :link "http://wipro.com"
              :job-title "Sr. Systems Engineer"
              :job-desc ["Technical delivery and solution lead for global pricing software implementations."
                         "Lead on and off-shore customer engagement teams on functional business requirement gathering and solution implementation of Pricing Management software." 
                         "Developed production log analysis software that built to monitor application uptime and downtime reason for failure."]}
             {:id 4
              :span "Dec 2009 - Dec 2010"
              :company "AgilityDocs (now Agile Upstream)"
              :link "http://www.agileupstream.com/"
              :job-title "Systems Engineer"
              :job-desc ["Manage and lead global content management system implementations spread across several major continents."
                         "Pioneer product development as a main business focus given our subject matter expertise in document management."
                         "Architect and lead team delivery of workflow automation designs for business process compliance."
                         "Engineer and conceptualize solutions provided during the sales process for rapid prototyping."]}])

(def skills (sort ["Scala"
                   "Node.js"
                   "Python"
                   "JavaScript"
                   "HTML5"
                   "CSS3"
                   "Clojure"
                   "ClojureScript"
                   "Cassandra"
                   "SQLite"
                   "Microsoft SQL Server"
                   "Oracle"
                   "PostgreSQL"]))

(def projects [{:name   "pretty-print.net"
                :desc   "EDN and Clojure code pretty printer"
                :date   "2015"
                :img    "images/pp-net2.png"
                :site   "http://pretty-print.com"
                :github "https://github.com/comamitc/pretty-print.net"}
               {:name   "clj-beautify"
                :desc   "clojure.tools.reader for preserving comments and macros"
                :date   "2015"
                :img    "images/github2.png"
                :github "https://github.com/comamitc/clj-beautify"}
               {:name   "cuttle"
                :desc   "User Interface for the ClojureScript Compiler"
                :date   "2015"
                :img    "images/cuttle2.png"
                :github "https://github.com/oakmac/cuttle"}])

(ns clad.views.site)
           

(def
  ^{:doc
    "Sitemap: Structure
     Page Title
        Sections
           Section Title
              Headings
                 Heading Title
                 From selector
                 To selector"}
  
  sitemap [{:title "Home" :file "Home.html"
            :sections [{:title "Irish Coast and CC"                                :from :#home_ic}
                       {:title "How can I use this site?"                          :from :#home_how}
                       {:title "News and Events"                                   :from :#home_news}]}
           {:title "Climate Change" :file "more.html"
            :sections [{:title "Essentials"                                        :from :#essentials
                        :topics [{:title "What is Climate Change?",                :from :#whatis,  }
                                   {:title "Evidence for Climate Change",          :from :#evidence,}
                                   {:title "Why is Climate Change Serious?",       :from :#whyis,   }
                                   {:title "Climate Modelling",                    :from :#modelling}
                                   {:title "Adaptation and Mitigation",            :from :#adapt,   }]}
                       {:title "Global Projections"                                :from :#project
                        :topics [{:title "Global and Regional Trends"              :from :#project}
                                   {:title "Climate change and Coasts"             :from :#impacts
                                    :subtopics [{:title "Sea level rise"           :from :#sea_level_rise
                                                 :refs [:nic07 :nic11]}
                                                {:title "Sea surface temperature"  :from :#seasurfacetemp}
                                                {:title "Water Salinity"           :from :#salinity}
                                                {:title "Ocean Acidification"      :from :#acidification}
                                                {:title "Storminess & Wave Height" :from :#storminess}
                                                {:title "Coastal Erosion"          :from :#coastalerosion}
                                                {:title "Coastal Squeeze"          :from :#squeeze}
                                                {:title "Floods & Extreme Events"  :from :#floods}
                                                {:title "Ecosystems"               :from :#ecosystems}]}]}
                       {:title "Irish Coasts"                                      :from :#ireland
                        :topics [{:title "Climate change in Ireland"               :from :#ireland}
                                   {:title "Impacts on Irish coasts"               :from :#irishcoastsimpacts
                                    :subtopics [{:title "Sea level rise"           :from :#impacts_sealevelrise}
                                                {:title "Sea surface temperature"  :from :#seatemp}
                                                {:title "Salinity & Acidification" :from :#saltacid}
                                                {:title "Storminess & Wave Height" :from :#impacts_storminess}
                                                {:title "Coastal Erosion & Squeeze" :from :#impacts_squeeze}
                                                {:title "Floods & Extreme Events"  :from :#extremeevents}
                                                {:title "Ecosystems"               :from :#ecosystems}]}
                                   {:title "Regions"                               :from :#regions}
                                   {:title "Sectors"                               :from :#sectors}]}]}
           {:title "Adaptation" :file "Adaptation.html"
            :sections [{:title "Why Climate Adaptation?"                           :from :#whyadapt
                        :topics [{:title "What is climate adaptation?"             :from :#whatis}
                                   {:title "Why adapt?"}
                                   {:title "How to approach it?"}]}
                       {:title "Adaptive Co-Management"
                        :topics [{:title "How can I do it?"}
                                   {:title "What do I need?"}]}]}
           {:title "Tools & Methods"
            :sections [{:title "Tools & Methods"
                        :topics [{:title "Which Method Works?"}
                                   {:title "Vulnerability Assessment"}
                                   {:title "Scenario Development"}
                                   {:title "Knowledge Integration"}
                                   {:title "Implementation"}
                                   {:title "Resources"}]}]}
           {:title "Policy & Law"
            :sections [{:title "How Adaptation Governance Works"
                        :topics [{:title "Challenges"}
                                   {:title "Policy and legislation"}
                                   {:title "Implementation"}]}
                       {:title "European Union"}
                       {:title "Ireland"}
                       {:title "Regions & Communities"}]}
           {:title "Case Studies"
            :sections [{:title "How do they manage?"
                        :topics [{:title "FIXME!"}]}
                       {:title "Ireland"
                        :topics [{:title "Tralee Bay Co.Kerry"}
                                   {:title "Bantry Bay Co. Cork"}
                                   {:title "Fingal Co. Dublin"}
                                   {:title "Cork Harbour Co. Cork"}
                                   {:title "Lough Swilly Co. Donegal"}]}
                       {:title "International"
                        :topics [{:title "CS 1"}
                                   {:title "CS 2"}
                                   {:title "CS 3"}]}
                       {:title "Look for your specific issue"}
                       {:title "Tell us about your experience!"}]}
           {:title "Resources" :file "resources.html"
            :sections [{:title "How I can build capacities for climate adaptation?"
                        :from :#res_cap}
                       {:title "Data and Information"
                        :topics [{:title "Climate Change"}
                                   {:title "Sustainable Development"}
                                   {:title "Irish Climate"}
                                   {:title "Irish Coasts and Seas"}]}
                       {:title "Guidelines"}
                       {:title "Legal and Policy Support"}
                       {:title "Financial Support"}
                       {:title "Practical Measures"}
                       {:title "Communication and Presentations"}
                       {:title "Working with Communities"}
                       {:title "References" :from :#refs}]}
           {:title "ICRN"
            :sections [{:title "About ICRN"
                        :topics [{:title "FIXME!"}]}
                       {:title "National Advisory Panel"}
                       {:title "Regional Units"
                        :topics [{:title "Tralee"}
                                   {:title "Bantry"}
                                   {:title "Fingal"}]}
                       {:title "Vulnerability assessment"
                        :topics [{:title "Tralee"}
                                   {:title "Bantry"}
                                   {:title "Fingal"}]}
                       {:title "Local Scenarios"
                        :topics [{:title "Tralee"}
                                   {:title "Bantry"}
                                   {:title "Fingal"}]}
                       {:title "GIS Coastal Adaptation"}
                       {:title "Get Involved!"}]}])


(def references
  {:nic07
   {:title "Coastal systems and low-lying areas. Climate Change 2007: Impacts, Adaptation and Vulnerability"
    :authors ["Nicholls, R.J" "P.P. Wong" "V.R. Burkett", "J.O. Codignotto", "J.E. Hay", "R.F. McLean",
              "S. Ragoonaden" "C.D. Woodroffe"]
    :published "Cambridge University Press, Cambridge, UK, 315-356"
    :link "http://www.ipcc.ch/pdf/assessment-report/ar4/wg2/ar4-wg2-chapter6.pdf"}
   :nic11
   {:title "Planning for the impacts of sea level rise"
    :authors ["Nicholls, R.J"]}})
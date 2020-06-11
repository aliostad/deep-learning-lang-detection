(ns epeus.state
  (:require [epeus.utils :refer [now]]))

(def app-state
  (atom
   {:graph
    {}

    :zoom 100

    :main
    {
     :modified
     (now)
     :items {:uid      0
             :root?    true
             :title    "Mind Maps"
             :x        5388
             :y        5118
             :color    "#c0c0c0"
             :children {1 {:uid      1
                           :title    "communicate"
                           :x        5601
                           :y        5067
                           :color    "#67d7c4"
                           :children {3 {:uid      3
                                         :title    "letter"
                                         :x        5717
                                         :y        5025
                                         :color    "#67d7c4"
                                         :children {}}
                                      4 {:uid      4
                                         :title    "idea"
                                         :x        5719
                                         :y        5091
                                         :color    "#67d7c4"
                                         :children {}}
                                      5 {:uid      5
                                         :title    "speach"
                                         :x        5710
                                         :y        5059
                                         :color    "#67d7c4"
                                         :children {}}}}
                        7 {:uid      7
                           :title    "create"
                           :x        5560
                           :y        5251
                           :color    "#ebd95f"
                           :children {8 {:uid      8
                                         :title    "brain bloom"
                                         :x        5650
                                         :y        5251
                                         :color    "#ebd95f"
                                         :children {}}
                                      9 {:uid      9
                                         :title    "generate"
                                         :x        5635
                                         :y        5286
                                         :color    "#ebd95f"
                                         :children {}}
                                      10 {:uid      10
                                          :title    "apply"
                                          :x        5635
                                          :y        5219
                                          :color    "#ebd95f"
                                          :children {}}}}
                        11 {:uid      11
                            :title    "think"
                            :x        5308
                            :y        5231
                            :color    "#e68782"
                            :children {12 {:uid      12
                                           :title    "problem"
                                           :x        5178
                                           :y        5201
                                           :color    "#e68782"
                                           :children {}}
                                       13 {:uid      13
                                           :title    "idea"
                                           :x        5172
                                           :y        5313
                                           :color    "#e68782"
                                           :children {}}
                                       14 {:uid      14
                                           :title    "vision"
                                           :x        5170
                                           :y        5271
                                           :color    "#e68782"
                                           :children {}}
                                       15 {:uid      15
                                           :title    "organize"
                                           :x        5175
                                           :y        5237
                                           :color    "#e68782"
                                           :children {}}}}
                        16 {:uid      16
                            :title    "manage"
                            :x        5253
                            :y        5156
                            :color    "#56e304"
                            :children {17 {:uid      17
                                           :title    "team"
                                           :x        5118
                                           :y        5128
                                           :color    "#56e304"
                                           :children {}}
                                       18 {:uid      18
                                           :title    "meetings"
                                           :x        5090
                                           :y        5153
                                           :color    "#56e304"
                                           :children {}}
                                       19 {:uid      19
                                           :title    "time"
                                           :x        5123
                                           :y        5175
                                           :color    "#56e304"
                                           :children {}}}}
                        20 {:uid      20
                            :title    "prepare"
                            :x        5295
                            :y        5071
                            :color    "#FF08E1"
                            :children {21 {:uid      21
                                           :title    "project"
                                           :x        5127
                                           :y        5038
                                           :color    "#FF08E1"
                                           :children {}}
                                       22 {:uid      22
                                           :title    "training"
                                           :x        5129
                                           :y        5068
                                           :color    "#FF08E1"
                                           :children {}}
                                       23 {:uid      23
                                           :title    "trip"
                                           :x        5129
                                           :y        5099
                                           :color    "#FF08E1"
                                           :children {}}}}
                        24 {:uid      24
                            :title    "improve"
                            :x        5608
                            :y        5157
                            :color    "#64AEFF"
                            :children {25 {:uid      25
                                           :title    "memory"
                                           :x        5734
                                           :y        5124
                                           :color    "#64AEFF"
                                           :children {}}
                                       26 {:uid      26
                                           :title    "productivity"
                                           :x        5731
                                           :y        5194
                                           :color    "#64AEFF"
                                           :children {}}
                                       27 {:uid      27
                                           :title    "understanding"
                                           :x        5736
                                           :y        5159
                                           :color    "#64AEFF"
                                           :children {}}}}}}  
     }

    :tooltip
    ""
   }))

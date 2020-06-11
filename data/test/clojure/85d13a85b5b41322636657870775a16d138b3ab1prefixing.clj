[;; System JAR dirs together:
 :max.system.jar.dir [(prefix "/Media/MaxJARs/support/" ["jython2.5.2"
                                                         "utility"
                                                         "jetty"
                                                         "groovy"
                                                         "clojure"])
                      "/Media/MaxJARs/loadbang"]

 ;; Assorted classes:
 :max.system.class.dir [;; Stuff in workspace:
                        (prefix "/Users/nick/workspace/"
                                ["MaxMSP/DEVELOPMENT_0/mxj-development/straker/java/.classes"
                                 ;; Stuff in workspace and ModularInstrument:
                                 (prefix "Flet/ModularInstrument/"
                                         ["SYSTEM/_classes"
                                          "DYNAMIC/clj-src"
                                          "DYNAMIC/_classes"])])]

 ;; Debugger setup:
 :max.jvm.option [(prefix "-X" ["incgc"
                                "ms64m"
                                "mx256m"

                                "debug"
                                "noagent"
                                "runjdwp:transport=dt_socket,address=8074,server=y,suspend=n"])
                  "-XX:-UseSharedSpaces"]]

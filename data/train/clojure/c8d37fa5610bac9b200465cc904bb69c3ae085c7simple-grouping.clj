[;; System JAR dirs together:
 :max.system.jar.dir ["/Media/MaxJARs/support/jython2.5.2"
                      "/Media/MaxJARs/support/utility"
                      "/Media/MaxJARs/support/jetty"
                      "/Media/MaxJARs/support/groovy"
                      "/Media/MaxJARs/support/clojure"
                      "/Media/MaxJARs/loadbang"]

 ;; Assorted classes:
 :max.system.class.dir ["/Users/nick/workspace/Flet/ModularInstrument/SYSTEM/_classes"
                        "/Users/nick/workspace/MaxMSP/DEVELOPMENT_0/mxj-development/straker/java/.classes"
                        "/Users/nick/workspace/Flet/ModularInstrument/DYNAMIC/clj-src"
                        "/Users/nick/workspace/Flet/ModularInstrument/DYNAMIC/_classes"]

 ;; Debugger setup:
 :max.jvm.option ["-Xincgc"
                  "-Xms64m"
                  "-Xmx256m"

                  "-Xdebug"
                  "-Xnoagent"
                  "-Xrunjdwp:transport=dt_socket,address=8074,server=y,suspend=n"
                  "-XX:-UseSharedSpaces"]]

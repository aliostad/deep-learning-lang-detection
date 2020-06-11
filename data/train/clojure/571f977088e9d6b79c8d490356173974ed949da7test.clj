(let
    [DEBUG false
     HOME (env "HOME")
     WORKSPACE (prefix HOME "/workspace/")]

  [
   :max.system.jar.dir (prefix "/Media/MaxJARS/support/" ["jython2.5.2"
                                                          "utility"
                                                          "jetty"
                                                          "groovy"
                                                          "clojure"])

   :max.system.class.dir
   (prefix WORKSPACE ["Flet/ModularInstrument/SYSTEM/_classes"
                      "MaxMSP/DEVELOPMENT_0/mxj-development/straker/java/.classes"])

   :max.system.jar.dir "/Media/MaxJARs/loadbang"

   :max.system.class.dir (prefix (prefix WORKSPACE "Flet/ModularInstrument/DYNAMIC/")
                                 ["clj-src" "_classes"])

   ;; Specify some JVM options

   :max.jvm.option (prefix "-X" ["incgc" "ms64m" "mx256m"])


   ;; uncomment these options(i.e. remove surrounding semi colons
   ;; to cause the JVM to be created
   ;; in debug mode and listening for remote debugger connections
   ;; on port 8074. This would enable you to interactively debug
   ;; your mxj code using JDB or some other debugger which supports
   ;; the JDI wire protocol

   :max.jvm.option (if DEBUG [(prefix "-X" ["debug"
                                            "noagent"
                                            "runjdwp:transport=dt_socket,address=8074,server=y,suspend=n"])
                              "-XX:-UseSharedSpaces"]
                       nil)])

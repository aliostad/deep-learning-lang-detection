(let [MI (prefix (env "HOME") "/workspace/Flet/ModularInstrument/")
      DEBUG true
      AS_SYSTEM true
      DIR_TAG (if AS_SYSTEM
                :max.system.class.dir
                :max.dynamic.class.dir)
      DEBUG_STUFF [(prefix "-X" ["debug"
                                 "noagent"
                                 "runjdwp:transport=dt_socket,address=8074,server=y,suspend=n"])
                   "-XX:-UseSharedSpaces"]]
  [DIR_TAG (prefix MI ["PRIVATE/_classes"
                       "PUBLIC/_classes"
                       "PRIVATE/clj/src"])
   :max.system.jar.dir (prefix MI "PRIVATE/lib/unitils")
   :max.jvm.option (prefix "-X" ["incgc" "ms64m" "mx256m"])
   :max.jvm.option (if DEBUG DEBUG_STUFF nil)])

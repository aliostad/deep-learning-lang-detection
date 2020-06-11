(ns user
  (:require [components.datomic :as datomic]
            [components.websocket :as websocket]
            [server.handler :as handler]
            [datomic.api :as d]
            [figwheel-sidecar.repl-api :as ra]
            [org.httpkit.server :refer [run-server]]
            [taoensso.sente.server-adapters.http-kit :refer [sente-web-server-adapter]]
            [com.stuartsierra.component :as component]))

(def figwheel-config {:figwheel-options {:css-dirs ["resources/public/css"]}
                      :build-ids ["dev"]
                      :all-builds
                      [{:id "dev"
                        :figwheel true
                        :source-paths ["src"]
                        :compiler {:main 'om-next-thingie.core
                                   :asset-path "js/compiled/out"
                                   :output-to "resources/public/js/compiled/om_next_thingie.js"
                                   :output-dir "resources/public/js/compiled/out"
                                   :source-map-timestamp true}}]})


(defrecord Figwheel [config]
  component/Lifecycle
  (start [component]
    (println "starting figwheel")
    (ra/start-figwheel! config)
    component)
  (stop [component]
    (println "stopping figwheel")
    (ra/stop-figwheel!)
    component))

(defrecord HttpKit [app config http-kit]
  component/Lifecycle
  (start [component]
    (println "starting httpkit")
    (assoc component :http-kit (run-server (:handler app) config)))
  (stop [component]
    (println "stopping httpkit")
    ((:http-kit component))
    (dissoc component :http-kit)))

(defn ws-dispatch
  [e]
  (println "dispatch: " (:id e)))

(defrecord WebsocketDispatch [dispatch datomic]
  component/Lifecycle
  (start [component]
    (println "Starting websocket dispatch")
    (assoc component :dispatch
           (fn [e]
             (let [conn (:conn datomic)]
               (#'ws-dispatch (assoc e :conn conn
                                       :db (d/db conn)))))))
  (stop [component]
    (println "Stopping websocket dispatch")
    (dissoc component :dispatch)))

(defn create-system
  [_]
  (component/system-map
   :datomic (datomic/datomic-component  "datomic:mem://om-demo")
   :figwheel (map->Figwheel {:config figwheel-config})
   :websocket-dispatch (component/using
                        (map->WebsocketDispatch {})
                        [:datomic])
   :websocket (component/using
               (websocket/websocket-component sente-web-server-adapter {})
               [:websocket-dispatch])
   :app (component/using
         (websocket/map->CombineWebsocketRoutes
          {:input-handler #'handler/app})
         [:websocket])
   :app-server (component/using
                (map->HttpKit {:config {:port 3000}})
                [:app])))

(defonce system (atom nil))

(defn datomic-conn
  []
  (-> @system
      :datomic
      :conn))

(defn init
  []
  (swap! system create-system))

(defn start
  []
  (swap! system component/start))

(defn stop
  []
  (swap! system #(when % (component/stop %))))

(defn run
  []
  (init)
  (start))

(defn restart
  []
  (stop)
  (run))

(comment
 (run)
 )


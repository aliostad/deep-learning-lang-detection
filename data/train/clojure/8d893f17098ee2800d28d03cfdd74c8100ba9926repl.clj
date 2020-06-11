(ns picture-gallery.repl
  "Functions used to manage app from REPL."
  (:use [picture-gallery.handler :only [app init destroy]]
        [ring.server.standalone :only [serve]]
        [ring.middleware content-type not-modified file]))

(defonce server (atom nil))

(defn get-handler
  "Get the root ring handler for the application."
  []
  ;; #'app expands to (var app) so that when we reload our code,
  ;; the server is forced to re-resolve the symbol in the var
  ;; rather than having its own copy. When the root binding
  ;; changes, the server picks it up without having to restart.
  (-> #'app
    ; Makes static assets in $PROJECT_DIR/resources/public/ available.
    (wrap-file "resources")
    ; Content-Type, Content-Length, and Last Modified headers for files in body
    (wrap-content-type)
    (wrap-not-modified)))

(defn start-server
  "used for starting the server in development mode from REPL"
  [& [port]]
  (let [port (if port (Integer/parseInt port) 8080)]
    (reset! server
            (serve (get-handler)
                   {:port port
                    :init init
                    :auto-reload? true
                    :destroy destroy
                    :join true}))
    (println (str "You can view the site at http://localhost:" port))))

(defn stop-server []
  "Stops the server in development mode from REPL"
  (.stop @server)
  (reset! server nil))

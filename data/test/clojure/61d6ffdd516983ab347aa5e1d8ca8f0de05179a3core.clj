(ns clj-simplegdx.core
  (:gen-class)
  (:import [com.badlogic.gdx.audio Sound Music]
           [com.badlogic.gdx.graphics GL10 OrthographicCamera Texture]
           [com.badlogic.gdx ApplicationListener Gdx Input$Keys]
           [com.badlogic.gdx.backends.lwjgl LwjglApplication LwjglApplicationConfiguration]
           [com.badlogic.gdx.graphics.g2d SpriteBatch]
           [com.badlogic.gdx.math MathUtils Rectangle Vector3]
           [com.badlogic.gdx.utils Array TimeUtils]))


; drops simulation
(def raindrops (atom {:drops []
                      :last-drop-time 0}))

(defn- spawn-raindrop! []
  (let [rand-x (MathUtils/random 0 (- 800 48))]
    (swap! raindrops #(assoc % :drops (conj (% :drops)
                                            (Rectangle. rand-x 480 48 48))
                             :last-drop-time (TimeUtils/nanoTime)))))

(defn- stepped-spawn-raindrop! []
  (if (< 1000000000 (- (TimeUtils/nanoTime) (:last-drop-time @raindrops)))
    (spawn-raindrop!)))

(defn- move-drops! [drop-state]
  (let [delta (* 200 (.getDeltaTime Gdx/graphics))
        {old-drops :drops} drop-state]
    (assoc drop-state :drops
           (filter #(> (+ (.-y %) 48) 0)
                   (map #(do (set! (.-y %) (- (.-y %) delta)) %) old-drops)))))


; manage game assets
(def assets (atom {}))

(defn- setup-assets! []
  (swap! assets (fn [old] {:drop-image (Texture. (.internal Gdx/files "drop.png"))
                          :bucket-image (Texture. (.internal Gdx/files "bucket.png"))
                          :drop-sound (.newSound Gdx/audio (.internal Gdx/files "drop.mp3"))
                          :rain-music (.newMusic Gdx/audio (.internal Gdx/files "rain.mp3"))
                          :batch (SpriteBatch.)
                          :camera (OrthographicCamera.)})))

; try this live for fun ;-) ...
#_(swap! assets #(assoc % :bucket-image (:drop-image %)
                      :drop-image (:bucket-image %)))

(defn- clear-plane! []
  (.glClearColor Gdx/gl 0 0 (float 0.2) 1)
  (.glClear Gdx/gl GL10/GL_COLOR_BUFFER_BIT))

(defn- update-camera! []
  (let [{:keys [camera batch]} @assets]
    (.update camera)
    (.setProjectionMatrix batch (.-combined camera))))


; model user interaction
(def bucket (atom (Rectangle. (- (/ 800 2) (/ 48 2)) 20 48 48)))

; TODO create new Rectangle rather than setting values in Atom swap
(defn- move-bucket! []
  (let [{:keys [camera]} @assets]
    (if (.isTouched Gdx/input)
      (let [touch-pos (Vector3.)
            x (.getX Gdx/input)
            y (.getY Gdx/input)]
        (.set touch-pos x y 0)
        (.unproject camera touch-pos)
        (swap! bucket #(do (set! (.-x %) (- x (/ 48 2))) %))))
    (if (.isKeyPressed Gdx/input Input$Keys/LEFT)
      (swap! bucket #(do (set! (.-x %) (- (.-x %) (* 200 (.getDeltaTime Gdx/graphics)))) %)))
    (if (.isKeyPressed Gdx/input Input$Keys/RIGHT)
      (swap! bucket #(do (set! (.-x %) (+ (.-x %) (* 200 (.getDeltaTime Gdx/graphics)))) %)))))

(defn- catch-drops! []
  (let [{drops :drops} @raindrops
        bucket @bucket
        uncaught-drops (filter #(not (.overlaps % bucket)) drops)
        {drop-sound :drop-sound} @assets]
    (if (not= (count drops) (count uncaught-drops))
      (.play drop-sound))
    (swap! raindrops (fn [old] (assoc old :drops uncaught-drops)))))


; draw the whole thing
(defn- draw! []
  (let [{:keys [batch bucket-image drop-image]} @assets
        bucket @bucket
        {drops :drops} @raindrops]
    (.begin batch)
    (.draw batch bucket-image (.-x bucket) (.-y bucket))
    (doall (map #(.draw batch drop-image (.-x %) (.-y %)) drops))
    (.end batch)))

; hook it all in libgdx
(def drop (reify ApplicationListener
            (create [this]
              (setup-assets!)
              (spawn-raindrop!)
              (let [{:keys [rain-music camera]} @assets]
                (.setLooping rain-music true)
                (.play rain-music)
                (.setToOrtho camera false 800 480)))
            (pause [this])
            (resume [this])
            (render [this]
              (move-bucket!)
              (swap! raindrops move-drops!)
              (stepped-spawn-raindrop!)

              (clear-plane!)
              (update-camera!)

              (catch-drops!)

              (draw!))
            (resize [this width height])
            (dispose [this]
              (let [{:keys [drop-image bucket-image drop-sound batch]} @assets]
                (.dispose drop-image)
                (.dispose bucket-image)
                (.dispose drop-sound)
                (.dispose batch)))))


(defn -main [& args]
  (let [cfg (LwjglApplicationConfiguration.)]
    (set! (.-title cfg) "Drop")
    (set! (.-useGL20 cfg) true)
    (set! (.-width cfg) 800)
    (set! (.-height cfg) 480)
    (LwjglApplication. drop cfg)))

(comment (def game (-main))
         (.exit game))

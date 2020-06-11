(ns com.sattvik.android.clojure.slimmed.ClojureBrowser
  (:gen-class :extends android.app.Activity
              :main false
              :exposes-methods {onCreate superOnCreate})
  (:import [android.view KeyEvent View$OnClickListener]
           [android.webkit WebSettings$ZoomDensity WebViewClient]
           [com.sattvik.android.clojure.slimmed R$id R$layout]))

(defn make-webview-client
  "Constructs an instance of WebViewClient that allows us to manage the
  WebView."
  [web-view]
  (proxy [WebViewClient] []
    (shouldOverrideUrlLoading [view url]
      (.loadUrl view url)
      true)))

(defn -onCreate
  "Called when the activity is initialised."
  [this bundle]
  (doto this
    (.superOnCreate bundle)
    (.setContentView R$layout/main))
  (let [web-view (.findViewById this R$id/webview)]
    (doto (.getSettings web-view)
      (.setJavaScriptEnabled true)
      (.setBuiltInZoomControls true)
      (.setDefaultZoom WebSettings$ZoomDensity/FAR))
    (doto web-view
      (.loadUrl "http://www.deepbluelambda.org/")
      (.setWebViewClient (make-webview-client web-view)))
    (let [button (.findViewById this R$id/back_button)]
      (.setOnClickListener button
                           (proxy [View$OnClickListener] []
                             (onClick [view]
                               (when (.canGoBack web-view)
                                 (.goBack web-view))))))
    (let [button (.findViewById this R$id/forward_button)]
      (.setOnClickListener button
                           (proxy [View$OnClickListener] []
                             (onClick [view]
                               (when (.canGoForward web-view)
                                 (.goForward web-view))))))))

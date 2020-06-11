(ns javabrowser.core
  (:require
   [javabrowser.util :as util]
   [javabrowser.ul :as ul]
   [javabrowser.search :as search]
   [cljs.reader :as reader]
   [goog.dom :as dom]
   [goog.json :as json]
   [goog.string :as string]
   [goog.array :as array]
   [goog.events :as events]
   [goog.async.Delay :as gDelay]
   [goog.net.XhrIo :as xhr]
   [goog.debug.Logger :as Logger]
   [goog.debug.Logger.Level :as Level]
   [goog.debug.Console :as Console]
   [goog.dom.query :as query]
   [goog.ui.CustomButton :as CustomButton]
   [goog.ui.Menu :as Menu]
   [goog.ui.MenuButton :as MenuButton]
   [goog.ui.Separator :as Separator]
   [goog.ui.decorate :as decorator]
   [goog.dom.classes :as classes]))

(def DELAY 500)
(def HOST "/rest/jars?search=.*")
(def DEFAULT_SEARCH_VAL "Search for Packages")
(def DEFAULT_MAX_LENGTH 10)

(def jar-menu (goog.ui.Menu.))

(def initial-state {:selected-jars #{}})

(def state (atom initial-state))

(defn update-state
  "Call this from swap! to change state"
  [old-state new-jar]
     (let [jar-set (:selected-jars old-state)
           selected (get jar-set new-jar)]
       (if selected
         (assoc old-state :selected-jars (disj jar-set new-jar))
         (assoc old-state :selected-jars (conj jar-set new-jar)))))

(defn clear-selected-jars
  []
  (swap! state (fn [old-state] (assoc old-state :selected-jars {}))))

(defn toggle-selected-jar
  [jar-path]
  (let []
    (swap! state update-state jar-path)))

;; Manage menu of jars
;; (defn create-jar-menu-items
;;   "Create menu of jars"
;;   [coll]
;;   (do
;;     (. jar-menu (removeChildren true))
;;     (doseq [x coll]
;;       (. jar-menu (addItem (create-jar-menu-item x))))))

;; (defn create-jar-menu-button
;;   []
;;   (let [button (goog.ui.MenuButton. "Add Jars" jar-menu)
;;         jars (util/get-element "#jars .menu")]
;;     (. button (setDispatchTransitionEvents goog.ui.Component.State.ALL true))
;;     (. button (setId "jar-button"))
;;     (. button (render jars))
;;     (. button (setTooltip "Jar Menu"))
;;     (. jar-menu (setId "jar-menu"))
;;     (events/listen jar-menu (. goog.ui.Component.EventType ACTION)
;;                    handle-jar-menu-change)))

;; (defn create-jar-menu-item
;;   [jar-path]
;;   (let [display (util/trunc-string (util/get-file-name jar-path))
;;         item (goog.ui.MenuItem. display jar-path)]
;;     (. item (setId jar-path))
;;     (. item (setDispatchTransitionEvents goog.ui.Component.State.ALL true))
;;     item))

;; (defn handle-jar-menu-change
;;   [e]
;;   (let [item (. e target)
;;         jar-path (. item (getValue))]
;;     (util/log (str "Clicked Menu Item: " jar-path))
;;     (toggle-selected-jar jar-path)
;;     (update-list-of-jars (:selected-jars @state))
;;     (. jar-menu (removeChild jar-path true))
;;     (get-list-of-classes-in-jar jar-path)))

;; manage list of selected jars
(defn get-list-of-jars
  [search]
  (let [search (if (empty? search) ".*" search)]
    (do
      (classes/remove (util/get-element "#jars .loading") "hidden")
      (util/request
       (str "/rest/jars?search=" search)
       (fn [response]
         (update-list-of-jars (util/parse-response response))
         (get-list-of-classes-in-jars (:selected-jars @state)))))))

(defn on-click-jar
  "When user clicks jar, add or remove from selected list, update css,
  and update class list"
  [e]
  (let [target (. e target)
        jar-path (. target data)]
    (util/log ("Clicked jar: " jar-path))
    (toggle-selected-jar jar-path)
    (classes/toggle target "selected")
    (get-list-of-classes-in-jars (:selected-jars @state))))

(defn update-list-of-jars
  "COLL is a list of absolute file paths to jar files"
  [coll]
  (let [elemid "#jars ul"]
    (ul/remove-all-items elemid)
    (doseq [item coll]
      (ul/create-and-add-li
       elemid
       (util/trunc-string (util/get-file-name item) 25)
       {:onclick on-click-jar :data item :classes "selected"})
      (toggle-selected-jar item))
    (classes/add (util/get-element "#jars .loading") "hidden")))

;; manage list of classes 
(defn get-list-of-classes-in-jars
  [jars & [search max offset]]
  (let [search (or search ".*")
        max (or max "20")
        offset (or offset "0")])
  (classes/remove (util/get-element "#classes .loading") "hidden")
  (util/request
   (str "/rest/classes?jars=" (apply str (interpose "," jars))
        "&search=" search
        "&max=" max
        "&offset=" offset)
   (fn [response] (update-list-of-classes (util/parse-response response)))))

(defn on-click-classname
  [e]
  (let [target (. e target)
        class-path (. target data)]
    (util/unselect-all "#classes ul a")
    (util/log ("Clicked class: " class-path))
    (classes/add target "selected")
    (get-class-details (util/path-to-fqdn class-path))))

(defn update-list-of-classes
  "COLL is a list of fully qualified classnames"
  [coll]
  (let [elemid "#classes ul"]
    (ul/remove-all-items elemid)
    (doseq [item coll]
      (ul/create-and-add-li
       elemid
       (util/trunc-string (util/get-file-name item) 25)
       {:onclick on-click-classname :data item})
      (classes/add (util/get-element "#classes .loading") "hidden"))))

;; Manage Class details
(defn get-class-details
  [classname]
  (do
    (classes/remove (util/get-element "#classdetail .loading") "hidden")
    (util/request
     (str "/rest/classdetail?classname=" classname)
     (fn [response] (update-class-detail (util/parse-response response))))))

(defn update-class-detail
  [response]
  (let [classdetail (util/get-element "#col3")
        new (util/build response)]
    (dom/removeChildren classdetail)
    (. classdetail (appendChild new))))

(defn ^:export init
  []
  (do
    (get-list-of-jars ".*")
    ;; Add search listener so it will filter list of classes by
    ;; whatever is typed into the text box
    (search/addSearchListener
     "#classes .searchbox" #(get-list-of-classes-in-jars (:selected-jars @state) %))))

(init)



[:div {:id "classdetail"}
 [:h1 "Class Detail"]
 [:div {:class "loading-wrap"}
  [:div {:class "loading hidden"}
   [:img {:src "/images/ajax-loader.gif"}]]]
 [:div {:id "class-nav"}
  [:a {:href "#declaration"} "declaration"]
  [:span " | "]
  [:a {:href "#constructors"} "constructors"]
  [:span " | "]
  [:a {:href "#methods"} "methods"]]
 [:a {:name "declaration", :id "declaration"}]
 [:div {:id "class-declaration"} [:div {:id "package-modifiers"} "public abstract"] [:h2 {:id "class-short-name"} "StringUtils"] nil]
 [:a {:name "constructors", :id "constructors"}]
 [:div {:id "class-constructors"} [:h2 "Constructors"]
  [:ul {:id "methods"} [:li "public org.springframework.util.StringUtils()"]]] [:a {:name "methods", :id "methods"}] [:div {:id "class-methods"} [:h2 "Methods"] [:ul {:id "methods"} [:li "public static java.lang.String replace(class java.lang.String, class java.lang.String, class java.lang.String)"] [:li "public static [Ljava.lang.String; split(class java.lang.String, class java.lang.String)"] [:li "public static java.lang.String delete(class java.lang.String, class java.lang.String)"] [:li "public static java.lang.String quote(class java.lang.String)"] [:li "public static java.lang.String capitalize(class java.lang.String)"] [:li "public static boolean startsWithIgnoreCase(class java.lang.String, class java.lang.String)"] [:li "public static boolean endsWithIgnoreCase(class java.lang.String, class java.lang.String)"] [:li "public static [Ljava.lang.String; toStringArray(interface java.util.Collection)"] [:li "public static [Ljava.lang.String; toStringArray(interface java.util.Enumeration)"] [:li "public static java.lang.String uncapitalize(class java.lang.String)"] [:li "public static boolean hasLength(interface java.lang.CharSequence)"] [:li "public static boolean hasLength(class java.lang.String)"] [:li "public static boolean hasText(class java.lang.String)"] [:li "public static boolean hasText(interface java.lang.CharSequence)"] [:li "public static boolean containsWhitespace(interface java.lang.CharSequence)"] [:li "public static boolean containsWhitespace(class java.lang.String)"] [:li "public static java.lang.String trimWhitespace(class java.lang.String)"] [:li "public static java.lang.String trimAllWhitespace(class java.lang.String)"] [:li "public static java.lang.String trimLeadingWhitespace(class java.lang.String)"] [:li "public static java.lang.String trimTrailingWhitespace(class java.lang.String)"] [:li "public static java.lang.String trimLeadingCharacter(class java.lang.String, char)"] [:li "public static java.lang.String trimTrailingCharacter(class java.lang.String, char)"] [:li "public static boolean substringMatch(interface java.lang.CharSequence, int, interface java.lang.CharSequence)"] [:li "public static int countOccurrencesOf(class java.lang.String, class java.lang.String)"] [:li "public static java.lang.String deleteAny(class java.lang.String, class java.lang.String)"] [:li "public static java.lang.Object quoteIfString(class java.lang.Object)"] [:li "public static java.lang.String unqualify(class java.lang.String, char)"] [:li "public static java.lang.String unqualify(class java.lang.String)"] [:li "public static java.lang.String getFilename(class java.lang.String)"] [:li "public static java.lang.String getFilenameExtension(class java.lang.String)"] [:li "public static java.lang.String stripFilenameExtension(class java.lang.String)"] [:li "public static java.lang.String applyRelativePath(class java.lang.String, class java.lang.String)"] [:li "public static java.lang.String cleanPath(class java.lang.String)"] [:li "public static [Ljava.lang.String; delimitedListToStringArray(class java.lang.String, class java.lang.String, class java.lang.String)"] [:li "public static [Ljava.lang.String; delimitedListToStringArray(class java.lang.String, class java.lang.String)"] [:li "public static java.lang.String collectionToDelimitedString(interface java.util.Collection, class java.lang.String)"] [:li "public static java.lang.String collectionToDelimitedString(interface java.util.Collection, class java.lang.String, class java.lang.String, class java.lang.String)"] [:li "public static boolean pathEquals(class java.lang.String, class java.lang.String)"] [:li "public static java.util.Locale parseLocaleString(class java.lang.String)"] [:li "public static [Ljava.lang.String; tokenizeToStringArray(class java.lang.String, class java.lang.String, boolean, boolean)"] [:li "public static [Ljava.lang.String; tokenizeToStringArray(class java.lang.String, class java.lang.String)"] [:li "public static java.lang.String toLanguageTag(class java.util.Locale)"] [:li "public static [Ljava.lang.String; addStringToArray(class [Ljava.lang.String;, class java.lang.String)"] [:li "public static [Ljava.lang.String; concatenateStringArrays(class [Ljava.lang.String;, class [Ljava.lang.String;)"] [:li "public static [Ljava.lang.String; mergeStringArrays(class [Ljava.lang.String;, class [Ljava.lang.String;)"] [:li "public static [Ljava.lang.String; sortStringArray(class [Ljava.lang.String;)"] [:li "public static [Ljava.lang.String; trimArrayElements(class [Ljava.lang.String;)"] [:li "public static [Ljava.lang.String; removeDuplicateStrings(class [Ljava.lang.String;)"] [:li "public static java.util.Properties splitArrayElementsIntoProperties(class [Ljava.lang.String;, class java.lang.String)"] [:li "public static java.util.Properties splitArrayElementsIntoProperties(class [Ljava.lang.String;, class java.lang.String, class java.lang.String)"] [:li "public static [Ljava.lang.String; commaDelimitedListToStringArray(class java.lang.String)"] [:li "public static java.util.Set commaDelimitedListToSet(class java.lang.String)"] [:li "public static java.lang.String collectionToCommaDelimitedString(interface java.util.Collection)"] [:li "public static java.lang.String arrayToDelimitedString(class [Ljava.lang.Object;, class java.lang.String)"] [:li "public static java.lang.String arrayToCommaDelimitedString(class [Ljava.lang.Object;)"] [:li "public final void wait()"] [:li "public final native void wait(long)"] [:li "public final void wait(long, int)"] [:li "public boolean equals(class java.lang.Object)"] [:li "public java.lang.String toString()"] [:li "public native int hashCode()"] [:li "public final native java.lang.Class getClass()"] [:li "public final native void notify()"] [:li "public final native void notifyAll()"]]]]


(ns #^{:author "al3xandr3 <al3xandr3@gmail.com>"
       :doc "Cov3, a custom crawler" }
  cov3)

(require '[clojure.zip :as zip])
(require '[clojure.xml :as xml])
(require '[clojure.contrib.string :as string])
(require '[clojure.contrib.duck-streams :as stream])

(use 'clojure.set) 
(use 'clojure.contrib.zip-filter.xml)


(import '(java.io File))
(import 'java.io.FileWriter)
(import 'java.text.SimpleDateFormat)
(import 'java.util.Date)
(import 'java.util.Calendar)
(import 'java.net.URLDecoder)

(import 'org.openqa.selenium.By)
(import 'org.openqa.selenium.Cookie)
(import 'org.openqa.selenium.Speed)
(import 'org.openqa.selenium.WebDriver)
(import 'org.openqa.selenium.WebElement)
(import 'org.openqa.selenium.htmlunit.HtmlUnitDriver)
(import 'org.openqa.selenium.firefox.FirefoxDriver)
(import 'org.openqa.selenium.ie.InternetExplorerDriver)
(import 'org.openqa.selenium.chrome.ChromeDriver)
(import 'org.openqa.selenium.JavascriptExecutor)

(import 'java.io.FileReader 'au.com.bytecode.opencsv.CSVReader)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WEBDRIVER API ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; *drivers* list and way to create a new instance, borrowed from:
;; http://github.com/mikitebeka/webdriver-clj/blob/master/webdriver.clj
(def *drivers* {
      :ff FirefoxDriver
      :ie InternetExplorerDriver
      :ch ChromeDriver
      :hu HtmlUnitDriver})

(defmacro with-browser
  "given a variable to place the browser intance and a type of browser 
   (ff, ie, ch or hu), it creates a webdriver browser instance than
   is then available in the body. Closes browser instance at the end"
  [browser type & body]
  `(let [~browser (.newInstance (*drivers* ~type))]
     ;; htmlUnit requires to be explicitly enabled for javascript
     (if (= ~type :hu)
       (.setJavascriptEnabled ~browser true))
     ~@body
     ;; htmlUnit does not needs to be closed
     (if (not (= ~type :hu))
       (.close ~browser))))
;; (macroexpand '(cov3/with-browser b :ff))
;; (cov3/with-browser b :ff)

(defn go
  "given a browser instance with some page open, it 
  browses to a page"
  [browser url]
  (try 
   (.get browser url)
  (catch Exception e
    (println (str url "," e)))))
;; (cov3/with-browser b :ff (cov3/go b "http://al3xandr3.github.com/"))

(defn js-eval
  "given a browser instance with some page open, it 
   executes javascript code"
  [browser code]
  (try 
   (.executeScript browser (str "return " code) (into-array ""))
   (catch Exception e
     (println (str code "," e))
     (str code "," e))))
;; (cov3/with-browser b :hu (cov3/go b "http://al3xandr3.github.com/") (println (cov3/js-eval b "document.title")))
;; (cov3/with-browser b :ff (cov3/go b "http://al3xandr3.github.com/") 
;;   (println (cov3/js-eval b "(typeof jQuery !== 'undefined')")))
;; (cov3/with-browser b :ff (cov3/go b "http://al3xandr3.github.com/") 
;;   (println (cov3/js-eval b "(new Date().getHours())+':'+(new Date().getMinutes())+':'+(new Date().getSeconds())")))

;; note that chrome has bugs, reported here:
;; http://code.google.com/p/selenium/issues/detail?id=430
;; so following does not work yet...
;; (cov3/with-browser b :ch (cov3/go b "http://al3xandr3.github.com/") (println (cov3/js-eval b "document.title")))

(defn get-protocol
  "given a browser instance with some page open, it 
   returns the url protocol, like 'http'"
  [b]
  (js-eval b "location.protocol"))
;; (cov3/with-browser b :hu (cov3/go b "http://al3xandr3.github.com/") (println (cov3/get-protocol b)))

(defn get-domain
  "given a browser instance with some page open, it 
   returns the url domain, like al3xandr3.github.com"
  [b]
  (js-eval b "location.hostname"))
;;(cov3/with-browser b :hu (cov3/go b "http://al3xandr3.github.com/") (println (cov3/get-domain b)))

(defn- get-attr
  "given a webdrivers html element, it returns
   the value of the attr specified"
  [elem attr]
  "gets an attribute from a webdriver web element"
  (.getAttribute elem attr))

(defn get-links-in-domain
  "given a browser instance with some page open, it 
   retuns all of the page's links to the same domain"
  [b]
  (try 
   (let [lnks   (js-eval b "document.links")]
     (if (empty? lnks)
       '()
       (let [href   (map #(get-attr % "href") lnks)
	     host   (str (get-protocol b) "//"  (get-domain b))
	     flnks  (map #(if (string/substring? host %) % (str host %)) href)
	     pound  (map #(first (string/split #"\#" %)) flnks)]
	 pound)))
   (catch Exception e
     (println (str "get-links-in-domain: " e)))))
      
;; (cov3/with-browser b :hu (cov3/go b "http://al3xandr3.github.com/") (println (first (cov3/get-links-in-domain b))))

(defn read-cookie
  [driver name]
  (let [coo (.getCookieNamed (.manage driver) name)]
    (if (= coo nil)
      ""
      (.getValue coo))))
;;(cov3/with-browser b :ff (cov3/go b "http://al3xandr3.github.com/") (println (cov3/read-cookie b "_github_ses")))

(defn write-cookie
  ([b n v]   (write-cookie b n v nil "/"))
  ([b n v d] (write-cookie b n v d "/"))
  ([b name value date path] (.addCookie (.manage b) (new Cookie name value path date))))
;;(cov3/with-browser b :ff (cov3/go b "http://al3xandr3.github.com/") (println (cov3/new-cookie b "al" "123" "")))

(defn remove-cookie
  "given en executing browser and a cookie name, 
   it removes that cookie"
  [b name]
  (.deleteCookieNamed (.manage b) name))
;; (cov3/with-browser b :hu (cov3/go b "http://al3xandr3.github.com/") (println (cov3/remove-cookie b "_github_ses")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PAGE VALIDATOR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn validate-page
  "given a browser and a page, returns a comma separated string
   result of the execution of the javascript validation given"
  ([b u v] (validate-page b u v (fn[b]()) ))
  ([browser a-url validations post-fn]
     (try 
      (go browser a-url)
      (Thread/sleep 2000) ;; make a little timeout, to avoid overloading server
      (post-fn browser)
      (let [vals (map #(js-eval browser %) validations) 
	    vals-str (apply str (interpose "," vals))]
	(str a-url "," vals-str))
      (catch Exception e
	(str a-url "," e)))))

;; (cov3/with-browser b :ff (println (cov3/validate-page b "http://al3xandr3.github.com/" '("document.title" "(typeof jQuery !== 'undefined')"))))
;; (cov3/with-browser b :ff (println (cov3/validate-page b "http://al3xandr3.github.com/" '("document.title") (fn[b](cov3/remove-cookie b "_github_ses")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; REGULAR CRAWLER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- domain-of [a-url]
  "given a url it returns its domain"
  (last (re-find #"http(s?)://([^/]*)" a-url)))
;; (cov3/domain-of "http://al3xandr3.github.com/")

(defn- save-q [a-url to-see seen]
  "saves a queue to file"
  (do 
    (stream/spit 
     (str (domain-of a-url) "_to_see.txt")
     to-see))
  (stream/spit 
   (str (domain-of a-url) "_seen.txt")
   seen))

(defn- load-q [a-url name] 
  "loads a queue(for the crawler) from file, for a given url, 
   for a given domain name.
   Note that when loads an non-existing file, then also returns back as the 
   first on the queue the url given as this func argument, 
   this is usefull for bootstraping the crawler"
  (let [fil (new File (str (domain-of a-url) name))]
    (if (.exists fil) 
      (with-in-str (slurp (str (domain-of a-url) name)) (read))
      #{(str a-url)})))

(defn- process-to-see
  "calculates the list of the next links to see in the crawler crawl"
  [to-see seen saw-lnk new-lnks]
  (let [nto-see (disj to-see saw-lnk)] ;remove the last seen link
    (if (not (empty? new-lnks))
      (let [asset (set new-lnks) 
	    ;; only allow the ones with correct domain
	    rightdomain (set (filter #(= (domain-of saw-lnk) (domain-of %)) asset)) 
	    ;; removes the already seen links
	    without-seen (difference rightdomain seen)]
	(union nto-see without-seen))
      nto-see)))

(defn crawl
  "crawls a site, and a aplies the javavascript validations given to each page"
  ([b u v] (crawl b u v (fn[b]()) ))
  ([b a-site validations post-fn]
     (cov3/with-browser browser b
       (binding [*out* (FileWriter. 
			(str "result_crawl_"
			     (domain-of a-site) 
			     (.format (SimpleDateFormat. "yyyy-MM-dd") (Date.)) ".csv"))]
	  ;; returns the root url, when empty for bootstrap
	 (loop [to-see (load-q a-site "_to_see.txt")
		seen (load-q a-site "_seen.txt")] 
	   (if (not (empty? to-see))
	     (let [a-url (first to-see)]
	       (save-q a-url to-see seen)
	       (println (validate-page browser a-url validations post-fn))
	       (let [new-lnks (get-links-in-domain browser)]
		 (recur (process-to-see to-see seen a-url new-lnks) (conj seen a-url))))))
	 (println "DONE")))))
;; (cov3/crawl :ff "http://al3xandr3.github.com/" '("document.title" "(typeof jQuery !== 'undefined')"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SITEMAP.XML CRAWLER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- pick-sample [a-percentage a-list]
  "picks a subset (a)percentage of the total"
  (filter #(if (> (rand) (- 1 (/ a-percentage 100))) %) a-list))
;; (cov3.sitemap/pick-sample 50 '(1 2 3 4 5 6 7 8 9 0))

(defn- get-sitemap
  "given a sitemap url it returns a list of the sample size of the links
   also aplies replacement to the links if desired, usefull for development 
   enviroments that go check live enviroment, or vice-versa."
  [sitemap-url sub-from sub-to sample-size]
  (let [raw   (xml-> (zip/xml-zip (xml/parse sitemap-url)) :url :loc text)
	piked (pick-sample sample-size raw)
	trans (map #(.replace % sub-from sub-to) piked)]
    trans))
;; (cov3/get-sitemap "http://al3xandr3.github.com/sitemap.xml" "" "" 100)

(defn sitemap-crawl
  "given a browser a sitemap url and validations it runs those validations
   on each page of the sample sixed sitemap, also with the transformation given"
  ([b s f t ss v] (sitemap-crawl b s f t ss v (fn[b]())))
  ([b sitemap-url replace-from replace-to sample-size validations post-fn]
     (cov3/with-browser a-browser b
       (let [url-list (get-sitemap sitemap-url replace-from replace-to sample-size)]
	 ;; outputs the result to file
	 (binding [*out* (FileWriter. 		   
			  (str "result_sitemap-crawl_" 
			       (domain-of sitemap-url) "_"
			       (.format (SimpleDateFormat. "yyyy-MM-dd") (Date.)) ".csv"))]
	     (doseq [a-url url-list]
	       (println (validate-page a-browser a-url validations post-fn))))))))
;; (cov3/sitemap-crawl :ff "http://al3xandr3.github.com/sitemap.xml" "" "" 90 '("document.title"))
;; (cov3/sitemap-crawl :ff "http://al3xandr3.github.com/sitemap.xml" "" "" 90 '("document.title"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; STEP CRAWLER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- read-csv [filename]
  "given a filename it returns a list(seq) of lines, where each line is a 4 element list(seq)"
  (let [reader (CSVReader. (FileReader. filename))]
    (map vec (take-while identity (repeatedly #(.readNext reader))))))

(defn step-crawl
  "given a browser and a file with the steps to take, goes step-by-step 
   outputing the validations results. In the file besides the url on each step
   there are also the validations to execute. File format, a csv file with 4 columns:
   url-to-go,javascript-validation-to-run1,javascript-validation-to-run2,javascript-validation-to-run3
   example: http://al3xandr3.github.com/,\"document.title\",\"'jQuery?:'+(typeof jQuery !== 'undefined')\",2+2"
  ([b f] (step-crawl b f (fn[b]())))
  ([b file post-fn]
     (let [stripname (last (string/split #"\/" file))]
       (binding [*out* (FileWriter. 
			(str "result_step-crawl_"
			     stripname "_"
			     (.format (SimpleDateFormat. "yyyy-MM-dd") (Date.)) ".csv"))]
	 (cov3/with-browser browser b
	   (let [lst (read-csv file)]
	     (doseq [[url check1 check2 check3] lst]
	       (println (validate-page browser url (list check1 check2 check3) post-fn)))))))))
;; (cov3/step-crawl :ff "data/steps.csv")
;; (cov3/step-crawl :ff "data/steps.csv" #(cov3/remove-cookie % "_github_ses"))

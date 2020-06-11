(ns html-parse.parser-test
  (:refer-clojure :exclude [ancestors descendants])
  (:use clojure.test plumbing.test)
  (:require
   [html-parse.parser :as parser]))


(def simple-html
  "
<html>
<body>
<div><p>foo</p><p>bar</p></div>
<div><p>fooz</p><p>barz</p></div>
</body>
</html>
")

(deftest ^{:slow true} relations
  (let [dom (parser/dom simple-html)
        html (-> dom parser/children first)
        body (-> html parser/children first)
        [i1 div1 i2 div2 i3] (parser/children body)
        [p1 p2 p3 p4] (mapcat parser/children [div1 div2])
        [t1 t2 t3 t4] (mapcat parser/children [p1 p2 p3 p4])]
    (is (= (parser/ancestors div1) [div1 body html dom]))
    (is (= (parser/ancestors p3) [p3 div2 body html dom]))
    (is (= (parser/ancestors dom) [dom]))
    (is (= (parser/descendants p1) [p1 t1]))
    (is (empty? (parser/strict-descendants t1)))
    (is (= (parser/descendants body) [body i1 div1 p1 t1 p2 t2 i2 div2 p3 t3 p4 t4 i3]))
    (is (= (parser/least-common-ancestor p1 p2) div1))
    (is (= (parser/least-common-ancestor p1 p4) body))
    (is (= (parser/least-common-ancestor p1 div2) body))))

(deftest simple-walk
  (is (= "\nfoobar\nfoozbarz\n"
         (parser/text-from-dom (parser/dom simple-html)))))

(def children-test-html
  "<html><head>
      <script src=\"script\"></script>
      <link rel=\"link1\"></link>
      <meta name=\"meta\"></meta>
      <link rel=\"link2\"></link>
    </head>
  </html>
")

(deftest dom->hiccup-test
  (is-= [:html {:xmlns:html "http://www.w3.org/1999/xhtml"}
         [:head
          [:meta
           {:content "text/html;charset=utf-8", :http-equiv "content-type"}]
          [:title "Hello"]]
         [:body [:h1 "Hello World"]]]
        (-> "<html>\n<head>\n<meta content=\"text/html;charset=utf-8\" http-equiv=\"content-type\" />\n<title>Hello</title>\n</head>\n<body>\n<h1>Hello World</h1>\n</body>\n</html>"
            parser/dom
            parser/dom->hiccup))

  (is-=
   [:html
    {:xmlns:html "http://www.w3.org/1999/xhtml"}
    [:body
     [:div
      {:itemprop "review"
       :itemscope "itemscope"
       :itemtype "http://schema.org/Review"}
      [:span {:itemprop "name"} "Not a happy camper"]
      "-\nby"
      [:span {:itemprop "author"} "Ellie"]
      ","]]
    [:head [:meta {:content "2011-04-01" :itemprop "datePublished"}]]
    [:body
     "April 1, 2011"
     [:div
      {:itemprop "reviewRating"
       :itemscope "itemscope"
       :itemtype "http://schema.org/Rating"}]]
    [:head [:meta {:content "1" :itemprop "worstRating"}]]
    [:body
     [:span {:itemprop "ratingValue"} "1"]
     "/"
     [:span {:itemprop "bestRating"} "5"]
     "stars"]]
   (-> "<div ITEMPROP=\"review\" itemscope itemtype=\"http://schema.org/Review\">
        <SPAN itemprop=\"name\">Not a happy camper</span> -
        by <span itemprop=\"author\">Ellie</span>,
        <meta itemprop=\"datePublished\" content=\"2011-04-01\">April 1, 2011
        <div itemprop=\"reviewRating\" itemscope itemtype=\"http://schema.org/Rating\">
        <meta itemprop=\"worstRating\" content = \"1\">
        <span itemprop=\"ratingValue\">1</span>/
        <span itemprop=\"bestRating\">5</span>stars
        </div>"
       parser/dom
       parser/dom->hiccup))

  (is-= [:html
         {:xmlns:html "http://www.w3.org/1999/xhtml"}
         [:body
          [:div
           {:property "aggregateRating" :typeof "AggregateRating"}
           [:span {:property "ratingValue"} "87"]
           "out of"
           [:span {:property "bestRating"} "100"]
           "based on"
           [:span {:property "ratingCount"} "24"]
           "user ratings"]]]
        (-> "<div property=\"aggregateRating\" typeof=\"AggregateRating\">
             <span property=\"ratingValue\">87</span> out of
             <span property=\"bestRating\">100</span> based on
             <span property=\"ratingCount\">24</span> user ratings </div>"
            parser/dom
            parser/dom->hiccup)))

(deftest children-test
  (let [dom (parser/dom children-test-html)]
    (is (= 4 (-> dom parser/head parser/children count)))
    (is ( = 2 (-> dom parser/head (parser/children "LiNK") count)))))

(def tc
  {:title "In The Fight Against IT Waste, 1E Releases NightWatchman 6.0", :link "http://feedproxy.google.com/~r/Techcrunch/~3/tEFtaTZo8jI/", :content "<p><img src=\"http://tctechcrunch.files.wordpress.com/2010/11/dashboard.jpg\" />Computer power management software company, <a href=\"http://www.1e.com/index.aspx\">1E</a> has released a new version of its marquee product, <a href=\"http://www.1e.com/softwareproducts/nightwatchman/index.aspx\">NightWatchman</a>.</p> <p>Like its predecessors, version 6.0, helps corporations manage their network of computers to optimize energy efficiency. It gives IT managers the ability to remotely power down computers and establish energy-saving settings (ie. automatic shutdown of desktops during the weekend).</p> <p>In the latest version, <a href=\"http://www.crunchbase.com/company/1e\">1E</a> has added three key features: a new web-based dashboard (to help managers oversee the entire company&#8217;s computer power usage), improved diagnostic tools to determine why a computer hasn&#8217;t properly powered down, and tariff calculations based on location.</p> <p>Given how the price of energy can fluctuate significantly on a region by region basis, the new location-based calculations will help companies more accurately assess how much they&#8217;re saving on energy usage. Energy efficiency as it relates to IT management is becoming an increasingly important field, and according to Gartner Research, in two years more than half of mid and large-sized businesses will centrally manage their desktops&#8217; energy consumption.</p> <p>Although the average NightWatchman PC only saves $36 a year in energy costs, those incremental savings yield significant sums in aggregate. Several of 1E&#8217;s clients are large corporations with massive IT operations, such as AT&amp;T, Ford and Dell. According to 1E, NightWatchman has 4.6 million licensed users around the world, a group that has collectively saved $530 million in energy costs.</p> <div class=\"cbw snap_nopreview\"><div class=\"cbw_header\"><script src=\"http://www.crunchbase.com/javascripts/widget.js\" type=\"text/javascript\"></script><div class=\"cbw_header_text\"><a href=\"http://www.crunchbase.com/\">CrunchBase Information</a></div></div><div class=\"cbw_content\"><div class=\"cbw_subheader\"><a href=\"http://www.crunchbase.com/company/1e\">1E</a></div><div class=\"cbw_subcontent\"><script src=\"http://www.crunchbase.com/cbw/company/1e.js\" type=\"text/javascript\"></script></div><div class=\"cbw_footer\">Information provided by <a href=\"http://www.crunchbase.com/\">CrunchBase</a></div></div></div> <br /> <a rel=\"nofollow\" href=\"http://feeds.wordpress.com/1.0/gocomments/tctechcrunch.wordpress.com/238571/\"><img alt=\"\" border=\"0\" src=\"http://feeds.wordpress.com/1.0/comments/tctechcrunch.wordpress.com/238571/\" /></a> <a rel=\"nofollow\" href=\"http://feeds.wordpress.com/1.0/godelicious/tctechcrunch.wordpress.com/238571/\"><img alt=\"\" border=\"0\" src=\"http://feeds.wordpress.com/1.0/delicious/tctechcrunch.wordpress.com/238571/\" /></a> <a rel=\"nofollow\" href=\"http://feeds.wordpress.com/1.0/gofacebook/tctechcrunch.wordpress.com/238571/\"><img alt=\"\" border=\"0\" src=\"http://feeds.wordpress.com/1.0/facebook/tctechcrunch.wordpress.com/238571/\" /></a> <a rel=\"nofollow\" href=\"http://feeds.wordpress.com/1.0/gotwitter/tctechcrunch.wordpress.com/238571/\"><img alt=\"\" border=\"0\" src=\"http://feeds.wordpress.com/1.0/twitter/tctechcrunch.wordpress.com/238571/\" /></a> <a rel=\"nofollow\" href=\"http://feeds.wordpress.com/1.0/gostumble/tctechcrunch.wordpress.com/238571/\"><img alt=\"\" border=\"0\" src=\"http://feeds.wordpress.com/1.0/stumble/tctechcrunch.wordpress.com/238571/\" /></a> <a rel=\"nofollow\" href=\"http://feeds.wordpress.com/1.0/godigg/tctechcrunch.wordpress.com/238571/\"><img alt=\"\" border=\"0\" src=\"http://feeds.wordpress.com/1.0/digg/tctechcrunch.wordpress.com/238571/\" /></a> <a rel=\"nofollow\" href=\"http://feeds.wordpress.com/1.0/goreddit/tctechcrunch.wordpress.com/238571/\"><img alt=\"\" border=\"0\" src=\"http://feeds.wordpress.com/1.0/reddit/tctechcrunch.wordpress.com/238571/\" /></a> <img alt=\"\" border=\"0\" src=\"http://stats.wordpress.com/b.gif?host=techcrunch.com&amp;blog=11718616&amp;post=238571&amp;subd=tctechcrunch&amp;ref=&amp;feed=1\" width=\"1\" height=\"1\" /> <p><a href=\"http://feedads.g.doubleclick.net/~at/w3bq_Lf15MuCCqeCkVfh9eMYs7g/0/da\"><img src=\"http://feedads.g.doubleclick.net/~at/w3bq_Lf15MuCCqeCkVfh9eMYs7g/0/di\" border=\"0\" ismap=\"true\"></img></a><br/> <a href=\"http://feedads.g.doubleclick.net/~at/w3bq_Lf15MuCCqeCkVfh9eMYs7g/1/da\"><img src=\"http://feedads.g.doubleclick.net/~at/w3bq_Lf15MuCCqeCkVfh9eMYs7g/1/di\" border=\"0\" ismap=\"true\"></img></a></p><div class=\"feedflare\"> <a href=\"http://feeds.feedburner.com/~ff/Techcrunch?a=tEFtaTZo8jI:MRP7yJsevfA:2mJPEYqXBVI\"><img src=\"http://feeds.feedburner.com/~ff/Techcrunch?d=2mJPEYqXBVI\" border=\"0\"></img></a> <a href=\"http://feeds.feedburner.com/~ff/Techcrunch?a=tEFtaTZo8jI:MRP7yJsevfA:7Q72WNTAKBA\"><img src=\"http://feeds.feedburner.com/~ff/Techcrunch?d=7Q72WNTAKBA\" border=\"0\"></img></a> <a href=\"http://feeds.feedburner.com/~ff/Techcrunch?a=tEFtaTZo8jI:MRP7yJsevfA:yIl2AUoC8zA\"><img src=\"http://feeds.feedburner.com/~ff/Techcrunch?d=yIl2AUoC8zA\" border=\"0\"></img></a> <a href=\"http://feeds.feedburner.com/~ff/Techcrunch?a=tEFtaTZo8jI:MRP7yJsevfA:-BTjWOF_DHI\"><img src=\"http://feeds.feedburner.com/~ff/Techcrunch?i=tEFtaTZo8jI:MRP7yJsevfA:-BTjWOF_DHI\" border=\"0\"></img></a> <a href=\"http://feeds.feedburner.com/~ff/Techcrunch?a=tEFtaTZo8jI:MRP7yJsevfA:D7DqB2pKExk\"><img src=\"http://feeds.feedburner.com/~ff/Techcrunch?i=tEFtaTZo8jI:MRP7yJsevfA:D7DqB2pKExk\" border=\"0\"></img></a> <a href=\"http://feeds.feedburner.com/~ff/Techcrunch?a=tEFtaTZo8jI:MRP7yJsevfA:qj6IDK7rITs\"><img src=\"http://feeds.feedburner.com/~ff/Techcrunch?d=qj6IDK7rITs\" border=\"0\"></img></a> </div><img src=\"http://feeds.feedburner.com/~r/Techcrunch/~4/tEFtaTZo8jI\" height=\"1\" width=\"1\"/>", :des "<img src=\"http://tctechcrunch.files.wordpress.com/2010/11/watchman.jpg\" />Computer power management software company, <a href=\"http://www.1e.com/index.aspx\">1E</a> has released a new version of its marquee product, <a href=\"http://www.1e.com/softwareproducts/nightwatchman/index.aspx\">NightWatchman</a>. Like its predecessors, version 6.0, helps corporations manage their network of computers to optimize energy efficiency. It gives IT managers the ability to remotely power down computers and establish energy-saving settings (ie. automatic shutdown of desktops during the weekend). In the latest version, <a href=\"http://www.crunchbase.com/company/1e\">1E</a> has added three key features.<img alt=\"\" border=\"0\" src=\"http://stats.wordpress.com/b.gif?host=techcrunch.com&amp;blog=11718616&amp;post=238571&amp;subd=tctechcrunch&amp;ref=&amp;feed=1\" width=\"1\" height=\"1\" />", :date "2010-11-01T16:54:57.582Z"})

(def clean-tc
  {:title "In The Fight Against IT Waste, 1E Releases NightWatchman 6.0", :link "http://feedproxy.google.com/~r/Techcrunch/~3/tEFtaTZo8jI/", :content "Computer power management software company, 1E has released a new version of its marquee product, NightWatchman. Like its predecessors, version 6.0, helps corporations manage their network of computers to optimize energy efficiency. It gives IT managers the ability to remotely power down computers and establish energy-saving settings (ie. automatic shutdown of desktops during the weekend). In the latest version, 1E has added three key features: a new web-based dashboard (to help managers oversee the entire company’s computer power usage), improved diagnostic tools to determine why a computer hasn’t properly powered down, and tariff calculations based on location. Given how the price of energy can fluctuate significantly on a region by region basis, the new location-based calculations will help companies more accurately assess how much they’re saving on energy usage. Energy efficiency as it relates to IT management is becoming an increasingly important field, and according to Gartner Research, in two years more than half of mid and large-sized businesses will centrally manage their desktops’ energy consumption. Although the average NightWatchman PC only saves $36 a year in energy costs, those incremental savings yield significant sums in aggregate. Several of 1E’s clients are large corporations with massive IT operations, such as AT&T, Ford and Dell. According to 1E, NightWatchman has 4.6 million licensed users around the world, a group that has collectively saved $530 million in energy costs. CrunchBase Information1EInformation provided by CrunchBase", :des "Computer power management software company, 1E has released a new version of its marquee product, NightWatchman. Like its predecessors, version 6.0, helps corporations manage their network of computers to optimize energy efficiency. It gives IT managers the ability to remotely power down computers and establish energy-saving settings (ie. automatic shutdown of desktops during the weekend). In the latest version, 1E has added three key features.", :date "2010-11-01T16:54:57.582Z"})

(deftest strip-space-test
  (is (= "foo  bar"
         (parser/strip-space "\n\n\tfoo  bar\n \t   \n\n")))
  (is (= "foo\nbar"
         (parser/strip-space "\n\n\tfoo  \n\n\n\n  bar\n \t   \n\n")))
  (is (= "foo\nbar"
         (parser/strip-space "\n\n\tfoo \n\t  \nbar\n \t   \n\n"))))

(def html-with-garbage
  "
<html>
<body>

<p>foo</p>
<p>bar</p>
<p>baz</p>

<img src=\"http://feeds.feedburner.com/~ff/Techcrunch?d=qj6IDK7rITs\" border=\"0\"></img>

<form name=\"input\" action=\"html_form_action.asp\" method=\"get\">
Username: <input type=\"text\" name=\"user\" />
<input type=\"submit\" value=\"Submit\" />
</form>

<script type=\"text/javascript\">
document.write(\"Hello World!\")
</script>

<iframe src=\"html_intro.asp\" width=\"100%\" height=\"300\">
  <p>Your browser does not support iframes.</p>
</iframe>

</body>
</html>
")

(def html-without-garbage
  "<?xml version=\"1.0\" encoding=\"UTF-16\"?><html xmlns:html=\"http://www.w3.org/1999/xhtml\"><body>\n\n<p>foo</p>\n<p>bar</p>\n<p>baz</p>\n\n<img border=\"0\" src=\"http://feeds.feedburner.com/~ff/Techcrunch?d=qj6IDK7rITs\"/>\n\n\n\n\n\n\n\n</body></html>")


(deftest unescape-html-test
  (is (= "10>3"
         (parser/unescape-html "10&gt;3"))))

(deftest replace-unicode-control-test
  (is (= "hi\u000aand\u000abye"
         (parser/replace-unicode-control "hi\u2028and\u2029bye"))))

(def html-with-relative
  "
<html>
<head>
<link href=\"bang.png\"/>
</head>
<body>
<img src=\"/kittens/city/hang.jpg\"</img>
<p><a href=\"http://www.anchors.com\">anchor text is good.</a></p>
<span>fizzle<p class=\"fuckyeah\"><a href=\"/anchors.com\"</a></p></span>
<a href=\"http://anchor-city-hustle.com\">fuck yeah, anchors are the future.</a>
</body>
</html>
")

(deftest proper-expanded-urls
  (is (=
       "<html xmlns:html=\"http://www.w3.org/1999/xhtml\"><head><link href=\"http://heavy-city.com/bang.png\"/></head><body>\n<img _=\"_\" img=\"img\" src=\"http://heavy-city.com/kittens/city/hang.jpg\"/>\n<p><a href=\"http://www.anchors.com\" shape=\"rect\">anchor text is good.</a></p>\n<span>fizzle</span><p class=\"fuckyeah\"><a _=\"_\" a=\"a\" href=\"http://heavy-city.com/anchors.com\" shape=\"rect\"/></p>\n<a href=\"http://anchor-city-hustle.com\" shape=\"rect\">fuck yeah, anchors are the future.</a>\n</body></html>"
       (->> html-with-relative parser/dom (parser/expand-relative-urls! "http://heavy-city.com/hangers") parser/html-str2))))

(deftest test-url
  (is (instance? java.net.URL (parser/url "http://google.com"))))

(deftest test-host
  (is (= "google.com") (parser/host (parser/url "http://google.com/foo")))
  (is (= "google.com") (parser/host (parser/url "http://Google.com/foo"))))

(deftest test-url-seq
  (is (= [(parser/url "http://google.com") (parser/url "http://yahoo.com")]
         (parser/url-seq "Yep, http://google.com is better than http://yahoo.com"))))


(deftest test-relative-url
  (is (= "http://foo.com/bar/baz/quux.html"
         (str (parser/relative-url "http://google.com" "http://foo.com/bar/baz/quux.html"))))
  (is (= "http://foo.com/bar/baz/quux.html"
         (str (parser/relative-url "http://foo.com/a/b/c.html" "/bar/baz/quux.html"))))
  (is (= "http://foo.com/bar/baz/quux.html"
         (str (parser/relative-url "http://foo.com/bar/b/c.html" "/bar/baz/quux.html"))))
  (is (= "http://foo.com/bar/baz/quux.html"
         (str (parser/relative-url "http://foo.com/bar/b/c.html" "../baz/quux.html"))))
  (is (= "http://foo.com/bar/baz/quux.html"
         (str (parser/relative-url "http://foo.com/bar/baz/kittens.html" "quux.html"))))
  (is (= "http://foo.com/bar/baz/quux.html"
         (str (parser/relative-url "http://foo.com/bar/baz/" "quux.html")))))

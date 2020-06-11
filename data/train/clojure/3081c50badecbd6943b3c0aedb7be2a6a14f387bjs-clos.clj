(use '(web blog))

(blog
 {:title   "JS-CLOS"
  :author  "ympbyc"
  :date    (java.util.Date. 2012 2 23)
  :content
  [:div
   [:p "This is a brief introduction to "
    [:a {:href "https://github.com/ympbyc/js-clos"} "JS-CLOS"]
    ". JS-CLOS is a JavaScript library that features multiple inheritance, multiple dispatching and multiple constructors. Multiplicating everything, you get multiple happinesses ;)"]

   [:h1 "JS-CLOS"]
   [:h2 "What is CLOS in the first place?"]
   [:p "Common Lisp Object System (CLOS) is a way to do OOP in Lisp. In CLOS, objects are basically just mutable hash-tables holding values. Methods are not included in these hash-tables. Instead, what's called methods in CLOS are implemented as <b>generic functions</b>. <b>Generic functions</b> are functions that work on multiple classes, a combination of them."]
   [:p "Heres a sample code in Tklos, a variant of CLOS."]
   [:pre [:code
 ";; a class representing instruments
 (define-class &lt;instrument&gt; () ())

 ;; flute inherits from &lt;instrument&gt;
 (define-class &lt;flute&gt; (&lt;instrument&gt;) ())

 ;; musicians have a name and the instrument they play
 (define-class &lt;musician&gt; ()
   ((instrument :init-keyword :instrument)
    (name       :init-keyword :name)))

 ;; flute players inherits from &lt;musician&gt; and they play the flute
 (define-class &lt;flute-player&gt; (&lt;musician&gt;)
   ((instrument :init-value (make &lt;flute&gt;))))

 ;; generic function can-play?
 (define-generic can-play?)

 ;; a flute-player can play the flute
 (define-method can-play? ((fp &lt;flute-player&gt;) (f &lt;flute&gt;))
   #t)
 ;; a flute-player can not play other instruments
 (define-method can-play? ((fp &lt;flute-player&gt;) (i &lt;instrument&gt;))
   #f)

 ;; a musician can play an instrument when the musician has the instrument
 (define-method can-play? ((m &lt;musician&gt;) (i &lt;instrument&gt;))
   (is-a? (slot-ref m 'instrument) i))"]]

   [:h2 "Implementing it in JS"]
   [:p "I found a repository named JS-CLOS on github that someone in Russia has abandoned a year ago unfinished. I forked and made some commits to it. I ended up rewriting almost every line and believe I've come up with a usable solution. Here's what's equivalent to the code above in JS-CLOS. The code is written in CoffeeScript."]
   [:pre [:code
"## a class representing instruments
instrument = define_class()

## flute inherits from instrument
flute = define_class [instrument]

## musicians have a name and an instrument they play
musician = define_class [], (x) ->
  (slot_exists x, 'instrument', instrument) &amp;&amp; (slot_exists x, 'name', 'string')

## flute players inherits from musician and they play the flute
flute_player = define_class [musician], (x) ->
  x.instrument = make flute
  true

## generic function can_play
can_play = define_generic()

## a flute_player can play the flute
define_method can_play, [flute_player, flute], -> true

## a flute-player can not play other instruments
define_method can_play, [flute_player, instrument], -> false

## a musician can play an instrument when the musician has the instrument
define_method can_play, [musician, instrument], (m, i) ->
  is_a m.instrument, i"]]

   [:h2 "Extension for Functional Programming"]
   [:p "I extended JS-CLOS with some features to support functional style programming. One is for dispatching methods on equality of values. This allows us to do something like this:"]
   [:pre [:code
    "fib = define_generic()

define_method fib, [0], -> 0
define_method fib, [1], -> 1
define_method fib, ['number'], (n) ->
  fib (n - 1) + fib (n - 2)"]]
   [:p "Another such feature is the support for multiple constructors. With this, you can write ML style datatypes."]
   [:pre [:code
    "color = define_class()
Red   = define_constructor color
Green = define_constructor color
Blue  = define_constructor color
WebColor = define_constructor color, (str) ->
  make(color, {webCol:str})

is_a Red(), color
#=>true
is_a (WebColor '#ff0033'), color
#=>true"]]
   [:p "More sophisticated examples will show up in my gist. Follow me if you are interested."]

   [:h2 "Thank you for reading. Learn it and hack on!"]
   [:p [:a {:href "https://github.com/ympbyc/js-clos"} "JS-CLOS"]]]})

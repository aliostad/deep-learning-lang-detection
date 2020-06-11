;; gorilla-repl.fileformat = 1

;; **
;;; # Clojure Lectures (3)
;;; 
;;; In this lecture, we will try to do something non-trivial(ish): we will use java's sound library to access MIDI interface and play some sounds.
;; **

;; @@
(ns poised-garden
   (:import javax.sound.midi.MidiSystem
            java.util.Random))
;; @@
;; =>
;;; {"type":"html","content":"<span class='clj-nil'>nil</span>","value":"nil"}
;; <=

;; **
;;; ## Java interoperability
;;; 
;;; As you saw at the beginning, you can import java classes by a simple `import` statement when you define your namespace.  However, you can do this in the code as well. If you want to create a new class, you'll do:
;; **

;; @@
(def rng (new Random 42))
(.nextInt rng)
;; @@
;; =>
;;; {"type":"html","content":"<span class='clj-unkown'>-1170105035</span>","value":"-1170105035"}
;; <=

;; **
;;; There is a shorthand version of the same `new` statement:
;; **

;; @@
(def rng (Random. 24))
(.nextInt rng)
;; @@
;; =>
;;; {"type":"html","content":"<span class='clj-unkown'>-1152406585</span>","value":"-1152406585"}
;; <=

;; **
;;; Notice the "." at the end of the class name.
;;; 
;;; Now, for our non-trivial application we are going to write a program which is going to play sound/music on our sound hardware. We are going to feed the program a sequence of notes, and it will playback the music.
;;; 
;;; 
;;; First, we are going to need a function that does the initialization on the sound channel, and then selects the instrument that we are going to play on the channel:
;; **

;; @@
(defn getInstrument [channelNum instrumentNum]
  (let [device (MidiSystem/getSynthesizer)]
    
    (.open device) 
  
    (let [channel    (-> device .getChannels (nth channelNum))
          instrument (-> device .getDefaultSoundbank .getInstruments (nth instrumentNum))]
          
       (println "Playing " (.getName instrument))
      
       (.loadInstrument device instrument)
       (.programChange channel instrumentNum) ; Important!!!!

       (fn [key duration volume]
          (.noteOn channel key volume)
          (Thread/sleep duration)
          (.noteOff channel key)))))
;; @@
;; =>
;;; {"type":"html","content":"<span class='clj-var'>#&#x27;poised-garden/getInstrument</span>","value":"#'poised-garden/getInstrument"}
;; <=

;; **
;;; I stole most of this code from [this blog post](https://taylodl.wordpress.com/2014/01/21/making-music-with-clojure-an-introduction-to-midi) on the same subject by [@taylodl](https://twitter.com/taylodl) on his [blog](https://taylodl.wordpress.com/). Let us go over the code line by line:
;;; 
;;; * The object `device` I initialized at the initial `let` statement is a pure java class. It came from [`javax.sound.midi.MidiSystem`](http://docs.oracle.com/javase/7/docs/api/javax/sound/midi/MidiSystem.html) fro which we call the static method [`getSynthesizer`](http://docs.oracle.com/javase/7/docs/api/javax/sound/midi/MidiSystem.html#getSynthesizer(). 
;;; * Next, we initialize the sound device and then open the channel. 
;;; * Then we get the channel numbered `channelNum` and then we get the instrument numbered `instrumentNum`.
;;; * Then we print on the console the name of the instrument we are playing.
;;; * Then we load the instrument to the channel.
;;; * And we tell the channel to use this instrument.
;;; 
;;; This part of the code in java would have looked like as follows:
;;; 
;;;         public getInstrument(int chanNum, int instNum) {
;;;            device = javax.sound.midi.MidiSystem.getSynthesizer();
;;;            device.open();
;;;            chan = device.getChannels()[chanNum];
;;;            inst = device.getDefaultSoundbank().getInstruments()[instNum];
;;;        
;;;            println(instrument.getname());
;;;            
;;;            device.loadInstrument(inst);
;;;            chan.programChange(instNum);
;;;            ...
;;;         }
;;;     
;;; Which, apart from the syntax issues, is a faithful translation of the clojure code, or vice versa.  However, there are some big differences:
;;; 
;;; ## The thread macros 
;;; 
;;; Look at the line which contains the *function-like* object "`->`". It has the following form
;;; 
;;;         (-> arg fn-1 fn-2 fn-3 ...)
;;;     
;;; It is called the *thread-first* macro.  It starts with evaluating the argument `arg`. Next, if `fn-1` is just a function name then it applies the function to the argumen.  Then gets the result and does the same thing for `fn-2` and`fn-3` etc.  However, if `fn-j` is not a name but a function call code as in `(nth i)` then inserts the argument at hand as the first argument creating `(nth arg i)` before it calls and evaluates it.  There is another version `->>` called the *thread-last* macro which has the same behavior except when it inserts, it inserts arg as a last argument. Here are two examples:
;; **

;; @@
(-> 2 (list 3) (conj 4))

(->> 2 (list 3) (cons 4))
;; @@
;; =>
;;; {"type":"list-like","open":"<span class='clj-list'>(</span>","close":"<span class='clj-list'>)</span>","separator":" ","items":[{"type":"html","content":"<span class='clj-long'>4</span>","value":"4"},{"type":"html","content":"<span class='clj-long'>3</span>","value":"3"},{"type":"html","content":"<span class='clj-long'>2</span>","value":"2"}],"value":"(4 3 2)"}
;; <=

;; **
;;; Such code transformations in the java-land are unheard of.
;;; 
;;; ## Going back to our application
;;; 
;;; Now, look at the last part of our function above:
;;; 
;;;         (fn [note duration volume]
;;;             (.noteOn channel note volume)
;;;             (Thread/sleep duration)
;;;             (.noteOff channel note))
;;; 
;;; Our function `getInstrument` returns a function of three variables: `note` the note we are going to play, `duration` the length of the note, and `volume`the volume at which this note is going to be played. Let me be clear: `getInstrument` **returns** a function! Not a class, but a **function**! 
;;; 
;;; Next, we need a function that would play the notes on a given instrument:
;; **

;; @@
(defn play [instrument notes]
  (doseq [note notes]
    (apply instrument note)))
;; @@
;; =>
;;; {"type":"html","content":"<span class='clj-var'>#&#x27;poised-garden/play</span>","value":"#'poised-garden/play"}
;; <=

;; **
;;; The function `doseq` takes two arguments: the first variable `note` is your iteration variable than runs over a sequence `notes` then evaluates its body.  In the body we have `apply` which had `instrument` and the iteration variable `note`. I am going to design songs as a sequence of notes, and each note will be a vector `[key length volume]`.
;;; 
;;; The function `apply` takea a function `fn` and a vector of values `[a b c ...]` then evaluates `(fn a b c ...)`.  In our case we evaluate `(instrument key length volume)`.
;;; 
;;; Let us make some noise :) On my machine, the implementation numbered the clavier as `7`.
;; **

;; @@
(let [clavier (getInstrument 2 7)]
  (play clavier (vector [42 250 180] [46 500 200] [32 500 220] [32 250 220])))
;; @@
;; ->
;;; Playing  Clavi
;;; 
;; <-
;; =>
;;; {"type":"html","content":"<span class='clj-nil'>nil</span>","value":"nil"}
;; <=

;; **
;;; The code above plays 42nd key 250ms with volume 180 followed by the 46th key 500ms with volume 200 etc on a clavier on channel 2.
;; **

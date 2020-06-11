;;; SYNTH.CLJ
;;; Mark Burger, August - October 2015
;;;
;;; To use, simply (load-file "../path/to/Synth.clj")
;;;
;;; API EXPLANATION--
;;;
;;; (synth-init)
;;;    Defines global variables and opens the synthesizer
;;;
;;; (channel <number>)
;;;    returns a channel of the specified number, usually 0 through 15.
;;;    Each channel can have its own instrument and notes.
;;;
;;; (change-instrument <channel> <instrument number>)
;;;    Changes the instrument playing on the channel. For instrument numbers,
;;;    use print-instruments. This assumes a default bank. By default in 
;;;    testing, instrument numbers go from 0 - 128.
;;;
;;; (change-instrument-with-bank <channel> <bank> <instrument number>)
;;;    Sometimes, you'll need the entire range of instruments. That's
;;;    accessible here. Bank/Program numbers are available from
;;;    print-instruments.
;;;
;;; (print-instruments)
;;;    Prints the number of an instrument beside its human-readable name.
;;;    Most implementations only allow elements 1 through 127 of this list
;;;    to get loaded into the synthesizer.
;;;
;;; (play-note <channel> <note> <intensity> <duration>)
;;;    Play the selected note (see below) on the specified channel (use
;;;    the channel function to retrieve a channel) for an intensity (0 - 255)
;;;    over a certain (<duration>) number of milliseconds.
;;;
;;; (play-notes <channel> <music>)
;;;    Play the array of music on a channel. <music> is a list of arrays, where
;;;    each element of the array is four elements-- a note, its intensity,
;;;    its duration (milliseconds), and the number of milliseconds to wait
;;;    before playing the next note.
;;;
;;; (start-beat <function> <wait> <identifier>)
;;;    Calls the <function>-- usually an (fn...) with some play-note or
;;;    play-notes calls in it== every <wait> milliseconds. The identifier
;;;    is a string that's used for turning on/off this beat timer sequence.
;;;    Note that using this implementation, a beat can happen across multiple
;;;    channels.
;;;
;;; (stop-beat <identifier>)
;;;    A beat generated with (start-beat ...) with a provided identifier can
;;;    be stopped with this function using the same identifier.
;;;
;;; (synth-shutdown)
;;;    Stops any running beats and closes the synthesizer.
;;;
;;;
;;; THE NOTES-- 
;;;
;;; Basically, MIDI notes begin at zero. Each increment in the number resembles
;;; moving right one key (including black keys) across a piano / synthesizer.
;;;
;;;    60 is C4
;;;    61 - C4 #
;;;    62 - D4
;;;    63 - D4 #
;;;    64 - E4
;;;    65 - F4
;;;    66 - F4 #
;;;    67 - G4
;;;    68 - G4 #
;;;    69 - A4
;;;    70 - A4 #
;;;    71 - B4
;;;    72 - C5
;;;     ... etc ...
;;;
;;; Information is pretty easily findable with an image search, i.e.
;;;    https://www.google.com/search?tbm=isch&q=midi+numbers
;;;


(import '(javax.sound.midi MidiSystem) '(java.util HashMap) )

(def synth (MidiSystem/getSynthesizer))
(def instruments (.getAvailableInstruments synth))
(def beat-array (new HashMap))
(defn synth-init[]
	(.open synth)
	"Boom!"
)

; num, for most implementations should be 0 through 15.
(defn channel[num]
	(nth (.getChannels synth) num)
)

(defn change-instrument [chan instrument]
	(.programChange chan instrument)
)

(defn change-instrument-with-bank [chan bank instrument]
	(.programChange chan bank instrument)
)

(defn print-instruments[]
	(dotimes [i (count instruments)]
		(println (nth instruments i))
	)
)

; See what instruments are loaded with --
; (map (fn [a] (.getName a)) instruments)
; (.loadInstrument synth (nth instruments 3))



(defn play-note[channel note intensity duration]
	(.start (new Thread (fn []
		(.noteOn channel note intensity)
		(Thread/sleep duration)
		(.noteOff channel note)
	)))
)



; Music is (list
;  [note1 intensity1 duration1 pauseAfter1]
;  [note2 intensity2 duration2 pauseAfter2] ... )
(defn play-notes [channel music]
	(dotimes [n (count music)]
		(let [q (nth music n)]
			(play-note channel (nth q 0) (nth q 1) (nth q 2))
			(Thread/sleep (nth q 3))
		)
	)
)

(defn start-beat[f millis id]
	(.start (new Thread (fn []
	(.put beat-array id true)
	(while (not (nil? (.get beat-array id)))
		(eval (list f))
		(Thread/sleep millis)
	))))
)

(defn stop-beat[id]
	(.put beat-array id nil)
)

(defn synth-shutdown[]
	(map (fn [k] (stop-beat k)) (.keySet beat-array))
	(.close synth)
)


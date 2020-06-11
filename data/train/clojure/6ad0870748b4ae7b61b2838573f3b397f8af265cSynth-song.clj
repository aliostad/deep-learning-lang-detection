(load-file "d:\\dev\\proj\\Synth.clj")

; Strategy: 
;    Channels 0 and 1 (power hit) for beat.
;    Channels 2 and 3 for melody / harmony.


(Thread/sleep 5000)
(synth-init)

(change-instrument (channel 3) 10)
(change-instrument (channel 2) 9)
(change-instrument (channel 1) 118)
(change-instrument (channel 0) 115)


(def main-beat (fn []
	(play-note (channel 1) 50 160 80)
	(play-notes (channel 0) (list
		[60 80 100 100]
		[63 80 100 100]
		[60 80 90 90]
		[60 80 100 100]
	))
))

(def low-beat (fn []
	(play-note (channel 1) 50 160 80)
	(play-notes (channel 0) (list
		[52 80 100 100]
		[55 80 100 100]
		[52 80 90 90]
		[52 80 100 100]
	))
))

(start-beat (fn []
	(dotimes [i 3]
		(main-beat))
	(low-beat))
	0
	"beat"
)


(defn main-secondary-tune[]
	(.start (new Thread (fn[]
		(play-notes
			(channel 2)
			(list 
				[65 200 195 195]
				[66 200 195 195]
				[67 200 195 195]
				[62 200 195 195]
				[63 200 195 195])
		)
	)))
	(play-notes
		(channel 3)
		(list
			[65 0 195 195]
			[66 0 195 195]
			[67 0 195 195]
			[62 200 195 195]
			[63 0 195 195])
	)
)

(defn second-secondary-tune[]
	(.start (new Thread (fn[]
		(play-notes
			(channel 2)
			(list 
				[67 200 195 195]
				[66 200 195 195]
				[68 200 195 195]
				[69 200 195 195]
				[69 200 195 195])
		)
	)))
	(play-notes
		(channel 3)
		(list
			[67 0 195 195]
			[66 0 195 195]
			[68 0 195 195]
			[69 200 195 195]
			[69 0 195 195])
	)
)

(dotimes [i 4]
	(main-secondary-tune)
	
	;; Mini beat
	(play-note (channel 3) 60 195 195)
	(play-note (channel 2) 60 195 195)
	
	(main-secondary-tune)
	
	;; Mini beat
	(play-note (channel 3) 60 195 195)
	(play-note (channel 2) 60 195 195)
	
	(second-secondary-tune)
	
	;; Mini beat
	
	(main-secondary-tune)

)

(stop-beat "beat")

(dotimes [i 4]
	(play-note (channel 3) 60 100 195)
	(play-note (channel 2) 60 225 195)
	(Thread/sleep 195)
)

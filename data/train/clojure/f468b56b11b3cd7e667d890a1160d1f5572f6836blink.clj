(ns clj-bots.hello-world.blink
  "# The hello world of hardware programming: a blinking LED"
  (:require [clj-bots.pin-ctrl :as pc]
            [clj-bots.pin-ctrl-bbb :as bbb]))

;; First we register the implementation. (Actually, it _should_ be the case that simply requiring the namespace
;; take care of this for us; there's also a way that requiring wouldn't be necessary, but it requires pin-ctrl
;; to have some knowledge of `known-implementations`. This is how `core.matrix` lets you just write something
;; like `(set-default-implementation! :vectorz)` without requiring or anything. Could do the same here, but it
;; needs we need to maintain a similar collection of known implementations.)
(bbb/register-implementation)


;; Next we create a board object. This could be in a var, as we're doing here, or we could use something like
;; Component to manage its lifecycle.
(def board (pc/create-board :bbb))

;; Now let's say we want to initialize pin 14 on header :P8 as a GPIO pin, and use it to control an LED that we'll blink.
;; (We _could_ actually do this as `:P8_14` instead of `[:P8 14]`, but my thought is that the latter is a bit
;; more composable.).
(def pin (pc/get-pin board [:P8 14]))
(pc/set-mode! pin :gpio)

;; Now let's set up the blinking
(def blink-thread
  (future
    (loop []
      (pc/toggle! pin)
      (Thread/sleep 1000)
      (recur))))

;; Yay! Let's bask in the glory for a few seconds and then turn the pin off
(Thread/sleep 10000)
(future-cancel blink-thread)
(pc/set-mode! pin :off)

;; It's also possible to use the board to control pins directly. In fact, the functions which operate on the
;; Pin objects are actually just thin wrappers around the board object. This makes state management a lot
;; cleaner.
(pc/set-mode! board [:P8 14] :gpio)

(def blink-thread2
  (future
    (loop []
      (pc/toggle! board [:P8 14])
      (Thread/sleep 1000)
      (recur))))

(Thread/sleep 10000)
(future-cancel blink-thread2)
(pc/set-mode! board [:P8 14] :off)



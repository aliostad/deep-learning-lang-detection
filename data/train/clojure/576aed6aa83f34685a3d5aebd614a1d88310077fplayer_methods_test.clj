;    Copyright (C) 2017  Joseph Fosco. All Rights Reserved
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.

(ns transit.player.player-methods-test
  (:use clojure.test
        transit.player.player-methods
        )
  )

(deftest test-remove-methods
  (testing "removes methods from player"
    (let [method1 (create-method-info select-instrument-for-player 10)
          method2 (create-method-info select-key 1)
          method3 (create-method-info select-scale 1)
          method4 (create-method-info select-instrument-for-player 1)
          method5 (create-method-info play-random 1)
          ]
        (is (=
             {:id 1
              :methods [method2 method3 method5]
              }
             (remove-methods {:id 1
                              :methods [method1
                                        method2
                                        method3
                                        method4
                                        method5
                                        ]}
                             select-instrument-for-player
                             select-mm
                             )
             )
            ))
    )
  )

(deftest test-add-methods
  (testing "adds methods to player"
    (let [method1 (create-method-info play-random 1)
          method2 (create-method-info select-key 1)
          method3 (create-method-info select-scale 1)
          orig-methods [method1 method2 method3]
          updated-methods (add-methods orig-methods
                                       select-instrument-for-player 2
                                       select-mm 2
                                       select-scale 3
                                       )
          ]
      (is (= 6 (count updated-methods)))
      (is (= orig-methods (take 3 updated-methods)))
      (is (= (for [mthd updated-methods] (:method mthd))
             (list play-random
              select-key
              select-scale
              select-instrument-for-player
              select-mm
              select-scale))
          )
      (is (= (for [mthd updated-methods] (:weight mthd)) '(1 1 1 2 2 3))
          )
      ))
  )

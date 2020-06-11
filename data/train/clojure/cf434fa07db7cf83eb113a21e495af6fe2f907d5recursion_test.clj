(ns spikes.functional-programming.recursion-test
  (:use midje.sweet))

(facts "thinking recursively 7.3"
       ;; recursion is often viewed as an operation when solutions
       ;; involving high-order function are not satisfactory
       (fact "mundane recursion 7.3"
             ;; the power function
             (defn pow [base exp]
               (if (zero? exp)
                 1
                 (* base (pow base (dec exp)))))
             (pow 2 10) => 1024
             (pow 1.01 925) => 9937.353723241924
             ;; mundane: because it is named explicily. Problem:
             ;; StackOverflow error: (pow 2 10000)
             (pow 2 10) => (* 2 (pow 2 9))
             (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (pow 2 0))))))))))) => (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 (* 2 1))))))))))
             ;; each multplication is a recursive caal in the java
             ;; stack

             ;; a solution using tail recursion with recur and an
             ;; accumulator
             (defn pow [base exp]
               (letfn [(kapow [base exp acc]
                         (if (zero? exp)
                           acc
                                        ; here exp is used as a decrement counter
                                        ; and acc as an intermediate result
                           (recur base (dec exp) (* base acc))))] ; recur in tail position 
                 (kapow base exp 1)))
             (pow 2 10) => 1024
                                        ; (kapow 2 10 1)
                                        ; (kapow 2 9 (* 2 1))
                                        ; (kapow 2 8 (* 2 2))
                                        ; (kapow 2 7 (* 2 4))
                                        ; ...
                                        ; (kapow 2 0 1024)
                                        ; using tail recursion optimization
             (pow 2N 10000N) => 19950631168807583848837421626835850838234968318861924548520089498529438830221946631919961684036194597899331129423209124271556491349413781117593785932096323957855730046793794526765246551266059895520550086918193311542508608460618104685509074866089624888090489894838009253941633257850621568309473902556912388065225096643874441046759871626985453222868538161694315775629640762836880760732228535091641476183956381458969463899410840960536267821064621427333394036525565649530603142680234969400335934316651459297773279665775606172582031407994198179607378245683762280037302885487251900834464581454650557929601414833921615734588139257095379769119277800826957735674444123062018757836325502728323789270710373802866393031428133241401624195671690574061419654342324638801248856147305207431992259611796250130992860241708340807605932320161268492288496255841312844061536738951487114256315111089745514203313820202931640957596464756010405845841566072044962867016515061920631004186422275908670900574606417856951911456055068251250406007519842261898059237118054444788072906395242548339221982707404473162376760846613033778706039803413197133493654622700563169937455508241780972810983291314403571877524768509857276937926433221599399876886660808368837838027643282775172273657572744784112294389733810861607423253291974813120197604178281965697475898164531258434135959862784130128185406283476649088690521047580882615823961985770122407044330583075869039319604603404973156583208672105913300903752823415539745394397715257455290510212310947321610753474825740775273986348298498340756937955646638621874569499279016572103701364433135817214311791398222983845847334440270964182851005072927748364550578634501100852987812389473928699540834346158807043959118985815145779177143619698728131459483783202081474982171858011389071228250905826817436220577475921417653715687725614904582904992461028630081535583308130101987675856234343538955409175623400844887526162643568648833519463720377293240094456246923254350400678027273837755376406726898636241037491410966718557050759098100246789880178271925953381282421954028302759408448955014676668389697996886241636313376393903373455801407636741877711055384225739499110186468219696581651485130494222369947714763069155468217682876200362777257723781365331611196811280792669481887201298643660768551639860534602297871557517947385246369446923087894265948217008051120322365496288169035739121368338393591756418733850510970271613915439590991598154654417336311656936031122249937969999226781732358023111862644575299135758175008199839236284615249881088960232244362173771618086357015468484058622329792853875623486556440536962622018963571028812361567512543338303270029097668650568557157505516727518899194129711337690149916181315171544007728650573189557450920330185304847113818315407324053319038462084036421763703911550639789000742853672196280903477974533320468368795868580237952218629120080742819551317948157624448298518461509704888027274721574688131594750409732115080498190455803416826949787141316063210686391511681774304792596709376N

             ;; lazy sequences are a better choice than tail recursion
             ;; because mundane recursion are often more
             ;; understandable
             (defn lz-rec-step [s]
               (lazy-seq
                (if (seq s)
                  [(first s) (lz-rec-step (rest s))]
                  [])))
             (first (lz-rec-step (range 200000))) => 0
             )
       (facts "tail calls and recur 7.3.2"
              ;; JVM does not provide generalized tail call
              ;; optimization
              (fact "tail recursion"
                    ;; greatest common denominator
                    (defn gcd [x y]
                      (cond
                       (> x y) (gcd (- x y) y)
                       (< x y) (gcd x (- y x))
                       :else x))
                    (gcd 12 27) => (gcd 12 15) 
                    (gcd 12 3) => (gcd 9 3) 
                    (gcd 6 3) => (gcd 3 3) 
                    ;; mundane recursion: stack overflow problem
                                        ; (gcd 6578436758436578439265784392
                                        ; 67548392657489326578432965784392)
                    
                    ;; tail position recursion
                    (defn gcd [x y]
                      (cond
                       (> x y) (recur  (- x y) y)
                       (< x y) (recur x (- y x))
                       :else x))
                    (gcd 6578436758436578439265784392 67548392657489326578432965784392) => 8

                    ;; no tail position error
                                        ; (defn gcd [x y]
                                        ; (int
                                        ; (cond
                                        ; (> x y) (recur  (- x y) y)
                                        ; (< x y) (recur x (- y x))
                                        ; :else x
                                        ; )))
                    )
              )
       
       (facts "don't forget your trampoline 7.3.3"
              ;; Mutually recursive functions are nice for
              ;; implementing finite state machines (FSA)
              (defn elevator [commands]
                (letfn
                    [(ff-open [[cmd & r]]
                       "When the elevator is open on the first floor
                        it can either be close or be done."
                       #(case cmd
                          :close (ff-closed r)
                          :done true
                          false))
                     (ff-closed [[cmd & r]]
                       "when the elevator is closed on the first floor
                       it can either be open or go up."
                       #(case cmd
                          :open (ff-open r)
                          :up (sf-closed r)
                          false))
                     (sf-closed [[cmd & r]]
                       "When se elevator is closed on the second floor
                        it can either be open or go down."
                       #(case cmd
                          :down (ff-closed r)
                          :open (sf-open r)
                          false))
                     (sf-open [[cmd & r]]
                       "When the elevator is open on the second floor
                        it can either close or be done."
                       #(case cmd
                          :close (sf-closed r)
                          :done true
                          false))]
                  (trampoline ff-open commands)))
              ;; the trampoline function can manage the stack on the
              ;; mutually recursive calls, thus avoiding cases where
              ;; a long schedule would blow the stack.
              ;; Make all of the functions participating in the mutual
              ;; recursion return a function instead of their normal
              ;; result. Normally this is as simple as tacking a #
              ;; onto the front of the outer level of the function
              ;; body.              
              ;; Invoke the first function in the mutual chain via the
              ;; trampoline function.
              
              (elevator [:close :open :close :up :open :open :done]) => false
              (elevator [:close :up :open :close :down :open :done]) => true
              ;; run at your own risk!
                                        ;(elevator (cycle [:close :open])) ; ... runs forever
              )
       (facts "continuation passing style (CPS) 7.3.4"
              ;; an hybrid between recursion and mutual recursion,
              ;; It’s a way of generalizing a computation in terms of
              ;; up to three functions:
              ;; An accept function that decides when a computation
              ;; should terminate
              ;; A return continuation that’s used to wrap the return
              ;; values
              ;; A continuation function used to provide the next step
              ;; in the computation
              (defn fac-cps [n k]
                (letfn [
                        (cont [v]
                          (k (* v n)))]
                  (if (zero? n)
                    (k 1)
                    (recur (dec n) cont))))
              (defn fac [n]
                (fac-cps n identity))
              (fac 10) => 3628800
              (* (* (* (* (* (* (* (* (* 1 2) 3) 4) 5) 6) 7) 8) 9) 10) => 3628800

              ;; Continuation-passing style function generator
              (defn mk-cps [accept? end-value kend knot]
                (fn [n]
                  ((fn [n k]
                     (let
                         [cont (fn [v] (k (knot v n)))]
                       (if (accept? n)
                         (k end-value)
                         (recur (dec n) cont))))
                   n kend)))

              (def fac (mk-cps zero? 1 identity #(* %1 %2)))
              (fac 10) => 3628800
              (def tri (mk-cps zero? 1 dec #(+ %1 %2)))
              (tri 10) => 55
              )
       )

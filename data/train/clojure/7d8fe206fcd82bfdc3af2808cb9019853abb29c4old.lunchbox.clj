(ns lunchbox
  (:use clojure.set))

(declare generate-code)

;
; [:func 'print [:builtin 'print]]
; [:call 'print [:+ 10 5]]
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; EMIT ASSEMBLY CODE
;

(defmulti emit (fn [a & b] a))
(defmethod emit 'print [_]
  "
    mov     ecx, [esp + 8]  ; string to write
    mov     edx, [esp + 4]  ; string length
    mov     ebx, 1
    mov     eax, 4
    int     0x80")

(defmethod emit '+ [_ a b]
  (str "
    add     " a ", " b))

(defmethod emit 'push [_ val]
  (str "
    push    " val))

(defmethod emit 'pop [_ val]
  (str "
    pop     " val))

(defmethod emit '+ [_ s d]
  (str "
    add     " d ", " s))

(defmethod emit '- [_ s d]
  (str "
    sub     " d ", " s))

(defmethod emit '* [_ s d]
  (str "
    mul     " d ", " s))

(defmethod emit '/ [_ s d]
  (str "
    div     " d ", " s))

(defmethod emit 'set [_ r v]
  (str "
    mov     " r ", " v))

(defmethod emit 'mov [_ s d]
  (str "
    mov     " d ", " s))

(defmethod emit 'func-prolog [_ name]
  (str "
__func__" name ":
    mov     esi, esp ; Store call stack
    mov     esp, ebp ; Use data stack"))

(defmethod emit 'func-epilog [_]
  (str "
    mov     ebp, esp ; Store data stack
    mov     esp, esi ; Use call stack
    ret"))

(defmethod emit 'call-prolog [_]
  (str "
    mov     ebp, esp ; Store data stack
    mov     esp, esi ; Use call stack"))

(defmethod emit 'call-epilog [_]
  (str "
    mov     esi, esp ; Store call stack
    mov     esp, ebp ; Use data stack"))

(defmethod emit 'call [_ name]
  (str "
    call    " name))

(defmethod emit 'start [_]
  (str "
section	.text
    global _start    ; must be declared for linker (ld)
_start:              ; tell linker entry point
    mov esi, [__builtin__call_stack] ; Initialise call stack"))

(defmethod emit 'end [_]
  (str "
    ; Terminate.
    mov     eax,1    ; system call number (sys_exit)
    int     0x80     ; call kernel
    
__builtin__call_stack resb 1024 ; 256 calls deep
    "))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MANAGE REGISTERS
;

(def registers #{'eax 'ebx 'ecx 'edx})

(defn new-reg [reglist]
  "Get an unused register, spilling to the stack if needed"
  (let [new (first (difference registers reglist))]
    (if (= nil new)
      (let [v (vec reglist)
            reg (peek v)]
        (list (emit 'push reg)
              (cons reg (seq (pop v)))))
      (list "" (cons new reglist)))))

(defn get-reg ([reglist omit]
  "Get next used register, taking from the stack if needed"
  (let [omit-set (set omit)
        reg (first (if omit
                     (filter #(= (omit-set %) nil) reglist)
                     reglist))]
    (if (= nil reg)
      (let [result (new-reg reglist)
            regs (second result)
            reg  (first regs)]
        (list (emit 'pop reg)
              reg
              (if omit
                (cons (frest regs)
                      (cons reg (rrest regs)))
                regs)))
      (list "" reg reglist))))
  ([reglist] (get-reg reglist nil)))

(defn release-reg [reglist]
  "Release next register"
  (rest reglist))

(defn flush-reg [reglist]
  "Flush registers to stack"
  (reduce #(str (emit 'push %2) %1) (cons "" reglist)))

(defn dup-reg [reglist]
  (let [result (get-reg reglist)]
    (list (first result)
          (cons (second result)
                (second (rest result))))))

(defn swap-reg [reglist]
  (let [[out1 first-reg  regs] (get-reg reglist)
        [out2 second-reg regs] (get-reg regs (list first-reg))]
    (list (str out1 out2)
          (cons second-reg (cons first-reg (drop 2 regs))))))

(defn drop-reg [reglist]
  (if (= (first reglist) nil)
    (list (emit 'pop nil) '())
    (list "" (release-reg reglist))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MANAGE INSTRUCTIONS
;

(defstruct environ  :funcmap)
(defstruct function :inlined :body)

(defmulti instruction (fn [a & b] a))
(defmethod instruction :binop [_ op reglist _]
  (let [[out1 source1 regs] (get-reg reglist)
        [out2 source2 regs] (get-reg regs (list source1))
        [out3 regs]         (swap-reg regs)
        [out4 regs]         (new-reg (release-reg regs))
        dest (first regs)
        regs (cons dest (drop 2 regs))]
    (list (str out1 out2 out3 out4
               (if (= source2 dest)
                 ""
                 (emit 'mov source2 dest))
               (emit op source1 dest))
          regs)))

(defmethod instruction :push [_ val reglist _]
  (let [[output regs] (new-reg reglist)]
    (list (str output
               (emit 'set (first regs) val))
          regs)))

(defmethod instruction :stack [_ op reglist _]
  (cond (= op 'dup)  (dup-reg  reglist)
        (= op 'swap) (swap-reg reglist)
        (= op 'drop) (drop-reg reglist)))

(defmethod instruction :function [_ defin reglist env]
  (let [name (first defin)
        body (rest defin)
        allowed-for-inline #{:binop :push :pop :stack :call}]
    (list
      ""
      reglist
      (conj env {:funcmap
                 (conj (:funcmap env)
                       (if (and (every? #(allowed-for-inline (first %)) body)
                                (> 25 (count body)))
                         ; Function gets inlined
                         {name (struct function true body)}
                         ; Function does not get inlined
                         (let [func (generate-code body '() env)]
                           {name (struct function false
                                         (str (emit 'func-prolog name)
                                          (first func)
                                          (flush-reg (second func))
                                          (emit 'func-epilog)))})))}))))

(defmethod instruction :call [_ name reglist env]
  (let [func ((:funcmap env) name)]
      (if (:inlined func)
        (generate-code (:body func) reglist env)
        (list (str
                (flush-reg reglist)
                (emit 'call-prolog)
                (emit 'call name)
                (emit 'call-epilog))
              '()))))

(defmethod instruction :flush [_ _ reglist _]
  (list (flush-reg reglist) '()))

(defmethod instruction :builtin [_ op reglist _]
  (when (#{'start 'end} op)
    (list (emit op) reglist)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CODE GENERATOR
;

(defn generate-code ([code rl e]
  (loop [reglist rl
         env    e
         output  ""
         head    (first code)
         tail    (rest code)]
    (if (= head nil)
      (list output
            reglist
            env)
      (let [result (instruction (first head)  ; Instruction type
                                (second head) ; Operation
                                reglist
                                env)
            new-env (second (rest result))]
        (recur (second result)
               (if new-env new-env env)
               (str output
                    (first result))
               (first tail)
               (rest tail))))))
  ([code] (generate-code code '() (struct environ {}))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(let [result (generate-code (concat (with-in-str (slurp (first *command-line-args*)) (read))
                                    '([:builtin start] [:call main] [:builtin end])))
      output (first result)
      env    (last result)]
  (println (str
             output
             (apply str "" (map #(:body (second %)) 
                             (filter #(not (:inlined (second %)))
                                     (:funcmap env)))))))


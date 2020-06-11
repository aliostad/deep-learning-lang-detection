(ns clarkdown.lexer)

(defn add-result-and-move-position
  ([state
    result]
     (add-result-and-move-position state result 1))
  ([state
     result
    move-by]
     (loop [state state
            result result
            move-by move-by]
       (if (= 1 move-by)
         (update-in (update-in state [:results] #(conj % result)) 
                    [:input-stream]
                    rest)
         (recur (update-in state [:input-stream] rest) result (dec move-by))))))

(defn get-text 
  [{:keys [input-stream
            results] :as state}]
  (add-result-and-move-position state (first input-stream)))

(defn try-char
  [char
   token
   {:keys [input-stream
            results] :as state}]
  (let [next-char (first input-stream)]
    (when (= next-char char) 
      (add-result-and-move-position state token))))


(defn try-star
  [state]
  (try-char \* :STAR state))

(defn try-underscore
  [state]
  (try-char \_ :UNDERSCORE state))

(defn try-octothorpe
  [state]
  (try-char \# :OCTOTHORPE state))

(defn try-newline
  [{:keys [input-stream
            results] :as state}]
  (let [next-char (first input-stream)
        next-next-char (second input-stream)]
    (cond
     (and (= next-char \return) (= next-next-char \newline)) (add-result-and-move-position state :NEWLINE 2)
     (= next-char \newline) (add-result-and-move-position state :NEWLINE)
     (= next-char \return) (add-result-and-move-position state :NEWLINE))))


(defn get-token
  [state]
  (or
   (try-star state)
   (try-newline state)
   (get-text state)))

(defn analyze-stream
  [state]
  (loop [{:keys [input-stream
                 results]} state]
    (cond
     (empty? input-stream) results
     :else (recur (get-token state)))))

(defn lex
  [input-stream]
  (analyze-stream {:input-stream input-stream :results []}))

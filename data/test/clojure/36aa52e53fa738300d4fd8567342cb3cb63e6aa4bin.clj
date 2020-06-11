(ns lab-2.core)

(import '(java.io DataInputStream)
        '(java.io FileInputStream)
        '(java.io DataOutputStream)
        '(java.io FileOutputStream))

(defn- third [coll]
  (nth coll 2))

(defn- maketuplesf [n]
  (fn [lst] (map (partial take n)
       (take-while (complement empty?)
                   (iterate (partial drop n)
                            lst)))))

(def makepairs (maketuplesf 2))

(defn- readBin [filename]
  (let
    [filestream (FileInputStream. filename)
     stream (DataInputStream. filestream)

     usernum (. stream readInt)
     relationnum (. stream readInt)
     votesnum (. stream readInt)
     users (repeatedly relationnum #(list (. stream readInt)
                                          (. stream readInt)))
     votes (repeatedly votesnum #(list (. stream readInt)
                                       (. stream readInt)))]
    (flatten
      (list
        usernum
        relationnum
        votesnum
        users
        votes))))

(defn- writeBin [bytes filename]
  (let [filestream (FileOutputStream. filename)
        stream (DataOutputStream. filestream)]
    (dorun (map #(. stream writeInt %) bytes))))

(defn- processBinData [bindata]
  (let [usernum (first bindata)
        relationnum (second bindata)
        votesnum (third bindata)
        bindata (drop 3 bindata)
        data {:usernum usernum
              :relationnum relationnum
              :votesnum votesnum
              :users (vec (repeat usernum nil))
              :votes (vec (repeat votesnum nil))}]
    ((println (makepairs bindata))
    (map
      (fn [pair]
        (let [from (first pair)
              to (second pair)]
          (def data (assoc data :votes
                      (assoc
                        (assoc (data :votes) from to)
                                             to from)))))
      (makepairs bindata))
    data)))

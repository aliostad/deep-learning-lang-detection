(ns utlc.stream
  (:use [utlc.numericalcomputation]
        [utlc.number]
        [utlc.list]
        [utlc.boolean]
        [utlc.fizzbuzz]))

;;在utlc中数据与数据结构都是逻辑意义上的 通俗的讲都是代码并不是一般概念上的数字 所以类似于函数可以递归地定义自己调用自己 LC中的数据也可以动态地计算自身的值 从而实现一个无穷的流

(def ZEROS
  (Z (fn [f]
       ((UNSHIFT f) ZERO))))

(to-integer (FIRST ZEROS))
(to-integer (FIRST (FIRST ZEROS)))
(to-integer (FIRST (FIRST (FIRST ZEROS))))

;;创建了由ZERO组成的无限数据流

;;实现惰性序列中的take操作

(defn stream-take
  ([lst]
   (stream-take lst nil))
  ([lst count]
   (if (or (to-boolean (IS_EMPTY lst)) (zero? count))
     []
     (cons (FIRST lst) (stream-take (REST lst) (if (nil? count)
                                                 count
                                                 (dec count)))))))

(map to-integer (stream-take ZEROS 5))
(map to-integer (stream-take ZEROS 10))
(map to-integer (stream-take ZEROS 20))

;;实现一个stream 其中每一个元素都是前一个元素的后继值

(def UPWARDS_OF
  (Z (fn [f]
       (fn [n]
         ((UNSHIFT (fn [x]
                     ((f (INCREMENT n)) x))) n)))))

(map to-integer (stream-take (UPWARDS_OF ZERO) 5))
(map to-integer (stream-take (UPWARDS_OF FIFTEEN) 20))

;;包含一个给定数字所有倍数的无限流

(def MULTIPLES_OF
  (fn [m]
    ((Z (fn [f]
          (fn [n]
            ((UNSHIFT (fn [x]
                        ((f ((ADD m) n)) x))) n)))) m)))

(map to-integer (stream-take (MULTIPLES_OF TWO) 10))
(map to-integer (stream-take (MULTIPLES_OF FIVE) 20))

;;可以利用列表操作来操作这些无限流 映射上一个lambda操作 从而产生一个新的无限流

(map to-integer (stream-take (MULTIPLES_OF THREE) 10))
(map to-integer (stream-take ((MAP (MULTIPLES_OF THREE)) INCREMENT) 10))
(map to-integer (stream-take ((MAP (MULTIPLES_OF THREE)) (MULTIPLY TWO)) 10))

;;甚至可以像操作组合子一样将两个无限流comp为一个无限流

(def MULTIPLY_STREAMS
  (Z (fn [f]
       (fn [k]
         (fn [l]
           ((UNSHIFT (fn [x]
                       (((f (REST k)) (REST l)) x)))
             ((MULTIPLY (FIRST k)) (FIRST l))))))))

(map to-integer (stream-take ((MULTIPLY_STREAMS (UPWARDS_OF ONE)) (MULTIPLES_OF THREE)) 10))

;;上面这种组合无限流的方式 就是将两个无限流对应位置的元素相乘 得到的新元素为组合后的新无限流对应位置的元素
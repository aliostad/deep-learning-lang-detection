;; Rounding errors
;; ---------------------------------------------------------------------------------------------------------------------
;; Of course, Clojure provides a decimal type that's boundless relative to your computer memory, so why wouldn't you use
;; that? In short, you can, but decimal operations can be easily corrupted -- especially when you're working with
;; existing Java libraries, taking and returning primitive types. Additionally, in the case of Java, its underlying
;; BigDecimal class is finite in that it uses a 32-bit integer to represent the number of digits to the right of the
;; decimal place. This can represent an extremely large range of values perfectly, but it's still subject to error:
1.0E-430000000M
;;=> 1.0E-430000000M

1.0E-4300000000M
;;=> NumberFormatException  java.math.BigDecimal.<init> (BigDecimal.java:511)

;; Even if you manage to ensure that your BigDecimal values are free from floating-point corruption, you can never
;; protect them from themselves. At some point, a floating-point calculation will encounter a number such as 2/3 that
;; always requires rounding, leading to subtle yet propagating errors. Finally, floating-point arithmetic is neither
;; associative nor distributive, which may lead to the shocking result that many floating-point calculations are
;; dependent on the order in which they're carried out:
(def a  1.0e50)
(def b -1.0e50)
(def c 17.0e00)

;; Associativity should guarantee 17.0 for both
(+ (+ a b) c)
;;=> 17.0

(+ a (+ b c))
;;=> 0.0

;; As shown, by selectively wrapping parentheses, we've changed the order of operations and, amazingly, changed the
;; answer! Therefore, for absolutely precise calculations, rationals are the best choice. Aside from the rational data
;; type, Clojure provides functions that can help maintain your sanity: ratio?, rational?, and rationalize. Taking apart
;; rationals is also a trivial matter. The best way to ensure that your calculations remain as accurate as possible is
;; to do them all using rational numbers. As shown next, the shocking results from using floating-point numbers have
;; been eliminated:
(def a (rationalize 1.0e50))
(def b (rationalize -1.0e50))
(def c (rationalize 17.0e00))

;; Associativity preserved
(+ (+ a b) c)
;;=> 17N

(+ a (+ b c))
;;=> 17N

;; You can use rational? to check whether a given number is a rational and then use rationalize to convert it to one.
;; There are a few rules of thumb to remember if you want to maintain perfect accuracy in your computations:
;; * Never use Java math libraries unless they return results of BigDecimal, and even then be suspicious.
;; * Don't rationalize values that are Java float or double primitives.
;; * If you must write your own high-precision calculations, do so with rationals.
;; * Only convert to a floating-point representation as a last resort.

;; Finally, you can extract the constituent parts of a rational using the numerator and denominator functions:
(numerator (/ 123 10))
;;=> 123

(denominator (/ 123 10))
;;=> 10

;; You might never need perfect accuracy in your calculations. When you do, Clojure provides tools for maintaining
;; sanity, but the responsibility to maintain rigor lies with you. Like any programming language feature, Clojure's
;; rational type has its share of trade-offs. The calculation of rational math, although accurate, isn't nearly as fast
;; as with floats or doubles. Each operation in rational math has an overhead cost (such as finding the least common
;; denominator) that should be accounted for. It does you no good to use rational operations if speed is a greater
;; concern than accuracy.

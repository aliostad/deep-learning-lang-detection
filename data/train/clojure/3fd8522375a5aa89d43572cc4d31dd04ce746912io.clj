;the whole material is from http://www.blogjava.net/killme2008/archive/2012/02/16/370144.html by 庄周蝶梦
(ns language.io
  (:require [clojure.java.io :as io]))

;obtain a java.io.File object

(def f (io/file "D:/data/big.txt"))

;copy file

(io/copy f (io/file "D:/data/b.txt"))

;copy is a tolerant function,

;it accepts InputStream Reader File byte[] or String as input
;it accepts OutputStream Writer File as io/output
;this is realized by clojure's protocol and defmulti

;但是，copy并不帮你处理文件的关闭问题，
;假设你传入的input是一个File，output也是一个File，copy会自动帮你打开InputStream和OutputStream并建立缓冲区做拷贝，
;但是它不会帮你关闭这两个流，因此你要小心，如果你经常使用copy，这可能是个内存泄漏的隐患。

;delete-file calls File.delete

(io/delete-file (io/file "D:/data/b.txt"))

;if file does not exist, this will throw an exception, to make it quiet, add this:

(io/delete-file (io/file "D:/data/afasfjalf.txt") true)

;more commonly used reader and writer

(def rdr (io/reader "D:/data/big.txt" :encoding "utf-8"))

(def wtr (io/writer "D:/data/b.txt" :append true))

;copy accepts many types of parameters

(io/copy rdr wtr :buffer-size 4096)


;close files

(.close wtr)
(.close rdr)

;judge if file exists

(.exists (io/file "D:/data/big.txt"))
(.exists (io/file "D:/data/hehhehehe.txt"))

;更常用的，我们一般都是用reader和writer函数来打开一个BufferedReader和BufferedWriter做读写，
;同样reader和writer也可以接受多种多样的参数类型，甚至包括Socket也可以。
;因为writer打开的通常是一个BufferedWriter，所以你如果用它写文件，有时候发现write之后文件还是没有内容，
;这是因为数据暂时写到了缓冲区里，没有刷入到磁盘，可以明确地调用(.flush wtr)来强制写入；或者在wtr关闭后系统帮你写入。
;reader和writer还可以传入一些配置项，如:encoding指定读写的字符串编码，writer可以指定是否为append模式等。

;Clojure并没有提供关闭文件的函数或者宏，你简单地调用close方法即可。
;clojure.java.io的设计很有原则，它不准备将java.io都封装一遍，而是提供一些最常用方法的简便wrapper供你使用。

;although copy will not close the document flow for you, we can utilize with-open to manage the flow

(with-open [rdr (io/reader "D:/data/big.txt")
            wtr (io/writer "D:/data/b.txt")]
  (io/copy rdr wtr))

;with-open宏会自动帮你关闭在binding vector里打开的流，
;你不再需要自己调用close，也不用担心不小心造成内存泄漏。
;因此我会推荐你尽量用reader和writer结合with-open来做文件操作，而不要使用file函数。
;file函数应该用在一些判断是否存在，判断文件是否为目录等操作上。


;slurp & spit

;在clojure.core里，还有两个最常用的函数slurp和spit，
;一个吃，一个吐，也就是slurp读文件，而spit写文件，
;他们类似Ruby的File里的read和write，用来完整地读或者写文件
;slurp 接受 :encoding 指定字符串编码
;spit 接受 :append 和 :encoding，将content转化为字符串写入文件

(spit "D:/data/c.txt" "hello world!")

;;;;;;;;;;;;;;;;十颗星重要！读取文件序列！！！！！！！！！！！！！
;返回深度优先顺序遍历的目录列表，且是一个LazySeq

(file-seq (java.io.File. "."))


(with-open [rdr (io/reader "D:/data/big.txt")]
  (doall (line-seq rdr)))

(line-seq (io/reader "D:/data/big.txt"))


(with-open [rdr (clojure.java.io/reader "D:/data/")]
         (count (line-seq rdr)))

;I don't know if the following is correct.

(defn safe-line-seq
  "Similar to line-seq, add a .close at the end."
  [file]
  (let [in-file (io/reader file)
        lazy (fn lazy [wrapped]
             (lazy-seq
              (if-let [line (.readLine wrapped)]
                (cons line (lazy-seq (lazy wrapped)))
                (.close in-file))))]
    (lazy in-file)))



(safe-line-seq "D:/data/big.txt")
(line-seq (io/reader "D:/data/big.txt"))


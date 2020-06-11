(ns foobar.classloader
  (:import [javassist ClassPool CtClass CtMethod CtNewMethod CtField
            LoaderClassPath])
  (:gen-class
   :name   foobar.classloader.CodeqClassLoader
   :extends java.net.URLClassLoader
   :exposes-methods {findClass superfindClass
                     defineClass superdefineClass}))

(def analyze-src "{ clojure.lang.Compiler$Expr expr = analyze$impl($1, $2, $3); expr.getClass().getDeclaredField(\"orig_form\").set(expr, $2); return expr; }")

(def field-src "public java.lang.Object orig_form;")

(defn instrument-class-expr [name loader]
  (let [pool (ClassPool/getDefault)
        loader-cp (LoaderClassPath. loader)
        _ (.insertClassPath pool loader-cp)
        ct-class (.get pool name)]
    (when-not (.isInterface ct-class)
      (.addField ct-class (CtField/make field-src ct-class))
      (.toBytecode ct-class))))

(defn instrument-class-compiler [loader]
  (let [pool (ClassPool/getDefault)
        loader-cp (LoaderClassPath. loader)
        _ (.insertClassPath pool loader-cp)
        ct-class (.get pool "clojure.lang.Compiler")
        analyze-params (into-array (map #(.get pool %)
                                        ["clojure.lang.Compiler$C"
                                         "java.lang.Object"
                                         "java.lang.String"]))
        mold (.getDeclaredMethod ct-class "analyze" analyze-params)
        mnew (CtNewMethod/copy mold "analyze" ct-class nil)]
    (.setName mold "analyze$impl")
    (.setBody mnew analyze-src)
    (.addMethod ct-class mnew)
    (.toBytecode ct-class)))

(defn -findClass [this name]
  (cond (= name "clojure.lang.Compiler")
        (let [b (instrument-class-compiler this)]
          (.superdefineClass this name b 0 (alength b)))
        (.startsWith name "clojure.lang.Compiler$")
        (let [b (instrument-class-expr name this)]
          (if b
            (.superdefineClass this name b 0 (alength b))
            (.superfindClass this name)))
        :else (.superfindClass this name)))

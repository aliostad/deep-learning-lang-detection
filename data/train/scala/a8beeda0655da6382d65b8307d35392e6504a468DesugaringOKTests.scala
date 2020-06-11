package l3.test.ok
import org.junit.Test

trait DesugaringOKTests {
  this: AllOKTests =>

  @Test def testDesugaringBegin =
    compileAndInterpret("""
      (begin
        (@byte-write (@char->int 'O'))
        (@byte-write (@char->int 'K'))
        (@byte-write 10)
      )
    """)

  @Test def testDesugaringCond =
    compileAndInterpret("""
      (cond ((@= 1 2) (@byte-write (@char->int '*')))
            ((@= 1 1) (@byte-write (@char->int 'O')))
            ((@= 1 1) (@byte-write (@char->int '*')))
      )

      (cond ((@= 1 1) (@byte-write (@char->int 'K')))
            ((@= 1 2) (@byte-write (@char->int '*')))
            ((@= 1 2) (@byte-write (@char->int '*')))
      )

      (cond ((@< 1 1) (@byte-write (@char->int '*')))
            ((@< 1 0) (@byte-write (@char->int '*')))
            ((@= 1 1) (@byte-write 10))
      )
    """)

  @Test def testDesugaringIf =
    compileAndInterpret("""
      (@byte-write (@char->int (if (@unit? (if #f 1)) 'O' 'K')))
      (@byte-write (@char->int (if (@unit? (if #t 1)) 'O' 'K')))
      (@byte-write 10)
    """)

  @Test def testDesugaringLets =
    compileAndInterpret("""
      (let* ((K1 'K')
             (O1 'O')
             (O O1)
             (K K1))
        (@byte-write (@char->int O))
        (@byte-write (@char->int K))
        (@byte-write 10)
      )
    """)

  @Test def testDesugaringRec =
    compileAndInterpret("""
      (def ok-str
           (fun (i)
                (cond ((@= i 0) 'O')
                      ((@= i 1) 'K')
                      ((@= i 2) (@int->char 10))
                )
           )
      )

      (rec loop ((i 0))
           (if (@<= i 2)
               (begin
                 (@byte-write (@char->int (ok-str i)))
                 (loop (@+ i 1)))))
    """)

  @Test def testDesugaringStrings =
    compileAndInterpret("""
      (def ok-str "OK")
      (@byte-write (@char->int (@block-get ok-str 0)))
      (@byte-write (@char->int (@block-get ok-str 1)))
      (@byte-write 10)
    """)
}

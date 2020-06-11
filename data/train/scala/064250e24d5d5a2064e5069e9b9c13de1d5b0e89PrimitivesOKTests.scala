package l3.test.ok
import org.junit.Test

trait PrimitivesOKTests {
  this: AllOKTests =>

  @Test def testPrimitiveArithmetic1 =
    compileAndInterpret("""
      (@byte-write (@+ 1 78))
      (@byte-write (@+ 6 69))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic2 =
    compileAndInterpret("""
      (@byte-write (@- 80 1))
      (@byte-write (@- 85 10))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic3 =
    compileAndInterpret("""
      (@byte-write (@+ (@* 2 (@* 3 13)) 1))
      (@byte-write (@* (@* 3 5) 5))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic4 =
    compileAndInterpret("""
      (@byte-write (@/ 158 2))
      (@byte-write (@/ 147976 1973))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic5 =
    compileAndInterpret("""
      (@byte-write (@% 159 80))
      (@byte-write (@% 3075 1000))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic6 =
    compileAndInterpret("""
      (@byte-write (@- (@<< 5 4) 1))
      (@byte-write (@+ (@<< 37 1) 1))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic7 =
    compileAndInterpret("""
      (@byte-write (@>> 1264 4))
      (@byte-write (@>> 150 1))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic8 =
    compileAndInterpret("""
      (@byte-write (@& 65535 79))
      (@byte-write (@& 91 111))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic9 =
    compileAndInterpret("""
      (@byte-write (@| 0 79))
      (@byte-write (@| 72 67))
      (@byte-write 10)
    """)

  @Test def testPrimitiveArithmetic10 =
    compileAndInterpret("""
      (@byte-write (@^ 127 48))
      (@byte-write (@^ 101 46))
      (@byte-write 10)
    """)

  @Test def testPrimitiveBlocks1 =
    compileAndInterpret("""
      (def nl (@int->char 10))
      (let ((v "OK"))
        (@byte-write (@char->int (if (@block? v) 'O' 'K')))
        (@byte-write (@char->int (if (@block? 1) 'O' 'K')))
        (@byte-write (@char->int nl))
      )
    """)

  @Test def testPrimitiveBlocks2 =
    compileAndInterpret("""
      (def nl (@int->char 10))
      (let ((v "OK"))
        (@byte-write (@char->int (@block-get v 0)))
        (@byte-write (@char->int (@block-get v 1)))
        (@byte-write (@char->int nl))
      )
    """)

  @Test def testPrimitiveBlocks3 =
    compileAndInterpret("""
      (def nl (@int->char 10))
      (let ((v "OK"))
        (@block-set! v 0 'K')
        (@block-set! v 1 'O')
        (@byte-write (@char->int (@block-get v 1)))
        (@byte-write (@char->int (@block-get v 0)))
        (@byte-write (@char->int nl))
      )
    """)

  @Test def testPrimitiveBlocks4 =
    compileAndInterpret("""
      (def nl (@int->char 10))
      (let ((v "OK"))
        (@byte-write (@+ (@block-length v) 77))
        (@byte-write (@+ (@block-length v) 73))
        (@byte-write (@char->int nl))
      )
    """)

  @Test def testPrimitiveBlocks5 =
    compileAndInterpret("""
      (def nl (@int->char 10))
      (let ((v2 (@block-alloc-0 2)))
        (@block-set! v2 0 'O')
        (@block-set! v2 1 'K')
        (@byte-write (@char->int (@block-get v2 0)))
        (@byte-write (@char->int (@block-get v2 1)))
        (@byte-write (@char->int nl))
      )
    """)

  @Test def testPrimitiveBlocks6 =
    compileAndInterpret("""
      (def nl (@int->char 10))
      (@byte-write (@block-tag (@block-alloc-79 12)))
      (@byte-write (@block-tag (@block-alloc-75 12)))
      (@byte-write (@char->int nl))
    """)

  @Test def testPrimitiveBlocks7 =
    compileAndInterpret("""
      (def nl (@int->char 10))
      (let ((b1 (@block-alloc-0 1))
            (b2 (@block-alloc-0 1)))
        (@block-set! b1 0 1)
        (@block-set! b2 0 1)
        (@byte-write (@char->int (if (@=  b1 b2) 'K' 'O')))
        (@byte-write (@char->int (if (@!= b1 b2) 'K' 'O')))
        (@byte-write (@char->int nl))
      )
    """)

  @Test def testPrimitiveLogic1 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@block? "") 'O' 'K')))
      (@byte-write (@char->int (if (@block? (@block-alloc-1 1)) 'K' 'O')))
      (newline)
    """)

  @Test def testPrimitiveLogic2 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@block? ""))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@block? (@block-alloc-1 1)))) (if v 'K''O'))))
      (newline)
    """)

  @Test def testPrimitiveLogic3 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write (@char->int (@int->char 10)))))
      (@byte-write (@char->int (if (@int? 0) 'O' 'K')))
      (@byte-write (@char->int (if (@int? 'K') 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic4 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@int? 0  ))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@int? 'K'))) (if v 'O' 'K'))))
      (newline)
    """)

  @Test def testPrimitiveLogic5 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@bool? #t) 'O' 'K')))
      (@byte-write (@char->int (if (@bool? #f) 'K' 'O')))
      (newline)
    """)

  @Test def testPrimitiveLogic6 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@< 1 2) 'O' 'K')))
      (@byte-write (@char->int (if (@< 1 1) 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic7 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@< 1 2))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@< 1 1))) (if v 'O' 'K'))))
      (newline)
    """)

  @Test def testPrimitiveLogic8 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@>= 2 1) 'O' 'K')))
      (@byte-write (@char->int (if (@>= 1 2) 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic9 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@>= 1 1))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@>= 1 2))) (if v 'O' 'K'))))
      (newline)
    """)

  @Test def testPrimitiveLogic10 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@> 2 1) 'O' 'K')))
      (@byte-write (@char->int (if (@> 1 1) 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic11 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@> 2 1))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@> 1 1))) (if v 'O' 'K'))))
      (newline)
    """)

  @Test def testPrimitiveLogic12 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@> 2 1))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@> 1 1))) (if v 'O' 'K'))))
      (newline)
    """)

  @Test def testPrimitiveLogic13 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@= 1 1) 'O' 'K')))
      (@byte-write (@char->int (if (@= 1 2) 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic14 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@= #t #t) 'O' 'K')))
      (@byte-write (@char->int (if (@= #t #f) 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic15 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@!= #f #t) 'O' 'K')))
      (@byte-write (@char->int (if (@!= #f #f) 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic16 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@bool? 1) 'K' 'O')))
      (@byte-write (@char->int (if (@bool? "bool") 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic17 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (@unit? #u) 'O' 'K')))
      (@byte-write (@char->int (if (@unit? #f) 'O' 'K')))
      (newline)
    """)

  @Test def testPrimitiveLogic18 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (if (not #t) 'K' 'O')))
      (@byte-write (@char->int (if (not #f) 'K' 'O')))
      (newline)
    """)

  @Test def testPrimitiveLogic19 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@bool? #t))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@bool? #f))) (if v 'K' 'O'))))
      (newline)
    """)

  @Test def testPrimitiveLogic20 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@bool? 1))) (if v 'K' 'O'))))
      (@byte-write (@char->int (let ((v (@bool? "bool"))) (if v 'O' 'K'))))
      (newline)
    """)

  @Test def testPrimitiveLogic21 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@unit? #u))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@unit? #f))) (if v 'O' 'K'))))
      (newline)
    """)

  @Test def testPrimitiveLogic22 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (@char? 'A'))) (if v 'O' 'K'))))
      (@byte-write (@char->int (let ((v (@char? 65))) (if v 'O' 'K'))))
      (newline)
    """)

  @Test def testPrimitiveLogic23 =
    compileAndInterpret("""
      (def newline (fun () (@byte-write 10)))
      (@byte-write (@char->int (let ((v (not #t))) (if v 'K' 'O'))))
      (@byte-write (@char->int (let ((v (not #f))) (if v 'K' 'O'))))
      (newline)
    """)
}

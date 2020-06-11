package l3.test.ok
import org.junit.Test

trait ConditionalOKTests {
  this: AllOKTests =>

  @Test def testConditional1 =
    compileAndInterpret("""
            (and (begin
                   (@byte-write (@char->int 'O'))
                   #f)
                 (@byte-write (@char->int '*')))
            (and #t
                 (@byte-write (@char->int 'K')))
            (@byte-write 10)

    """)

  @Test def testConditional2 =
    compileAndInterpret("""
      (or (begin
             (@byte-write (@char->int 'O'))
             #t)
           (@byte-write (@char->int '*')))
      (or #f
          (@byte-write (@char->int 'K')))
      (@byte-write 10)"""
    )

  @Test def testConditional3 =
    compileAndInterpret("""
      (@byte-write (@char->int (or 'O' 'K')))
      (@byte-write (@char->int (or #f 'K')))
      (@byte-write 10)
    """)

  @Test def testSideEffectingCondition =
    compileAndInterpret("""
      (if (@byte-write (@char->int 'O'))
        (if (@byte-write (@char->int 'K'))
          (if (@byte-write 10) ; don't optimize this away!
            #t
            #t
          )
          #t
        )
        #t
      )
    """)

  @Test def testConditional4 =
    compileAndInterpret("""
	(if (if (@byte-write (@char->int 'O')) #t #t)
		  (@byte-write (@char->int 'K'))
		  (@byte-write (@char->int 'T'))
  )
      """)
}

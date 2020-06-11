import org.junit.Assert._
import org.junit.Test
import org.junit.Ignore
import scala.util.Random
import scala.collection.mutable.ArrayBuffer
import Chisel._
import OLK.Manage._

class ManageSuite extends TestSuite {

  @Test def manageTests {

    class ManageTests(c : Manage) extends Tester(c) {
      val cycles = 5*c.stages
      val r = scala.util.Random

      val forceNAexpect = new ArrayBuffer[Boolean]()
      val yCexpect      = new ArrayBuffer[Boolean]()
      val yRegexpect    = new ArrayBuffer[BigInt]()
      for (i <- 1 until c.stages){
        forceNAexpect += true
        yCexpect      += true
        yRegexpect    += BigInt(0)
      }

      var etanuOld = BigInt(0)
      for (i <- 0 until cycles) {
        val forceNAin  = (r.nextInt(5) == 1)

        val yCin      = (r.nextInt(2) == 1)
        val yRegin    = BigInt( r.nextInt(1 << (c.bitWidth/2)) )
        val forgetin  = BigInt( r.nextInt(1 << (c.bitWidth/2)) )

        // For NORMA
        val eta    = BigInt( r.nextInt(1 << (c.bitWidth/2)) )
        val nu     = BigInt( r.nextInt(1 << (c.bitWidth/2)) )

        // For OLK
        val fracCin  = BigInt( r.nextInt(1 << (c.bitWidth/2)) )
        val epsilon  = BigInt( r.nextInt(1 << (c.bitWidth/2)) )

        forceNAexpect += forceNAin
        yCexpect += yCin
        yRegexpect += yRegin

        poke(c.io.forceNAin, forceNAin)
        poke(c.io.forgetin, forgetin)

        if ( c.isNORMA ) {
          val normaIO = c.io.asInstanceOf[NORMAIOBundle]
          poke(normaIO.eta, eta)
          poke(normaIO.nu,  nu)
          if ( c.appType == 1 ) {
            val normacIO = normaIO.asInstanceOf[NORMAcIOBundle]
            poke(normacIO.yCin, yCin)
          }
          if ( c.appType == 3 ) {
            val normarIO = normaIO.asInstanceOf[NORMArIOBundle]
            poke(normarIO.yRegin, yRegin)
          }
        } else {
          val olkIO = c.io.asInstanceOf[OLKIOBundle]
          poke(olkIO.fracCin, fracCin)
          if ( c.appType == 1 ) {
            val olkcIO = olkIO.asInstanceOf[OLKcIOBundle]
            poke(olkcIO.yCin, yCin)
          }
          if ( c.appType == 3 ) {
            val olkrIO = olkIO.asInstanceOf[OLKrIOBundle]
            poke(olkrIO.epsilon, epsilon)
            poke(olkrIO.yRegin,  yRegin)
          }
        }

        step(1)

        if ( i >= c.stages - 1 ) {
          expect(c.io.forceNAout, forceNAexpect(i))
          expect(c.io.forgetout, forgetin)

          if ( c.isNORMA ) {
            val normaIO = c.io.asInstanceOf[NORMAIOBundle]
            expect(normaIO.etapos, eta )
            expect(normaIO.etaneg, -eta )
            expect(normaIO.etanu,  (eta*nu) >> c.fracWidth )
            expect(normaIO.etanu1, etanuOld - eta )

            if ( c.appType == 1 ) {
              val normacIO = normaIO.asInstanceOf[NORMAcIOBundle]
              expect(normacIO.yCout, yCexpect(i) )
            }
            if ( c.appType == 3 ) {
              val normarIO = normaIO.asInstanceOf[NORMArIOBundle]
              expect(normarIO.yRegout, yRegexpect(i) )
            }
          } else {
            val olkIO = c.io.asInstanceOf[OLKIOBundle]
            expect(olkIO.fracCout, fracCin )

            if ( c.appType == 1 ) {
              val olkcIO = olkIO.asInstanceOf[OLKcIOBundle]
              expect(olkcIO.yCout, yCexpect(i) )
            }
            if ( c.appType == 3 ) {
              val olkrIO = olkIO.asInstanceOf[OLKrIOBundle]
              expect(olkrIO.yepos, yRegexpect(i) - epsilon )
              expect(olkrIO.yeneg, - (yRegexpect(i) + epsilon) )
            }
          }
        }
        etanuOld = (eta*nu) >> c.fracWidth
      }
    }

    val myRand = new Random
    val fracWidth = myRand.nextInt(24) + 1
    val bitWidth = myRand.nextInt(24) + fracWidth + 4
    val stages = myRand.nextInt(50)
    val isNORMA = true
    val appType = myRand.nextInt(3) + 1
    println("val fracWidth = " + fracWidth)
    println("val bitWidth = " + bitWidth)
    println("val stages = " + stages)
    println("val isNORMA = " + isNORMA)
    println("val appType = " + appType)
    chiselMainTest(Array("--genHarness", "--compile", "--test", "--backend", "c"), () => {
      Module( new Manage( bitWidth, fracWidth, stages, isNORMA, appType) )
    } ) { c => new ManageTests( c ) }
  }

}

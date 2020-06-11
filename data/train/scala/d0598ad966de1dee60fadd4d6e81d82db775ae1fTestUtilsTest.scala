package com.dnwiebe.emulator.utils
import org.junit.runner.RunWith
import org.scalatest.path.FunSpec
import org.scalatest.junit.JUnitRunner
import org.scalatest.exceptions.TestFailedException
import com.dnwiebe.emulator.io.OutputRecorder

@RunWith (classOf[JUnitRunner])
class TestUtilsTest extends FunSpec {
	describe ("captureException") {
	  describe ("when given code that throws an exception") {
	    val (name, msg) = TestUtils.captureException {() => throw new NullPointerException ("This is the one!")}
	    it ("returns the exception thrown") {
	      assert (name === "NullPointerException")
	      assert (msg === "This is the one!")
	    }
	  }
	  describe ("when given code that doesn't throw an exception") {
	    var x = 0;
	    try {
	    	val e = TestUtils.captureException {() => x = 1}
	    	fail ()
	    }
	    catch {
	      case e: TestFailedException => assert (e.getMessage === "Exception should have been thrown")
	    }
	  }
	}
	describe ("makeInputRecording") {
	  describe ("when given all zeros") {
	    val recording = TestUtils.makeInputRecording(1.0, 1.0, "000")
	    it ("doesn't do much of anything") {
	      assert (recording.sample (0.5) === 0)
	      assert (recording.sample (1.5) === 0)
	      assert (recording.sample (2.5) === 0)
	      assert (recording.sample (3.5) === 0)
	      assert (recording.sample (1000.0) === 0)
	    }
	  }
	  describe ("when given all ones") {
	    val recording = TestUtils.makeInputRecording(1.0, 1.0, "111")
	    it ("doesn't do much more") {
	      assert (recording.sample (0.5) === 1)
	      assert (recording.sample (1.5) === 1)
	      assert (recording.sample (2.5) === 1)
	      assert (recording.sample (3.5) === 1)
	      assert (recording.sample (1000.0) === 1)
	    }
	  }
	  describe ("when given 11010") {
	    val recording = TestUtils.makeInputRecording(1.0, 1.0, "11010")
	    it ("generates the proper signal") {
	      assert (recording.sample (0.5) === 1)
	      assert (recording.sample (1.5) === 1)
	      assert (recording.sample (2.5) === 0)
	      assert (recording.sample (3.5) === 1)
	      assert (recording.sample (4.5) === 0)
	      assert (recording.sample (1000.0) === 0)
	    }
	  }
	  describe ("when given 11010, but really fast") {
	    val recording = TestUtils.makeInputRecording(0.0001, 1.0, "11010")
	    it ("generates the proper signal") {
	      assert (recording.sample (0.00005) === 1)
	      assert (recording.sample (0.00015) === 1)
	      assert (recording.sample (0.00025) === 0)
	      assert (recording.sample (0.00035) === 1)
	      assert (recording.sample (0.00045) === 0)
	      assert (recording.sample (1000.0) === 0)
	    }
	  }
	}
	describe ("dumpOutputRecorder") {
	  val recorder = new OutputRecorder()
	  describe ("when given a steady space") {
	    recorder.accept (0.0, 0)
	    describe ("and dumped for one bit time") {
	      val dump = TestUtils.dumpOutputRecorder (1.0, 1, recorder)
	      it ("produces one zero") {
	        assert (dump === "0")
	      }
	    }
	    describe ("and dumped for ten bit times") {
	      val dump = TestUtils.dumpOutputRecorder (1.0, 10, recorder)
	      it ("produces ten zeros") {
	        assert (dump === "0000000000")
	      }
	    }
	  }
	  describe ("when given a steady mark") {
	    recorder.accept (0.0, 10)
	    describe ("and dumped for one bit time") {
	      val dump = TestUtils.dumpOutputRecorder (1.0, 1, recorder)
	      it ("produces one one") {
	        assert (dump === "1")
	      }
	    }
	    describe ("and dumped for ten bit times") {
	      val dump = TestUtils.dumpOutputRecorder (1.0, 10, recorder)
	      it ("produces ten ones") {
	        assert (dump === "1111111111")
	      }
	    }
	  }
	  describe ("when given high high low high low") {
	    recorder.accept (0.0, 5)
	    recorder.accept (1.0, 1)
	    recorder.accept (2.0, 0)
	    recorder.accept (3.0, 2)
	    recorder.accept (4.0, 0)
	    describe ("and dumped for five bit times") {
	      val dump = TestUtils.dumpOutputRecorder (1.0, 5, recorder)
	      it ("generates 11010") {
	        assert (dump === "11010")
	      }
	    }
	  }
	}
}
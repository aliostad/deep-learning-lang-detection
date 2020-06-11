/**
 * ReadWriter is a static class (an object in scala) that
 * can input from a file or output to one.
 */

package com.cpb.cs4500.io {
  import com.cpb.cs4500.parsing._

  import scala.io._

  object ReadWriter {

    def inputFromFile(fileName: String): String = {
      var str = ""
      for (line <- Source.fromFile(fileName, "utf-8").getLines)
        str+= " " + line + " "
      str
    }

    // output the tests to the file in the boilerplate code
    // credit to Professor Clinger for the generated scheme code
    def outputToFile(fileName: String, tests: List[String], adts: List[String]): Unit = {
      val out = new java.io.FileWriter(fileName)
      out.write(";;; Black-box test program generated by Cool Project, Bro\n")
      out.write("\n")
      out.write("(import (rnrs base)\n")
      out.write("        (rnrs exceptions)     ; for the guard syntax\n")
      out.write("        (rnrs io simple)      ; for display etc\n")
      for (adt <- adts) {
        out.write("        (testing " + adt + ")\n")
      }
      out.write(")\n")
      out.write("\n")
      out.write(";;; Counters for the summary report when testing is complete.\n")
      out.write("\n")
      out.write("(define tests-run 0)\n")
      out.write("(define tests-passed 0)\n")
      out.write("(define tests-failed 0)\n")
      out.write("\n")
      out.write(";;; Syntax to make testing more convenient.\n")
      out.write(";;;\n")
      out.write(";;; (test <name> <expr>) evaluates <expr>.\n")
      out.write(";;; If <expr> evaluates to a true value (any value other #f),\n")
      out.write(";;; then the test has been passed.\n")
      out.write(";;; If <expr> evaluates to #f, then the test has been failed.\n")
      out.write(";;; If an exception occurs during evaluation of <expr>, then\n")
      out.write(";;; the test has been failed.\n")
      out.write("\n")
      out.write("(define-syntax test\n")
      out.write("  (syntax-rules ()\n")
      out.write("    ((_ name expr)\n")
      out.write("     (begin (set! tests-run (+ tests-run 1))\n")
      out.write("            (if (guard (exn (else #f))\n")
      out.write("                  expr)\n")
      out.write("                (set! tests-passed (+ tests-passed 1))\n")
      out.write("                (begin (set! tests-failed (+ tests-failed 1))\n")
      out.write("                       (display \"Failed test: \")\n")
      out.write("                       (display name)\n")
      out.write("                       (newline)))))))\n")
      out.write("\n")
      out.write(";;; The black-box tests.\n")
      out.write("\n")

      // this is where the tests are written to the file
      for (test <- tests) {
        out.write(test)
      }

      out.write("\n")
      out.write(";;; Summary of results.\n")
      out.write("\n")
      out.write("(display \"SUMMARY: failed \")\n")
      out.write("(display tests-failed)\n")
      out.write("(display \" of \")\n")
      out.write("(display tests-run)\n")
      out.write("(display \" tests.\")\n")
      out.write("(newline)\n")
      out.write("\n")
      out.write(";;; Sanity check.\n")
      out.write("\n")
      out.write("(if (not (= tests-run\n")
      out.write("            (+ tests-passed tests-failed)))\n")
      out.write("    (begin (display \"Oops...\") (newline)))")
      out.close
    }

  }

}
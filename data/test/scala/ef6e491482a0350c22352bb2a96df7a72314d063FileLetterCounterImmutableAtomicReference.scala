package ch13.questions.q9

import java.util.concurrent.atomic.AtomicReference

object FileLetterCounterImmutableAtomicReference {

  def update(frequencies: AtomicReference[Map[Char, Int]], ch: Char): Unit = {
    while (true) {
      val oldMap = frequencies.get()
      val newMap = oldMap + (ch -> (oldMap.getOrElse(ch, 0) + 1))
      if (frequencies.compareAndSet(oldMap, newMap)) {
        return
      } else {
        print("Ouch! ")
      }
    }
  }

  def readFile(frequencies: AtomicReference[Map[Char, Int]]) = {
    val source = getBufferedSource()
    val iter = source.buffered
    while (iter.hasNext) {
      update(frequencies, iter.next)
    }
    source.close()
  }
}

object FileLetterCounterImmutableAtomicReferenceMain extends App {

  import FileLetterCounterImmutableAtomicReference._

  println("AtomicReference results...")
  val frequencies = new AtomicReference(Map[Char, Int]())

  countFiles({ readFile(frequencies) }, 250)
  Thread.sleep(2000)

  displayResults(frequencies.get())
}
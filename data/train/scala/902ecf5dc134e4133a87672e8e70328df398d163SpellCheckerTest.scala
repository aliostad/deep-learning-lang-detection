package com.kaggle.nlp

/**
  * Created by freezing on 02/03/16.
  */
// tODO: Have unit tests
object SpellCheckerTest extends App {
  val spellChecker = new DataSpellChecker

  println(spellChecker.process(Token("conditiner")))
  println(spellChecker.process(Token("air")))
  println(spellChecker.process(Token("airo")))
  println(spellChecker.process(Token("ligfht")))
  println(spellChecker.process(Token("ssink")))
  println(spellChecker.process(Token("sinz")))
  println(spellChecker.process(Token("influnce")))
  println(spellChecker.process(Token("aluminum")))
  println(spellChecker.process(Token("aluminium")))
  println(spellChecker.process(Token("cleanxing")))
}

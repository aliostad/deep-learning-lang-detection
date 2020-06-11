package com.kaggle.nlp

import com.kaggle.model.CleanTerm

/**
  * Created by freezing on 05/03/16.
  */
object TermSemanticExtractionTest extends App {
  val extractor = new TermSemanticExtraction
  println(nice(termSemanticExtraction.process(DataCleaner.process("50 amp 250-600v"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("Rust-Oleum Specialty 30 oz. Magnetic Primer Kit"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("air filter 1 in"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("milliken millwork 36 x 80 master nouveau decor glas 1 4 lite 8 panel finish oak fiberglas prehung front door"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("Sigman 20 ft. x 30 ft. Silver Black Heavy Duty Tarp"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("Closet Max 18 in. Over the Door Closet Rod"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("12 inch sower head"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("six stage hepa filter portabl electronic air purifier with 20 kv ionizer and 2 plate ozone genre"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("Heartland Cabinetry 18x24.3x34.5 in. Base Cabinet with 3 Drawers in White"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("Leatherman Tool Group Skeletool 7-in-1 All-Purpose Multi-Tool"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("RIDGID 13 in. Thickness Corded Planer"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("Rust-Oleum Specialty 30 oz. Magnetic Primer Kit"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("Roberts 1 Gal. Engineered Wood Glue Adhesive"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("Scotts Turf Builder 20 lb. Tall Fescue Mix Grass Seed"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process("book cases"))))
  println(nice(termSemanticExtraction.process(DataCleaner.process(""))))
  println(nice(termSemanticExtraction.process(DataCleaner.process(""))))
  println(nice(termSemanticExtraction.process(DataCleaner.process(""))))
  println(nice(termSemanticExtraction.process(DataCleaner.process(""))))

  def nice(term: CleanTerm): String = {
    (term.tokens map {_.stemmedValue} mkString " ") ++ "  | " ++ (term.attributes map { case (k, v) => s"[$k, ${ v map { _.stemmedValue } mkString " " }}}]"} mkString " ")
  }
}

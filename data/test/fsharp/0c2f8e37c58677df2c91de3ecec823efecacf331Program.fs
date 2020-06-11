open Compile

[<EntryPoint>]
let main argv = 
  do batchProcess LatexDefinition.generatePresentation FunctionalWeek1.slides "INFDEV02-8-Lec1-Lambda-calculus" "The INFDEV@HR Team" "Introduction to functional programming and lambda calculus" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek2.slides "INFDEV02-8-Lec2-Delta-rules" "The INFDEV@HR Team" "Delta rules" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek3.slides "INFDEV02-8-Lec3-Data-structures" "The INFDEV@HR Team" "Data structures" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek4.slides "INFDEV02-8-Lec4-Letrec-FSharp" "The INFDEV@HR Team" "Recursion and F\# translations" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek5.slides "INFDEV02-8-Lec5-Types" "The INFDEV@HR Team" "Types, inference, and F\# data types" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek6.slides "INFDEV02-8-Lec6-Practicum" "The INFDEV@HR Team" "Setting up a functional application" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek7.slides "INFDEV02-8-Lec7-Haskell" "The INFDEV@HR Team" "Haskell" true true
  // Lecture 8 (optional lecture) advanced patterns and practices: monads, up to coroutines

//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam1.slides "INFDEV02-8-SampleExam1" "The INFDEV@HR Team" "INFDEV02-8 Sample exam" true false
//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam2.slides "INFDEV02-8-SampleExam2" "The INFDEV@HR Team" "INFDEV02-8 Sample exam" true false
//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam3.slides "INFDEV02-8-SampleExam3" "The INFDEV@HR Team" "INFDEV02-8 Sample exam" true false
//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam4.slides "INFDEV02-8-SampleExam4" "The INFDEV@HR Team" "INFDEV02-8 Sample exam" true false
//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam5.slides "INFDEV02-8-SampleExam5" "The INFDEV@HR Team" "INFDEV02-8 Sample exam" true false

  0

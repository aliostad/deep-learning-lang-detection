open Compile

[<EntryPoint>]
let main argv = 
  do batchProcess LatexDefinition.generatePresentation FunctionalWeek1.slides "INFSEN02-1-Lec1-Lambda-calculus" "The INFDEV@HR Team" "Introduction to functional programming and lambda calculus" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek2.slides "INFSEN02-1-Lec2-Delta-rules" "The INFDEV@HR Team" "Delta rules" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek3.slides "INFSEN02-1-Lec3-Data-structures" "The INFDEV@HR Team" "Data structures" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek4.slides "INFSEN02-1-Lec4-Letrec-FSharp" "The INFDEV@HR Team" "Recursion and F\# translations" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek5.slides "INFSEN02-1-Lec5-Types" "The INFDEV@HR Team" "Types, inference, and F\# data types" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek6.slides "INFSEN02-1-Lec6-Practicum" "The INFDEV@HR Team" "Setting up a functional application" true false
//  do batchProcess LatexDefinition.generatePresentation FunctionalWeek7.slides "INFSEN02-1-Lec7-Haskell" "The INFDEV@HR Team" "Haskell" true true
  // Lecture 8 (optional lecture) advanced patterns and practices: monads, up to coroutines

//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam1.slides "INFSEN02-1-SampleExam1" "The INFDEV@HR Team" "INFSEN02-1 Sample exam" true false
//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam2.slides "INFSEN02-1-SampleExam2" "The INFDEV@HR Team" "INFSEN02-1 Sample exam" true false
//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam3.slides "INFSEN02-1-SampleExam3" "The INFDEV@HR Team" "INFSEN02-1 Sample exam" true false
//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam4.slides "INFSEN02-1-SampleExam4" "The INFDEV@HR Team" "INFSEN02-1 Sample exam" true false
//  do batchProcess LatexDefinition.generateDocument SampleExams.Exam5.slides "INFSEN02-1-SampleExam5" "The INFDEV@HR Team" "INFSEN02-1 Sample exam" true false

  0

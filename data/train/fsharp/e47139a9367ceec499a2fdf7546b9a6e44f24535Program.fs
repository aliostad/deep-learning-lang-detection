open Compile

let makeSlides (title : string) =
  do batchProcess LatexDefinition.generatePresentation (Chapter1.Week1.v2.slides title) (sprintf "%s_Lec1_DP_intro" title) "The INFDEV team" "Introduction" false true
//  do batchProcess LatexDefinition.generatePresentation (Chapter2.Week2.v1.slides title) (sprintf "%s_Lec2_DP_iterator" title) "The INFDEV team" "Iterating collections" false true
//  do batchProcess LatexDefinition.generatePresentation (Chapter3.Week3.v1.slides title) (sprintf "%s_Lec3_DP_adapter" title) "The INFDEV team" "Adapting interfaces" true true
//  do batchProcess LatexDefinition.generatePresentation (Chapter4_0.Week4.v1.slides title) (sprintf "%s_Lec4A_DP_abstract_classes" title) "The INFDEV team" "Abstract classes" true true
//  do batchProcess LatexDefinition.generatePresentation (Chapter4.Week4.v1.slides title) (sprintf "%s_Lec4B_DP_factory" title) "The INFDEV team" "Factory (virtual constructors)" true true
//  do batchProcess LatexDefinition.generatePresentation (Chapter5.Week5.v1.slides title) (sprintf "%s_Lec5_DP_decorator" title) "The INFDEV team" "The decorator design pattern" true true



// REMOVE UNREPEATED EVERYWHERE IT WORKS!!!!!!!!! FREE SLIDEZ!!!!1111oneoneone



[<EntryPoint>]
let main argv = 
//  do makeSlides "INFSEN02-2"
  do makeSlides "INFDEV02-4"
  0    
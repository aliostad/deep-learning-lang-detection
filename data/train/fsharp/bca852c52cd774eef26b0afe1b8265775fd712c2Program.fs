//these are similar to C# using statements
open canopy
open runner
open System
open TestHelper
//start an instance of the firefox browser
start firefox


//this is how you define a test
 // examples : https://github.com/lefthandedgoat/canopy/blob/master/tests/basictests/Program.fs
"taking canopy for a spin" &&& HelloCanopy.CanopySample.test "http://lefthandedgoat.github.io/canopy/testpages/"

"taking site for a spin" &&& Cvs.test "http://www.company.com/"

"taking site api for a spin" &&& CvsApi.test "http://api.company.com/"

//run all tests
run()

printfn "press [enter] to exit"
System.Console.ReadLine() |> ignore

quit()
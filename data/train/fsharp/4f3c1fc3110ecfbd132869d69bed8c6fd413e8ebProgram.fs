// redesign from scratch, figure out where everything goes, and how random elements will be added in. Flowchart it.
// a file for different location patterns (like separating triplets from a random two note split)
// a file for making keys, motifs, themes.
// each separate voice will have an instrument that it links to
// the singer will then manage these methods. A singer should ideally be only its members and a single function that generates the buffer array of the next measure
// make all note ratios generated after the locations are put into a linear format
//3. Make generator that generates a melody and bass voice, uses overtones and different waves, and has song progression over the course of the song
//4. Audio's main purpose will be continuous streaming
open Audio
open SingerAbstract
open Waves
open System
open Freq

gen ()

Console.ReadKey true |> ignore
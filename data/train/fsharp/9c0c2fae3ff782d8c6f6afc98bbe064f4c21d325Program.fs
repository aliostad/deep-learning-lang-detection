namespace RottenTomatoesApi.ConsoleClient

open System
open RottenTomatoesApi
open FSharp.Data
  
module App =
    
    let Run() =
        
        let PrintMoviesEndpoints() =
                    
            Console.WriteLine ":: Movies"

            Console.WriteLine "\n\n"

            Console.WriteLine "======= [ Search ] ======="
            Api.Movies.Search("interstellar").Movies |> Seq.iter(fun m -> Console.WriteLine m.Title)

            Console.WriteLine "\n\n"

            Console.WriteLine "======= [ Box Office ] ======="
            Api.Movies.GetBoxOffice() |> Seq.iter(fun m -> Console.WriteLine m.Title)
              
            Console.WriteLine "\n\n"

            Console.WriteLine "======= [ In Theater ] ======="
            Api.Movies.GetInTheater() |> Seq.iter(fun m -> Console.WriteLine m.Title)

            Console.WriteLine "\n\n"

            Console.WriteLine "======= [ Opening ] ======="
            Api.Movies.GetOpening() |> Seq.iter(fun m -> Console.WriteLine m.Title)

            Console.WriteLine "\n\n"
              
            Console.WriteLine "======= [ Upcoming ] ======="
            Api.Movies.GetUpcoming() |> Seq.iter(fun m -> Console.WriteLine m.Title)

            Console.WriteLine "\n\n"
   

        let PrintDVDsEndpoints() =
            
            Console.WriteLine ":: DVDs"
        
            Console.WriteLine "\n\n"

            Console.WriteLine "======= [ New Releases ] ======="
            Api.DVDs.GetNewReleases() |> Seq.iter(fun m -> Console.WriteLine m.Title)

            Console.WriteLine "\n\n"

            Console.WriteLine "======= [ Current Releases ] ======="
            Api.DVDs.GetCurrentReleases() |> Seq.iter(fun m -> Console.WriteLine m.Title)

            Console.WriteLine "\n\n"

            //Console.WriteLine "======= [ Upcoming ] ======="
            //Api.DVDs.GetUpcoming().Movies |> Seq.iter(fun m -> Console.WriteLine m.Title)

            Console.WriteLine "\n\n"

        let PrintMovieDetailsEndpoints() =            
              
            Console.WriteLine ":: Movie details"
        
            Console.WriteLine "\n\n"

            Console.WriteLine "======= [ Details ] ======="
            Api.Movie.GetDetails(770672122).Title |> Console.WriteLine 

            Console.WriteLine "\n\n"              

            Console.WriteLine "======= [ Reviews ] ======="
            Api.Movie.GetReviews(770672122).Reviews |> Seq.iter(fun r -> Console.WriteLine (sprintf "%s wrote: %s(...)\n" r.Critic (r.Quote.Substring(0, 30))))

            Console.WriteLine "\n\n"              

            Console.WriteLine "======= [ Similar ] ======="
            Api.Movie.GetSimilar(770672122).Title |> Console.WriteLine

            Console.WriteLine "\n\n"              

        PrintMoviesEndpoints()
        PrintDVDsEndpoints()
        PrintMovieDetailsEndpoints()
                
module ConsoleClient = 

    [<EntryPoint>]
    let main argv =      
       
        App.Run()

        Console.ReadLine() |> ignore
        0

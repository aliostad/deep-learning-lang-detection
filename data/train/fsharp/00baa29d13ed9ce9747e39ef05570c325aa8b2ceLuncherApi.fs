namespace Luncher.Api


open  System
type LuncherApi() =
   static let notVisited (restaurants) (visited : seq<RestaurantType>) = 
        Luncher.Api.Restaurant.distinct (Seq.toList restaurants) visited
   static member GetRestaurants(restaurantString : String) = 
                            restaurantString 
                            |> FileSystem.parseLine
                            |> Seq.map Luncher.Api.Restaurant.create
                            |> Luncher.Api.Restaurant.randomize



   static member ImHungry (all : seq<RestaurantType>) : seq<RestaurantType> = 
            let rec imHungryRec (visited : RestaurantType list) = 
                seq {
                    match notVisited all visited with
                    | [] -> 
                        yield {Name = ""}
                        yield! imHungryRec []
                    | x :: xs -> 
                        yield x
                        yield! imHungryRec (x :: visited)
                }
            imHungryRec []

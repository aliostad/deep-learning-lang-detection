module GHC.Domain

open ExtCore.Collections
open System.Collections.Generic

open GHC.Extensions
open GHC.Extensions.Common
open System.Collections.Generic

//-------------------------------------------------------------------------------------------------

type Coord = int * int

type Product = int

type Order = {idO : int ; adress : Coord ; products : Product list ; BookedProducts : Dictionary<int (*warehouse id*),Product list> }

type Warehouse = { idW : int ; cell : Coord ; stock : Product array}

type Drone = { idD : int ; mutable position : Coord ; mutable loadLeft : int ; maxLoad : int ; mutable time : int}

let droneCreates droneNumber maxLoad warehouseDefault =
   Array.init droneNumber
      (fun i -> { idD = i ; position = warehouseDefault ; loadLeft = maxLoad; maxLoad = maxLoad; time=0})

let copyDrone d = {d with position = d.position; time=d.time}

let copyArrayBy (a:Drone array) = Array.init a.Length (fun i -> copyDrone a.[i]) 

//-------------------------------------------------------------------------------------------------

let distance (ra,ca) (rb,cb) =
   (ra-rb)*(ra-rb) + (ca-cb)*(ca-cb)
   |> float |> sqrt |> ceil |> int

//compute the cost of a given drone
let computeDistanceTime warehousePosition drone =
      (distance drone.position warehousePosition) + drone.time

//Orders the drones depending on their time and distance to the warehouse
let findDrones warehousePosition drones = 
      Array.sortBy (computeDistanceTime warehousePosition) drones


type Consigne =
   | Load of int*int*int*int // droneId*warehouse * prodtype * quantity
   | Unload of int*int*int*int // droneId*warehouse * prodtype * quantity
   | Deliver of int*int*int*int // droneId*orderId * prodtype * quantity
   | Wait of int*int // droneId*turnNum

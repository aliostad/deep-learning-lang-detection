(*
 * queue_menu.fs
 * By Antonio F. Huertas
 * This program manages a menu of common queue operations.
 *)
module queue_menu

open FunctionalCollections    // for the Queue module functions
open System                   // for the .NET Console class methods

// Process the add element menu option.
let process_add que =
    Console.Write "Enter a character: "
    let elem = Console.ReadLine () |> char
    Console.WriteLine ("Adding {0} into the queue.", elem)
    Queue.add elem que

// Process the remove element menu option.
let process_remove que =
    try
        let elem = Queue.peek que |> char
        Console.WriteLine ("Removing {0} from the queue.", elem)
        Queue.remove que
    with
        EmptyQueue msg -> Console.WriteLine ("Cannot remove: {0}", msg)
                          que

// Process the view contents menu option.
let process_view que =
    if Queue.isEmpty que then
        Console.WriteLine "Cannot show: queue is empty."
    else
        Console.Write "Contents of the queue: "
        Queue.iter (printf "%c ") que
        Console.WriteLine ()

// Shows the menu options.
let show_menu () =
    Console.WriteLine "\nQueue Menu\n"
    Console.WriteLine "1. Add an element"
    Console.WriteLine "2. Remove an element"
    Console.WriteLine "3. View the contents"
    Console.WriteLine "4. Exit"

// Manages the menu selection on the queue.
let rec process_menu que =
    show_menu ()
    Console.Write "Enter selection (1-4): "
    match (Console.ReadLine () |> int) with
    | 1 -> que |> process_add |> process_menu
    | 2 -> que |> process_remove |> process_menu
    | 3 -> process_view que
           process_menu que
    | 4 -> Console.WriteLine "Thanks for using this program!"
    | _ -> Console.WriteLine "Error! Selection must be between 1 and 4."
           process_menu que

// Serves as the entry point of the program.
let main () =
    process_menu Queue.empty
    Console.ReadKey () |> ignore

// Calls the main function.
main()
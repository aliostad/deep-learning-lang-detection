open canopy
open runner
open System

start chrome

"taking canopy for a spin" &&&& fun _ ->
    url "http://github.com"
    click "a[href='/login']"
    "#login_field" << "YOUR USER NAME"
    "#password" << "YOUR PASSWORD"
    click "input[value='Sign in']"
    "input[placeholder='Search GitHub']" << "canopy"
    press enter
    click (first ".repo-list-item h3 a")
    click "button[aria-label='Fork your own copy of lefthandedgoat/canopy to your account']"

run()

printfn "press [enter] to exit"

System.Console.ReadLine() |> ignore

quit()

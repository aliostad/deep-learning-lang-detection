module ConsoleApplication =
    open PiouPiouDomain

    let startGame() =
        let api = PiouPiouImplementation.Api.api
        //let loggedApi = Logger.injectLogging api
        GameWithAi.PiouPiouConsoleUI.startGame api 

(*

To play in a IDE:
1) first highlight all code in the file and "Execute in Interactive" or equivalent
2) Uncomment the ConsoleApplication.startGame() line below and execute ité

To play in command line:
1) Uncomment the ConsoleApplication.startGame() line below and execute the entire file using FSI

*)


ConsoleApplication.startGame() 
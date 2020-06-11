namespace Cap09

module _05_Railway_Oriented_Programming = 
    //Syntax Expression Choice
    //    [<StructuralEquality>]
    //    [<StructuralComparison>]
    //    type Choice<'T1,'T2> =
    //    | Choice1Of2 of 'T1
    //    | Choice2Of2 of 'T2
    //     with
    //      interface IStructuralEquatable
    //      interface IComparable
    //      interface IComparable
    //      interface IStructuralComparable
    //     end
    let bind inputFunc = 
        function 
        | Choice1Of2 s -> inputFunc s
        | Choice2Of2 f -> Choice2Of2 f
    
    type Account = 
        { UserName : string
          IsLogged : bool
          Email : string }
    
    let validateAccount account = 
        match account with
        | account when account.UserName = "" -> Choice2Of2 "UserName is not valid"
        | account when account.Email = "" -> Choice2Of2 " Email is not empty"
        | _ -> Choice1Of2 account
    
    let checkLogin account = 
        if (account.IsLogged) then Choice1Of2 account
        else Choice2Of2 "User is not logged"
    
    let LogIn account = 
        if (account.IsLogged) then Choice2Of2 "User has already Logged"
        else Choice1Of2 { account with IsLogged = true }
    
    let LogOut account = 
        if (account.IsLogged) then Choice1Of2 { account with IsLogged = false }
        else Choice2Of2 "User has already Logged"
    
    let ProcessNewAccount = 
        validateAccount
        >> (bind LogIn)
        >> (bind checkLogin)
    
    let NewFakeAccount = 
        { UserName = ""
          Email = ""
          IsLogged = false }
    
    let AccountLogged = 
        { UserName = "User"
          Email = "user@user.net"
          IsLogged = true }
    
    let NewAccount = 
        { UserName = "User1"
          Email = " user1@user.net "
          IsLogged = false }
    
    ProcessNewAccount NewFakeAccount |> printfn "Result = %A"
    ProcessNewAccount AccountLogged |> printfn "Result = %A"
    ProcessNewAccount NewAccount |> printfn "Result = %A"
    
    let ProcessLogOutAccount = 
        validateAccount
        >> (bind LogOut)
        >> (bind checkLogin)
    
    let ControlAccount = validateAccount >> (bind checkLogin)
    let ControlAndLoginAccount = ProcessNewAccount >> (bind ControlAccount)

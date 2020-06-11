type 'a IList = INode of  Id: int * Hd: 'a * Tl : 'a IList | INil

/// internal data constructor which takes garbage collector as a parameter
/// iCons will be derived from this after gc is defined
let iCons' gcAlloc h t = INode( Id = gcAlloc t, Hd=h, Tl=t)

let iHd x =
    match x with
    | INode(i,h,t) -> h
    | _ -> failwithf "IList node expected"

let iTl x =
    match x with
    | INode(i,h,t) -> t
    | _ -> failwithf "IList node expected"


let iId = function
    | INode(i, h, t) -> i
    | INil -> -1 // give a negative integer instead of failing

let (|IMatch|_|) = function
    | INode (i, h, t) -> Some (h,t)
    | _ -> None


type Data = float IList // Type of all data used in simulations

type StackFrame = Map<string, Data Ref> 

let mutable GlobalStack: StackFrame list = []


/// create a two parameter stack oriented function by wrapping the provided functionUsingStack
let ManageCallTwoParameters p1Name p2Name localNames (functionUsingStack: StackFrame -> (Data -> Data -> Data) -> Data) =
    let rec innerFunc p1 p2 = // this is the function returned
        let oldStack = GlobalStack
        /// stack frame with locals initialised from parameters given by calling function
        /// extra local variables (if needed) are initialised to INil
        let newFrame = Map.ofList <| [ p1Name, ref p1 ; p2Name, ref p2 ] @ (List.map (fun lName -> lName, ref INil) localNames) // create the new stack frame for this function call
        GlobalStack <- newFrame :: oldStack
        let returnedData = functionUsingStack newFrame innerFunc
        GlobalStack <- oldStack // destroy the stack frame for this call which is no longer needed
        returnedData
    innerFunc

/// create a one parameter stack oriented function by wrapping the provided functionUsingStack
let ManageCallOneParameter p1Name localNames (functionUsingStack: StackFrame -> (Data -> Data) -> Data) =
    let rec innerFunc p1 = // this is the function returned
        let oldStack = GlobalStack
        /// stack frame with locals initialised from parameters given by calling function
        /// extra local variables (if needed) are initialised to INil
        let newFrame = Map.ofList <| [ p1Name, ref p1 ] @ (List.map (fun lName -> lName, ref INil) localNames) // create the new stack frame for this function call
        GlobalStack <- newFrame :: oldStack
        let returnedData = functionUsingStack newFrame innerFunc
        GlobalStack <- oldStack // destroy the stack frame for this call which is no longer needed
        returnedData
    innerFunc




// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// -------------------Implement a better GC method in gcAlloc------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
let checkConsistency (lst:Data) =
    let rec getIdListFromData: Data -> int list = function
        | INode(id,h,t) -> id :: getIdListFromData t
        | _ -> []
    let aliveIdList =
       GlobalStack
       |> List.collect (Map.toList >> List.map (fun (_, x) -> !x) >> List.collect getIdListFromData)
    let checkAlive id =
        match List.exists (fun x -> x = id) aliveIdList with
        | true -> ()
        | false -> failwithf "Inconsistent data id %d discovered, id not on stack %A" id aliveIdList
    List.iter checkAlive (getIdListFromData lst)


/// the total number of nodes in the memory
let numOfFreeMemory = 25

/// used to record whether a node is allocated
let mutable alloc = [|for i in 1..numOfFreeMemory -> false|]

///initialise a free list
let mutable freeList = 
    let mutable fl = INil
    match numOfFreeMemory with
    | _ when numOfFreeMemory <= 0 -> failwith "initial free memory cannot be set to zero or negative"   
    | _ when numOfFreeMemory = 1 -> fl
    | _ -> 
        for i in (numOfFreeMemory-1)..(-1)..0 do
            fl <- INode(i, 0.0, fl)
        fl




///garbage collector
let gc() = 
    //-------mark phase-----
    let markPhase() = 
        ///convert 'stackframe' type to a list of 'data' type
        let listOfValuesFromMap x = x |> Map.toList |> List.map (fun (_,x)-> (!x))
        ///mark memory on the stack. The input is a list of 'data' type
        let markList dataList = 
            let rec mark data = 
                match data with
                | INil -> ()
                | INode(_,_,_) -> 
                    match alloc.[iId data] with
                    |true -> ()
                    |false -> 
                        alloc.[iId data] <- true
                        mark (iTl data)
            dataList |> List.iter mark
        // firstly set the mark of all memory to false
        alloc <- alloc |> Array.map (fun x -> false)
        // then start marking all the data in the global stack
        GlobalStack |> List.iter (listOfValuesFromMap >> markList) 

    //-------scan phase-----
    let scanPhase() = 
        freeList <- INil
        for i in (numOfFreeMemory-1)..(-1)..0 do 
            match alloc.[i] with
            |false -> freeList <- INode(i, 0.0, freeList)
            |true -> ()
    
    markPhase()
    scanPhase()

///generates the next id for a new INode
let nextGenerator() = 
    let mutable id = 0
    let next() =
        match freeList with
        | INil -> 
            gc() // collect garbage
            match freeList with
            | INil -> failwith "error, memory full!"
            | _ ->
                id <- iId freeList
                freeList <- iTl freeList
                id
        | _ -> 
            id <- iId freeList
            freeList <- iTl freeList
            id
    next

/// nextId is the generator function
let nextId = nextGenerator()

let gcAlloc lst =
    checkConsistency lst
    let id = nextId()
    printfn "Creating Data id=%d" id
    id

let iCons = iCons' gcAlloc
// *****************************************************************************
// *****************************************************************************
// -------------------the end of implementing a better GC----------------------
// *****************************************************************************
// *****************************************************************************






//----------------------
// Application Code
//----------------------

/// turn a float list into a Data item (float IList)
let makeDataList (lst: float list) =
    let oldStack = GlobalStack
    let tmpVar = ref INil
    GlobalStack <- Map.ofList [ "x", tmpVar ] :: oldStack
    List.iter (fun f -> tmpVar := iCons f !tmpVar) (List.rev lst) 
    GlobalStack <- oldStack
    !tmpVar


/// create a merge function using StackFrames
let mergeUsingStack (frame: StackFrame) (merge: Data -> Data -> Data) = 
    let x,y,lz = frame.["x"], frame.["y"], frame.["lz"]
    match !x, !y with
    | IMatch(a,x'), IMatch(b,y') when a > b -> 
        x := x'
        lz := merge !x !y
        iCons a !lz
    | IMatch(a,x'), IMatch(b,y')-> 
        y := y'
        lz := merge !x !y
        iCons b !lz
    | INil, IMatch(b,y') -> !y
    | IMatch(a,x') , INil -> !x 
    | INil, INil -> INil

/// create a function, that selects elements with even index, using StackFrames
let evenElementsUsingStack (frame: StackFrame) (evenElements: Data -> Data) =
    let x,ly = frame.["x"],frame.["ly"]
    match !x with
    | INil -> INil
    | IMatch(a,INil) -> iCons a INil
    | IMatch(a,IMatch(_,lst')) -> 
        ly := evenElements lst'
        iCons a !ly


// ******************************************************************************* 
//    functions that are simulated here. These functions can be used as normal
// ******************************************************************************* 
let merge = ManageCallTwoParameters "x" "y" ["lz"] mergeUsingStack
let evenElements = ManageCallOneParameter "x" ["ly"] evenElementsUsingStack


/// create a merge sort function using StackFrames
let mergeSortUsingStack (frame:StackFrame) (mergeSort:Data->Data) =
    let x = frame.["x"]
    match !x with
    | INil -> INil
    | IMatch(a,INil) -> iCons a INil
    | IMatch(a,lst') ->  merge (evenElements (!x) |> mergeSort) (evenElements lst' |> mergeSort)


///simulated mergeSort function 
let mergeSort = ManageCallOneParameter "x" [] mergeSortUsingStack
printfn "mergeSort = %A " (mergeSort (makeDataList [25.0 ; 10.0; 20.0; 100.0; 30.1; 10.0 ; 100.0; 30.1; 10.0 ; 100.0; 30.1 ])) 
printfn "mergeSortTest = %A " (mergeSortTest [25.0 ; 10.0; 20.0; 100.0; 30.1; 10.0 ; 100.0; 30.1; 10.0 ; 100.0; 30.1 ])


// -----------------------------------------
//   -----------------test-----------------     
// -----------------------------------------
/////test merge function 
//let rec mergeTest x y =
//    match x,y with
//    | a :: x', b :: y' when a > b -> a :: mergeTest x' y
//    | x, b :: y' -> b :: mergeTest x y'
//    | [], y -> y
//    | x, [] -> x
//printfn "merge = %A " (merge (makeDataList [25.0 ; 10.0 ; 100.0 ]) (makeDataList [15.0 ; 30.0 ; 50.0]))
//printfn "mergeTest = %A " (mergeTest [25.0 ; 10.0 ; 100.0] [15.0 ; 30.0 ; 50.0])

/////test evenElements function
//let rec evenElementsTest = function
//    | [] -> []
//    | [a] -> [a]
//    | a :: _ :: lst' -> a :: evenElementsTest lst'
//printfn "evenElements = %A " (evenElements (makeDataList [25.0 ; 10.0 ; 100.0; 30.1]))
//printfn "evenElementsTest = %A " (evenElementsTest [25.0 ; 10.0 ; 100.0; 30.1])


/////test mergeSort function
//let rec mergeSortTest lst =
//    match lst with
//    | [] -> []
//    | [a] -> [a]
//    | a :: lst' -> mergeTest (evenElementsTest lst |> mergeSortTest) (evenElementsTest lst' |> mergeSortTest)    
//printfn "mergeSort = %A " (mergeSort (makeDataList [25.0 ; 10.0; 20.0; 100.0; 30.1; 10.0 ; 100.0; 30.1; 10.0 ; 100.0; 30.1 ])) 
//printfn "mergeSortTest = %A " (mergeSortTest [25.0 ; 10.0; 20.0; 100.0; 30.1; 10.0 ; 100.0; 30.1; 10.0 ; 100.0; 30.1 ])


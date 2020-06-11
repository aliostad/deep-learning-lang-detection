namespace StackVM.Tests

open NUnit.Framework
open StackVM

module Instructions = 
    [<Test>]
    let ``Push 4 pushes 4 on the stack``() = 
        let result = [ Push 4 ] |> Stack.fold Stack.initialState
        Assert.AreEqual(List.head result, 4)
    
    [<Test>]
    let ``Pop removes the head of the stack ``() = 
        let result = [ Pop ] |> Stack.fold [ 4; 3; 7 ]
        Assert.AreEqual(result, [ 3; 7 ])
    
    [<Test>]
    let ``Add calculates the sum of 2 numbers``() = 
        let result = 
            [ Push 4
              Push 3
              Add ]
            |> Stack.fold Stack.initialState
        Assert.AreEqual(List.head result, 7)
    
    [<Test>]
    let ``Subtract subtracts``() = 
        let result = 
            [ Push 4
              Push 3
              Subtract ]
            |> Stack.fold Stack.initialState
        Assert.AreEqual(List.head result, 1)
    
    [<Test>]
    let ``Multiply multiplies``() = 
        let result = 
            [ Push 4
              Push 2
              Multiply ]
            |> Stack.fold Stack.initialState
        Assert.AreEqual(List.head result, 8)
    
    [<Test>]
    let ``Divide divides``() = 
        let result = 
            [ Push 4
              Push 2
              Divide ]
            |> Stack.fold Stack.initialState
        Assert.AreEqual(List.head result, 2)
    
    [<Test>]
    let ``Ignore does nothing``() = 
        let result = [ Ignore ] |> Stack.fold Stack.initialState
        Assert.AreEqual(result, [])
    
    [<Test>]
    let ``Print doesn't modify the stack``() = 
        let result = 
            [ Push 4
              Print ]
            |> Stack.fold Stack.initialState
        Assert.AreEqual(List.head result, 4)
    
    [<Test>]
    let ``Halt stops the stack from being changed further``() = 
        let result = 
            [ Push 40
              Halt
              Push 2 ]
            |> Stack.fold Stack.initialState
        Assert.AreEqual(List.head result, 40)
    
    [<Test>]
    let ``Copy copies the top element of the stack``() = 
        let result = [ Copy ] |> Stack.fold [ 4 ]
        Assert.AreEqual(result, [ 4; 4 ])

module Parser = 
    [<Test>]
    let ``push 6 leads to Push 6 Instruction``() = 
        let result = AssemblyParser.parse [ "push 6" ]
        Assert.AreEqual(List.head result, Push(6))
    
    [<Test>]
    let ``push without a number is ignored``() = 
        let result = AssemblyParser.parse [ "push" ]
        Assert.AreEqual(List.head result, Ignore)
    
    [<Test>]
    let ``print leads to Print Instruction``() = 
        let result = AssemblyParser.parse [ "print" ]
        Assert.AreEqual(List.head result, Print)
    
    [<Test>]
    let ``add leads to Add Instruction``() = 
        let result = AssemblyParser.parse [ "add" ]
        Assert.AreEqual(List.head result, Add)
    
    [<Test>]
    let ``sub leads to Subtract Instruction``() = 
        let result = AssemblyParser.parse [ "sub" ]
        Assert.AreEqual(List.head result, Subtract)
    
    [<Test>]
    let ``mul leads to Multiply Instruction``() = 
        let result = AssemblyParser.parse [ "mul" ]
        Assert.AreEqual(List.head result, Multiply)
    
    [<Test>]
    let ``div leads to Divide Instruction``() = 
        let result = AssemblyParser.parse [ "div" ]
        Assert.AreEqual(List.head result, Divide)
    
    [<Test>]
    let ``pop leads to Pop Instruction``() = 
        let result = AssemblyParser.parse [ "pop" ]
        Assert.AreEqual(List.head result, Pop)
    
    [<Test>]
    let ``halt leads to Halt Instruction``() = 
        let result = AssemblyParser.parse [ "halt" ]
        Assert.AreEqual(List.head result, Halt)
    
    [<Test>]
    let ``copy leads to Copy Insctruction``() = 
        let result = AssemblyParser.parse [ "copy" ]
        Assert.AreEqual(List.head result, Copy)

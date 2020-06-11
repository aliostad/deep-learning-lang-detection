module Sol1

open System.Text
open System.Collections
open System.Collections.Generic;
open System.Linq
open System

let EnumFromBitArray (ba:BitArray) = 
    seq {
            for i in 0..ba.Count-1 do
                yield ba.Get(i)
        }
        
let show (ba:BitArray) =
    let s = new StringBuilder()
    for i in 0..ba.Count-1 do
         ignore( s.Append( (if ba.Get(i)=true then 1 else 0) ))
    s.ToString()

let allvisited (ba:BitArray) = ((EnumFromBitArray ba).All(fun b -> b=true))      
       
let copy (ba:BitArray) = 
    let a = EnumFromBitArray(ba).ToArray()
    new BitArray(a)
    
let index (i,j) n = (i-1)*n + j-1

let moveLeft (i,j) (visited:BitArray) n  =
        if (j>1) then 
            let dest = (i,j-1)
            let x = index dest n
            if (not(visited.[x])) then
                let v = copy visited
                v.Set(x, true)
                [dest,v]
            else
                []
        else 
            []            
    
let moveRight (i,j) (visited:BitArray) n =
        if (j<n) then 
            let dest = (i,j+1)
            let x = index dest n
            if (not(visited.[x])) then
                let v = copy visited
                v.Set(x, true)
                [dest,v]
            else
                []
        else 
            []
            
let moveUp (i,j) (visited:BitArray) n  =
       if (i>1) then 
            let dest = (i-1,j)
            let x = index dest n
            if (not(visited.[x])) then
                let v = copy visited
                v.Set(x, true)
                [dest,v]
            else
                []
        else 
            []
            
let moveDown (i,j) (visited:BitArray) n  =        
        if (i<4) then 
            let dest = (i+1,j)
            let x = index dest n
            if (not(visited.[x])) then
                let v = copy visited
                v.Set(x, true)
                [dest,v]
            else
                []
        else 
            []


   
let alltours sn  =  
    let n = Int32.Parse sn   
    let q = new Queue<(int*int)*BitArray>()
    let mutable count=0
    let mutable visited = new BitArray(4*n,false) 
    count<-0
    visited.Set(0,true)
    q.Enqueue ((1,1),visited)  
    
    while (q.Count>0) do
        let (x,y),v = q.Dequeue()
        if ((x,y) = (4,1)) then
            if allvisited v then    
                count<-count+1                      
        else
            let xs = ((moveLeft (x,y) v n) 
                    @ (moveRight (x,y) v n) 
                    @ (moveUp (x,y) v  n) 
                    @ (moveDown (x,y) v n))                
            for t in xs do
                 q.Enqueue (t)
    count
   

open System.Diagnostics
let executeAndTime f = 
    Console.WriteLine ("Enter x:")
    let sw = Stopwatch.StartNew()
    let res = Console.ReadLine() |> f 
    sw.Stop()
    res.ToString(),sw.Elapsed    
    
let main=
    let res,time=executeAndTime alltours
    printfn "Solution=%s Duration=%s" (res) (time.TotalSeconds.ToString())
    Console.ReadLine()
    
     
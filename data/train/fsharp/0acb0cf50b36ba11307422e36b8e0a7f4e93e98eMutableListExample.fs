module main.MutableListExample
open System.Collections.Generic
open System 
open System.Collections

type MyComparator(x) = 
    member self.x = x 
    interface IComparer<int> with 
       member this.Compare(x:int , y:int):int = 
           x - y

type MutableListExample() = 
    member self.example1() = 
       let numbers = new List<int>()
       numbers.Add 10 
       numbers.Add 20 
       numbers.Add 30 
       numbers.Add 40
       printfn "<<numbers>>"
       numbers.ForEach (fun el -> printf "%d " el) 
       printfn ""

       let names = new List<string>()
       names.Add "foo"
       names.Add "bar"
       names.Add "bim"
       names.Add "pako"
       printfn "<<names>>"
       names.ForEach (fun el-> printf "%s ; " el) 
       printfn ""
       
       let doubleNumbers = new List<double>()
       doubleNumbers.Add 10.0
       doubleNumbers.Add 20.0
       doubleNumbers.Add 30.0
       doubleNumbers.Add 40.0
       printfn "<<doubleNumbers>>"
       doubleNumbers.ForEach (fun el -> printf "%.2f ; " el)
       printfn ""
       let count = numbers.Count
       let capacity = numbers.Capacity
       let item_0 = numbers.Item 0 
       printfn "count = %d" count 
       printfn "capacity = %d" capacity 
       printfn "item 0 = %d" item_0


    member self.copyList(source:List<int>) :List<int> = 
        let res:List<int> = new List<int>()
        source.ForEach (fun el -> res.Add(el))
        res     

//Add
//AddRange
//AsReadOnly
//BinarySearch(T)
//BinarySearch(T, IComparer(T))
//BinarySearch(Int32, Int32, T, IComparer(T))
//Clear
//Contains
//ConvertAll(TOutput)
//CopyTo(T[])
//CopyTo(T[], Int32)
//CopyTo(Int32, T[], Int32, Int32)
//Equals(Object)
//Exists
//Finalize
//Find
//FindAll
//FindIndex(Predicate(T))
//FindIndex(Int32, Predicate(T))
//FindIndex(Int32, Int32, Predicate(T))
//FindLast
//FindLastIndex(Predicate(T))
//FindLastIndex(Int32, Predicate(T))
//FindLastIndex(Int32, Int32, Predicate(T))
//ForEach
//GetEnumerator
//GetHashCode
//GetRange
//GetType
//IndexOf(T)
//IndexOf(T, Int32)
//IndexOf(T, Int32, Int32)
//Insert
//InsertRange
//LastIndexOf(T)
//LastIndexOf(T, Int32)
//LastIndexOf(T, Int32, Int32)
//MemberwiseClone
//Remove
//RemoveAll
//RemoveAt
//RemoveRange
//Reverse()
//Reverse(Int32, Int32)
//Sort()
//Sort(Comparison(T))
//Sort(IComparer(T))
//Sort(Int32, Int32, IComparer(T))
//ToArray
//ToString
//TrimExcess
//TrueForAll
    member self.example2() = 
       let l1:List<int> = new List<int>()
       l1.Add 10 
       l1.Add 20 
       l1.Add 30 
       l1.Add 40 
       l1.Add 50 
       let copyAdd = self.copyList l1 
       copyAdd.Add 60 
       let copyAddRange = self.copyList l1 
       copyAddRange.AddRange [60;70;80;90]
       let asReadOnly = l1.AsReadOnly()
       let binarySearch = l1.BinarySearch 20 
       let binarySearch2 = l1.BinarySearch (20, new MyComparator("x"))
       let binarySearch3 = l1.BinarySearch (0, 3 , 20 , new MyComparator("x"))
       let copyClear:List<int> = self.copyList l1 
       copyClear.Clear()
       let contains = l1.Contains 10 
       let convertAll = l1.ConvertAll (fun el-> el*el)
       let copyTo = Array.zeroCreate l1.Count
       l1.CopyTo copyTo 
       let copyTo2 = Array.zeroCreate (l1.Count + 1) 
       l1.CopyTo(copyTo2,1) 
       let copyTo3 = Array.zeroCreate 3 
       l1.CopyTo(1, copyTo3 , 0, 3) 
       let equals = l1.Equals l1
       printfn "add = %A" copyAdd
       printfn "addRange = %A" copyAddRange
       printfn "asReadOnly = %A" asReadOnly
       printfn "binarySearch = %A" binarySearch
       printfn "binarySearch2 = %A" binarySearch2
       printfn "binarySearch3 = %A" binarySearch3
       printfn "clear = %A" copyClear
       printfn "contains = %A" contains 
       printfn "convertAll = %A" convertAll
       printfn "copyTo = %A" copyTo 
       printfn "copyTo2 = %A" copyTo2
       printfn "copyTo3 = %A" copyTo3
       printfn "equals = %A" equals 
       let find = l1.Find (fun el -> el % 2 = 0)
       let findAll = l1.FindAll (fun el -> el % 2 = 0) 
       let findIndex = l1.FindIndex (fun el -> el % 2 = 0) 
       let findIndex2 = l1.FindIndex (0,(fun el -> el % 2 = 0))
       let findIndex3 = l1.FindIndex(0, 3 , (fun el -> el % 2 = 0))
       let findLast = l1.FindLast (fun el -> el % 2 = 0) 
       let findLastIndex = l1.FindLastIndex (fun el -> el % 2 = 0) 
       let findLastIndex2 = l1.FindLastIndex (0, (fun el -> el % 2 = 0))
       let findLastIndex3 = l1.FindLastIndex (0, 1, (fun el -> el % 2 = 0))
       printfn "find = %A" find 
       printfn "findAll = %A" findAll
       printfn "findIndex = %A" findIndex 
       printfn "findIndex2 = %A" findIndex2 
       printfn "findIndex3 = %A" findIndex3 
       printfn "findLast = %A" findLast 
       printfn "findLastIndex = %A" findLastIndex 
       printfn "findLastIndex2 = %A" findLastIndex2 
       printfn "findLastIndex3 = %A" findLastIndex3
       let enumerator = l1.GetEnumerator()
       let hashCode = l1.GetHashCode()
       let getType = l1.GetType()
       let indexOf = l1.IndexOf(30 , 1) 
       let indexOf2 = l1.IndexOf(30, 1, 4) 
       let copyInsert:List<int> = self.copyList l1 
       copyInsert.Insert(0, 666) 
       let copyInsertRange = self.copyList l1 
       copyInsertRange.InsertRange(1, [6;66;666;6666])
       let lastIndexOf = l1.LastIndexOf 10 
       let lastIndexOf2 = l1.LastIndexOf(30 , 1) 
       let lastIndexOf3 = l1.LastIndexOf(30, 1, 2) 
       let copyRemove:List<int> = self.copyList l1 
       copyRemove.Remove 10 
       let copyRemoveAll:List<int> = self.copyList l1 
       copyRemoveAll.RemoveAll (fun el -> el % 2 = 0)
       let copyRemoveRange:List<int> = self.copyList l1 
       copyRemoveRange.RemoveRange(1, 3) 
       printfn "enumerator = %A" enumerator 
       printfn "hashCode = %A" hashCode 
       printfn "getType = %A" getType 
       printfn "indexOf = %A" indexOf 
       printfn "indexOf2 = %A" indexOf2 
       printfn "insert = %A" copyInsert 
       printfn "insertRange = %A" copyInsertRange
       printfn "lastIndexOf = %A" lastIndexOf
       printfn "lastIndexOf2 = %A" lastIndexOf2 
       printfn "lastIndexOf3 = %A" lastIndexOf3
       printfn "remove = %A" copyRemove 
       printfn "removeAll = %A" copyRemoveAll
       printfn "removeRange = %A" copyRemoveRange
       let copyReverse:List<int> = self.copyList l1 
       copyReverse.Reverse()
       let copySort:List<int> = self.copyList l1 
       copySort.Sort()
       let copySort2 = self.copyList l1 
       copySort2.Sort (fun el1 el2 -> el1 - el2) 
       let copySort3 = self.copyList l1 
       copySort3.Sort (0, copySort3.Count , new MyComparator("x"))
       let toArray = l1.ToArray()
       let toString = l1.ToString()
       let copyTrimExcess = self.copyList l1 
       copyTrimExcess.TrimExcess()
       let trueForAll = l1.TrueForAll (fun el-> el % 2 = 0)
       printfn "reverse = %A" copyReverse
       printfn "sort = %A" copySort 
       printfn "sort2 = %A" copySort2 
       printfn "sort3 = %A" copySort3 
       printfn "toArray = %A" toArray
       printfn "toString = %A" toString
       printfn "trimExcess = %A" copyTrimExcess
       printfn "trueForAll = %A" trueForAll
       printfn "<<forEach>>" 
       l1.ForEach (fun el -> printf "%d ; " el) 
       printfn ""
       

      
       

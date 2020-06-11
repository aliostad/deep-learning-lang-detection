module main.MutableDictionaryExample

open System 
open System.Collections.Generic

type MutableDictionaryExample() = 
    member self.example1() = 
       let d1 = new Dictionary<string,int>()
       d1.Add("foo", 10) 
       d1.Add("bar", 20) 
       d1.Add("bim", 30)
       d1.Add("pako", 40) 

       printfn "d1 = %A" d1 
       printfn "d1 comparer = %A" (d1.Comparer) 
       printfn "d1 count = %A" (d1.Count)
       printfn "d1 item foo = %A" (d1.Item("foo"))
       printfn "d1 Keys = %A" (d1.Keys)
       printfn "d1 Values = %A" (d1.Values)




    member self.copyDictionary(dict:Dictionary<string,int>): Dictionary<string,int> = 
        let ret = new Dictionary<string,int>()
        for entry in dict do 
            ret.Add((entry.Key), (entry.Value))
        ret 

//Add
//Clear
//ContainsKey
//ContainsValue
//Equals(Object)
//GetEnumerator
//GetHashCode
//GetObjectData
//GetType
//Remove
//ToString
//TryGetValue
    member self.example2() = 
       let add = new Dictionary<string,int>()
       add.Add("foo", 10) 
       add.Add("bar", 20) 
       add.Add("bim", 30)
       add.Add("pako", 40) 
       let copyClear = self.copyDictionary add 
       copyClear.Clear()
       let containsKey_foo = add.ContainsKey("foo")
       let containsKey_edutilos = add.ContainsKey("edutilos")
       let containsValue_10 = add.ContainsValue(10)
       let containsValue_100 = add.ContainsValue(100)
       let equals = add.Equals add 
       let mutable enumerator = add.GetEnumerator()
       let hashCode = add.GetHashCode()
       let getType = add.GetType()
       let copyRemove = self.copyDictionary add 
       copyRemove.Remove("foo")
       let toString = add.ToString()
       let value = 0 
       let tryGetValue = add.TryGetValue("foo", ref  value)
       printfn "add = %A" add 
       printfn "clear = %A" copyClear
       printfn "containsKey foo = %A" containsKey_foo
       printfn "containsKey edutilos = %A" containsKey_edutilos 
       printfn "containsValue 10 = %A" containsValue_10 
       printfn "containsValue 100 = %A" containsValue_100
       printfn "equals = %A" equals 
       printfn "<<enumerator>>" 
       while (enumerator.MoveNext()) do 
          printfn "%A" (enumerator.Current)

       printfn "hashCode = %A" hashCode 
       printfn "getType = %A" getType 
       printfn "remove = %A" copyRemove 
       printfn "toString = %A" toString 
       printfn "tryGetValue = %A" value 

           


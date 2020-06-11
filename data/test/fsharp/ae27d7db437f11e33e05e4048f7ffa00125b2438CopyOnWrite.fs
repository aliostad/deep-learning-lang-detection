
module CopyOnWrite
    
    open BenchUtils

    type quantity = { quantity : int }
    type price = { price : float } 

    type commandLine = { itemName : string ; 
                         itemQuantity : quantity ; 
                         itemPrice : price }

    let testCopyOnWrite () = 
        let l1 = { itemName = "Raspberry" ; 
                   itemQuantity = { quantity = 1 } ; 
                   itemPrice = { price = 4.99 } }
        
        let l2 = { l1 with itemName = "Apple" }
        
        let b1 = System.Object.ReferenceEquals(l1.itemName,l2.itemName)
        let b2 = System.Object.ReferenceEquals(l1.itemQuantity,l2.itemQuantity)
        let b3 = System.Object.ReferenceEquals(l1.itemPrice,l2.itemPrice) 
        let lines = ("itemName"::"true"::b1.ToString()::[])::("itemQuantity"::"false"::b2.ToString()::[])::("itemPrice"::"false"::b3.ToString()::[])::[]

        let header = "Field name"::"Have been changed"::"is Field equal"::[]
        ResultFormater.formatResult 1 1 "-" "|" header lines

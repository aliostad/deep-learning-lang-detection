let ar = [|15..-1..1|]

let counters = Array.zeroCreate<int> 32
for elem in ar do
    for i=0 to 31 do
        let mask = 1 <<< i
        let c = if elem &&& mask <> 0 then 1 else 0
        counters.[i] <- counters.[i]+c

let mutable sorted_ar = ar |> Array.copy
let mutable sorted_ar2 = ar |> Array.copy

for i=0 to 31 do
    let mutable s1 = 0
    let mutable s2 = counters.[i]-1
    for elem in sorted_ar do
        let mask = 1 <<< i
        if elem &&& mask = 0 then 
            sorted_ar2.[s1] <- elem 
            s1 <- s1+1
         else 
            sorted_ar2.[s2] <- elem
            s2 <- s2+1
    sorted_ar <- Array.copy sorted_ar2

    
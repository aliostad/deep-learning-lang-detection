namespace CodeJam
open CodeJam.Utils
open System



// https://code.google.com/codejam/contest/2418487/dashboard#s=p0
module Bullseye = 

    // paint needed to cover a ring starting at r
    let paint (r: bigint) = 
        // ((r+1I) * (r+1I) - r * r) = r**2 + 2*r + 1 - r**2 
        // paint(n+1) - paint(n) = 2n+2+1 - 2n-1 = 2
        2I * r + 1I

    let count (r: bigint) (t: bigint) = 
        let rec loop n t = 
            let p = paint (r + 2I*n)
            if t < p then n else loop (n+1I) (t-p)
        loop 0I t

    let calculate (r: bigint) (t: bigint) = 
        // every new ring needs +4 than the one before
        // S = (a1 + a1+(n-1)*4)/2 * n = 2*n**2 + (a1-2)*n
        let a1 = paint r 
        let d = a1*a1 - 4I*a1 + 4I + 8I*t
        // cannot use double due to rounding errors
        let n = (2I - a1 + Numerics.sqrti(d)) / 4I
        n
        
    let solve fn = 
        solveFile fn (fun line ->
            let [|r;t|] = line |> splitSpaces |> Array.map (fun x -> bigint.Parse(x))
            calculate r t |> string)

    // CodeJam.Bullseye.solve "bullseye-sample-practice.in"
    // CodeJam.Bullseye.solve "bullseye-small-practice.in"
    // CodeJam.Bullseye.solve "bullseye-large-practice.in"


// https://code.google.com/codejam/contest/2418487/dashboard#s=p1
module ManageYourEnergy = 

    // maximum gain
    let gain E R V = 
        let maxi = (V |> Array.length) - 1
        // calculate maximum gain from task i with e energy to spend on them
        let rec maxgain = memoize <| fun (i, e) ->  
            if i = maxi then
                V.[i] * e, [e]
            else                     
                // find the first point where we lose more from the rest than we gain from this
                let rec loop j (bg, bj) = 
                    if j > e then 
                        bg, bj
                    else
                        let g = V.[i] * j
                        let e' = min E (e - j + R)
                        let gr, jr = maxgain (i+1, e')
                        if g + gr < bg then
                            bg, bj
                        else
                            loop (j+1L) (g+gr, j::jr)

                // maximum from the rest if we spend 0 here
                let e' = min E (e + R)
                let mg, mj = maxgain (i+1, e')
                loop 1L (mg, 0L::mj)

        let best = maxgain (0, E)
        // printfn "%A" (snd best)
        fst best


    let solve fn = 
        solveFile2 fn (fun lines ->
            let [|l1;l2|] = lines |> splitLines
            let [|E;R;_|] = l1 |> splitSpaces |> Array.map int64
            let V = l2 |> splitSpaces |> Array.map int64
            gain E R V |> string)


    // CodeJam.ManageYourEnergy.solve "manageyourenergy-sample.in"
    // CodeJam.ManageYourEnergy.solve "manageyourenergy-small-practice.in"


    // gain 9174849L 3990053L [|9029186L;6768994L|]
    // gain 3646321L 205998L [|9123315L;8377335L;3886394L|]


// https://code.google.com/codejam/contest/2418487/dashboard#s=p2
module GoodLuck = 

    // find out if p is a product of any subset of ns
    let isProductOf ns (p: int64) = 
        let rec loop ns p = 
            match ns, p with
            | _, p when p = 1L -> 
                true
            | [], _ -> 
                false
            | h::t, p when p % h = 0L ->
                loop t (p/h) || loop t p
            | _::t, p -> 
                loop t p
        loop ns p

    // [9L;4L;36L;1L] |> List.forall (isProductOf [3L;4L;3L])

    let rnd = new Random()

    // get N random numbers between 2 and M
    let randoms n m = seq {
        while true do
            yield Array.init n (fun _ -> rnd.Next(2, m+1) |> int64)
        }   

    // generate all unique possibilities
    let generate N M = 
        let rec loop n m = seq {
            if n = 1 then
                for i in m .. M do
                    yield [int64 i]
            else
                for i in m .. M do                    
                    for g in loop (n-1) i do
                        yield (int64 i)::g                    
        }
        loop N 2 |> Seq.map Array.ofList


    let rec fact n = if n = 1L then 1L else n * fact(n-1L)

    // number of unique combinations of size k from n different elements with replacement
    let CWR n k = 
        // (n + k - 1)! / (k! * (n-1)!)        
        fact (n+k-1L) / fact k / fact (n-1L)       
    
    // assertEqual (CWR (5L-1L) 3L) 20L "CWR"
    // assertEqual (generate 3 5 |> Seq.length) 20 "generate"
    
    // frequency of a given combination in all the possibilities
    let freq N M (ns: int64[]) = 
        // all the different variations we can get using 2 .. M in N places = pown ((int64 M)-1L) N
        // number of ways to arrange N items 
        let arrangements = fact (int64 N)
        // we have to cancel the permutations of every digit
        let digits = ns |> Seq.countBy id
        let deduplicate  = digits 
                        |> Seq.map (fun (d, c) -> fact (int64 c)) 
                        |> Seq.fold (fun p f -> p * f) 1L        
        arrangements / deduplicate

    // assertEqual (freq 3 5 [3L;3L;3L]) 1L "freq"
    // assertEqual (freq 3 5 [2L;3L;4L]) 6L "freq"

    // generate the highest probability candidates first
    let candidates N M = 
        generate N M |> Seq.sortBy (fun lst -> -(freq N M lst))
    
    // find N random numbers between 2 and M that can explain all products
    let guess cands ps = 
        cands |> Seq.find (fun r ->
                    let ns = r |> Array.toList
                    ps |> Array.forall (isProductOf ns))            

    // guess (randoms 3 5) [|9L;4L;36L;1L|]
    // guess (randoms 3 5) [|1L;1L;1L;1L|]


    let solve fn = 

        let partitioner = caseByDynWithHeader (fun line -> 
            (line |> splitSpaces).[0] |> int)

        solveFileBy partitioner fn <| fun data ->
            let lines = data |> splitLines
            let toArr = splitSpaces >> Array.map int64
            let [|R;N;M;K|] = lines.[0] |> toArr
            let cases = lines.[1 ..] |> Array.map toArr
            // go by the most probable first
            let cands = candidates (int N) (int M) |> List.ofSeq // (randoms (int N) (int M))
            let guesses = cases |> Array.map (guess cands)
            // output one big string
            sprintf "\n%s" (guesses |> Array.map (fun guess -> String.Join("", guess)) |> joinLines)

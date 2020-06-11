//Implements the theory from 'How to write a financial contract' by S.L Peyton Jones 
//and J-M Eber

type RandomVariable<'a> = seq<'a>

type Process<'a> = Process of (seq<RandomVariable<'a>>)
    
let liftP f (Process(p)) =  Process(Seq.map (Seq.map f) p)
    
let liftP2 f (Process(p1)) (Process(p2)) = 
    Process(Seq.map2 (Seq.map2 f) p1 p2) 
    
let seq_map3 f xs1 xs2 xs3 = 
  Seq.zip3 xs1 xs2 xs3 |> Seq.map (fun (a,b,c) -> f a b c)    
    
let liftP3 f (Process(p1)) (Process(p2)) (Process(p3))= 
    Process(seq_map3 (seq_map3 f) p1 p2 p3)     

type Obs<'a when 'a :comparison> = Obs of (float -> Process<'a>)

type Currency = 
    |USD 
    |EUR
    |JPY 
    |GBP 

type Contract = 
    | Zero
    | One of Currency
    | Give of Contract
    | And of Contract * Contract
    | Or of Contract * Contract
    | Scale of float Obs * Contract 
    | Anytime of bool Obs * Contract 
    | Cond of bool Obs * Contract * Contract 
    | When of bool Obs * Contract //<--
    | Until of bool Obs * Contract

let when' o c = When(o,c)
let anytime o c = Anytime(o,c)

let rec always x = seq { yield x; yield! always x}

let K x = Process  (always (always x))
let konst a = Obs (fun t -> K a) 
let scaleK x c = Scale ((konst x), c)

let TempInParis = konst 9.7

let rec generate_time t = seq{ yield always t ; yield! generate_time (t + 1.) }

let date = Obs (fun t -> Process(generate_time 0.) )

let lift  f (Obs (o)) = Obs (fun t -> liftP f (o t))
let lift2 f (Obs(o1)) (Obs(o2)) = Obs(fun t -> liftP2 f (o1 t) (o2 t) )

let eq_obs a b = a = b

let at (t:float) = lift2 (fun x y -> eq_obs x y) date (konst t)

let zcb t x k = when' (at t) (scaleK x (One k)) //Zero Coupon Bond

let european t u = when' (at t) (Or(u,Zero))

let (%>=) a b = lift2 (>=) a b
let (%<=) a b = lift2 (<=) a b

let between t1 t2 = lift2 (&&) (date %>= t1) (date %<= t2)

let american (t1, t2) u = anytime (between t1 t2) u

let oneBuck = One USD;;
let hundredBucks = Scale((konst 100.),oneBuck);;

let add_obs = liftP2 (+) 
let (%+) = liftP2 (+) 
let minus_obs = liftP2 (-)
let (%-) = liftP2 (-) 
let mult_obs = liftP2 (*) 
let (%*) = liftP2 (*) 
let div_obs = liftP2 (/) 
let (%/) = liftP2 (/) 
let (~-) = liftP (~-)
let max = liftP2 max

let cond = liftP3 (fun b tru fal -> if b then tru else fal)

type Model  = 
    abstract exch  : (Currency -> Currency -> Process<float>)
    abstract disc  : (Currency -> Process<bool>*Process<float> -> Process<float>)
    abstract snell : (Currency -> Process<bool>*Process<float> -> Process<float>)
    abstract absorb: (Currency -> Process<bool>*Process<float> -> Process<float>)

let evalO (Obs(o)) = o 0.

let ff = evalO TempInParis

let rec evalC (m:Model) (cur:Currency) (c:Contract)    =
    let evalC' = evalC m cur
    match c with 
    | Zero -> K 0.
    | One(cur2)  -> m.exch cur cur2 
    | Give(c1)   -> -(evalC' c1) 
    | Scale(o,c1) -> mult_obs (evalO o) (evalC' c1)
    | And(c2,c1) -> add_obs (evalC' c1) (evalC' c2)
    | Or(c2,c1) -> max (evalC' c1) (evalC' c2)
    | Cond(o,c1,c2) -> cond (evalO o) (evalC' c1) (evalC' c2)
    | When(o,c1) -> m.disc cur ((evalO o), (evalC' c1))
    | Anytime(o,c1) -> m.snell cur ((evalO o), (evalC' c1))
    | Until(o,c1) -> m.absorb cur ((evalO o), (evalC' c1))
    
    
let rates (rateNow:float) (delta:float) = 
    
    let rec generateSlice minRate n =  
        seq { yield minRate + 2.*delta*float(n); yield! generateSlice minRate (n+1) }
    
    let rateSlice minRate n = Seq.take n (generateSlice minRate 0)
    
    let rec makeRateSlices rateNow n = 
        seq { 
            yield (rateSlice rateNow n) ; 
            yield! (makeRateSlices (rateNow-delta) (n+1))}
    
    Process(makeRateSlices rateNow 1)
    

open System.Collections.Generic
    
let rateModels = new Dictionary<Currency,Process<float>>()

Seq.iter (fun x -> rateModels.Add x) [ 
    USD, rates 7. 1.; 
    EUR, rates 6. 1.; 
    JPY, rates 8. 1.; 
    GBP, rates 5. 1.; 
    ] 
    
let rateModel k = 
    match rateModels.TryGetValue(k) with
    | true, p -> p
    | _   , _ -> failwith "invalid currency"
    
let unProc (Process(s)) = s

let rec prevSlice (r:seq<float>) = 
  seq {
            if not (Seq.isEmpty r) then 
                let rest = Seq.skip 1 r
                if not (Seq.isEmpty rest) then 
                
                    let a = Seq.head r
                    let b = Seq.head rest
                                                                    
                    yield ((a + b)/2.)
                
                    yield! prevSlice rest
        
    }
    
let rec discCalc (pb:seq<RandomVariable<bool>>) (pf:seq<RandomVariable<float>>) 
        (rates:seq<RandomVariable<float>>) = 
    seq{
        if not(Seq.isEmpty pb || Seq.isEmpty pf || Seq.isEmpty rates) then
            
            let bRv = Seq.head pb
            let pRv = Seq.head pf
            
            //-- we need a termination condition or as much as it is needed to ensure a level of certainty                       
            if Seq.forall (fun x -> x) (Seq.truncate 10 bRv)   
            then 
                yield pRv
            else
                let rateRv = Seq.head rates
            
                let bs = Seq.skip 1 pb
                let ps = Seq.skip 1 pf
                let rs = Seq.skip 1 rates
                
                let rest = discCalc bs ps rs; 
                
                if not(Seq.isEmpty rest) then
                
                    let nextSlice = Seq.head rest
                    
                    let discSlice = 
                        Seq.map2 (fun x r -> x / (1. + (r/100.))) (prevSlice nextSlice) rateRv
                                        
                    let thisSlice = 
                        seq_map3 (fun b p q -> if b then p else q) bRv pRv discSlice
                    
                    yield thisSlice; yield! rest
    }

let disc k (Process(pb),Process(pf)) = 
    Process(discCalc pb pf (unProc(rateModel k)))

let model = {
    new Model with
        member m.exch   = fun cur1 cur2    -> K 1.
        member m.disc   = disc
        member m.snell  = fun cur1 (pb,pf) -> K 0.5//--
        member m.absorb = 
            fun k (Process(bO),Process(rvs)) -> 
                    Process(Seq.map2 (Seq.map2 (fun o p -> if o then 0. else p)) bO rvs)
}

let GiltStrip = zcb 3.0 10. GBP

let q = evalC model GBP GiltStrip

printf "%A\n" q

printf "%A\n" (evalO (at 3.0))
printf "%A\n" (evalO (date))
printf "%A\n" (rateModel GBP)

// FUNZIONI RICORSIVE

//  gcd : int * int -> int
// gcd (m,n) =  MCD(m,n), dove m >= 0 e n >= 0 

let rec gcd (m,n) =
    match (m,n)  with
        | (0,n) -> n
        | (m,n) -> gcd (n % m, m)


// simplify : int * int -> int * int
(*  Dati due interi a >= 0 e  b>0, simplify semplifica la frazione a/b
    Piu' precisamente, simplify (a,b) = (c,d) se e solo se
    c/d e' la frazione ottenuta semplificando  a/b

*)

let simplify ( a , b ) =
    let m = gcd (a,b)
    ( a / m , b / m)

// copy: string * int -> string
// copy (str,n) genera la stringa contenente n copie di str (n>=1)

let rec copy (str:string ,n) =
    match n with
        | 1 -> str
        | _ -> str + copy (str, n-1)


// sum1 : int -> int
// dato n >= 0,  calcola la somma  dei numeri compresi  fra 0 e n

let rec sum1 n =
    match n with
        | 0 -> 0
        | _ -> n + sum1 (n-1)


// sum2 : int * int -> int
(*
   Dati m e n tali che n >= m >= 0,
  calcola la somma dei numeri compresi fra m e n       
*)

let rec sum2 (m,n) =
    match n-m with
        | 0  -> n 
        | _ -> m + sum2  (m+1 ,n  )


//  fib : int -> int
// dato n >= 0, fib n e' l' n-esimo  numero di Fibonacci      

let rec fib m =
    match m with
        | 0 ->  0
        | 1 -> 1 
        | n  ->  fib (n-1) + fib ( n-2 )
            





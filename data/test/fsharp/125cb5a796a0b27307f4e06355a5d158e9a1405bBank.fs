module Bank

(* multiQAPs *)

// mirroring geppetto.h
let TOP_LEVEL = -1 
let mutable bootstrap = false
let state_function() = Val.Native.Global((if bootstrap then "@STATE_BOOT" else "@STATE"),0)
let state_instance() = Val.Native.Global((if bootstrap then "@STATE_BOOT" else "@STATE"),1)

let tmax = 100 // maximal number of dynamic instances of any given bank in a compound proof

/// scheduled task for each bank instance:
type verifierTask = 
  | Recommit     // the verifier recommits
  | LoadRecommit // the prover saves values; the verifier loads and recommits
  | VerifyCommit // the prover just send the commiment; the verifier verifies it -- the default.
  // bank processing also depends on shared, which determines whether it is a "bus" or a "full bank"

/// for each named bank that we compile, we record: 
[<CustomEquality;CustomComparison>]
type b = 
  { // cType : LLVM.typ // source type, determining the size of the arrays below 

    // static record, when compiling
    name  : string
    index : int            // ordering index
    mutable shared: bool   // do we allocate equations for sharing commitments on these banks? 
    mutable root0: int     // first root for sharing commitments 
    mutable mQAPindex: int // bank index in the mQAP
    spec  : QAP.Semantics.t array 
                           // compile-time size, semantics, and ranges           
    
    // bank instances, when proving & verifying
    // CLI-based: we re-use the last values opportunistically
    value : Val.Run.v array                                   // prove-time assignment, used to build messages & commitments
    mutable commit: (Field.t array * Proof.commitment) option // last committed values, possibly re-used (memory leak?) 
    mutable vcommit: Proof.commitment option                  // last commitment recomputed or verified

    // whole-program: we manage multiple instances indexed by t (with t=0 meaning all zeros)
    mutable task    : Map<int, verifierTask>     //[t] verifier task (as recorded in the program trace)    
    mutable values  : Map<int, Field.t array>    //[t] saved values for the bank, or [||] when unsaved yet.
    mutable proved  : Map<int, Proof.commitment> //[t] prover's commitments to the tasks 
    mutable verified: Map<int, Proof.commitment> //[t] verifier's validated commitments to the tasks
  }
  // we normalize the order of banks between all function: 
  // first public, then shared, then (implicitly) locals
  interface System.IComparable with
    member b0.CompareTo v1 = 
      let b1 = match v1 with :? b as b1 -> b1 | _ -> failwith "bank comparison"         
      match b0.shared, b1.shared with
      | false, true -> -1
      | true, false ->  1
      | _           -> compare b0.index b1.index
  override b.Equals v = failwith "unused"
  override b.GetHashCode() = b.index

// prove-time log of bank operations for the current outsourced function 
// (in evaluation order); relocate?
let mutable outsourced : List<string * int> = []
let private value (b:b) = snd (List.find (fun (n,t) -> n = b.name) outsourced)

/// arguments of outsourced calls (CLI)
type v = 
  | Bank of b
  | Cfg of Val.Native.t array // using mutability (we could support fancier data structures) 

/// outsourced function
type f = { 
    name  : string 
    args  : int array list  // compile-time arguments; could be Val.Run.v array 
    banks : b array         // all banks accessed by the function, sorted: public then shared
    qap   : QAP.t
    kb    : Map<string,int> // for each bank, local index of its first variable
    mutable k0: int         // index of the first bank for this function in the mQAP

    // caching evidence from proving to verifying
    mutable c0: Proof.commitment // prover-only cached "unit" commitment (lots of coefficients) 
    mutable proof: Map<int, Proof.commitment * Proof.proof> // indexed by dynamic outsourced run
  }


/// global compiler state
type state = { 
    mutable banks    : Map<string,b>  // declared banks
    mutable functions: f list         // compiled functions (in compilation order)
    mutable ek       : Proof.Prove.key option 
    mutable vk       : Proof.Verify.key option
    mutable banksize : int
  }
  
let s : state = { 
    banks     = Map.empty
    functions = []
    ek        = None
    vk        = None 
    banksize  = 0
  } 

let clear s = 
    VM.code     <- []
    s.banks     <- Map.empty
    s.functions <- []
    s.ek        <- None
    s.vk        <- None 
    s.banksize  <- 0

let prefix = if Lib.w then "%struct.Bank_" else "%struct.bank_"
let bankSize n =
  let bt = VM.Code.findTypeDef (prefix + n) 
  let t = 
    if Lib.w then
      match bt with
      | LLVM.Struct [LLVM.Int 32; t] ->  t
      | t -> failwithf "not a bank representation %A" t
    else bt
  VM.Code.tSize t 

let bank' n = 
  let size = bankSize n
  { name  = n
    index = s.banks.Count
    shared = false
    spec  = Array.create size QAP.Semantics.int32 // should add support for field elements
    value = Array.create size Val.Run.Void 
    root0 = 0
    mQAPindex = 0
    commit = None
    vcommit = None

    task     = Map.empty
    values   = Map.empty
    proved   = Map.empty
    verified = Map.empty
  }

let bank n = 
  match s.banks.TryFind n with
  | Some b -> b 
  | None   -> let b = bank' n in s.banks <- s.banks.Add(n,b); b

// In outsourced function signatures, 
// the bank type b is a pointer to a struct prefix + b

let of_type typ =  
   match typ with 
   | LLVM.Ptr(LLVM.Tvar n) when n.StartsWith prefix -> Some(bank (n.Substring prefix.Length))
   | _ -> None


// We keep a single, "latest" value for each bank.
// We recompute the commitment only when a local run updates it.
// For the verifier, what is reused should follow from the sequence of verified runs. 
// TODO better tracking of ranges in banks (often no need to truncate intermediates)

/// number of local witnesses for that function (could be stored)
let rho (f:f) =
  let banked = Array.fold (fun a b -> a + b.spec.Length) 0 f.banks 
  f.qap.nWire - 1 - banked


/// KEYGEN:
/// smash all local mQAPs into a single one with bank sharing
/// generate keys for VCing the compiled functions 


// printing C declarations for bootstrapping with encoding-qap.c

let mutable file : System.IO.StreamWriter = null

let definePreamble suffix = 
  match Lib.emit with
  | Some name -> 
        file <-  new System.IO.StreamWriter(name + "." + suffix)
        fprintfn file "// mQAP compiled from %d functions on %d banks at %A" s.functions.Length s.banks.Count System.DateTime.Now 
  | _ -> ()


let mutable nrecomp = 0 
let mutable lrecomp = 0
    
let defineBank name index length recomputable recomputed =
  if Lib.emit <> None then
    let n = name + String.replicate (max 0 (20 - name.Length)) " "
    fprintfn   file "\n#define C_%s %6d // bank index %s" n index (if recomputable then "" else "(not recomputable)")
    if recomputable then
      fprintfn file "#define R_%s %6d // bank index among recomputable banks" n nrecomp 
      fprintfn file "#define O_%s %6d // offset for this bank" n lrecomp
      fprintfn file "#define L_%s %6d // length for this bank" n length 
      nrecomp <- nrecomp + 1;
      lrecomp <- lrecomp + length
    match recomputed with 
    | Some (ts : Map<int,verifierTask>) -> 
        // we add a trailing -1 to avoid a special all-zero clang optimization... 
        let vs = Array.init (ts.Count + 1) (fun i -> if i = ts.Count then "-1" else if ts.[i+1] = VerifyCommit then "0" else "1") 
        fprintfn file "#define V_%s  { %s } // instances actually recomputed, indexed by t - 1" n (String.concat ", " vs)
    | None -> () 

  // This is relying on geppetto.h -DVERIFY (either native of bootstrap) 
  // with banks whose representation carries the bank index (t) and an optional, trusted commitment (c)
  // The updates to outsource_id and function_id should be done by Enter and Exit, as before.
 
let defineVerify (f:f) = 
    // we go through f signature all over again... 
    let resultType, formals, body = VM.Code.findFunDef ("@"+f.name)
    let actuals = 
      List.map 
        (fun (t,name) -> 
          match t with 
            | LLVM.Ptr(LLVM.Tvar n) when n.StartsWith prefix -> bank (n.Substring (prefix.Length))
            | _                                              -> failwithf "argument type %A" t )
        formals  
    let result =  
          match resultType with  
            | LLVM.Ptr(LLVM.Tvar n) when n.StartsWith prefix -> bank (n.Substring (prefix.Length))
            | _                                              -> failwith "result mandatory"
    let bi = actuals.Length
    let nc = f.banks.Length + 2
    let args = String.concat ", " ("int outsource_id" :: List.mapi (fun i (b:b) -> b.name + " b" + string i) actuals)
    fprintfn file @"%s Verify_%s(%s) {                                     " result.name f.name args 
    fprintfn file @"    cCommitment cs[%d];                                " nc // unit + locals + named banks 
    fprintfn file @"    for (int j = 0; j < %d; j++) init_commit(&cs[j]);  " nc
    fprintfn file @"    %s b%d = recommit_verify_%s();                     " result.name bi result.name
    fprintfn file @"    // reuse previous commitments                      "
    List.iteri (fun i b -> 
      fprintfn file 
                  @"    cs[%d] = b%d->c;" i i) (actuals @ [result])
    fprintfn file @"    // recompute the unit commitment"
    fprintfn file @"    int one = 1;"
    fprintfn file @"    compute_commit(&STATE.vk, &cs[%d], C_%s_UNIT, R_%s_UNIT, &one, O_%s_UNIT, 1);" (nc - 2) f.name f.name f.name
    fprintfn file @"    // verify the local commitments"
    fprintfn file @"    load_cCommitment(%s, &cs[%d], outsource_id, RUN_TIME); " ("\"" + f.name + "-locals\"") (nc - 1)
    fprintfn file @"    STATE.ok *= verify_commit(&STATE.vk, &cs[%d], C_%s_LOCALS);" (nc - 1) f.name 
    fprintfn file @"    // verify the proof"
    fprintfn file @"    cProof pi;"
    fprintfn file @"    load_cProof(%s, &pi, outsource_id, RUN_TIME);" ("\"" + f.name + "\"")
    fprintfn file @"    STATE.ok *= verify_proof(&STATE.vk, &pi, %d, cs);" nc
    fprintfn file @"    return b%d;" bi
    fprintfn file @"}"


let defineDone index = 
  match Lib.emit with
  | Some name -> 
    fprintfn file ""
    fprintfn file "#define NUM_BANKS_TOTAL %13d // total number of banks in the mQAP" index
    fprintfn file "#define NUM_BANKS_VK    %13d // number of banks that can be recomputed from VK" nrecomp
    fprintfn file "#define SUM_BANK_SIZES  %13d // number of points to recompute them in VK" lrecomp
    fprintfn file "\n// -----end-verifier-declarations-----\n"
    file.Close()
    definePreamble "verify.c"
    List.iter defineVerify s.functions
    fprintfn file "\n// ----end-verifier-implementations---\n"
    file.Close()
  | _ -> ()

let localName (f:f) =
    let ints2string xs = 
      let s x = sprintf "%d" x
      String.concat "_" (Array.map s xs) 
    match f.args with
    | []   -> f.name
    | xss  -> let a = String.concat "__" (List.map ints2string xss)
              sprintf "%s_%s" f.name a 

let keygen() = 
    if Lib.v then 
      printfn "Key generation for %d functions with banks %A" s.functions.Length s.banks

    definePreamble "verify.h"
    // the total degree is the max of the local degrees plus the number of shared variables
    // we also update each shared bank with its first root in the resulting mQAP.  
    let maxRoots = List.fold (fun a f -> max a f.qap.nRoot) 0 s.functions 
    let linkRoots = 
      Map.fold (fun a _ (b:b) -> if b.shared then b.root0 <- a+maxRoots; a + b.spec.Length else a) 0 s.banks 
    let roots = maxRoots + linkRoots

    // we define the banks for the resulting mQAP: 
    // for each compiled function, with a mix of explicit IO banks and shared banks,
    // we have a unit bank, the IO banks, plus an extra bank for all internals (the shared copies + locals)
    // we also update each function with its first bank in the mQAP.
    let append (sizes,flags) (size,flag) = Array.append sizes [| size |], Array.append flags [| flag |]
    let index (sizes,flags) = Array.length sizes
    let decl = 
      let localbanks decl f : int array * Proof.bankType array  = 
        f.k0 <- index decl
        defineBank (localName f + "_UNIT") (index decl) 1 true None
        let decl = append decl (1, Proof.RECOMPUTED) // unit bank
        let decl, ios, nLocals =                     // IO banks
          Array.fold
           ( fun (decl,ios,nLocals) (b:b)-> 
             if b.shared 
             then decl                             , ios      , nLocals 
             else 
               let j = index decl
               b.mQAPindex <- j
               defineBank b.name j b.spec.Length true (Some b.task)      
               append decl (b.spec.Length, Proof.RECOMPUTED), ios @ [b], nLocals - b.spec.Length) 
           (decl,[],f.qap.wire.Length - 1) 
           f.banks
        defineBank (localName f + "_LOCALS") (index decl) nLocals false None
        append decl (nLocals, Proof.VERIFIED)      // local bank        
      List.fold localbanks ([||],[||]) s.functions
    // we finally add a bank for each shared bank  
    let decl = 
      Map.fold 
        (fun decl _ (b:b) -> 
          if b.shared then 
            b.mQAPindex <- index decl
            defineBank b.name b.mQAPindex b.spec.Length true (Some b.task)
            append decl (b.spec.Length, Proof.BOTH) // we should pick instead VERIFIED in some cases
          else decl) 
        decl s.banks 
    s.banksize <- index decl
    let sizes, _ = decl
    defineDone (index decl) 
    let summary = sprintf "%d equations x %d variables in banks %A " roots (Array.fold (+) 0 sizes) sizes
    // printf "roots %A decl %A banks %A" roots decl s.banks
    let a = Proof.KeyGen.init roots decl // unmanaged state

    let n0 target (f:f) = // compute the first k index for bank target in this function
      let banks : b array = f.banks 
      let mutable i = 0
      let mutable r = 0
      while i < banks.Length && not (banks.[i].name = target) do
        if banks.[i].shared then r <- r - banks.[i].spec.Length
        i <- i + 1
      if i = banks.Length then failwithf "bank not found %A" target
      banks.[i].root0 + r

    // we overlap the compiled mQAPs, using sizes to maintain the (b,n) index.
    let overlap (b,n) (f:f) = 
       QAP.wire_foldi 
         (fun (b,n) k (w:QAP.wire) ->
           // adding all equations for f
           // we start with the IO, then do the locals (internals + shared banks copies)
           // we interleave the linking equations (in polynomial order)
           Map.iter (Proof.KeyGen.addI a b n Proof.V) w.V  
           match w.bank with 
               | QAP.Shared name -> 
                   let b' = s.banks.[name]
                   if b'.shared then 
                     let r = n0 name f + n
                     Proof.KeyGen.addI a b n Proof.V r QAP.one 
               | _ -> ()
           Map.iter (Proof.KeyGen.addI a b n Proof.W) w.W
           match w.bank with 
               | QAP.One -> // add W=1 for each linking equation
                   Array.iter 
                     (fun (bank:b) -> 
                         if bank.shared then
                           let i0 = bank.root0
                           for i = 0 to bank.spec.Length - 1 do 
                             Proof.KeyGen.addI a b n Proof.W (i0+i) QAP.one)
                     f.banks
               | _ -> ()
           Map.iter (Proof.KeyGen.addI a b n Proof.Y) w.Y  
           sizes.[b] <- sizes.[b] - 1
           if sizes.[b] = 0 then (b+1,0) else (b,n+1) // this does *not* work with empty banks
         )
         (b,n)
         f.qap.wire
    let (b,n) = List.fold overlap (0,0) s.functions

     // we finally append the shared-bank variables
    let _ = 
          Map.fold 
            (fun bn _ (b:b) ->
              if b.shared then 
                for i = 0 to b.spec.Length - 1 do
                  Proof.KeyGen.addI a bn i Proof.Y (i + b.root0) QAP.one
                bn+1
              else bn)
            b
            s.banks         
    
    let k = Proof.KeyGen.finalize a
    s.ek <- Some (Proof.Prove.EK k)
    s.vk <- Some (Proof.Verify.VK k)
    summary


module Prove = 
  // add to commitment c three polynomials multiplied by v
  let (*inline*) add_polys c (w:QAP.wire) v = // move to Proof? 
      if not(v = Field.t.zero) then 
        Map.iter (fun r x -> Proof.Prove.add_poly c Proof.V r (Field.t.ofBig x) v) w.V
        Map.iter (fun r x -> Proof.Prove.add_poly c Proof.W r (Field.t.ofBig x) v) w.W
        Map.iter (fun r x -> Proof.Prove.add_poly c Proof.Y r (Field.t.ofBig x) v) w.Y

  let commitments (f:f) (finals: int[]) (internals: Field.t[]) =   
    if Lib.v then printfn "committing for %s with indexes %A" f.name finals 
    let cs = Array.create s.banksize Proof.zeros
    let ek = s.ek.Value 
    let k = ref 0    // current variable in the local QAP 
    let l = ref 0    // current variable in the internals still to be committed
    let j = ref f.k0 // current index of the public bank to be assigned (within those specific to f)

    //(1) accumulate polynomials for the public commitments that the verifier will recompute
    // we cache the unit commitment, but not the others  
    let commitPublic o =
      if Lib.v then printfn "%3d: public commitment from k=%d" !j !k
      let c = Proof.Prove.commitment ek !j 
      let xs = match o with Some(b,t) -> b.values.[t] | None -> [| Field.t.one |]
      for i = 0 to xs.Length - 1 do add_polys c f.qap.wire.[!k+i] xs.[i] 
      if !k = 0 then // add W_0(r) = 1 where r ranges over all linked roots for f
        Array.iter 
          (fun (b:b) -> if b.shared then 
                          for r = b.root0 to b.root0 + b.spec.Length - 1 do 
                             Proof.Prove.add_poly c Proof.W r Field.t.one Field.t.one)
          f.banks   
      Proof.Prove.finalize c
      cs.[!j] <- c
      incr j
      k := !k + xs.Length
    let commitPublicTimed (o:(b*int)option) =
      let the_name = match o with Some(b,t) -> b.name | None -> "C_0"
      let label = sprintf "Committing to %s" the_name 
      Lib.time label commitPublic o
    // unit commitment (cached)
    if f.c0 = Proof.zeros then 
      commitPublicTimed None  
      f.c0 <- cs.[!j]
    else
      cs.[!j] <- f.c0; incr j; incr k

    Array.iter2 
      (fun (b:b) t -> 
        if not b.shared then commitPublicTimed (Some(b,t))
        if Lib.save <> None && b.task.[t] = LoadRecommit then
          // save all plaintext values (shared or not) 
          Field.IO.save_array (b.name + "." + string t) b.values.[t])
      f.banks finals
    
    //(2) compute the private local commitment incrementally
    //    first from local shared banks, then internals (will be communicated) 
    let jl = f.k0 + Array.fold (fun a b -> a + if b.shared then 0 else 1) 1 f.banks 
    assert (jl = !j)
    let kl0 = !k
    let cl = Proof.Prove.commitment ek jl 
    let commitPrivate link size = 
      // commit local wires k to k + size - 1 using xs.[start] ... xs.[start + size - 1]
      // sorting & batching, to compute e.g. (g0*g1)^x instead of g0^x and g1^1
      let xs, r, start = 
        match link with 
        | Some (b,t) -> b.values.[t], b.root0, 0
        | None       -> internals, -1, !l
      for dk = 0 to size - 1 do
        let v = xs.[start + dk]
        add_polys cl f.qap.wire.[!k + dk] v
        if r > 0 then 
          Proof.Prove.add_poly cl Proof.V (r + dk) Field.t.one v  // add a point V_i(i + b.root0) = 1 
      if Lib.v then printfn "%3d: local commitment %d values from k=%d (%s)" jl size !k (if link = None then "internals" else "shared")
      let batch = Array.init size (fun dk -> !k - kl0 + dk) // target indices
      let lk = start - !k + kl0
      if not Lib.raw && bootstrap then printfn "starting to sort"
      System.Array.Sort(batch, (fun dk0 dk1 -> compare xs.[lk + dk0] xs.[lk + dk1])) // not quite linear
      // printfn "batch %A" batch
      let mutable j = 0
      for i = 0 to batch.Length - 1 do
        if not Lib.raw && ((bootstrap && i % 10000 = 9999)||( i % 100000 = 99999)) then 
          printfn "committing... (%d %%)" ((i*100)/batch.Length)
        let v = xs.[lk + batch.[i]]        
        if i = batch.Length - 1 || v <> xs.[lk + batch.[i+1]] then
          Proof.Prove.add_multi cl batch j (i+1) v
          j <- i + 1 
      k := !k + size
    let commitPrivateTimed (link:(b*int)option) size =
      let label = "Committing to " + match link with Some(b,t) -> b.name | None -> "locals"       
      Lib.time label (commitPrivate link) size

    //(3) produce shared commitments (reused, communicated, or recomputed) 
    let commitShared (b,t) =
      match b.proved.TryFind t with
      | Some c   -> if Lib.v then printfn "%3d: reusing shared commitment %s.%d" b.mQAPindex b.name t
                    cs.[b.mQAPindex] <- c   
      | None     -> let committed = b.task.[t] = VerifyCommit 
                    if Lib.v then printfn "%3d: creating shared commitment %s.%d (%s)" b.mQAPindex b.name t (if committed then "committed" else "recomputed")
                    let c = Proof.Prove.commitment ek b.mQAPindex 
                    let xs = b.values.[t]
                    for i = 0 to xs.Length - 1 do 
                      // add a point Y_i(i + b.root0) = 1
                      Proof.Prove.add_poly c Proof.Y (i+b.root0) Field.t.one xs.[i]    
                      if committed then Proof.Prove.add c i xs.[i]
                    Proof.Prove.finalize c
                    b.proved <- b.proved.Add(t,c)
                    cs.[b.mQAPindex] <- c
                    if Lib.save <> None && b.task.[t] = VerifyCommit then
                      c.Save Lib.save.Value (b.name + "." + string t)
    Array.iter2 
      (fun (b:b) t -> if b.shared then commitShared (b,t); commitPrivateTimed (Some (b,t)) b.spec.Length)
      f.banks finals
    assert (!j = jl)
    commitPrivateTimed None (f.qap.wire.Length - !k)
    Proof.Prove.finalize cl
    cs.[jl] <- cl

    if Lib.v then printfn "Prover costs: %d polynomial coefficients;  %d encodings" !Proof.npoly !Proof.nenc
    cl, cs

  // We have collected all load/store for this outsourced call.
  // all banks should already have been committed, but still we may check equations as a sanity check,
  // and we need commitments and local copies for the shared banks. 
  let proof i i0 internals =
  
    if Lib.h then
          let histogram = Array.zeroCreate 255;
          Array.iter (fun (x: Field.t) -> let i = QAP.log2 (x.Big + QAP.one) in histogram.[i] <- histogram.[i] + 1) internals
          printfn "#bit #variable\n"
          Array.iteri (fun i n -> if n <> 0 then printfn "%3d %7d" i n) histogram
 
    let f = s.functions.[i0]
    let finals = Array.map value f.banks
    if Lib.check then
      Lib.time "Checking equations" // optionally check the solution to the local QAP (a fine sanity check)
        (fun () -> 
          let bs = Array.map2 (fun b t-> b.values.[t]) f.banks finals
          let w = Array.concat ([| Field.t.one |] :: List.ofArray bs @ [internals])
          QAP.check w ) ()
    let cl, cs = commitments f finals internals
    let pi     = Lib.time "Generating proof"        (Proof.Prove.proof s.ek.Value) cs
    Proof.Prove.streamline cl;
    if Lib.v then printfn "Commitments: %s\n%A" (Array.fold (fun s c -> s + if c = Proof.zeros then "-" else "C") "" cs) cs
    if Lib.save <> None then
      cl.Save Lib.save.Value (f.name + "-locals." + string i )
      pi.Save Lib.save.Value (f.name + "." + string i )
    // always keep the proof, in case we saved Simple
    f.proof <- f.proof.Add(i, (cl, pi))


/// VERIFIER: 
/// re-build mQAP commitments from the public results of a run 

module Verify = 

  /// assembles a verified vector of commitments for the proof 
  let commitments i i0 cl =  
    let f = s.functions.[i0]
    let t = outsourced // in order of allocation
    let value (b:b) = snd (List.find (fun (n,t) -> n = b.name) outsourced)

    // locally-verified or recomputed commitments 
    let cs = Array.create s.banksize Proof.zeros 
    let vk = s.vk.Value 

    //(1) re-compute commitments (not communicated), could be cached
    let recompute j (xs: Field.t[]) = 
      if Lib.v then printfn "%3d: recompute commitment on %A" j xs
      let c = Proof.Verify.recompute vk j 
      for i = 0 to xs.Length - 1 do Proof.Verify.add c i xs.[i] 
      Proof.Verify.finalize c
      c
    cs.[f.k0] <- recompute f.k0 [|Field.t.one|] 

    //(2) validate the locals
    let jl = f.k0 + Array.fold (fun a b -> a + if b.shared then 0 else 1) 1 f.banks 
    if Lib.time "Verifying locals" (Proof.Verify.committed vk jl) cl
      then 
        if Lib.v then printfn "%3d: verify locals" jl
        cs.[jl] <- cl
      else 
        failwithf "bad local commitment for %s" f.name

    //(3) validate shared private commitments
    let check (b:b) t =
      let c = 
        if Lib.save = Some Lib.Rich then
          Proof.Verify.load vk (b.name + "." + string t) 
        else
          b.proved.[t] 
      if Proof.Verify.committed vk b.mQAPindex c
        then if Lib.v then printfn "%3d: verify commitment on bank %s" b.mQAPindex b.name  
        else failwithf "Commitment verification fails on bank[%d] %s" b.mQAPindex b.name
      c

    let finals = Array.map value f.banks

    Array.iter2 
      (fun b t -> 
        cs.[b.mQAPindex] <-
          match b.verified.TryFind t with 
          | Some c -> 
              if Lib.v then printfn "%3d: %s.%d %A (reused)" b.mQAPindex b.name t b.task.[t]
              c 
          | None -> 
              let c = 
                if Lib.v then printfn "%3d: %s.%d %A" b.mQAPindex b.name t b.task.[t]
                if b.task.[t] = LoadRecommit && Lib.save = Some Lib.Rich then 
                  let loaded = Field.IO.load_array (b.name + "." + string t) b.spec.Length
                  b.values <- b.values.Add(t, loaded)
                match b.task.[t] with 
                | VerifyCommit -> Lib.time (sprintf "Verifying bank %s" b.name) (check b) t
                | LoadRecommit 
                | Recommit     -> Lib.time (sprintf "Recommitting to %s" b.name) (recompute b.mQAPindex) b.values.[t] 
              b.verified <- b.verified.Add(t,c)
              c
            )
      f.banks
      finals
    cs

  let proof i i0 = 
    let f = s.functions.[i0]
    let (cl, pi) as evidence = 
      if Lib.save = Some Lib.Rich then
        let cl = Proof.Verify.load s.vk.Value (f.name + "-locals." + string i)
        let pi = Proof.proof.load (f.name + "." + string i )
        cl, pi
      else
        f.proof.[i]
    //let cs = Lib.time "Verifying commitments" (commitments i i0) cl
    let cs = commitments i i0 cl
    let ok = Lib.time "Verifying proof" (Proof.Verify.proof s.vk.Value pi) cs
    
    if Lib.v then 
      printfn "Commitments: %s" (Array.fold (fun s c -> s + if c = Proof.zeros then "-" else "C") "" cs)
      printfn "%A" cs 

    if not ok then 
      failwithf "Proof verification failed for %d" i0
 

module TraceReader =
  open System.IO
  let schedule_h b =
    let ts = Map.fold (fun a k action -> a @ if action = VerifyCommit then ["0"] else ["1"]) [] b.task
    sprintf "const int recommit_%s = { %s };" b.name (String.concat ", " ts)

  type context = string option // None, or Some "outsourced"
  type trace = { mutable calls: int
                 mutable calling: string option
                 mutable sharing: Map<string, Set<context>> }

  let share (s:trace) bankname = 
    let v0 = 
      match s.sharing.TryFind bankname with
      | None   -> Set.empty
      | Some v -> v
    s.sharing <- s.sharing.Add(bankname, v0.Add s.calling)

  let mutable functions : Map<int,string> = Map.empty
  let read name = 
    let trace = { calls = 0; calling = None; sharing = Map.empty }
    let r = new StreamReader(new FileStream(name, FileMode.Open)) 
    let rec parse (linenum:int) =
      let line = r.ReadLine()
      if not(line = null) then
        let tokens0 = (line.Substring 15).Split ' '
        let tokens = 
          if tokens0.[0] = "_BOOT" then
            if bootstrap  
              then Some(Array.sub tokens0 1 (tokens0.Length - 1)) 
              else None
          else Some tokens0
        match tokens with 
        | None                      -> ()
        | Some [|"call"; name; i |] -> trace.calling <- Some name
                                       functions <- functions.Add(int i,name)
        | Some [|"return"|]         -> trace.calls <- trace.calls + 1
                                       trace.calling <- None
        | Some [|"load"; name; t |] -> let b = bank name
                                       share trace name
                                       (match b.task.TryFind (int t), trace.calling with 
                                        | None             , _      -> failwithf "read before save:\n%s" line
                                        | Some VerifyCommit, None   -> b.task <- b.task.Add(int t, LoadRecommit)
                                        | _                , _      -> ())
        | Some [|"save"; name; t |] -> let b = bank name
                                       share trace name
                                       (match b.task.TryFind (int t), trace.calling with
                                        | Some _           , _      -> failwithf "double save:\n%s" line
                                        | None             , Some _ -> b.task <- b.task.Add(int t, VerifyCommit)
                                        | None             , None   -> b.task <- b.task.Add(int t, Recommit))
        | _                         -> failwithf "bad trace line number %d:\n%A" linenum tokens
        parse (linenum+1)
    parse (1)
    Map.iter 
      (fun name (set: Set<context>) -> 
        let b = bank name
        b.shared <- Map.exists (fun t x -> x = VerifyCommit) b.task // sharing between different instances
                 || set.Remove(None).Count > 1                      // sharing between different functions 
      )
      trace.sharing
    //TODO avoid "both" in some keygen
    if Lib.bv then printfn "// Loaded schedule from %s" name
    //printfn "#define NUM_BANKS %d" s.banks.Count
    //Map.iter (fun _ (b:b) -> printfn "// %s bank %s, size %d\n%s" (if b.shared then "shared" else "public") b.name b.spec.Length (schedule_h b)) s.banks
    //Map.iter (fun i name  -> printfn "// function %d is %s" i name) functions





// -------------------------------- CLI-style prover and verifier

/// PROVER: 
/// build the mQAP commitments from the results of a run (finals, internals)
/// this involves duplicating shared banks
let commit (f:f) recomputes finals internals =   
    if Lib.v then printfn "prover commit %A" finals // internals
    let cs = Array.create s.banksize Proof.zeros
    let ek = s.ek.Value 
    let bIndex = ref f.k0 // the next bank to be assigned, within those for f
    let kIndex = ref 0    // the next k from the local QAP
    let recomputed b = 
      not b.shared || Array.exists (fun n -> n = b.name) recomputes

    // add to commitment c all those polynomials multiplied by v
    let inline add_polys c (w:QAP.wire) v = // move to Proof? 
      if not(v = Field.t.zero) then 
        Map.iter (fun r x -> Proof.Prove.add_poly c Proof.V r (Field.t.ofBig x) v) w.V
        Map.iter (fun r x -> Proof.Prove.add_poly c Proof.W r (Field.t.ofBig x) v) w.W
        Map.iter (fun r x -> Proof.Prove.add_poly c Proof.Y r (Field.t.ofBig x) v) w.Y

    //(1) accumulate polynomials for the public commitments that the verifier will recompute,
    let commitPublic (xs: Field.t[]) = 
      if Lib.v then printfn "public commitment %d" !bIndex
      let c = Proof.Prove.commitment ek !bIndex 
      for i = 0 to xs.Length - 1 do add_polys c f.qap.wire.[!kIndex+i] xs.[i] 
      // if this is the unit bank, with xs = [| 1 |] 
      // then we add W_0(r) = 1 where r ranges over all linked roots for f
      if !kIndex = 0 then 
        Array.iter 
          (fun (b:b) -> 
          if b.shared then 
            for r = b.root0 to b.root0 + b.spec.Length - 1 do 
              Proof.Prove.add_poly c Proof.W r Field.t.one Field.t.one)
          f.banks   
      Proof.Prove.finalize c
      cs.[!bIndex] <- c
      bIndex := !bIndex + 1
      kIndex := !kIndex + xs.Length

    commitPublic [|Field.t.one|] 
    Array.iter2
      (fun (b:b) xs -> if not b.shared then commitPublic xs)
      f.banks
      finals  
    
    //(2) produce private local commitment (will be communicated)
    let k0 = !kIndex
    if Lib.v then printfn "local commitment %d" !bIndex
    let c = Proof.Prove.commitment ek !bIndex 
    let commitPrivate link (xs : Field.t[]) = 
      // sorting & batching, to compute e.g. (g0*g1)^x instead of g0^x and g1^1
      let dk = !kIndex - k0 
      let batch = 
        Array.map 
          (fun v ->
            let k = !kIndex 
            // We currently assume f.qap.wire.ContainsKey k. 
            add_polys c f.qap.wire.[k] v
            match link with // when linked, we add a point V_i(i + b.root0) = 1 
            | Some r -> Proof.Prove.add_poly c Proof.V (r + k) Field.t.one v
            | None   -> ()
            incr kIndex  
            k - k0 )
          xs  
      let batch = Array.sortBy (fun k -> xs.[k - dk]) batch
      let mutable j = 0
      for i = 0 to batch.Length - 1 do
        let v = xs.[batch.[i] - dk]        
        if i = batch.Length - 1 || v <> xs.[batch.[i+1] - dk] then
          Proof.Prove.add_multi c batch j (i+1) v
          j <- i + 1  
    Array.iter2
      (fun (b:b) xs -> if b.shared then commitPrivate (Some (b.root0 - !kIndex)) xs)
      f.banks
      finals  
    commitPrivate None internals
    Proof.Prove.finalize c
    cs.[!bIndex] <- c
    assert (!kIndex = f.qap.wire.Length)

    //(3) produce shared commitments (reused, communicated, or recomputed) 
    let commitShared (b:b) (xs:Field.t array) = 
      match b.commit with
      | Some (a,c) when a = xs -> 
          if Lib.v then printfn "Reusing shared bank[%d] %s" b.mQAPindex b.name 
          cs.[b.mQAPindex] <- c          
      | _ ->
          let committed = not (Array.exists (fun n -> n = b.name) recomputes)
          if Lib.v then printfn "Committing shared bank[%d] %s %s <- \n%A" b.mQAPindex b.name (if committed then "commited" else "recomputed") xs
          let c = Proof.Prove.commitment ek b.mQAPindex 
          for i = 0 to xs.Length - 1 do 
            // re-generate polynomials on the fly: Y_i(i + b.root0) = 1
            Proof.Prove.add_poly c Proof.Y (i+b.root0) Field.t.one xs.[i]    
            if committed then Proof.Prove.add c i xs.[i]
          done
          Proof.Prove.finalize c
          b.commit <- Some(xs,c)
          cs.[b.mQAPindex] <- c          
    Array.iter2
      (fun (b:b) xs -> if b.shared then commitShared b xs)
      f.banks
      finals  
    cs

let commitVerify (f:f) recomputes (cs:Proof.commitment array) finals  =   
    // locally-verified or recomputed commitments 
    let csv = Array.create s.banksize Proof.zeros 
    let vk = s.vk.Value 
    let recompute j (xs: Field.t[]) = 
      if Lib.v then printfn "  recompute commitment on bank[%d] := %A" j xs
      let c = Proof.Verify.recompute vk j 
      for i = 0 to xs.Length - 1 do Proof.Verify.add c i xs.[i] 
      Proof.Verify.finalize c
      csv.[j] <- c

    if Lib.v then printfn "\ncommitVerify: %A %A" cs finals
    //(1) re-compute all public commitments (not communicated)
    let bIndex = ref f.k0 // the next bank to be assigned, within those for f
    let commitPublic xs  = 
      recompute !bIndex xs 
      incr bIndex
    commitPublic [|Field.t.one|] 
    Array.iter commitPublic finals

    //(2) validate the locals
    let c = cs.[!bIndex]
    if Proof.Verify.committed vk !bIndex c
      then if Lib.v then printfn "  verify commitment on locals"
      else failwith "commitment verification fails on locals"
    csv.[!bIndex] <- c
    incr bIndex

    //(3) validate (or recompute) shared commitments
    let check (b:b) =
      if Array.exists (fun n -> n = b.name) recomputes
      then 
        // ugly; could also re-use verifier commitments
        let xs,_ = b.commit.Value 
        recompute b.mQAPindex xs 
      else 
        let c = cs.[b.mQAPindex]
        if b.vcommit = Some(c) 
        then 
          if Lib.v then printfn "  reuse commitment on bank %s" b.name
        else
          if Proof.Verify.committed vk b.mQAPindex c
            then if Lib.v then printfn "  verify commitment on bank %s" b.name  
            else failwithf  "Commitment verification fails on bank[%d] %s" b.mQAPindex b.name
          b.vcommit <- Some(c)
        csv.[b.mQAPindex] <- c
    Array.iter (fun b -> if b.shared then check b) f.banks 

    csv
module Env

open AstObject
open System.Collections.Generic

//type EnvImpl = 
//    
//
//    new() = {
//        inner = None;
//        dict = new Dictionary<string, SObject>(); 
//    }
//    
//    // used by Wrap()
//    private new(newInner) = {
//        inner = Some(newInner);
//        dict = new Dictionary<string, SObject>(); 
//    }
//
//    // used by Copy()
//    private new(innerE, dictE) = {
//        inner = innerE; 
//        dict = dictE;        
//    }
//
//    // Call this when entering a new scope
//    member this.Wrap() =
//        new EnvImpl(this)

//    member this.Copy() =
//        // We are cloning only the dictionary, not the values
//        // if there are SObjects with mutating state, we need to
//        // clone them too
//        match this.inner with
//        | None -> new EnvImpl(None, new Dictionary<string, SObject>(this.dict))
//        | Some(env) ->
//            new EnvImpl(Some(env.Copy()), new Dictionary<string, SObject>(this.dict))



// Environment
type Env = 
    val inner : Option<Env>
    val dict : Dictionary<string, SObject>

    new() = { inner = None; dict = new Dictionary<string, SObject>(); }

    // A copy of the environment
    private new(newInner) = { inner = newInner; dict = new Dictionary<string, SObject>(); }

    member this.Wrap() =
        //this.e <- this.e.Wrap()
        //this
        new Env(Some(this));

//    member this.Copy() = 
//        new Env(this.e.Copy())

    member this.Unwrap() =
        match this.inner with
        | Some(e) -> e
        | None -> failwith "No inner env!"

    member this.Lookup(key) =
        if this.dict.ContainsKey(key) then
            this.dict.[key]
        else 
            match this.inner with
            | Some(env) -> env.Lookup(key);
            | None -> failwith ("Unable to find " + key)

    member this.Put(key, ob) =
        if this.dict.ContainsKey(key) then
            failwith "You can't mutate an existing var with put!"
            //this.dict.[key] <- ob
        else
            this.dict.Add(key, ob)
        this
        
    member this.Change(key, new_val) = 
        if this.dict.ContainsKey(key) then
            this.dict.[key] <- new_val
            this
        else
            match this.inner with
            | Some(env) -> env.Change(key, new_val)
            | None -> failwith "You can't change something that doesnt exist!";;

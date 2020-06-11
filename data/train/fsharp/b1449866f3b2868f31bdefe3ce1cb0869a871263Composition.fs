module Composition

open Interfaces

type CompositeEmitter<'key2,'value2,'key3,'value3 when 'key2: equality and 'key3: equality>(job2: Job1_1<'key2,'value2,'key3,'value3>, emitter2: Emitter<'key3,'value3>) =
    interface Emitter<'key2,'value2> with 
        member this.emit(cell2: KeyValueCell<'key2, 'value2>) = 
                job2.onProcess(cell2) emitter2 

type CompositeJob<'key1,'value1,'key2,'value2,'key3,'value3 when 'key1: equality and 'key2: equality and 'key3: equality>(job1: Job1_1<'key1,'value1,'key2,'value2>, job2: Job1_1<'key2,'value2,'key3,'value3>) =
    interface Job1_1<'key1,'value1,'key3,'value3> with
        member this.keepsState with get() = job1.keepsState || job2.keepsState 
        member this.isStateEmpty with get() = job1.isStateEmpty && job2.isStateEmpty

        member this.onProcess(cell1: KeyValueCell<'key1,'value1>) (emitter: Emitter<'key3,'value3>): unit =   
                    let emitter1 = CompositeEmitter<'key2,'value2,'key3,'value3>(job2, emitter)
                    match cell1 with
                     (*| Modified(k,(oldV, newV)) ->
                            job1.onProcess(Deleted(k, oldV)) emitter1
                            job1.onProcess(Inserted(k, newV)) emitter1*)
                     | _ -> job1.onProcess(cell1) emitter1  
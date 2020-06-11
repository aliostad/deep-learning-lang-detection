module Tachyon.Atom
    open Tachyon.IStream

    type Atom<'a when 'a : equality>(value : 'a) =
        let r = ref value

        let e = new Event<'a>()
        let p = e.Publish

        member x.get () = !r
        member x.swap f =
            let newValue =
                let rec aux () =
                    let oldValue = !r
                    let newValue = f oldValue
                    let success =
                        lock r (fun () ->
                            if !r = oldValue then
                                r := newValue
                                true
                            else false)
                    if success then newValue
                    else aux()
                aux()
            e.Trigger newValue
            newValue

        interface IStream<'a> with
            member x.addWatch h = p.AddHandler h
            member x.removeWatch h = p.RemoveHandler h

    let atom value = new Atom<_>(value)

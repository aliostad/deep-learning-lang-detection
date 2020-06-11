open SharedMemoryManager
open System
open System.Threading
open System.IO
open System.Runtime.InteropServices
open Microsoft.FSharp.NativeInterop
open PInvokeHelper
open System.ComponentModel
open System.Runtime.Serialization
open System.Runtime.Serialization.Formatters.Binary
open System.ComponentModel
open System.Diagnostics

[<Struct; StructLayout(LayoutKind.Sequential)>]
type Contact =
    struct 
        val name: string
        val age: int
        new (name:string, age:int) = { name = name; age = age}
    end 



[<EntryPoint>]
let main argv = 
    
    if argv <> null && argv.Length = 0 then

        while true do
            //  use sm = new SharedMemoryManager<Contact>("contacts", 8092) :> ISharedMemory<Contact>
            //use sm = new SharedMemoryMappedManager<Contact>("contacts", 8092) :> ISharedMemory<Contact>
            //use sm = new SharedMemoryPipeManager<Contact>("contacts", PipeType.Client) :> ISharedMemory<Contact>
            use sm = new SharedUnmanagedMemoryManager<Contact>("contacts", 8092) :> ISharedMemory<Contact>
            let processName = Process.GetCurrentProcess().MainModule.FileName
            Console.ReadLine() |> ignore
            let contact = sm.Receive() //:?> Contact
            printfn "Receiving contatc pricess name %s ..." processName
            printfn "Contact Name %s - Age %d" contact.name contact.age
            Console.ReadLine() |> ignore
    else
        
       while true do
            //use sm = new SharedMemoryManager<Contact>("contacts", 8092) :> ISharedMemory<Contact>
            //use sm = new SharedMemoryMappedManager<Contact>("contacts", 8092) :> ISharedMemory<Contact>
            //use sm = new SharedMemoryPipeManager<Contact>("contacts", PipeType.Server) :> ISharedMemory<Contact>
            use sm = new SharedUnmanagedMemoryManager<Contact>("contacts", 8092) :> ISharedMemory<Contact>


            let processName = Process.GetCurrentProcess().MainModule.FileName
        
            Console.ReadLine() |> ignore
            let contact = Contact("Riccardo",40)
            printfn "Seinding contatc pricess name %s ..." processName
            sm.Send(contact)

       Console.ReadLine() |> ignore
    0 // return an integer exit code

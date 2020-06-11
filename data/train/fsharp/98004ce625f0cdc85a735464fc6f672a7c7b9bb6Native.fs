namespace FsCPS

open System

type NativeCPSException(msg) =
    inherit Exception(msg)


type CPSQualifier =
    | Target = 1
    | Observed = 2
    | Proposed = 3
    | RealTime = 4


type CPSAttributeType =
    //| UInt16 = 0
    //| UInt32 = 1
    //| UInt64 = 2
    | Binary = 3


type CPSAttributeClass =
    | Leaf = 1
    | LeafList = 2
    | Container = 3
    | Subsystem = 4
    | List = 5


type CPSOperationType =
    | Delete = 1
    | Create = 2
    | Set = 3
    | Action = 4



// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------



namespace FsCPS.Native

#nowarn "9" // Unverifiable IL

open System
open System.Linq.Expressions
open System.Reflection
open System.Runtime.InteropServices
open System.Text
open System.Text.RegularExpressions
open FsCPS


// Definition of native types.
// Note that complex structures are modeled as classes, not structs:
// the native APIs always expect a pointer, so using a reference type helps
// avoiding manual pinning and continuous copies when these types are passed
// in the managed code.

module internal Constants =
    [<Literal>]
    let KeyLength = 256
    [<Literal>]
    let ObjEventLength = 50000

type internal NativeKeyStorage private (addr: nativeint) =

    interface IDisposable with
        member this.Dispose() = this.Dispose()

    new () as this =
        new NativeKeyStorage(Marshal.AllocHGlobal(Constants.KeyLength + 8))
        then
            Marshal.WriteInt64(this.Address, Constants.KeyLength, 42L)

    member val Address = addr

    member this.Dispose() =
        this.CheckCanary()
        Marshal.FreeHGlobal(addr)

    member this.CheckCanary() =
        let canary = Marshal.ReadInt64(addr, Constants.KeyLength)
        if canary <> 42L then
            invalidOp (sprintf "CANARY: %d" canary)


type internal NativeObject = nativeint
type internal NativeObjectList = nativeint
type internal NativeAttr = nativeint
type internal NativeAttrID = uint64


[<Class>]
[<AllowNullLiteral>]
[<StructLayout(LayoutKind.Sequential)>]
type internal NativeObjectIterator =
    val mutable len: unativeint
    val mutable attr: NativeAttr

    new () =
        { len = 0un; attr = 0n }


[<Class>]
[<AllowNullLiteral>]
[<StructLayout(LayoutKind.Sequential)>]
type internal NativeGetParams =
    val mutable keys: nativeint // Pointer to array of Key
    val mutable key_count: unativeint
    val mutable list: NativeObjectList
    val mutable filters: NativeObjectList
    val mutable timeout: unativeint

    new () =
        { keys = 0n; key_count = 0un; list = 0n; filters = 0n; timeout = 0un }


[<Class>]
[<AllowNullLiteral>]
[<StructLayout(LayoutKind.Sequential)>]
type internal NativeTransactionParams =
    val mutable change_list: NativeObjectList
    val mutable prev: NativeObjectList
    val mutable timeout: unativeint

    new () =
        { change_list = 0n; prev = 0n; timeout = 0un }


type internal NativeServerCallback<'TParam when 'TParam : not struct> = delegate of nativeint * 'TParam * unativeint -> int

type internal NativeEventHandle = nativeint

[<Struct>]
[<StructLayout(LayoutKind.Sequential)>]
type internal NativeEventRegistration =
    val mutable priority: int
    val mutable objects: nativeint
    val mutable objects_size: unativeint


[<Struct>]
[<StructLayout(LayoutKind.Sequential)>]
type internal NativeServerRegistrationRequest =
    val mutable handle: nativeint
    val mutable context: nativeint
    [<MarshalAs(UnmanagedType.ByValArray, SizeConst = Constants.KeyLength)>]
    val mutable key: byte[]
    [<MarshalAs(UnmanagedType.FunctionPtr)>]
    val mutable read_function: NativeServerCallback<NativeGetParams>
    [<MarshalAs(UnmanagedType.FunctionPtr)>]
    val mutable write_function: NativeServerCallback<NativeTransactionParams>
    [<MarshalAs(UnmanagedType.FunctionPtr)>]
    val mutable rollback_function: NativeServerCallback<NativeTransactionParams>





// Private module to make sure that the extern functions are not directly available to the outside
module private Extern =

    // CPS libraries do not have a consistent name, so we need to load them dynamically using `dlopen`.

    [<DllImport("libdl.so", CharSet = CharSet.Ansi)>]
    extern IntPtr private dlopen([<MarshalAs(UnmanagedType.LPStr)>] string filename, int flags);

    [<DllImport("libdl.so", CharSet = CharSet.Ansi)>]
    extern IntPtr private dlsym(IntPtr handle, [<MarshalAs(UnmanagedType.LPStr)>] string symbol);

    let private cpsLibraryHandle =
        [
            "libcps-api-common.so" // Dell OS10
            "libopx_cps_api_common.so.1" // OpenSwitch
        ]
        |> Seq.map (fun name -> dlopen(name, 2 (* RTLD_NOW *)))
        |> Seq.find ((<>) IntPtr.Zero)

    let private makeNewCustomDelegate =
        Delegate.CreateDelegate(
            typeof<Func<Type[], Type>>,
            typeof<Expression>.Assembly.GetType("System.Linq.Expressions.Compiler.DelegateHelpers").GetMethod("MakeNewCustomDelegate", BindingFlags.NonPublic ||| BindingFlags.Static)
        ) :?> Func<Type[], Type>

    let private sym<'TDelegate when 'TDelegate :> Delegate> name =
        let ptr = dlsym(cpsLibraryHandle, name)
        if ptr = IntPtr.Zero then
            invalidArg "name" (sprintf "Unable to find native function %s." name)

        // We cannot use generic delegates for interop, so we need to generate
        // a temporary non-generic one.
        let tdel = typeof<'TDelegate>
        if not tdel.IsGenericType then
            Marshal.GetDelegateForFunctionPointer(ptr, typeof<'TDelegate>) :?> 'TDelegate
        else
            // Action delegates have an implicit void return type
            let pars =
                let mutable arr = tdel.GetGenericArguments()
                if tdel.Name.StartsWith("Action") then
                    Array.Resize(&arr, arr.Length + 1)
                    arr.[arr.Length - 1] <- typeof<Void>
                arr
            let newDelegateType = makeNewCustomDelegate.Invoke(pars)

            // Marshal the native function and reconstruct a new generic delegate
            let newDelegate = Marshal.GetDelegateForFunctionPointer(ptr, newDelegateType)
            typeof<'TDelegate>
                .GetConstructor(BindingFlags.NonPublic ||| BindingFlags.Public ||| BindingFlags.Instance, null, [| typeof<obj>; typeof<nativeint> |], null)
                .Invoke([| newDelegate.Target; newDelegate.Method.MethodHandle.GetFunctionPointer() :> obj |])
                :?> 'TDelegate

    // Library initialization

    let cps_api_class_map_init = sym<Action> "cps_api_class_map_init"

    // Objects

    [<UnmanagedFunctionPointerAttribute(CallingConvention.Cdecl, CharSet = CharSet.Ansi)>]
    type cps_api_object_create_int = delegate of [<MarshalAs(UnmanagedType.LPStr)>] desc: string
                                                * line: uint32
                                                * [<MarshalAs(UnmanagedType.LPStr)>] name: string
                                               -> NativeObject
    let cps_api_object_create_int = sym<cps_api_object_create_int> "cps_api_object_create_int"

    let cps_api_object_delete = sym<Action<NativeObject>> "cps_api_object_delete"

    let cps_api_object_clone = sym<Func<NativeObject, NativeObject, bool>> "cps_api_object_clone"

    let cps_api_object_key = sym<Func<NativeObject, nativeint>> "cps_api_object_key"

    let cps_api_object_reserve = sym<Func<NativeObject, unativeint, bool>> "cps_api_object_reserve"

    // Object attributes

    [<UnmanagedFunctionPointerAttribute(CallingConvention.Cdecl, CharSet = CharSet.Ansi)>]
    type cps_api_object_e_add = delegate of obj: NativeObject
                                          * [<MarshalAs(UnmanagedType.LPArray, SizeParamIndex = 2s)>] aid: NativeAttrID[]
                                          * id_size: unativeint
                                          * atype: CPSAttributeType
                                          * [<MarshalAs(UnmanagedType.LPArray, SizeParamIndex = 5s)>] data: byte[]
                                          * len: unativeint
                                         -> bool
    let cps_api_object_e_add = sym<cps_api_object_e_add> "cps_api_object_e_add"

    let cps_api_object_attr_delete = sym<Action<NativeObject, NativeAttrID>> "cps_api_object_attr_delete"

    let cps_api_object_attr_id = sym<Func<NativeAttr, NativeAttrID>> "cps_api_object_attr_id"

    let cps_api_object_attr_data_bin = sym<Func<NativeAttr, nativeint>> "cps_api_object_attr_data_bin"

    let cps_api_object_attr_len = sym<Func<NativeAttr, unativeint>> "cps_api_object_attr_len"
        
    let cps_api_object_attr_get = sym<Func<NativeObject, NativeAttrID, NativeAttr>> "cps_api_object_attr_get"

    type cps_api_object_it_begin = delegate of obj: NativeObject
                                             * [<In; Out>] it: NativeObjectIterator
                                            -> unit
    let cps_api_object_it_begin = sym<cps_api_object_it_begin> "cps_api_object_it_begin"

    // Keys

    let cps_api_key_from_attr_with_qual = sym<Func<nativeint, NativeAttrID, CPSQualifier, bool>> "cps_api_key_from_attr_with_qual"

    [<UnmanagedFunctionPointerAttribute(CallingConvention.Cdecl, CharSet = CharSet.Ansi)>]
    type cps_api_key_from_string = delegate of key: nativeint
                                             * [<MarshalAs(UnmanagedType.LPStr)>] str: string
                                            -> bool
    let cps_api_key_from_string = sym<cps_api_key_from_string> "cps_api_key_from_string"

    type cps_api_key_print = delegate of key: nativeint
                                       * [<MarshalAs(UnmanagedType.LPStr)>] buffer: StringBuilder
                                       * len: unativeint
                                      -> nativeint
    let cps_api_key_print = sym<cps_api_key_print> "cps_api_key_print"

    // Attribute ID to name mapping

    let cps_dict_find_by_id = sym<Func<NativeAttrID, nativeint>> "_Z19cps_dict_find_by_idm"

    [<UnmanagedFunctionPointerAttribute(CallingConvention.Cdecl, CharSet = CharSet.Ansi)>]
    type cps_dict_find_by_name = delegate of [<MarshalAs(UnmanagedType.LPStr)>] path: string
                                          -> nativeint
    let cps_dict_find_by_name = sym<cps_dict_find_by_name> "_Z21cps_dict_find_by_namePKc"

    let cps_attr_id_to_name = sym<Func<NativeAttrID, nativeint>> "cps_attr_id_to_name"

    // Object lists

    let cps_api_object_list_create = sym<Func<NativeObjectList>> "cps_api_object_list_create"

    let cps_api_object_list_destroy = sym<Action<NativeObjectList, bool>> "cps_api_object_list_destroy"

    let cps_api_object_list_get = sym<Func<NativeObjectList, unativeint, NativeObject>> "cps_api_object_list_get"

    let cps_api_object_list_append = sym<Func<NativeObjectList, NativeObject, bool>> "cps_api_object_list_append"

    let cps_api_object_list_size = sym<Func<NativeObjectList, unativeint>> "cps_api_object_list_size"

    // Transactions

    type TransFunc1<'T> = delegate of [<In; Out>] x: 'T -> int
    type TransFunc2<'T> = delegate of [<In; Out>] x: 'T * NativeObject -> int

    let cps_api_transaction_init = sym<TransFunc1<NativeTransactionParams>> "cps_api_transaction_init"

    let cps_api_transaction_close = sym<TransFunc1<NativeTransactionParams>> "cps_api_transaction_close"

    let cps_api_get = sym<TransFunc1<NativeGetParams>> "cps_api_get"

    let cps_api_create = sym<TransFunc2<NativeTransactionParams>> "cps_api_create"

    let cps_api_set = sym<TransFunc2<NativeTransactionParams>> "cps_api_set"

    let cps_api_delete = sym<TransFunc2<NativeTransactionParams>> "cps_api_delete"

    let cps_api_get_request_init = sym<TransFunc1<NativeGetParams>> "cps_api_get_request_init"

    let cps_api_get_request_close = sym<TransFunc1<NativeGetParams>> "cps_api_get_request_close"

    let cps_api_commit = sym<TransFunc1<NativeTransactionParams>> "cps_api_commit"

    // API for servers

    type RefDelegate1<'T> = delegate of byref<'T> -> int
    type RefDelegate2<'T1, 'T2> = delegate of byref<'T1> * 'T2 -> int
    type RefDelegate3<'T1, 'T2> = delegate of 'T1 * byref<'T2> -> int

    let cps_api_operation_subsystem_init = sym<RefDelegate2<nativeint, int>> "cps_api_operation_subsystem_init"

    let cps_api_register = sym<RefDelegate1<NativeServerRegistrationRequest>> "cps_api_register"

    let cps_api_object_type_operation = sym<Func<nativeint, int>> "cps_api_object_type_operation"

    // Events

    let cps_api_event_service_init = sym<Func<int>> "cps_api_event_service_init"

    let cps_api_event_client_connect = sym<RefDelegate1<NativeEventHandle>> "cps_api_event_client_connect"

    let cps_api_event_client_disconnect = sym<Func<NativeEventHandle, int>> "cps_api_event_client_disconnect"

    let cps_api_event_client_register = sym<RefDelegate3<NativeEventHandle, NativeEventRegistration>> "cps_api_event_client_register"

    let cps_api_wait_for_event = sym<Func<NativeEventHandle, NativeObject, int>> "cps_api_wait_for_event"

    let cps_api_event_publish = sym<Func<NativeEventHandle, NativeObject, int>> "cps_api_event_publish"

    // Initializes the native library as soon as the module is loaded.
    do
        cps_api_class_map_init.Invoke()



/// Definitions of all the native methods needed by FsCPS.
module internal NativeMethods =

    // Precompiled regex to validate key strings
    let private _keyRegex = Regex("^(\d+\.?)+$", RegexOptions.Compiled)

    /// Returns a string representation of a CPS error code.
    let ReturnValueToString ret =
        match ret with
        | 0 -> "OK"
        | 1 -> "GENERIC_ERROR"
        | 2 -> "NO_SERVICE"
        | 3 -> "SERVICE_CONNECT_FAIL"
        | 4 -> "INTERNAL_FAILURE"
        | 5 -> "TIMEOUT"
        | _ -> "UNKNOWN_ERROR"

    /// Returns the string representation of the given string.
    let PrintKey key =
        let sb = StringBuilder(1024)
        Extern.cps_api_key_print.Invoke(key, sb, 1024un) |> ignore
        sb.ToString()

    /// Parses the given string representation of a key into an actual key.
    let ParseKey str =
        
        // We validate the key manually, since it does look like that the native function
        // always returns true.
        if not (_keyRegex.IsMatch(str)) then
            Error "Could not parse key."
        else
            let k = new NativeKeyStorage()
            if Extern.cps_api_key_from_string.Invoke(k.Address, str) then
                k.CheckCanary()
                Ok k
            else
                k.Dispose()
                Error "Could not parse key."

    /// Converts a human-readable string path to an Attribute ID.
    let AttrIdFromPath path =
        let ptr = Extern.cps_dict_find_by_name.Invoke(path)
        if ptr = IntPtr.Zero then
            Error ("Cannot find path " + path)
        else
            // The offset 40 was found by trial and error.
            // The pointer returned by `cps_dict_find_by_name` points to an internal C++ struct
            // which we don't know. This is now 40, but can change without notice.
            // This is horrible. There must be a better way. There must be.
            let id = uint64 (Marshal.ReadInt64(ptr, 40))
            Ok id

    /// Converts an attribute ID to a path name.
    let AttrIdToPath id =
        let ptr = Extern.cps_attr_id_to_name.Invoke(id)
        if ptr = IntPtr.Zero then
            Error (sprintf "Cannot find attribute with id %d" id)
        else
            Ok (Marshal.PtrToStringAnsi(ptr))

    /// Extracts the attribute class from an attribute ID.
    let AttrClassFromAttrId id =
        let ptr = Extern.cps_dict_find_by_id.Invoke(id)
        if ptr = IntPtr.Zero then
            Error (sprintf "Cannot find attribute with id %d" id)
        else
            // Again, the offset 28 was found by trial and error. See above.
            let c = Marshal.ReadInt32(ptr, 28)
            Ok (enum<CPSAttributeClass> c)

    /// Extracts the attribute ID from an attribute pointer.
    let AttrIdFromAttr attr =
        Extern.cps_api_object_attr_id.Invoke(attr)

    /// Creates a native key out of a qualifier and a path.
    let CreateKey qual path =
        AttrIdFromPath path
        >>= (fun attrId ->
            let k = new NativeKeyStorage()
            if Extern.cps_api_key_from_attr_with_qual.Invoke(k.Address, attrId, qual) then
                k.CheckCanary()
                Ok k
            else
                Error "Could not set object's key."
        )

    /// Extracts the key of an object.
    let GetObjectKey obj =
        let k = Extern.cps_api_object_key.Invoke(obj)
        if k = IntPtr.Zero then
            Error "Could not get object's key."
        else
            Ok k

    /// Sets an object's key.
    let SetObjectKey key obj =
        GetObjectKey obj
        >>= (fun k ->
            if Extern.cps_api_key_from_string.Invoke(k, key) then
                Ok obj
            else
                Error "Could not parse key."
        )

    /// Extracts the operation type from a key.
    let GetOperationFromKey key =
        let ret = Extern.cps_api_object_type_operation.Invoke(key)
        if ret = 0 then
            Error "Cannot extract operation type from key."
        else
            Ok (enum<CPSOperationType> ret)

    /// Creates a new CPS object.
    let CreateObject () =
        let obj = Extern.cps_api_object_create_int.Invoke("", 0u, "")
        if obj = IntPtr.Zero then
            Error "Cannot create native CPS object"
        else
            Ok obj

    /// Frees the resources of a native CPS object.
    let DestroyObject (obj: NativeObject) =
        Extern.cps_api_object_delete.Invoke(obj)

    /// Clones an object into another.
    let CloneObject (dest: NativeObject) (src: NativeObject) =
        if Extern.cps_api_object_clone.Invoke(dest, src) then
            Ok ()
        else
            Error "Could not clone object."
       
    /// Reserves the given amount of space in an object.
    let ReserveSpaceInObject (size: unativeint) (obj: NativeObject) =
        if Extern.cps_api_object_reserve.Invoke(obj, size) then
            Ok ()
        else
            Error "Could not reseve space in object."

    /// Creates a new iterator for the attributes of the given object.
    let BeginAttributeIterator (obj: NativeObject) =
        let it = NativeObjectIterator()
        Extern.cps_api_object_it_begin.Invoke(obj, it)
        it

    /// Returns a sequence that iterates over all the native objects in the given list.
    let IterateObjectList (l: NativeObjectList) =
        let len = Extern.cps_api_object_list_size.Invoke(l)
        if len = 0un then
            Seq.empty
        else
            seq {
                for i = 0un to len - 1un do
                    yield Extern.cps_api_object_list_get.Invoke(l, i)
            }

    // Adds a nested attribute to the given object.
    let AddNestedAttribute (obj: NativeObject) (aid: NativeAttrID[]) (value: byte[]) =
        if Extern.cps_api_object_e_add.Invoke(obj, aid, unativeint aid.Length, CPSAttributeType.Binary, value, unativeint value.Length) then
            Ok ()
        else
            Error "Cannot add attribute to native object."

    /// Adds a binary attribute to a native CPS object.
    let AddAttribute (obj: NativeObject) (aid: NativeAttrID) (value: byte[]) =
        AddNestedAttribute obj [| aid |] value

    /// Returns a copy of the attribute store in the given object with the given id.
    let GetAttribute (obj: NativeObject) (aid: NativeAttrID) =
        let attr = Extern.cps_api_object_attr_get.Invoke(obj, aid)
        if attr = IntPtr.Zero then
            Error (sprintf "Could not find attribute with id %d." aid)
        else
            let len = int (Extern.cps_api_object_attr_len.Invoke(attr))
            let arr = Array.zeroCreate<byte> len
            Marshal.Copy(Extern.cps_api_object_attr_data_bin.Invoke(attr), arr, 0, len)
            Ok(arr)

    /// Removes the attribute from the given object.
    let RemoveAttribute (obj: NativeObject) (aid: NativeAttrID) =
        Extern.cps_api_object_attr_delete.Invoke(obj, aid)
        Ok()

    /// Creates a new object list.
    let CreateObjectList () =
        let list = Extern.cps_api_object_list_create.Invoke()
        if list <> IntPtr.Zero then
            Ok list
        else
            Error "Cannot create native object list."

    /// Destroys an object list.
    let DestroyObjectList (destroyObjects: bool) (list: NativeObjectList) =
        Extern.cps_api_object_list_destroy.Invoke(list, destroyObjects)
        Ok()

    /// Appends an element to an object list.
    let AppendObjectToList list obj =
        if Extern.cps_api_object_list_append.Invoke(list, obj) then
            Ok list
        else
            Error "Cannot append native object to list."

    /// Extracts the object at a given index of a native object list.
    let ObjectListGet list index =
        let ret = Extern.cps_api_object_list_get.Invoke(list, index)
        if ret = IntPtr.Zero then
            Error (sprintf "Cannot get item %d of native object list." index)
        else
            Ok ret

    /// Creates a new CPS Get request.
    let CreateGetRequest () =
        let req = NativeGetParams()
        let ret = Extern.cps_api_get_request_init.Invoke(req)
        if ret = 0 then
            Ok req
        else
            Error (sprintf "Cannot inizialize native get request (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Destroys the Get request.
    let DestroyGetRequest (req: NativeGetParams) =
        let ret = Extern.cps_api_get_request_close.Invoke(req)
        if ret = 0 then
            Ok()
        else
            Error (sprintf "Error freeing get request (Return value: %s = %d)." (ReturnValueToString ret) ret)

    // Sends the given get request.
    let GetRequestSend (req: NativeGetParams) =
        let ret = Extern.cps_api_get.Invoke(req)
        if ret = 0 then
            Ok()
        else
            Error (sprintf "Error sending get request (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Creates a new CPS transaction.
    let CreateTransaction () =
        let trans = NativeTransactionParams()
        let ret = Extern.cps_api_transaction_init.Invoke(trans)
        if ret = 0 then
            Ok trans
        else
            Error (sprintf "Cannot initialize native transaction (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Releases the resources of a native CPS transaction.
    let DestroyTransaction (trans: NativeTransactionParams) =
        let ret = Extern.cps_api_transaction_close.Invoke(trans)
        if ret = 0 then
            Ok()
        else
            Error (sprintf "Error freeing transaction (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Adds a `create` operation to a transaction.
    let TransactionAddCreate (trans: NativeTransactionParams) (obj: NativeObject) =
        let ret = Extern.cps_api_create.Invoke(trans, obj)
        if ret = 0 then
            Ok()
        else
            Error (sprintf "Error adding operation to transaction (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Adds a `set` operation to a transaction.
    let TransactionAddSet (trans: NativeTransactionParams) (obj: NativeObject) =
        let ret = Extern.cps_api_set.Invoke(trans, obj)
        if ret = 0 then
            Ok()
        else
            Error (sprintf "Error adding operation to transaction (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Adds a `delete` operation to a transaction.
    let TransactionAddDelete (trans: NativeTransactionParams) (obj: NativeObject) =
        let ret = Extern.cps_api_delete.Invoke(trans, obj)
        if ret = 0 then
            Ok()
        else
            Error (sprintf "Error adding operation to transaction (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Commits a transaction.
    let TransactionCommit (trans: NativeTransactionParams) =
        let ret = Extern.cps_api_commit.Invoke(trans)
        if ret = 0 then
            Ok()
        else
            Error (sprintf "Error committing transaction (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Initializes the operation subsystem.
    let InitializeOperationSubsystem () =
        let mutable handle = 0n
        let ret = Extern.cps_api_operation_subsystem_init.Invoke(&handle, 1)
        if ret = 0 then
            Ok handle
        else
            Error (sprintf "Error initializing operation subsystem (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Registers listeners for the given key.
    let RegisterServer (handle: nativeint) (key: string) (read: NativeServerCallback<_>) (write: NativeServerCallback<_>) (rollback: NativeServerCallback<_>) =
        
        // Prepares the request
        let mutable req =
            NativeServerRegistrationRequest(
                handle = handle,
                context = 0n,
                key = Array.zeroCreate Constants.KeyLength,
                read_function = read,
                write_function = write,
                rollback_function = rollback
            )
        ParseKey key
        |>> (fun k ->
            Marshal.Copy(k.Address, req.key, 0, Constants.KeyLength)
            k.Dispose()
        )
        |> Result.okOrThrow (invalidArg "key")

        // Registers the server
        let ret = Extern.cps_api_register.Invoke(&req)
        if ret = 0 then
            Ok ()
        else
            Error (sprintf "Cannot register server (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Initializes the event subsystem and starts the event thread.
    let InitializeEventSubsystem () =
        let ret = Extern.cps_api_event_service_init.Invoke()
        if ret = 0 then
            Ok ()
        else
            Error (sprintf "Cannot initialize event service (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Creates a new handle on which CPS events can be listened to.
    let CreateEventHandle () : Result<NativeEventHandle, _> =
        let mutable handle = 0n
        let ret = Extern.cps_api_event_client_connect.Invoke(&handle)
        if ret = 0 then
            Ok handle
        else
            Error (sprintf "Cannot create event handle (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Destroys an event handle.
    let DestroyEventHandle (handle: NativeEventHandle) =
        let ret = Extern.cps_api_event_client_disconnect.Invoke(handle)
        if ret = 0 then
            Ok ()
        else
            Error (sprintf "Cannot destroy event handle (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Registers a key as a filter for an event handle.
    let RegisterEventFilter (handle: NativeEventHandle) (key: nativeint) =
        let mutable reg =
            NativeEventRegistration(
                priority = 0,
                objects = key,
                objects_size = 1un
            )
        let ret = Extern.cps_api_event_client_register.Invoke(handle, &reg)
        if ret = 0 then
            Ok ()
        else
            Error (sprintf "Cannot register native event (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Suspends the current thread waiting for a new event to arrive.
    /// When an event arrives, the given object is filled with details.
    /// Returns the same object (but filled) for chaining.
    let WaitForEvent (handle: NativeEventHandle) (obj: NativeObject) =
        let ret = Extern.cps_api_wait_for_event.Invoke(handle, obj)
        if ret = 0 then
            Ok obj
        else
            Error (sprintf "Cannot receive event (Return value: %s = %d)." (ReturnValueToString ret) ret)

    /// Publishes an event to the CPS system.
    let PublishEvent (handle: NativeEventHandle) (obj: NativeObject) =
        let ret = Extern.cps_api_event_publish.Invoke(handle, obj)
        if ret = 0 then
            Ok ()
        else
            Error (sprintf "Cannot publish event (Return value: %s = %d)." (ReturnValueToString ret) ret)


// Augments the NativeObjectIterator with methods useful for traversing attribute tree
type NativeObjectIterator with

    /// Checks if the iterator is valid or not.
    member this.IsValid =
        if this.attr = IntPtr.Zero then
            false
        else
            let len = Marshal.ReadInt64(this.attr, sizeof<uint64>)
            let totalLen = unativeint (len + 2L * (int64 sizeof<uint64>))
            this.len >= totalLen

    /// Extracts a copy of the contents of the current attribute.
    member this.Value() =
        let len = int (Extern.cps_api_object_attr_len.Invoke(this.attr))
        let arr = Array.zeroCreate<byte> len
        Marshal.Copy(Extern.cps_api_object_attr_data_bin.Invoke(this.attr), arr, 0, len)
        arr

    /// Advances the iterator.
    member this.Next() =
        if this.attr <> IntPtr.Zero then
            let len = Marshal.ReadInt64(this.attr, sizeof<uint64>)
            let totalLen = unativeint (len + 2L * (int64 sizeof<uint64>))
            if this.len < totalLen then
                this.attr <- IntPtr.Zero
            else
                this.len <- this.len - totalLen
                this.attr <- this.attr + nativeint totalLen

    /// Returns a new iterator pointing inside the current value.
    member this.Inside() =
        let insideIt = NativeObjectIterator(attr = this.attr, len = this.len)
        insideIt.len <- unativeint (Marshal.ReadInt64(insideIt.attr, sizeof<uint64>))
        insideIt.attr <- insideIt.attr + 2n * (nativeint sizeof<uint64>)
        insideIt

    /// Returns a lazy sequence that walks the iterator.
    member this.Iterate() =
        seq {
            while this.IsValid do
                yield this
                this.Next()
        }
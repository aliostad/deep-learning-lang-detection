namespace Bindings48

open System.Linq.Expressions
open System.Reflection
open System


module ReflectionHelper =
    let rec private findValue (obj : obj) (path : list<PropertyInfo>) =
        match box obj with
        | :? ConstantExpression as e -> e.Value, path
        | :? MemberExpression as e -> findValue <| e.Expression <| [e.Member :?> PropertyInfo] @ path
        | _ -> failwith "Can't find property"

    let getSourceObject (expr : Expression) = 
        match box expr with
        | :? Expression as e -> findValue e []
        | _ -> failwith "Can't find body"
    
    let getEvents (obj : obj) = 
        let t = obj.GetType()
        let events = t.GetRuntimeEvents()
        List.ofSeq events

    let private getProperties (obj : obj) : PropertyInfo list =
        let t = obj.GetType()
        let properties = t.GetRuntimeProperties()
        List.ofSeq properties

    let rec private findProperty (property : PropertyInfo) (properties : PropertyInfo list) : PropertyInfo option =
        match properties with
        | [] -> None
        | head::tail -> 
            match head with
            | h when h.PropertyType = property.PropertyType && h.Name = property.Name -> Some (head)
            | _ -> findProperty property tail

    let private getMethodFromProperty (property: PropertyInfo option) : MethodInfo option =
        match property with
        | Some p -> Some p.GetMethod
        | None -> None

    let private invokeMethod (method : MethodInfo option) (obj : obj) : obj =
        match method with
        | Some m -> m.Invoke(obj, null)
        | None -> failwith "Can't invoke method"

       
    let private getObjectFromProperty (obj : obj) (property : PropertyInfo) : obj =
        let findPropertyInObject = getMethodFromProperty << findProperty property
        let method = findPropertyInObject <| getProperties obj
        invokeMethod method obj

    let rec getPropertyObject (root : obj) (path : PropertyInfo list) =
        match path with 
        | [x] -> root, x
        | head::tail -> getPropertyObject <| getObjectFromProperty root head <| tail
        | [] -> failwith "Something went wrong"

    let rec getPropertyValue (propertyObject : obj) (property : PropertyInfo) = 
        getObjectFromProperty propertyObject property

    let subscribeToEvent (eventHolder : obj) (eventName : string) (handler : System.Action) =
        let events = getEvents eventHolder
        let event = events
                    |> List.ofSeq
                    |> List.find (fun x -> x.Name=eventName)

        let eventHandlerType = event.EventHandlerType
        let eventMethods = eventHandlerType.GetRuntimeMethods()
        let eventMethod = eventMethods
                            |> List.ofSeq
                            |> List.find (fun x -> x.Name="Invoke")
        let parameters = eventMethod.GetParameters()
        let expressionParameters = parameters 
                                    |> List.ofSeq 
                                    |> List.map (fun x -> Expression.Parameter(x.ParameterType))
        let expressionHandler =
            let lambda = Expression.Lambda (
                                    event.EventHandlerType,
                                    Expression.Call(Expression.Constant(handler), "Invoke", null),
                                    expressionParameters)
            lambda.Compile()
        event.AddEventHandler(eventHolder, expressionHandler)
        expressionHandler
     
    let unsubscribeFromEvent (eventHolder : obj) (eventName : string) (handler : Delegate) =
        let events = getEvents eventHolder
        let event = events
                    |> List.ofSeq
                    |> List.find (fun x -> x.Name=eventName)
         
        event.RemoveEventHandler(eventHolder, handler)


module Binding =
    type BindingMode = OneWay = 0 | TwoWay = 1

    type Binding<'S, 'T>
        (
               source: 'S,
               target: 'T,
               mode: BindingMode,
               sourceObject: obj,
               targetObject: obj,
               sourceProperty: PropertyInfo,
               targetProperty: PropertyInfo
                                    ) = 
        
        let mutable defaultSourceEventName = "PropertyChanged"
        let mutable defaultTargetEventName = "PropertyChanged"

        let mutable sourceEventDelegate = null
        let mutable targetEventDelegate = null

        let mutable sourceValue = source
        let mutable targetValue = target

        member this.Source with get() = sourceValue
        member this.Target with get() = targetValue
        member this.Mode = mode
        member this.SourceObject = sourceObject
        member this.TargetObject = targetObject
        member this.SourceProperty = sourceProperty
        member this.TargetProperty = targetProperty
        member val TargetEventName = defaultTargetEventName with get, set
        member val SourceEventName = defaultSourceEventName with get, set

        member private this.OnSourceChangedHandler() =
            let source = ReflectionHelper.getPropertyValue this.SourceObject this.SourceProperty
            this.TargetProperty.SetValue(this.TargetObject, source)

            sourceValue <- (source :?> 'S)
            ()

        member private this.OnTargetChangedHandler() =
            let target = ReflectionHelper.getPropertyValue this.TargetObject this.TargetProperty
            this.SourceProperty.SetValue(this.SourceObject, target)
           
            targetValue <- (target :?> 'T)
            ()
        
        member this.Unsubscribe() =
            let unsubscribe_source() = match sourceEventDelegate with
                                       | null -> Diagnostics.Debug.WriteLine "sourceEventDelegate is null, can be already unsubscribed."
                                       | _ -> 
                                             ReflectionHelper.unsubscribeFromEvent this.SourceObject this.SourceEventName sourceEventDelegate
                                             sourceEventDelegate <- null
            let unsubscribe_target() = match targetEventDelegate with
                                       | null -> Diagnostics.Debug.WriteLine "targetEventDelegate is null, can be already unsubscribed."
                                       | _ -> 
                                             ReflectionHelper.unsubscribeFromEvent this.TargetObject this.TargetEventName targetEventDelegate
                                             targetEventDelegate <- null
            match this.Mode with
            | BindingMode.OneWay -> unsubscribe_source()
            | BindingMode.TwoWay -> unsubscribe_source()
                                    unsubscribe_target()
            | _ -> Diagnostics.Debug.WriteLine ("Unfamiliar BindingMode" + this.Mode.ToString())
            ()
          
        member this.Subscribe() =
            let subscribe_source() = match sourceEventDelegate with
                                     | null -> sourceEventDelegate <- ReflectionHelper.subscribeToEvent this.SourceObject this.SourceEventName (System.Action this.OnSourceChangedHandler)
                                     | _ -> this.Unsubscribe ()

            let subscribe_target() = match targetEventDelegate with
                                     | null -> targetEventDelegate <- ReflectionHelper.subscribeToEvent this.TargetObject this.TargetEventName (System.Action this.OnTargetChangedHandler)
                                     | _ -> this.Unsubscribe ()
            match this.Mode with
            | BindingMode.OneWay -> subscribe_source ()
            | BindingMode.TwoWay -> subscribe_source ()
                                    subscribe_target()
            | _ -> Diagnostics.Debug.WriteLine ("Unfamiliar BindingMode" + this.Mode.ToString())
            ()

    let CreateBinding<'S,'T> (s: Expression<System.Func<'S>>) (t: Expression<System.Func<'T>>) (m: BindingMode) (sub: Boolean) = 

        let root, path_to_property = ReflectionHelper.getSourceObject s.Body
        let root2, path_to_property2 = ReflectionHelper.getSourceObject t.Body

        let sourceObject, sourceProperty = ReflectionHelper.getPropertyObject root path_to_property
        let targetObject, targetProperty = ReflectionHelper.getPropertyObject root2 path_to_property2

        let source = ReflectionHelper.getPropertyValue sourceObject sourceProperty
        let target = ReflectionHelper.getPropertyValue targetObject targetProperty

        let instance = Binding(
                               source=(source :?> 'S),
                               target=(target :?> 'T),
                               mode=m,
                               sourceObject=sourceObject,
                               targetObject=targetObject,
                               sourceProperty=sourceProperty,
                               targetProperty=targetProperty
                               )

        if sub then instance.Subscribe()

        instance
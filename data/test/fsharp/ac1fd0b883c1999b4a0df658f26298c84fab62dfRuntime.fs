module Runtime

open System
open System.ComponentModel
module PropertyChanged =

    let get x = 
        try
            x |> box :?> INotifyPropertyChanged
        with _ ->
            failwithf "PropertyChanged.get x:%A is not IPropertyChanged" x 

    let private (~%%) = get
    
    let add x f =
        (%% x).PropertyChanged.Add f    

    let addAction x f =
        let f = PropertyChangedEventHandler(f)
        (%% x ).PropertyChanged.AddHandler f 
        f

    let addHandler x f =
        (%% x).PropertyChanged.AddHandler f
    
    let removeAction x f =
        (x |> box :?> ComponentModel.INotifyPropertyChanged).PropertyChanged.RemoveHandler f

    let isPropertyCahnged (t:Type) = 
        t.GetInterfaces() |> Array.exists ( (=) typeof<INotifyPropertyChanged> )

let enumPropertiesByType<'T> (ass:System.Reflection.Assembly) moduleName  = 
    let modul = ass.GetType moduleName 
    if modul=null then 
        sprintf "В сборке \"%s\" отсутствует модуль \"%s\"" (ass.FullName) moduleName
        |> failwith
    [   for prop in modul.GetProperties() do
            if prop.PropertyType=typeof<'T> then
                let x = 
                    try prop.GetGetMethod().Invoke( None, [||] ) :?> 'T with e ->
                        sprintf "Ошибка инициализации экземпляра %A %s: %A" prop.PropertyType prop.Name e |> failwith
                yield x, prop.Name]
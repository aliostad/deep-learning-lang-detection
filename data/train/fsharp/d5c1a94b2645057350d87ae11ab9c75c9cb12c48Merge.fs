module CasanovaCompiler.ParseAST.Merge
open CasanovaCompiler.ParseAST

type ModulesTree =
  { mutable moduleName  : string
    mutable included    : bool
    mutable astList     : ResizeArray<Program>
    children            : ResizeArray<ModulesTree> }
  with 
    member this.Contains (module_name : string list) =
      if this.moduleName = "" then 
        match 
          [for child in this.children do
            match child.Contains module_name with
            | None -> ()
            | elem -> yield elem] with
        | x::_ -> x
        | _ -> None
      else
        match module_name with
        | [x] -> if this.moduleName = x then 
                    if not this.included then 
                      this.included <- true
                      Some (this.astList |> Seq.toList) 
                    else Some []
                  else None
        | x::xs ->        
          if (this.moduleName = x) then 
            match 
              [for child in this.children do
                yield child.Contains xs] with
            | x::_ -> x
            | _ -> None
          else None
        | [] -> failwith "empty module not supported. Utils.ModulesTree.Contains"
      
    static member AddToTree (tree : ModulesTree) (ast : Program) (module_name : string list) =
      match module_name with
      | [] -> failwith "empty module not supported. Utils.ModulesTree.AddToTree"
      | [x] -> 
        match tree.children |> Seq.tryFind(fun child -> child.moduleName = x) with
        | Some child ->
           child.astList.Add(ast)
        | None ->
          let astList = ResizeArray<Program>()
          astList.Add(ast)
          tree.children.Add( { moduleName = x
                               astList = astList
                               included = false
                               children = ResizeArray<ModulesTree>()
                               })
      | x::xs -> 
        match tree.children |> Seq.tryFind(fun child -> child.moduleName = x) with
        | Some child ->
           ModulesTree.AddToTree child ast xs
        | None ->
          let child = 
            { moduleName = x
              included = false
              astList = ResizeArray<Program>()
              children = ResizeArray<ModulesTree>() }
          tree.children.Add(child)
          ModulesTree.AddToTree child ast xs

    member this.AddToRoot ((ast, module_name) : Program * (string list)) =
      //let module_name = module_name.Lid |> List.map(fun elem -> elem.idText)
      ModulesTree.AddToTree this ast module_name

    static member Empty() = 
        { moduleName = ""
          astList = ResizeArray<Program>()
          included = false
          children = ResizeArray<ModulesTree>() }

let rec buildModulesTreeAUX (asts : Program list) (tree : ModulesTree) =
  for ast in asts do  
    tree.AddToRoot (ast, ast.ModuleStatement.Lid |> List.map(fun li -> li.idText))

let buildModulesTree (asts : Program list) =
  let tree = ModulesTree.Empty()
  buildModulesTreeAUX  asts tree
  tree


let mutable not_included_modules_or_namespaces = Set<string list>(Seq.empty)
//TODO: manage circular references A open B and B open A
let rec getIncludedAstFromAUX (module_statement :  string list) (tree : ModulesTree) : Program list =
  match tree.Contains module_statement with
  | Some (program::_) -> 
    let opens =
      [for worldOrEntityDecl in program.WorldOrEntityDecls do
        match worldOrEntityDecl with
        | SynModuleDecl.Open(longIdentWithDots, _) -> yield longIdentWithDots.Lid |> List.map(fun id -> id.idText)
        | _ -> ()]   
    let opened_ast =
      [for op in opens do
        yield! getIncludedAstFromAUX op tree ]
    program :: opened_ast
  | Some [] -> [] //the module has already been included
  | _ -> 
    not_included_modules_or_namespaces <- not_included_modules_or_namespaces.Add(module_statement)
    []

let mergeCasanovaPrograms (main : Program) (other_files : Program list) (load_ast_from_file : string -> Program) (load_library : string -> seq<System.Type>) current_directory =
  
//  let other_files = other_files |> List.filter(fun f -> f <> main)
  let a,b  = main, other_files
  let programs, other_files = 
    main :: other_files 
    |> List.partition(fun p -> p.WorldOrEntityDecls |> List.exists(fun p' -> match p' with 
                                                                              | SynModuleDecl.World (_) -> true 
                                                                              | SynModuleDecl.Types (tps, _) -> tps |> List.exists(fun t -> snd t)
                                                                              | _ -> false))
  let d, e = programs, other_files
    

  let computer_program main =


      let opened_ast =
        let opens =
          [for worldOrEntityDecl in main.WorldOrEntityDecls do
            match worldOrEntityDecl with
            | SynModuleDecl.Open(longIdentWithDots, _) -> yield longIdentWithDots.Lid |> List.map(fun id -> id.idText)
            | _ -> ()]   



        let tree = buildModulesTree (main :: other_files)
        
        let opened_ast1 =
          [for op in opens do
            yield! getIncludedAstFromAUX op tree ]
        
        
        [for ast in opened_ast1 do
          for worldOrEntityDecl in ast.WorldOrEntityDecls do
            match worldOrEntityDecl with
            | SynModuleDecl.Types(synTypeDefn_list, _) as tp-> 
              yield tp
            | _ -> ()]

      let moduleStatement = main.ModuleStatement
      let opens =
        [for not_included_namespace_or_module in not_included_modules_or_namespaces do
          yield SynModuleDecl.Open(LongIdentWithDots(not_included_namespace_or_module |> List.map(fun elem -> Ident(elem, main.Range)), 
                                                                          [for _ in [0..not_included_modules_or_namespaces.Count-1] do yield main.Range]),
                                                        main.Range)]
      
      let main_worldOrEntityDecls =        
         [for synDecl in main.WorldOrEntityDecls do
          match synDecl with
          | SynModuleDecl.World(_) as this -> yield this
          | SynModuleDecl.OpenLibrary(lib, _) -> ()
          | SynModuleDecl.Types(synTypeDefn_list, range) ->
            yield SynModuleDecl.Types(synTypeDefn_list, range)
          | SynModuleDecl.Open(_, _) -> ()
          | SynModuleDecl.Import(_, _) -> ()
          | SynModuleDecl.EntryPoint(_) as this -> yield this
          | _ -> yield synDecl] @ opened_ast @


         [for synDecl in main.WorldOrEntityDecls do
            match synDecl with
            | SynModuleDecl.World(_) | SynModuleDecl.Types(_) | SynModuleDecl.Open(_) | SynModuleDecl.EntryPoint(_) -> ()
            | SynModuleDecl.OpenLibrary(lib, _) -> load_library lib
            | SynModuleDecl.Import(file,_) -> 
              let file = System.IO.Path.GetFullPath(System.IO.Path.Combine(current_directory,file))
//              System.Console.WriteLine ("Loading file" + file)
              let res = load_ast_from_file file
//              System.Console.WriteLine ("Elements: " + string res.WorldOrEntityDecls.Length)
              yield! res.WorldOrEntityDecls]
      
      
      let refereced_libraries = 
        let imported_types = ResizeArray<System.Type>()
        for synDecl in main.WorldOrEntityDecls do
            match synDecl with
            | SynModuleDecl.OpenLibrary(lib, _) ->       
              for l in load_library lib do
                if imported_types |> Seq.forall(fun l' -> l'.FullName <> l.FullName) then
                  imported_types.Add(l)
            | _ -> ()
        System.AppDomain.CurrentDomain.GetAssemblies() |> Seq.filter(fun a -> a.GetName().Name = "System" || 
                                                                              a.GetName().Name = "System.Core" || 
                                                                              a.GetName().Name = "mscorlib") 
                                                       |> Seq.iter(fun a -> imported_types.AddRange(a.GetTypes()))
        imported_types

      let main_worldOrEntityDecls = opens @ main_worldOrEntityDecls
      { 
        ModuleStatement     = moduleStatement
        WorldOrEntityDecls  = main_worldOrEntityDecls
        Range               = main.Range
        ReferencedLibraries = refereced_libraries
      }
  [for program in programs do yield computer_program program]
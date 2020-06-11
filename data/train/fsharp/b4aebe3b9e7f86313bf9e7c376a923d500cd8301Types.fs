module Types

(*
The original Damas-Milner paper
(http://web.cs.wpi.edu/~cs4536/c12/milner-damas_principal_types.pdf) identifies
four different kinds of types, organized into two classes:

- Types
  - Type variables (HKTs are not allowed for)
  - Base types (Unit, Bool, Int, etc.) which don't require type parameters
  - Function types, which we generalize to any fully-applied parameterized
    type.
- Type schemes
  - Types themselves
  - Universally quantified types, which bind a variable across a type scheme

For example, within the definition:

    type List a {
        Nil;
        Cons of (a, List a);
    }

    def zero? x -> x = 0

    def head lst ->
      match lst in {
        \Cons (head, _) -> head
      }

We have:

    List :: ∀a. List a
    Nil :: ∀a. List a
    Cons :: ∀a. (a, List a) -> List a
    zero? :: Int -> Bool
    head :: ∀a. List a -> a
*)

/// <summary>
/// A base type is a type that does not involve a quantifier (though it might
/// be inside of a universal scheme which has one).
/// </summary>
type Type<'tag> =
    | TypeVar of 'tag * int
    | TypeCon of 'tag * Bindings.Type * Type<'tag> list

/// <summary>
/// Retrieves the tag attached to a type scheme.
/// </summary>
let get_type_tag (ty: Type<'tag>) =
    match ty with
    | TypeVar (tag, _) -> tag
    | TypeCon (tag, _, _) -> tag

/// <summary>
/// Maps the tags of a type through a function.
/// </summary>
let rec map_type_tag (f: 'a -> 'b) (ty: Type<'a>) =
    match ty with
    | TypeVar (tag, var) -> TypeVar (f tag, var)
    | TypeCon (tag, ctor, args) -> 
        TypeCon (f tag, ctor, args |> List.map (map_type_tag f))

/// <summary>
/// Finds the variables in a type.
/// </summary>
let rec vars_in_type (ty: Type<'tag>) =
    match ty with
    | TypeVar (_, var) -> Set.add var Set.empty
    | TypeCon (_, _, args) ->
        args
        |> List.map vars_in_type
        |> Set.unionMany

/// <summary>
/// Type constraints are extra restrictions placed on top of types, to ensure
/// the soundness of the type system.
/// </summary>
/// <remarks>
/// The only one currently available is Equatable, which ensures that a type
/// can be tested for equality.
/// </remarks>
type Constraint =
    | Equatable

/// <summary>
/// Constraint environments manage the constraints on the type variables that
/// are currently in scope.
/// </summary>
type ConstraintEnvironment = Map<int, Set<Constraint>>

/// <summary>
/// Returns the set of constraints that apply to the type variable, or an empty
/// set if none apply.
/// </summary>
let get_constraints (env: ConstraintEnvironment) (tvar: int) =
    match Map.tryFind tvar env with
    | Some constraints -> constraints
    | None -> Set.empty

/// <summary>
/// A type scheme is a structure that can be instantiated to produce another
/// scheme, which is more specific than the original scheme.
/// </summary>
type Scheme<'tag> =
    | BaseScheme of 'tag * Type<'tag>
    | UniversalScheme of 'tag * (int * Set<Constraint>) list * Scheme<'tag>

/// <summary>
/// Retrieves the tag attached to a type scheme.
/// </summary>
let get_scheme_tag (scheme: Scheme<'tag>) =
    match scheme with
    | BaseScheme (tag, _) -> tag
    | UniversalScheme (tag, _, _) -> tag

/// <summary>
/// Maps the tags of a scheme through a function.
/// </summary>
let rec map_scheme_tag (f: 'a -> 'b) (scheme: Scheme<'a>) =
    match scheme with
    | BaseScheme (tag, ty) -> BaseScheme (f tag, map_type_tag f ty)
    | UniversalScheme (tag, vars, subscheme) ->
        UniversalScheme (f tag, vars, map_scheme_tag f subscheme)

/// <summary>
/// Finds the free variables in a scheme.
/// </summary>
let rec free_in_scheme (scheme: Scheme<'tag>) =
    match scheme with
    | BaseScheme (_, ty) -> vars_in_type ty
    | UniversalScheme (_, vars, scheme) ->
        let bound_vars =
            vars
            |> List.map fst
            |> Set.ofList
        Set.difference (free_in_scheme scheme) bound_vars

/// <summary>
/// Finds the bound variables in a scheme.
/// </summary>
let rec bound_in_scheme (scheme: Scheme<'tag>) =
    match scheme with
    | BaseScheme _ -> Set.empty
    | UniversalScheme (_, bound_constraints, subscheme) ->
        let bound = List.map fst bound_constraints
        Set.union (Set.ofList bound) (bound_in_scheme subscheme)

/// <summary>
/// This binds names to the types that they've taken on in the current
/// scope
/// </summary>
type Table<'tag> = {
    Values: Scopes.Table<string, Scheme<'tag>>
    Constructors: Scopes.Table<string, Scheme<'tag>>
}

/// <summary>
/// Finds the free variables in an environment.
/// </summary>
// Note that the original paper isn't exactly clear what this means, but WYAH
// interprets it as 'the union of all type variables free in each bound scheme'
let free_in_table (table: Table<'tag>) =
    let free_in_scoped_table (table: Scopes.Table<'a, Scheme<'b>>) =
        Map.toList table
        |> List.map snd // For the (key, value) tuple
        |> List.map snd // For the (time, binding) tuple
        |> List.map free_in_scheme
        |> Set.unionMany

    Set.union (free_in_scoped_table table.Values)
              (free_in_scoped_table table.Constructors)

/// <summary>
/// Retrieves a value's type from the bindings table, taking into account the
/// current scope as well as all scopes accessible from this one.
/// </summary>
/// <returns>
/// Either None, if no such value is accessible from the current scope,
/// or the value's type.
/// </returns>
let find_value (scope: Scopes.Token) (name: string) (time: Scopes.Time) (bindings: Table<'tag>) =
    Scopes.find_binding scope name time bindings.Values

/// <summary>
/// Retrieves a constructor's type from the bindings table, taking into account the
/// current scope as well as all scopes accessible from this one.
/// </summary>
/// <returns>
/// Either None, if no such constructor is accessible from the current scope,
/// or the constructor's type.
/// </returns>
let find_ctor (scope: Scopes.Token) (name: string) (time: Scopes.Time) (bindings: Table<'tag>) =
    Scopes.find_binding scope name time bindings.Constructors

/// <summary>
/// TypeVars is responsible for generating fresh type variables.
/// </summary>
type TypeVars<'tag> () =
    let mutable counter = 0

    // Necessary for testing, since a defacto TypeVars is shared
    member x.Reset (value: int) = counter <- value

    member x.Next (tag: 'tag) =
        counter <- counter + 1
        TypeVar (tag, counter)

/// <summary>
/// The TypeVars instance used by the type lifter and type checker.
/// </summary>
let fresh_typevar = new TypeVars<AST.Id>()

/// <summary>
/// Creates a function type that maps the parameter type to the return type.
/// </summary>
let function_type (tag: 'tag) (param_type: Type<'tag>) (ret_type: Type<'tag>) =
    TypeCon (tag, Bindings.BuiltinTB Bindings.FunctionType, [param_type; ret_type])

/// <summary>
/// Creates a product type for the given input types.
/// </summary>
let product_type (tag: 'tag) (types: Type<'tag> list) =
    let product_type = Bindings.ProductType (List.length types)
    TypeCon (tag, Bindings.BuiltinTB product_type, types)

/// <summary>
/// Wraps a primitive type in a type constructor.
/// </summary>
/// <remarks>
/// Should only be used with types that do not expect type arguments.
/// </remarks>
let primitive_type (tag: 'tag) (builtin: Bindings.BuiltinType) =
    TypeCon (tag, Bindings.BuiltinTB builtin, [])

/// <summary>
/// Performs a type substitution, replacing any type variables found in the
/// substitution map with their targets, until no substitutions can be made.
/// </summary>
let rec substitute_type (subst: Map<int, Type<'tag>>) (ty: Type<'tag>) =
    match ty with
    | TypeVar (_, var) ->
        match Map.tryFind var subst with
        | None -> ty
        | Some replacement -> substitute_type subst replacement

    | TypeCon (tag, ctor, args) ->
        TypeCon (tag, ctor, args |> List.map (substitute_type subst))

let substitute_types (subst: Map<int, Type<'tag>>) (tys: Type<'tag> list) =
    List.map (substitute_type subst) tys

/// <summary>
/// Performs a substitution over a type scheme, respecting type variables bound
/// by quantifiers.
/// </summary>
let rec substitute_scheme (subst: Map<int, Type<'tag>>) (scheme: Scheme<'tag>) =
    match scheme with
    | BaseScheme (tag, ty) -> BaseScheme (tag, substitute_type subst ty)
    | UniversalScheme (tag, bound_var_constraints, subscheme) ->
        // We can ignore the constraints here, since anything that is
        // constrained is bound, and thus isn't changed by the substitution
        let bound_vars = List.map fst bound_var_constraints

        let subst_without_bound =
            subst
            |> Map.filter (fun var _ -> not (List.contains var bound_vars))

        let subst_subscheme = substitute_scheme subst_without_bound subscheme
        UniversalScheme (tag, bound_var_constraints, subst_subscheme)

/// <summary>
/// Applies the types to the given type scheme, replacing quantified variables
/// with actual types.
/// </summary>
let rec substitute_bound_scheme (subst_args: Type<AST.Id> list) (scheme: Scheme<'tag>) =
    let rec make_subst (subst: Map<int, Type<AST.Id>>) (scheme: Scheme<'tag>) =
        match scheme with
        | BaseScheme (_, ty) -> substitute_type subst ty
        | UniversalScheme (_, bound_var_constraints, subscheme) ->
            let bound_subst =
                bound_var_constraints
                |> List.mapi (fun idx (var, _) -> (var, List.item idx subst_args))
                |> Map.ofList
            make_subst bound_subst subscheme

    make_subst Map.empty scheme

/// <summary>
/// Performs a type substitution within a type binding update.
/// </summary>
let substitute_update (subst: Map<int, Type<'tag>>) ((scope, name, time, scheme): Scopes.Update<string, Scheme<'tag>>) =
    (scope, name, time, substitute_scheme subst scheme)

let substitute_updates (subst: Map<int, Type<'tag>>) (updates: Scopes.Update<string, Scheme<'tag>> list) =
    List.map (substitute_update subst) updates

/// <summary>
/// Performs a type substitution within type binding environment.
/// </summary>
let substitute_table (subst: Map<int, Type<'tag>>) (bindings: Table<'tag>) : Table<'tag> =
    let subst_scoped_table (tbl: Scopes.Table<string, Scheme<'tag>>) =
        tbl
        |> Map.map (fun _ (time, scheme) -> (time, substitute_scheme subst scheme))

    {Values=subst_scoped_table bindings.Values;
     Constructors=subst_scoped_table bindings.Constructors}

/// <summary>
/// Returns true if a variable occurs in a type, or false otherwise.
/// </summary>
let rec occurs_check (target_var: int) (ty: Type<'tag>) =
    vars_in_type ty
    |> Set.contains target_var

/// <summary>
/// Replaces all the bound type variables in a scheme with fresh type variables, and
/// returns the unwrapped version of the substituted scheme..
/// </summary>
let rec freshen (new_id: 'newtag) (env: ConstraintEnvironment) (scheme: Scheme<'tag>) =
    let rec extract_type (scheme: Scheme<'tag>) =
        match scheme with
        | BaseScheme (_, ty) -> ty
        | UniversalScheme (_, _, scheme) -> extract_type scheme

    let tag = get_scheme_tag scheme
    let fresh_subst =
        bound_in_scheme scheme
        |> Set.map (fun var -> (var, fresh_typevar.Next tag))
        |> Map.ofSeq

    let new_type =
        extract_type scheme
        |> substitute_type fresh_subst
        |> map_type_tag (fun _ -> new_id)

    let new_constraints =
        match scheme with
        | BaseScheme _ -> env
        | UniversalScheme (_, bound_var_constraints, _) ->
            bound_var_constraints
            |> List.fold (fun env (var, constraints) ->
                          let (TypeVar (_, fresh_var)) = Map.find var fresh_subst
                          Map.add fresh_var constraints env)
                         env

    (new_type, new_constraints)

/// <summary>
/// Generates the 'closure' of a type, by wrapping it in quantifiers for each
/// of its variables that are free in the type but not constrained by the
/// environment. It also carries along any inferred constraints into the
/// scheme it creates.
/// </summary>
/// <remarks>
/// This is only use for let expressions, because only they can create
/// polymorphic bindings. (Other things might inherit them, but only let
/// can create them).
/// </remarks>
let type_closure (bindings: Table<'tag>) (env: ConstraintEnvironment) (ty: Type<'tag>) =
    let free_bindings_vars = free_in_table bindings
    let enclosed_vars = Set.difference (vars_in_type ty) free_bindings_vars

    let tag = get_type_tag ty
    let base_scheme = BaseScheme (tag, ty)
    if Set.isEmpty enclosed_vars then
        base_scheme
    else
        let var_constraints =
            enclosed_vars
            |> Seq.map (fun var -> (var, get_constraints env var))
            |> List.ofSeq

        UniversalScheme (tag, var_constraints, base_scheme)

/// <summary>
/// Lifts a type into a scheme, by wrapping it in a BaseScheme.
/// </summary>
let lift_type (ty: Type<'tag>) =
    BaseScheme (get_type_tag ty, ty)

namespace Flame.Loyc

open Loyc
open Loyc.Syntax
open Flame
open Flame.Compiler
open Flame.Compiler.Expressions
open Flame.Functional
open Pixie

module ExpressionConverters =
    /// Creates a function that returns the given constant.
    let Constant<'a, 'b> (result : 'b) = fun (_ : 'a) -> result

    /// Creates a new node converter from the given predicate and converter function.
    let CreateConverter<'a> predicate convert =
        new SingleNodeConverter<'a>(predicate, convert)

    /// Creates a predicate function that matches nodes with the given number
    /// of arguments.
    let MatchesArgumentCount count =
        fun (node : LNode) -> node.ArgCount = count

    /// Creates an n-ary node converter with the given converter.
    let CreateNAryConverter n =
        CreateConverter (MatchesArgumentCount n)

    /// Defines a nullary node converter with the given converter.
    let CreateNullaryConverter converter =
        CreateNAryConverter 0 converter

    /// Defines a unary node converter with the given converter.
    let CreateUnaryConverter converter =
        CreateNAryConverter 1 converter

    /// Defines a binary node converter with the given converter.
    let CreateBinaryConverter converter =
        CreateNAryConverter 2 converter

    /// Defines a binary node converter with the given converter.
    let CreateTernaryConverter converter =
        CreateNAryConverter 3 converter

    /// Defines a converter that simply returns a constant.
    let DefineConstantConverter value =
        CreateConverter (Constant true) (value |> Constant |> Constant |> Constant)

    /// Defines a nullary operator with the given converter.
    let DefineScopedNullaryOperator converter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            converter scope, scope

        CreateNullaryConverter conv

    /// Defines a unary operator that acts on expressions.
    let DefineScopedUnaryOperator converter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let expr, newScope = parent.ConvertExpression node.Args.[0] scope
            converter newScope expr, newScope

        CreateUnaryConverter conv

    /// Defines a binary operator with the given converter.
    let DefineScopedBinaryOperator converter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let        newScope = scope
            let expr1, newScope = parent.ConvertExpression node.Args.[0] newScope
            let expr2, newScope = parent.ConvertExpression node.Args.[1] newScope
            converter newScope expr1 expr2, newScope

        CreateBinaryConverter conv

    /// Defines a binary operator with the given converter.
    let DefineScopedTypeBinaryOperator converter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let      newScope = scope
            let lhs, newScope = parent.ConvertExpression node.Args.[0] newScope
            let rhs           = parent.ConvertType node.Args.[1] newScope
            converter newScope lhs rhs, newScope

        CreateBinaryConverter conv

    /// Defines a ternary operator with the given converter.
    let DefineScopedTernaryOperator converter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let        newScope = scope
            let expr1, newScope = parent.ConvertExpression node.Args.[0] newScope
            let expr2, newScope = parent.ConvertExpression node.Args.[1] newScope
            let expr3, newScope = parent.ConvertExpression node.Args.[2] newScope
            converter newScope expr1 expr2 expr3, newScope

        CreateTernaryConverter conv

    /// Defines a nullary operator with the given converter.
    let DefineNullaryOperator value =
        DefineScopedNullaryOperator (Constant value)

    /// Defines a unary operator that acts on expressions.
    let DefineUnaryOperator converter =
        DefineScopedUnaryOperator (Constant converter)

    /// Defines a binary operator with the given converter.
    let DefineBinaryOperator converter =
        DefineScopedBinaryOperator (Constant converter)

    /// Defines a ternary operator with the given converter.
    let DefineTernaryOperator converter =
        DefineScopedTernaryOperator (Constant converter)

    /// Defines a binary assignment operator based on the given converter.
    /// Said converter need not perform the assignment itself: it should compute
    /// the right-hand side of the assignment instead.
    let DefineBinaryAssignmentOperator (converter : LocalScope -> IExpression -> IExpression -> IExpression) =
        DefineScopedBinaryOperator (fun scope lhs rhs -> ExpressionBuilder.Assign scope lhs (converter scope lhs rhs))

    let MakeUnsafeConverter (converter : SingleNodeConverter<IExpression * LocalScope>) : SingleNodeConverter<IExpression * LocalScope> =
        let convUnsafe parent node scope =
            let inner, scope = converter.Convert parent node scope
            let logWarning = match scope.Function.Function with
                             | Some declFunc -> not(UnsafeHelpers.IsUnsafe declFunc) && UnsafeHelpers.MissingUnsafeWarning.UseWarning scope.Global.Log.Options
                             | None          -> false
            if logWarning then
                let descNode =
                    UnsafeHelpers.MissingUnsafeWarning.CreateMessage(
                        "Unsafe code should not appear outside of an unsafe context. " +
                        "Add 'unsafe' to the enclosing member to make this warning go away. ")

                let srcLoc =
                    match scope.Function.Function with
                    | Some x -> x.GetSourceLocation()
                    | None   ->
                        match scope.Function.Type with
                        | Some x -> x.GetSourceLocation()
                        | None   -> null

                let entry =
                    new LogEntry(
                        "Unsafe code in safe context",
                        [descNode; srcLoc.CreateRemarkDiagnosticsNode("Expected 'unsafe' here: ")])

                inner |> ExpressionBuilder.Warning entry, scope
            else
                inner, scope

        new SingleNodeConverter<IExpression * LocalScope>(converter.Matches, convUnsafe)

    /// Converts a scoped expression.
    /// Note that an IExpression is returned, instead of an IExpression * LocalScope,
    /// as this function should not be exposed as a converter directly.
    /// Doing so anyway and registering it will most likely end up in infinite recursion.
    let ConvertScopedExpression (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
        parent.ConvertExpression node scope.ChildScope ||> ExpressionBuilder.Scope

    /// A converter for an ambiguous `+` operator.
    let AddOrConcatConverter =
        let convAdd (scope : LocalScope) (left : IExpression) (right : IExpression) =
            if left.Type = PrimitiveTypes.String || right.Type = PrimitiveTypes.String then
                ExpressionBuilder.Binary Operator.Concat scope (ExpressionBuilder.Cast scope left PrimitiveTypes.String) (ExpressionBuilder.Cast scope right PrimitiveTypes.String)
            else
                ExpressionBuilder.Binary Operator.Add scope left right
        DefineScopedBinaryOperator convAdd

    /// A converter for if-then expressions, which are of type void.
    let IfConverter =
        let convIf (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let cond, newScope = parent.ConvertExpression node.Args.[0] scope
            let scopedBody     = ConvertScopedExpression parent node.Args.[1] newScope
            ExpressionBuilder.If scope cond scopedBody, newScope
        CreateBinaryConverter convIf

    /// A converter for select/if-then-else expressions.
    let SelectConverter =
        let convIfElse (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let cond, newScope = parent.ConvertExpression node.Args.[0] scope
            let ifBody         = ConvertScopedExpression parent node.Args.[1] newScope
            let elseBody       = ConvertScopedExpression parent node.Args.[2] newScope
            ExpressionBuilder.Select scope cond ifBody elseBody, newScope
        CreateTernaryConverter convIfElse

    /// A converter for while expressions.
    let WhileConverter =
        let convWhile (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let cond, newScope = parent.ConvertExpression node.Args.[0] scope
            let tag            = new UniqueTag()
            let innerScope     = newScope.FlowChildScope tag
            let scopedBody     = ConvertScopedExpression parent node.Args.[1] innerScope
            ExpressionBuilder.While tag cond scopedBody, newScope
        CreateBinaryConverter convWhile

    /// A converter for do-while expressions.
    let DoWhileConverter =
        let convDoWhile (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let tag            = new UniqueTag()
            let innerScope     = scope.FlowChildScope tag
            let scopedBody     = ConvertScopedExpression parent node.Args.[0] innerScope
            let cond           = ConvertScopedExpression parent node.Args.[1] innerScope
            ExpressionBuilder.DoWhile tag scopedBody cond, scope
        CreateBinaryConverter convDoWhile

    /// A converter for `for`-loop expressions.
    let ForConverter =
        let convFor (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let tag            = new UniqueTag()
            let newScope       = scope.ChildScope
            let init, newScope = parent.ConvertExpression node.Args.[0] newScope
            let cond, newScope = parent.ConvertExpression node.Args.[1] newScope
            let delta          = ConvertScopedExpression parent node.Args.[2] newScope
            let body           = newScope.FlowChildScope tag |> ConvertScopedExpression parent node.Args.[3]
            ExpressionBuilder.Scope (ExpressionBuilder.For tag init cond delta body) newScope, scope

        CreateNAryConverter 4 convFor

    /// Converts an unscoped sequence of nodes by invoking the given block builder.
    /// The resulting block *does not* manage its own scope.
    /// Instead, it works with whatever scope it's passed.
    let ConvertUnscopedSequence (blockBuilder : seq<IExpression> -> IExpression) (parent : INodeConverter) (nodes : seq<LNode>) (scope : LocalScope) =
        let appendItem (list, scope) elem =
            let convExpr, newScope = parent.ConvertExpression elem scope
            convExpr :: list, newScope

        let foldedItems, bodyScope = nodes |> Seq.fold appendItem ([], scope)
        blockBuilder (List.rev foldedItems), bodyScope

    /// Converts a block node by invoking the given block builder.
    /// The resulting block *does not* manage its own scope.
    /// Instead, it works with whatever scope it's passed.
    let ConvertUnscopedBlock (blockBuilder : seq<IExpression> -> IExpression) (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
        ConvertUnscopedSequence blockBuilder parent node.Args scope

    /// Converts a block node by invoking the given block builder.
    /// The resulting block *does* manage its own scope.
    let ConvertScopedBlock (blockBuilder : seq<IExpression> -> IExpression) (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
        ConvertUnscopedBlock blockBuilder parent node scope.ChildScope ||> ExpressionBuilder.Scope, scope

    /// A block converter for void blocks.
    let VoidBlockConverter = CreateConverter (Constant true) (ConvertScopedBlock ExpressionBuilder.VoidBlock)

    /// A block converter for comma blocks.
    let CommaConverter = CreateConverter (Constant true) (ConvertUnscopedBlock ExpressionBuilder.Comma)

    /// Creates an error expression that represents an error (`#error`) node.
    let ConvertError (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
        let message     = string node.Args.[0].Value
        let sourceRange = NodeHelpers.ToSourceLocation node.Range
        let sourceRange = if sourceRange.Length = 0 then new SourceLocation(sourceRange.Document, sourceRange.Position, 1) else sourceRange
        let entry       = new LogEntry("Invalid syntax", message, sourceRange)
        ExpressionBuilder.VoidError entry, scope

    /// Creates a warning expression that represents a warning (`#warning`) node.
    let ConvertWarning (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
        let message     = string node.Args.[0].Value
        let sourceRange = NodeHelpers.ToSourceLocation node.Range
        let sourceRange = if sourceRange.Length = 0 then new SourceLocation(sourceRange.Document, sourceRange.Position, 1) else sourceRange
        let entry       = new LogEntry("Syntax-level warning", message, sourceRange)
        ExpressionBuilder.Warning entry ExpressionBuilder.Void, scope

    let ErrorConverter = CreateUnaryConverter ConvertError
    let WarningConverter = CreateUnaryConverter ConvertWarning

    let private convertQuickbind (valueGetter : LNode -> LNode) (nameGetter : LNode -> LNode) (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
        let valueNode      = valueGetter node
        let name           = (nameGetter node).Name.Name
        let expr, newScope = parent.ConvertExpression valueNode scope
        ExpressionBuilder.Quickbind newScope expr name

    /// A converter for quickbind expressions.
    let QuickbindConverter =
        CreateBinaryConverter (convertQuickbind (fun node -> node.Args.[0]) (fun node -> node.Args.[1]))

    /// A converter for quickbind-set expressions.
    let QuickbindSetConverter =
        CreateBinaryConverter (convertQuickbind (fun node -> node.Args.[1]) (fun node -> node.Args.[0]))

    /// Converts a single variable definition, with the given type inference function.
    let ConvertVariableDefinition (inferType : IExpression -> IType) (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
        match NodeHelpers.GetIdNode node with
        | None ->
            let message = new LogEntry("Invalid variable declaration",
                                       "A variable declaration must reference an identifier node, " +
                                       "which was not found in '" + node.Print() + "'.")
            ExpressionBuilder.VoidError message, scope
        | Some identifier ->
            match (inferType null, NodeHelpers.GetAssignedValueNode node) with
            | (null, None) ->
                let message = new LogEntry("Invalid variable declaration",
                                           "A variable declaration that infers its type must be assigned a value, " +
                                           "which was not found in '" + node.Print() + "'.")
                ExpressionBuilder.VoidError message, scope

            | (null, Some assignedVal) ->
                let expr, newScope  = parent.ConvertExpression assignedVal scope
                let local, newScope = (inferType expr, identifier.Name.Name) ||> ExpressionBuilder.DeclareLocal newScope
                ExpressionBuilder.Assign newScope local expr, newScope

            | (varType, None) ->
                ExpressionBuilder.DeclareLocal scope varType identifier.Name.Name

            | (varType, Some assignedVal) ->
                let local, newScope = ExpressionBuilder.DeclareLocal scope varType identifier.Name.Name
                let expr, newScope  = parent.ConvertExpression assignedVal newScope
                ExpressionBuilder.Assign newScope local expr, newScope

    /// A node converter for variable declarations.
    let VariableDeclarationConverter =
        let convDeclVar (parent : INodeConverter) (node : LNode) (scope : LocalScope) =
            let typeNode = node.Args.[0]

            let inferType = if typeNode.Name = CodeSymbols.Missing then
                                fun (arg : IExpression) -> arg.GetTypeOrNull()
                            else
                                parent.ConvertType typeNode scope |> Constant

            let foldDef (init, currentScope) item =
                let result, currentScope = ConvertVariableDefinition inferType parent item currentScope
                ExpressionBuilder.Initialize init result, currentScope

            node.Args.Slice(1) |> Seq.fold foldDef (ExpressionBuilder.Void, scope)

        CreateConverter (Constant true) convDeclVar

    /// A type converter that tries to retrieve the root type.
    let RootTypeConverter =
        let getRootType (scope : LocalScope) = scope.Global.Environment.RootType
        CreateConverter (Constant true) (getRootType |> Constant |> Constant)

    /// A converter for generic instance expressions.
    let GenericInstanceConverter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
            let tgt, scope = parent.ConvertExpression node.Args.[0] scope
            let tArgs      = node.Args.Slice(1) |> Seq.map (parent.ConvertType >> ((|>) scope))
            ExpressionBuilder.InstantiateGenericDelegates scope tgt tArgs, scope
        let matches (node : LNode) =
            node.ArgCount > 1
        CreateConverter matches conv


    /// Converts an argument expression, which may have a `#ref` attribute.
    let ConvertArgumentExpression (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
        let expr, scope = parent.ConvertExpression node scope
        if node.Attrs |> Seq.exists (fun x -> x.Name = CodeSymbols.Ref || x.Name = CodeSymbols.Out) then
            ExpressionBuilder.AddressOf expr |> ExpressionBuilder.Source (NodeHelpers.ToSourceLocation node.Range), scope
        else
            expr, scope

    /// Converts a sequence of argument expressions, which may have `#ref` attributes.
    let ConvertArgumentExpressions (parent : INodeConverter) (nodes : LNode seq) (scope : LocalScope) =
        nodes |> Seq.fold (fun (results, scope) arg -> let res, scope = ConvertArgumentExpression parent arg scope in res :: results, scope) ([], scope)

    /// Converts an invocation expression.
    let ConvertInvocation (target : IExpression) (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
        let args, scope = ConvertArgumentExpressions parent node.Args scope
        let args        = List.rev args
        ExpressionBuilder.Invoke scope target args, scope

    /// Converts a new-instance expression.
    let ConvertNewInstance (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
        let call         = node.Args.[0]
        let instanceType = parent.ConvertType call.Target scope
        let args, scope  = ConvertArgumentExpressions parent call.Args scope
        ExpressionBuilder.NewInstance scope instanceType args, scope

    let private convertArrayDimensions (parent : INodeConverter) (nodes : LNode seq) (scope : LocalScope) : IExpression seq * LocalScope =
        let dims, scope  = parent.ConvertExpressions nodes scope
        let dims         = dims |> Seq.map (ExpressionBuilder.CastImplicit scope >> (|>) PrimitiveTypes.Int32)
        dims, scope

    /// Matches and converts new-array expressions.
    let NewArrayConverter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
            let call         = node.Args.[0]
            let elemType     = parent.ConvertType call.Target.Args.[1] scope
            let dims, scope  = convertArrayDimensions parent call.Args scope
            ExpressionBuilder.NewArray elemType dims, scope

        let matches (node : LNode) =
            // Matches anything that looks like:
            //
            // #new(#of(@`[...]`, T)(dims...))

            node.ArgCount = 1 &&
            let arrType = node.Args.[0].Target in
                arrType <> null &&
                arrType.Target <> null &&
                arrType.Target.Name = CodeSymbols.Of &&
                arrType.ArgCount = 2 &&
                CodeSymbols.IsArrayKeyword arrType.Args.[0].Name

        CreateConverter matches conv

    let private convertInitializedArrayItems (parent : INodeConverter) (elemType : IType) (nodes : LNode seq) (scope : LocalScope) =
        let args, scope  = parent.ConvertExpressions nodes scope
        let args         = args |> Seq.map (ExpressionBuilder.CastImplicit scope >> (|>) elemType)
        args, scope

    /// Matches and converts manually typed initialized array expressions.
    let InitializedTypedArrayConverter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
            let call         = node.Args.[0]
            let elemType     = parent.ConvertType call.Target.Args.[1] scope
            let dims, scope  = convertArrayDimensions parent call.Args scope
            let args, scope  = convertInitializedArrayItems parent elemType (node.Args.Slice(1)) scope

            let resultExpr = ExpressionBuilder.NewInitializedArray elemType args

            let dimsRank = Seq.length dims
            if dimsRank = 0 then
                resultExpr, scope // Easy. Just infer the array's length.
            else if dimsRank <> 1 then
                resultExpr |> ExpressionBuilder.Error (new LogEntry("Unsupported feature",
                                                                    "Initialized arrays of rank greater than one are not supported yet.")), scope
            else
                let constDim = dims |> Seq.exactlyOne |> NodeExtensions.EvaluateConstant
                if constDim = null then
                    resultExpr |> ExpressionBuilder.Error (new LogEntry("Variable array length",
                                                                        "The given array length could not be evaluated at compile-time.")), scope
                else if constDim.GetInt32Value() <> Seq.length args then
                    resultExpr |> ExpressionBuilder.Error (new LogEntry("Array initialization length mismatch",
                                                                        "Expected an initializer list of length '" + string(constDim.GetInt32Value()) + "', got one of length '" + string(Seq.length args) + "'.")), scope
                else
                    resultExpr, scope

        let matches (node : LNode) =
            // Matches anything that looks like:
            //
            // #new(#of(@`[...]`, T)(dims...), args...)

            node.ArgCount > 1 &&
            let arrType = node.Args.[0].Target in
                (arrType <> null &&
                 arrType.Target <> null &&
                 arrType.Target.Name = CodeSymbols.Of &&
                 arrType.ArgCount = 2 &&
                 CodeSymbols.IsArrayKeyword arrType.Args.[0].Name)

        CreateConverter matches conv

    /// Matches and converts automatically typed initialized array expressions.
    let InitializedAutoArrayConverter =
        let conv (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
            let args, scope  = parent.ConvertExpressions (node.Args.Slice(1)) scope
            let lowerBounds  = args |> Seq.map (fun x -> x.Type)
                                    |> MemberHelpers.UpperBounds (fun x y -> x.Is(y))
            if lowerBounds |> Seq.skip 1 |> Seq.isEmpty then
                ExpressionBuilder.NewInitializedArray (Seq.exactlyOne lowerBounds) args, scope
            else
                let optionList = lowerBounds |> Seq.map scope.Global.TypeNamer
                                             |> Seq.map (fun name -> new MarkupNode(NodeConstants.TextNodeType, name))
                                             |> (fun options -> ListExtensions.Instance.CreateList("Irreconcilable item types:", options))
                let message    = new MarkupNode(NodeConstants.TextNodeType, "Could not infer the automatically typed array's element type, because the array's item types could not be reconciled.")
                let contents   = new MarkupNode("entry", Seq.ofArray [| message; optionList |])

                ExpressionBuilder.NewInitializedArray scope.Global.Environment.RootType args |>
                    ExpressionBuilder.Error (new LogEntry("Ambiguous array type",
                                                          contents)), scope

        let matches (node : LNode) =
            // Matches anything that looks like:
            //
            // #new([], args...)
            node.ArgCount > 1 && node.Args.[0].Name = CodeSymbols.Array

        CreateConverter matches conv

    /// Converts an indexed expression, such as `arr[0]`.
    let ConvertIndexed (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
        let inner, scope = parent.ConvertExpression node.Args.[0] scope
        let args, scope  = ConvertArgumentExpressions parent (node.Args.Slice(1)) scope
        ExpressionBuilder.Index scope inner args, scope

    /// Converts member access.
    let MemberAccessConverter =
        let convStaticMemberAccess (parent : INodeConverter) (left : LNode) (right : LNode) (scope : LocalScope) : IExpression * LocalScope =
            match parent.TryConvertType left scope with
            | Some ty ->
                ExpressionBuilder.AccessNamedMembers scope right.Name.Name (Global ty), scope
            | None    ->
                let error = ExpressionBuilder.VoidError (new LogEntry("Unresolved type", "Could not resolve type '" + left.Print() + "' on the left-hand side of a member access operation."))
                ExpressionBuilder.Source (NodeHelpers.ToSourceLocation left.Range) error, scope

        let convMemberAccess (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
            let left, right = node.Args.[0], node.Args.[1]
            match parent.TryConvertExpression left scope with
            | Some(expr, newScope) ->
                if ExpressionBuilder.IsError expr then
                    convStaticMemberAccess parent left right scope
                else
                    ExpressionBuilder.AccessNamedMembers scope right.Name.Name (ExpressionBuilder.GetAccessedExpression expr), newScope
            | None                 ->
                convStaticMemberAccess parent left right scope

        CreateBinaryConverter convMemberAccess

    /// Converts 'default' expressions.
    let DefaultExpressionConverter =
        let convDefault (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression * LocalScope =
            let exprType = parent.ConvertType node.Args.[0] scope
            ExpressionBuilder.Default exprType, scope

        CreateUnaryConverter convDefault

    /// Converts a `void` or `missing` identifier.
    let ConvertVoidIdentifier (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression option =
        if node.Name = CodeSymbols.Void || node.Name = CodeSymbols.Missing then
            Some ExpressionBuilder.Void
        else
            None

    /// Converts an identifier that identifies a local variable.
    let ConvertLocalIdentifier (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression option =
        match scope.GetVariable(node.Name.Name) with
        | Some localVar -> Some (localVar.CreateGetExpression())
        | None          -> None

    /// Converts a member identifier.
    let ConvertMemberIdentifier (getAccessedExpr : LocalScope -> AccessedExpression option) (parent : INodeConverter) (node : LNode) (scope : LocalScope) : IExpression option =
        match getAccessedExpr scope with
        | None      -> None
        | Some expr ->
            let accExpr = ExpressionBuilder.AccessNamedMembers scope node.Name.Name expr
            if ExpressionBuilder.IsError accExpr then
                None
            else
                Some accExpr

    /// Converts an identifier that identifies a type member of the current object instance.
    let ConvertInstanceIdentifier : IdentifierConverter =
        let getAccExpr (scope : LocalScope) =
            match scope.GetVariable(CodeSymbols.This.Name) with
            | None         -> None
            | Some thisVar -> Some (ExpressionBuilder.GetAccessedExpression (thisVar.CreateGetExpression()))
        ConvertMemberIdentifier getAccExpr

    /// Converts an identifier that identifies a static type member of the enclosing type.
    let ConvertStaticIdentifier : IdentifierConverter =
        let getAccExpr (scope : LocalScope) =
            match scope.Function.Type with
            | None    -> None
            | Some ty -> Some (Global ty)
        ConvertMemberIdentifier getAccExpr

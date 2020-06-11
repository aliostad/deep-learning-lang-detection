namespace CodeBlog.CodeFormat

///
/// Visit a CSharp syntax tree
/// and output classified tokens.
///
module internal Walker  =
    open Microsoft.CodeAnalysis
    open Microsoft.CodeAnalysis.CSharp
    open Microsoft.CodeAnalysis.CSharp.Syntax
    open Model
    open System.Text.RegularExpressions
//    open Microsoft.CodeAnalysis.Shared.Utilities
    let inline getMemberInfo arg = 
        let memberType = let memberTotalType = ( ^a : (member Type : ITypeSymbol) arg)
                         match ( ^a : (member Type : ITypeSymbol) arg).SpecialType  with
                         | SpecialType.None -> memberTotalType.Name.ToString()
                         | _ -> memberTotalType.ToDisplayString()
        let containingType = ( ^a : (member ContainingType : INamedTypeSymbol) arg).Name.ToString()
        let memberName = ( ^a : (member Name : string) arg)
        (memberType, containingType, memberName)

    type Walker( model : SemanticModel, lineBounds : (int*int) option ) = 
        inherit CSharpSyntaxWalker(SyntaxWalkerDepth.StructuredTrivia) with 
            let mutable Tokens = List<Token>.Empty
            let createToken (token : SyntaxToken) (t : TokenType) tooltip : Token = 
                {
                    Text = token.Text
                                |> sprintf "%s"
                    Type = t;
                    ToolTip = tooltip;
                }
            let processAnyToken t = createToken t Nothing ""

            // Should use something like :
            // http://source.roslyn.codeplex.com/#Microsoft.CodeAnalysis.Workspaces/Shared/Utilities/DocumentationComment.cs,1b3c3f5a6ae8d64d
            // if it were acessible
            let extractSummary t = 
                let r = new Regex("<summary>(.*?)<\/summary>", RegexOptions.Singleline)
                let g = r.Match(t)
                if g.Success then
                    (g.Groups.Item 1).Value.Trim()
                else 
                    "COULD NOT GET DOC" + t
                
            ///
            /// Handles different types of symbols.
            ///
            let processSymbol (n : ISymbol) (t:SyntaxToken) = 
                let processMember (mtype,ctype,mname) kind t =
                    let memberkind = match kind with
                                     | Parameter -> "parameter"
                                     | Property -> "property"
                                     | Field -> "field"
                                     | _ -> failwith "not a parameter kind"
                    let tooltip = sprintf "(%s) %s %s.%s" memberkind mtype ctype mname
                    createToken t kind tooltip
                match n.Kind with 
                    | SymbolKind.NamedType -> 
                            let typeSymbol = n :?> INamedTypeSymbol
                            let typeKind = match typeSymbol.TypeKind with 
                                           | TypeKind.Enum -> "enum"
                                           | TypeKind.Class -> "class"
                                           | TypeKind.Struct -> "struct"
                                           | TypeKind.Interface -> "interface"
                                           | _ -> "" 
                            let tooltip = sprintf "(%s) %s.%s \n%s"
                                            <| typeKind
                                            <| typeSymbol.ContainingNamespace.Name.ToString()
                                            <| typeSymbol.Name.ToString() 
                                            <| (typeSymbol.GetDocumentationCommentXml())
                            createToken t (Type typeKind) tooltip
                    | SymbolKind.Method -> 
                            let methodSymbol = n :?> IMethodSymbol
                            
                            let tooltip = (methodSymbol.ReturnType.ToDisplayString(),
                                             methodSymbol.ContainingType.Name.ToString(),
                                             methodSymbol.Name.ToString()) 
                                            |||> (sprintf "%s (method) %s %s.%s" (methodSymbol.GetDocumentationCommentXml() |> extractSummary ))
                            createToken t Method tooltip
                    | SymbolKind.Parameter -> 
                            let parameterSymbol = n :?> IParameterSymbol
                            let info = getMemberInfo parameterSymbol
                            processMember <| info 
                                          <| Parameter 
                                          <| t
                    | SymbolKind.Field -> 
                            let parameterSymbol = n :?> IFieldSymbol
                            let info = getMemberInfo parameterSymbol
                            processMember <| info 
                                          <| Field 
                                          <| t
                    | SymbolKind.Property ->
                            let parameterSymbol = n :?> IPropertySymbol
                            let info = getMemberInfo parameterSymbol
                            processMember <| info 
                                          <| Property 
                                          <| t
                    | SymbolKind.Local ->
                            let parameterSymbol = n :?> ILocalSymbol
                            let (a,_,c) = getMemberInfo parameterSymbol
                            let tooltip = sprintf "(local variable) %s %s" a c 
                            createToken t Local tooltip
                    | _ -> createToken t Nothing ""


            ///
            /// Handles Identifiers, such as Types, variables, properties, fields..
            ///
            let processIdentifierNameSyntax (token : SyntaxToken) =
                match model.GetDeclaredSymbol(token.Parent) with
                    | null -> match model.GetSymbolInfo(token.Parent).Symbol with 
                                | null -> processAnyToken token 
                                | s -> processSymbol s token // is a ref symbol
                    | s -> processSymbol s token // is a declared symbol

            ///
            /// The generated tokens
            ///
            member x.GeneratedTokens = Tokens

            ///
            /// Visit Trivias, triggered from VisitToken
            ///
            member x.ProcessTrivia (t:SyntaxTrivia) =
                let nodeType = match t.Kind() with
                                    | SyntaxKind.SingleLineCommentTrivia
                                    | SyntaxKind.MultiLineCommentTrivia
                                    | SyntaxKind.MultiLineDocumentationCommentTrivia
                                    | SyntaxKind.SingleLineDocumentationCommentTrivia
                                        -> Comment
                                    | _ -> Nothing
                let newToken = {
                            Text = t.ToFullString();
                            Type = nodeType;
                            ToolTip = "";
                        }
                Tokens <- Tokens @ newToken :: []
            
            member x.processToken (t : SyntaxToken) =
                // visit leading trivia
                t.LeadingTrivia |> Seq.iter x.ProcessTrivia

                let newToken = match t.Kind() with 
                                 | SyntaxKind.IdentifierToken -> processIdentifierNameSyntax t
//                                 | SyntaxKind.StringLiteralToken 
//                                 | SyntaxKind.NumericLiteralToken 
// TODO : Process literal.
                                 | k when SyntaxFacts.IsLiteralExpression(t.Kind()) -> createToken t Literal ""
                                 | _  when SyntaxFacts.IsKeywordKind(t.Kind()) -> createToken t Keyword ""
                                 | _ -> processAnyToken t
                Tokens <-   Tokens @ newToken :: []
                
                // visit trailing trivia
                t.TrailingTrivia |> Seq.iter x.ProcessTrivia
            ///
            /// Visit Tokens
            ///
            override x.VisitToken (t : SyntaxToken) =
                let currLine = t.GetLocation().GetLineSpan().StartLinePosition.Line
                let shouldVisitToken = 
                    match lineBounds with 
                        | None -> true
                        | Some(startLine, endLine) when currLine <=endLine && currLine >= startLine -> true
                        | _ -> false
                if shouldVisitToken then 
                    x.processToken t
                else 
                    ()
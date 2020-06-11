//----------------------------------------------------------------------------
//
// Copyright (c) 2002-2012 Microsoft Corporation. 
//
// This source code is subject to terms and conditions of the Apache License, Version 2.0. A 
// copy of the license can be found in the License.html file at the root of this distribution. 
// By using this source code in any fashion, you are agreeing to be bound 
// by the terms of the Apache License, Version 2.0.
//
// You must not remove this notice, or any other, from this software.
//----------------------------------------------------------------------------

// Helper functions for the F# lexer lex.mll


module (*internal*) CasanovaCompiler.Compiler.Lexhelp

open System.Text
open Microsoft.FSharp.Text
open Microsoft.FSharp.Text.Lexing
open Microsoft.FSharp.Compiler
open CasanovaCompiler.ParseAST
open Microsoft.FSharp.Compiler.ErrorLogger
open CasanovaCompiler.Parser
open Microsoft.FSharp.Compiler.Internal
open Microsoft.FSharp.Compiler.Internal.Library
open Internals.Utils



// The "mock" filename used by fsi.exe when reading from stdin.
// Has special treatment by the lexer, i.e. __SOURCE_DIRECTORY__ becomes GetCurrentDirectory()
let stdinMockFilename = "stdin" 

/// Lexer args: status of #light processing.  Mutated when a #light
/// directive is processed. This alters the behaviour of the lexfilter.
[<Sealed>]
type LightSyntaxStatus(initial:bool,warn:bool) = 
    let mutable status = None
    member x.Status 
       with get() = match status with None -> initial | Some v -> v
       and  set v = status <- Some(v)
    member x.ExplicitlySet = status.IsSome
    member x.WarnOnMultipleTokens = warn
    

/// Manage lexer resources (string interning)
[<Sealed>]
type LexResourceManager() =
    let strings = new System.Collections.Generic.Dictionary<string,CasanovaCompiler.Parser.token>(100)
    member x.InternIdentifierToken(s) = 
        let mutable res = Unchecked.defaultof<_> 
        let ok = strings.TryGetValue(s,&res)  
        if ok then res  else 
        let res = IDENT s
        (strings.[s] <- res; res)

              
/// Lexer parameters 
type lexargs =  
    { defines: string list;
      ifdefStack: LexerIfdefStack;
      resourceManager: LexResourceManager;
      lightSyntaxStatus : LightSyntaxStatus;
      errorLogger: ErrorLogger }

let mkLexargs (_filename,defines,lightSyntaxStatus,resourceManager,ifdefStack,errorLogger) =
    { defines = defines;
      ifdefStack= ifdefStack;
      lightSyntaxStatus=lightSyntaxStatus;
      resourceManager=resourceManager;
      errorLogger=errorLogger }

/// Register the lexbuf and call the given function
let reusingLexbufForParsing (lexbuf : LexBuffer<char>) f = 
    use unwindBuildPhase = PushThreadBuildPhaseUntilUnwind (BuildPhase.Parse)
//    try
    f () 
//    with e ->
//      raise (WrappedError(e,(try lexbuf.LexemeRange with e -> Position.Empty)))

let resetLexbufPos filename (lexbuf: LexBuffer<char>) = 
    lexbuf.EndPos <- Position.FirstLine filename

/// Reset the lexbuf, configure the initial position with the given filename and call the given function
let usingLexbufForParsing (lexbuf:LexBuffer<char>,filename) f =
    resetLexbufPos filename lexbuf;
    reusingLexbufForParsing lexbuf (fun () -> f lexbuf)

//------------------------------------------------------------------------
// Functions to manipulate lexer transient state
//-----------------------------------------------------------------------

let defaultStringFinisher = (fun _endm _b s -> STRING (Encoding.Unicode.GetString(s,0,s.Length))) 

let callStringFinisher fin (buf: ByteBuffer) endm b = fin endm b (buf.Close())

let addUnicodeString (buf: ByteBuffer) (x:string) = buf.EmitBytes (Encoding.Unicode.GetBytes x)

let addIntChar (buf: ByteBuffer) c = 
    buf.EmitIntAsByte (c % 256);
    buf.EmitIntAsByte (c / 256)

let addUnicodeChar buf c = addIntChar buf (int c)
let addByteChar buf (c:char) = addIntChar buf (int32 c % 256)

/// When lexing bytearrays we don't expect to see any unicode stuff. 
/// Likewise when lexing string constants we shouldn't see any trigraphs > 127 
/// So to turn the bytes collected in the string buffer back into a bytearray 
/// we just take every second byte we stored.  Note all bytes > 127 should have been 
/// stored using addIntChar 
let stringBufferAsBytes (buf: ByteBuffer) = 
    let bytes = buf.Close()
    Array.init (bytes.Length / 2) (fun i -> bytes.[i*2]) 

/// Sanity check that high bytes are zeros. Further check each low byte <= 127 
let stringBufferIsBytes (buf: ByteBuffer) = 
    let bytes = buf.Close()
    let mutable ok = true 
    for i = 0 to bytes.Length / 2-1 do
        if bytes.[i*2+1] <> 0uy then ok <- false
    ok

let newline (lexbuf:LexBuffer<_>) = 
    lexbuf.EndPos <- lexbuf.EndPos.NextLine

let trigraph c1 c2 c3 =
    let digit (c:char) = int c - int '0' 
    char (digit c1 * 100 + digit c2 * 10 + digit c3)

let digit d = 
    if d >= '0' && d <= '9' then int32 d - int32 '0'   
    else failwith "digit" 

let hexdigit d = 
    if d >= '0' && d <= '9' then digit d 
    elif d >= 'a' && d <= 'f' then int32 d - int32 'a' + 10
    elif d >= 'A' && d <= 'F' then int32 d - int32 'A' + 10
    else failwith "hexdigit" 

let unicodeGraphShort (s:string) =
    if s.Length <> 4 then failwith "unicodegraph";
    uint16 (hexdigit s.[0] * 4096 + hexdigit s.[1] * 256 + hexdigit s.[2] * 16 + hexdigit s.[3])

let hexGraphShort (s:string) =
    if s.Length <> 2 then failwith "hexgraph";
    uint16 (hexdigit s.[0] * 16 + hexdigit s.[1])

let unicodeGraphLong (s:string) =
    if s.Length <> 8 then failwith "unicodeGraphLong";
    let high = hexdigit s.[0] * 4096 + hexdigit s.[1] * 256 + hexdigit s.[2] * 16 + hexdigit s.[3] in 
    let low = hexdigit s.[4] * 4096 + hexdigit s.[5] * 256 + hexdigit s.[6] * 16 + hexdigit s.[7] in 
    if high = 0 then None, uint16 low 
    else 
      (* A surrogate pair - see http://www.unicode.org/unicode/uni2book/ch03.pdf, section 3.7 *)
      Some (uint16 (0xD800 + ((high * 0x10000 + low - 0x10000) / 0x400))),
      uint16 (0xDC00 + ((high * 0x10000 + low - 0x10000) % 0x400))

let escape c = 
    match c with
    | '\\' -> '\\'
    | '\'' -> '\''
    | 'a' -> char 7
    | 'f' -> char 12
    | 'v' -> char 11
    | 'n' -> '\n'
    | 't' -> '\t'
    | 'b' -> '\b'
    | 'r' -> '\r'
    | c -> c

//------------------------------------------------------------------------
// Keyword table
//-----------------------------------------------------------------------   

exception ReservedKeyword of string * Position
exception IndentationProblem of string * Position

module Keywords = 
    type private compatibilityMode =
        | ALWAYS  (* keyword *)
        | FSHARP  (* keyword, but an identifier under --ml-compatibility mode *)

    let private keywordList = 
     [ 
      
      FSHARP, "abstract"   ,ABSTRACT;
      ALWAYS, "and"        ,AND;
      ALWAYS, "as"         ,AS;
      ALWAYS, "assert"     ,ASSERT;
      ALWAYS, "asr"        ,INFIX_STAR_STAR_OP "asr";
      ALWAYS, "base"       ,BASE;
      ALWAYS, "begin"      ,BEGIN;
      ALWAYS, ".|"         ,SELECT_OPERATOR;
      ALWAYS, "!|"         ,INT_SELECT_OPERATOR;
      ALWAYS, "=>"         ,BODY_OPERATOR;
      ALWAYS, "class"      ,CLASS;
      ALWAYS, "connecting"   ,CONNECTING;
      ALWAYS, "connected"    ,CONNECTED;
      FSHARP, "const"      ,CONST;
      FSHARP, "default"    ,DEFAULT;
      FSHARP, "delegate"   ,DELEGATE;
      ALWAYS, "disconnect" ,DISCONNECT;
      ALWAYS, "do"         ,DO;
      ALWAYS, "done"       ,DONE;
      FSHARP, "downcast"   ,DOWNCAST;
      ALWAYS, "downto"     ,DOWNTO;
      FSHARP, "elif"       ,ELIF;
      ALWAYS, "else"       ,ELSE;
      ALWAYS, "end"        ,END;
      ALWAYS, "entity"     ,ENTITY
      ALWAYS, "exception"  ,EXCEPTION;
      FSHARP, "extern"     ,EXTERN;
      ALWAYS, "false"      ,FALSE;
      ALWAYS, "finally"    ,FINALLY;
      ALWAYS, "for"        ,FOR;
      ALWAYS, "fun"        ,FUN;
      ALWAYS, "function"   ,FUNCTION;
      FSHARP, "global"     ,GLOBAL;
      ALWAYS, "if"         ,IF;
      ALWAYS, "in"         ,IN;
      ALWAYS, "inherit"    ,INHERIT;
      FSHARP, "inline"     ,INLINE;
      FSHARP, "interface"  ,INTERFACE;
      FSHARP, "internal"   ,INTERNAL;
      ALWAYS, "land"       ,INFIX_STAR_DIV_MOD_OP "land";
      ALWAYS, "lazy"       ,LAZY;
      ALWAYS, "let"        ,LET(false);
      ALWAYS, "let!"       ,LET_BANG(false);
      ALWAYS, "lor"        ,INFIX_STAR_DIV_MOD_OP "lor";
      ALWAYS, "lsl"        ,INFIX_STAR_STAR_OP "lsl";
      ALWAYS, "lsr"        ,INFIX_STAR_STAR_OP "lsr";
      ALWAYS, "lxor"       ,INFIX_STAR_DIV_MOD_OP "lxor";
      ALWAYS, "master"     ,MASTER;
      ALWAYS, "match"      ,MATCH;
      FSHARP, "member"     ,MEMBER;
      ALWAYS, "mod"        ,INFIX_STAR_DIV_MOD_OP "mod";
      ALWAYS, "module"     ,MODULE;
      ALWAYS, "mutable"    ,MUTABLE;
      ALWAYS, "ref"        ,REFERENCE;
      FSHARP, "namespace"  ,NAMESPACE;
      ALWAYS, "new"        ,NEW;
      FSHARP, "null"       ,NULL;
      ALWAYS, "of"         ,OF;
      ALWAYS, "open"       ,OPEN;
      ALWAYS, "import"     ,IMPORT;
      ALWAYS, "or"         ,OR;
      FSHARP, "override"   ,OVERRIDE;
      ALWAYS, "private"    ,PRIVATE;  
      FSHARP, "public"     ,PUBLIC;
      ALWAYS, "rec"        ,REC;
      FSHARP, "rule"       ,RULE;
      FSHARP, "wait"       ,WAIT;
      FSHARP, ".&"         ,PARALLEL_OPERATOR;
      FSHARP, "Create"     ,CREATE;
      ALWAYS, "sig"        ,SIG;
      ALWAYS, "slave"      ,SLAVE;
      FSHARP, "static"     ,STATIC;
      ALWAYS, "struct"     ,STRUCT;
      ALWAYS, "then"       ,THEN;
      ALWAYS, "to"         ,TO;
      ALWAYS, "true"       ,TRUE;
      ALWAYS, "try"        ,TRY;
      ALWAYS, "type"       ,TYPE;
      FSHARP, "upcast"     ,UPCAST;
      FSHARP, "use"        ,LET(true);
      ALWAYS, "val"        ,VAL;
      ALWAYS, "virtual"    ,VIRTUAL;
      FSHARP, "void"       ,VOID;
      ALWAYS, "when"       ,WHEN;
      ALWAYS, "while"      ,WHILE;
      ALWAYS, "with"       ,WITH;
      ALWAYS, "worldEntity"     ,WORLD_ENTITY;
      ALWAYS, "scene"           ,WORLD_ENTITY;
      ALWAYS, "game"            ,WORLD_ENTITY;
      FSHARP, "yield"      ,YIELD;
      ALWAYS, "_"          ,UNDERSCORE;
    (*------- for prototyping and explaining offside rule *)
      FSHARP, "__token_OBLOCKSEP" ,OBLOCKSEP;
      FSHARP, "__token_OWITH"     ,OWITH;
      FSHARP, "__token_ODECLEND"  ,ODECLEND;
      FSHARP, "__token_OTHEN"     ,OTHEN;
      FSHARP, "__token_OBODY_OPERATOR"   ,OBODY_OPERATOR;
      FSHARP, "__token_OELSE"     ,OELSE;
      FSHARP, "__token_OEND"      ,OEND;
      FSHARP, "__token_ODO"       ,ODO;
      FSHARP, "__token_OWAIT"     ,OWAIT;
      FSHARP, "__token_OPARALLEL_OPERATOR",  OPARALLEL_OPERATOR;
      FSHARP, "__token_OWHEN" ,OWHEN;
      FSHARP, "__token_OYIELD"    ,OYIELD;
      FSHARP, "__token_OWHERE"    ,OWHERE;
      FSHARP, "__token_OLET"      ,OLET(true);
      FSHARP, "__token_constraint",CONSTRAINT;
      ]
    (*------- reserved keywords which are ml-compatibility ids *) 
    @ List.map (fun s -> (FSHARP,s,RESERVED)) 
        [ "atomic"; "break"; 
          "checked"; "component"; "constraint"; "constructor"; "continue"; 
          "eager"; 
          "fixed"; "fori"; "functor"; 
          "include";  
          "measure"; "method"; "mixin"; 
          "object"; 
          "parallel"; "params";  "process"; "protected"; "pure"; 
          "recursive"; 
          "sealed"; 
          "trait";  "tailcall";  "volatile"; ]

    let private unreserveWords = 
        keywordList |> List.choose (function (mode,keyword,_) -> if mode = FSHARP then Some keyword else None) 

    //------------------------------------------------------------------------
    // Keywords
    //-----------------------------------------------------------------------

    let keywordNames = 
        keywordList |> List.map (fun (_, w, _) -> w) 

    let keywordTable = 
        // TODO: this doesn't need to be a multi-map, a dictionary will do
        let tab = System.Collections.Generic.Dictionary<string,token>(100)
        for (_mode,keyword,token) in keywordList do tab.Add(keyword,token)
        tab
        
    let KeywordToken s = keywordTable.[s]

    /// ++GLOBAL MUTABLE STATE. Note this is a deprecated, undocumented command line option anyway, we can ignore it.
    let mutable permitFsharpKeywords = true

    let IdentifierToken args (lexbuf:LexBuffer<char>) (s:string) =
        args.resourceManager.InternIdentifierToken s

    let KeywordOrIdentifierToken args (lexbuf:LexBuffer<char>) s =
        if not permitFsharpKeywords && List.mem s unreserveWords then
            // You can assume this condition never fires - this is a deprecated, undocumented command line option anyway, we can ignore it.
            IdentifierToken args lexbuf s
        else
          let mutable v = Unchecked.defaultof<_>
          if keywordTable.TryGetValue(s, &v) then 
              if (match v with RESERVED -> true | _ -> false) then
                  warning(ReservedKeyword(FSComp.SR.lexhlpIdentifierReserved(s), lexbuf.LexemeRange));
                  IdentifierToken args lexbuf s
              else v
          else 
            match s with 
//            | "__SOURCE_DIRECTORY__" ->
//                let filename = fileOfFileIndex lexbuf.file.FileIndex
//                let dirname  = if filename = stdinMockFilename then
//                                   System.IO.Directory.GetCurrentDirectory() // TODO: is this right for Silverlight?
//                               else
//                                   filename |> FileSystem.SafeGetFullPath (* asserts that path is already absolute *)
//                                            |> System.IO.Path.GetDirectoryName
//                CasanovaCompiler.Parser.KEYWORD_STRING dirname
//            | "__SOURCE_FILE__" -> 
//                CasanovaCompiler.Parser.KEYWORD_STRING (System.IO.Path.GetFileName((fileOfFileIndex lexbuf.StartPos.FileIndex))) 
//            | "__LINE__" -> 
//                CasanovaCompiler.Parser.KEYWORD_STRING (string lexbuf.StartPos.Line)
            | _ -> 
               IdentifierToken args lexbuf s
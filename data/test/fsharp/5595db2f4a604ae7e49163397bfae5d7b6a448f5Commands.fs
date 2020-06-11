namespace MonoDevelop.DocFood.FSharp

open MonoDevelop.Components.Commands
open MonoDevelop.Ide
open Mono.TextEditor
open ICSharpCode.NRefactory.TypeSystem

type Commands =
    | DocumentThis = 0
    | DocumentBuffer = 1

type DocumentBufferHandler() =
    inherit CommandHandler()

    override this.Update(info: CommandInfo) =
        info.Enabled <- IdeApp.Workbench.ActiveDocument <> null &&
                        IdeApp.Workbench.ActiveDocument.Editor <> null &&
                        IdeApp.Workbench.ActiveDocument.Editor.Document.MimeType = "text/x-fsharp"
        base.Update(info)

    static member NeedsDocumentation(data: TextEditorData, aMember: IUnresolvedEntity) =
        false

    static member internal GenerateDocumentation (data: TextEditorData, aMember: IEntity, indent: string, prefix: string) =
        System.String.Empty
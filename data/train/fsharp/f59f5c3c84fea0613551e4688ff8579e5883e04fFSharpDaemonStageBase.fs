namespace ActiveMesa.FSharper.Daemon.FSharp.Stages

open JetBrains.ReSharper.Daemon
open JetBrains.ReSharper.Psi
open JetBrains.Annotations
open ActiveMesa.FSharper.Psi.FSharp
open ActiveMesa.FSharper.Psi.FSharp.Tree

[<AbstractClass>]
type FSharpDaemonStageBase() =
  abstract member CreateProcess : IDaemonProcess * DaemonProcessKind -> IDaemonStageProcess
  abstract member NeedsErrorStripe : IPsiSourceFile -> ErrorStripeRequest
  
  [<CanBeNull>]
  static member GetPsiFile(sourceFile:IPsiSourceFile) =
    let manager = PsiManager.GetInstance(sourceFile.GetSolution())
    manager.AssertAllDocumentAreCommited()
    manager.GetPsiFile(sourceFile, FSharpLanguage.Instance) :?> IFSharpFile

  static member IsSuported(sourceFile:IPsiSourceFile) =
    match sourceFile with
    | sf when sf = null || not(sf.IsValid()) -> false
    | sf -> let psiFile = FSharpDaemonStageBase.GetPsiFile(sf)
            (psiFile <> Unchecked.defaultof<IFSharpFile>) && psiFile.Language.Is<FSharpLanguage>() 

  interface IDaemonStage with
    member this.CreateProcess(theProcess, processKind) = this.CreateProcess(theProcess, processKind)
    member this.NeedsErrorStripe(sourceFile) = this.NeedsErrorStripe(sourceFile)
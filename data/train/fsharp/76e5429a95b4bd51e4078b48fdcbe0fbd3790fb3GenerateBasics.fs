module GenerateBasics

open ControllerDefinitions
open JavaImplementation.JAPI
open LanguageInterface.API
open LanguageInterface.ImplementationInterface

///CONTROLLER

type LController<'L>(controller: Controller,lApiProvider: APIProvider<'L> ) =
  member this.ApiProvider = lApiProvider
  member this.Module = lApiProvider.ModuleRoot.Child("com").Child("jasperhilven").Child("controller")
  member this.LType = lApiProvider.TType controller.Name this.Module
  member this.Variable = this.LType.Variable
  member this.Children = controller.Children |> List.map (fun c -> new LController<'L>(c,lApiProvider))
  member this.ChildVariables = this.Children |> List.map (fun c -> c.Variable)
  
///ILVARIABLE

type LVariable<'L> with
  member this.Getter = this.Provider.ClMethodDecl ("Get" + this.LType.Name) this.LType [] (this.Provider.StReturn this.Eval.IlRHV)
  member this.AsField = this.Provider.This.AccessField(this)

///ILTYPE

type LType<'L> with
  member this.GetConstructorFieldInitializations(fieldsToInitialize: LVariable<'L> list) = 
    let singleAssignment field = this.provider.This.AccessField(field).SetTo(field)
    let content = if fieldsToInitialize.Length.Equals(0) then this.provider.StEmpty else fieldsToInitialize |> List.map singleAssignment |> List.reduce (fun l r -> l.Append(r))
    this.provider.CLConstDecl this fieldsToInitialize content

let private getClassOfController(controller: LController<'L>) = 
  let constr = controller.LType.GetConstructorFieldInitializations controller.ChildVariables
  let getters = controller.ChildVariables |> List.map (fun cV -> cV.Getter)
  controller.ApiProvider.ClClass controller.LType [constr] getters controller.ChildVariables
type LController<'L> with
  member this.GenerateClass()  = getClassOfController(this)


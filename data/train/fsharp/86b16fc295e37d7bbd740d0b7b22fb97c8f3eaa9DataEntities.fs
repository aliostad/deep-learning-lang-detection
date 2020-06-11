namespace WX.Utilities.WPFDesignerX.BusinessEditor
open System
open System.Windows
open System.Windows.Data
open System.Windows.Controls
open System.Windows.Input
open System.ComponentModel
open System.Reflection
open WX
open WX.Utilities.WPFDesignerX.Common

[<AbstractClass>]
type EntityBase()=
  let propertyChangedEvent = new DelegateEvent<PropertyChangedEventHandler>()
  let mutable _IsChecked=false
  let mutable _EditStatus=EditStatus.Add
  interface INotifyPropertyChanged with
      [<CLIEvent>]
      member this.PropertyChanged = propertyChangedEvent.Publish
  member this.OnPropertyChanged propertyName = 
      propertyChangedEvent.Trigger([| this; new PropertyChangedEventArgs(propertyName) |])

  member this.IsChecked 
    with get ()=_IsChecked
    and set v=
      if _IsChecked<>v then
        _IsChecked<-v
        this.OnPropertyChanged "IsChecked"

  member this.EditStatus 
    with get ()=_EditStatus
    and set v=_EditStatus<-v

type ServiceInfo()=
  inherit EntityBase()
  let mutable _ServiceName=String.Empty
  let mutable _ServiceNameCopy=String.Empty
  let mutable _ServiceDescription=String.Empty
  let mutable _ServiceDescriptionCopy=String.Empty
  let mutable _ServiceCode=String.Empty
  let mutable _ServiceCodeCopy=String.Empty
  let mutable _ServiceCodeChangedType=ChangedType.Unchanged
  let mutable _ServiceCodeChangedTypeCopy=ChangedType.Unchanged
  let mutable _ServiceCodeChangedTypeX="未变更"
  let mutable _IsDirtyOfServiceName=false
  let mutable _IsDirtyOfServiceDescription=false
  let mutable _IsDirtyOfServiceCode=false
  let mutable _IsDirtyOfServiceCodeChangedType=false
  let mutable _ReferenceCount=0

  member this.ServiceName 
    with get ()=_ServiceName
    and set v=
      if _ServiceName<>v then
        _ServiceName<-v
        this.OnPropertyChanged "ServiceName"
        if _ServiceNameCopy<>v then 
          _IsDirtyOfServiceName<-true
        else _IsDirtyOfServiceName<-false

  member this.ServiceDescription 
    with get ()=_ServiceDescription
    and set v=
      if _ServiceDescription<>v then
        _ServiceDescription<-v
        this.OnPropertyChanged "ServiceDescription"
        if _ServiceDescriptionCopy<>v then 
          _IsDirtyOfServiceDescription<-true
        else _IsDirtyOfServiceDescription<-false

  member this.ServiceCode 
    with get ()=_ServiceCode
    and set v=
      if _ServiceCode<>v then
        _ServiceCode<-v
        this.OnPropertyChanged "ServiceCode"
        if _ServiceCodeCopy<>v then 
          _IsDirtyOfServiceCode<-true
        else _IsDirtyOfServiceCode<-false

  member this.ServiceNameCopy 
    with get ()=_ServiceNameCopy
    and set v=
      if _ServiceNameCopy<>v then
        _ServiceNameCopy<-v
        _IsDirtyOfServiceName<-false

  member this.ServiceDescriptionCopy 
    with get ()=_ServiceDescriptionCopy
    and set v=
      if _ServiceDescriptionCopy<>v then
        _ServiceDescriptionCopy<-v
        _IsDirtyOfServiceDescription<-false

  member this.ServiceCodeCopy 
    with get ()=_ServiceCodeCopy
    and set v=
      if _ServiceCodeCopy<>v then
        _ServiceCodeCopy<-v
        _IsDirtyOfServiceCode<-false

  member this.IsDirtyOfServiceName 
    with get ()=_IsDirtyOfServiceName
    and set v=_IsDirtyOfServiceName<-v

  member this.IsDirtyOfServiceDescription 
    with get ()=_IsDirtyOfServiceDescription
    and set v=_IsDirtyOfServiceDescription<-v

  member this.IsDirtyOfServiceCode 
    with get ()=_IsDirtyOfServiceCode
    and set v=_IsDirtyOfServiceCode<-v

  member this.ReferenceCount 
    with get ()=_ReferenceCount
    and set v=_ReferenceCount<-v

  //--------------------------------------------------------------
  //没有输入服务代码时，可以辅助识别服务代码的变更
  member this.ServiceCodeChangedType 
    with get ()=_ServiceCodeChangedType
    and set v=
      if _ServiceCodeChangedType<>v then
        _ServiceCodeChangedType<-v
        this.OnPropertyChanged "ServiceCodeChangedType"
        if this.ServiceCodeChangedTypeCopy<>v then 
          this.IsDirtyOfServiceCodeChangedType<-true
        else this.IsDirtyOfServiceCodeChangedType<-false
        match v with
        | ChangedType.Added ->this.ServiceCodeChangedTypeX<-"增加"
        | ChangedType.Modified ->this.ServiceCodeChangedTypeX<-"修改"
         | ChangedType.Dirtied ->this.ServiceCodeChangedTypeX<-"变脏"
        | _ ->this.ServiceCodeChangedTypeX<-"未变更"

  member this.ServiceCodeChangedTypeCopy 
    with get ()=_ServiceCodeChangedTypeCopy
    and set v=
      if _ServiceCodeChangedTypeCopy<>v then
        _ServiceCodeChangedTypeCopy<-v
        _IsDirtyOfServiceCodeChangedType<-false

  member this.ServiceCodeChangedTypeX 
    with get ()=_ServiceCodeChangedTypeX
    and set v=
      if _ServiceCodeChangedTypeX<>v then
        _ServiceCodeChangedTypeX<-v
        this.OnPropertyChanged "ServiceCodeChangedTypeX"

  member this.IsDirtyOfServiceCodeChangedType 
    with get ()=_IsDirtyOfServiceCodeChangedType
    and set v=_IsDirtyOfServiceCodeChangedType<-v

type Annotation() =
  inherit EntityBase()
  let mutable _UIElementID=DefaultGuidValue
  let mutable _UIElementName=String.Empty
  let mutable _UITypeName=String.Empty
  let mutable _UIName=String.Empty
  let mutable _IsInTabItem=false
  let mutable _IsTabItem=false
  let mutable _TabControlNumber=0
  let mutable _TabItemNumber=0
  let mutable _TabItemHeader=String.Empty
  let mutable _RequirementDescription=String.Empty
  let mutable _BehaviorDescription=String.Empty
  let mutable _RequirementDescriptionCopy=String.Empty
  let mutable _BehaviorDescriptionCopy=String.Empty
  let mutable _IsDirtyOfRequirementDescription=false
  let mutable _IsDirtyOfBehaviorDescription=false
  let mutable _ServiceInfos:ServiceInfo[]=null
  let mutable _IsDirtyOfServiceInfos=false
  let mutable _IsDirtyOfUIInfo=false

  member this.UIElementID 
    with get ()=_UIElementID
    and set v=
      if _UIElementID<>v then
        _UIElementID<-v
        this.OnPropertyChanged "UIElementID"

  member this.UIElementName  
    with get ()=_UIElementName 
    and set v=
      if _UIElementName <>v then
        _UIElementName <-v
        this.OnPropertyChanged "UIElementName"

  member this.UITypeName  
    with get ()=_UITypeName 
    and set v=
      if _UITypeName <>v then
        _UITypeName <-v
        this.OnPropertyChanged "UITypeName"

  member this.UIName 
    with get ()=_UIName
    and set v=
      if _UIName<>v then
        _UIName<-v
        this.OnPropertyChanged "UIName"

  member this.IsInTabItem 
    with get ()=_IsInTabItem
    and set v=
      if _IsInTabItem<>v then
        _IsInTabItem<-v
        this.OnPropertyChanged "IsInTabItem"

  member this.IsTabItem 
    with get ()=_IsTabItem
    and set v=
      if _IsTabItem<>v then
        _IsTabItem<-v
        this.OnPropertyChanged "IsTabItem"

  member this.TabControlNumber 
    with get ()=_TabControlNumber
    and set v=
      if _TabControlNumber<>v then
        _TabControlNumber<-v
        this.OnPropertyChanged "TabControlNumber"

  member this.TabItemNumber 
    with get ()=_TabItemNumber
    and set v=
      if _TabItemNumber<>v then
        _TabItemNumber<-v
        this.OnPropertyChanged "TabItemNumber"

  member this.TabItemHeader 
    with get ()=_TabItemHeader
    and set v=
      if _TabItemHeader<>v then
        _TabItemHeader<-v
        this.OnPropertyChanged "TabItemHeader"

  member this.RequirementDescription  
    with get ()=_RequirementDescription 
    and set v=
      if _RequirementDescription <>v then
        _RequirementDescription <-v
        this.OnPropertyChanged "RequirementDescription"
        if _RequirementDescriptionCopy<>v then 
          _IsDirtyOfRequirementDescription<-true
        else _IsDirtyOfRequirementDescription<-false

  member this.BehaviorDescription  
    with get ()=_BehaviorDescription 
    and set v=
      if _BehaviorDescription <>v then
        _BehaviorDescription <-v
        this.OnPropertyChanged "BehaviorDescription"
        if _BehaviorDescriptionCopy<>v then 
          _IsDirtyOfBehaviorDescription<-true
        else _IsDirtyOfBehaviorDescription<-false

  member this.RequirementDescriptionCopy  
    with get ()=_RequirementDescriptionCopy 
    and set v=
      if _RequirementDescriptionCopy<>v then
        _RequirementDescriptionCopy <-v
        _IsDirtyOfRequirementDescription<-false

  member this.BehaviorDescriptionCopy  
    with get ()=_BehaviorDescriptionCopy 
    and set v=
      if _BehaviorDescriptionCopy<>v then
        _BehaviorDescriptionCopy <-v
        _IsDirtyOfBehaviorDescription<-false

  member this.IsDirtyOfRequirementDescription 
    with get ()=_IsDirtyOfRequirementDescription
    and set v=_IsDirtyOfRequirementDescription<-v

  member this.IsDirtyOfBehaviorDescription 
    with get ()=_IsDirtyOfBehaviorDescription
    and set v=_IsDirtyOfBehaviorDescription<-v

  member this.ServiceInfos
    with get ()=_ServiceInfos
    and set v=_ServiceInfos<-v

  member this.IsDirtyOfServiceInfos 
    with get ()=_IsDirtyOfServiceInfos
    and set v=_IsDirtyOfServiceInfos<-v

  member this.IsDirtyOfUIInfo 
    with get ()=_IsDirtyOfUIInfo
    and set v=
      if _IsDirtyOfUIInfo <>v then
        match CommonData.EditorOperateScope with
        | EditorOperateScope.All | EditorOperateScope.ViewAndEdit ->
            _IsDirtyOfUIInfo <-v
            this.OnPropertyChanged "IsDirtyOfUIInfo"
        | _ ->()
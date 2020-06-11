// Copyright (c) Microsoft Open Technologies, Inc.  All Rights Reserved.  Licensed under the Apache License, Version 2.0.  See License.txt in the project root for license information.


//--------------------------------------------------------------------------------------
// Mock types for F# CodeDom and LanguageService functionality

#if DESIGNER
namespace FSharp.CodeDom
    open System
    
    /// This is a mock type: we should be loading an F# CodeDom provider here
    type FSharpProvider() = 
        member x.AddReference(project:string) = 
            System.Diagnostics.Debug.Assert(false,"Stub Code!")

namespace Microsoft.VisualStudio.FSharp.ProjectSystem
    open System
    open System.CodeDom.Compiler;
    open Microsoft.VisualStudio;
    open Microsoft.VisualStudio.Designer.Interfaces;
    type FSharpCodeModelFactory() = 
        static member CreateFileCodeModel (item:EnvDTE.ProjectItem, provider:CodeDomProvider, url:string) : EnvDTE.FileCodeModel  = 
            System.Diagnostics.Debug.Assert(false,"Stub Code!");
            raise (new NotSupportedException("Microsoft.VisualStudio.FSharp.ProjectSystem: CreateFileCodeModel not yet available"));

        static member CreateProjectCodeModel(item:EnvDTE.Project) : EnvDTE.CodeModel  = 
            System.Diagnostics.Debug.Assert(false,"Stub Code!");
            raise (new NotSupportedException("Microsoft.VisualStudio.FSharp.ProjectSystem: CreateFileCodeModel not yet available"));
#endif
            
namespace Microsoft.VisualStudio.FSharp.LanguageService
    open Microsoft.VisualStudio.Shell.Interop

    type internal IFSharpLibraryManager =
          abstract RegisterHierarchy : hierarchy:IVsHierarchy  -> unit 
          abstract UnregisterHierarchy : hierarchy:IVsHierarchy -> unit

//--------------------------------------------------------------------------------------
// The implementation of the project system proper

namespace Microsoft.VisualStudio.FSharp.ProjectSystem

    open System
    open System.Reflection
    open System.CodeDom
    open System.CodeDom.Compiler
    open System.Runtime.CompilerServices
    open System.Runtime.InteropServices
    open System.Runtime.Serialization
    open System.Collections.Generic
    open System.Collections
    open System.ComponentModel
    open System.ComponentModel.Design
    open System.Text.RegularExpressions
    open System.Diagnostics
    open System.IO
    open System.Drawing
    open System.Globalization
    open System.Text


    open Microsoft.Win32

    open Microsoft.VisualStudio.Shell
    open Microsoft.VisualStudio.Shell.Interop
    open Microsoft.VisualStudio.Shell.Flavor
    open Microsoft.VisualStudio.OLE.Interop
    open Microsoft.VisualStudio.FSharp.ProjectSystem.Automation
#if DESIGNER
    open Microsoft.Windows.Design.Host
    open Microsoft.Windows.Design.Model
    open Microsoft.VisualStudio.Designer.Interfaces
    open Microsoft.VisualStudio.TextManager.Interop
    open Microsoft.VisualStudio.Shell.Design.Serialization
    open Microsoft.VisualStudio.Shell.Design.Serialization.CodeDom
#endif
    open Microsoft.VisualStudio
    open Microsoft.VisualStudio.FSharp.LanguageService
    open EnvDTE
    open System

    type IOleServiceProvider = Microsoft.VisualStudio.OLE.Interop.IServiceProvider
    type ErrorHandler = Microsoft.VisualStudio.ErrorHandler
    type VSConstants = Microsoft.VisualStudio.VSConstants
    type VsCommands = Microsoft.VisualStudio.VSConstants.VSStd97CmdID
    type VsCommands2K = Microsoft.VisualStudio.VSConstants.VSStd2KCmdID

    module internal FSharpSDKHelper = 
        [<Literal>]
        let v20 = "v2.0"
        [<Literal>]
        let v40 = "v4.0"
        [<Literal>]
        let NETCore = ".NETCore"
        [<Literal>]
        let NETPortable = ".NETPortable"
        [<Literal>]
        let NETFramework = ".NETFramework"

        // TODO: if we want to pick this location from registry?
        let FSharpReferenceAssembliesLocation =
            let root =
                let candidate = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86)
                if String.IsNullOrEmpty candidate then Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles)
                else candidate
            Path.Combine (root, @"Reference Assemblies\Microsoft\FSharp")

        let private listReferenceFoldersForPlatform platform = 
            let path = Path.Combine(FSharpReferenceAssembliesLocation, platform)
            let root = DirectoryInfo(path)
            if not root.Exists then Seq.empty else
            seq {
                for di in root.GetDirectories() do
                    let ok, _ = Version.TryParse di.Name
                    if ok then yield di.FullName
            }
        
        let ListAllReferenceFolders() = 
            seq {
                yield! listReferenceFoldersForPlatform (Path.Combine(NETFramework, v20))
                yield! listReferenceFoldersForPlatform (Path.Combine(NETFramework, v40))
                yield! listReferenceFoldersForPlatform NETCore
                yield! listReferenceFoldersForPlatform NETPortable
            }

    module internal Helpers =
        let GetOutputExtension(outputType) = 
            if (outputType = OutputType.Library) then ".dll" else ".exe"

        let ParseEnum<'a> (s:string) = 
            Enum.Parse(typeof<'a>, s, true (*ignorecase*)) |> unbox<'a>

        /// A helper to get ther service 'service at interface 'intf from the given service provider
        let TryGetService2<'service, 'intf>(serviceProvider: System.IServiceProvider) : 'intf option = 
            match serviceProvider.GetService(typeof<'service>) with
            | :? ('intf) as v -> Some(v)
            | _ -> None

        /// Like TryGetService2, but where the service and interface types are identical
        let TryGetService<'service>(serviceProvider: System.IServiceProvider) : 'service option = 
            TryGetService2<'service,'service>(serviceProvider)

        let GetService2<'service, 'intf>(serviceProvider: System.IServiceProvider) : 'intf = 
            match TryGetService2<'service, 'intf>(serviceProvider) with 
            | Some(service) -> service
            | None -> raise <| InvalidOperationException(sprintf "Could not get service %A at interface %A. Make sure the package is Sited before calling this method" (typeof<'service>) (typeof<'intf>))
                
        /// Like GetService2, but where the service and interface types are identical
        let GetService<'service>(serviceProvider: System.IServiceProvider) : 'service = 
            GetService2<'service,'service>(serviceProvider)

        let GetProvider(node: HierarchyNode) = 
            let serviceProvider = node.OleServiceProvider
            new Microsoft.VisualStudio.Shell.ServiceProvider(serviceProvider,true)
                
    open Helpers

    //--------------------------------------------------------------------------------------
    // The Resource Reader

    type internal DummyTypeInThisAssembly = class end
    
    module internal FSharpSR =
        [<Literal>] 
        let   ProjectReferenceError2 = "ProjectReferenceError2"
        [<Literal>] 
        let   Application = "Application"
        [<Literal>] 
        let   ApplicationIcon = "ApplicationIcon"
        [<Literal>] 
        let   ApplicationIconDescription = "ApplicationIconDescription"
        [<Literal>] 
        let   AssemblyName = "AssemblyName"
        [<Literal>] 
        let   AssemblyNameDescription = "AssemblyNameDescription"
        [<Literal>] 
        let   DefaultNamespace = "DefaultNamespace"
        [<Literal>] 
        let   DefaultNamespaceDescription = "DefaultNamespaceDescription"
        [<Literal>] 
        let   GeneralCaption = "GeneralCaption"
        [<Literal>] 
        let   InvalidOutputType = "InvalidOutputType"
        [<Literal>] 
        let   InvalidRunPostBuildEvent = "InvalidRunPostBuildEvent"
        [<Literal>] 
        let   InvalidTargetFrameworkVersion = "InvalidTargetFrameworkVersion"
        [<Literal>] 
        let   OutputFile = "OutputFile"
        [<Literal>] 
        let   OutputFileDescription = "OutputFileDescription"
        [<Literal>] 
        let   OutputType = "OutputType"
        [<Literal>] 
        let   OutputTypeDescription = "OutputTypeDescription"
        [<Literal>] 
        let   Project = "Project"
        [<Literal>] 
        let   ProjectFile = "ProjectFile"
        [<Literal>] 
        let   ProjectFileDescription = "ProjectFileDescription"
        [<Literal>] 
        let   ProjectFileExtensionFilter = "ProjectFileExtensionFilter"
        [<Literal>] 
        let   ComponentFileExtensionFilter = "ComponentFileExtensionFilter"
        [<Literal>] 
        let   ProjectFolder = "ProjectFolder"
        [<Literal>] 
        let   ProjectRenderFolderMultiple = "ProjectRenderFolderMultiple"
        [<Literal>] 
        let   ProjectFolderDescription = "ProjectFolderDescription"
        [<Literal>] 
        let   PropertyDefaultNamespace = "PropertyDefaultNamespace"
        [<Literal>] 
        let   StartupObject = "StartupObject"
        [<Literal>] 
        let   StartupObjectDescription = "StartupObjectDescription"
        [<Literal>] 
        let   TargetPlatform = "TargetPlatform"
        [<Literal>] 
        let   TargetPlatformDescription = "TargetPlatformDescription"
        [<Literal>] 
        let   TargetPlatformLocation = "TargetPlatformLocation"
        [<Literal>] 
        let   TargetPlatformLocationDescription = "TargetPlatformLocationDescription"
        [<Literal>]
        let   OtherFlags = "OtherFlags"
        [<Literal>]
        let   OtherFlagsDescription = "OtherFlagsDescription"
        [<Literal>]
        let   Tailcalls = "Tailcalls"
        [<Literal>]
        let   TailcallsDescription = "TailcallsDescription"
        [<Literal>]
        let   TemplateNotFound = "TemplateNotFound"
        [<Literal>]
        let   NeedReloadToChangeTargetFx = "NeedReloadToChangeTargetFx" 
        [<Literal>]
        let   NeedReloadToChangeTargetFxCaption = "NeedReloadToChangeTargetFxCaption"
        [<Literal>]
        let   Build = "Build"
        [<Literal>]
        let AddReferenceDialogTitle = "AddReferenceDialogTitle";
        [<Literal>]
        let AddReferenceDialogTitleDev11 = "AddReferenceDialogTitle_Dev11";
        [<Literal>]
        let Dev11SupportsOnlySilverlight5 = "Dev11SupportsOnlySilverlight5";
        [<Literal>]
        let AddReferenceAssemblyPageDialogRetargetingText = "AddReferenceAssemblyPageDialogRetargetingText";
        [<Literal>]
        let AddReferenceAssemblyPageDialogNoItemsText = "AddReferenceAssemblyPageDialogNoItemsText";
        [<Literal>]
        let FSharpCoreVersionIsNotCompatibleWithDev11 = "FSharpCoreVersionIsNotCompatibleWithDev11";


        let thisAssembly = typeof<DummyTypeInThisAssembly>.Assembly 

        let private resources = lazy (new System.Resources.ResourceManager("VSPackage", thisAssembly))

        let GetString(name:string) = 
            resources.Force().GetString(name, CultureInfo.CurrentUICulture)
            
        let GetStringWithCR(name:string) = 
            let s = resources.Force().GetString(name, CultureInfo.CurrentUICulture)
            s.Replace(@"\n", Environment.NewLine)

        let GetObject(name:string) =
            resources.Force().GetObject(name, CultureInfo.CurrentUICulture)

    //--------------------------------------------------------------------------------------
    // Attributes used to mark up editable properties 

    [<AttributeUsage(AttributeTargets.All)>]
    type internal SRDescriptionAttribute(description:string ) =
        inherit DescriptionAttribute(description)
        let mutable replaced = false

        override x.Description = 
            if not (replaced) then 
                replaced <- true
                x.DescriptionValue <- FSharpSR.GetString(base.Description)
            base.Description

    [<AttributeUsage(AttributeTargets.All)>]
    type internal SRCategoryAttribute(category:string) =
        inherit CategoryAttribute(category)
        override x.GetLocalizedString(value:string) =
            FSharpSR.GetString(value)

    [<AttributeUsage(AttributeTargets.Class ||| AttributeTargets.Property ||| AttributeTargets.Field, Inherited = false, AllowMultiple = false)>]
    type internal LocDisplayNameAttribute(name:string) =  
        inherit DisplayNameAttribute()

        override x.DisplayName = 
          match FSharpSR.GetString(name) with 
          | null -> 
              Debug.Assert(false, "String resource '" + name + "' is missing")
              name
          | result -> result

    //--------------------------------------------------------------------------------------
    // Some more constants

    module internal GuidList =
        let guidEditorFactory = new Guid("{4EB7CCB7-4336-4FFD-B12B-396E9FD079A9}")
        [<Literal>]
        let guidEditorFactoryString = "4EB7CCB7-4336-4FFD-B12B-396E9FD079A9"
        [<Literal>]
        let guidFSharpProjectPkgString = "91A04A73-4F2C-4E7C-AD38-C1A68E7DA05C"
        [<Literal>]
        let guidFSharpProjectFactoryString = "F2A71F9B-5D33-465A-A702-920D77279786"
        [<Literal>]
        let guidFSharpProjectFactoryStringWithCurlies = "{F2A71F9B-5D33-465A-A702-920D77279786}"

    // General properties page
    type internal GeneralPropertyPageTag = 
        | AssemblyName = 0
        | OutputType = 1
        | RootNamespace = 2
        | StartupObject = 3
        | ApplicationIcon = 4
        | TargetPlatform = 5
        | TargetPlatformLocation = 6

    type internal FSharpImageName = 
        | FsFile = 0
        | FsProject = 1
        | FsxFile = 2
        | FsiFile = 3
        
#if DESIGNER
    //--------------------------------------------------------------------------------------
    // Provider to connect designer tools through to F# code via the F# CodeDom. Alas the
    // F# CodeDom is not yet complete and can't parse code, which means this won't work.
    // But if we manage to complete it then it appears we may be able to 
    // have a designer story of some kind without too much hassle.

    type VSMDFSharpProvider(vsproject:VSLangProj.VSProject) = class
        let mutable vsproject = vsproject 

        let mutable provider : FSharp.CodeDom.FSharpProvider option  = None

        /// When a reference is added, add it to the provider
        let onReferenceAdd (reference:VSLangProj.Reference) = 
            provider.Value.AddReference(reference.Path)

        /// When a reference is added, add it to the provider
        let onReferenceAddHandler = 
            VSLangProj._dispReferencesEvents_ReferenceAddedEventHandler(onReferenceAdd)

        /// When a reference is removed/changed, let the provider know
        let onReferenceRemoveOrChange (reference:VSLangProj.Reference) =
            // Because our provider only has an AddReference method and no way to
            // remove them, we end up having to recreate it.
            provider <- Some(new FSharp.CodeDom.FSharpProvider());
            if (vsproject.References <> null) then 
              for (currentReference :VSLangProj.Reference ) in vsproject.References do
                provider.Value.AddReference(currentReference.Path);

        let onReferenceRemoveHandler = 
            VSLangProj._dispReferencesEvents_ReferenceRemovedEventHandler(onReferenceRemoveOrChange)
        let onReferenceChangeHandler = 
            VSLangProj._dispReferencesEvents_ReferenceChangedEventHandler(onReferenceRemoveOrChange)

        
        do  if (vsproject= null) then raise <| ArgumentNullException("project");

          // Create the provider
        do  onReferenceRemoveOrChange(null);

        do  vsproject.Events.ReferencesEvents.add_ReferenceAdded(onReferenceAddHandler);
        do  vsproject.Events.ReferencesEvents.add_ReferenceRemoved(onReferenceRemoveHandler)
        do  vsproject.Events.ReferencesEvents.add_ReferenceChanged(onReferenceChangeHandler);

        interface IVSMDCodeDomProvider with 
            member x.CodeDomProvider = provider.Value  |> box

        interface IDisposable with 
            member x.Dispose() = 
              if (vsproject <> null) then 
                vsproject <- null;
                vsproject.Events.ReferencesEvents.remove_ReferenceAdded(onReferenceAddHandler)
                vsproject.Events.ReferencesEvents.remove_ReferenceRemoved(onReferenceRemoveHandler)
                vsproject.Events.ReferencesEvents.remove_ReferenceChanged(onReferenceChangeHandler)
        end
    end // class VSMDFSharpProvider
#endif

    module internal Attributes = 
        //[<assembly: System.Security.SecurityTransparent>]
#if NO_ASSEM_ATTRS_YET    
        //
        // General Information about an assembly is controlled through the following 
        // set of attributes. Change these attribute values to modify the information
        // associated with an assembly.
        //
        [<assembly: AssemblyTitle("")>]
        [<assembly: AssemblyDescription("")>]
        [<assembly: AssemblyConfiguration("")>]
        [<assembly: AssemblyCompany("")>]
        [<assembly: AssemblyProduct("")>]
        [<assembly: AssemblyCopyright("")>]
        [<assembly: AssemblyTrademark("")>]
        [<assembly: AssemblyCulture("")>]

        //
        // Version information for an assembly consists of the following four values:
        //
        //      Major Version
        //      Minor Version 
        //      Build Number
        //      Revision
        //
        // You can specify all the values or you can default the Revision and Build Numbers 
        // by open the '*' :?> shown below:

        [<assembly: AssemblyVersion("9.0.*")>]

        //
        // In order to sign your assembly you must specify a key to use. Refer to the 
        // Microsoft .NET Framework documentation for more information on assembly signing.
        //
        // Use the attributes below to control which key is used for signing. 
        //
        // Notes: 
        //   (*) If no key is specified, the assembly is not signed.
        //   (*) KeyName refers to a key that has been installed in the Crypto Service
        //       Provider (CSP) on your machine. KeyFile refers to a file which contains
        //       a key.
        //   (*) If the KeyFile and the KeyName values are both specified, the 
        //       following processing occurs:
        //       (1) If the KeyName can be found in the CSP, that key is used.
        //       (2) If the KeyName does not exist and the KeyFile does exist, the key 
        //           in the KeyFile is installed into the CSP and used.
        //   (*) In order to create a KeyFile, you can use the sn.exe (Strong Name) utility.
        //       When specifying the KeyFile, the location of the KeyFile should be
        //       relative to the project output directory which is
        //       %Project Directory%\obj\<configuration>. For example, if your KeyFile is
        //       located in the project directory, you would specify the AssemblyKeyFile 
        //       attribute :?> [<assembly: AssemblyKeyFile("..\\..\\mykey.snk")>]
        //   (*) Delay Signing is an advanced option - see the Microsoft .NET Framework
        //       documentation for more information on this.
        //
        [<assembly: AssemblyDelaySign(false)>]
        [<assembly: AssemblyKeyFile("")>]
        [<assembly: AssemblyKeyName("")>]

        [<assembly: CLSCompliant(false)>]
#endif
        do()

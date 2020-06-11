namespace XsdTool.Configuration

open System
open System.Configuration
open System.IO
open System.Text
open System.Xml.Serialization

type DtoAssemblies () =
    [<DefaultValue>] val mutable assembly: string
    [<DefaultValue>] val mutable probingPath: string
    [<DefaultValue>] val mutable xmlNamespace: string
    [<DefaultValue>] val mutable assemblyNamespaces: string[]

type ConfigSectionHandler () =
    interface IConfigurationSectionHandler with
        member __.Create(_, _, section) =
            let configXml = section.SelectSingleNode("//DtoAssemblies").OuterXml
            if String.IsNullOrEmpty(configXml) then null
            else
                use stream = new MemoryStream(Encoding.UTF8.GetBytes(configXml))
                stream.Position <- 0L
                let serializer = XmlSerializer(typeof<DtoAssemblies>)
                serializer.Deserialize(stream)

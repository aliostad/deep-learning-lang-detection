using System;
using System.Collections.Generic;
using System.Reflection;
using Pixel3D.Serialization.BuiltIn.DelegateHandling;

namespace Pixel3D.Serialization.Generator
{
    public class GeneratorResult
    {
        internal GeneratorResult(SerializationMethodProviders serializationMethods,
                Dictionary<Type, SerializeDispatchDelegate> dispatchTable,
                DeserializeDispatchDelegate deserializeDispatch,
                List<Module> moduleTable)
        {
            this.serializationMethods = serializationMethods;
            this.serializeDispatchTable = dispatchTable;
            this.deserializeDispatch = deserializeDispatch;
            this.moduleTable = moduleTable;
        }

        internal readonly SerializationMethodProviders serializationMethods;

        internal readonly Dictionary<Type, SerializeDispatchDelegate> serializeDispatchTable;
        internal readonly DeserializeDispatchDelegate deserializeDispatch;

        // Valid modules for serializing System.Type
        internal List<Module> moduleTable;
        
        internal Dictionary<Type, DelegateTypeInfo> delegateTypeTable;
    }
}

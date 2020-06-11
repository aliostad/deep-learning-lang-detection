using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FileMonitorService.Models
{
    //[Serializable]
    public class InvokeMethodData
    {
        [Key]
        public long Id { get; set; }
        public String AssemblyName { get; set; }
        public String ClassName { get; set; }
        public String MethodName { get; set; }
        public virtual ICollection<InvokeMethodParameterData> MethodParameters { get; set; }        
        
        public InvokeMethodData()
        {
        }

        public InvokeMethodData(InvokeMethodData invokeMethodData)
        {
            if (invokeMethodData == null)
            {
                return;
            }

            AssemblyName = invokeMethodData.AssemblyName;
            ClassName = invokeMethodData.ClassName;
            MethodName = invokeMethodData.MethodName;
            MethodParameters = invokeMethodData.MethodParameters == null ? new List<InvokeMethodParameterData>() : new List<InvokeMethodParameterData>(invokeMethodData.MethodParameters);
        }
    }
}

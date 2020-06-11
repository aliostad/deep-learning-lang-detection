using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.XPath;

namespace LotusGenCode
{
    class Template
    {

        public string TemplateBeforeProcess { set; get; }

        public Template(string TemplateBeforeProcess)
        {
            this.TemplateBeforeProcess = TemplateBeforeProcess;
        }

        public void ProcessStep1_EncodeHTML()
        {
           this.TemplateBeforeProcess = this.TemplateBeforeProcess.Replace("<", "[#(#]");
           this.TemplateBeforeProcess = this.TemplateBeforeProcess.Replace("/>", "[#/)#]");
           this.TemplateBeforeProcess = this.TemplateBeforeProcess.Replace(">", "[#)#]");
        }

        public void ProcessStep2_DecodeGENTAB()
        {
            this.TemplateBeforeProcess = this.TemplateBeforeProcess.Replace("[@", "<");
            this.TemplateBeforeProcess = this.TemplateBeforeProcess.Replace("@]", ">");
            this.TemplateBeforeProcess = this.TemplateBeforeProcess.Replace("/@]", "/>");
        }
    }
}

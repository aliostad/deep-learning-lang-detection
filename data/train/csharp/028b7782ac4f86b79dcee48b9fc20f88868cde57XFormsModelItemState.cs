using System;
using System.Runtime.Serialization;
using System.Xml.Linq;

namespace NXKit.XForms
{

    [Serializable]
    public class XFormsModelItemState : ISerializable
    {

        private bool dispatchReadOnly;
        private bool dispatchReadWrite;
        private bool dispatchRequired;
        private bool dispatchOptional;
        private bool dispatchEnabled;
        private bool dispatchDisabled;
        private bool dispatchValid;
        private bool dispatchInvalid;

        /// <summary>
        /// Initializes a new instance.
        /// </summary>
        public XFormsModelItemState()
        {

        }

        /// <summary>
        /// Deserializes an instance.
        /// </summary>
        /// <param name="info"></param>
        /// <param name="context"></param>
        public XFormsModelItemState(SerializationInfo info, StreamingContext context)
        {
            Id = (int?)info.GetValue("Id", typeof(int?));
            Type = (XName)info.GetValue("Type", typeof(XName));
            ReadOnly = (bool?)info.GetValue("ReadOnly", typeof(bool?));
            Required = (bool?)info.GetValue("Required", typeof(bool?));
            Relevant = (bool?)info.GetValue("Relevant", typeof(bool?));
            Valid = (bool?)info.GetValue("Valid", typeof(bool?));
        }

        public int? Id { get; set; }

        public XName Type { get; set; }

        public bool DispatchValueChanged { get; set; }

        public bool? ReadOnly { get; set; }

        public bool DispatchReadOnly
        {
            get { return dispatchReadOnly; }
            set { dispatchReadOnly = value; if (dispatchReadOnly) dispatchReadWrite = false; }
        }

        public bool DispatchReadWrite
        {
            get { return dispatchReadWrite; }
            set { dispatchReadWrite = value; if (dispatchReadWrite) dispatchReadOnly = false; }
        }

        public bool? Required { get; set; }

        public bool DispatchRequired
        {
            get { return dispatchRequired; }
            set { dispatchRequired = value; if (dispatchRequired) dispatchOptional = false; }
        }

        public bool DispatchOptional
        {
            get { return dispatchOptional; }
            set { dispatchOptional = value; if (dispatchOptional) dispatchRequired = false; }
        }

        public bool? Relevant { get; set; }

        public bool DispatchEnabled
        {
            get { return dispatchEnabled; }
            set { dispatchEnabled = value; if (dispatchEnabled) dispatchDisabled = false; }
        }

        public bool DispatchDisabled
        {
            get { return dispatchDisabled; }
            set { dispatchDisabled = value; if (dispatchDisabled) dispatchEnabled = false; }
        }

        public bool? Valid { get; set; }

        public bool DispatchValid
        {
            get { return dispatchValid; }
            set { dispatchValid = value; if (dispatchValid) dispatchInvalid = false; }
        }

        public bool DispatchInvalid
        {
            get { return dispatchInvalid; }
            set { dispatchInvalid = value; if (dispatchInvalid) dispatchValid = false; }
        }

        public bool Clear { get; set; }

        public XElement NewElement { get; set; }

        public string NewValue { get; set; }

        void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
        {
            info.AddValue("Id", Id);
            info.AddValue("Type", Type);
            info.AddValue("ReadOnly", ReadOnly);
            info.AddValue("Required", Required);
            info.AddValue("Relevant", Relevant);
            info.AddValue("Valid", Valid);
        }

    }

}

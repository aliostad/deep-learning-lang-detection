using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

using NXKit.Serialization;

namespace NXKit.XForms
{

    /// <summary>
    /// Serializable storage for a <see cref="UIBinding"/>'s state.
    /// </summary>
    [SerializableAnnotation]
    public class UIBindingState :
        IAttributeSerializableAnnotation
    {

        XName dataType;
        bool relevant = true;
        bool readOnly = false;
        bool required = false;
        bool valid = true;
        string value = "";

        bool dispatchValueChanged;
        bool dispatchReadOnly;
        bool dispatchReadWrite;
        bool dispatchRequired;
        bool dispatchOptional;
        bool dispatchEnabled;
        bool dispatchDisabled;
        bool dispatchValid;
        bool dispatchInvalid;

        public string Value
        {
            get { return value; }
            set { this.value = value; }
        }

        public bool DispatchValueChanged
        {
            get { return dispatchValueChanged; }
            set { dispatchValueChanged = value; }
        }

        public XName DataType
        {
            get { return dataType; }
            set { dataType = value; }
        }

        public bool Relevant
        {
            get { return relevant; }
            set { relevant = value; }
        }

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

        public bool ReadOnly
        {
            get { return readOnly; }
            set { readOnly = value; }
        }

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

        public bool Required
        {
            get { return required; }
            set { required = value; }
        }

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

        public bool Valid
        {
            get { return valid; }
            set { valid = value; }
        }

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

        IEnumerable<XAttribute> IAttributeSerializableAnnotation.Serialize(AnnotationSerializer serializer, XNamespace ns)
        {
            if (dataType != null)
                yield return new XAttribute(ns + "type", dataType);
            if (!relevant)
                yield return new XAttribute(ns + "relevant", relevant);
            if (readOnly)
                yield return new XAttribute(ns + "readonly", readOnly);
            if (required)
                yield return new XAttribute(ns + "required", required);
            if (!valid)
                yield return new XAttribute(ns + "valid", valid);
            if (value != null && value != "")
                yield return new XAttribute(ns + "value", value);
        }

        void IAttributeSerializableAnnotation.Deserialize(AnnotationSerializer serializer, XNamespace ns, IEnumerable<XAttribute> attributes)
        {
            dataType = attributes.Where(i => i.Name == ns + "type").Select(i => XName.Get((string)i)).FirstOrDefault();
            relevant = (bool?)attributes.FirstOrDefault(i => i.Name == ns + "relevant") ?? true;
            readOnly = (bool?)attributes.FirstOrDefault(i => i.Name == ns + "readonly") ?? false;
            required = (bool?)attributes.FirstOrDefault(i => i.Name == ns + "required") ?? false;
            valid = (bool?)attributes.FirstOrDefault(i => i.Name == ns + "valid") ?? true;
            value = (string)attributes.FirstOrDefault(i => i.Name == ns + "value") ?? "";
        }

    }

}

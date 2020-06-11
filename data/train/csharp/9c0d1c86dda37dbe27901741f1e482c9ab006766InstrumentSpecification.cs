using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RicksGuitarsStart.Model
{
    public class InstrumentSpecification
    {
        private Dictionary<string, object> _properties;
        public IDictionary<string, object> Properties => _properties;

        public InstrumentSpecification(IDictionary<string, object> properties) 
            => _properties = properties is null ? new Dictionary<string, object>() : new Dictionary<string, object>(properties);

        /// <summary>
        /// Check every property in the <paramref name="other"/> specification against the properties in the instance. 
        /// </summary>
        /// <param name="other">The properties to match on.</param>
        /// <returns>True if all the properties in <paramref name="other"/> match proerties in the instance; otherwise false.</returns>
        public bool Matches(InstrumentSpecification other)
        {
            if (other == null)
                throw new ArgumentNullException(nameof(other));

            foreach (KeyValuePair<string, object> property in other.Properties)
            {
                if (!Properties.Contains(property))
                    return false;
            }
            return true;
        }

        /// <summary>
        /// Return the value of the named property
        /// </summary>
        /// <param name="name">The name of the property.</param>
        /// <returns>The value of the named property if it exists; otherwise null.</returns>
        public object GetProperty(string name) => Properties.ContainsKey(name) ? Properties[name] : null;

        /// <summary>
        /// Check if two InstrumentSpecifications are equal.
        /// </summary>
        /// <param name="other">The second InstrumentSpecification to check for equality.</param>
        /// <returns>True if all of the properties in the two speciifcations match; otherwise false.</returns>
        public bool Equals(InstrumentSpecification other) => other != null && Properties == other.Properties;
       

        /// <summary>
        /// Check if the InstrumentSpecification is equal to the given object.
        /// </summary>
        /// <param name="other">The second object to check for equality.</param>
        /// <returns>True if the InstrumentSpecification is equal to the given object; otherwise false.</returns>
        public override bool Equals(object obj)
        {
            InstrumentSpecification other = obj as InstrumentSpecification;
            return Equals(other);
        }

        /// <summary>
        /// Return the hash code for the InstrumentSpecification.
        /// </summary>
        /// <returns>The hash code for the InstrumentSpecification.</returns>
        public override int GetHashCode() => Properties.GetHashCode();

        /// <summary>
        /// Check if two InstrumentSpecifications are equal.
        /// </summary>
        /// <param name="instrumentSpecification1">The first InstrumentSpecification.</param>
        /// <param name="instrumentSpecification2">The second InstrumentSpecification.</param>
        /// <returns>True if the the two InstrumentSpecifications are equal; otherwise false.</returns>
        public static bool operator ==(InstrumentSpecification instrumentSpecification1, InstrumentSpecification instrumentSpecification2)
            => instrumentSpecification1 is null || instrumentSpecification2 is null ?
                Object.Equals(instrumentSpecification1, instrumentSpecification2)
                : instrumentSpecification1.Equals(instrumentSpecification2);


        /// <summary>
        /// Check if two InstrumentSpecifications are not equal.
        /// </summary>
        /// <param name="instrumentSpecification1">The first InstrumentSpecification.</param>
        /// <param name="instrumentSpecification2">The second InstrumentSpecification.</param>
        /// <returns>True if the the two InstrumentSpecifications are not equal; otherwise false.</returns>
        public static bool operator !=(InstrumentSpecification instrumentSpecification1, InstrumentSpecification instrumentSpecification2)
            => !(instrumentSpecification1 is null || instrumentSpecification2 is null ?
                Object.Equals(instrumentSpecification1, instrumentSpecification2)
                : instrumentSpecification1.Equals(instrumentSpecification2));
    }
}

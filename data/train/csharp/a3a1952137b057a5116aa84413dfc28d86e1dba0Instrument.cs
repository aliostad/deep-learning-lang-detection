using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RicksGuitarsStart.Model
{
    public class Instrument : IEquatable<Instrument>
    {
        public string SerialNumber { get; protected set; }
        public decimal Price { get; protected set; }
        public InstrumentSpecification Specification { get; protected set; }

        public Instrument(string serialNumber, decimal price, InstrumentSpecification specification)
        {
            SerialNumber = serialNumber;
            Price = price;
            this.Specification = specification;
        }

        /// <summary>
        /// Check if two Instruments are equal.
        /// </summary>
        /// <param name="other">The second Instrument to check for equality.</param>
        /// <returns>True if the two Instruments are equal; otherwise false.</returns>
        public bool Equals(Instrument other) => other != null && SerialNumber == other.SerialNumber;

        /// <summary>
        /// Check if the Instrument is equal to the given object.
        /// </summary>
        /// <param name="other">The second object to check for equality.</param>
        /// <returns>True if the Instrument is equal to the given object; otherwise false.</returns>
        public override bool Equals(object obj)
        {
            Instrument other = obj as Instrument;
            return Equals(other);
        }

        /// <summary>
        /// Return the hash code for the Instrument.
        /// </summary>
        /// <returns>The hash code for the Instrument.</returns>
        public override int GetHashCode() => SerialNumber.GetHashCode();

        /// <summary>
        /// Check if two Instruments are equal.
        /// </summary>
        /// <param name="InstrumentSpecification1">The first Instrument.</param>
        /// <param name="InstrumentSpecification2">The second Instrument.</param>
        /// <returns>True if the the two InstrumentSpecifications are equal; otherwise false.</returns>
        public static bool operator ==(Instrument instrument1, Instrument instrument2)
            => instrument1 is null || instrument2 is null ?
                Object.Equals(instrument1, instrument2)
                : instrument1.Equals(instrument2);


        /// <summary>
        /// Check if two Instruments are not equal.
        /// </summary>
        /// <param name="InstrumentSpecification1">The first Instrument.</param>
        /// <param name="InstrumentSpecification2">The second Instrument.</param>
        /// <returns>True if the the two Instruments are not equal; otherwise false.</returns>
        public static bool operator !=(Instrument instrument1, Instrument instrument2)
            => !(instrument1 is null || instrument2 is null ?
                Object.Equals(instrument1, instrument2)
                : instrument1.Equals(instrument2));
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace Observer.Rebuild
{
    /// <summary>
    /// A collection of instruments, enabling the order books of multiple instruments to be rebuilt from the same file stream.
    /// </summary>
    internal sealed class InstrumentCollection : IList<Instrument>
    {
        private List<Instrument> instrumentCollection = new List<Instrument>();
        private List<int> pertinentContracts = new List<int>();
        private DateTime previousCallTime;

        /// <summary>
        /// A collection of instruments, enabling the order books of multiple instruments to be rebuilt from the same file stream.
        /// </summary>
        /// <param name="directoryPath">The location of the directory in which the instrument configuration files are located.</param>
        public InstrumentCollection(string directoryPath)
        {
            PopulateCollection(directoryPath);
        }

        private void PopulateCollection(string directoryPath)
        {
            foreach (string file in Directory.GetFiles(directoryPath))
            {
                instrumentCollection.Add(new Instrument(file));
            }
        }

        /// <summary>
        /// Returns an up-to-date list of the pertinent contracts of all instruments in the collection, as defined by each instrument's configuration file.
        /// </summary>
        /// <param name="currentTime"></param>
        /// <returns></returns>
        public List<int> PertinentContracts(DateTime currentTime)
        {
            if (currentTime.IsWithinCacheRangeOf(previousCallTime))
                return pertinentContracts;

            pertinentContracts.Clear();

            foreach (Instrument instrument in instrumentCollection)
            {
                foreach (int contract in instrument.PertinentContracts(currentTime))
                {
                    pertinentContracts.Add(contract);
                }
            }

            previousCallTime = currentTime;

            return pertinentContracts;
        }

        public int IndexOf(Instrument item)
        {
            return instrumentCollection.IndexOf(item);
        }

        public void Insert(int index, Instrument item)
        {
            instrumentCollection.Insert(index, item);
        }

        public void RemoveAt(int index)
        {
            instrumentCollection.RemoveAt(index);
        }

        public Instrument this[int index]
        {
            get
            {
                return instrumentCollection[index];
            }
            set
            {
                instrumentCollection[index] = value;
            }
        }

        /// <summary>
        /// Works the same as System.Collections.Generic.List's 'Add' function, but throws an exception if identical instruments are added.
        /// </summary>
        /// <param name="item"></param>
        public void Add(Instrument item)
        {
            bool containsInstrument = false;
            foreach (Instrument instrument in instrumentCollection)
            {
                if (item.Name == instrument.Name)
                {
                    containsInstrument = true;
                    break;
                }
            }

            if (containsInstrument)
                throw new SystemException("EXCEPTION: InstrumentCollection already contains instrument \"" + item.Name + "\".");
            else
                instrumentCollection.Add(item);
        }

        public void Clear()
        {
            instrumentCollection.Clear();
        }

        public bool Contains(Instrument item)
        {
            return instrumentCollection.Contains(item);
        }

        public void CopyTo(Instrument[] array, int arrayIndex)
        {
            instrumentCollection.CopyTo(array, arrayIndex);
        }

        public int Count
        {
            get { return instrumentCollection.Count; }
        }

        public bool IsReadOnly
        {
            get { return ((IList<Instrument>)instrumentCollection).IsReadOnly; }
        }

        public bool Remove(Instrument item)
        {
            return instrumentCollection.Remove(item);
        }

        public IEnumerator<Instrument> GetEnumerator()
        {
            return instrumentCollection.GetEnumerator();
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return instrumentCollection.GetEnumerator();
        }
    }
}

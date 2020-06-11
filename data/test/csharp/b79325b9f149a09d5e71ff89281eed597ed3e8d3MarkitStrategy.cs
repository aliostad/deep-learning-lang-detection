using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using QLNet;

namespace QLyx.Simulation
{
    public class MarkitStrategy<T> : InvestmentStrategy<T> where T : InstrumentHelper
    {

        
        // Constructors
        public MarkitStrategy(SimulationParameters simulationParameters, T instrumentParameters ) 
            : base(simulationParameters, instrumentParameters) { }

        
        // Methods
        public virtual Instrument Instrument()
        {
            throw new NotImplementedException();
        }

    }



}

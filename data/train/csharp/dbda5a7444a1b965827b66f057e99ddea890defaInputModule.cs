using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NFlowGraph.Core
{

    public class InputModule<TOutput> : Module<bool, TOutput>
    {
        private Func<TOutput> _process;
        protected Func<TOutput> Process { get { return _process; } set { _process = value; base.Process = input => _process(); } }
        
        public InputModule(Func<TOutput> process) : base()
        {
            _process = process;
            base.Process = input => _process();
        }
        
        public InputModule() : base()
        {
        }      
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Threading;

namespace flood
{
    sealed class RefreshDispatchTimer
    {
        private RefreshDispatchTimer() { }

        private static readonly Lazy<RefreshDispatchTimer> lazy = new Lazy<RefreshDispatchTimer>(()
            => new RefreshDispatchTimer() { Timer = new DispatcherTimer() }, true);
        public DispatcherTimer Timer { get; private set; }

        public static RefreshDispatchTimer Instance
        {
            get
            {
                return lazy.Value;
            }
        }
        
            
        
    }
}

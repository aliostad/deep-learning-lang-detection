using System;
using System.Diagnostics;
using Core;
using Core.API;
using Core.Abstractions;

namespace Plugins.Processes
{
    [DefaultAction(typeof(SwitchToWindow))]
    internal class ProcessItem : ITypedItem<Process>
    {
        private readonly Process _process;

        public ProcessItem(Process process)
        {
            _process = process;
        }

        public string Text
        {
            get { return string.Format("{0} - {1}", _process.ProcessName, _process.MainWindowTitle); }
        }

        public string Description
        {
            get { return string.Format("Process {0} - Window {1} with id: {2}", _process.ProcessName, _process.MainWindowTitle, _process.Id); }
        }

        public object Item
        {
            get { return TypedItem; }
        }

        public Process TypedItem
        {
            get { return _process; }
        }
    }
}
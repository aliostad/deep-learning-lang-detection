using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Threading;
using System.Runtime.InteropServices;

namespace CSharpUtils.Process
{
	abstract public class Process : ProcessBase
    {
        static protected Process currentExecutingProcess = null;

        protected int priority = 0;
        protected double x = 0, y = 0, z = 0;
        protected Process parent = null;
        protected LinkedList<Process> childs;

        static private LinkedList<Process> _allProcesses = new LinkedList<Process>();

        static public LinkedList<Process> allProcesses
        {
            get
            {
                return new LinkedList<Process>(_allProcesses);
            }
        }

        static public void _removeOld()
        {
            foreach (var process in allProcesses)
            {
                if (process.State == State.Ended) process._Remove();
            }
        }

        protected void _ExecuteProcessBefore()
        {
            foreach (var process in childs.Where(process => process.priority < 0).OrderBy(process => process.priority)) process._ExecuteProcess();
        }

        protected void _ExecuteProcessAfter()
        {
            foreach (var process in childs.Where(process => process.priority >= 0).OrderBy(process => process.priority)) process._ExecuteProcess();
        }

        public void _ExecuteProcess()
        {
            if (State == State.Ended) return;

            currentExecutingProcess = this;

            this._ExecuteProcessBefore();
			//Console.WriteLine("<Execute " + this + ">");
			this.SwitchTo();
			//Console.WriteLine("</Execute " + this + ">");
			this._ExecuteProcessAfter();
        }

        protected void _DrawProcessBefore()
        {
            foreach (var process in childs.Where(process => process.z < 0).OrderBy(process => process.z)) process._DrawProcess();
        }

        protected void _DrawProcessAfter()
        {
            foreach (var process in childs.Where(process => process.z >= 0).OrderBy(process => process.z)) process._DrawProcess();
        }

        public void _DrawProcess()
        {
            this._DrawProcessBefore();
            this.Draw();
            this._DrawProcessAfter();
        }

        virtual protected void Draw()
        {
            //Console.WriteLine(this);
        }

        public Process() : base()
        {
            _allProcesses.AddLast(this);
            childs = new LinkedList<Process>();
            parent = currentExecutingProcess;
            if (parent != null)
            {
                parent.childs.AddLast(this);
            }
        }

		~Process()
		{
			_Remove();
		}

		override protected void _Remove()
		{
			if (parent != null)
			{
				parent.childs.Remove(this);
			}
			_allProcesses.Remove(this);
			base._Remove();
		}
    }
}

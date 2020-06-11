using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Utilities.Threading;

namespace Juixel.Tools
{
    public class DispatchQueue
    {
        #region Static Regions

        public static DispatchQueue Main = new DispatchQueue();

        public static DispatchQueue IO;

        public static void DispatchMain(Action Block)
        {
            Main.Dispatch(Block);
        }

        public static void DispatchIO(Action Block)
        {
            if (IO == null)
            {
                IO = new DispatchQueue();
                StartIOQueue();
            }
            IO.Dispatch(Block);
        }

        private static async void StartIOQueue()
        {
            while (true)
            {
                await Task.Delay(100);
                if (IO != null)
                    IO.Step();
                else
                    return;
            }
        }

        public static void DispatchBackground(Action Action)
        {
            var Thread = new Thread(() => { Action(); });
            Thread.IsBackground = true;
            Thread.Start();
        }

        #endregion

        private LockingList<Action> ToDispatch = new LockingList<Action>();

        public void Dispatch(Action Block) => ToDispatch.Add(Block);

        public void Step()
        {
            if (ToDispatch.Count > 0)
            {
                Action[] Blocks = ToDispatch.ToArrayAndClear();
                for (int i = 0; i < Blocks.Length; i++)
                    Blocks[i].Invoke();
            }
        }
    }
}

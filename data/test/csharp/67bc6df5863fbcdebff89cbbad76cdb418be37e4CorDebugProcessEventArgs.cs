namespace HDebuggerCore.Wrappers
{
    using HDebuggerCore.NativeAPI;




    /// <summary>
    /// 
    /// </summary>
    public class CorDebugProcessEventArgs : CorDebugEventArgs
    {
        #region Fields
        private readonly CorDebugProcess _process;
        #endregion







        #region Constructors
        private CorDebugProcessEventArgs()
        {
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="process"></param>
        public CorDebugProcessEventArgs(ICorDebugProcess process)
            : this(new CorDebugProcess(process))
        {
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="process"></param>
        public CorDebugProcessEventArgs(CorDebugProcess process)
        {
            this._process = process;
        }
        #endregion








        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public CorDebugProcess Process
        {
            get { return this._process; }
        }
        #endregion
    }
}

// License Rider: I really don't care how you use this code, or if you give credit. Just don't blame me for any damage you do
namespace ProdUI.Adapters
{
    /// <summary>
    /// Provides access to methods for controls the implement the UIA InvokePattern
    /// </summary>
    public interface InvokeAdapter
    {
        /// <summary>
        /// Performs the Invoke action associated with the control
        /// </summary>
        /// <example>this.Invoke(this);</example>
        void Invoke();
    }
}
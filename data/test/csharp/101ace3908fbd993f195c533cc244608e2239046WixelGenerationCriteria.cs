using System;

public class WixelGenerationCriteria
{
    #region Fields

    public Func<int, int, int, WixelChunk, bool> Condition;
    public Action<int, int, int, WixelChunk> Action;

    #endregion Fields

    #region Methods

    /// <summary>
    /// If this criteria's condition is true, perform the associated
    /// action.
    /// </summary>
    /// <param name="x">X chunk coordinate</param>
    /// <param name="y">Y chunk coordinate</param>
    /// <param name="z">Z chunk coordinate</param>
    /// <param name="chunk">Chunk to operate on</param>
    public void CheckCriteria(int x, int y, int z, WixelChunk chunk)
    {
        if (!Condition(x, y, z, chunk))
            return;

        Action(x, y, z, chunk);
    }

    #endregion Methods
}

using UnityEngine;
using System.Collections;

public class PreviewChunk : Chunk
{
    public static PreviewChunk use;

    public VTileChunk chunk;
    
    protected override void Awake()
    {
        use = this;
        base.Awake();
    }

    void Start()
    {
        chunk = new VTileChunk(-1, -1, -1, 8, 8, 8);
    }

    void LateUpdate()
    {
        VTile t = tile.GetTile();

        cachedVChunk = chunk;

        if (chunk.GetWidth() != t.GetWidth() ||
            chunk.GetHeight() != t.GetHeight() ||
            chunk.GetDepth() != t.GetDepth())
        {
            chunk.Resize(t.GetWidth(), t.GetHeight(), t.GetDepth());
        }

        if (GetChunk().IsDirty() || t.GetPalette().IsDirty()) Refresh();

        mr.enabled = Tool.editing;
    }

    public void Clear()
    {
        chunk.SetPaletteIndices(new byte[chunk.GetWidth() * chunk.GetHeight() * chunk.GetDepth()]);
    }
}

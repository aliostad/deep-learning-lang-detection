using UnityEngine;
using UnityEditor;
using System.Collections;

namespace MyDungeon.Editors
{
    [CustomEditor(typeof(Chunk))]
    public class EditorChunk : Editor
    {
        Chunk _chunk;

        void OnEnabled()
        {
            _chunk = (Chunk) target;
        }

        public override void OnInspectorGUI()
        {
            if (!_chunk)
                _chunk = (Chunk)target;

            if (Application.isPlaying)
            {
                if (GUILayout.Button("Generate"))
                    _chunk.GenerateTiles();

                if (GUILayout.Button("Update"))
                    _chunk.UpdateTiles();

                GUILayout.Space(20);
            }

            base.OnInspectorGUI();
        }

    }
}



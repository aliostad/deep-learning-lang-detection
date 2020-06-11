using UnityEngine;
using System.Collections;

public class CRTPresetApplier : MonoBehaviour
{
    public CRTProcess _process;

    private CRTProcess process
    {
        get
        {
            if (_process == null)
            {
                _process = Camera.main.GetComponent<CRTProcess>();
                if (_process == null)
                {
                    return null;
                }
            }
            return _process;
        }
    }

    public void TurnOffEffect()
    {
        process.pixelHeight = 1;
        process.pixelWidth = 1;
        process.pixelPitch = 0;
        process.softness = 1;
    }

    public void Pixelate()
    {
        process.pixelHeight = 6;
        process.pixelWidth = 6;
        process.pixelPitch = 0;
        process.softness = 1;
    }

    public void CRTify()
    {
        process.pixelHeight = 8;
        process.pixelWidth = 6;
        process.pixelPitch = 1;
        process.softness = 0.25f;
    }
}

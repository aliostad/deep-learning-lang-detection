using UnityEngine;

public class InputCore : UnitySingleton<InputCore>
{
    public void Update()
    {
        foreach (var instrument in InstrumentHelper.GetInstrumentList())
        {
            CheckInstrument(instrument);
        }
        Input.ResetInputAxes();
    }

    public void CheckInstrument(Instrument instrument)
    {
        if (Input.GetButtonDown(instrument.ToString()))
        {
            MusicCore.Instance.RecordHit(instrument, RhythmCore.Instance.GetAbsoluteTime());
        }
    }
}
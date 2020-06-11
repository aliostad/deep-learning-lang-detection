using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using MusicIO;

public class InstrumentController : MonoBehaviour
{

    //Singleton references
    private static InstrumentController m_instance;
    public static InstrumentController Instance { get { return m_instance; } }

    //InstrumentOrb references
    protected List<InstrumentHandle> m_instruments;
    protected List<InstrumentHandle> m_returns;
    protected InstrumentHandle m_selectedInstrument;
    protected GameObject m_lastSelectedGameInstrument = null;

    private Queue<InstrumentParameter> m_queuedParameters;

    // Unity
    //-------------------------------------
    void Awake()
    {
        m_instruments = new List<InstrumentHandle>();
        m_returns = new List<InstrumentHandle>();
        m_instance = this;
        m_queuedParameters = new Queue<InstrumentParameter>();
    }

    public void AddToQueue(InstrumentParameter param)
    {
        m_queuedParameters.Enqueue(param);
    }


    void Update()
    {
        if (m_queuedParameters.Count > 0)
        {
            m_queuedParameters.Dequeue().Send();
        }

        //foreach (InstrumentHandle instrument in m_instruments)
        //{
        //    instrument.update();
        //}

        //foreach (InstrumentHandle instrument in m_returns)
        //{
        //    instrument.update();
        //}
    }



    //InstrumentOrb selection
    //--------------------
    public InstrumentHandle SelectedInstrument { get { return m_selectedInstrument; } }


    /*
     * Adds an instrument
     */
    public void AddInstrument(InstrumentHandle instrument)
    {
        m_instruments.Add(instrument);
    }

    public void AddReturn(InstrumentHandle instrument)
    {
        m_returns.Add(instrument);
    }


    /*
     * Gets instrument by name
     */
    public InstrumentHandle GetInstrumentByName(string targetInstrument)
    {
        foreach (InstrumentHandle instrument in m_instruments)
        {
            if (instrument.name == targetInstrument)
                return instrument;
        }

        return null;
    }

    public InstrumentHandle GetInstrumentByTrackindex(int trackindex)
    {
        foreach (InstrumentHandle instrument in m_instruments)
        {
            if (instrument.trackIndex == trackindex)
                return instrument;
        }

        return null;
    }

    /*
     * Finds a specific parameter by index
     */
    public DeviceParameter FindParameter(int trackindex, int deviceindex, int parameterindex, int category)
    {

        List<InstrumentHandle> instrumentList;

        if (category == 0)
            instrumentList = m_instruments;
        else
            instrumentList = m_returns;

        foreach (InstrumentHandle instrument in instrumentList)
        {
            if (instrument.trackIndex == trackindex)
            {
                foreach (DeviceParameter param in instrument.paramList)
                {
                    if (param.deviceIndex == deviceindex && param.parameterIndex == parameterindex)
                    {
                        return param;
                    }
                }
            }
        }
        return null;
    }

    public SendParameter FindSendParameter(int trackindex, int sendindex)
    {
        foreach (InstrumentHandle instrument in m_instruments)
        {
            if (instrument.trackIndex == trackindex)
            {
                foreach (SendParameter send in instrument.sendsList)
                {
                    if (send.sendIndex == sendindex)
                    {
                        return send;
                    }
                }
            }
        }
        return null;
    }

    /*
     * Find a specific clip by index
     */
    public ClipParameter FindClip(int trackindex, int clipindex)
    {
        foreach (InstrumentHandle instrument in m_instruments)
        {
            if (instrument.trackIndex == trackindex)
            {
                foreach (ClipParameter clip in instrument.clipList)
                {
                    if (clip.scene == clipindex)
                    {
                        return clip;
                    }
                }
            }
        }
        return null;
    }


    /*
     * Remembers last selected isntrument
     */
    public void SetLastSelectedGameInstrument(GameObject gameInstrument)
    {
        m_lastSelectedGameInstrument = gameInstrument;
    }


    /*
     * Gets last selected isntrument
     */
    public GameObject LastSelectedGameInstrument { get { return m_lastSelectedGameInstrument; } }

}

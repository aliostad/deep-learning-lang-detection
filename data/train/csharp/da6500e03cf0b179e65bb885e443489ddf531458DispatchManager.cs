using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DispatchManager {

    private static DispatchManager instance;
    private EntityManager m_EntityManager;

    private DispatchManager() { }

    public static DispatchManager Instance
    {
        get
        {
            if (instance == null)
            {
                instance = new DispatchManager();
            }
            return instance;
        }
    }

    public void DispatchMessage(Telegram telegram)
    {

    }
}

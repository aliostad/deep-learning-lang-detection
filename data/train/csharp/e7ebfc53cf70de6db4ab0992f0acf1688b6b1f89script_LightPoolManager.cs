using UnityEngine;
using System.Collections;

public class script_LightPoolManager : MonoBehaviour {

    public GameObject LightPoolParent;
    public Object prefab;

    public void OnSpawnInstrument(GameObject instrument)
    {
        //lights.Add(new InstrumentSpotlight(instrument));
        
        if(prefab)
        {

            GameObject light = (GameObject)Network.Instantiate(prefab, new Vector3(0, 0, 0), new Quaternion(), 0);
            light.GetComponent<InstrumentSpotlight>().setInstrument(instrument);

        }
    }

   
}

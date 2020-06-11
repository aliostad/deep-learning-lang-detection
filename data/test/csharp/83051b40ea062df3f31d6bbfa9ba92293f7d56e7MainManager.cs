using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainManager : MonoBehaviour {

    public bool _won = false;
    public bool Won
    {
        get
        {
            return _won;
        }
    }

    public GameObject Boat;
    public Animator boatAnim;

    /** The size of the band playing the romantic music */
    private const int GOOD_BAND_SIZE = 3;

    /** The size of the band playing the metal music */
    private const int METAL_BAND_SIZE = 2;

    static private MainManager instance;
    static public MainManager Instance
    {
        get
        {
            return instance;
        }
    }

    private Dictionary<VuforiaObjectTest.InstrumentType, int> instrumentCounts =
        new Dictionary<VuforiaObjectTest.InstrumentType, int>();

    public void increaseInstrument(VuforiaObjectTest.InstrumentType type)
    {
        if (instrumentCounts.ContainsKey(type)) {
            instrumentCounts[type]++;
        }
        else
        {
            // this is the first time an instrument of this type is encountered
            instrumentCounts[type] = 1;
        }
    }    

    public void decreaseInstrument(VuforiaObjectTest.InstrumentType type)
    {
        if (instrumentCounts.ContainsKey(type))
        {
            instrumentCounts[type]--;
        }
    }

    // Use this for initialization
    void Start () {
        instance = this;
        boatAnim = Boat.GetComponent<Animator>();
        instrumentCounts[VuforiaObjectTest.InstrumentType.GOOD] = 0;
        instrumentCounts[VuforiaObjectTest.InstrumentType.METAL] = 0;
        instrumentCounts[VuforiaObjectTest.InstrumentType.WEIRD] = 0;

    }
	
	// Update is called once per frame
	void Update () {

        boatAnim.SetInteger("GoodMusic", instrumentCounts[VuforiaObjectTest.InstrumentType.GOOD] - instrumentCounts[VuforiaObjectTest.InstrumentType.METAL] - instrumentCounts[VuforiaObjectTest.InstrumentType.WEIRD] - 3);
        if (!_won) {
            // check if boat is in view
            if (instrumentCounts[VuforiaObjectTest.InstrumentType.BOAT] >= 1)
            {
                // check if the full metal band is playing
                if (instrumentCounts[VuforiaObjectTest.InstrumentType.GOOD] == 0 &&
                    instrumentCounts[VuforiaObjectTest.InstrumentType.METAL] >= METAL_BAND_SIZE &&
                    instrumentCounts[VuforiaObjectTest.InstrumentType.WEIRD] == 0
                    )
                {

                    /* TODO change boat animation to fighting maybe?
                    otherwise change boat animation to weird faces */

                }

                // check if the current playing band is good
                else if (instrumentCounts[VuforiaObjectTest.InstrumentType.METAL] == 0 &&
                    instrumentCounts[VuforiaObjectTest.InstrumentType.WEIRD] == 0)
                {
                    if (instrumentCounts[VuforiaObjectTest.InstrumentType.GOOD] == GOOD_BAND_SIZE)
                    {
                        _won = true;

                        // TODO change boat animation to win scene

                        
                    }
                    else
                    {
                        /* TODO change boat animation depending on how many good 
                         * band members are currently playing */
                    }
                }

                // the band must be playing weird music
                else
                {
                    // TODO change boat animation to weird faces
                }
            }
            if (_won)
            {
                GameObject[] winObjects = GameObject.FindGameObjectsWithTag("winobject");
                foreach (GameObject obj in winObjects)
                {
                    obj.transform.SetParent(Boat.transform);
                }
            } 
        }

	}
}

using UnityEngine;
using System.Collections;
using Assets;
using System.Collections.Generic;

public class instrumentScript : MonoBehaviour {



    private Instrument instrument;


    internal Instrument Instrument
    {
        get { return instrument; }
        set { instrument = value; }
    }
  
    void OnMouseDown()
    {

        Debug.Log(instrument.Nom);
        gameObject.transform.parent.active = false;
        GameObject.Find("BoutonMenu").GetComponent<BoutonMenuScript>().Instrument = this.instrument;
        GameObject.Find("BoutonMenu").GetComponent<SpriteRenderer>().sprite = this.GetComponent<SpriteRenderer>().sprite;
        GameObject.Find("BoutonMenu").GetComponent<Transform>().localScale = new Vector3((float)1.5, (float)1.5, (float)0.0);

        GameObject.Find("BoutonMenu").GetComponent<BoutonMenuScript>().LoadLoop();
    }

    
}

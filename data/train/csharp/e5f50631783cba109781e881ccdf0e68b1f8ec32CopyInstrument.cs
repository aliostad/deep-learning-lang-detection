using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System.Collections.Generic;

public class CopyInstrument : MonoBehaviour, IDropHandler{

	//Holds the insturments so they can be copied (AAJ)
	private GameObject[] instruments;

	//Holds the instrument number of the instrument being copied from (AAJ)
	private int copiedInstrument;

	//Holds the instrument number of the instrument being pasted to (AAJ)
	private int pastedInstrument;

	//Returns the first child (AAJ)
	public GameObject item{
		
		get{
			
			if (transform.childCount > 0){
				
				return transform.GetChild(0).gameObject;
			}//if
			return null;
		}//get
	}//item

	//Copies one instrument onto another(AAJ)
	#region IDropHandler implementation
	public void OnDrop (PointerEventData eventData){

		if(!item){

			if(DragAndDrop.itemBeingDragged != null){

				if(DragAndDrop.itemBeingDragged.GetComponent<CopyInstrument>() != null){

					//Finds the instruments (AAJ)
					instruments = GameObject.FindGameObjectsWithTag("Instrument");

					//Gets the instrument number of the instrument that is being copied from (AAJ)
					copiedInstrument = DragAndDrop.itemBeingDragged.transform.parent.parent.GetComponentInParent<InstrumentScript>().instrumentNumber;

					//Gets the instrument number of the instrument that is being pasted to (AAJ)
					pastedInstrument = this.transform.GetComponentInParent<InstrumentScript>().instrumentNumber;

					Destroy(instruments[pastedInstrument].GetComponent<InstrumentScript>().graphSuspended);
					instruments[pastedInstrument].GetComponent<InstrumentScript>().CreateBGGraph();
					
					//Applies an edit to an instrument (AAJ)
					instruments[pastedInstrument].GetComponent<InstrumentScript>().
						LoadDataForInstrument(instruments[copiedInstrument].GetComponent<InstrumentScript>().Graph.sprite,
						instruments[copiedInstrument].GetComponent<InstrumentScript>().RawData,
						instruments[copiedInstrument].GetComponent<InstrumentScript>().fileName);
					
					//updates the overlayed graph image once the edit has been applied (AAJ)
					instruments[pastedInstrument].GetComponent<InstrumentScript>().
						graphSuspended.GetComponent<DrawLine>().UpdateLine(instruments[pastedInstrument].
						GetComponent<InstrumentScript>().RawData);
					
					instruments[pastedInstrument].GetComponent<InstrumentScript>().graphSuspended.
						GetComponent<DrawLine>().beingEdited = false;
					
				}//if
			}//if
		}//if
	}//OnDrop
	#endregion
}
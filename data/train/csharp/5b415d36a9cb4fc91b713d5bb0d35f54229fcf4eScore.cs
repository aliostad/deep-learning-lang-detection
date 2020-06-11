using UnityEngine;
using System.Collections;

public class Score : MonoBehaviour
{
	public static Score scoreInstance;
	public GameObject prefabInst;
	public AudioClip[] clips;

	//public bool[][] score;
	public bool[] inst0;
	public bool[] inst1;
	public bool[] inst2;
	public bool[] inst3;
	public static int instrumentCount;

	private GameObject[] instruments;
	private SequencerInstrument[] instrumentScripts;

	private int instrumentsCount;

	void Awake()
	{
		scoreInstance = this;

		instrumentsCount = clips.Length;
		instruments = new GameObject[instrumentsCount];
		instrumentScripts = new SequencerInstrument[instrumentsCount];
		//score = new bool[instrumentCount + 1][];

		for (int i = 0; i < instrumentsCount; i++)
		{
			instruments [i] = Instantiate (prefabInst);
			instruments [i].name = "" + i;
			instruments [i].transform.parent = this.transform;
			instrumentScripts [i] = instruments [i].GetComponent<SequencerInstrument> ();
			instrumentScripts [i].audioClip = clips [i];
			//score[instrumentCount] = new bool[16];
			//instrumentScripts [i].score = score[i];
			switch(i)
			{
			case 0: 
				instrumentScripts [i].score = inst0;
				break;
			case 1: 
				instrumentScripts [i].score = inst1;
				break;
			case 2: 
				instrumentScripts [i].score = inst2;
				break;
			case 3: 
				instrumentScripts [i].score = inst3;
				break;

			}
		}
	}

	public void onBarChange()
	{
		;
	}
}

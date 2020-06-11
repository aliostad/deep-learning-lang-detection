using UnityEngine;
using System.Collections;

public class SceneManager : MonoBehaviour {

	public enum ProcessType{
		Loading,
		CardSelect,
		CardDetail,
		Dump,
		Battle,

	}

	private ProcessParent mCurrentProcess;
	
	private ProcessBattle 		mProcessBattle;
	private ProcessCardDetail 	mProcessCardDetail;
	private ProcessCardSelect 	mProcessCardSelect;
	private ProcessLoading 		mProcessLoading;
	private ProcessDump 		mProcessDump;

	// Use this for initialization
	void Start () {
		mProcessBattle 		= GetComponentInChildren<ProcessBattle>();
		mProcessCardDetail 	= GetComponentInChildren<ProcessCardDetail>();
		mProcessCardSelect 	= GetComponentInChildren<ProcessCardSelect>();
		mProcessLoading 	= GetComponentInChildren<ProcessLoading>();
		mProcessDump 		= GetComponentInChildren<ProcessDump>();

		mCurrentProcess = mProcessLoading;
		//mCurrentProcess = mProcessLoading;

		mCurrentProcess.SceneStart();
	}
	
	public void ChangeScene(ProcessType type){
		mCurrentProcess.SceneEnd();

		switch(type){
		case ProcessType.Battle:
			mCurrentProcess = mProcessBattle;
			break;
		case ProcessType.CardDetail:
			mCurrentProcess = mProcessCardDetail;
			break;
		case ProcessType.CardSelect:
			mCurrentProcess = mProcessCardSelect;
			break;
		case ProcessType.Loading:
			mCurrentProcess = mProcessLoading;
			break;
		case ProcessType.Dump:
			mCurrentProcess = mProcessDump;
			break;
		}

		mCurrentProcess.SceneStart();
	}



	void OnGUI(){
		GUI.Label(new Rect(0, 0, Screen.width, 30), ""+mCurrentProcess.ToString());
	}
}

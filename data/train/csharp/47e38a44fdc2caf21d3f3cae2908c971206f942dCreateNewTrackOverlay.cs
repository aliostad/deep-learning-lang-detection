using UnityEngine;
using UnityEngine.UI;
using System;

public class CreateNewTrackOverlay : UIMenu
{
	public event Action<TrackData> OnCreate;
	public event Action OnCancel;

	public InputField trackNameInput;
	public UIButton instrumentButton;

	public TrackInstrumentList instrumentList;

	private InstrumentId currentInstrumentId;

	public UIButton createButton;
	public UIButton cancelButton;

	public void Init()
	{
		trackNameInput.text = "VOCALS";

		instrumentList.Init();
		instrumentList.gameObject.SetActive(false);

		currentInstrumentId = InstrumentId.Vocals;
		instrumentButton.setText(currentInstrumentId.ToString().ToUpper());

		instrumentButton.onClick += OnInstrumentButtonClick;

		createButton.onClick += OnCreateButtonClick;
		cancelButton.onClick += OnCancelButtonClick;
	}

	private void OnInstrumentButtonClick()
	{
		instrumentList.gameObject.SetActive(true);
		instrumentList.OnSelect += OnInstrumentSelect;
	}

	private void OnInstrumentSelect(InstrumentId instrumentId)
	{
		instrumentList.OnSelect -= OnInstrumentSelect;

		currentInstrumentId = instrumentId;
		instrumentButton.setText(currentInstrumentId.ToString().ToUpper());

		instrumentList.gameObject.SetActive(false);
	}

	private void OnCreateButtonClick()
	{
		string trackName = trackNameInput.text;
		string trackId = trackName.Trim();

		TrackData trackData = new TrackData(trackId, trackName, currentInstrumentId);
		if (OnCreate != null) OnCreate(trackData);
	}

	private void OnCancelButtonClick()
	{
		if (OnCancel != null) OnCancel();
	}
}
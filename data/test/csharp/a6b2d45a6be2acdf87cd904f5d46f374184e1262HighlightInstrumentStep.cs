using UnityEngine;
using DG.Tweening;
using CameraTools;
using Graphics;
using System.Collections;

namespace Interactive.Detail
{
	public class HighlightInstrumentStep : BeginStepGameBase
	{
        private CameraManager cameraManager;
        private GameObject instrument;

        private HighlightObject instrumentHighlight;

        public override void StartStep()
        {
            instrument = GameObject.FindGameObjectWithTag("Instrument");

            if (instrument != null)
            {
                instrumentHighlight = instrument.GetComponent<HighlightObject>();
                instrumentHighlight.ActivateHighlight();
                instrumentHighlight.AnimationLoopCompleted += CompleteStep;
            }
            else
            {
                CompleteStep();
            }
		}

        private void CompleteStep()
        {
            EndStep();
        }
	}
}
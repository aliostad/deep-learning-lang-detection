using System.Collections.Generic;
using UnityEngine;
using System.Collections;
using Magicolo.GeneralTools;

namespace Magicolo.AudioTools {
	[System.Serializable]
	public class SamplerItemManager : AudioItemManager {

		public Sampler sampler;
		
		Dictionary<string, SamplerInstrument> instrumentDict;
		
		public SamplerItemManager(Sampler sampler)
			: base(sampler.listener, sampler.infoManager, sampler) {
			
			this.sampler = sampler;
			BuildInstrumentDict();
		}

		public AudioItem Play(string instrumentName, int note, float velocity, object source, params AudioOption[] audioOptions) {
			SamplerInstrument instrument = GetInstrument(instrumentName);
			
			SingleAudioItem audioItem = GetSingleAudioItem(instrument, note, velocity, source);
			if (audioItem == null) {
				return instrument;
			}

			audioItem.Play(audioOptions);
			return audioItem;
		}

		public AudioItem Play(string moduleName, string instrumentName, int note, float velocity, object source, params AudioOption[] audioOptions) {
			PDModule module = player.generalSettings.PdPlayer.itemManager.GetModule(moduleName, source);
			SamplerInstrument instrument = GetInstrument(instrumentName);
			SingleAudioItem audioItem = GetPDSingleAudioItem(instrument, note, velocity, source);
			
			if (audioItem == null) {
				return instrument;
			}
			
			if (module.State != AudioStates.Playing) {
				module.Initialize();
				module.Play();
			}
			
			audioItem.Play(audioOptions);
			module.AddAudioItem(audioItem);
			
			return audioItem;
		}

		public virtual SamplerInstrument GetInstrument(string instrumentName) {
			SamplerInstrument instrument = null;
			try {
				instrument = instrumentDict[instrumentName];
			}
			catch {
				Debug.LogError(string.Format("Instrument named {0} was not found.", instrumentName));
			}
			return instrument;
		}

		public virtual SingleAudioItem GetSingleAudioItem(SamplerInstrument instrument, int note, float velocity, object source) {
			if (velocity > 0) {
				SamplerInstrumentLayer layer = instrument.GetLayer(note, velocity);
				SingleAudioItem audioItem = GetSingleAudioItem(layer.Name, source);
				audioItem.audioSource.clip = layer.GetClip();
				instrument.AddAudioItem(audioItem, note, velocity);
				return audioItem;
			}
			
			instrument.Stop(note);
			return null;
		}

		public virtual SingleAudioItem GetPDSingleAudioItem(SamplerInstrument instrument, int note, float velocity, object source) {
			if (velocity > 0) {
				SamplerInstrumentLayer layer = instrument.GetLayer(note, velocity);
				SingleAudioItem audioItem = player.generalSettings.PdPlayer.itemManager.GetSingleAudioItem(layer.Name, source);
				audioItem.audioSource.clip = layer.GetClip();
				instrument.AddAudioItem(audioItem, note, velocity);
				return audioItem;
			}
			
			instrument.Stop(note);
			return null;
		}

		public void BuildInstrumentDict() {
			instrumentDict = new Dictionary<string, SamplerInstrument>();
			
			foreach (SamplerInstrument instrument in sampler.editorHelper.instruments) {
				instrumentDict[instrument.Name] = instrument;
				idCounter += 1;
				instrument.Initialize(idCounter, this);
			}
		}
	}
}

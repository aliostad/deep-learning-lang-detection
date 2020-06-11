using Akka.Actor;
using AudioDevices;
using System;
using System.Collections.Generic;

namespace SongStreamer
{
    public class AudioHub : IDisposable
    {
        private static Dictionary<Instrument, int> channels = new Dictionary<Instrument, int>
        {
            { Instrument.Choir, 1 },
            { Instrument.Flute, 2 },
            { Instrument.JazzGuitar, 3 },
            { Instrument.Organ, 4 },
            { Instrument.Piano, 5 },
            { Instrument.SlapBass, 6 },
            { Instrument.TenorSax, 7 },
            { Instrument.Trumpet, 8 },
            { Instrument.Vibes, 9 }
        };

        private MidiSynthesizer synth;

        public ActorSystem System { get; private set; }

        public AudioHub()
        {
            System = ActorSystem.Create("speakers");
            synth = new MidiSynthesizer();
            foreach (var channel in channels)
                synth.SetVoice(channel.Value, (int)channel.Key);
        }

        public void Play(Pitch pitch, Instrument instrument, int volume)
        {
            synth.Play(pitch, channels[instrument], volume);
        }

        public void Stop(Pitch pitch, Instrument instrument)
        {
            synth.Stop(pitch, channels[instrument]);
        }

        public IActorRef NewSpeaker()
        {
            return System.ActorOf(Props.Create(() => new Speaker(this)));
        }

        public void Dispose()
        {
            System.Terminate();
            synth.Dispose();
        }
    }
}

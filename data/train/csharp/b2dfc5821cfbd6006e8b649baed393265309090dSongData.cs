using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using MME.Exceptions;
using MME.Sound;

namespace MME.Data
{
    public class SongData
    {
        public static float Bpm = 140;
        private static readonly Dictionary<string, bool[]> IsNotePlaying = new Dictionary<string, bool[]>();
        private static readonly Dictionary<string, WaveFunction> Instruments = new Dictionary<string, WaveFunction>();
        public static readonly Dictionary<string, List<Note>> NoteDb = new Dictionary<string, List<Note>>();
        private static readonly List<WaveGenerator> Voices = new List<WaveGenerator>();

        private static void _checkInstrAndNote(string instrumentName, int noteIndex)
        {
            if (noteIndex > 49 || noteIndex < 0)
                throw new IndexOutOfRangeException("Note index must be between 0 and 49");

            if (!Instruments.ContainsKey(instrumentName))
                throw new NullReferenceException("Instrument has not been added");
        }

        public static void AddNote(string instrumentName, int noteIndex, float amp, float startBeat, float lengthBeats)
        {
            _checkInstrAndNote(instrumentName, noteIndex);

            NoteDb[instrumentName].Add(new Note
            {
                Index = noteIndex,
                Volume = amp,
                StartBeat = startBeat,
                LengthBeats = lengthBeats
            });
        }

        public static void RemoveNote(NoteAndInstrument note)
        {
            NoteDb[note.InstrumentName].Remove(note);
        }

        public static WaveGenerator PlayInstrumentNote(string instrumentName, int noteIndex, float amp)
        {
            _checkInstrAndNote(instrumentName, noteIndex);

            Instruments.TryGetValue(instrumentName, out WaveFunction instrClone);
            instrClone = instrClone.Clone();
            instrClone.Frequency = Notes.NoteFreqs[noteIndex];
            instrClone.Amplitude = amp;

            var generator = new WaveGenerator(instrClone);

            generator.Play();

            Voices.Add(generator);

            return generator;
        }

        public static WaveGenerator PlayInstrumentNote(string instrumentName, Note note)
        {
            return PlayInstrumentNote(instrumentName, note.Index, note.Volume);
        }

        public static WaveGenerator PlayInstrumentNote(NoteAndInstrument note)
        {
            return PlayInstrumentNote(note.InstrumentName, note);
        }

        public static void StopInstrumentNote(WaveGenerator generator)
        {
            generator.Stop();
            if (Voices.Contains(generator))
                Voices.Remove(generator);
        }

        public static void AddInstrument(string instrumentName, WaveFunction instrument)
        {
            if (Instruments.ContainsKey(instrumentName)) throw new InstrumentException("Instrument already exists");

            Instruments.Add(instrumentName, instrument);
            IsNotePlaying.Add(instrumentName, new bool[49]);
            MainWindow.InstrumentsList.Items.Add(instrumentName);

            NoteDb.Add(instrumentName, new List<Note>());
        }

        public static void RemoveInstrument(string instrumentName)
        {
            Instruments.Remove(instrumentName);
            NoteDb.Remove(instrumentName);
            MainWindow.InstrumentsList.Items.Remove(instrumentName);
        }

        public static void RemoveAllInstruments()
        {
            Instruments.Clear();
            IsNotePlaying.Clear();
            MainWindow.InstrumentsList.Items.Clear();
            NoteDb.Clear();
        }

        public static Dictionary<string, WaveFunction> GetInstruments()
        {
            return Instruments;
        }

        public static List<Note> GetInstrumentNotes(string instrumentName)
        {
            _checkInstrAndNote(instrumentName, 0);
            return NoteDb[instrumentName];
        }

        public static void PlayNote(string instrumentName, int noteIndex)
        {
            _checkInstrAndNote(instrumentName, noteIndex);

            IsNotePlaying[instrumentName][noteIndex] = true;
        }

        public static void StopNote(string instrumentName, int noteIndex)
        {
            _checkInstrAndNote(instrumentName, noteIndex);

            IsNotePlaying[instrumentName][noteIndex] = false;
        }

        public static bool GetIsNotePlaying(string instrumentName, int noteIndex)
        {
            _checkInstrAndNote(instrumentName, noteIndex);

            return IsNotePlaying[instrumentName][noteIndex];
        }

        public static int GetVoicesCount()
        {
            return Voices.Count;
        }

        public static List<WaveGenerator> GetVoices()
        {
            return Voices;
        }

        public static void AddVoice(WaveGenerator voice)
        {
            Voices.Add(voice);
        }

        public static void RemoveVoice(WaveGenerator voice)
        {
            Voices.Remove(voice);
        }

        public static IEnumerable<NoteAndInstrument> EveryNote()
        {
            return (from instrument in NoteDb let instrumentName = instrument.Key from note in instrument.Value select new NoteAndInstrument(instrumentName, note)).ToList();
        }

        public static float CalculateLength()
        {
            // loop through all notes and find the last one
            return (from noteKeyValue in NoteDb from note in noteKeyValue.Value select note.StartBeat + note.LengthBeats + 1).Concat(new float[] {0}).Max();
        }
    }
}
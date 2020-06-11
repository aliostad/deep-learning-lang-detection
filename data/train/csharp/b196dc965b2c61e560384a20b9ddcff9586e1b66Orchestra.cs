using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.Devices.Midi;
using Windows.Storage.Streams;

namespace IoPokeMikuClient.Model
{
    public class Orchestra : MidiPlayer
    {
        List<Instrument> channels = new List<Instrument>();

        public Orchestra(string deviceName, IMidiOutPort port) : base(deviceName, port)
        {
            const byte kMikuVelocity = 0;
            const byte kInstVelocity = 127;
            // element num less than 16
            channels = new List<Instrument>{
                /*
                new Instrument( 0, 12, 0),// Hatsune Miku
                //new Instrument( 33, -12, 127),// Accoustic Bass
                //new Instrument( 43, -12, 127),//Cello
                new Instrument( 44, -24, 127),// Contrabass
                //new Instrument( 58, -12, 127),// trombone
                new Instrument( 58, -24, 127),// tuba
                //new Instrument( 61, -12, 127),// horn
                //new Instrument( 71, -24, 127),// basoon
                new Instrument( 49, 0, 127),// String Ensemble1
                //new Instrument( 50, 0, 127),// String Ensemble 2
                //new Instrument( 56, 0, 127),// ochestra all
                //new Instrument( 57, 0, 127),// trumpet
                new Instrument( 62, 0, 127),// brass section
                //new Instrument( 69, 0, 127),// Oboe
                //new Instrument( 70, 0, 127),// english horn
                //new Instrument( 72, 0, 127),// clarinet
                new Instrument( 55, 12, 127),// voice ooh
                //new Instrument( 41, 12, 127),// Violin
                //new Instrument( 42, 12, 127),// Viola
                new Instrument( 73, 12, 127),// piccolo
                //new Instrument( 74, 12, 127),// flute*/
                new Instrument( 0, 12, kMikuVelocity),// Hatsune Miku, C
                new Instrument( 44, -29, kInstVelocity),// Contrabass, G
                new Instrument( 44, -24, kInstVelocity),// Contrabass, C
                new Instrument( 44, -20, kInstVelocity),// Contrabass, E
                new Instrument( 58, -29, kInstVelocity),// tuba, G
                new Instrument( 58, -24, kInstVelocity),// tuba, C
                new Instrument( 58, -20, kInstVelocity),// tuba, E
                new Instrument( 49, -5, kInstVelocity),// String Ensemble1, G
                new Instrument( 49, 0, kInstVelocity),// String Ensemble1, C
                new Percussion( 0, 49, kInstVelocity),// symbal
                new Instrument( 62, 0, kInstVelocity),// brass section, C
                new Instrument( 62, 4, kInstVelocity),// brass section, E
                new Instrument( 69, 7, kInstVelocity),// Oboe, G
                new Instrument( 74, 12, kInstVelocity),// flute, C
                new Instrument( 73, 16, kInstVelocity),// piccolo, E
            };
        }

        public override void SetupProgram()
        {
            byte counter = 0;
            foreach (var inst in channels)
            {
                var msg = new MidiProgramChangeMessage(Convert.ToByte(counter), Convert.ToByte(inst.InstNum));
                m_port.SendMessage(msg);
                counter++;
            }
        }

        public override void NoteOn(Byte note)
        {
            Byte counter = 0;
            lock (m_lock)
            {
                NoteOff();
                foreach (var ch in channels)
                {
                    base.NoteOn(counter, ch.GetNote(note), ch.Velocity);
                    counter++;
                }
            }
        }
    }
}

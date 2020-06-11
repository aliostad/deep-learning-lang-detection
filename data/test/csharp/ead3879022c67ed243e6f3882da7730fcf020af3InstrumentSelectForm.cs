using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace MidiEditorPlayerCs
{
    public partial class InstrumentSelectForm : Form
    {
        #region Declarations
        DialogResult ButtonResult = DialogResult.Cancel;
        Boolean TypeSelected = true;
        Boolean InstrumentSelected = true;
        byte ChosenInstrument = 0x00;
        #endregion

        #region Constructor
        public InstrumentSelectForm(String FormText)
        {
            InitializeComponent();
            this.Text = FormText;
        }
        #endregion

        #region Events
        //Update Instrument Combobox when user selects Instrument Type
        private void TypeComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (TypeComboBox.SelectedIndex)
            {
                    //http://stackoverflow.com/questions/5983753/adding-multiple-items-to-a-combo-box-using-addrange
                case -1:
                    InstrumentComboBox.Items.Clear();
                    break;
                case 0:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Acoustic Grand Piano",
                    "Bright Acoustic Piano",
                    "Electric Grand Piano",
                    "Honky-tonk Piano",
                    "Electric Piano",
                    "Electric Piano 2",
                    "Harpsichord",
                    "Clavinet"});
                    break;
                case 1:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Celesta",
                    "Glockenspiel",
                    "Music Box",
                    "Vibraphone",
                    "Marimba",
                    "Xylophone",
                    "Tubular Bells",
                    "Dulcimer"});
                    break;
                case 2:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Drawbar Organ",
                    "Percussive Organ",
                    "Rock Organ",
                    "Church Organ",
                    "Reed Organ",
                    "Accordion",
                    "Harmonica",
                    "Tango Accordion"});
                    break;
                case 3:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Acoustic Guitar (nylon)",
                    "Acoustic Guitar (steel)",
                    "Electric Guitar (jazz)",
                    "Electric Guitar (clean)",
                    "Electric Guitar (muted)",
                    "Overdriven Guitar",
                    "Distortion Guitar",
                    "Guitar harmonics"});
                    break;
                case 4:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Acoustic Bass",
                    "Electric Bass (finger)",
                    "Electric Bass (pick)",
                    "Fretless Bass",
                    "Slap Bass 1",
                    "Slap Bass 2",
                    "Synth Bass 1",
                    "Synth Bass 2"});
                    break;
                case 5:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Violin",
                    "Viola",
                    "Cello",
                    "Contrabass",
                    "Tremolo Strings",
                    "Pizzicato Strings",
                    "Orchestral Harp",
                    "Timpani"});
                    break;
                case 6:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "String Ensemble 1",
                    "String Ensemble 2",
                    "Synth Strings 1",
                    "Synth Strings 2",
                    "Choir Aahs",
                    "Voice Oohs",
                    "Synth Voice",
                    "Orchestra Hit"});
                    break;
                case 7:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Trumpet",
                    "Trombone",
                    "Tuba",
                    "Muted Trumpet",
                    "French Horn",
                    "Brass Section",
                    "Synth Brass 1",
                    "Synth Brass 2 "});
                    break;
                case 8: //Reed
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Soprano Sax",
                    "Alto Sax",
                    "Tenor Sax",
                    "Baritone Sax",
                    "Oboe",
                    "English Horn",
                    "Bassoon",
                    "Clarinet"});
                    break;
                case 9: //Pipe
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Piccolo",
                    "Flute",
                    "Recorder",
                    "Pan Flute",
                    "Blown Bottle",
                    "Shakuhachi",
                    "Whistle",
                    "Ocarina"});
                    break;
                case 10: //synth lead
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Lead 1 (square)",
                    "Lead 2 (sawtooth)",
                    "Lead 3 (calliope)",
                    "Lead 4 (chiff)",
                    "Lead 5 (charang)",
                    "Lead 6 (voice)",
                    "Lead 7 (fifths)",
                    "Lead 8 (bass + lead)"});
                    break;
                case 11: //Synth Pad:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Pad 1 (new age)",
                    "Pad 2 (warm)",
                    "Pad 3 (polysynth)",
                    "Pad 4 (choir)",
                    "Pad 5 (bowed)",
                    "Pad 6 (metallic)",
                    "Pad 7 (halo)",
                    "Pad 8 (sweep)"});
                    break;
                case 12: //Synth FX:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "FX 1 (rain)",
                    "FX 2 (soundtrack)",
                    "FX 3 (crystal)",
                    "FX 4 (atmosphere)",
                    "FX 5 (brightness)",
                    "FX 6 (goblins)",
                    "FX 7 (echoes)",
                    "FX 8 (sci-fi))"});
                    break;
                case 13: //Ethinc:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Sitar",
                    "Banjo",
                    "Shamisen",
                    "Koto",
                    "Kalimba",
                    "Bag pipe",
                    "Fiddle",
                    "Shanai"});
                    break;
                case 14: //Percussive:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Tinkle Bell",
                    "Agogo",
                    "Steel Drums",
                    "Woodblock",
                    "Taiko Drum",
                    "Melodic Tom",
                    "Synth Drum"});
                    break;
                case 15: //SoundEffects:
                    InstrumentComboBox.Items.Clear();
                    InstrumentComboBox.Items.AddRange(new String[]{
                    "Reverse Cymbal",                    
                    "Guitar Fret Noise",
                    "Breath Noise",
                    "Seashore",
                    "Bird Tweet",
                    "Telephone Ring",
                    "Helicopter",
                    "Applause",
                    "Gunshot"});
                    break;
                default:
                    break;
            }
        }

        //Determine Selected Instrument
        //http://soundprogramming.net/file_formats/general_midi_instrument_list

        private void OKButton_Click(object sender, EventArgs e)
        {
            TypeSelected = true;
            InstrumentSelected = true;
            ChosenInstrument = 0;
            switch (TypeComboBox.SelectedIndex)
            {
                case -1:
                    TypeSelected = false;
                    break;
                case 0:
                    ChosenInstrument = 1;
                    break;
                case 1:
                    ChosenInstrument = 9;
                    break;
                case 2:
                    ChosenInstrument = 17;
                    break;
                case 3:
                    ChosenInstrument = 25;
                    break;
                case 4:
                    ChosenInstrument = 33;
                    break;
                case 5:
                    ChosenInstrument = 41;
                    break;
                case 6:
                    ChosenInstrument = 49;
                    break;
                case 7:
                    ChosenInstrument = 57;
                    break;
                case 8:
                    ChosenInstrument = 65;
                    break;
                case 9:
                    ChosenInstrument = 73;
                    break;
                case 10:
                    ChosenInstrument = 81;
                    break;
                case 11:
                    ChosenInstrument = 89;
                    break;
                case 12:
                    ChosenInstrument = 97;
                    break;
                case 13:
                    ChosenInstrument = 105;
                    break;
                case 14:
                    ChosenInstrument = 113;
                    break;
                case 15:
                    ChosenInstrument = 120;
                    break;
                default:
                    break;
            }
            switch (InstrumentComboBox.SelectedIndex)
            {
                case -1:
                    InstrumentSelected = false;
                    break;
                case 1:
                    ChosenInstrument += 1;
                    break;
                case 2:
                    ChosenInstrument += 2;
                    break;
                case 3:
                    ChosenInstrument += 3;
                    break;
                case 4:
                    ChosenInstrument += 4;
                    break;
                case 5:
                    ChosenInstrument += 5;
                    break;
                case 6:
                    ChosenInstrument += 6;
                    break;
                case 7:
                    ChosenInstrument += 7;
                    break;
                case 8:
                    ChosenInstrument += 8;
                    break;
                case 9:
                    ChosenInstrument += 9;
                    break;
                case 10:
                    ChosenInstrument += 10;
                    break;
                default:
                    break;
            }
            if (TypeSelected == true && InstrumentSelected == true)
            {
                ButtonResult = DialogResult.OK;
                ChosenInstrument -= 1;
                this.Close();
            }
            else
            {
                MessageBox.Show("Please Select Type & Instrument");
            }
        }

        //Cancel Click
        private void CancelClickButton_Click(object sender, EventArgs e)
        {
            ButtonResult = DialogResult.Cancel;
            ChosenInstrument = 0;
            this.Close();
        }
        #endregion

        #region Accessors
        public DialogResult ButtonClicked
        {
            get { return ButtonResult; }
            set { ButtonResult = value; }
        }
        public Byte Instrument
        {
            get { return ChosenInstrument; }
            set { ChosenInstrument = value; }
        }
        #endregion
    }
}

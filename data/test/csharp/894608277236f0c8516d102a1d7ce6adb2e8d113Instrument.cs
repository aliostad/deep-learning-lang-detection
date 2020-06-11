using System.Collections.Generic;
using System.Linq;
using Moworks.Common;

namespace Moworks.Music.Domain.Compigram
{
    public class Instrument : Enumeration<string>
    {
        #region Static Helper Members

        private static readonly IDictionary<string, Instrument> Items;
        private static readonly object Sync = new object();

        public static IEnumerable<Instrument> GetAll()
        {
            yield return Accordion; //Accordion
            yield return AcousticGuitar; //Acoustic Guitar
            yield return Bagpipes; //Bagpipes                                          
            yield return Banjo; //Banjo                                             
            yield return BassAcid; //Bass (Acid)                                       
            yield return BassElectric; //Bass (Electric)                          
            yield return BassFretless; //Bass (Fretless)                                   
            yield return BassSynth; //Bass (Synth)                                      
            yield return BassUpright; //Bass (Upright)                                    
            yield return BassWompy; //Bass (Wompy)                                      
            yield return BassGuitar; //Bass Guitar
            yield return Bassoon; //Bassoon                                           
            yield return Bells; //Bells                                             
            yield return Bohdran; //Bohdran                                           
            yield return Bongos; //Bongos                                            
            yield return Brass; //Brass                                             
            yield return Bugle; //Bugle                                             
            yield return Castanets; //Castanets                                         
            yield return Cello; //Cello
            yield return ChapmanStick; //Chapman Stick                                     
            yield return Chimes; //Chimes                                            
            yield return ChoirVocals; //Choir Vocals                                      
            yield return Cittern; //Cittern                                           
            yield return Clapping; //Clapping                                          
            yield return Clarinet; //Clarinet                                          
            yield return ClassicalGuitar; //Classical Guitar
            yield return Clave; //Clave                                             
            yield return Conga; //Conga                                             
            yield return Cornet; //Cornet
            yield return Cymbals; //Cymbals                                           
            yield return Didgereedoo; //Didgereedoo                                       
            yield return Drums; //Drums
            yield return DrumsElectronic; //Drums (Electronic)                                
            yield return DrumsGlitch; //Drums (Glitch)                                    
            yield return DrumsIndustrial; //Drums (Industrial)                                
            yield return DrumsLive; //Drums (Live)                                      
            yield return DrumsOrganic; //Drums (Organic)                                   
            yield return ElectricGuitar; //Electric Guitar
            yield return Fiddle; //Fiddle                                            
            yield return FilterSweep; //Filter Sweep                                      
            yield return Flute; //Flute                                             
            yield return FrenchHorn; //French Horn                                       
            yield return Glokenspiel; //Glokenspiel                                       
            yield return Gong; //Gong                                              
            yield return GuitarAcoustic; //Guitar (Acoustic)                                 
            yield return GuitarElectric; //Guitar (Electric)                                 
            yield return GuitarPedalSteel; //Guitar (Pedal Steel)                              
            yield return Harmonica; //Harmonica                                         
            yield return Harp; //Harp                                              
            yield return Harpsicord; //Harpsicord                                        
            yield return Horn; //Horn
            yield return HornSection; //Horn Section                                      
            yield return HornsMiddleEastern; //Horns (Middle Eastern)                            
            yield return Keyboards; //Keyboards                                         
            yield return LaserZap; //Laser Zap!                                        
            yield return Mandolin; //Mandolin                                          
            yield return Maracas; //Maracas                                           
            yield return Organ; //Organ                                             
            yield return OrganJazz; //Organ (Jazz)                                      
            yield return Other; //Other
            yield return PanFlute; //Pan Flute
            yield return Percussion; //Percussion                                        
            yield return PercussionMiddleEastern; //Percussion (Middle Eastern)                       
            yield return Piano; //Piano                                             
            yield return PianoRhodes; //Piano (Rhodes)                                    
            yield return PianoSynth; //Piano (Synth)                                     
            yield return Piccolo; //Piccolo
            yield return Robospeak; //Robospeak                                         
            yield return Saxophone; //Saxophone                                         
            yield return Scratchin; //Scratchin                                         
            yield return Sitar; //Sitar                                             
            yield return SoundEffectsComputerNoise; //Sound Effects (Computer Noise)                    
            yield return SoundEffectsElectronicNoise; //Sound Effects (Electronic Noise)                  
            yield return SoundEffectsGlitch; //Sound Effects (Glitch)                            
            yield return SoundEffectsNature; //Sound Effects (Nature)                            
            yield return SoundEffectsOther; //Sound Effects (Other)                             
            yield return SoundEffectsSpacey; //Sound Effects (Spacey)                            
            yield return SoundEffectsUrban; //Sound Effects (Urban)                             
            yield return SoundEffectsVideoGame; //Sound Effects (Video Game)                        
            yield return SteelDrum; //Steel Drum                                        
            yield return Strings; //Strings                                           
            yield return StringsBowed; //Strings (Bowed)                                   
            yield return StringsPlucked; //Strings (Plucked)                                 
            yield return Synthesizer; //Synthesizer
            yield return SynthesizerAcid; //Synthesizer (Acid)                                
            yield return SynthesizersAngel; //Synthesizers (Angel)                              
            yield return SynthesizersArpeggiated; //Synthesizers (Arpeggiated)                        
            yield return SynthesizersDistortion; //Synthesizers (Distortion)                         
            yield return SynthesizersPad; //Synthesizers (Pad)                                
            yield return SynthesizersPortamento; //Synthesizers (Portamento)                         
            yield return SynthesizersVoxChoir; //Synthesizers (Vox/Choir)                          
            yield return Tabla; //Tabla                                             
            yield return Tambourine; //Tambourine                                        
            yield return Timpani; //Timpani                                           
            yield return Triangle; //Triangle                                          
            yield return Trombone; //Trombone                                          
            yield return Trumpet; //Trumpet                                           
            yield return Tuba; //Tuba
            yield return Turntables; //Turntables                                        
            yield return Ukulele; //Ukulele
            yield return Vibraphone; //Vibraphone                                        
            yield return Violin; //Violin
            yield return Vocoder; //Vocoder                                           
            yield return Voice; //Voice                                             
            yield return Whistle; //Whistle                                           
            yield return Xylophone; //Xylophone                                         

        }

        public static Instrument GetByValue(string value)
        {
            if (!Items.ContainsKey(value))
            {
                throw new KeyNotFoundException($"Key value '{value}' was not found.");
            }

            return Items[value];
        }

        static Instrument()
        {
            lock (Sync)
            {
                Items = GetAll().ToDictionary(k => k.Value);
            }
        }

        #endregion

        #region Well known types as static properties

        public static readonly Instrument Accordion = new Instrument("Accordion", "Accordion");
        public static readonly Instrument AcousticGuitar = new Instrument("AcousticGuitar", "Acoustic Guitar");
        public static readonly Instrument Bagpipes = new Instrument("Bagpipes", "Bagpipes");
        public static readonly Instrument Banjo = new Instrument("Banjo", "Banjo");
        public static readonly Instrument BassAcid = new Instrument("BassAcid", "Bass (Acid)");
        public static readonly Instrument BassElectric = new Instrument("BassElectric", "Bass (Electric)");
        public static readonly Instrument BassFretless = new Instrument("BassFretless", "Bass (Fretless)");
        public static readonly Instrument BassSynth = new Instrument("BassSynth", "Bass (Synth)");
        public static readonly Instrument BassUpright = new Instrument("BassUpright", "Bass (Upright)");
        public static readonly Instrument BassWompy = new Instrument("BassWompy", "Bass (Wompy)");
        public static readonly Instrument BassGuitar = new Instrument("BassGuitar", "Bass Guitar");
        public static readonly Instrument Bassoon = new Instrument("Bassoon", "Bassoon");
        public static readonly Instrument Bells = new Instrument("Bells", "Bells");
        public static readonly Instrument Bohdran = new Instrument("Bohdran", "Bohdran");
        public static readonly Instrument Bongos = new Instrument("Bongos", "Bongos");
        public static readonly Instrument Brass = new Instrument("Brass", "Brass");
        public static readonly Instrument Bugle = new Instrument("Bugle", "Bugle");
        public static readonly Instrument Castanets = new Instrument("Castanets", "Castanets");
        public static readonly Instrument Cello = new Instrument("Cello", "Cello");
        public static readonly Instrument ChapmanStick = new Instrument("ChapmanStick", "Chapman Stick");
        public static readonly Instrument Chimes = new Instrument("Chimes", "Chimes");
        public static readonly Instrument ChoirVocals = new Instrument("ChoirVocals", "Choir Vocals");
        public static readonly Instrument Cittern = new Instrument("Cittern", "Cittern");
        public static readonly Instrument Clapping = new Instrument("Clapping", "Clapping");
        public static readonly Instrument Clarinet = new Instrument("Clarinet", "Clarinet");
        public static readonly Instrument ClassicalGuitar = new Instrument("ClassicalGuitar", "Classical Guitar");
        public static readonly Instrument Clave = new Instrument("Clave", "Clave");
        public static readonly Instrument Conga = new Instrument("Conga", "Conga");
        public static readonly Instrument Cornet = new Instrument("Cornet", "Cornet");
        public static readonly Instrument Cymbals = new Instrument("Cymbals", "Cymbals");
        public static readonly Instrument Didgereedoo = new Instrument("Didgereedoo", "Didgereedoo");
        public static readonly Instrument Drums = new Instrument("Drums", "Drums");
        public static readonly Instrument DrumsElectronic = new Instrument("DrumsElectronic", "Drums (Electronic)");
        public static readonly Instrument DrumsGlitch = new Instrument("DrumsGlitch", "Drums (Glitch)");
        public static readonly Instrument DrumsIndustrial = new Instrument("DrumsIndustrial", "Drums (Industrial)");
        public static readonly Instrument DrumsLive = new Instrument("DrumsLive", "Drums (Live)");
        public static readonly Instrument DrumsOrganic = new Instrument("DrumsOrganic", "Drums (Organic)");
        public static readonly Instrument ElectricGuitar = new Instrument("ElectricGuitar", "Electric Guitar");
        public static readonly Instrument Fiddle = new Instrument("Fiddle", "Fiddle");
        public static readonly Instrument FilterSweep = new Instrument("FilterSweep", "Filter Sweep");
        public static readonly Instrument Flute = new Instrument("Flute", "Flute");
        public static readonly Instrument FrenchHorn = new Instrument("FrenchHorn", "French Horn");
        public static readonly Instrument Glokenspiel = new Instrument("Glokenspiel", "Glokenspiel");
        public static readonly Instrument Gong = new Instrument("Gong", "Gong");
        public static readonly Instrument GuitarAcoustic = new Instrument("GuitarAcoustic", "Guitar (Acoustic)");
        public static readonly Instrument GuitarElectric = new Instrument("GuitarElectric", "Guitar (Electric)");
        public static readonly Instrument GuitarPedalSteel = new Instrument("GuitarPedalSteel", "Guitar (Pedal Steel)");
        public static readonly Instrument Harmonica = new Instrument("Harmonica", "Harmonica");
        public static readonly Instrument Harp = new Instrument("Harp", "Harp");
        public static readonly Instrument Harpsicord = new Instrument("Harpsicord", "Harpsicord");
        public static readonly Instrument Horn = new Instrument("Horn", "Horn");
        public static readonly Instrument HornSection = new Instrument("HornSection", "Horn Section");
        public static readonly Instrument HornsMiddleEastern = new Instrument("HornsMiddleEastern", "Horns (Middle Eastern)");
        public static readonly Instrument Keyboards = new Instrument("Keyboards", "Keyboards");
        public static readonly Instrument LaserZap = new Instrument("LaserZap", "Laser Zap!");
        public static readonly Instrument Mandolin = new Instrument("Mandolin", "Mandolin");
        public static readonly Instrument Maracas = new Instrument("Maracas", "Maracas");
        public static readonly Instrument Organ = new Instrument("Organ", "Organ");
        public static readonly Instrument OrganJazz = new Instrument("OrganJazz", "Organ (Jazz)");
        public static readonly Instrument Other = new Instrument("Other", "Other");
        public static readonly Instrument PanFlute = new Instrument("PanFlute", "Pan Flute");
        public static readonly Instrument Percussion = new Instrument("Percussion", "Percussion");
        public static readonly Instrument PercussionMiddleEastern = new Instrument("PercussionMiddleEastern", "Percussion (Middle Eastern)");
        public static readonly Instrument Piano = new Instrument("Piano", "Piano");
        public static readonly Instrument PianoRhodes = new Instrument("PianoRhodes", "Piano (Rhodes)");
        public static readonly Instrument PianoSynth = new Instrument("PianoSynth", "Piano (Synth)");
        public static readonly Instrument Piccolo = new Instrument("Piccolo", "Piccolo");
        public static readonly Instrument Robospeak = new Instrument("Robospeak", "Robospeak");
        public static readonly Instrument Saxophone = new Instrument("Saxophone", "Saxophone");
        public static readonly Instrument Scratchin = new Instrument("Scratchin", "Scratchin");
        public static readonly Instrument Sitar = new Instrument("Sitar", "Sitar");
        public static readonly Instrument SoundEffectsComputerNoise = new Instrument("SoundEffectsComputerNoise", "Sound Effects (Computer Noise)");
        public static readonly Instrument SoundEffectsElectronicNoise = new Instrument("SoundEffectsElectronicNoise", "Sound Effects (Electronic Noise)");
        public static readonly Instrument SoundEffectsGlitch = new Instrument("SoundEffectsGlitch", "Sound Effects (Glitch)");
        public static readonly Instrument SoundEffectsNature = new Instrument("SoundEffectsNature", "Sound Effects (Nature)");
        public static readonly Instrument SoundEffectsOther = new Instrument("SoundEffectsOther", "Sound Effects (Other)");
        public static readonly Instrument SoundEffectsSpacey = new Instrument("SoundEffectsSpacey", "Sound Effects (Spacey)");
        public static readonly Instrument SoundEffectsUrban = new Instrument("SoundEffectsUrban", "Sound Effects (Urban)");
        public static readonly Instrument SoundEffectsVideoGame = new Instrument("SoundEffectsVideoGame", "Sound Effects (Video Game)");
        public static readonly Instrument SteelDrum = new Instrument("SteelDrum", "Steel Drum");
        public static readonly Instrument Strings = new Instrument("Strings", "Strings");
        public static readonly Instrument StringsBowed = new Instrument("StringsBowed", "Strings (Bowed)");
        public static readonly Instrument StringsPlucked = new Instrument("StringsPlucked", "Strings (Plucked)");
        public static readonly Instrument Synthesizer = new Instrument("Synthesizer", "Synthesizer");
        public static readonly Instrument SynthesizerAcid = new Instrument("SynthesizerAcid", "Synthesizer (Acid)");
        public static readonly Instrument SynthesizersAngel = new Instrument("SynthesizersAngel", "Synthesizers (Angel)");
        public static readonly Instrument SynthesizersArpeggiated = new Instrument("SynthesizersArpeggiated", "Synthesizers (Arpeggiated)");
        public static readonly Instrument SynthesizersDistortion = new Instrument("SynthesizersDistortion", "Synthesizers (Distortion)");
        public static readonly Instrument SynthesizersPad = new Instrument("SynthesizersPad", "Synthesizers (Pad)");
        public static readonly Instrument SynthesizersPortamento = new Instrument("SynthesizersPortamento", "Synthesizers (Portamento)");
        public static readonly Instrument SynthesizersVoxChoir = new Instrument("SynthesizersVoxChoir", "Synthesizers (Vox/Choir)");
        public static readonly Instrument Tabla = new Instrument("Tabla", "Tabla");
        public static readonly Instrument Tambourine = new Instrument("Tambourine", "Tambourine");
        public static readonly Instrument Timpani = new Instrument("Timpani", "Timpani");
        public static readonly Instrument Triangle = new Instrument("Triangle", "Triangle");
        public static readonly Instrument Trombone = new Instrument("Trombone", "Trombone");
        public static readonly Instrument Trumpet = new Instrument("Trumpet", "Trumpet");
        public static readonly Instrument Tuba = new Instrument("Tuba", "Tuba");
        public static readonly Instrument Turntables = new Instrument("Turntables", "Turntables");
        public static readonly Instrument Ukulele = new Instrument("Ukulele", "Ukulele");
        public static readonly Instrument Vibraphone = new Instrument("Vibraphone", "Vibraphone");
        public static readonly Instrument Violin = new Instrument("Violin", "Violin");
        public static readonly Instrument Vocoder = new Instrument("Vocoder", "Vocoder");
        public static readonly Instrument Voice = new Instrument("Voice", "Voice");
        public static readonly Instrument Whistle = new Instrument("Whistle", "Whistle");
        public static readonly Instrument Xylophone = new Instrument("Xylophone", "Xylophone");

        #endregion

        public Instrument(string value, string displayName) : base(value, displayName)
        {
        }
    }
}
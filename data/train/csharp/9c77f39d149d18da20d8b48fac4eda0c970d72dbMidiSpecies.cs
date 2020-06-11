////////////////////////////////////////////////////////////////////////
//                  Q - A B C   S O U N D   P L A Y E R
//
//                   Copyright (C) Pieter Geerkens 2012-2016
////////////////////////////////////////////////////////////////////////
using System;
using Midi;

namespace PGSoftwareSolutions.Music {
    internal class MidiSpecies : IInstrument {
        public IInstrumentGenus Genus      { get { return _genus;      } } readonly IInstrumentGenus _genus;
        public short            Index      { get { return _index;      } } readonly short _index;
        public Instrument       Instrument { get { return _instrument; } } readonly Instrument _instrument;
        public string           Name       { get { return _name;       } } readonly string _name;

        public MidiSpecies(IInstrumentGenus genus, short index) {
            _index      = index;
            _genus      = genus;
            _instrument = (Midi.Instrument)(_genus.Index * 8 + _index);
            _name = Enum.GetName(typeof(Midi.Instrument), _instrument); ;
        }
    }
}

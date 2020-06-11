using System.Collections.Generic;

namespace MultiAlign.ViewModels.Instruments
{
    public class InstrumentPresetFactory
    {
        public static IEnumerable<InstrumentPresetViewModel> Create()
        {
            var presets = new List<InstrumentPresetViewModel>
            {
                Create(InstrumentPresets.Tof),
                Create(InstrumentPresets.Velos),
                Create(InstrumentPresets.LtqOrbitrap)
            };

            return presets;
        }

        public static InstrumentPresetViewModel Create(InstrumentPresets preset)
        {
            InstrumentPresetViewModel model = null;
            switch (preset)
            {
                case InstrumentPresets.Tof:
                    model = new InstrumentPresetViewModel("TOF",
                        12,
                        .03,
                        50,
                        .5,
                        8);

                    break;
                case InstrumentPresets.Velos:
                    model = new InstrumentPresetViewModel("Velos",
                        6,
                        .03,
                        50,
                        .5,
                        8);
                    break;
                case InstrumentPresets.LtqOrbitrap:
                    model = new InstrumentPresetViewModel("LTQ Orbitrap",
                        13,
                        .03,
                        50,
                        .5,
                        8);
                    break;
            }

            return model;
        }
    }
}
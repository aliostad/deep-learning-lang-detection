/*
* Copyright (c) 2014 Universal Technical Resource Services, Inc.
* 
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

using ATMLDataAccessLibrary.model;
using ATMLModelLibrary.model.equipment;

namespace ATMLCommonLibrary.controls.instrument
{
    public partial class TestStationDescriptionInstrumentControl : ItemDescriptionReferenceControl
    {
        public TestStationDescriptionInstrumentControl()
        {
            InitializeComponent();
            DocumentType = dbDocument.DocumentType.INSTRUMENT_DESCRIPTION;
        }

        public TestStationDescriptionInstrument TestStationDescriptionInstrument
        {
            get
            {
                ControlsToData();
                return _itemDescriptionReference as TestStationDescriptionInstrument;
            }
            set
            {
                _itemDescriptionReference = value;
                DataToControls();
            }
        }

        private new void DataToControls()
        {
            if (_itemDescriptionReference != null)
            {
                var instrument =
                    _itemDescriptionReference as TestStationDescriptionInstrument;
                base.DataToControls();
                if (instrument != null)
                {
                    edtAddress.Value = instrument.Address;
                    edtId.Value = instrument.ID;
                    edtPhysicalLocation.Value = instrument.PhysicalLocation;
                }
            }
        }

        private new void ControlsToData()
        {
            if (_itemDescriptionReference == null)
                _itemDescriptionReference = new TestStationDescriptionInstrument();
            base.ControlsToData();
            var instrument =
                _itemDescriptionReference as TestStationDescriptionInstrument;
            if (instrument != null)
            {
                instrument.Address = edtAddress.GetValue<string>();
                instrument.ID = edtId.GetValue<string>();
                instrument.PhysicalLocation = edtPhysicalLocation.GetValue<string>();
            }
        }

        public void AddSelectedDocumentId(string uuid)
        {
            documentReferenceControl.AddSelectedDocumentId(uuid);
        }

    }
}
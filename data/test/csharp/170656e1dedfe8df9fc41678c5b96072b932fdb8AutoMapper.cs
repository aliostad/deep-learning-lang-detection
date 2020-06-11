using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Assignment4
{
    public class AutoMapper
    {
        public static void RegisterMappings()
        {
            // Add map creation statements here
            // Mapper.CreateMap< FROM , TO >();

            // Disable AutoMapper v4.2.x warnings
#pragma warning disable CS0618

            // Attention 1 - AutoMapper create map statements (Regular mapping)
            Mapper.CreateMap<Models.Instrument, Controllers.InstrumentBase>();
            Mapper.CreateMap<Models.Instrument, Controllers.InstrumentWithPhotoMediaInfo>();
            Mapper.CreateMap<Models.Instrument, Controllers.InstrumentWithPhotoMedia>();

            Mapper.CreateMap<Models.Instrument, Controllers.InstrumentWithSoundClipMediaInfo>();
            Mapper.CreateMap<Models.Instrument, Controllers.InstrumentWithSoundClipMedia>();

            Mapper.CreateMap<Models.Instrument, Controllers.InstrumentWithPhotoAndSoundClipMediaInfo>();
            Mapper.CreateMap<Models.Instrument, Controllers.InstrumentWithPhotoAndSoundClipMedia>();

            Mapper.CreateMap<Controllers.InstrumentWithPhotoMedia, Controllers.InstrumentWithPhotoMediaInfo>();
            Mapper.CreateMap<Controllers.InstrumentWithSoundClipMedia, Controllers.InstrumentWithSoundClipMediaInfo>();
            Mapper.CreateMap<Controllers.InstrumentWithPhotoAndSoundClipMedia, Controllers.InstrumentWithPhotoAndSoundClipMediaInfo>();


            Mapper.CreateMap<Controllers.InstrumentAdd, Models.Instrument>();
        }
    }
}
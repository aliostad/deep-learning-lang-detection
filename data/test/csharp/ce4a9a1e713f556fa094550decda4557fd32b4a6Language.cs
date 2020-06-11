using JamendoApi.Util;
using System;
using System.Collections.Generic;
using System.Linq;

namespace JamendoApi.Common
{
    /// <summary>
    /// Lists the possible languages.
    /// </summary>
    public enum Language
    {
        [ApiName("en")]
        English,

        [ApiName("fr")]
        French,

        [ApiName("es")]
        Spanish,

        [ApiName("de")]
        German,

        [ApiName("pl")]
        Polish,

        [ApiName("it")]
        Italian,

        [ApiName("ru")]
        Russian,

        [ApiName("pt")]
        Portugese
    }
}
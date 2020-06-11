using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace BikeR.Web.Configuration
{
    public class AuthApiKeySection : ConfigurationSection
    {

        // Create a "font" element.
        [ConfigurationProperty("GoogleApi")]
        public GoogleApiKey GoogleApi
        {
            get
            {
                return (GoogleApiKey)this["GoogleApi"];
            }
            set
            { this["GoogleApi"] = value; }
        }


        [ConfigurationProperty("FacebookApi")]
        public FacebookApiKey FacebookApi
        {
            get
            {
                return (FacebookApiKey)this["FacebookApi"];
            }
            set
            { this["FacebookApi"] = value; }
        }


    }
}
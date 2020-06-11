using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace ProjetPhoneDaveMuret.DataAccess
{
    class DetailsInstrumentDataAccess
    {
        public DetailsInstrumentDataAccess()
        {    
                   
        }

        private int idInstrument;

        public int IdInstrument
        {
            get { return idInstrument; }
            set { idInstrument = value; }
        }

        public async Task getAsyncIdInstrument (String nomInstrumentSansEspaces)
        {
            var url = new Uri("http://webapiphone.azurewebsites.net/api/instruments/RetournerIdInstrument/?nomInstrument=" + nomInstrumentSansEspaces);

            HttpClient client = new HttpClient();
            var json = await client.GetStringAsync(url);
            List<int> idInstrumentListString = JsonConvert.DeserializeObject<List<int>>(json);

            idInstrument = idInstrumentListString[0];
        }

        public async Task<String> getAsyncDescription()
        {
            Uri url = new Uri("http://webapiphone.azurewebsites.net/api/instruments/RetournerDescriptionInstrument/?idInstrument=" + idInstrument);

            HttpClient  client = new HttpClient();
            var json = await client.GetStringAsync(url);
            List<String> descriptionInstrumentListString = JsonConvert.DeserializeObject<List<String>>(json);

            return descriptionInstrumentListString[0];
        }

        public async Task<String> getAsyncUrlPhoto()
        {
            Uri url = new Uri("http://webapiphone.azurewebsites.net/api/photos/RechercherPhotoInstrument/?idInstrument=" + idInstrument);

            HttpClient client = new HttpClient();
            var json = await client.GetStringAsync(url);
            List<String> urlPhotoInstrumentListString = JsonConvert.DeserializeObject<List<String>>(json);

            return urlPhotoInstrumentListString[0];
        }
    }
}

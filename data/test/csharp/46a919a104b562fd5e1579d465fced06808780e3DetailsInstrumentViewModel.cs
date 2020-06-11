using GalaSoft.MvvmLight;
using Newtonsoft.Json;
using ProjetPhoneDaveMuret.DataAccess;
using ProjetPhoneDaveMuret.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace ProjetPhoneDaveMuret.ViewModel
{
    class DetailsInstrumentViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private DetailsInstrumentDataAccess detailsInstrumentDA;

        public DetailsInstrumentViewModel()
        {
            detailsInstrumentDA = new DetailsInstrumentDataAccess();
        }

        public async Task getAsyncDetailInstrument()
        {
            String nomInstrumentSansEspaces = setNomInstrumentSansEspaces(NomInstrument);

            await detailsInstrumentDA.getAsyncIdInstrument(nomInstrumentSansEspaces);

            Description = await detailsInstrumentDA.getAsyncDescription();

            UrlPhoto = await detailsInstrumentDA.getAsyncUrlPhoto();
        }

        public String setNomInstrumentSansEspaces(String nom)
        {
            String nomCopie = "";

            for (int i = 0; i < nom.Length; i++)
            {
                if (nom.ElementAt(i) == ' ')
                {
                    nomCopie += '_';
                }
                else
                {
                    nomCopie += nom.ElementAt(i);
                }
            }

            return nomCopie;
        }

        private String nomInstrument;

        public String NomInstrument
        {
            get { return nomInstrument; }
            set { nomInstrument = value; }
        }

        private int idInstrument;

        public int IdInstrument
        {
            get { return idInstrument; }
            set { idInstrument = value; }
        }

        private String description;

        public String Description
        {
            get { return description; }
            set { description = value; }
        }

        private String urlPhoto;

        public String UrlPhoto
        {
            get { return urlPhoto; }
            set { urlPhoto = value; }
        }

        private String son;

        public String Son
        {
            get { return son; }
            set { son = value; }
        }

    }
}

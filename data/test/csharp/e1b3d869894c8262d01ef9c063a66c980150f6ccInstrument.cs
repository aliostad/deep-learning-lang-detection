using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProjetPhoneDaveMuret.Model
{
    class Instrument
    {
        private int idInstrument;

        public int IdInstrument
        {
            get { return idInstrument; }
            set { idInstrument = value; }
        }

        private Photo photoInstrument;

        public Photo PhotoInstrument
        {
            get { return photoInstrument; }
            set { photoInstrument = value; }
        }

        private String nom;

        public String Nom
        {
            get { return nom; }
            set
            { nom = value;}
        }

        private String description;

        public String Description
        {
            get { return description; }
            set { description = value; }
        }

        private String son;

        public String Son
        {
            get { return son; }
            set { son = value; }
        }

        private Categorie categorieInstrument;

        public Categorie CategorieInstrument
        {
            get { return categorieInstrument; }
            set { categorieInstrument = value; }
        }

        public Instrument (String nom,Photo photo, String description, String son)
        {
            this.nom = nom;
            this.photoInstrument = photo;
            this.description = description;
            this.son = son;
        }

        public Instrument(String nom)
        {
            this.nom = nom;
        }
    }
}

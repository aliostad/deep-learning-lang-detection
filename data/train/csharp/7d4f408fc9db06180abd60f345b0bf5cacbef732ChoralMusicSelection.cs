using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LendingLibrary_Library.MusicSelection
{
    public  class ChoralMusicSelection : MusicSelection
    {
        public String Voicing { get; private set; }
        public String Voicing_LowerCase { get; private set; }
        public String Accompaniment { get; private set; }
        public String Accompaniment_LowerCase { get; private set; }
        public Boolean IsSacred { get; private set; }

        private List<ChoralInstrumentPart> InstrumentParts;

        public ChoralMusicSelection(String id, String institution_Id, String title, Contributor composer, Boolean isSacred)
            : base(id, institution_Id, title, composer)
        {
            this.IsSacred = isSacred;
            this.InstrumentParts = new List<ChoralInstrumentPart>();
        }

        public ChoralMusicSelection(String institution_Id, String title, Contributor composer, Boolean isSacred)
            : base(institution_Id, title, composer)
        {
            this.IsSacred = isSacred;
            this.InstrumentParts = new List<ChoralInstrumentPart>();
        }

        public void setVoicing(String voicing){
            this.Voicing = String.IsNullOrWhiteSpace(voicing) == true ? "" : voicing.Trim();
            this.Voicing_LowerCase = String.IsNullOrWhiteSpace(voicing) == true ? "" : voicing.Trim().ToLower();
        }

        public void setAccompaniment(String accompaniment)
        {
            this.Accompaniment = String.IsNullOrWhiteSpace(accompaniment) == true ? "" : accompaniment.Trim();
            this.Accompaniment_LowerCase = String.IsNullOrWhiteSpace(accompaniment) == true ? "" : accompaniment.Trim().ToLower();
        }

        public void setIsSacred(Boolean isSacred)
        {
            this.IsSacred = isSacred;
        }

        public void addInstrumentPart(ChoralInstrumentPart instrumentPart)
        {
            if (instrumentPart == null)
            {
                throw new ArgumentNullException("In class ChoralMusicSelection, method AddInstrumentPart().  Argument cannot be null.");
            }
            if (this.InstrumentParts.Exists(i => i.InstrumentName == instrumentPart.InstrumentName))
            {
                return;
            }
            this.InstrumentParts.Add(instrumentPart);
        }

        public void removeInstrumentPart(ChoralInstrumentPart instrumentPart)
        {
            if (instrumentPart == null)
            {
                throw new ArgumentNullException("In class ChoralMusicSelection, method AddInstrumentPart().  Argument cannot be null.");
            }
            if (this.InstrumentParts.Exists(i => i.InstrumentName == instrumentPart.InstrumentName))
            {
                this.InstrumentParts.RemoveAt(this.InstrumentParts.FindIndex(i => i.InstrumentName == instrumentPart.InstrumentName));
            }
            else
            {
                throw new ArgumentException("In class ChoralMusicSelection, method removeInstrumentPart(). Unable to remove instrument part that does not exist in the list.");
            }
        }

        public void setInstrumentParts(List<ChoralInstrumentPart> instrumentParts)
        {
            if (instrumentParts == null)
            {
                throw new ArgumentNullException("In class ChoralMusicSelection, method setInstrumentParts().  Argument cannot be null.");
            }
            this.InstrumentParts = instrumentParts;
        }

        public List<ChoralInstrumentPart> getInstrumentParts()
        {
            return this.InstrumentParts;
        }
    }
}

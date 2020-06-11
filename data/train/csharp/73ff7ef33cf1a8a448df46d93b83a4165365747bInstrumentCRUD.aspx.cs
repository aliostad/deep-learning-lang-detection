using Repertoar.App_GlobalResourses;
using Repertoar.MODEL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Repertoar.Pages.RepertoarPages
{
    public partial class InstrumentCRUD : System.Web.UI.Page
    {
        #region Service-objekt
        private Service _service;
        private Service Service
        {
            get { return _service ?? (_service = new Service()); }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            //Om genomförd handling lyckades av klienten och meddelande finns så visas det
            SuccessMessageLiteral.Text = Page.GetTempData("SuccessMessage") as string;
            SuccessMessagePanel.Visible = !String.IsNullOrWhiteSpace(SuccessMessageLiteral.Text);
        }
        #region CREATE
        public void InstrumentFormView_InsertInstrument(Instrument instrument)
        {
            if (ModelState.IsValid)
            {
                try
                {

                    //*SPARAR DET NYA INSTRUMENTET  - ifall det är validerat och okej.
                    instrument.InstrumentID = Service.SaveInstrument(instrument);

                    //Sätter meddelande till klienten
                    Page.SetTempData("SuccessMessage", "Instrumentet: " + instrument.Namn + " har lagts till.");

                    //Laddar om sidan
                    Response.RedirectToRoute("CreateInstrument", false);
                    Context.ApplicationInstance.CompleteRequest();
                }

                catch (Exception ex)
                {
                    //sätter felmeddelande till klienten
                    ModelState.AddModelError(string.Empty, ex.Message);
                }
            }
        }
        #endregion
        #region UPDATE
        public void InstrumentListView_UpdateInstrument(Instrument Instrument)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var instrument = Service.GetInstrumentByID(Instrument.InstrumentID);
                    if (instrument == null)
                    {
                        // Hittade inte låten.
                        ModelState.AddModelError(String.Empty, String.Format("Instrumentet med id {0} hittades inte, så det gick tyvärr inte att uppdatera just nu.", Instrument.InstrumentID));
                        return;
                    }

                    if (TryUpdateModel(Instrument))
                    {
                        Service.SaveInstrument(Instrument); 
                    }

                    //Sätter meddelande till klienten
                    Page.SetTempData("SuccessMessage", Strings.Action_Instrument_Updated);

                    //Laddar om sidan
                    Response.RedirectToRoute("CreateInstrument", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                catch (Exception)
                {
                    ModelState.AddModelError(String.Empty, Strings.Song_Updating_Error);
                }
            }
        }
        #endregion
        #region DELETE
        public void InstrumentListView_DeleteInstrument(Instrument instrument)
        {
            try
            {   
                Service.DeleteInstrument(instrument);
                Page.SetTempData("SuccessMessage", Strings.Action_Instrument_Deleted);
               
                //Laddar om sidan
                Response.RedirectToRoute("CreateInstrument", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception)
            {
                ModelState.AddModelError(String.Empty, Strings.Instrument_Deleting_Error);
            }
        }
        #endregion
        public IEnumerable<Instrument> InstrumentListView_GetData()
        {
            return Service.GetInstruments();
        }
    }     
}
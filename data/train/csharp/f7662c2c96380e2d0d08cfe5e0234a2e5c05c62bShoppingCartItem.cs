
namespace GuitarStore.Models
{
    public class ShoppingCartItem
    {
        #region Data
        public string ItemId { get; set; }
        public int Quantity { get; set; }
        public int InstrumentId { get; set; }
        public virtual Instrument Instrument { get; set; }
        #endregion

        #region ToStringForWebPage
        public string ToStringForWebPage()
        {
            return "Item ID: " + Instrument.InstrumentId + "<br />" +
                   "Brand: " + Instrument.Brand + "<br />" +
                   "Instrument name: " + Instrument.InstrumentModel + "<br />" +
                   "Price: " + Instrument.Price + "$" + "<br />" +
                   "Quantity: " + Quantity + "<br />" +
                   "Total: " + Instrument.Price * Quantity + "$";
        }
        #endregion

        #region ToStringForEmail
        public string ToStringForEmail()
        {
            return "Item ID: " + Instrument.InstrumentId +
               "\nBrand: " + Instrument.Brand +
               "\nInstrument name: " + Instrument.InstrumentModel +
               "\nPrice: " + Instrument.Price + "$" +
               "\nQuantity: " + Quantity +
               "\nTotal: " + Instrument.Price * Quantity + "$";
        }
        #endregion
    }
}
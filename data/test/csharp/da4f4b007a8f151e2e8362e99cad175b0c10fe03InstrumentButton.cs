using demoBand.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

namespace demoBand.Gui.Dialog
{
    public class InstrumentButton : Button
    {
        private string instrument;
        public InstrumentButton(string instrument)
        {
            this.instrument = instrument;
            Content = instrument;
            ((global::Windows.UI.Xaml.Controls.Primitives.ButtonBase)(this)).Click += this.onClick;
        }

        private void onClick(object o, RoutedEventArgs e)
        {
        
            Session.GetInstance().insertValue("instrument",instrument);
            if (NavigateEvent != null)
                NavigateEvent();
            NavigateEvent = null;
        
        }

        public static event demoBand.Gui.HomePage.emptyDelegate NavigateEvent; 
    }


}

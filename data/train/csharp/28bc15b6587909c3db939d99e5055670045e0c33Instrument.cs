using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestApp {
    class Instrument {
        public String instrument_Code { get; set; }
        public String instrument_Voice_code { get; set; }
        public float instrument_High_Value { get; set; }
        public float instrument_Low_Value { get; set; }
        public bool flag { get; set; }
        public string instrument_Curr_Value { get; set; }


        public Instrument() {
        }

        public Instrument(String instrument_Code, String instrument_Voice_code,
            float instrument_High_Value, float instrument_Low_Value, bool flag) {

                this.instrument_Code = instrument_Code;
                this.instrument_Voice_code = instrument_Voice_code;
                this.instrument_High_Value = instrument_High_Value;
                this.instrument_Low_Value = instrument_Low_Value;
                this.flag = flag;
                this.instrument_Curr_Value = null;
            }
        }
    
}

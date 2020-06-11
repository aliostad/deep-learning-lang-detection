using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScenarioScriptBuilder
{
    public class TestProcessFactory
    {
        public TestProcessFactory()
        {

        }

        public GeneralGBMProcess generalGBMProcess()
        {
            GeneralGBMProcess process = new GeneralGBMProcess();

            process.Name_ = "";

            process.X0_ = "";
            process.Mue_Curve_Value_ = "";
            process.Mue_Curve_Tenor_ = "";
            process.Mue_Curve_Interpolation_ = "";

            process.Dividend_ = "";
            process.Sigma_ = "";

            process.Shock_ = "";
            process.Addtional_Calculation_ = "";

            return process;
        }

        public GeneralHullWhiteProcess generalHullWhiteProcess()
        {
            GeneralHullWhiteProcess process = new GeneralHullWhiteProcess();

            process.Name_ = "";

            process.Fitting_Curve_Value_ = "";
            process.Fitting_Curve_Tenor_ = "";
            process.Fitting_Curve_Interpolation_ = "";
            process.Alpha_ = "";
            process.Sigma_ = "";

            process.Shock_ = "";
            process.Addtional_Calculation_ = "";

            process.Calibration_Flag_ = "";
            process.Calibration_Tool_ = "";
            process.Alpha_Calibration_Flag_ = "";
            process.Sigma_Calibration_Flag_ = "";

            return process;
        }

    }
}

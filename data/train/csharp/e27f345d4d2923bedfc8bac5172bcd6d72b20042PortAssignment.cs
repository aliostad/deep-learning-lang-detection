using System;

namespace SipperFile
{
	/// <summary>
	/// Summary description for PortAssignment.
	/// </summary>
	public class PortAssignment
	{
    private  Instrument  instrument;
    private  String      desc;
    public   const int   MaxNumOfPorts = 6;



    public  PortAssignment (Instrument _instrument,
                            string     _desc
                           )
    {
      instrument = _instrument;
      desc       = _desc;
    }



    public  PortAssignment (string  instrumentStr,
                            string  _desc
                           )
    {
      if  (instrumentStr.ToLower () == "none")
      {
        instrument = null;
        desc = "";
        return;
      }

      if  (instrumentStr == "")
      {
        instrument = SipperFile.Instrument.OtherInstrument ();
        desc = instrument.Description ();
      }

      instrument = SipperFile.Instrument.LookUpByShortName(instrumentStr);
      if  (instrument == null)
      {
        instrument = SipperFile.Instrument.OtherInstrument();
        desc = instrument.Description ();
      }

      else
      {
        desc = instrument.Description ();
        if  (instrument.ShortName ().ToLower () == "other")
        {
          if  (_desc != "")
            desc = _desc;
        }
      }
    }




    public string  HeaderStr ()
    {
      string  s;
      s = instrument.ShortName ();
      if  (instrument.ShortName ().ToLower () == "other")
        s += "," + desc;
      return  s;
    }  /* HeaderStr */




    public Instrument Instrument ()  {return instrument;}
    public string     ShortName  ()  {return instrument.ShortName ();}
    public string     Desc       ()  {return desc;}

  }  /* PortAssignment */
}

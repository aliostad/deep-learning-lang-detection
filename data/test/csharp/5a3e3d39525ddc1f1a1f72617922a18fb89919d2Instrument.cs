using System;
using System.Collections;


namespace SipperFile
{
  /// <summary>
  /// Summary description for Instrument.
  /// </summary>
  public class Instrument
  {
    public Instrument (string  _shortName,
                       string  _description
                      )
    {
      shortName   = _shortName;
      description = _description;
    }

    public  string  ShortName   () {return shortName;}
    public  string  Description () {return description;}


    virtual  public  InstrumentDataReport  CreateInstrumentDataReport (InstrumentDataManager manager,
                                                                       byte                  deviceId
                                                                      )
    {
      InstrumentDataReport dr = null;

      switch (deviceId)
      {
        case  6: dr = new InstrumentDataReportText (manager, deviceId);
                 break;

        case  7: dr = new InstrumentDataReportIllumination (manager, deviceId);
                 break;
                
        case  8: dr = new InstrumentDataReportCTD (manager, deviceId, InstrumentDataReportCTD.OutPutFormat.EngineeringUnitsInDec);
                 break;

        case  9: dr = new InstrumentDataReportGPS (manager, deviceId);
                 break;

        case 10: dr = new InstrumentDataReportFlowMeter (manager, deviceId);
                 break;
                

        default: dr = new InstrumentDataReport (manager, deviceId);
                 break;
      }
    
      return dr;
    }  /* CreateInstrumentDataReport */



    
    private static  void  BuildInstrumentList ()
    {
      instruments = new Instrument[] {new InstrumentCTD (), 
                                      new InstrumentGPS (),
                                      new InstrumentInclinationMeter (),
                                      new InstrumentBatteryMeters (),
                                      new InstrumentOther ()
                                     };
    }  /* BuildInstrumentList */



    public  static  Instrument  LookUpByShortName (string _shortName)
    {
      string  shortNameLower = _shortName.ToLower ();

      if  (instruments == null)
        BuildInstrumentList ();

      for  (int x = 0;  x < instruments.Length;  x++)
      {
        if  (instruments[x] != null)
        {
          if  (instruments[x].ShortName ().ToLower () == shortNameLower)
            return instruments[x];
        }
      }

      return null;
    }  /* LookUpByShortName */



    public  static  Instrument  OtherInstrument ()
    {
      return LookUpByShortName ("OTH");
    }


    virtual public  bool  Other ()  {return false;}  // Only the InstrumentOtherf can return true.


    public  static  void  PopulateComboBox (System.Windows.Forms.ComboBox  comboBox)
    {
      int x = 0;

      if  (instruments == null)
        BuildInstrumentList ();
     
      ArrayList choices = new ArrayList ();
      choices.Add ("None");
      for  (x = 0;  x < instruments.Length;  x++)
      {
        choices.Add (instruments[x].ShortName ());
      }
 
      comboBox.DataSource = choices;
    }  /* PopulateComboBox */


    private static  Instrument[] instruments = null;

    private string  shortName;
    private string  description;
  }  /* Instrument */





  public class InstrumentCTD: Instrument 
  {
    public  InstrumentCTD (): base ("CTD", "CTD")
    {
    }

    public  override InstrumentDataReport  CreateInstrumentDataReport (InstrumentDataManager manager,
                                                                       byte                  deviceId
                                                                      )
    {
      return new InstrumentDataReportCTD (manager, deviceId, InstrumentDataReportCTD.OutPutFormat.EngineeringUnitsInDec);
    }
  }  /* InstrumentCTD */








  public class InstrumentGPS: Instrument 
  {
    public  InstrumentGPS (): base ("GPS", "GPS")
    {
    }



    public override  InstrumentDataReport  CreateInstrumentDataReport (InstrumentDataManager manager,
                                                                       byte                  deviceId
                                                                      )
    {
      return new InstrumentDataReportGPS (manager, deviceId);
    }
  }  /* InstrumentGPS */




  public class InstrumentInclinationMeter: Instrument 
  {
    public  InstrumentInclinationMeter (): base ("P-R", "Inclination Meter")
    {
    }

    public override  InstrumentDataReport  CreateInstrumentDataReport (InstrumentDataManager manager,
                                                                       byte                  deviceId
                                                                      )
    {
      return new InstrumentDataReportInclination (manager, deviceId);
    }
  }  /* InstrumentOther */






  public class InstrumentBatteryMeters : Instrument
  {
    public InstrumentBatteryMeters ()
      : base ("BAT", "Battery Meters")
    {
    }

    public override  InstrumentDataReport  CreateInstrumentDataReport (InstrumentDataManager manager,
                                                                       byte deviceId
                                                                      )
    {
      return new  InstrumentDataReportBatteryMeter (manager, deviceId);
    }
  }  /* InstrumentOther */





  public class InstrumentOther: Instrument 
  {
    public  InstrumentOther (): base ("OTH", "Other")
    {
    }


    public  override bool  Other ()  {return true;}  // Only the InstrumentOther can return true.


    public override  InstrumentDataReport  CreateInstrumentDataReport (InstrumentDataManager manager,
                                                                       byte deviceId
                                                                      )
    {
      return new InstrumentDataReport (manager, deviceId);
    }
  }  /* InstrumentOther */
}

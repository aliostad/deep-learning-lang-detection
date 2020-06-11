using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Inventory {

    private Dictionary<string, bool> obtained_instruments;
    private const int total_number_instruments = 3;
    private List<string> instruments_order;
    private int equipped_instrument;

    public Inventory() {
        obtained_instruments = new Dictionary<string, bool>();
        obtained_instruments.Add("guitar", false);
        obtained_instruments.Add("electric_guitar", false);
        obtained_instruments.Add("keyboard", false);

        instruments_order = new List<string>();
        instruments_order.Add("guitar");
        instruments_order.Add("electric_guitar");
        instruments_order.Add("keyboard");

        equipped_instrument = 1;
    }

    public void SetInstrument(string instrument) {
        obtained_instruments[instrument] = true;
    }

    public string GetEquippedInstrument() {
        return instruments_order[equipped_instrument];
    }

 
    public void ChangeInstrument(int direction) {
  
        if (equipped_instrument + direction < 0)
            equipped_instrument = total_number_instruments - 1;
        else if (equipped_instrument + direction > total_number_instruments - 1)
            equipped_instrument = 0;
        else
            equipped_instrument += direction;

        if (obtained_instruments[instruments_order[equipped_instrument]] == false)
            ChangeInstrument(direction);
        //Play sound 
    }
}

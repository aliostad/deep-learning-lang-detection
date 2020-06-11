using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine.UI;

public class Battle
{
    public List<Instrument> sideOneInstruments = new List<Instrument>();
    public List<Instrument> sideTwoInstruments = new List<Instrument>();

    public int Participants { get { return sideOneInstruments.Count + sideTwoInstruments.Count; } }
    public List<Instrument> AllInstruments { get { return sideOneInstruments.Concat(sideTwoInstruments).ToList(); } }

    public bool battleGoing;

    Instrument _currentRiffer;
    public Instrument CurrentRiffer { get { return _currentRiffer; } }

    public bool RoundFinished()
    {
        bool roundFinished = true;
        foreach (Instrument instrument in AllInstruments)
        {
            if (instrument.AudioPlaying) roundFinished = false;
        }
        return roundFinished;
    }

    public void RunRound()
    {
        // set new riffer
        if (sideOneInstruments.Contains(_currentRiffer))
            _currentRiffer = sideTwoInstruments[Random.Range(0, sideTwoInstruments.Count)];
        else if (sideTwoInstruments.Contains(_currentRiffer))
            _currentRiffer = sideOneInstruments[Random.Range(0, sideOneInstruments.Count)];

        foreach (Instrument instrument in AllInstruments)
        {
            if (instrument == _currentRiffer)
                instrument.PlayRiff();
            else
                instrument.PlayRythm();
        }
    }

    public void UpdateBattle()
    {
        // at least one side is missing an instrument
        if (sideOneInstruments.Count == 0 || sideTwoInstruments.Count == 0)
        {
            if (battleGoing)
                battleGoing = false;

            return;
        }

        if (!battleGoing)
        {
            // starting a new battle
            int startingRifferTeam = Random.Range(0, 2);
            if (startingRifferTeam == 0) _currentRiffer = sideOneInstruments[Random.Range(0, sideOneInstruments.Count)];
            else if (startingRifferTeam == 1) _currentRiffer = sideTwoInstruments[Random.Range(0, sideTwoInstruments.Count)];

            battleGoing = true;
        }
    }
}

public class BattleManager : MonoBehaviour 
{
    public static BattleManager Instance;
    public GameObject riffRing;

    List<Battle> _currentBattles = new List<Battle>();

    void Awake()
    {
        Instance = this;
    }


    /// <summary>
    /// use update to keep battles progressing
    /// </summary>
    void Update()
    {
        foreach (Battle battle in _currentBattles)
        {
            if (battle == null)
            {
                _currentBattles.Remove(battle);
                break;
            }

            if (battle.battleGoing)
            {
                if (battle.RoundFinished())
                {
                    battle.RunRound();
                    riffRing.transform.position = battle.CurrentRiffer.transform.position;
                }
            }
        }
    }


    /// <summary>
    /// Add an instrument to a battle
    /// TODO what is a 'battle'?
    /// </summary>
    public void AddInstrumentToBattle(Battle battle, Instrument instrument, int side)
    {
        if (battle == null)
        {
            // create new battle here
            battle = new Battle();
            _currentBattles.Add(battle);
        }

        if (side == 1) battle.sideOneInstruments.Add(instrument);
        else if (side == 2) battle.sideTwoInstruments.Add(instrument);

        battle.UpdateBattle();
    }


    /// <summary>
    /// remove an instrument from a battle, which will remove the battle if it's now empty
    /// </summary>
    public void RemoveInstrumentFromBattle(Battle battle, Instrument instrument)
    {
        if (battle.sideOneInstruments.Contains(instrument))
            battle.sideOneInstruments.Remove(instrument);
        else if (battle.sideTwoInstruments.Contains(instrument))
            battle.sideTwoInstruments.Remove(instrument);

        if (battle.Participants == 0)
        {
            _currentBattles.Remove(battle);
            battle = null;
        }
        else
            battle.UpdateBattle();
    }

    public void InstrumentClick(GameObject instrumentObject)
    {
        Instrument instrument = instrumentObject.GetComponent<Instrument>();
        int side = int.Parse(instrumentObject.name[0].ToString());
        Battle battle = GetBattleForInstrument(instrument);

        instrument.inBattleImage.gameObject.SetActive(!instrument.inBattleImage.gameObject.activeSelf);
            
        if (battle != null)
        {
            RemoveInstrumentFromBattle(battle, instrument);
        }
        else
        {
            battle = _currentBattles.Count > 0 ? _currentBattles[0] : null;
            AddInstrumentToBattle(battle, instrument, side);
        }
    }

    Battle GetBattleForInstrument(Instrument instrument)
    {
        foreach (Battle battle in _currentBattles)
        {
            if (battle.AllInstruments.Contains(instrument)) 
                return battle;
        }
        return null;
    }
}

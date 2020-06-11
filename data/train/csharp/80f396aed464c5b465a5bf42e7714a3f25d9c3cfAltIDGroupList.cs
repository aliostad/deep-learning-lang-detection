using FreeQuant.FIX;
using System.Collections;

namespace OpenQuant.API
{
  public class AltIDGroupList : IEnumerable
  {
    internal Instrument instrument;

    public AltIDGroup this[string altSource]
    {
      get
      {
        foreach (FIXSecurityAltIDGroup group in (FIXGroupList) this.instrument.instrument.SecurityAltIDGroup)
        {
          if (group.SecurityAltIDSource == altSource)
            return new AltIDGroup(this.instrument, group);
        }
        return (AltIDGroup) null;
      }
    }

    public int Count
    {
      get
      {
        return this.instrument.instrument.SecurityAltIDGroup.Count;
      }
    }

    internal AltIDGroupList(Instrument instrument)
    {
      this.instrument = instrument;
    }

    public AltIDGroup Add(string altSource)
    {
      foreach (FIXSecurityAltIDGroup group in (FIXGroupList) this.instrument.instrument.SecurityAltIDGroup)
      {
        if (group.SecurityAltIDSource == altSource)
          return new AltIDGroup(this.instrument, group);
      }
      FIXSecurityAltIDGroup group1 = new FIXSecurityAltIDGroup();
      group1.SecurityAltIDSource = altSource;
      this.instrument.instrument.SecurityAltIDGroup.Add((FIXGroup) group1);
      return new AltIDGroup(this.instrument, group1);
    }

    public void Remove(string altSource)
    {
      foreach (FIXSecurityAltIDGroup securityAltIdGroup in (FIXGroupList) this.instrument.instrument.SecurityAltIDGroup)
      {
        if (securityAltIdGroup.SecurityAltIDSource == altSource)
        {
          this.instrument.instrument.SecurityAltIDGroup.Remove((FIXGroup) securityAltIdGroup);
          break;
        }
      }
    }

    public bool Contains(string altSource)
    {
      return this[altSource] != null;
    }

    public IEnumerator GetEnumerator()
    {
      foreach (FIXSecurityAltIDGroup group in (FIXGroupList) this.instrument.instrument.SecurityAltIDGroup)
        yield return (object) new AltIDGroup(this.instrument, group);
    }
  }
}

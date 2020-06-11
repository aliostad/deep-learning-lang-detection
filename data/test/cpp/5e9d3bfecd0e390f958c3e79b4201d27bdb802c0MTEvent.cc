#include "../interface/MTEvent.h"

using namespace IPHCTree;


// ---------------------------------------------------------------------------
// Reset
// ---------------------------------------------------------------------------
void MTEvent::Reset()
{
  general.Reset();  trigger.Reset();
  mc.Reset();
  pileup.Reset();
  electrons.Reset();      muons.Reset();
  taus.Reset();           photons.Reset();
  jets.Reset();           tracks.Reset();
  vertices.Reset();       beamSpot.Reset();
  others.Reset();         met.Reset();
  pfcandidates.Reset();    descriptor.Reset();
}


// ---------------------------------------------------------------------------
// Dump
// ---------------------------------------------------------------------------
void MTEvent::Dump(std::ostream & os) const
{
  general.Dump(os); trigger.Dump(os);
  mc.Dump(os);
  pileup.Dump(os);
  electrons.Dump(os);      muons.Dump(os);
  taus.Dump(os);           photons.Dump(os);
  jets.Dump(os);         tracks.Dump(os);
  vertices.Dump(os);       beamSpot.Dump(os);
  others.Dump(os);         met.Dump(os);
  pfcandidates.Dump(os);
}







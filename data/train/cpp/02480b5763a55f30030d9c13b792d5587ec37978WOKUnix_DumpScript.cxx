#ifndef WNT
#include <TCollection_AsciiString.hxx>
#include <WOKUnix_DumpScript.ixx>

//=======================================================================
//function : WOKUnix_DumpScript
//purpose  : 
//=======================================================================
 WOKUnix_DumpScript::WOKUnix_DumpScript()
{
}

//=======================================================================
//function : WOKUnix_DumpScript
//purpose  : 
//=======================================================================
 WOKUnix_DumpScript::WOKUnix_DumpScript(const TCollection_AsciiString & apath)
                     :WOKUnix_ShellStatus(apath)
{
}

//=======================================================================
//function : EndCmd
//purpose  : 
//=======================================================================
void WOKUnix_DumpScript::EndCmd(const Handle(WOKUnix_Shell)& ashell)
{
}

//=======================================================================
//function : Sync
//purpose  : 
//=======================================================================
void WOKUnix_DumpScript::Sync(const Handle(WOKUnix_Shell)& ashell)
{
}

//=======================================================================
//function : Reset
//purpose  : 
//=======================================================================
void WOKUnix_DumpScript::Reset(const Handle(WOKUnix_Shell)& ashell)
{
}

//=======================================================================
//function : Get
//purpose  : 
//=======================================================================
Standard_Integer WOKUnix_DumpScript::Get()
{
  return 0;
}

#endif

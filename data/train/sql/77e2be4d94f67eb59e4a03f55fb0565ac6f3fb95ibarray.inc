
!ABCIncludeFile(IBC)

  OMIT('_EndOfInclude_',_ArrayPresent_)
_ArrayPresent_ EQUATE(1)

  INCLUDE('IBCBASE.INC'),ONCE

Element                 CLASS(CInterface),MODULE('IBARRAY'),DLL(_IbcDllMode_),TYPE
                        END


BaseArray               CLASS(CInterface),MODULE('IBARRAY.CLW'),DLL(_IbcDllMode_),LINK('IBARRAY.CLW',_IbcLinkMode_),TYPE ! Abstract
Head                      LONG,PROTECTED
Used                      UNSIGNED,PROTECTED
ReleaseComponents         BOOL,PROTECTED
Size                      BYTE,PROTECTED

Construct                 PROCEDURE
Destruct                  PROCEDURE,DERIVED

_init                     PROCEDURE,PROTECTED
_space                    PROCEDURE,PROTECTED

CastItem                  PROCEDURE(SIGNED pos),LONG
DoClear                   PROCEDURE
Is_Item                   PROCEDURE(UNSIGNED pos = 0),BYTE
Kill                      PROCEDURE,VIRTUAL
Ordinality                PROCEDURE,SIGNED
SetReleaseComponents      PROCEDURE(BOOL b)
Swap                      PROCEDURE(UNSIGNED pos1, UNSIGNED pos2)
                        END



! An array or 'objects'

Array                   CLASS(BaseArray),MODULE('IBARRAY.CLW'),DLL(_IbcDllMode_),LINK('IBARRAY.CLW',_IbcLinkMode_),type
_set                      PROCEDURE(CInterface next, SIGNED index),PRIVATE

GetIterator               PROCEDURE(),*CIterator
Kill                      PROCEDURE,DERIVED
Item                      PROCEDURE(SIGNED pos),*CInterface
Replace                   PROCEDURE(CInterface next, UNSIGNED pos, BYTE nodel = 0)
Remove                    PROCEDURE(UNSIGNED pos, BYTE nodel = 0)
DoAppend                  PROCEDURE(CInterface next)
DoAdd                     PROCEDURE(CInterface next, UNSIGNED pos)
DoSort                    PROCEDURE(ICInterfaceCompare Cmp)
Find                      PROCEDURE(CInterface search),UNSIGNED
ZapAll                    PROCEDURE(CInterface search, BYTE nodel = 0),BYTE,PROC
Zap                       PROCEDURE(CInterface search, BYTE nodel = 0),BYTE,PROC
                        END


! An array of 'interfaces'

ArrayI                  CLASS(BaseArray),MODULE('IBARRAY.CLW'),DLL(_IbcDllMode_),LINK('IBARRAY.CLW',_IbcLinkMode_),type
_Set                      PROCEDURE(IInterface next, SIGNED index),PRIVATE

DoAdd                     PROCEDURE(IInterface next, UNSIGNED pos)
DoAppend                  PROCEDURE(IInterface next)
DoSort                    PROCEDURE(IIInterfaceCompare Cmp)
Find                      PROCEDURE(IInterface search),UNSIGNED
GetIterator               PROCEDURE(),*IIterator
Item                      PROCEDURE(SIGNED pos),*IInterface
Kill                      PROCEDURE,DERIVED
Remove                    PROCEDURE(UNSIGNED pos, BYTE nodel = 0)
Replace                   PROCEDURE(IInterface next, UNSIGNED pos, BYTE nodel = 0)
Zap                       PROCEDURE(IInterface search, BYTE nodel = 0),BYTE,PROC
ZapAll                    PROCEDURE(IInterface search, BYTE nodel = 0),BYTE,PROC
                        END


  _EndOfInclude_


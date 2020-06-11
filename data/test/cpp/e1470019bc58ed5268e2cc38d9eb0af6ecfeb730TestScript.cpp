#include "stdafx.h"
#include "TestScript.h"
#include "BfBootCore/ScriptCmdList.h"

namespace TestBfBoot
{    
    using BfBootCore::ScriptCmdList;       

    void TestScript()
    {        
        TUT_ASSERT( ScriptCmdList::Validate("Load(SPI,0);Load(MAIN,1);", 2) );
        TUT_ASSERT( ScriptCmdList::Validate(" Load ( SPI , 0 ) ;  Load ( MAIN , 1 ) ; ", 2) ); // test trimming

        std::string err;

        // wrong interface name
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SP,0); Load(MAIN,1);", 2, &err) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0); Load(MAI,1);", 2, &err) );

        // wrong cmd name
        TUT_ASSERT( !ScriptCmdList::Validate("u(SPI,0); Load(MAIN,1);", 2, &err) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0); Zzz(MAIN,1);", 2, &err) );

        // missing separators
        TUT_ASSERT( !ScriptCmdList::Validate("Load SPI,0);Load(MAIN,1);", 2, &err) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0 ;Load(MAIN,1);", 2, &err) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0) Load(MAIN,1);", 2, &err) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0);Load(MAIN 1);", 2, &err) );

        // wrong arg count
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0 ,r);", 2, &err) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI);", 2, &err) );

        // missing symbol
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0) Load(MAIN,1);", 2, &err) );
        //TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0); Load(MAIN,1)", 2) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load SPI,0); Load(MAIN,1);", 2, &err) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0); Load(MAIN,1 ;", 2, &err) );

        // z
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0); Load(MAIN,1)z;", 2, &err) );        

        // wrong index
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,0); Load(MAIN,2);", 2, &err) );
        TUT_ASSERT( !ScriptCmdList::Validate("Load(SPI,X); Load(MAIN,1);", 2, &err) );

        // MAIN in last
        TUT_ASSERT( !ScriptCmdList::Validate("Load(MAIN,1); Load(SPI,0);", 2, &err) );

        TUT_ASSERT( !ScriptCmdList::Validate("Load(MAIN,1);;", 2, &err) );        
    }
} // namespace TestBfBoot

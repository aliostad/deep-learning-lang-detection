#ifndef FUTTRADE_STREAM_T_H
#define FUTTRADE_STREAM_T_H

#include "../cg_stream_t.h"

namespace cgatepp
{

//-------------------------------------------------------------------
//-------------------------------------------------------------------

class futtrade_stream_t : public cg_stream_t
{
public:
    futtrade_stream_t() :
        cg_stream_t("FORTS_FUTTRADE_REPL", "FutTrade")
    {
        to_ini(m_short_name);
    }
};

//-------------------------------------------------------------------
//-------------------------------------------------------------------

}

#endif // FUTTRADE_STREAM_T_H

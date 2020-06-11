#include "rApi.h"

namespace Red
{

ApiInterfaz *Api::apiInterfaz = NULL ;
ApiLogica   *Api::apiLogica = NULL ;

void    
Api::Inicializar(int modo)
{
    switch (modo)
    {
        case MODO_LOCAL:
            apiInterfaz = new ApiInterfazLocal() ;
            apiLogica   = new ApiLogicaLocal() ;
            break ;
        case MODO_SERVIDOR:
            apiInterfaz = new ApiInterfazRed() ;
            apiLogica   = new ApiLogicaLocal() ;
            break ;
        case MODO_CLIENTE:
            apiInterfaz = new ApiInterfazLocal() ;
            apiLogica   = new ApiLogicaRed() ;
            break ;
    }
}
 
void 
Api::Finalizar()
{
    if ( apiInterfaz )
    {
        delete apiInterfaz ;
        apiInterfaz = NULL ;
    }
    if ( apiLogica )
    {
        delete apiLogica ;
        apiLogica = NULL ;
    }
}

ApiInterfaz *
Api::GetApiInterfaz()
{
    return apiInterfaz ;
}

ApiLogica *
Api::GetApiLogica()
{
    return apiLogica ;
}

void
Api::Actualizar()
{
    if ( apiInterfaz && apiLogica )
    {
        apiInterfaz->Actualizar();
        apiLogica->Actualizar();
    }
}

}

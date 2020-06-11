#ifndef __R_API_H__
#define __R_API_H__

#include "rApiInterfazLocal.h"
#include "rApiInterfazRed.h"
#include "rApiLogicaLocal.h"
#include "rApiLogicaRed.h"

namespace Red
{
    
class Api
{
private:
    static ApiInterfaz *apiInterfaz ;
    static ApiLogica *apiLogica ;
    
public:
    static const int MODO_LOCAL = 0 ;
    static const int MODO_SERVIDOR = 1 ;
    static const int MODO_CLIENTE = 2 ;
    
    static void Inicializar(int modo);
    static void Finalizar();
    static ApiInterfaz * GetApiInterfaz() ;
    static ApiLogica   * GetApiLogica() ;
    
    static void Actualizar() ;
};

}

#endif

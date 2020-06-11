<?php

namespace Snappminds\ContableBundle\Entity\Transaccion;


class TransaccionesFactory
{
    private $cuentasRepository;
    
    public function __construct(Snappminds\ContableBundle\Entity\Cuenta\ICuentaRepository $cuentasRepository)
    {
        $this->setCuentasRepository($cuentasRepository);
    }
    
    protected function setCuentasRepository(Snappminds\ContableBundle\Entity\Cuenta\ICuentaRepository $value)
    {
        $this->cuentasRepository = $value;
    }
    
    protected function getCuentasRepository()
    {
        return $this->cuentasRepository;
    }
    
    public function createVentaMostrador(VentasMostrador\DTOs\DTOTransaccionVentaMostrador $dto)
    {
        return new VentasMostrador\TransaccionVentaMostrador(
                $this->getCuentasRepository(), 
                $dto
        );
    }
}
<?php

require_once FACADE."EmpresaUsuarioFacade.php";  
require_once ENTITY."EmpresaUsuario.php";
require_once FACADE."EmpresaFacade.php";
require_once FACADE."UsuarioFacade.php";
require_once FACADE."AbstractFacade.php";   
require_once ENTITY."EmpresaUsuario.php";   

class EmpresaUsuarioFacade extends AbstractFacade
{    
    
    protected function getNameRelationEntity() 
    {
        return "EmpresaUsuario";
    }

//    public function getObj($fila) 
//    {
//        $empresaFacade=new EmpresaFacade();
//        $usuarioFacade=new UsuarioFacade();
//        $consulta=$empresaFacade->getFindPrimaryKey($fila[1]);
//        $array=$empresaFacade->arrayToObject($consulta);
//        
//        $empresa=$array[0];
//        $usuario=  $usuarioFacade->arrayToObject($usuarioFacade->getFindPrimaryKey($fila[2]))[0];
//        return new EmpresaUsuario(
//                $fila[0],
//                $empresa,
//                $usuario);
//    }

 
}
<?php
include_once ("../clases/dao/Apiario.php");
class beans_apiario{
    private $obj_api;
    private $_api_id;
    private $_api_nombre;
    private $_api_direccion;
    private $_api_latitud;
    private $_api_longitud;
    private $_api_fecha_ingreso;
    private $_api_estado;
    
    public function __construct() {
        $this->obj_api = new Apiario();
    }
    
    public function AgregarApiario($nombre, $direccion, $latitud, $longitud, $estado){
        $res = $this->obj_api->AgregarApiario($nombre, $direccion, $latitud, $longitud, $estado);
        return $res;
    }
    
    public function ListarApiarios($id = null){
        $res = $this->obj_api->ListarApiarios($id);
        return $res;
    }
    
    public function setApiario($id){
        $res = $this->ListarApiarios($id);
        if(is_array($res)){
            $this->_api_id              =   $res[0]['API_ID'];
            $this->_api_nombre          =   $res[0]['API_NOMBRE'];
            $this->_api_direccion       =   $res[0]['API_DIRECCION'];
            $this->_api_latitud         =   $res[0]['API_LATITUD'];
            $this->_api_longitud        =   $res[0]['API_LONGITUD'];
            $this->_api_fecha_ingreso   =   $res[0]['API_FECHA_INGRESO'];
            $this->_api_estado          =   $res[0]['API_ESTADO'];
        }else{
            $this->_api_id              =   '';
            $this->_api_nombre          =   '';
            $this->_api_direccion       =   '';
            $this->_api_latitud         =   '';
            $this->_api_longitud        =   '';
            $this->_api_fecha_ingreso   =   '';
            $this->_api_estado          =   '';
        }
    }
    
    public function get_api_id() {
        return $this->_api_id;
    }

    public function set_api_id($_api_id) {
        $this->_api_id = $_api_id;
    }

    public function get_api_nombre() {
        return $this->_api_nombre;
    }

    public function set_api_nombre($_api_nombre) {
        $this->_api_nombre = $_api_nombre;
    }

    public function get_api_direccion() {
        return $this->_api_direccion;
    }

    public function set_api_direccion($_api_direccion) {
        $this->_api_direccion = $_api_direccion;
    }

    public function get_api_latitud() {
        return $this->_api_latitud;
    }

    public function set_api_latitud($_api_latitud) {
        $this->_api_latitud = $_api_latitud;
    }

    public function get_api_longitud() {
        return $this->_api_longitud;
    }

    public function set_api_longitud($_api_longitud) {
        $this->_api_longitud = $_api_longitud;
    }

    public function get_api_fecha_ingreso() {
        return $this->_api_fecha_ingreso;
    }

    public function set_api_fecha_ingreso($_api_fecha_ingreso) {
        $this->_api_fecha_ingreso = $_api_fecha_ingreso;
    }

    public function get_api_estado() {
        return $this->_api_estado;
    }

    public function set_api_estado($_api_estado) {
        $this->_api_estado = $_api_estado;
    }


}


?>
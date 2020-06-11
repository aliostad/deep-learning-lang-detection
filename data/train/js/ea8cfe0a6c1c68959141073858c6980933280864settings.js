/**
 * Created by marco on 05/11/2016.
 */

angular.module("wellnessApp").value("configuracion", {
    "protocol" : "http",
    "host" : "localhost:8000",
    "rutaApiLogin" : "users/api/v1/login/",
    "rutaApiLogout" : "users/api/v1/logout/",
    "rutaApiGetUsers" : "users/api/v1/users/",
    "rutaApiDeleteUser" : "users/api/v1/users/",
    "rutaApiGetConsumos" : "facturas/api/v1/consumodiario/?ordering=fecha__fecha&search=",
    "rutaApiDeleteConsumo" : "facturas/api/v1/consumodiario/",
    "rutaApiGetPrecio" : "facturas/api/v1/preciodiario/",
    "sesion" : {}
});
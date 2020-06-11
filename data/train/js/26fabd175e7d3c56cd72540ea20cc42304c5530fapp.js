/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
Ext.Loader.setConfig({
    enabled:true
});
Ext.application({
    name:'appApplication',
    appFolder:'Application',
    autoCreateViewport:true,
    controllers:['MenuController','ModuleController','TypeUserController','UserController'
             ,'StaffController','CompanyController','TypeUserPermissionController','MenuTemplateController'
             ,'MarcaController','TipoProductoController','ModeloController','ProductoController']
});


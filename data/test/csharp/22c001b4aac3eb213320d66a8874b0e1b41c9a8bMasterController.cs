using Proyecto.servicios;
using Proyecto.vistas;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Proyecto.controladores
{
    public class MasterController
    {
        public MasterController(MasterViewController masterViewController)
        {
            NotificationMessagess notificationMessages = new NotificationMessagess();
            MySQLContection SQLService = new MySQLContection();
            SQLService.setNotificationMessages(notificationMessages);

            ModeloController modeloBusinessController = new ModeloController();
            ModeloViewController modeloViewController = new ModeloViewController();
            modeloBusinessController.setSQLService(SQLService);
            modeloBusinessController.setPresenter(modeloViewController);
            modeloViewController.setBusinessController(modeloBusinessController);

            TipoController tipoBusinessController = new TipoController();
            TipoViewController tipoViewController = new TipoViewController();
            tipoBusinessController.setSQLService(SQLService);
            tipoBusinessController.setPresenter(tipoViewController);
            tipoViewController.setBusinessController(tipoBusinessController);

            ProductoController productoBusinessController = new ProductoController();
            ProductoViewController productoViewController = new ProductoViewController();
            productoBusinessController.setSQLService(SQLService);
            productoBusinessController.setPresenter(productoViewController);
            productoViewController.setBusinessController(productoBusinessController);
            productoViewController.setBusinessController(tipoBusinessController);
            productoViewController.setBusinessController(modeloBusinessController);

            VentaController ventaBusinessController = new VentaController();
            VentaViewController ventaViewController = new VentaViewController();
            ventaBusinessController.setSQLService(SQLService);
            ventaBusinessController.setPresenter(ventaViewController);
            ventaViewController.setBusinessController(ventaBusinessController);
            ventaViewController.setBusinessController(productoBusinessController);

            LoginViewController loginViewController = new LoginViewController();
            loginViewController.setMasterViewController(masterViewController);

            InventoryViewController inventoryViewController = new InventoryViewController();
            inventoryViewController.setBusinessController(productoBusinessController);

            CorteDiaViewController corteDiaViewController = new CorteDiaViewController();
            corteDiaViewController.setBusinessController(ventaBusinessController);

            CorteMensualViewController corteMensualViewController = new CorteMensualViewController();
            corteMensualViewController.setBusinessController(ventaBusinessController);
            
            masterViewController.setViewController(modeloViewController);
            masterViewController.setViewController(inventoryViewController);
            masterViewController.setViewController(tipoViewController);
            masterViewController.setViewController(productoViewController);
            masterViewController.setViewController(ventaViewController);
            masterViewController.setViewController(loginViewController);
            masterViewController.setViewController(corteDiaViewController);
            masterViewController.setViewController(corteMensualViewController);

            masterViewController.init();
        }
    }
}

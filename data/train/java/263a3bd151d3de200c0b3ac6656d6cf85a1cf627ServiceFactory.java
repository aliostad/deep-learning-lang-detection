package model.service;

/**
 *
 * @author Zergio
 */
public class ServiceFactory {

    private ServiceFactory() {
    }
    private static ServiceFactory instance;

    public static synchronized ServiceFactory getInstance() {
        if (instance == null) {
            instance = new ServiceFactory();
        }
        return instance;
    }

    public EmpresaService getEmpresaService() {
        return EmpresaService.getInstance();
    }

    public UsuarioService getUsuarioService() {
        return UsuarioService.getInstance();
    }

    public ErrorService getErrorService() {
        return ErrorService.getInstance();
    }
    
    public VersionService getVersionService(){
        return VersionService.getInstance();
    }
}

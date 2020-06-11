import net.RpcClient;
import service.Service;
import service.ServiceClient;
import ui.UiConsole;
import ui.UiService;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by Cristina on 3 Dec 2015.
 */
public class ClientApp {
    public static void main(String[] args) {
        UiService uiService = new UiService();
        ExecutorService executorService = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
        RpcClient rpcClient = new RpcClient(Service.SERVICE_HOST, Service.SERVICE_PORT);
        Service serviceClient = new ServiceClient(executorService, rpcClient);

        uiService.setHelloService(serviceClient);
        uiService.run();
        executorService.shutdownNow();
        System.out.println("Hello from client");
    }
}

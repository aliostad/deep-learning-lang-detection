package znt.main;

import znt.helper.ZntServiceHelper;
import znt.service.RpcService;
import znt.service.ZntService;

/**
 * @author elviswang
 * @date 2016/12/7
 * @time 11:25
 * Desc TODO
 */
public class ClientTest {

    public static void main(String[] args) throws Exception {
        ZntService.Iface zntService = ZntServiceHelper.getService(ZntService.Iface.class);
        System.out.println(zntService.znt("1.0.1"));

        RpcService.Iface rpcService = ZntServiceHelper.getService(RpcService.Iface.class);
        System.out.println(rpcService.rpc("1.0.1"));
    }
}

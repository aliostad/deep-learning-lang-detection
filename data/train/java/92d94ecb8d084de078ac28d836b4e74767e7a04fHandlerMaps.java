package com.huawei.ism.openapi.common.handlercfg;

import java.util.HashMap;
import java.util.Map;

import com.huawei.ism.openapi.alarm.AlarmHandlerImp;
import com.huawei.ism.openapi.cachepartition.CachePartitionHandlerImp;
import com.huawei.ism.openapi.common.DefaultCommHandler;
import com.huawei.ism.openapi.common.keydeifines.ConstantsDefine.HandlerConstant;
import com.huawei.ism.openapi.consistentgroup.ConsistentGroupHandlerImp;
import com.huawei.ism.openapi.disk.DiskHandlerImp;
import com.huawei.ism.openapi.diskpool.DiskPoolHandlerImp;
import com.huawei.ism.openapi.ethport.ETHPortHandlerImp;
import com.huawei.ism.openapi.fcinitiator.FcInitiatorHandlerImp;
import com.huawei.ism.openapi.fcinitiator.system.performance.PerformanceStatisticSwitchHandlerImpl;
import com.huawei.ism.openapi.fcinitiator.system.systime.SystemTimeHandlerImpl;
import com.huawei.ism.openapi.fclink.FCLinkHandlerImp;
import com.huawei.ism.openapi.fcoeport.FCoEPortHandlerImp;
import com.huawei.ism.openapi.fcport.FCPortHandlerImp;
import com.huawei.ism.openapi.hardware.controller.ControllerHandlerImpl;
import com.huawei.ism.openapi.host.HostHandlerImpl;
import com.huawei.ism.openapi.hostgroup.HostGroupHandlerImp;
import com.huawei.ism.openapi.iscsiinitiator.ISCSIInitiatorHandlerImp;
import com.huawei.ism.openapi.iscsilink.ISCSILinkHandlerImp;
import com.huawei.ism.openapi.lun.LunHandlerImp;
import com.huawei.ism.openapi.lungroup.LunGroupHandlerImp;
import com.huawei.ism.openapi.mappingview.MappingViewHandlerImp;
import com.huawei.ism.openapi.nas.adfield.ADFieldHandlerImpl;
import com.huawei.ism.openapi.nas.cifsauthclient.CIFSShareAuthClientHandlerImp;
import com.huawei.ism.openapi.nas.cifsservice.CIFSServiceHandlerImpl;
import com.huawei.ism.openapi.nas.cifsshare.CIFSShareHandlerImpl;
import com.huawei.ism.openapi.nas.filesystem.FileSystemHandlerImpl;
import com.huawei.ism.openapi.nas.homedir.HomeDirHandlerImpl;
import com.huawei.ism.openapi.nas.ldapfield.LDAPFieldHandlerImpl;
import com.huawei.ism.openapi.nas.localresgroup.LocalResGroupHandlerImpl;
import com.huawei.ism.openapi.nas.localresuser.LocalResuserHandlerImpl;
import com.huawei.ism.openapi.nas.nfsauthclient.NFSShareAuthClientHandlerImp;
import com.huawei.ism.openapi.nas.nfsservice.NFSServiceHandlerImpl;
import com.huawei.ism.openapi.nas.nfsshare.NFSShareHandlerImpl;
import com.huawei.ism.openapi.nas.nisfield.NISFieldHandlerImpl;
import com.huawei.ism.openapi.nas.quota.QuotaHandlerImp;
import com.huawei.ism.openapi.nas.quotatree.QuotaTreeHandlerImp;
import com.huawei.ism.openapi.nas.user.UserHandlerImp;
import com.huawei.ism.openapi.nas.vstore.VStoreHandlerImp;
import com.huawei.ism.openapi.perfstatistic.PerfStatisticHandlerImp;
import com.huawei.ism.openapi.portgroup.PortGroupHandlerImp;
import com.huawei.ism.openapi.remotedevice.RemoteDeviceHandlerImp;
import com.huawei.ism.openapi.remotelun.RemoteLunHandlerImp;
import com.huawei.ism.openapi.replicationpair.ReplicationPairHandlerImp;
import com.huawei.ism.openapi.snapshot.SnapshotHandlerImpl;
import com.huawei.ism.openapi.storagepool.StoragePoolHandlerImp;
import com.huawei.ism.openapi.sysinfo.SysInfoHandlerImp;

/*import com.huawei.ism.openapi.nas.quota.QuotaHandlerImp;
 import com.huawei.ism.openapi.nas.quotatree.QuotaTreeHandlerImp;
 import com.huawei.ism.openapi.nas.vstore.VStoreHandlerImp;
 import com.huawei.ism.openapi.nas.adfield.ADFieldHandlerImpl;
 import com.huawei.ism.openapi.nas.cifsauthclient.CIFSShareAuthClientHandlerImp;
 import com.huawei.ism.openapi.nas.cifsservice.CIFSServiceHandlerImpl;
 import com.huawei.ism.openapi.nas.cifsshare.CIFSShareHandlerImpl;
 import com.huawei.ism.openapi.nas.filesystem.FileSystemHandlerImpl;
 import com.huawei.ism.openapi.nas.homedir.HomeDirHandlerImpl;
 import com.huawei.ism.openapi.nas.ldapfield.LDAPFieldHandlerImpl;
 import com.huawei.ism.openapi.nas.localresgroup.LocalResGroupHandlerImpl;
 import com.huawei.ism.openapi.nas.localresuser.LocalResuserHandlerImpl;
 import com.huawei.ism.openapi.nas.nfsauthclient.NFSShareAuthClientHandlerImp;
 import com.huawei.ism.openapi.nas.nfsservice.NFSServiceHandlerImpl;
 import com.huawei.ism.openapi.nas.nfsshare.NFSShareHandlerImpl;
 import com.huawei.ism.openapi.nas.nisfield.NISFieldHandlerImpl;*/

/**
 * 模块配置类
 * @author fWX183786
 * @version V100R001C10
 */
public class HandlerMaps
{
    private static HandlerMaps handlerMapsInstanceHandlerMaps = null;

    private static Map<String, Class<? extends DefaultCommHandler>> handlerMap = null;

    static
    {
        initHandlerMap();
    }

    /**
     * 获取HandlerMaps单例
     * @return HandlerMaps单例
     */
    public static HandlerMaps getHandlerMapsInstance()
    {
        if (null == handlerMapsInstanceHandlerMaps)
        {
            handlerMapsInstanceHandlerMaps = new HandlerMaps();
        }
        return handlerMapsInstanceHandlerMaps;
    }

    /**
     * 获取具体实现类实例
     * @param key handler名称
     * @return 具体实现类实例
     */
    public Class<? extends DefaultCommHandler> getValue(String key)
    {
        if (handlerMap.containsKey(key))
        {
            return handlerMap.get(key);
        }
        else
        {
            return null;
        }
    }

    /**
     * 模块配置初始化
     */
    private static void initHandlerMap()
    {
        handlerMap = new HashMap<String, Class<? extends DefaultCommHandler>>();
        if (null != handlerMap)
        {
            handlerMap.put(HandlerConstant.LUN_HANDLER, LunHandlerImp.class);
            handlerMap.put(HandlerConstant.STORAGEPOOL_HANDLER, StoragePoolHandlerImp.class);
            handlerMap.put(HandlerConstant.HOSTGROUP_HANDLER, HostGroupHandlerImp.class);
            handlerMap.put(HandlerConstant.PORTGROUP_HANDLER, PortGroupHandlerImp.class);
            handlerMap.put(HandlerConstant.MAPPINGVIEW_HANDLER, MappingViewHandlerImp.class);
            handlerMap.put(HandlerConstant.ISCSIINITIATOR_HANDLER, ISCSIInitiatorHandlerImp.class);
            handlerMap.put(HandlerConstant.FCINITIATOR_HANDLER, FcInitiatorHandlerImp.class);
            handlerMap.put(HandlerConstant.LUNGROUP_HANDLER, LunGroupHandlerImp.class);
            handlerMap.put(HandlerConstant.HOST_HANDLER, HostHandlerImpl.class);
            handlerMap.put(HandlerConstant.SYSINFO_HANDLER, SysInfoHandlerImp.class);
            handlerMap.put(HandlerConstant.ALARM_HANDLER, AlarmHandlerImp.class);
            handlerMap.put(HandlerConstant.PERFSTATISTIC_HANDLER, PerfStatisticHandlerImp.class);
            handlerMap.put(HandlerConstant.DISKPOOL_HANDLER, DiskPoolHandlerImp.class);
            handlerMap.put(HandlerConstant.CACHEPARTITION_HANDLER, CachePartitionHandlerImp.class);
            handlerMap.put(HandlerConstant.PERFORMANCE_STATISTIC_SWITCH, PerformanceStatisticSwitchHandlerImpl.class);
            handlerMap.put(HandlerConstant.SYSTEM_TIMEZONE, SystemTimeHandlerImpl.class);
            handlerMap.put(HandlerConstant.FCOE_PORT, FCoEPortHandlerImp.class);
            handlerMap.put(HandlerConstant.CONTROLLER, ControllerHandlerImpl.class);
            handlerMap.put(HandlerConstant.ETH_PORT, ETHPortHandlerImp.class);
            handlerMap.put(HandlerConstant.DISK_HANDLER, DiskHandlerImp.class);
            handlerMap.put(HandlerConstant.FCPORT_HANDLER, FCPortHandlerImp.class);
            handlerMap.put(HandlerConstant.SNAPSHOT, SnapshotHandlerImpl.class);
            handlerMap.put(HandlerConstant.FCLINK_HANDLER, FCLinkHandlerImp.class);
            handlerMap.put(HandlerConstant.ISCSILINK_HANDLER, ISCSILinkHandlerImp.class);
            handlerMap.put(HandlerConstant.REMOTEDEVICE_HANDLER, RemoteDeviceHandlerImp.class);
            handlerMap.put(HandlerConstant.REMOTELUN_HANDLER, RemoteLunHandlerImp.class);
            handlerMap.put(HandlerConstant.REPLICATIONPAIR_HANDLER, ReplicationPairHandlerImp.class);
            handlerMap.put(HandlerConstant.CONSISTENTGROUP_HANDLER, ConsistentGroupHandlerImp.class);
            // 文件系统handler
            handlerMap.put(HandlerConstant.NISFIELD_HANDLER, NISFieldHandlerImpl.class);
            handlerMap.put(HandlerConstant.ADFIELD_HANDLER, ADFieldHandlerImpl.class);
            handlerMap.put(HandlerConstant.LDAPFIELD_HANDLER, LDAPFieldHandlerImpl.class);
            handlerMap.put(HandlerConstant.CIFSSHARE_HANDLER, CIFSShareHandlerImpl.class);
            handlerMap.put(HandlerConstant.CIFSSHARE_AUTH_CLIENT_HANDLER, CIFSShareAuthClientHandlerImp.class);
            handlerMap.put(HandlerConstant.NFSSHARE_HANDLER, NFSShareHandlerImpl.class);
            handlerMap.put(HandlerConstant.NFSSHARE_AUTH_CLIENT_HANDLER, NFSShareAuthClientHandlerImp.class);
            handlerMap.put(HandlerConstant.FILESYSTEM_HANDLER, FileSystemHandlerImpl.class);
            handlerMap.put(HandlerConstant.HOMEDIR_HANDLER, HomeDirHandlerImpl.class);
            handlerMap.put(HandlerConstant.CIFSSERVICE_HANDLER, CIFSServiceHandlerImpl.class);
            handlerMap.put(HandlerConstant.NFSSERVICE_HANDLER, NFSServiceHandlerImpl.class);
            handlerMap.put(HandlerConstant.LOCAL_RESGROUP_HANDLER, LocalResGroupHandlerImpl.class);
            handlerMap.put(HandlerConstant.LOCAL_RESUSER_HANDLER, LocalResuserHandlerImpl.class);
            handlerMap.put(HandlerConstant.QUOTA_HANDLER, QuotaHandlerImp.class);
            handlerMap.put(HandlerConstant.QUOTATREE_HANDLER, QuotaTreeHandlerImp.class);
            handlerMap.put(HandlerConstant.VSTORE_HANDLER, VStoreHandlerImp.class);
            handlerMap.put(HandlerConstant.USER_HANDLER, UserHandlerImp.class);
        }
    }
}

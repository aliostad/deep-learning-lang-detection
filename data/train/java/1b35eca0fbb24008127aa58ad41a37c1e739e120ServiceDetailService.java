package com.cyou.fz2035.servicetag.servicedetail.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.util.HtmlUtils;

import com.cyou.fz.commons.mybatis.selecterplus.mybatis.util.ObjectUtil;
import com.cyou.fz2035.servicetag.config.ServiceBaseStatusEnum;
import com.cyou.fz2035.servicetag.config.ServiceTagConstants;
import com.cyou.fz2035.servicetag.config.ServiceTypeEnum;
import com.cyou.fz2035.servicetag.servicebase.bean.ServiceBase;
import com.cyou.fz2035.servicetag.servicebase.service.ServiceBaseService;
import com.cyou.fz2035.servicetag.servicebase.vo.ServiceBaseVo;
import com.cyou.fz2035.servicetag.servicedetail.ServiceDetail;
import com.cyou.fz2035.servicetag.servicedetail.dao.ServiceDetailDAO;

/**
 * User: littlehui Date: 14-12-1 Time: 上午10:10
 */
@Service
public class ServiceDetailService {

	@Autowired
	@Qualifier("serviceDetailDAOImpl")
	ServiceDetailDAO serviceDetailDAO;

	@Autowired
	ServiceBaseService serviceBaseService;

    @Autowired
    ServiceDetailClassifyService serviceDetailClassifyService;

	public void transInsertServiceDetail(ServiceDetail serviceDetail) {
		ServiceBaseVo serviceBaseVo = serviceDetail.getServiceBaseVo();
		serviceBaseVo.setStatus(ServiceTagConstants.SERVICE_BASE_STATUS_UNPUBLISH);
        serviceDetail = serviceDetailClassifyService.produceServiceDetailForInsertTeleText(serviceDetail, serviceBaseVo.getServiceType());
        serviceDetail = serviceDetailClassifyService.reproduceServiceDetailForAgenda(serviceDetail, serviceBaseVo.getServiceType());
        serviceDetail =  serviceDetailClassifyService.reproduceServiceDetailForTask(serviceDetail, serviceBaseVo.getServiceType());
        serviceDetail =  serviceDetailClassifyService.reproduceServiceDetailForReward(serviceDetail, serviceBaseVo.getServiceType());
		serviceDetailDAO.insertServiceDetail(serviceDetail);
	}

	public void transUpdateServiceDetail(ServiceDetail serviceDetail) {
		ServiceBase serviceBase = ObjectUtil.convertObj(serviceDetail.getServiceBaseVo(), ServiceBase.class);
		if (serviceBase.getId() == null) {
			throw new RuntimeException("serviceBaseId 为空");
		}
        serviceDetail =  serviceDetailClassifyService.reproduceServiceDetailForAgenda(serviceDetail, serviceBase.getServiceType());
        serviceDetail = serviceDetailClassifyService.reproduceServiceDetailForTask(serviceDetail, serviceBase.getServiceType());
        serviceDetail =  serviceDetailClassifyService.reproduceServiceDetailForReward(serviceDetail, serviceBase.getServiceType());
        serviceDetail = serviceDetailClassifyService.reproduceServiceDetailForTeleText(serviceDetail, serviceBase.getServiceType());
		serviceDetailDAO.updateServiceDetail(serviceDetail);
	}

	public ServiceDetail getServiceDetail(Integer serviceBaseId) {
		ServiceBase serviceBase = serviceBaseService.get(serviceBaseId);
		ServiceDetail serviceDetail = serviceDetailDAO.getServiceDetail(serviceBase);
        serviceDetail =  serviceDetailClassifyService.produceServiceDetailForTeleText(serviceDetail, serviceBase.getServiceType());
        serviceDetail = serviceDetailClassifyService.produceServiceDetailForTask(serviceDetail, serviceBase.getServiceType());
        serviceDetail = serviceDetailClassifyService.produceServiceDetailForAgenda(serviceDetail, serviceBase.getServiceType());
        serviceDetail = serviceDetailClassifyService.produceServiceDetailForReward(serviceDetail, serviceBase.getServiceType());
		return serviceDetail;
	}
}

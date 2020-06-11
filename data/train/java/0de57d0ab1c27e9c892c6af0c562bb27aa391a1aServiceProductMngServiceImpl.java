package ca.esystem.bridges.service.impl;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ca.esystem.framework.service.AbstractService;
import ca.esystem.bridges.dao.ServiceProductDao;
import ca.esystem.bridges.domain.ServiceArea;
import ca.esystem.bridges.domain.ServiceProduct;
import ca.esystem.bridges.service.ServiceProductMngService;

/**
 * Implementation for ServiceProductMngService.
 * 
 * @author Lei Han
 *
 */
@Service("ServiceProductMngService")
@Transactional
public class ServiceProductMngServiceImpl extends AbstractService implements ServiceProductMngService {

    @Resource
    private ServiceProductDao dao;

    public List<?> queryList(Object condition) {
        return dao.queryListByCondition(condition);
    }

    public int queryCount(Object condition) {
        return dao.queryCountRowsByCondition(condition);
    }

    @SuppressWarnings("unchecked")
    public Object queryOne(Object condition) {
        ServiceProduct serviceProduct = (ServiceProduct) condition;
        ServiceProduct serviceProductToReturn = (ServiceProduct) dao.queryObjectByCondition(serviceProduct);

        ServiceArea serviceAreaQuery = new ServiceArea();
        serviceAreaQuery.setService_id(serviceProduct.getService_id());

        List<ServiceArea> serviceAreaList = (List<ServiceArea>) dao.queryServiceAreaList(serviceAreaQuery);

        List<String> cityList = new ArrayList<String>();
        for (ServiceArea area : serviceAreaList) {
            cityList.add(area.getCity_code());
        }
        serviceProductToReturn.setServiceAreaList(cityList);
        serviceProductToReturn = convdertTaxRate(serviceProductToReturn, false);
        return serviceProductToReturn;
    }

    public Object add(Object obj) {
        ServiceProduct serviceProduct = (ServiceProduct) obj;
        serviceProduct = convdertTaxRate(serviceProduct, true);
        dao.insert(serviceProduct);
        ServiceProduct serviceProductNew = (ServiceProduct) dao.queryObjectByCondition(obj);
        Integer serviceId = serviceProductNew.getService_id();

        List<String> serviceAreaList = serviceProduct.getServiceAreaList();

        if (serviceAreaList != null) {
            for (String cityCode : serviceAreaList) {
                ServiceArea serviceArea = new ServiceArea();
                serviceArea.setCity_code(cityCode);
                serviceArea.setService_id(serviceId);
                dao.insertServiceArea(serviceArea);
            }
        }

        return dao.queryObjectByCondition(obj);
    }

    @SuppressWarnings("unchecked")
    public int update(Object obj) {
        ServiceProduct serviceProduct = (ServiceProduct) obj;
        serviceProduct = convdertTaxRate(serviceProduct, true);
        dao.update(serviceProduct);

        List<String> serviceAreaList = serviceProduct.getServiceAreaList();

        ServiceArea serviceAreaQuery = new ServiceArea();
        serviceAreaQuery.setService_id(serviceProduct.getService_id());

        List<ServiceArea> oldServiceAreaList = (List<ServiceArea>) dao.queryServiceAreaList(serviceAreaQuery);
        for (ServiceArea serviceAreaOld : oldServiceAreaList) {
            dao.deleteServiceArea(serviceAreaOld);
        }

        Integer serviceId = serviceProduct.getService_id();

        if (serviceAreaList != null) {
            for (String cityCode : serviceAreaList) {
                ServiceArea serviceArea = new ServiceArea();
                serviceArea.setCity_code(cityCode);
                serviceArea.setService_id(serviceId);
                dao.insertServiceArea(serviceArea);
            }
        }

        return 1;
    }

    public int archive(Object obj) {
        return 0;
    }

    public int delete(Object obj) {
        ServiceProduct serviceProduct = (ServiceProduct) obj;

        return dao.delete(serviceProduct);
    }

    private ServiceProduct convdertTaxRate(ServiceProduct obj, boolean isToDB) {
        DecimalFormat fmt = new DecimalFormat("0.00");
        if (isToDB) {
            obj.setGst_rate(Float.parseFloat(obj.getGstRate()) / 100);
            obj.setPst_rate(Float.parseFloat(obj.getPstRate()) / 100);
        } else {
            obj.setGstRate(fmt.format(obj.getGst_rate() * 100));
            obj.setPstRate(fmt.format(obj.getPst_rate() * 100));
        }
        return obj;
    }

    public List<ServiceProduct> queryServiceProductByUserId(ServiceProduct serviceProduct) {
        return dao.queryServiceProductByUserId(serviceProduct);
    }
    
    public List<ServiceProduct> queryServiceProductForIndex(ServiceProduct serviceProduct){
    	return dao.queryServiceProductForIndex(serviceProduct);
    }
}

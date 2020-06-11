package com.espendwise.manta.support.spring;


import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.espendwise.manta.service.AccountService;
import com.espendwise.manta.service.AllUserService;
import com.espendwise.manta.service.BusEntityService;
import com.espendwise.manta.service.CatalogService;
import com.espendwise.manta.service.DistributorService;
import com.espendwise.manta.service.EventService;
import com.espendwise.manta.service.GroupService;
import com.espendwise.manta.service.ManufacturerService;
import com.espendwise.manta.service.PropertyService;
import com.espendwise.manta.service.ScheduleService;
import com.espendwise.manta.service.ServiceTypeService;
import com.espendwise.manta.service.SiteHierarchyService;
import com.espendwise.manta.service.SiteService;
import com.espendwise.manta.service.StoreMessageService;
import com.espendwise.manta.service.StoreService;
import com.espendwise.manta.service.TemplateService;
import com.espendwise.manta.service.TradingPartnerService;
import com.espendwise.manta.service.UserService;
import com.espendwise.manta.service.WorkflowService;
import com.espendwise.manta.service.CostCenterService;
import com.espendwise.manta.service.ItemService;
import com.espendwise.manta.service.OrderService;

public class ServiceLocator {

    private static final Logger logger = Logger.getLogger(ServiceLocator.class);

    private static StoreMessageService storeMessageService;
    private static AccountService accountService;
    private static SiteService siteService;
    private static PropertyService propertyService;
    private static TemplateService templateService;
    private static AllUserService allUserService;
    private static UserService userService;
    private static SiteHierarchyService siteHierarchyService;
    private static ServiceTypeService serviceTypeService;
    private static WorkflowService workflowService;
    private static CatalogService catalogService;
    private static ManufacturerService manufacturerService;
    private static ItemService itemService;
    private static DistributorService distributorService;
    private static GroupService groupService;
    private static CostCenterService costCenterService;
    private static TradingPartnerService tradingPartnerService;
    private static ScheduleService scheduleService;
    private static EventService eventService;
    private static OrderService orderService;
    private static BusEntityService busEntityService;
    private static StoreService storeService;

    public static StoreMessageService getStoreMessageService() {
        return storeMessageService;
    }

	public static AllUserService getAllUserService() {
        return allUserService;
    }
	public static UserService getUserService() {
        return userService;
    }

    public static AccountService getAccountService() {
        return accountService;
    }

    public static SiteService getSiteService() {
        return siteService;
    }

    public static PropertyService getPropertyService() {
        return propertyService;
    }

    public static TemplateService getTemplateService() {
        return templateService;
    }

    public static SiteHierarchyService getSiteHierarchyService() {
        return siteHierarchyService;
    }

    public static ServiceTypeService getServiceTypeService() {
		return serviceTypeService;
	}

    public static WorkflowService getWorkflowService() {
		return workflowService;
	}

    public static CatalogService getCatalogService() {
		return catalogService;
	}
    public static GroupService getGroupService() {
		return groupService;
	}
    
	public static ManufacturerService getManufacturerService() {
        return manufacturerService;
    }
    
	public static DistributorService getDistributorService() {
        return distributorService;
    }

	public static CostCenterService getCostCenterService() {
        return costCenterService;
    }
    
	public static TradingPartnerService getTradingPartnerService() {
        return tradingPartnerService;
    }
    
	public static ScheduleService getScheduleService() {
        return scheduleService;
    }
	
	public static EventService getEventService() {
        return eventService;
    }

    public static ItemService getItemService() {
        return itemService;
    }
    
    public static OrderService getOrderService() {
        return orderService;
    }
    
    public static BusEntityService getBusEntityService() {
        return busEntityService;
    }

    public static StoreService getStoreService() {
        return storeService;
    }

    @Autowired
	public void setServiceTypeService(ServiceTypeService serviceTypeService) {
		ServiceLocator.serviceTypeService = serviceTypeService;
	}

    @Autowired
    public void setAllUserService(AllUserService allUserService) {
        ServiceLocator.allUserService = allUserService;
    }
    @Autowired
    public void setUserService(UserService userService) {
        ServiceLocator.userService = userService;
    }

    @Autowired
    public void setSiteHierarchyService(SiteHierarchyService siteHierarchyService) {
        ServiceLocator.siteHierarchyService = siteHierarchyService;
    }

    @Autowired
    public void setTemplateService(TemplateService templateService) {
        ServiceLocator.templateService = templateService;
    }

    @Autowired
    public void setAccountService(AccountService accountService) {
        ServiceLocator.accountService = accountService;
    }

    @Autowired
    public void setSiteService(SiteService siteService) {
        ServiceLocator.siteService = siteService;
    }

    @Autowired
    public void setPropertyService(PropertyService propertyService) {
        ServiceLocator.propertyService = propertyService;
    }

    @Autowired
    public void setStoreMessageService(StoreMessageService storeMessageService) {
        ServiceLocator.storeMessageService = storeMessageService;
    }
 
    
    @Autowired
	public void setWorkflowService(WorkflowService workflowService) {
		ServiceLocator.workflowService = workflowService;
	}

    @Autowired
	public void setCatalogService(CatalogService catalogService) {
		ServiceLocator.catalogService = catalogService;
	}
    @Autowired
	public void setGroupService(GroupService groupService) {
		ServiceLocator.groupService = groupService;
	}

    @Autowired
	public void setManufacturerService(ManufacturerService manufacturerService) {
		ServiceLocator.manufacturerService = manufacturerService;
	}

    @Autowired
	public void setDistributorService(DistributorService distributorService) {
		ServiceLocator.distributorService = distributorService;
	}

    @Autowired
	public void setTradingPartnerService(TradingPartnerService tradingPartnerService) {
		ServiceLocator.tradingPartnerService = tradingPartnerService;
	}

    @Autowired
	public void setScheduleService(ScheduleService scheduleService) {
		ServiceLocator.scheduleService = scheduleService;
	}

    @Autowired
	public void setCostCenterService(CostCenterService costCenterService) {
		ServiceLocator.costCenterService = costCenterService;
	}
    
    @Autowired
	public void setEventService(EventService eventService) {
		ServiceLocator.eventService = eventService;
	}

	@Autowired
	public void setItemService(ItemService itemService) {
        ServiceLocator.itemService = itemService;
    }
    
    @Autowired
    public void setOrderService(OrderService orderService) {
        ServiceLocator.orderService = orderService;
    }
    
    @Autowired
    public void setBusEntityService(BusEntityService busEntityService) {
        ServiceLocator.busEntityService = busEntityService;
    }

    @Autowired
    public void setStoreService(StoreService storeService) {
        ServiceLocator.storeService = storeService;
    }


}

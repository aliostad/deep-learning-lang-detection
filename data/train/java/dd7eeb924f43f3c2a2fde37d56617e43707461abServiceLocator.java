package com.loyauty.service;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;


import com.loyauty.service.operations.OperationsService;
import com.loyauty.service.operations.OperationsServiceImpl;
import com.loyauty.service.orders.OrdersService;
import com.loyauty.service.orders.OrdersServiceImpl;
import com.loyauty.service.product.ProductService;
import com.loyauty.service.product.ProductServiceImpl;
import com.loyauty.service.search.SearchService;
import com.loyauty.service.search.SearchServiceImpl;
import com.loyauty.service.specification.SpecificationService;
import com.loyauty.service.specification.SpecificationServiceImpl;
import com.loyauty.service.user.UserServiceImpl;
import com.loyauty.service.brand.BrandService;
import com.loyauty.service.brand.BrandServiceImpl;
import com.loyauty.service.cache.CacheServiceImpl;
import com.loyauty.service.Service;
import com.loyauty.exception.ServiceLocatorException;
import com.loyauty.service.cache.CacheService;
import com.loyauty.service.category.CategoryService;
import com.loyauty.service.category.CategoryServiceImpl;
import com.loyauty.service.common.CommonService;
import com.loyauty.service.common.CommonServiceImpl;
import com.loyauty.service.image.ImageService;
import com.loyauty.service.image.ImageServiceImpl;
import com.loyauty.service.init.ConfigService;
import com.loyauty.service.init.ConfigServiceImpl;
import com.loyauty.service.user.UserService;
import com.loyauty.service.usersprivileges.UsersPrivilegesService;
import com.loyauty.service.usersprivileges.UsersPrivilegesServiceImp;




/**
 * J2EE clients interact with service components which provide business 
 * services and persistence capabilities.
 * This class offers a lookup interface for all services available in the system.
 *  
 * TODO:
 * JNDI lookup for remote services!  
 *
 */
public class ServiceLocator {

	// Services Constants Inner Class
	public class Services {
		public static final int CONFIG_SERVICE  = 1;
		public static final int CACHE_SERVICE = 2;
		public static final int USER_SERVICE = 3;
		public static final int BRAND_SERVICE = 4;
		public static final int CATEGORY_SERVICE = 5;
		public static final int PRODUCT_SERVICE = 6;
		public static final int SPECIFICATION_SERVICE = 7; // we have add a team service
		public static final int COMMON_SERVICE = 8;
		public static final int SEARCH_SERVICE = 9;
		public static final int IMAGE_SERVICE =10;
		public static final int ARTICLE_SERVICE =11;
		public static final int Operations_SERVICE =12;
		public static final int PO_SERVICE =13;
		public static final int ORDER_SERVICE =14;
		public static final int USER_PRIVILEGES_SERVICE =15;

	} 
	
	private static final ServiceLocator INSTANCE = new ServiceLocator();
	
	/**
	 * A singleton service locator
	 * 
	 * @return
	 */
	public static ServiceLocator getInstance(){
		return INSTANCE;
	}
	
	private ServiceLocator(){
		if (INSTANCE != null) {
			throw new IllegalStateException(this.getClass()	+ " instance is already created");
		}
	}
	
	/**
	 * Looks up the configuration service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public ConfigService getConfigService() throws ServiceLocatorException{		
		return (ConfigService) lookupService(Services.CONFIG_SERVICE);
	}

	/**
	 * Looks up the cache service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public CacheService getCacheService() throws ServiceLocatorException{
		return (CacheService) lookupService(Services.CACHE_SERVICE);
	}
	
	/**
	 * Looks up the user service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public UserService getUserService() throws ServiceLocatorException{
		return (UserService) lookupService(Services.USER_SERVICE);
	}
	
	/**
	 * Looks up the user service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public BrandService getBrandService() throws ServiceLocatorException{
		return (BrandService) lookupService(Services.BRAND_SERVICE);
	}
	
	/**
	 * Looks up the CategoryService service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public CategoryService getCategoryService() throws ServiceLocatorException{
		return (CategoryService) lookupService(Services.CATEGORY_SERVICE);
	}
	
	
	/**
	 * Looks up the CategoryService service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public ProductService getProductService() throws ServiceLocatorException{
		return (ProductService) lookupService(Services.PRODUCT_SERVICE);
	}
	
	
	/**
	 * 
	 * @return
	 * @throws ServiceLocatorException
	 */
	public SpecificationService getSpecificationService() throws ServiceLocatorException{
		return (SpecificationService) lookupService(Services.SPECIFICATION_SERVICE);
	}
	/**
	 * Looks up the Common service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public CommonService getCommonService() throws ServiceLocatorException{
		return (CommonService) lookupService(Services.COMMON_SERVICE);
	}
	
	/**
	 * Looks up the CategoryService service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public ImageService getImageService() throws ServiceLocatorException{
		return (ImageService) lookupService(Services.IMAGE_SERVICE);
	}
	
	
	/**
	 * Looks up the CategoryService service.
	 * @return
	 * @throws ServiceLocatorException
	 */
	public SearchService getSearchService() throws ServiceLocatorException{
		return (SearchService) lookupService(Services.SEARCH_SERVICE);
	}
	
	/**
	 * Looks up a service by its id.
	 * @param serviceId
	 * @return
	 * @throws ServiceLocatorException
	 */
	private Service lookupService(int serviceId)throws ServiceLocatorException{
		return lookupService(serviceId, false);
	}
	
	
	public OperationsService getOperationsService() throws ServiceLocatorException{
		return (OperationsService) lookupService(Services.Operations_SERVICE);
	}
	
	
	public OrdersService getOrderService() throws ServiceLocatorException{
		return (OrdersService) lookupService(Services.ORDER_SERVICE);
	}
	
	
	public UsersPrivilegesService getUserPrivilegesService() throws ServiceLocatorException{
		return (UsersPrivilegesService) lookupService(Services.USER_PRIVILEGES_SERVICE);
	}
	
	
	/**
	 * Looks up a service by its id.
	 * If useJNDI is true, the service will be looked up from a 
	 * JNDI context.
	 * @param serviceId
	 * @param useJNDI
	 * @return
	 * @throws ServiceLocatorException
	 */
	private Service lookupService(int serviceId, boolean useJNDI) throws ServiceLocatorException{
		Service service = null;
		
		if(!useJNDI){
			try{
				switch (serviceId) {
				case Services.CONFIG_SERVICE:
					service = ConfigServiceImpl.getInstance(); 
					break;
				case Services.CACHE_SERVICE:
					service = CacheServiceImpl.getInstance();
					break;
				case Services.USER_SERVICE:
					service = new UserServiceImpl();
					break;
				case Services.BRAND_SERVICE:
					service = new BrandServiceImpl();
					break;
				case Services.COMMON_SERVICE:
					service = new CommonServiceImpl();
					break;
				case Services.CATEGORY_SERVICE:
					service = new CategoryServiceImpl();
					break;
				case Services.PRODUCT_SERVICE:
					service = new ProductServiceImpl();
					break;
				case Services.IMAGE_SERVICE:
					service = new ImageServiceImpl();
					break;
				case Services.SPECIFICATION_SERVICE:
					service = new SpecificationServiceImpl();
					break;
				case Services.SEARCH_SERVICE:
					service = SearchServiceImpl.getInstance();
					break;
				case Services.Operations_SERVICE:
					service = new OperationsServiceImpl();
					break;
					
				case Services.PO_SERVICE:
					service = new ProductServiceImpl();
					break;
					
				case Services.ORDER_SERVICE:
					service = new OrdersServiceImpl();
					break;

				case Services.USER_PRIVILEGES_SERVICE:
					service = new UsersPrivilegesServiceImp();
					break;
					
				default:
					break;
				}
			}catch (Exception e) {
				throw new ServiceLocatorException(e);
			}			
		}else{
			try{
				Hashtable<String, String> env = new Hashtable<String, String>();
				env.put(Context.INITIAL_CONTEXT_FACTORY, "com.loyauty.service.init.ConfigServiceImpl");
				
				Context initial  = new InitialContext(env);
				service = (Service) initial.lookup(getServiceName(serviceId));

			}catch (NamingException ne) {
				throw new ServiceLocatorException(ne);
			}catch (Exception e) {
				throw new ServiceLocatorException(e);
			}
		}
		
		return service;
	}
	
	/**
	 * Returns service's name from its id.
	 * @param serviceId
	 * @return
	 */
	private String getServiceName(int serviceId){
		return getServiceClass(serviceId).getName();
	}
	
	@SuppressWarnings({ "unchecked" })
	/**
	 * Returns service's class  from its id.
	 */
	private Class getServiceClass(int serviceId){
		Class clazz = null;
		
		switch (serviceId) {
		case Services.CONFIG_SERVICE:
			clazz = ConfigService.class;
			break;
		case Services.CACHE_SERVICE:
			clazz = CacheService.class;
			break;
		case Services.USER_SERVICE:
			clazz = UserService.class;
			break;
		case Services.BRAND_SERVICE:
			clazz = BrandService.class;
			break;
		case Services.COMMON_SERVICE:
			clazz = CommonService.class;
			break;
		case Services.CATEGORY_SERVICE:
			clazz = CategoryService.class;
			break;
		case Services.PRODUCT_SERVICE:
			clazz = ProductService.class;
			break;
		case Services.IMAGE_SERVICE:
			clazz = ImageService.class;
			break;
		case Services.SPECIFICATION_SERVICE:
			clazz = SpecificationService.class;
			break;		
			
		default:
			break;
		}
		
		return clazz;
	}

}

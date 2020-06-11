package devopsdistilled.operp.server.context.items;

import javax.inject.Inject;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.remoting.rmi.RmiServiceExporter;

import devopsdistilled.operp.server.data.service.items.BrandService;
import devopsdistilled.operp.server.data.service.items.CategoryService;
import devopsdistilled.operp.server.data.service.items.ItemService;
import devopsdistilled.operp.server.data.service.items.ManufacturerService;
import devopsdistilled.operp.server.data.service.items.ProductService;

@Configuration
public class ItemRmiContext {

	@Inject
	private ItemService itemService;

	@Inject
	private ProductService productService;

	@Inject
	private CategoryService categoryService;

	@Inject
	private BrandService brandService;

	@Inject
	private ManufacturerService manufacturerService;

	@Bean
	public RmiServiceExporter rmiItemServiceExporter() {
		RmiServiceExporter rmiServiceExporter = new RmiServiceExporter();
		rmiServiceExporter.setServiceName("ItemService");
		rmiServiceExporter.setServiceInterface(ItemService.class);
		rmiServiceExporter.setService(itemService);
		rmiServiceExporter.setRegistryPort(1099); // default
		return rmiServiceExporter;
	}

	@Bean
	public RmiServiceExporter rmiProductServiceExporter() {
		RmiServiceExporter rmiServiceExporter = new RmiServiceExporter();
		rmiServiceExporter.setServiceName("ProductService");
		rmiServiceExporter.setServiceInterface(ProductService.class);
		rmiServiceExporter.setService(productService);
		rmiServiceExporter.setRegistryPort(1099);
		return rmiServiceExporter;
	}

	@Bean
	public RmiServiceExporter rmiBrandServiceExporter() {
		RmiServiceExporter rmiServiceExporter = new RmiServiceExporter();
		rmiServiceExporter.setServiceName("BrandService");
		rmiServiceExporter.setServiceInterface(BrandService.class);
		rmiServiceExporter.setService(brandService);
		rmiServiceExporter.setRegistryPort(1099);
		return rmiServiceExporter;
	}

	@Bean
	public RmiServiceExporter rmiCategoryServiceExporter() {
		RmiServiceExporter rmiServiceExporter = new RmiServiceExporter();
		rmiServiceExporter.setServiceName("CategoryService");
		rmiServiceExporter.setServiceInterface(CategoryService.class);
		rmiServiceExporter.setService(categoryService);
		rmiServiceExporter.setRegistryPort(1099);
		return rmiServiceExporter;
	}

	@Bean
	public RmiServiceExporter rmiManufacturerServiceExporter() {
		RmiServiceExporter rmiServiceExporter = new RmiServiceExporter();
		rmiServiceExporter.setServiceName("ManufacturerService");
		rmiServiceExporter.setServiceInterface(ManufacturerService.class);
		rmiServiceExporter.setService(manufacturerService);
		rmiServiceExporter.setRegistryPort(1099);
		return rmiServiceExporter;
	}

}

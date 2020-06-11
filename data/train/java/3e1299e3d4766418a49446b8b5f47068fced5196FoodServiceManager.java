package practicejsf.bean.service;

import java.util.Arrays;
import java.util.List;

import javax.inject.Inject;

public class FoodServiceManager implements FoodServiceCaller {

	@Inject
	@Curry
	private FoodService curryService;
	
	@Inject
	@Noodle
	private FoodService noodleService;
	
	@Inject
	@Sushi
	private FoodService sushiService;

	/**
	 * @Injectを書いた場所でBeanを生成することができる？
	 * しかしコンストラクタやsetterでInjectした時にどうやって呼び出すのか。
	 */
	
//	@Inject
//	public FoodServiceManager(@Named("curry") FoodService curryService,
//		@Named("noodle") FoodService noodleService,
//		@Named("sushi") FoodService sushiService) {
//		this.curryService = curryService;
//		this.noodleService = noodleService;
//		this.sushiService = sushiService;
//	}

	@Override
	public List<String> callFoodService() {
		List<String> foods = Arrays.asList(
			curryService.getFoods(),
			noodleService.getFoods(),
			sushiService.getFoods()
		);
		
		return foods;
	}
	
}

import service.FactoryService;
import service.ShapeService;

/**
 * Author: Daniel
 */
public class Runner {
    public static void main(String[] args) {
//        ApplicationContext context =
//                new ClassPathXmlApplicationContext("context.xml");
//
//        ShapeService shapeService =
//                (ShapeService) context.getBean("shapeService");
//
//        Circle circle = shapeService.getCircle();

        FactoryService factoryService = new FactoryService();
        ShapeService shapeService =
                (ShapeService) factoryService.getBean("shapeService");
        shapeService.getCircle();
    }
}

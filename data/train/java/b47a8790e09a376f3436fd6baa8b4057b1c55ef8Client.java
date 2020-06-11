/**
 * 
 */
package guice.print;

import com.google.inject.Inject;

/**
 * @author yangwm in Jan 3, 2010 8:56:21 PM
 */
public class Client {

    /*
    // or 属性注入
    @Inject 
    private PrintService printService;
    */

    /*
    // or 构造函数注入
    private PrintService printService;
    
    @Inject
    public Client(PrintService printService) {
        this.printService = printService;
    }
    */
    
    /**/
    // or 方法注入
    private PrintService printService;
    
    @Inject
    public void setPrintService(PrintService printService) {
        this.printService = printService;
    }
    

    /*
    // or 属性注入 + 自定义注释
    @Inject 
    @Print 
    private PrintService printService;
    */
    
    /*
    // or 属性注入 + @Named代替自定义标注
    @Inject 
    @Named("printNamed") 
    private PrintService printService;
    */

    public void printString() {
        printService.print("Hello world!\n");
    }
    
    // getter 
    
    public PrintService getPrintService() {
        return printService;
    }
    
}

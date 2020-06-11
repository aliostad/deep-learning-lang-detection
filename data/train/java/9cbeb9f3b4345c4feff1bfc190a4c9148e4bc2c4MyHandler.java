package pattern.chain;
/**
 * @author lwkjob
 *
 */
public class MyHandler  implements Handler {  
  
    private String name;  
    private Handler handler;  
    
    public Handler getHandler() {  
        return handler;  
    }  
  
    public void setHandler(Handler handler) {  
        this.handler = handler;  
    }  
    public MyHandler(String name) {  
        this.name = name;  
    }  
  
    @Override  
    public void doFilter() {  
        System.out.println(name+"deal!");  
        if(getHandler()!=null){  
            getHandler().doFilter();  
        }  
    }  
}  
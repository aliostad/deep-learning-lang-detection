package liquid.process.handler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

/**
 * Created by redbrick9 on 6/7/14.
 */
@Service
public class TaskHandlerFactory {
    @Autowired
    private ApplicationContext context;

    public TaskHandler locateHandler(String definitionKey) {
        TaskHandler handler = context.containsBean(definitionKey + "Handler")
                ? context.getBean(definitionKey + "Handler", TaskHandler.class)
                : context.getBean("defaultHandler", TaskHandler.class);
        handler.setDefinitionKey(definitionKey);
        return handler;
    }
}

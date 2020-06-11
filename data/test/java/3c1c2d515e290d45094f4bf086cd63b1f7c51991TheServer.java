package org.chronicweirdo.dump.server;

import org.chronicweirdo.dump.model.Source;
import org.chronicweirdo.dump.parsers.ReferenceParser;
import org.chronicweirdo.dump.parsers.XPathParser;
import org.chronicweirdo.dump.service.BuilderService;
import org.chronicweirdo.dump.service.ScannerService;
import org.chronicweirdo.dump.service.SourceService;
import org.eclipse.jetty.rewrite.handler.RewriteHandler;
import org.eclipse.jetty.rewrite.handler.RewritePatternRule;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.DefaultHandler;
import org.eclipse.jetty.server.handler.HandlerCollection;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by scacoveanu on 12/31/2014.
 */
@Component
public class TheServer {

    @Autowired
    private HomeHandler homeHandler;

    @Autowired
    private BuilderService builderService;

    @Autowired
    private FilterHandler filterHandler;

    @Autowired
    private SourceService sourceService;

    @Autowired
    private PostsHandler postsHandler;

    public void setFilterHandler(FilterHandler filterHandler) {
        this.filterHandler = filterHandler;
    }

    public void setPostsHandler(PostsHandler postsHandler) {
        this.postsHandler = postsHandler;
    }

    public void setHomeHandler(HomeHandler homeHandler) {
        this.homeHandler = homeHandler;
    }

    public void setBuilderService(BuilderService builderService) {
        this.builderService = builderService;
    }

    public void setSourceService(SourceService sourceService) {
        this.sourceService = sourceService;
    }

    public void start() {
        Server server = new Server(getPort());

        ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
        context.setContextPath("/");

        RewriteHandler rewriteHandler = new RewriteHandler();
        rewriteHandler.setHandler(context);
        rewriteHandler.setRewritePathInfo(false);
        rewriteHandler.setRewriteRequestURI(false);
        RewritePatternRule rootRule = new RewritePatternRule();
        rootRule.setPattern("");
        rootRule.setReplacement("/home");
        rewriteHandler.addRule(rootRule);

        // add resources
        List<Handler> resourceHandlers = new ArrayList<>();
        for (String source: sourceService.getResources()) {
            // create a resource handler
            ResourceHandler resourceHandler = new ResourceHandler();
            resourceHandler.setDirectoriesListed(false);
            resourceHandler.setResourceBase(source);
            resourceHandlers.add(resourceHandler);
        }



        HandlerCollection handlerCollection = new HandlerCollection();
        //handlerCollection.addHandler(rewriteHandler); TODO: why does this work even if it's not added?
        handlerCollection.addHandler(homeHandler);
        handlerCollection.addHandler(filterHandler);
        handlerCollection.addHandler(postsHandler);
        for (Handler handler: resourceHandlers) {
            handlerCollection.addHandler(handler);
        }
        handlerCollection.addHandler(new DefaultHandler());
        server.setHandler(handlerCollection);

        try {
            server.start();
            server.join();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    private int getPort() {
        return 8080;
    }
}

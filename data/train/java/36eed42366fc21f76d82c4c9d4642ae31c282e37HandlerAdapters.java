package swoop.pipeline;

public class HandlerAdapters {

    public static HandlerAdapter adjustRouteParametersPreProcess(final HandlerEntry entry, final HandlerAdapter handler) {
        return new HandlerAdapter() {
            @Override
            public void handle(Pipeline pipeline) {
                RouteParametersHandler routeParametersHandler = pipeline.get(RouteParametersHandler.class);
                if (routeParametersHandler != null)
                    routeParametersHandler.adjustFor(pipeline, entry);
                handler.handle(pipeline);
            }
        };
    }

    public static HandlerAdapter wrap(final PipelineDownstreamHandler handler) {
        return new HandlerAdapter() {
            @Override
            public void handle(Pipeline pipeline) {
                pipeline.with(Handler.Mode.class, Handler.Mode.Downstream);
                handler.handleDownstream(pipeline);
            }
        };
    }

    public static HandlerAdapter wrap(final PipelineUpstreamHandler handler) {
        return new HandlerAdapter() {
            @Override
            public void handle(Pipeline pipeline) {
                pipeline.with(Handler.Mode.class, Handler.Mode.Upstream);
                handler.handleUpstream(pipeline);
            }
        };
    }

    public static HandlerAdapter wrap(final PipelineTargetHandler handler) {
        return new HandlerAdapter() {
            @Override
            public void handle(Pipeline pipeline) {
                pipeline.with(Handler.Mode.class, Handler.Mode.Target);
                handler.handleTarget(pipeline);
            }
        };
    }

}

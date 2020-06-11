
test(
    "Basic Controller test",
    function() {

        var controller = new Jackalope.Client.Controller ({});
        ok(controller instanceof Jackalope.Client.Controller, "... we are an instance of Jackalope.Client.Controller");

        ok(!controller.has_context(), '... no context for this controller');

        var context = {};
        controller.bind('update:context', function (c, ctx) {
            ok(c === controller, '... got passed the controller instance');
            ok(ctx === context, '... got passed the context we set');
        });
        controller.bind('clear:context', function (c) {
            ok(c === controller, '... got passed the controller instance');
        });

        controller.set_context( context );
        ok(controller.has_context(), '... we now have context for this controller');

        ok(controller.get_context() === context, '... got have the context we set');

        controller.clear_context();
        ok(!controller.has_context(), '... no context for this controller anymore');

    }
);
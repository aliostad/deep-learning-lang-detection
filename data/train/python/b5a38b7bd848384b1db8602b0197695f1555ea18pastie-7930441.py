def form_action(controller, item):
    parser = controller.parse_request(fallback=item)

    if controller.request.method in ('PUT', 'POST', 'PATCH'):
        if parser.validate():

            parser.update(item)

            item.put()

            controller.context.set(**{
                controller.scaffold.singular: item})

            if controller.scaffold.redirect:
                return controller.redirect(controller.scaffold.redirect)

    controller.context.set(**{
        'form': parser.container,
        controller.scaffold.singular: item})
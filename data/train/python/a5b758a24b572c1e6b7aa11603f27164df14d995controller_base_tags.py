from django.template import loader, Library, TemplateDoesNotExist
from django.contrib.contenttypes.models import ContentType

register = Library()


@register.simple_tag(takes_context=True)
def render_controller(context, controller):
    ctype = ContentType.objects.get_for_model(controller)
    try:
        t = loader.get_template(
            '%s/inclusion_tags/controller_object.html' % ctype.app_label)
    except TemplateDoesNotExist:
        t = loader.get_template(
            'base/inclusion_tags/controller_object.html')
    context.update({'controller_object': controller})
    return t.render(context)

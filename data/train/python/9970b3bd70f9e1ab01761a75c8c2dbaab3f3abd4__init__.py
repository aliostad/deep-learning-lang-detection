"""PPA.Template - templating support in PPA.

This package defines a set of classes to find, interpret and evaluate templates
in various templating languages.

PPA.Template provides:

fromString              - compiles template passed as string
fromFile                - compiles template from file-like object
TemplateController      - controller for all template operation, use it if you
                          need more control
FileSourceFinder        - finds templates by name from series of directories
TemplateNotFoundError   - exception, raise when template not found

You may look deeper in code to use all provided classes directly, but more
common usage is like this:

from PPA import Template

Simple usage:

    template = Template.fromString('<h1><%= title %></h1>', type='pyem')
    result = template.toString({'title': 'Python rulez!'})

    template = Template.fromFile('template.pyem')
    template.toFile(sys.stdout, {'title': 'Python rulez!'})

More complex example:

    source_finder = Template.FileSourceFinder(['/path/to/tamplates1',
                                               '/path/to/tamplates2'])
    controller = Template.TemplateController(source_finder)
    # The following method automatically determines the type of template
    template = controller.getTemplate('template')
    template.toFile(sys.stdout, global_ns, local_ns)
"""

from Controller import TemplateController
from SourceFinders import TemplateNotFoundError, FileSourceFinder

__all__ = ['TemplateNotFoundError', 'TemplateController', 'FileSourceFinder']


_controller = None

def fromString(source, name='?', type=None, controller=None):
    '''Compiles template passed as string (str or unicode) and returns
    TemplateWrapper instance.'''
    global _controller
    if controller is None:
        if _controller is None:
            _controller = TemplateController()
        controller = _controller
    return controller.compileString(source, name, type)

def fromFile(source_file, name=None, type=None, controller=None):
    '''Compiles template from path or file-like object and returns
    TemplateWrapper instance.'''
    global _controller
    close = False
    if not hasattr(source_file, 'read'):
        source_file = open(source_file, 'rb')
        close = True
    try:
        if controller is None:
            if _controller is None:
                _controller = TemplateController()
            controller = _controller
        result = controller.compileFile(source_file, name, type)
    finally:
        if close:
            source_file.close()
    return result

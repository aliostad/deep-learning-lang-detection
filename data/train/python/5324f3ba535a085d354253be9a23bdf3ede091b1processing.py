def process_form(request, form_class, form_dict=None, save_kwargs=None, *a, **kw):
    '''
        Optional:
        =========

        You can pass kwargs to the form save function in a 'save_kwargs' dict.


        Example Usage:
        ==============

        success, form = process_form(request, DiscussionForm, initial={
            'category':Category.objects.all()[0].id,
        })
        if success:
            return form # this is the return from the forms save method.

        return template(request, 'talk/create_discussion.html', {
            'categories': Category.objects.all(),
            'form': form
        })
    '''

    form = form_class(form_dict or request.POST or None, *a, **kw)

    if request.method == 'POST':
        if form.is_valid():
            if not save_kwargs:
                save_kwargs = {}
            results = form.save(request=request, **save_kwargs)
            return (True, results)
    return (False, form)

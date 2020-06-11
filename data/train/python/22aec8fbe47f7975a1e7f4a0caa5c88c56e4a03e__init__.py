def save_form(form, actor=None):
    """Allows storing a form with a passed actor. Normally, Form.save() does not accept an actor, but if you require
    this to be passed (is not handled by middleware), you can use this to replace form.save().

    Requires you to use the audit.Model model as the actor is passed to the object's save method.
    """

    obj = form.save(commit=False)
    obj.save(actor=actor)
    form.save_m2m()
    return obj

#def intermediate_save(instance, actor=None):
#    """Allows saving of an instance, without storing the changes, but keeping the history. This allows you to perform
#    intermediate saves:
#
#    obj.value1 = 1
#    intermediate_save(obj)
#    obj.value2 = 2
#    obj.save()
#    <value 1 and value 2 are both stored in the database>
#    """
#    if hasattr(instance, '_audit_changes'):
#        tmp = instance._audit_changes
#        if actor:
#            instance.save(actor=actor)
#        else:
#            instance.save()
#        instance._audit_changes = tmp
#    else:
#        if actor:
#            instance.save(actor=actor)
#        else:
#            instance.save()

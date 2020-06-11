class BaseAdmin(object):
    def save_formset(self, request, form, formset, change):
        instances = formset.save(commit=False)
        for instance in instances:
            if not instance.pk:
                instance.created_by = request.user
            instance.modified_by = request.user
            instance.save()
        formset.save_m2m()

    def save_model(self, request, obj, form, change):
        if not obj.id:
            obj.created_by = request.user

        obj.modified_by = request.user
        obj.save()

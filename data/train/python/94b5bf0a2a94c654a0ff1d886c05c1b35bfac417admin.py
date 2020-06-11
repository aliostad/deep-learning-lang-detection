from employers.models import Employer
from django.contrib import admin

# Register your models here.

from .models import Employer

class EmployerAdmin(admin.ModelAdmin):
    class Meta:
        model = Employer
        
    def save_model(self, request, obj, form, change): 
        obj.user = request.user
        obj.save()

    def save_formset(self, request, form, formset, change): 
        if formset.model == Employer:
            instances = formset.save(commit=False)
            for instance in instances:
                instance.user = request.user
                instance.save()
        else:
            formset.save()
        
#admin.site.register(Employer, EmployerAdmin)
        


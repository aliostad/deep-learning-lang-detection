from cvitae.models import Cvitae
from django.contrib import admin

# Register your models here.

from .models import Cvitae

class CvitaeAdmin(admin.ModelAdmin):
    class Meta:
        model = Cvitae
        
    #def save_model(self, request, obj, form, change): 
       # obj.user = request.user
       # obj.save()

    #def save_formset(self, request, form, formset, change): 
        #if formset.model == Cvitae:
            #instances = formset.save(commit=False)
           # for instance in instances:
                #instance.user = request.user
                #instance.save()
        #else:
            #formset.save()
        
#admin.site.register(Cvitae, CvitaeAdmin)

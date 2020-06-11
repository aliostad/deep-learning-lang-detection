from cv.models import Cv
from django.contrib import admin

# Register your models here.

from .models import Cv

class CvAdmin(admin.ModelAdmin):
    class Meta:
        model = Cv
        
    #def save_model(self, request, obj, form, change): 
       # obj.user = request.user
       # obj.save()

    #def save_formset(self, request, form, formset, change): 
        #if formset.model == Cv:
            #instances = formset.save(commit=False)
           # for instance in instances:
                #instance.user = request.user
                #instance.save()
        #else:
            #formset.save()
        
#admin.site.register(Cv, CvAdmin)

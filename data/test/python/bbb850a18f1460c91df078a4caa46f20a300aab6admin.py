from django.contrib import admin
from models import Property
from models import Broker
from models import PropertyStatus

# Register your models here.
class PropertyAdmin(admin.ModelAdmin):
	list_display = ['Property_ID','Price','Bedroom_Number','Bathroom_Number','Address','City','Post_code','Description']
	class Meta:
		model = Property


class BrokerAdmin(admin.ModelAdmin):
	list_display = ['Broker_ID','Company_Name','Broker_Name','Broker_Name','Company_Address','Company_City','Company_Post_Code','Broker_Phone','Broker_Email']
	class Meta:
		model = Broker


class PropertyStatusAdmin(admin.ModelAdmin):
	list_display = ['Property_ID','Offer_Flag','Offer_date','Sold_Flag','Sold_Date']
	class Meta:
		model = PropertyStatus

admin.site.register(Property,PropertyAdmin)
admin.site.register(Broker,BrokerAdmin)
admin.site.register(PropertyStatus,PropertyStatusAdmin)

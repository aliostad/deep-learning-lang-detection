from django.contrib import admin

#
#
#
class CreatedByBaseAdmin(admin.ModelAdmin):
	""" 
	Base class for handling created by stuff
	"""

	readonly_fields = ('created_by', 'created_date')

	def save_formset(self, request, form, formset, change):
		instances = formset.save(commit=False)
		for instance in instances:
			if not change:
				instance.created_by = request.user
				instance.save()
		formset.save()

	def save_model(self, request, obj, form, change):
		if not change:
			obj.created_by = request.user
		obj.save()

	class Meta:
		abstract = True		



class FullAuditBaseAdmin(admin.ModelAdmin):
	""" 
	Base class for handling created by stuff
	"""

	readonly_fields = ('created_by', 'created_date', 'modified_by', 'modified_date', 'deleted_by', 'deleted_date')

	def save_formset(self, request, form, formset, change):
		instances = formset.save(commit=False)
		for instance in instances:
			if not change:
				instance.created_by = request.user
				instance.save()
		formset.save()

	def save_model(self, request, obj, form, change):
		if not change:
			obj.created_by = request.user
		obj.save()

	class Meta:
		abstract = True

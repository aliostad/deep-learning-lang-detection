from django.contrib import admin

from edc_base.modeladmin.admin import BaseModelAdmin, BaseStackedInline

from ..actions import return_dispatched_containers
from ..models import DispatchContainerRegister, DispatchItemRegister


class DispatchItemRegisterInline(BaseStackedInline):
    model = DispatchItemRegister
    extra = 0


class DispatchContainerRegisterAdmin(BaseModelAdmin):

    date_hierarchy = 'dispatch_datetime'

    ordering = ['-created', ]

    list_display = (
        'producer',
        'to_items',
        'container_model_name',
        'container_identifier',
        'created',
        'is_dispatched',
        'dispatch_datetime',
        'return_datetime')

    list_filter = (
        'producer',
        'container_identifier',
        'created',
        'is_dispatched',
        'dispatch_datetime',
        'return_datetime')

    search_fields = ('id', 'container_identifier', )

    inlines = [DispatchItemRegisterInline, ]

    actions = [return_dispatched_containers, ]

admin.site.register(DispatchContainerRegister, DispatchContainerRegisterAdmin)

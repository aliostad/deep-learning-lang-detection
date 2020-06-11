# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from admintool.models import ExpenseCategory, ExpenseType, VendorType

def load_data(apps, schema_editor):
    ExpenseCategory(category_name="Groceries",).save()
    ExpenseCategory(category_name="Books",).save()
    ExpenseCategory(category_name="School Supplies",).save()
    ExpenseCategory(category_name="Utilities",).save()
    ExpenseCategory(category_name="Insurance",).save()
    ExpenseCategory(category_name="Medical",).save()
    ExpenseCategory(category_name="Gas",).save()
    ExpenseCategory(category_name="Mortgage",).save()
    ExpenseCategory(category_name="Travel",).save()
    ExpenseCategory(category_name="Restaurant",).save()
    ExpenseCategory(category_name="Taxes",).save()

    ExpenseType(type_name="Cash",).save()
    ExpenseType(type_name="Check",).save()
    ExpenseType(type_name="Credit Card",).save()

    VendorType(vendor_name="Walmart",).save()
    VendorType(vendor_name="Amazon",).save()
    VendorType(vendor_name="Costco/Sams",).save()
    VendorType(vendor_name="Starbucks",).save()

class Migration(migrations.Migration):

    dependencies = [
        ('admintool', '0004_auto_20140922_0210'),
    ]

    operations = [
        migrations.RunPython(load_data)
    ]

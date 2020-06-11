#encoding:utf-8
from django import forms
from libreria.main.models import *
from django.contrib.auth.models import User
from django.forms.models import BaseInlineFormSet, inlineformset_factory

class BookManageForm(forms.ModelForm):
	class Meta:
		model = Book

class BookClassificationManageForm(forms.ModelForm):
	class Meta:
		model = BookClassification

class BookSubClassificationManageForm(forms.ModelForm):
	class Meta:
		model = BookSubClassification

class LibraryUserManageForm(forms.ModelForm):
	class Meta:
		model = LibraryUser	 

class AppUserManageForm(forms.ModelForm):
	class Meta:
		model = User	 

class GuarantorManageForm(forms.ModelForm):
	class Meta:
		model = Guarantor

class LoanManageForm(forms.ModelForm):
	class Meta:
		model = Loan

class BookLoanManageForm(forms.ModelForm):
	model = BookLoan

def get_bookloan_items_formset(form, formset = BaseInlineFormSet, **kwargs):
	return inlineformset_factory(Loan, BookLoan, form, formset, **kwargs)
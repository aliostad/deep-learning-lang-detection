# -*- coding: utf-8 -*-
from django.conf.urls import url

from api.views.university_faculties_view import UniversityFacultiesView
from api.views.api_autocomplete_city_name import ApiAutocompleteCityName
from api.views.api_autocomplete_company_name import ApiAutocompleteCompanyName
from api.views.api_autocomplete_faculty_name import ApiAutocompleteFacultyName

urlpatterns = [
    url(r'autocomplete-city-name$', ApiAutocompleteCityName.as_view(), name='api_autocomplete_city_name'),
    url(r'autocomplete-company-name$', ApiAutocompleteCompanyName.as_view(), name='api_autocomplete_company_name'),
    url(r'university/faculties/get$', UniversityFacultiesView.as_view(), name='university_faculties_url'),
    url(r'faculties-names/get$', ApiAutocompleteFacultyName.as_view(), name='api_autocomplete_faculty_name')
]

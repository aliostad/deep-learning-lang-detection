from django.conf.urls import patterns, url
from django.contrib.auth.decorators import login_required

# Misc functions
from ts_emod.views.ScenarioBrowseView import ScenarioBrowseView
from ts_repr.utils.misc_functions import delete_scenario, determine_page, get_emod_snippet_ajax, get_om_snippet_ajax

# Entry points
from ts_repr.views.IndexView import IndexView

# Browsers
from ts_repr.views.BrowseScenarioView import BrowseScenarioView

# Creation process
from ts_repr.views.creation.NewScenarioView import NewScenarioView
from ts_repr.views.creation.WeatherView import WeatherView, save_weather_data, get_weather_data
from ts_repr.views.creation.DemographicsView import DemographicsView, save_demographics_data, get_demographics_data
from ts_repr.views.creation.SpeciesView import SpeciesView, get_species_data_ajax, save_species_data
from ts_repr.views.creation.ParasiteView import ParasiteView, save_parasite_data
from ts_repr.views.creation.DetailsView import DetailsView, save_scenario_name_ajax

# Managers
from ts_repr.views.managers.ManageWeatherView import ManageWeatherView
from ts_repr.views.managers.ManageDemographicsView import ManageDemographicsView
from ts_repr.views.managers.ManageSpeciesView import ManageSpeciesView
from ts_repr.views.managers.ManageSpeciesParameterView import ManageSpeciesParameterView
from ts_repr.views.managers.ManageEMODSnippetView import ManageEMODSnippetView
from ts_repr.views.managers.ManageOMSnippetView import ManageOMSnippetView


urlpatterns = patterns('ts_repr.views',
                        # Entry points
                        url(r'^$', IndexView.as_view(), name='ts_repr.index'),

                        url(r'^(?P<scenario_id>\d+)/$', login_required(determine_page), name='ts_repr.determine_view'),

                        # Browsers
                        url(r'^scenario/browse2/$', login_required(BrowseScenarioView.as_view()), name='ts_repr.browse_scenario2'),
                        url(r'^scenario/browse/$', login_required(ScenarioBrowseView.as_view()), name='ts_repr.browse_scenario'),

                        # Creation process
                        url(r'^new/$', login_required(NewScenarioView.as_view()), name='ts_repr.new_scenario'),

                        url(r'^weather/(?P<scenario_id>\d+)/$', login_required(WeatherView.as_view()), name='ts_repr.weather'),
                        url(r'^weather/data/(?P<option_id>\d+)/$', get_weather_data, name='ts_repr.get_weather_data'),
                        url(r'^weather/save_data/$', save_weather_data, name='ts_repr.save_weather_data'),

                        url(r'^demographics/(?P<scenario_id>\d+)/$', login_required(DemographicsView.as_view()), name='ts_repr.demographics'),
                        url(r'^demographics/data/(?P<option_id>\d+)/$', get_demographics_data, name='ts_repr.get_demographics_data'),
                        url(r'^demographics/save_data/$', save_demographics_data, name='ts_repr.save_demographics_data'),

                        url(r'^species/(?P<scenario_id>\d+)/$', login_required(SpeciesView.as_view()), name='ts_repr.species'),
                        url(r'^species/data/(?P<option_id>\d+)/$', get_species_data_ajax, name='ts_repr.get_species_data'),
                        url(r'^species/save_data/$', save_species_data, name='ts_repr.save_species_data'),

                        url(r'^parasite/(?P<scenario_id>\d+)/$', login_required(ParasiteView.as_view()), name='ts_repr.parasite'),
                        #url(r'^parasite/data/(?P<option_id>\d+)/$', get_parasite_data_ajax, name='ts_repr.get_parasite_data'),
                        url(r'^parasite/save_data/$', save_parasite_data, name='ts_repr.save_parasite_data'),

                        url(r'^details/(?P<scenario_id>\d+)/$', login_required(DetailsView.as_view()), name='ts_repr.details'),
                        url(r'^details/save_data/$', save_scenario_name_ajax, name='ts_repr.save_scenario_name'),

                        # Managers
                        url(r'^manage/weather/$', ManageWeatherView.as_view(), name='ts_repr.manage_weather'),
                        url(r'^manage/demographics/$', ManageDemographicsView.as_view(), name='ts_repr.manage_demographics'),
                        url(r'^manage/species/$', ManageSpeciesView.as_view(), name='ts_repr.manage_species'),
                        url(r'^manage/species_parameter/$', ManageSpeciesParameterView.as_view(), name='ts_repr.manage_species_parameter'),
                        url(r'^manage/emod_snippet/$', ManageEMODSnippetView.as_view(), name='ts_repr.manage_emod_snippet'),
                        url(r'^manage/om_snippet/$', ManageOMSnippetView.as_view(), name='ts_repr.manage_om_snippet'),

                        # Other
                        url(r'^scenario/delete/(?P<scenario_id>\d+)/$', delete_scenario, name='ts_repr.delete_scenario'),
                        url(r'^emod_snippet/data/(?P<option_id>\d+)/$', get_emod_snippet_ajax, name='ts_repr.emod_snippet_data'),
                        url(r'^om_snippet/data/(?P<option_id>\d+)/$', get_om_snippet_ajax, name='ts_repr.om_snippet_data'),
                       )
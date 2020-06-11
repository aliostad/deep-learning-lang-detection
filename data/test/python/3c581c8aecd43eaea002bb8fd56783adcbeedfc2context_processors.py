# django imports
from django.conf import settings
from django.utils import translation

# lfc imports
import lfc.utils
from lfc.settings import LANGUAGES_DICT

def main(request):
    """context processor for LFC.
    """
    current_language = translation.get_language()
    default_language = settings.LANGUAGE_CODE
    
    is_default_language = default_language == current_language
    if current_language == "0" or is_default_language:
        link_language = ""
    else:
        link_language = current_language
    
    return {
        "PORTAL" : lfc.utils.get_portal(),
        "LFC_MULTILANGUAGE" : settings.LFC_MULTILANGUAGE,
        "LFC_MANAGE_WORKFLOWS" : settings.LFC_MANAGE_WORKFLOWS,
        "LFC_MANAGE_APPLICATIONS" : settings.LFC_MANAGE_APPLICATIONS,
        "LFC_MANAGE_COMMENTS" : settings.LFC_MANAGE_COMMENTS,
        "LFC_MANAGE_USERS" : settings.LFC_MANAGE_USERS,
        "LFC_MANAGE_PERMISSIONS" : settings.LFC_MANAGE_PERMISSIONS,
        "LFC_MANAGE_SEO" : settings.LFC_MANAGE_SEO,
        "LANGUAGES_DICT" : LANGUAGES_DICT,
        "DEFAULT_LANGUAGE" : default_language,
        "CURRENT_LANGUAGE" : current_language,
        "IS_DEFAULT_LANGUAGE" : is_default_language,
        "LINK_LANGUAGE" : link_language, 
    }

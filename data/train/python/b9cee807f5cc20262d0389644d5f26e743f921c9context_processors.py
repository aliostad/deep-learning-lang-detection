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
        "PORTAL": lfc.utils.get_portal(),
        "LFC_MULTILANGUAGE": getattr(settings, "LFC_MULTILANGUAGE", True),
        "LFC_MANAGE_WORKFLOWS": getattr(settings, "LFC_MANAGE_WORKFLOWS", True),
        "LFC_MANAGE_APPLICATIONS": getattr(settings, "LFC_MANAGE_APPLICATIONS", True),
        "LFC_MANAGE_COMMENTS": getattr(settings, "LFC_MANAGE_COMMENTS", True),
        "LFC_MANAGE_USERS": getattr(settings, "LFC_MANAGE_USERS", True),
        "LFC_MANAGE_PERMISSIONS": getattr(settings, "LFC_MANAGE_PERMISSIONS", True),
        "LFC_MANAGE_SEO": getattr(settings, "LFC_MANAGE_SEO", True),
        "LFC_MANAGE_UTILS": getattr(settings, "LFC_MANAGE_UTILS", True),
        "LANGUAGES_DICT": LANGUAGES_DICT,
        "DEFAULT_LANGUAGE": default_language,
        "CURRENT_LANGUAGE": current_language,
        "IS_DEFAULT_LANGUAGE": is_default_language,
        "LINK_LANGUAGE": link_language,
    }

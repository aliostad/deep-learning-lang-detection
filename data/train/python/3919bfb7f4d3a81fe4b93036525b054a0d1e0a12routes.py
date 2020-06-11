# -*- coding: utf-8 -*-
from web_translator.controllers import po_edit, static

ROUTES = [
    {"url": "/assets/:filename#.+#", "method": "GET", "controller": static.get_file},
    {'url': '/', 'method': 'GET', 'controller': po_edit.panel},
    {'url': '/select_language', 'method': 'GET', 'controller': po_edit.select_language},
    {'url': '/translate/:lang_to', 'method':'GET', 'controller': po_edit.system_translate},
#    {'url': '/translate/:lang_to/:role', 'method': 'GET', 'controller': po_edit.system_translate_by_role},
    {'url': '/translate/:lang_to', 'method': 'POST', 'controller': po_edit.save_translation},
    {'url': '/filtered_translate/:hash', 'method':'GET', 'controller': po_edit.decode_url},
    {'url': '/generate_db', 'method': 'GET', 'controller': po_edit.generate_db},
    {'url': '/generate_po/:lang_to', 'method': 'GET', 'controller': po_edit.generate_po_from_db},
    {'url': '/generate_all_po', 'method': 'GET', 'controller': po_edit.generate_all_po},
    {'url': '/generate_link', 'method': 'POST', 'controller': po_edit.generate_link},
    {'url': '/deleted', 'method': 'GET', 'controller': po_edit.deleted},
    {'url': '/undelete', 'method': 'POST', 'controller': po_edit.undelete},
]

# import os
# import re
# import types
# import importlib
#
# api_names = []
#
# api_dir = os.path.dirname(__file__)
# if api_dir == '':
#     api_dir = '.'
#
# for filename in os.listdir(api_dir):
#     if not re.match(r"^.*.py$", filename) or filename == "__init__.py":
#         continue
#     api_module = importlib.import_module(__name__ + "." + filename[:-3])
#     for api_name in dir(api_module):
#         api_function = getattr(api_module, api_name)
#         if not isinstance(api_function, (type, types.FunctionType)):
#             continue
#         globals()[api_name] = api_function
#         api_names.append(api_name)
#
#
# __all__ = api_names
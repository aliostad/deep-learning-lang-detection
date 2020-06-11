import re
import sys

SAVE_KEY = 'save_dir'
LOAD_KEY = 'load_dir'

def load_usr_settings(settings = '.usr_settings.txt'):
   f = None
   settings_dict = {}
   
   try:
      f = file(settings)
   except IOError:
      settings_dict[SAVE_KEY] = '~'
      settings_dict[LOAD_KEY] = '~'
      return settings_dict
   
   stuff = f.read()
   regular_exp = ' = (.+)\n'
   
   match = re.search(SAVE_KEY + regular_exp, stuff)
   if match:
      print(match.group())
      settings_dict[SAVE_KEY] = match.group(1)
   else:
      settings_dict[SAVE_KEY] = '~'

   match = re.search(LOAD_KEY + regular_exp, stuff)
   if match:
      print(match.group())
      settings_dict[LOAD_KEY] = match.group(1)
   else:
      settings_dict[LOAD_KEY] = '~'
   
   return settings_dict

def get_dir_from_path(path):
   for i in range(len(path)-1, 0, -1):
      if path[i] == '/':
         return path[0:i]
   return '~'
   
def save_usr_settings(settings_dict, save_name = '.usr_settings.txt'):
   save_file = file(save_name, 'w')
   
   for item in settings_dict:
      save_file.write(item + ' = ' + settings_dict[item] + '\n')
   
   save_file.close()
   return
   

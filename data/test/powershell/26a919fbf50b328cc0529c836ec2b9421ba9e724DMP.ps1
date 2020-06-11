##########################
# This function creates a Django project and converts it into a Django-Mako-Plus
# project.
##########################
function dmp($folder) {

### Update the Value of this variable to your django-admin.py file.
$django_admin = "C:\Users\Tyler\AppData\Local\scoop\apps\python\3.5.1\Lib\site-packages\django\bin\django-admin.py"

python $django_admin startproject $folder
cd $folder
python manage.py migrate

$settings = "settings.py"
$urls = "urls.py"

cd $folder

Add-Content $settings "STATICFILES_DIRS = (
 # SECURITY WARNING: this next line must be commented out at deployment
 BASE_DIR,  
)
STATIC_ROOT = os.path.join(BASE_DIR, 'static')


DEBUG_PROPAGATE_EXCEPTIONS = DEBUG  # never set this True on a live site
LOGGING = {
 'version': 1,
 'disable_existing_loggers': True,
 'formatters': {
     'simple': {
         'format': '%(levelname)s %(message)s'
     },
 },
 'handlers': {
     'console':{
         'level':'DEBUG',
         'class':'logging.StreamHandler',
         'formatter': 'simple'
     },
 },
 'loggers': {
     'django_mako_plus': {
         'handlers': ['console'],
         'level': 'DEBUG',
         'propagate': False,
     },
 },
}

###############################################################
###   Specific settings for the Django-Mako-Plus app

DJANGO_MAKO_PLUS = {
 # identifies where the Mako template cache will be stored, relative to each app
 'TEMPLATES_CACHE_DIR': 'cached_templates',

 # the default app and page to render in Mako when the url is too short
 'DEFAULT_PAGE': 'index',
 'DEFAULT_APP': 'homepage',

 # the default encoding of template files
 'DEFAULT_TEMPLATE_ENCODING': 'utf-8',

 # these are included in every template by default - if you put your most-used libraries here, you won't have to import them exlicitly in templates
 'DEFAULT_TEMPLATE_IMPORTS': [
   'import os, os.path, re, json',
 ],

 # see the DMP online tutorial for information about this setting
 'URL_START_INDEX': 0,

 # whether to send the custom DMP signals -- set to False for a slight speed-up in router processing
 # determines whether DMP will send its custom signals during the process
 'SIGNALS': True,

 # whether to minify using rjsmin, rcssmin during 1) collection of static files, and 2) on the fly as .jsm and .cssm files are rendered
 # rjsmin and rcssmin are fast enough that doing it on the fly can be done without slowing requests down
 'MINIFY_JS_CSS': True,

 # see the DMP online tutorial for information about this setting
 'TEMPLATES_DIRS': [ 
   # '/var/somewhere/templates/',
 ],
}

###  End of settings for the Django-Mako-Plus
################################################################"

$setting_content = Get-Content $settings
$setting_content = $setting_content.replace("'django.contrib.staticfiles',","'django.contrib.staticfiles',
    'django_mako_plus.controller',")

$setting_content = $setting_content.replace("'django.middleware.clickjacking.XFrameOptionsMiddleware',","#'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django_mako_plus.controller.router.RequestInitMiddleware',")

$setting_content = $setting_content.replace("'django.middleware.csrf.CsrfViewMiddleware',","#'django.middleware.csrf.CsrfViewMiddleware',")
$setting_content | out-file $settings -Encoding Ascii

$urls_content = Get-Content $urls
$urls_content = $urls_content.replace("url(r'^admin/', admin.site.urls),", "url(r'^admin/', admin.site.urls),
# the django_mako_plus controller handles every request - this line is the glue that connects Mako to Django
      url(r'^.*$', 'django_mako_plus.controller.router.route_request' ),")

$urls_content | out-file $urls -Encoding Ascii

cd ../
python manage.py dmp_startapp homepage
cd $folder

$settings = "settings.py"
$setting_content = Get-Content $settings
$setting_content = $setting_content.replace("'django_mako_plus.controller',","'django_mako_plus.controller',
    'homepage',")
$setting_content | out-file $settings -Encoding Ascii

cd ../
write-host "
Project Created!!!!
To Run the server, run 'python manage.py runserver'
"
}
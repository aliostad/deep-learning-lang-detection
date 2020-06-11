from fabric.api import local

# Start the development server - $ fab run
def run():
    local("dev_appserver.py .")

# Upload the app to App Engine - $ fab upload
def upload():
    local("appcfg.py --oauth2 update .")

# Save to github - $ fab save:m="First commit"
def save(m="Auto-Update"):
    """ save the to github """
    local("git add .")
    local("git commit -a -m '{0}'".format(m))
    local("git push")

# Save to GitHub and upload to App Engine - $ fab update:m="First commit"
def update(m="Auto-Update"):
    save(m)
    local("appcfg.py --oauth2 update .")
from fabric.api import env, run

# def _get_manage():
#     return "/webapps/todolists/src/"

# def _get_base_folder(host):
#     return '/webapps/' + str(host)

def _get_manage_dot_py(host):
    return '/webapps/todolists/virtualenv/bin/python /webapps/todolists/src/manage.py'

def reset_database():
    run('/webapps/todolists/virtualenv/bin/python /webapps/todolists/src/manage.py flush --noinput')

def create_session_on_server(email):
    print "email", email
    session_key = run('/webapps/todolists/virtualenv/bin/python /webapps/todolists/src/manage.py create_session {email}'.format(
        email=email,
        ))
    print(session_key)
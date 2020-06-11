from fabric.api import env, run


def _get_base_folder(host):
	return '~/django_sites/superlists' # hardcoded


def _get_manage_dot_py(host):
	return '/usr/bin/python {path}/source/manage.py'.format(
		path=_get_base_folder(host)
	)


def reset_database():
	run('{manage_py} flush --noinput'.format(
		#manage_py=_get_manage_dot_py(env.host)
		manage_py=_get_manage_dot_py('webadmin@192.168.0.246')
	))


def create_session_on_server(email):
	session_key = run('{manage_py} create_session {email}'.format(
		manage_py=_get_manage_dot_py(env.host),
		email=email,
	))
	print(session_key)

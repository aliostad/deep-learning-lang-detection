from fabric.api import env, put, run


def _get_base_folder(host):
    return '~/sites/' + host

def _get_manage_dot_py(host):
    return '{path}/virtualenv/bin/python {path}/source/manage.py'.format(
        path=_get_base_folder(host)
    )

def reset_database():
    run('{manage_py} flush --noinput'.format(
        manage_py=_get_manage_dot_py(env.host)
    ))

def create_session_on_server(email, password):

    cmd_string = (
        "{manage_py} create_session_cookie "
        "--email={email} --password={password}"
    )

    serialized_cookie= run(cmd_string.format(
        manage_py=_get_manage_dot_py(env.host),
        email=email,
        password=password,
    ))

    print(serialized_cookie)

def create_user(email, password):
    cmd_string = (
        "{manage_py} create_user "
        "--email={email} --password={password}"
    )

    run(cmd_string.format(
        manage_py=_get_manage_dot_py(env.host),
        email=email,
        password=password,
    ))

def send_fixture_file(filepath):
    # mkdir if doesn't exist
    fixtures_path = (
        _get_base_folder(env.host) + '/source/functional_tests/fixtures'
    )

    run('mkdir -p %s' % (fixtures_path,))

    # send the fixture file
    server_files_list = put(filepath, fixtures_path)

    # `put` returns a list of server file paths, so we need to unpack it
    # to get the complete file path on server.
    fixture_file = server_files_list[0]

    # run manage loaddata on fixture file
    run("{manage_py} loaddata {fixture_file}".format(
        manage_py=_get_manage_dot_py(env.host),
        fixture_file=fixture_file,
    ))

    # rm fixture file
    run("rm {fixture_file}".format(
        fixture_file=fixture_file,
    ))

def create_media_file(file_name):
    # create/get media folder
    media_folder = _get_base_folder(env.host) + '/media'
    run('mkdir -p {media_folder}'.format(
        media_folder=media_folder
    ))

    # create a dummy file
    run('echo "this is a test" > {media_folder}/{file_name}'.format(
        media_folder=media_folder,
        file_name=file_name,
    ))

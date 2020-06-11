# coding=utf-8
from fabric.api import env, run


COMMAND_COLLECTSTATIC = 'collectstatic'
COMMAND_SYNCDB = 'syncdb'
COMMAND_MIGRATE = 'migrate'

_default_command = '{python} {manage} {command}'
_commands_list = {
    COMMAND_COLLECTSTATIC: 'yes yes | {python} {manage} {command}',
    COMMAND_MIGRATE: '{python} {manage} {command} --noinput',
}


def django_commands(os_environment=None):
    for command in env.django_commands:
        _django_command(command, os_environment)


def _django_command(command, os_environment):
    command_to_run = _commands_list.get(command, _default_command)
    command_to_run = command_to_run.format(
        python=env.server_python,
        manage=env.server_manage,
        command=command
    )

    if os_environment is None:
        run(command_to_run)
        return

    prefix = ' '.join([
        '{}={}'.format(k, v)
        for k, v in os_environment.items()
    ])

    run('{} {}'.format(prefix, command_to_run))



resource_id = "rabbitmq-1"

_install_script = """
[
  { "id": "rabbitmq-1",
    "key": {"name": "rabbitmq", "version": "2.4"},
    "config_port": {
      "host": "${hostname}",
      "port": "5672"
    },
    "input_ports": {
      "host": {
        "cpu_arch": "x86_64",
        "genforma_home": "${deployment_home}",
        "hostname": "${hostname}",
        "log_directory": "${deployment_home}/log",
        "os_type": "mac-osx",
        "os_user_name": "${username}",
        "private_ip": null,
        "sudo_password": "GenForma/${username}/sudo_password"
      }
    },
    "output_ports": {
      "broker": {
        "BROKER_HOST": "${hostname}",
        "BROKER_PORT": "5672",
        "broker": "rabbitmqctl"
      }
    },
    "inside": {
      "id": "${hostname}",
      "key": {"name": "mac-osx", "version": "10.6"},
      "port_mapping": {
        "host": "host"
      }
    }
  }
]
"""

def get_install_script():
    return _install_script

def get_password_data():
    return {}

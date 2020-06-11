{
  'targets': [
    {
      'target_name': 'permission_broker_proxies',
      'type': 'none',
      'actions': [
        {
          'action_name': 'generate-permission_broker_dbus-proxies',
          'variables': {
            'dbus_service_config': 'dbus_bindings/dbus-service-config.json',
            'proxy_output_file': 'include/permission_broker/dbus-proxies.h',
            'mock_output_file': 'include/permission_broker/dbus-proxy-mocks.h',
            'proxy_path_in_mocks': 'permission_broker/dbus-proxies.h',
          },
          'sources': [
            'dbus_bindings/org.chromium.PermissionBroker.xml',
          ],
          'includes': ['../common-mk/generate-dbus-proxies.gypi'],
        },
      ],
    },
  ],
}

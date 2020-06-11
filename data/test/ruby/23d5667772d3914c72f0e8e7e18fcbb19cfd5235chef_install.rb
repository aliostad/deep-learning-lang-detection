repositories = value_for_platform(node['yum-scl']['repos'])
if repositories.nil?
  raise 'No softwarecollections repository is available '\
        "for #{node['platform']}-#{node['platform_version']}"
end
# rubocop:disable Metrics/BlockLength
repositories.each_pair do |repository_name, repository_spec|
  yum_repository repository_name do
    baseurl repository_spec['baseurl'] unless repository_spec['baseurl'].nil?
    cost repository_spec['cost'] unless repository_spec['cost'].nil?
    description repository_spec['description'] unless repository_spec['description'].nil?
    enabled repository_spec['enabled'] unless repository_spec['enabled'].nil?
    enablegroups repository_spec['enablegroups'] unless repository_spec['enablegroups'].nil?
    exclude repository_spec['exclude'] unless repository_spec['exclude'].nil?
    failovermethod repository_spec['failovermethod'] unless repository_spec['failovermethod'].nil?
    fastestmirror_enabled repository_spec['fastestmirror_enabled'] unless repository_spec['fastestmirror_enabled'].nil?
    gpgcheck repository_spec['gpgcheck'] unless repository_spec['gpgcheck'].nil?
    gpgkey "file:///etc/pki/rpm-gpg/#{repository_spec['gpgkey']}" unless repository_spec['gpgkey'].nil?
    http_caching repository_spec['http_caching'] unless repository_spec['http_caching'].nil?
    include_config repository_spec['include_config'] unless repository_spec['include_config'].nil?
    includepkgs repository_spec['includepkgs'] unless repository_spec['includepkgs'].nil?
    keepalive repository_spec['keepalive'] unless repository_spec['keepalive'].nil?
    make_cache repository_spec['make_cache'] unless repository_spec['make_cache'].nil?
    max_retries repository_spec['max_retries'] unless repository_spec['max_retries'].nil?
    metadata_expire repository_spec['metadata_expire'] unless repository_spec['metadata_expire'].nil?
    mirror_expire repository_spec['mirror_expire'] unless repository_spec['mirror_expire'].nil?
    mirrorlist repository_spec['mirrorlist'] unless repository_spec['mirrorlist'].nil?
    mirrorlist_expire repository_spec['mirrorlist_expire'] unless repository_spec['mirrorlist_expire'].nil?
    password repository_spec['password'] unless repository_spec['password'].nil?
    priority repository_spec['priority'] unless repository_spec['priority'].nil?
    proxy repository_spec['proxy'] unless repository_spec['proxy'].nil?
    proxy_username repository_spec['proxy_username'] unless repository_spec['proxy_username'].nil?
    proxy_password repository_spec['proxy_password'] unless repository_spec['proxy_password'].nil?
    report_instanceid repository_spec['report_instanceid'] unless repository_spec['report_instanceid'].nil?
    repositoryid repository_spec['repositoryid'] unless repository_spec['repositoryid'].nil?
    skip_if_unavailable repository_spec['skip_if_unavailable'] unless repository_spec['skip_if_unavailable'].nil?
    source repository_spec['source'] unless repository_spec['source'].nil?
    sslcacert repository_spec['sslcacert'] unless repository_spec['sslcacert'].nil?
    sslclientcert repository_spec['sslclientcert'] unless repository_spec['sslclientcert'].nil?
    sslclientkey repository_spec['sslclientkey'] unless repository_spec['sslclientkey'].nil?
    sslverify repository_spec['sslverify'] unless repository_spec['sslverify'].nil?
    timeout repository_spec['timeout'] unless repository_spec['timeout'].nil?
    username repository_spec['username'] unless repository_spec['username'].nil?
  end
  cookbook_file "#{repository_name}-gpgkey" do
    path "/etc/pki/rpm-gpg/#{repository_spec['gpgkey']}"
    source repository_spec['gpgkey']
    action :create
    not_if { repository_spec['gpgkey'].nil? }
  end
end
# rubocop:enable Metrics/BlockLength

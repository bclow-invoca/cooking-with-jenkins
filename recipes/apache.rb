#
# jenkins_ci::apache
#
include_recipe 'apache2::default'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'

#
# Install SSL certs and keys
#
bag_item = node['jenkins_ci']['apache']['encrypted_item']
data_bag = node['jenkins_ci']['apache']['app_data_bag']
secret_file = Chef::EncryptedDataBagItem.load_secret(node['jenkins_ci']['secrets_key_path'])
jenkins_sec = Chef::EncryptedDataBagItem.load(data_bag, bag_item, secret_file)

directory node['jenkins_ci']['apache']['ssl_cert_dir'] do
  owner 'root'
  group node['apache']['root_group']
  mode 0o0755
end

file node['jenkins_ci']['apache']['ssl_cert_path'] do
  owner 'root'
  group node['apache']['root_group']
  mode 0o0600
  content jenkins_sec['ssl']['cert']
  notifies :restart, "service[apache2]", :delayed
end

file node['jenkins_ci']['apache']['ssl_key_path'] do
  owner 'root'
  group node['apache']['root_group']
  mode 0o0600
  content jenkins_sec['ssl']['key']
  notifies :restart, "service[apache2]", :delayed
end

#
# Install vhosts for apache application proxy
#
%w(
  jenkins-ci
).each do |site|
  template "#{node['apache']['dir']}/sites-available/#{site}.conf" do
    owner 'root'
    group node['apache']['root_group']
    mode 0o0644
    source "#{site}.conf.erb"
  end
  apache_site site
end

apache_site '000-default' do
  enable false
end

file "#{node['apache']['dir']}/conf-available/fqdn.conf" do
  owner 'root'
  group node['apache']['root_group']
  mode 0o0644
  content "ServerName #{node['fqdn']}"
end

apache_config 'fqdn'

include_recipe 'apache2::logrotate'

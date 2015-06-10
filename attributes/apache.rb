#
# apache2 configuration
#
default['apache']['contact']                      = 'jenkins@imaginaryexample.com'
default['apache']['listen_ports']                 = ['80', '443']
default['jenkins_ci']['apache']['ssl_cert_dir']   = '/etc/apache2/ssl'
default['jenkins_ci']['apache']['ssl_cert_path']  = "#{node['jenkins_ci']['apache']['ssl_cert_dir']}/jenkins_cert.pem"
default['jenkins_ci']['apache']['ssl_key_path']   = "#{node['jenkins_ci']['apache']['ssl_cert_dir']}/jenkins_key.pem"
default['jenkins_ci']['apache']['encrypted_item'] = node['jenkins_ci']['encrypted_item']
default['jenkins_ci']['apache']['app_data_bag']   = node['jenkins_ci']['app_data_bag']

#
# Cookbook Name:: db_base
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
gem_package "mysql" do
  action :install
end

# create connection info as an external ruby hash
mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

# create a mysql database
mysql_database 'fluffbox' do
  connection mysql_connection_info
  action :create
end

web_server = search(:node,"name:web")
private_ip = "#{web_server[0][:rackspace][:private_ip]}"
puts private_ip

mysql_database_user 'fluffbox' do
  connection mysql_connection_info
  password 'fluffbox'
  database_name 'fluffbox'
  host "#{private_ip}"
  action :grant
end
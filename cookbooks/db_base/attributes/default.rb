node.set['mysql']['bind_address'] = node[:rackspace][:private_ip]
node.set['mysql']['server_root_password'] = 'sup3rs3cur3'
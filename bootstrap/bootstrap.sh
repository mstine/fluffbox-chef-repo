#!/bin/sh

#Bootstrap Servers
knife rackspace server create -S chefweb -N web -I 112 -f 2
knife rackspace server create -S chefdb -N db -I 112 -f 2

#Setup web run_list
knife node run_list add web 'recipe[apt]'
knife node run_list add web 'recipe[java]'
knife node run_list add web 'recipe[tomcat]'
knife node run_list add web 'recipe[web_base]'
knife node run_list add web 'recipe[mysql::client]'

#Setup db run_list
knife node run_list add db 'recipe[apt]'
knife node run_list add db 'recipe[mysql::server]'
knife node run_list add db 'recipe[database]'
knife node run_list add db 'recipe[db_base]'

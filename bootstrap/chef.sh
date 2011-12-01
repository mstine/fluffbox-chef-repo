#!/bin/sh

#Setup SSH Keys
cap web_server setup_key -s password=$1
cap db_server setup_key -s password=$2

#Run chef-client
cap web_server chef_run
cap db_server chef_run
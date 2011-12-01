require 'rubygems'
require 'fog'

credentials = {
  :provider           => 'Rackspace',
  :rackspace_username => ENV['RACKSPACE_USERNAME'],
  :rackspace_api_key  => ENV['RACKSPACE_API_KEY']
}

puts "Starting Fluffbox DNS bootstrap..."

connection = Fog::Compute.new(credentials)
dns = Fog::DNS.new(credentials)

#puts "Creating DNS zone for fluffbox.info"
#zone = dns.zones.create(
#  :domain => 'fluffbox.info',
#  :email  => 'matt.stine@gmail.com'
#)
puts "Finding DNS zone for fluffbox.info"

zone = nil
dns.zones.all.each do |existing_zone|
  zone = existing_zone
end

connection.servers.all.each do |server|
  if server.name =~ /chef(.*)/
      
    if server.name == "chefweb"
      puts "Creating primary DNS record and CNAME for web"
    
      record = zone.records.create(
        :value   => server.public_ip_address,
        :name => "chef-www.fluffbox.info",
        :type => 'A'
      )
      
    else
      puts "Creating DNS record for #{server.name}"
    
      record = zone.records.create(
        :value   => server.public_ip_address,
        :name => "#{server.name}.fluffbox.info",
        :type => 'A'
      )
        
    end
  end 
    
  puts "Done creating DNS record(s) for #{server.name}"
end

puts "Fluffbox DNS bootstrap finished!"
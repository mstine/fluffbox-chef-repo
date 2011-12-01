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

puts "Creating DNS zone for fluffbox.info"
zone = dns.zones.create(
  :domain => 'fluffbox.info',
  :email  => 'matt.stine@gmail.com'
)

connection.servers.all.each do |server|  
  if server.name == "web"
    puts "Creating primary DNS record and CNAME for web"
    
    record = zone.records.create(
      :value   => server.public_ip_address,
      :name => "fluffbox.info",
      :type => 'A'
    )
        
    record = zone.records.create(
      :value   => "fluffbox.info",
      :name => "www.fluffbox.info",
      :type => 'CNAME'
    )
      
  else
    puts "Creating DNS record for #{server.name}"
    
    record = zone.records.create(
      :value   => server.public_ip_address,
      :name => "#{server.name}.fluffbox.info",
      :type => 'A'
    )
        
  end
    
  puts "Done creating DNS record(s) for #{server.name}"
end

puts "Fluffbox DNS bootstrap finished!"
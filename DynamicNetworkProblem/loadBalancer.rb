class LoadBalancer
  attr_accessor :servers

  def initialize(servers_max_load)
    @servers = servers_max_load.map { |max_load| Server.new(max_load) }
  end

  def print_load
    @servers.each do |server, i|
      puts "Server #{i}: #{server.current_load} out of #{server.max_load}"
    end
  end
end
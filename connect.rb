require 'socket'
require 'json'

class Connector
	
	@hostname = 'localhost'
	@port = 6789
	
	def Connector.get_user_matches(id)
		s = TCPSocket.open(@hostname, @port)
		a = id.to_s
		s.puts(a)
		json = s.gets.chomp
		json = JSON.parse(json)
		matches = {}
		json.each do |key, value|
			matches[key.to_i] = value.to_f
		end
		s.close
		return matches
	end
	
	def Connector.reinitialize_algorithm_db
		s = TCPSocket.open(@hostname, @port)
		a = "restartdb"
		s.puts(a)
		
		a = s.gets.chomp
	end
end

puts Connector.get_user_matches(12)
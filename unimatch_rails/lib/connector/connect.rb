module Connect
    class Connector
        
        @hostname = 'unimatch.ddns.net'
        @port = 6789
        
        def Connector.get_user_matches
            s = TCPSocket.open(@hostname, @port)
            a = 2.to_s
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
    end
end
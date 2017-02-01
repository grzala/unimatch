module Connect
    class Connector
        
        @config = YAML.load_file(__dir__ + '/config.yaml')
        
        @hostname = @config['hostname'] 
        @port = @config['port']
        
        @usermatchmsg = @config['usermatchmsg']
        @societymatchmsg = @config['societymatchmsg']
        
        def Connector.get_user_matches(id)
            begin
                s = TCPSocket.open(@hostname, @port)
                s.puts(@usermatchmsg + " " + id.to_s)
                json = s.gets.chomp
                json = JSON.parse(json)
                matches = {}
                json.each do |key, value|
                	matches[key.to_i] = value.to_f
                end
                s.close
                return matches
            rescue SocketError
                return {}
            end
        end        
        
        def Connector.get_society_matches(id)
            begin
                s = TCPSocket.open(@hostname, @port)
                s.puts(@societymatchmsg + " " + id.to_s)
                json = s.gets.chomp
                json = JSON.parse(json)
                matches = {}
                json.each do |key, value|
                	matches[key.to_i] = value.to_f
                end
                s.close
                return matches
            rescue SocketError
                return {}
            end
        end
    end
end
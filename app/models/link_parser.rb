class LinkParser
   
    def self.get_playlist_id(playlist_link)
        uri = URI.parse(playlist_link)
        args = CGI.parse(uri.query)
        args["list"]
    end
    
end
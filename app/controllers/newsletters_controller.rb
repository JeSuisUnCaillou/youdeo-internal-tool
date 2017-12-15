class NewslettersController < ApplicationController
   
    def index
       
    end
    
    def create
        playlist_id = LinkParser.get_playlist_id(newsletter_params[:q])
        redirect_to newsletter_path(playlist_id)
    end
    
    def show 
        youtube_api = YoutubeApiConnector.new
        @playlist_id = playlist_params[:id]
        @playlist_items = youtube_api.get_playlist_items(@playlist_id, 10)
        channels_ids = @playlist_items.map{ |item| item["snippet"]["channelId"]}.join(",")
        @channels = youtube_api.get_channel_infos(channels_ids)
    end
    
    private
    
        def newsletter_params
           params.permit(:q) 
        end
        
        def playlist_params
           params.permit(:id) 
        end
end
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
        videos_ids = @playlist_items.map{ |item| item["contentDetails"]["videoId"] }
        videos = youtube_api.get_videos_infos(videos_ids)
        
        channel_ids = videos.map{ |video| video["snippet"]["channelId"] }
        
        @channels = youtube_api.get_channels_infos(channel_ids)
        
        # Add channel infos to each video
        @playlist_items.each_with_index{ |item, index| item["channel"] = @channels[index] }
    end
    
    private
    
        def newsletter_params
           params.permit(:q) 
        end
        
        def playlist_params
           params.permit(:id) 
        end
end
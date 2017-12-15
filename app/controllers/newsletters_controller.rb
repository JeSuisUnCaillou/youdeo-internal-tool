class NewslettersController < ApplicationController
   
    def index
       
    end
    
    def create
        playlist_id = LinkParser.get_playlist_id(newsletter_params[:q])
        
        redirect_to newsletter_path(playlist_id)
    end
    
    def show 
        youtube_api = YoutubeApiConnector.new
        @playlist_items = youtube_api.get_playlist_items(playlist_params[:id], 10)
    end
    
    private
    
        def newsletter_params
           params.permit(:q) 
        end
        
        def playlist_params
           params.permit(:id) 
        end
end
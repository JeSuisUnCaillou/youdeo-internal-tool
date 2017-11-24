class ChannelsController < ApplicationController
    def search_channels
        youtube_api = YoutubeApiConnector.new
        @search_input = channels_params["search_input"]
        if @search_input.present?
            @channels = youtube_api.search_channels(@search_input)
        else
           @channels = [] 
        end
    end
    
    def show
        
    end
    
    private
    
        def channels_params
           params.permit("search_input")
        end
end
class ChannelsController < ApplicationController
    before_action :set_channel_id, only: [:show]
    
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
        youtube_api = YoutubeApiConnector.new
        @channel = youtube_api.get_channel_infos(@channel_id)
    end
    
    private
    
        def set_channel_id
           @channel_id = params["id"] 
        end
    
        def channels_params
           params.permit("search_input")
        end
end
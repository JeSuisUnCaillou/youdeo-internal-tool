class ChannelsController < ApplicationController
    before_action :set_channel_id, only: [:show]
    
    def search_channels
        youtube_api = YoutubeApiConnector.new
        @search_input = channels_params["q"]
        if @search_input.present?
            @channels = youtube_api.search_channels(@search_input, 50)
        else
           @channels = [] 
        end
    end
    
    def show
        youtube_api = YoutubeApiConnector.new
        @channel = youtube_api.get_channel_infos(@channel_id)
        @playlist_items = youtube_api.get_playlist_items(@channel, 25)
        @videos_stats = youtube_api.get_videos_stats(@playlist_items)
        @last_views_count = @videos_stats.map{ |stats| Integer(stats["statistics"]["viewCount"] || 0) }.sum
        @last_likes_count = @videos_stats.map{ |stats| Integer(stats["statistics"]["likeCount"] || 0) }.sum
        @last_comms_count = @videos_stats.map{ |stats| Integer(stats["statistics"]["commentCount"] || 0) }.sum
    end
    
    private
    
        def set_channel_id
           @channel_id = params["id"] 
        end
    
        def channels_params
           params.permit("q")
        end
end
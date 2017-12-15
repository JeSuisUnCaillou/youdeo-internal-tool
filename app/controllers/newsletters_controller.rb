class NewslettersController < ApplicationController
   
    def index
       
    end
    
    def create
        @playlist_id = LinkParser.get_playlist_id(newsletter_params[:q])
        youtube_api = YoutubeApiConnector.new
        ap @playlist_id
        @playlist_items = youtube_api.get_playlist_items(@playlist_id, 10)
        videos_ids = @playlist_items.map{ |item| item["contentDetails"]["videoId"] }
        videos = youtube_api.get_videos_infos(videos_ids)
        channel_ids = videos.map{ |video| video["snippet"]["channelId"] }
        @channels = youtube_api.get_channels_infos(channel_ids)
        
        # Add channel infos to each video
        @playlist_items.each_with_index{ |item, index| item["channel"] = @channels[index] }
        
        @playlist_items.each{ |item|
            NewsletterVideo.create(
                playlist_id: @playlist_id,
                video_id: item["snippet"]["resourceId"]["videoId"],
                video_title: item["snippet"]["title"],
                video_thumbnail: item["snippet"]["thumbnails"]["medium"]["url"],
                channel_title: item["channel"]["snippet"]["title"],
                channel_desc: item["channel"]["snippet"]["description"],
                new_title: item["channel"]["snippet"]["title"] + " : " + item["snippet"]["title"],
                new_desc: item["channel"]["snippet"]["description"]
            ) unless NewsletterVideo.find_by(video_id: item["snippet"]["resourceId"]["videoId"])
        }
        redirect_to newsletter_path(@playlist_id)
    end
    
    def show
        @playlist_id = playlist_params[:id]
        @newsletter_videos = NewsletterVideo.where(playlist_id: @playlist_id)
    end
    
    def edit
        @playlist_id = playlist_params[:id]
        @newsletter_videos = NewsletterVideo.where(playlist_id: @playlist_id)
    end
    
    private
    
        def newsletter_params
           params.permit(:q) 
        end
        
        def playlist_params
           params.permit(:id) 
        end
end
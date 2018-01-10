require 'csv'

desc "get the stats of the youtube channels shared by the youdeo newsletter"
task :yt_stats, [:filename] => [:environment] do |t, args|
    channel_ids = []
    
    CSV.foreach(File.dirname(__FILE__) + "/" + args[:filename]) do |row|
        channel_ids.push(extract_id(row.first))
    end
    
    File.open(File.dirname(__FILE__) + "/" + "channels_ids.csv", "w") { |file| 
        file.write(channel_ids.join("\n"))
    }
end

def extract_id(channel_link)
    youtube_api = YoutubeApiConnector.new
    
    match_channel = /channel\/(.+?)(\/.+)?$/.match(channel_link)
    match_video = /watch\?v=(.+)$/.match(channel_link)
    match_user = /user\/(.+?)(\/.+)?$/.match(channel_link)
    
    if match_channel
       match_channel[1]
       
    elsif match_video
        video_id = match_video[1]
        items = youtube_api.get_videos_infos([video_id])
        video = items.first
        if(video)
            video["snippet"]["channelId"]
        else
            "/!\\" + channel_link
        end
    elsif match_user
        username = match_user[1]
        channel = youtube_api.get_channel_infos_by_username(username)
        if(channel)
           channel["id"]
        else
            "/!\\" + channel_link
        end
    else
        "not matched : " + channel_link
    end
end
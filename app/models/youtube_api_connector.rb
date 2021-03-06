require 'net/http'

class YoutubeApiConnector
    API_KEY = ENV["GOOGLE_API_KEY"]
    OAUTH_CLIENT_ID = ENV["GOOGLE_CLIENT_ID"]
    OAUTH_CLIENT_SECRET = ENV["GOOGLE_CLIENT_SECRET"]
    
    def initialize()
        initialize_secret_keys()
    end
    
    def search_channels(search_str, max_results)
        url = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=channel&q=#{URI::encode(search_str)}"
        items = get_resource_first_page(url, max_results)
        return items
    end
    
    def get_channel_infos(channel_id)
        url = "https://www.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=#{channel_id}"
        items = get_resource_first_page(url, 1).first
        return items
    end
    
    def get_playlist_items(channel, max_results)
        playlist_id = channel["contentDetails"]["relatedPlaylists"]["uploads"]
        url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{playlist_id}"
        items = get_resource_first_page(url, max_results)
        return items
    end
    
    def get_videos_stats(playlist_items)
        videos_ids = playlist_items.map{ |playlist_item| playlist_item["contentDetails"]["videoId"] }.join(",")
        url = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=#{videos_ids}"
        items = get_resource_first_page(url, playlist_items.count)
        return items
    end

    private
    
        def get_resource_all_pages(url)
            get_resource_page(url, nil)
        end
        
        def get_resource_first_page(url, max_results)
            full_url = URI.parse("#{url}&maxResults=#{max_results}&key=#{API_KEY}")
            res = Net::HTTP.get(full_url)
            json = ActiveSupport::JSON.decode(res)
            json["items"]
        end
        
        def get_resource_page(url, max_results, page_token)
            full_url = URI.parse("#{url}&maxResults=#{max_results}&key=#{API_KEY}&pageToken=#{page_token}")
            res = Net::HTTP.get(full_url)
            json = ActiveSupport::JSON.decode(res)
            items = json["items"]
            items = items + get_resource_page(url, json["nextPageToken"]) if json["nextPageToken"].present?
            
            return items
        end
    
        def initialize_secret_keys
            if(API_KEY.blank?)
                raise LoadError, "Can't find environment variable 'GOOGLE_API_KEY'"
            end
            
            if(OAUTH_CLIENT_ID.blank?)
                raise LoadError, "Can't find environment variable 'GOOGLE_CLIENT_ID'"
            end
            
            if(OAUTH_CLIENT_SECRET.blank?)
                raise LoadError, "Can't find environment variable 'GOOGLE_CLIENT_SECRET'"
            end
        end
end
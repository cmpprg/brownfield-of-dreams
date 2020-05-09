class YoutubeService

  def playlist_videos_info(playlist_id)
    total_results = []
    params = { part: 'snippet', playlistId: playlist_id,
               maxResults: '50', pageToken: "" }
    gather_videos_info(params, total_results)
    total_results
  end

  def playlist_info(playlist_id)
    params = { part: 'snippet', id: playlist_id }

    get_json('youtube/v3/playlists', params)
  end

  def video_info(id)
    params = { part: 'snippet,contentDetails,statistics', id: id }

    get_json('youtube/v3/videos', params)
  end

  private

  def get_json(url, params)
    response = conn.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://www.googleapis.com') do |f|
      f.adapter Faraday.default_adapter
      f.params[:key] = ENV['YOUTUBE_API_KEY']
    end
  end

  def add_to_total(new_results, total_results)
    new_results.each do |result|
      total_results << result unless result[:snippet][:title] == 'Private video'
    end
  end

  def gather_videos_info(params, total_results)
    loop do
      response = get_json('youtube/v3/playlistItems', params)
      add_to_total(response[:items], total_results)
      break if response[:nextPageToken] == nil
      params[:pageToken] = response[:nextPageToken]
    end
  end
end

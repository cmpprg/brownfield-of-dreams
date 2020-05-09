class Admin::ImportPlaylistController < Admin::BaseController
  def new
  end

  def create
    tutorial = Tutorial.create(tutorial_params)
    videos_params.each { |video| tutorial.videos.create(video) }
    flash[:import_success] = "Successfully created tutorial. <a href=/tutorials/#{tutorial.id}>View it here</a>."
    redirect_to admin_dashboard_path
  end

  private

  def tutorial_params
    tutorial_info ||= YoutubeService.new.playlist_info(params[:playlist_id])
    {
      playlist_id: tutorial_info[:items][0][:id],
      title: tutorial_info[:items][0][:snippet][:title],
      description: tutorial_info[:items][0][:snippet][:description],
      thumbnail: tutorial_info[:items][0][:snippet][:thumbnails][:default][:url]
    }
  end

  def videos_params
    videos_info ||= YoutubeService.new.playlist_videos_info(params[:playlist_id])
    videos_info.map do |video|
      {
        title: video[:snippet][:title],
        description: video[:snippet][:description],
        video_id: video[:snippet][:resourceId][:videoId],
        thumbnail: video[:snippet][:thumbnails][:default][:url],
        position: video[:snippet][:position]
      }
    end
  end

end

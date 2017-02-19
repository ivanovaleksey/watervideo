module VideosHelper
  def thumbnail_url(video)
    video.thumbnail.url
  end
end

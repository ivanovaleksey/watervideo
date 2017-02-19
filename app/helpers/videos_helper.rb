module VideosHelper
  def thumbnail_url(video)
    video.thumbnail.url
  end

  def duration(video)
    Time.at(video.duration).utc.strftime('%H:%M:%S')
  end
end

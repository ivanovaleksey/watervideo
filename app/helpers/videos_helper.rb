module VideosHelper
  def duration(video)
    Time.at(video.duration).utc.strftime('%H:%M:%S')
  end

  def filename(video)
    video.file.file.filename
  end

  def thumbnail_url(video)
    video.thumbnail.url
  end
end
